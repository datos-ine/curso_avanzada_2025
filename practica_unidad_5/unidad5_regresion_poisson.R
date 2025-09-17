### Curso de Epidemiología: Nivel Avanzado
### UNIDAD 5: Estudios de Cohorte
### Script clase teórica: Regresión de Poisson


# Carga paquetes ----------------------------------------------------------
library(parameters)
library(see)
library(gtsummary)
library(performance)
library(epiDisplay)
library(tidyverse) # cargar siempre al final para evitar conflictos de funciones


# Carga datos -------------------------------------------------------------
datos <- read_csv2("cohorte_ocupacional.csv")


# Limpieza de datos -------------------------------------------------------
datos <- datos %>% 
  # cambia etiquetas niveles de variables
  mutate(
    grupo.edad = factor(grupo.edad, labels=c("40-49","50-59","60-69","70-79")),
    
    periodo = factor(periodo, labels=c("1938-1949", "1950-1959", "1960-1969", "1970-1977")),
    
    comienzo = factor(comienzo, labels=c("< 1925", "1925 y post")),
    
    arsenico = factor(arsenico, labels=c("<1 año", "1-4 años","5-14 años", "15+ años"))
    ) %>% 
  
  # recategoriza arsénico
  mutate(arsenico2 = if_else(arsenico == "<1 año", "<1 año", "1+ años") %>% 
           as.factor())


# Exploración de datos ----------------------------------------------------
glimpse(datos)

## Niveles de factores
levels(datos$grupo.edad)

levels(datos$periodo)

levels(datos$comienzo)

levels(datos$arsenico)


## Exploremos los datos de la base organizando la información de persona-años
## por edad y período
datos %>% count(periodo, grupo.edad, wt = persona.anio) %>% 
  pivot_wider(names_from = grupo.edad, values_from = n)


## Incidencia de muertes por 10000 personas-año para cada celda
# crea objeto personas-años
personas_años <- datos %>% count(periodo, grupo.edad, 
                                 wt = persona.anio,
                                 name = "p.a")

# calcula incidencia muertes
muertes <- datos %>% 
  count(periodo, grupo.edad, wt = muertes) %>% 
  
  left_join(personas_años, by = c("periodo", "grupo.edad")) %>% 
  
  mutate(incidencia = round(n/p.a*10000,2)) %>%
  
  select(-n, -p.a)


print(muertes)

# gráfico
muertes %>% 
  ggplot(mapping = aes(x = periodo, y = incidencia, 
                       color = grupo.edad, group = grupo.edad)) +
  
  geom_point() +
  
  geom_path() +
  
  labs(x = "Período", y = "10.000 personas-año", color = "Edad")


# Regresión Poisson -------------------------------------------------------
## Modelo saturado
modelo <- glm(muertes ~ periodo + grupo.edad + arsenico, 
              offset = log(persona.anio),
              family = poisson,
              data = datos)

## Resumen modelo
summary(modelo)

## Bondad de ajuste
poisgof(modelo)

poisgof(modelo)$p.value # muestra solo el p-valor


## Selección de variables a partir de modelo saturado
# (-) arsénico
mod1 <- glm(muertes ~ periodo + grupo.edad, offset = log(persona.anio),
            family = poisson,
            data = datos)

# (-) grupo etario
mod2 <- glm(muertes ~ periodo + arsenico, offset = log(persona.anio),
            family = poisson,
            data = datos)

# (-) período
mod3 <- glm(muertes ~ grupo.edad + arsenico, offset = log(persona.anio),
            family = poisson,
            data = datos) 

## Compara modelos - paquete performance - 
compare_performance(modelo, mod1, mod2, mod3, metrics = "common")


## Selección de variables a partir de modelo 3
# (-) arsénico
mod3.1 <- glm(muertes ~ grupo.edad, offset = log(persona.anio),
              family = poisson,
              data = datos) 

# (-) grupo etario
mod3.2 <- glm(muertes ~ arsenico, offset = log(persona.anio),
              family = poisson,
              data = datos) 

## Compara modelos - paquete performance - 
compare_performance(mod3, mod3.1, mod3.2, metrics = "common")

## Bondad de ajuste
poisgof(mod3)

poisgof(mod3)$p.value

## Resumen modelo
summary(mod3)

## Coeficientes
# función exp()
round(exp(coef(mod3)),2)

# función tbl_regression() - paquete gtsummary - 
tbl_regression(mod3, exponentiate = T)


## Modelo con arsénico recategorizado
mod4 <- glm(muertes ~ grupo.edad + arsenico2,
            offset=log(persona.anio), 
            family=poisson, 
            data = datos)


## Compara modelos - paquete performance - 
compare_performance(mod3, mod4, metrics = "common")

## Bondad de ajuste
poisgof(mod4)

## Resumen modelo
summary(mod4)

## Coeficientes
# función exp()
round(exp(coef(mod4)),2)

# función tbl_regression() - paquete gtsummary - 
tbl_regression(mod4, exponentiate = T)


# Predicción datos nuevos -------------------------------------------------
## Crea nuevo set de datos
newdata <- tibble(
  grupo.edad = c("40-49", "40-49"),
  arsenico2 = c("<1 año", "1+ años"),
  persona.anio = c(100000, 100000)
)

## Predice datos
di <- predict(mod4, newdata, type = "response")

rdi.arsenico <- di[2] / di[1]

rdi.arsenico 

# coeficientes
exp(coef(mod4)[5])

# salida completa - paquete epiDisplay - 
idr.display(mod4)

# gráfico modelo - paquetes see y parameters - 
model_parameters(mod4, exponentiate = T) %>% 
  plot()
