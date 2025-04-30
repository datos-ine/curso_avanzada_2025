### Este script contiene la lista de paquetes sugerido para trabajar en el curso
### de Epidemiología: Nivel Avanzado. Si es la primera vez que usan R, se
### recomienda instalarlos todos de una vez apretando el botón Source, de lo
### contrario ejecutar solamente las líneas de aquellos que no estén instalados.


# Unidad 1 ----------------------------------------------------------------
install.packages("tidyverse", dependencies = TRUE)

install.packages("esquisse", dependencies = TRUE)

install.packages("janitor", dependencies = TRUE)

install.packages("dlookr", dependencies = TRUE)

install.packages("skimr", dependencies = TRUE)

install.packages("scico", dependencies = TRUE) # Paletas accesibles (opcional)


# Unidad 2 ----------------------------------------------------------------
install.packages("samplingbook", dependencies = TRUE)

install.packages("pwr", dependencies = TRUE)

install.packages("nortest", dependencies = TRUE)

install.packages("ggpubr", dependencies = TRUE)

install.packages("moments", dependencies = TRUE)

install.packages("srvyr", dependencies = TRUE)

install.packages("epikit", dependencies = TRUE) # Herramientas epidemiología (opcional)


# Unidad 3 ----------------------------------------------------------------
## Unidad 3
# Evaluación de supuestos en modelos de regresión:
install.packages("easystats", dependencies = TRUE)

install.packages("nortest", dependencies = TRUE)

install.packages("gvlma", dependencies = TRUE)

install.packages("lmtest", dependencies = TRUE)

# Tablas de coeficientes:
install.packages("gtsummary", dependencies = TRUE)

# Generación de correlogramas:
install.packages("GGally", dependencies = TRUE)

# Comparación de medias
install.packages("emmeans", dependencies = TRUE)


# Unidad 4 ----------------------------------------------------------------
install.packages("detectseparation", dependencies = TRUE)

install.packages("MatchIt", dependencies = TRUE)

install.packages("epiR", dependencies = TRUE)

install.packages("flextable", dependencies = TRUE)



# Unidad 5 ----------------------------------------------------------------
install.packages("glmmTMB", dependencies = TRUE)


# Unidad 6 ----------------------------------------------------------------
install.packages("survminer", dependencies = TRUE)
