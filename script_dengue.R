# Cargar paquetes --------------------------------------------------------
pacman::p_load(
  glmmTMB,
  easystats,
  gtsummary,
  janitor,
  tidyverse
)


# Cargar datos -----------------------------------------------------------
datos <- read_delim("files/datos/dengue_costa.txt")


## Explorar datos
glimpse(datos)

tabyl(datos$provincia)
tabyl(datos$departamento)
tabyl(datos$periodo)

datos |>
  count(semana_epi, wt = casos) |>
  ggplot(mapping = aes(x = semana_epi, y = n)) +
  geom_point()


# Ajuste del modelo ------------------------------------------------------
## Modelo poisson
fit_pois <- glm(
  casos ~ semana_epi + grupo_edad_cat,
  family = poisson,
  data = datos
)


summary(fit_pois)

check_overdispersion(fit_pois)


## Modelo binomial negativo
fit_nb <- glmmTMB(
  casos ~ semana_epi + grupo_edad_cat,
  family = nbinom2(),
  data = datos
)

summary(fit_nb)
