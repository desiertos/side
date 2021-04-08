library(sf)
library(tidyverse)

arg <- read_sf(dsn = "./geo_data/provincia", layer = "provincia")

arg_simples <- sf::st_simplify(arg)

arg_continental <- st_filter(x <= -53, y >= -56)

sf::st_crs(arg_simples)

bbox_arg_continental <- data.frame(
  lon = c(-53, -53, -75, -75),
  lat  = c(-21, -56, -56, -21)
)

polygon <- bbox_arg_continental %>%
  st_as_sf(coords = c("lon", "lat"), crs = 4326) %>%
  summarise(geometry = st_combine(geometry)) %>%
  st_cast("POLYGON")

ggplot(polygon) + geom_sf()

arg_continental <- st_intersection(polygon, arg_simples)

ggplot(arg_continental) + geom_sf()
