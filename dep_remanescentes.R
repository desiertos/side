library(tidyverse)
library(sf)
library(geojsonsf)

#arg <- read_sf(dsn = "./geo_data/pais", layer = "pais")
arg_dept <- read_sf(dsn = "./geo_data/departamento", layer = "departamento")
sf::st_crs(arg_dept)
arg_prov <- read_sf(dsn = "./geo_data/provincia", layer = "provincia")
locales <- read_sf(dsn = "./geo_data/pais_locales", layer = "pxlocdatos")
depto_censo <- read_sf(dsn = "./geo_data/pais_depto", layer = "pxdptodatosok")
mun_censo <- read_sf(dsn ="./geo_data/ign_municipio", layer = "ign_municipio")
barrios <- read_sf(dsn ="./geo_data/shp_barrios", layer = "barrios_badata")

the_crs <- sf::st_crs(arg_prov)
sf::st_crs(barrios)

mun <- geojson_sf("departamentos.json")



# para ler as tabelas :/ --------------------------------------------------

arg_prov_sem_geom <- arg_prov
sf::st_geometry(arg_prov_sem_geom) <- NULL


# CABA --------------------------------------------------------------------

caba <- arg_prov %>% filter(nam == "Ciudad Autónoma de Buenos Aires")

a<-st_contains(caba, arg_dept)
depts_inside_caba <- st_intersection(arg_dept, caba)

arg_dept$nam[a[[1]]]

ggplot() + 
  geom_sf(data = caba, fill = "white", color = "black") +
  geom_sf_text(data = depts_inside_caba, aes(label = gid)) +
  geom_sf(data = barrios, fill ="lightpink", alpha = .4, color = "tomato") +
geom_sf(data = depts_inside_caba, fill ="transparent", alpha = .4, color = "hotpink")
  

# para o excel ------------------------------------------------------------

mun_empty <- mun %>%
  filter(sf::st_is_empty(mun))

sf::st_geometry(mun_empty) <- NULL

dept <- arg_dept %>%
  select(nam, gid, geometry)

lista_dept <- dept
sf::st_geometry(lista_dept) <- NULL

write.csv2(lista_dept, "para_comparar_dept.csv")
write.csv2(mun_empty, "para_comparar_mun.csv")

# The problem: argentina's shapefiles do not indicate the province. trying to figure the gid of the missing departments by looking at the map


# Finding capital missiones
ggplot() +
  geom_sf(data = arg_prov %>% filter(nam == "Misiones"), fill =  "darkgrey") +
  geom_sf(data = arg_dept %>% filter(nam == "Capital"), fill = "ghostwhite", color = "hotpink", alpha = .5) +
  geom_sf_text(data = arg_dept %>% filter(nam == "Capital"), aes(label = gid))


# Finding capital mendoza
ggplot() +
  geom_sf(data = arg_prov %>% filter(nam == "Mendoza"), fill =  "darkgrey") +
  geom_sf(data = arg_dept %>% filter(nam == "Capital"), fill = "ghostwhite", color = "hotpink", alpha = .5) +
  geom_sf_text(data = arg_dept %>% filter(nam == "Capital"), aes(label = gid))


# Finding Río Chico
ggplot() +
  geom_sf(data = arg_prov %>% filter(nam %in% c("Santiago del Estero", "Santa Cruz")), fill =  "darkgrey") +
  geom_sf(data = arg_dept %>% filter(nam == "Río Chico"), fill = "ghostwhite", color = "hotpink", alpha = .5) +
  geom_sf_text(data = arg_dept %>% filter(nam == "Río Chico"), aes(label = gid)) +
  geom_sf_label(data = arg_prov %>% filter(nam %in% c("Santiago del Estero", "Santa Cruz")), aes(label = nam))

# Finding Libertador General San Martín, de San Luis

ggplot() +
  geom_sf(data = arg_prov %>% filter(nam == "San Luis"), fill =  "darkgrey") +
  geom_sf(data = arg_dept %>% filter(nam == "Libertador General San Martín"), fill = "ghostwhite", color = "hotpink", alpha = .5) +
  geom_sf_text(data = arg_dept %>% filter(nam == "Libertador General San Martín"), aes(label = gid))

# Finding Capital, de Corrientes

ggplot() +
  geom_sf(data = arg_prov %>% filter(nam == "Corrientes"), fill =  "darkgrey") +
  geom_sf(data = arg_dept %>% filter(nam == "Capital"), fill = "ghostwhite", color = "hotpink", alpha = .5) +
  geom_sf_text(data = arg_dept %>% filter(nam == "Capital"), aes(label = gid)) +
  scale_y_continuous(limits = c(-32, -26))
