library(tidyverse)
library(sf)
library(geojsonsf)

arg_prov <- read_sf(dsn = "./geo_data/provincia", layer = "provincia")
arg <- read_sf(dsn = "./geo_data/pais", layer = "pais")

arg_prov <- sf::st_simplify(arg_prov)
arg <- sf::st_simplify(arg)

bbox_arg_continental <- data.frame(
  lon = c(-53, -53, -75, -75),
  lat  = c(-21, -56, -56, -21)
)

polygon <- bbox_arg_continental %>%
  st_as_sf(coords = c("lon", "lat"), crs = 4326) %>%
  summarise(geometry = st_combine(geometry)) %>%
  st_cast("POLYGON")

arg_cont <- st_intersection(polygon, arg)

#ggplot(arg_cont) + geom_sf()

# mascara -----------------------------------------------------------------


world <- geojson_sf("./geo_data/world.json")

st_crs(world) <- st_crs(arg_cont)

world_crs <- st_transform(world, st_crs(world))

arg_mask <- sf::st_difference(world_crs, arg_cont)

ggplot(arg_mask) + 
  geom_sf()

arg_geojson <- geojsonsf::sf_geojson(arg_prov, digits = 6)
write_file(arg_geojson, "./geo_data/arg.geojson")

arg_mask_geojson <- geojsonsf::sf_geojson(arg_mask, digits = 6)
write_file(arg_mask_geojson, "./geo_data/arg_mask.geojson")
