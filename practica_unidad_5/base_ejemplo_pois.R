### Dataset para la práctica de regresión Poisson
### Autora: Tamara Ricardo
### Fecha modificación:
# 2025-09-17 10:34:19

# Cargar paquetes ----------------------------------------------------------
pacman::p_load(
  rio,
  epikit,
  skimr,
  janitor,
  tidyverse
)

# Cargar datos -------------------------------------------------------------
## Casos leptospirosis
casos_raw <- import("raw/SIVILA_casos.csv")

## Población Santa Fe
pob_raw <- import("raw/_tmp_5916981.xlsX", range = "B11:C485")


## Explorar datos
tabyl(casos_raw$Resultado)

tabyl(casos_raw$Sexo)

summary(casos_raw$Edad.diagnostico)

tabyl(casos_raw$Provincia.R)

tabyl(casos_raw$Depto.R)

tabyl(casos_raw$Depto.M)

# Limpiar datos leptospirosis --------------------------------------------
casos <- casos_raw |>
  # Estandarizar nombres de columnas
  clean_names() |>
  rename(nom_depto = depto_r) |>

  # Filtrar casos confirmados y probables
  filter(str_detect(res, "CONF|PROB")) |>

  # Filtrar datos ausentes departamento de residencia
  filter(!is.na(nom_depto)) |>

  # Filtrar datos ausentes sexo
  filter(between(sexo, "F", "M")) |>

  # Filtrar edad en meses
  filter(tipo_edad_diagnostico != "MESES" & !is.na(edad_diagnostico)) |>

  # Cambiar etiquetas sexo
  mutate(sexo = if_else(sexo == "F", "Femenino", "Masculino")) |>

  # Crear columna para el año
  mutate(anio = year(fis)) |>

  # Crear columna para el mes
  mutate(mes = month(fis)) |>

  # Crear columna para grupo etario
  mutate(
    grupo_edad = age_categories(
      edad_diagnostico,
      breakers = c(0, 10, 15, 25, 45, 65)
    )
  ) |>

  # Crear columna para estación
  mutate(
    estacion = case_when(
      between(mes, 1, 3) ~ "Verano",
      between(mes, 4, 6) ~ "Otoño",
      between(mes, 7, 9) ~ "Invierno",
      between(mes, 10, 12) ~ "Primavera"
    )
  ) |>

  # Crear columna para ecorregión
  mutate(
    ecoregion = case_when(
      nom_depto == "VERA" ~ "Chaco Húmedo",
      nom_depto == "9 DE JULIO" ~ "Chaco Seco",
      str_detect(nom_depto, "CON|GAR|OBL|CAP|ROS|JAV") ~
        "Delta e Islas del Paraná",
      str_detect(nom_depto, "CAST|COLO|CRIS|JER|JUS") ~ "Espinal",
      str_detect(nom_depto, "CASE|LOP|IRI|MAR|LOR") ~ "Pampa"
    )
  ) |>

  # Agrupar datos
  count(
    anio,
    mes,
    estacion,
    ecoregion,
    nom_depto,
    grupo_edad,
    name = "casos_lepto"
  )


# Limpiar datos población ------------------------------------------------
pob <- pob_raw |>
  # Estandarizar nombres de columnas
  clean_names() |>
  rename(
    grupo_edad_5 = x1,
    pob = x2
  ) |>

  # Crear columna para el departamento
  mutate(
    nom_depto = if_else(
      str_detect(grupo_edad_5, "AREA"),
      pob,
      NA
    )
  ) |>
  # Completar filas
  fill(nom_depto, .direction = "down") |>

  # Filtrar datos
  filter(between(grupo_edad_5, "0-4", "95 y más")) |>

  # Reagrupar grupos etarios
  mutate(
    grupo_edad = fct_collapse(
      grupo_edad_5,
      "0-9" = c("0-4", "5-9"),
      "15-24" = c("15-19", "20-24"),
      "25-44" = c("25-29", "30-34", "35-39", "40-44"),
      "45-64" = c("45-49", "50-54", "55-59", "60-64"),
      "65+" = c(
        "65-69",
        "70-74",
        "75-79",
        "80-84",
        "85-89",
        "90-94",
        "95 y más"
      )
    )
  ) |>

  # Cambiar etiquetas departamento
  mutate(
    nom_depto = str_to_upper(nom_depto) |>
      stringi::stri_trans_general("Latin-ASCII")
  ) |>

  # Población a numérico
  mutate(pob = parse_number(pob)) |>

  # Agrupar datos
  count(nom_depto, grupo_edad, wt = pob, name = "poblacion")


# Unir datos -------------------------------------------------------------
datos <- casos |>
  # Añadir población
  left_join(pob)


# Guardar datos limpios --------------------------------------------------
export(datos, file = "base_pois_lepto.txt")
