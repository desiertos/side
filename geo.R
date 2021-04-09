library(tidyverse)
library(sf)
library(geojsonsf)

arg <- read_sf(dsn = "./provincia", layer = "provincia")
arg_pais <- read_sf(dsn = "./pais", layer = "pais")

arg_simples <- sf::st_simplify(arg_pais)

bbox_arg_continental <- data.frame(
  lon = c(-53, -53, -75, -75),
  lat  = c(-21, -56, -56, -21)
)

polygon <- bbox_arg_continental %>%
  st_as_sf(coords = c("lon", "lat"), crs = 4326) %>%
  summarise(geometry = st_combine(geometry)) %>%
  st_cast("POLYGON")

arg_cont <- st_intersection(polygon, arg_simples)

ggplot(arg_cont) + geom_sf()

#mascara

world <- geojson_sf("world.geojson")

st_crs(world) <- st_crs(arg_cont)

world_crs <- st_transform(world, st_crs(world))

arg_mask <- sf::st_difference(world_crs, arg_cont)

ggplot(arg_mask) + 
  geom_sf()

arg_geojson <- geojsonsf::sf_geojson(arg)
write_file(arg_geojson, "arg.geojson")

arg_mask_geojson <- geojsonsf::sf_geojson(arg_mask)
write_file(arg_mask_geojson, "arg_mask.geojson")
