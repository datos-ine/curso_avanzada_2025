# opciones globales
knitr::opts_chunk$set(
  fig.align = "center",
  out.width = "85%",
  dpi = 300
)


# paquetes
pacman::p_load(
  patchwork,
  scico,
  janitor,
  easystats,
  kableExtra,
  tidyverse
)

# paleta colorblind-friendly
pal <- scico::scico(n = 9, palette = "tokyo")
