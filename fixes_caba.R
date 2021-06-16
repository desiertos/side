library(tidyverse)
library(sf)
library(geojsonsf)
library(jsonlite)

# this was already simplified with mapshaper
dep_json <- jsonlite::read_json('../desiertos.github.io/data/maps/dep.json')

dep_sf <- geojson_sfc(dep_json)
