library(tidyverse)
library(sf)
library(geojsonsf)


arg_dept <- read_sf(dsn = "./geo_data/departamento", layer = "departamento")
arg_prov <- read_sf(dsn = "./geo_data/provincia", layer = "provincia")

the_crs <- sf::st_crs(arg_prov)

mun <- geojson_sf("../data/output/municipios.json")
#prov <- geojson_sf("../data/output/provincias.json")

# setando na mão o crs
mun_ <- sf::st_set_crs(mun, 5343)

mun_sf <- sf::st_transform(mun_, the_crs)

#prov_sf <-  sf::st_transform(prov, the_crs)


mun_geo <- geojsonsf::sf_geojson(mun_sf)
#prov_geo <- geojsonsf::sf_geojson(prov_sf, digits = 6)

write_file(mun_geo, "./geo_data/d3/mun_.geojson")
#write_file(prov_geo, "./geo_data/d3/prov_.geojson")

mun_$poblacion_residente %>% 
  as.numeric() %>% 
  sum() %>% 
  format(big.mark = ".")



bbox_arg_continental <- data.frame(
  lon = c(-53, -53, -75, -75),
  lat  = c(-21, -56, -56, -21)
)

polygon <- bbox_arg_continental %>%
  st_as_sf(coords = c("lon", "lat"), crs = 4326) %>%
  summarise(geometry = st_combine(geometry)) %>%
  st_cast("POLYGON")

arg <- sf::st_simplify(arg_prov, dTolerance = .1)

arg_cont <- st_intersection(polygon, arg)

ggplot(arg_cont) + geom_sf()

write_file(
  geojsonsf::sf_geojson(arg_cont), 
  "./geo_data/d3/provv.geojson")



