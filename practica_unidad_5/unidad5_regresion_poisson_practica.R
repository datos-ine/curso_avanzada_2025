## Curso de Epidemiología: Nivel Avanzado
### UNIDAD 5: Estudios de Cohorte
### Práctica Regresión de Poisson

# Carga paquetes ----------------------------------------------------------
pacman::p_load(
  glmmTMB,
  easystats,
  gtsummary,
  skimr,
  janitor,
  tidyverse,
  update = TRUE
)


# Carga datos -------------------------------------------------------------
datos <- read_delim("clean/base_pois_lepto.txt")


# Limpieza de datos -------------------------------------------------------
datos <- datos |>

  # Variables caracter a factor
  mutate(across(.cols = where(is.character), .fns = ~ as.factor(.x)))


# Exploración de datos ----------------------------------------------------
glimpse(datos)

skim(datos)

## Niveles de factores
levels(datos$estacion)

levels(datos$ecoregion)

levels(datos$grupo_edad)

# crea objeto personas-años

# calcula incidencia

# gráfico incidencia

# Regresión Poisson -------------------------------------------------------
## Modelo saturado

# resumen modelo

# bondad de ajuste

## Selección de variables a partir de modelo saturado

## Compara modelos - paquete performance -

## Selección de variables a partir de modelo

## Compara modelos - paquete performance -

## Bondad de ajuste

## Resumen modelo

## Coeficientes
# función exp()

# función tbl_regression() - paquete gtsummary -

# Predicción datos nuevos -------------------------------------------------
## Crea nuevo set de datos

## Predice datos

# coeficientes

# salida completa - paquete epiDisplay -

# gráfico modelo - paquetes see y parameters -
