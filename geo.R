library(sf)
library(tidyverse)

arg <- read_sf(dsn = "./geo_data/provincia", layer = "provincia")

ggplot(arg) + geom_sf()
