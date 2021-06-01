library(tidyverse)
library(sf)
library(geojsonsf)


#arg_dept <- read_sf(dsn = "./geo_data/departamento", layer = "departamento")
arg_prov <- read_sf(dsn = "./geo_data/provincia", layer = "provincia")

the_crs <- sf::st_crs(arg_prov)

mun <- geojson_sf("../data/output/municipios.json")
prov <- geojson_sf("../data/output/provincias.json")

# setando na mão o crs
mun <- sf::st_set_crs(mun, 5343)
prov <- sf::st_set_crs(prov, 5343)

mun_sf <- sf::st_transform(mun, the_crs)
prov_sf <-  sf::st_transform(prov, the_crs)

provincia_convert = c(
  "misiones" = "Misiones", 
  "tierra_del_fuego" = "Tierra del Fuego, Antártida e Islas del Atlántico Sur", 
  "santiago_del_estero" = "Santiago del Estero", 
  "cordoba" = "Córdoba",
  "la_pampa" = "La Pampa", 
  "formosa" = "Formosa", 
  "santa_cruz" = "Santa Cruz", 
  "tucuman" = "Tucumán", 
  "chaco" = "Chaco", 
  "san_luis" = "San Luis", 
  "catamarca" = "Catamarca", 
  "rio_negro" = "Río Negro", 
  "salta" = "Salta", 
  "neuquen" = "Neuquén", 
  "corrientes" = "Corrientes", 
  "ciudad_autonoma_de_buenos_aires" = "Ciudad Autónoma de Buenos Aires",
  "buenos_aires" = "Buenos Aires", 
  "chubut" = "Chubut", 
  "jujuy" = "Jujuy", 
  "santa_fe" = "Santa Fe", 
  "la_rioja" = "La Rioja", 
  "entre_rios" = "Entre Ríos", 
  "san_juan" = "San Juan", 
  "mendoza" = "Mendoza")

prov_sf <- prov_sf %>%
  mutate(nam = provincia_convert[provincia],
         local = nam)

bboxes <- data.frame()

for (i in 1:nrow(prov_sf)) {
  bbox <- st_bbox(prov_sf[i,])
  bboxes[i,"nam"] <- prov_sf[i, "nam"]
  
  for (name in names(bbox)) {
    bboxes[i,name] <- bbox[[name]]
  }
}

mun_sf <- mun_sf %>%
  mutate(provincia = provincia_convert[provincia],
         nam = `departamento/municipio/barrio`) %>%
  left_join(bboxes, by = c('provincia' = 'nam')) %>%
  rename(pob = poblacion_residente,
         cant_medios = cantidad_de_medios,
         cant_periodistas = cantidad_de_periodistas,
         pobXmedios = `relacion_poblacion_residente/medios`,
         pobXperiodistas = `relacion_poblacion_residente/periodistas`)


mun_geo <- geojsonsf::sf_geojson(mun_sf)
#prov_geo <- geojsonsf::sf_geojson(prov_sf, digits = 6)

write_file(mun_geo, '../desiertos.github.io/data/maps/mun2.json')
#write_file(prov_geo, "./geo_data/d3/prov_.geojson")

prov_geo <- geojsonsf::sf_geojson(prov_sf, digits = 6)
#prov_geo <- geojsonsf::sf_geojson(prov_sf, digits = 6)

write_file(prov_geo, '../desiertos.github.io/data/maps/prov2.json')
#write_file(prov_geo, "./geo_data/d3/prov_.geojson")



# lista

mun_names <- data.frame(
  local = mun_sf$nome_local, 
  provincia = mun_sf$provincia,
  text = paste0(mun_sf$nam, " (", mun_sf$provincia, ")"),
  tipo = 'localidad')

prov_names <- data.frame(
  local = prov_sf$nam,
  provincia = prov_sf$nam,
  text = paste0(prov_sf$nam, " (", prov_sf$provincia, ")"),
  tipo = 'provincia')


lista_locais <- bind_rows(mun_names, prov_names)

jsonlite::write_json(lista_locais, '../desiertos.github.io/data/places.json')




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



# c("deserts_count", "relacion_poblacion_residente/medios", "semiforests_count", 
#   "relacion_poblacion_residente/periodistas", "semiserts_count", 
#   "populacion_en_areas_recenseadas", "cantidad_de_medios", "categoria", 
#   "semiforests_percentage", "promedio_categorias", "cantidad_de_periodistas", 
#   "provincia", "forests_percentage", "forests_count", "deserts_percentage", 
#   "semideserts_percentage", "poblacion_total", "codpcia", "nam", 
#   "local", "xmin", "ymin", "xmax", "ymax", "geometry")

