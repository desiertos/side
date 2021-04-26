library(tidyverse)
library(sf)
library(geojsonsf)

arg_prov <- read_sf(dsn = "./geo_data/provincia", layer = "provincia")
arg_dept <- read_sf(dsn = "./geo_data/departamento", layer = "departamento")
arg <- read_sf(dsn = "./geo_data/pais", layer = "pais")

arg_prov <- sf::st_simplify(arg_prov)
arg_dept <- sf::st_simplify(arg_dept)
arg <- sf::st_simplify(arg)

bboxes <- data.frame()

for (i in 1:nrow(arg_dept)) {
  bbox <- st_bbox(arg_dept[i,])
  bboxes[i,"nam"] <- arg_dept[i, "nam"]
  
  for (name in names(bbox)) {
    bboxes[i,name] <- bbox[[name]]
  }
}

arg_dept$bbox <- sf::st_bbox(arg_dept)
bboxes %>% count(nam) %>% filter(n > 1) %>% arrange(desc(n))
write_rds(bboxes, 'bboxes.rds')

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

arg_mask_simple <- sf::st_simplify(arg_mask, dTolerance = .1)

ggplot(arg_mask) + 
  geom_sf()

arg_geojson <- geojsonsf::sf_geojson(arg_prov, digits = 6)
write_file(arg_geojson, "./geo_data/arg.geojson")

arg_mask_geojson <- geojsonsf::sf_geojson(arg_mask_simple, digits = 6)
write_file(arg_mask_geojson, "./geo_data/arg_mask.geojson")

arg_dept_geojson <- geojsonsf::sf_geojson(arg_dept, digits = 6)
write_file(arg_dept_geojson, "./geo_data/arg_dept.geojson")


# arquivo alternativo -----------------------------------------------------

dept_categoria <- datos_cidades_export %>%
  select(local, categoria) %>%
  mutate(name_key = str_to_lower(local))

arg_dept_com_categorias <- arg_dept %>%
  mutate(name_key = str_to_lower(nam))
  left_join(dept_categoria, by = "name_key")

arg_dept_geojson <- geojsonsf::sf_geojson(arg_dept_com_categorias, digits = 6)
write_file(arg_dept_geojson, "./geo_data/arg_dept.geojson")
