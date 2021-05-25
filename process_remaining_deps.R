library(tidyverse)
library(sf)
library(geojsonsf)

arg_dept <- read_sf(dsn = "./geo_data/departamento", layer = "departamento")
arg_prov <- read_sf(dsn = "./geo_data/provincia", layer = "provincia")
barrios_raw <- read_sf(dsn ="./geo_data/shp_barrios", layer = "barrios_badata")

the_crs <- sf::st_crs(arg_prov)
sf::st_crs(barrios)

mun_raw <- geojson_sf("departamentos.json")
mun_raw <- sf::st_set_crs(mun_raw, 5343)
mun <- sf::st_transform(mun_raw, the_crs)

#barrios_raw <- sf::st_set_crs(barrios_raw, 5343)
barrios <- sf::st_transform(barrios_raw, the_crs)

# depts without geometry --------------------------------------------------

mun_with_geom <- mun %>%
  filter(!sf::st_is_empty(mun))

mun_no_geom_pre <- mun %>%
  filter(sf::st_is_empty(mun)) %>%
  filter(provincia != 'santa_cruz') %>% #(1)
  mutate(provincia = ifelse(provincia == 'santiago_del_estero',
                            'santa_cruz',
                            provincia)) #(2)

sf::st_geometry(mun_no_geom_pre) <- NULL
         
#(1) localities of santa cruz are municipalities, we need to insert the data for departments
#(2) these were switched

# gets data from santiago
santiago <- readxl::read_excel('para_comparar.xlsx', sheet = 'santiago') %>%
  mutate_all(as.character)

mun_no_geom <- bind_rows(
  mun_no_geom_pre,
  santiago) %>%
  mutate(nome_provincia = paste(nome_local, provincia, sep = "_"))


# get the correpondence

nome_provincia_gid <- readxl::read_excel('para_comparar.xlsx', sheet = 'correspondence')

mun_no_geom_gid <- mun_no_geom %>%
  filter(nome_local != "villa_general_mitre") %>%
  left_join(nome_provincia_gid)

geoms_dep <- arg_dept %>%
  select(gid)

mun_reman_geom <- mun_no_geom_gid %>%
  left_join(geoms_dep) %>%
  select(-gid, nome_provincia)


# villa general mitre -----------------------------------------------------

mitre_no_geom <- mun_no_geom %>%
  filter(nome_local == "villa_general_mitre")

mitre_geom <- barrios %>% filter(str_detect(BARRIO, "MITRE"))

#st_crs(mitre_geom)

#mitre_geom_sf <- sf::st_transform(mitre_geom, the_crs)

mitre <- mitre_no_geom
st_geometry(mitre) <- st_geometry(mitre_geom)


# join everything ---------------------------------------------------------

mun_completo <- bind_rows(
  mun_with_geom,
  mun_reman_geom,
  mitre
)

# st_crs(mun_completo)
# mun_completo <- sf::st_set_crs(mun_completo, 5343)
# mun_completo_sf <- sf::st_transform(mun_completo, the_crs)

# saves -------------------------------------------------------------------

saveRDS(mun_completo, 'mun_completo.rds')



# test plots --------------------------------------------------------------


ggplot(mun_completo %>% filter(provincia == 'santa_cruz')) + geom_sf()
ggplot(mun_completo %>% filter(provincia == 'santiago_del_estero')) + geom_sf()
ggplot(mun_completo %>% filter(provincia == 'ciudad_autonoma_de_buenos_aires')) + geom_sf(fill = "lavender") + 
  geom_sf(data = barrios, fill = "lightpink", alpha = .4)

ggplot(mun_completo %>% filter(provincia == 'misiones')) + geom_sf(fill = 'lavender')


mun__ <- mun_completo
st_geometry(mun__) <- NULL
mun__ %>% count(paste(nome_local, provincia)) %>% filter(n>1)

mun__ %>% count(categoria) %>% mutate(pct = n / sum(n))
mun__ %>% group_by(provincia) %>% count(categoria)

mun__$cantidad_de_medios %>% as.numeric() %>% sum(na.rm = T)
