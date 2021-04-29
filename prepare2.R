library(tidyverse)
library(sf)

datos_salta_san_luis <- datos_cidades_cons %>% 
  filter(provincia %in% c("Salta", "San Luis"))

dados_geo_depto <- read_sf(dsn = './geo_data/pais_depto', layer = 'pxdptodatosok')

dados_geo_salta_san_luis %>% dados_geo_depto %>%
  select(local = departamen, provincia) %>%
  filter(provincia %in% c("Salta", "San Luis"))
