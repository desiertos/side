library(tidyverse)
library(sf)
library(geojsonsf)


#arg_dept <- read_sf(dsn = "./geo_data/departamento", layer = "departamento")
arg_prov <- read_sf(dsn = "./geo_data/provincia", layer = "provincia")

the_crs <- sf::st_crs(arg_prov)

mun <- geojson_sf("departamentos.json")
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

prov_sf <- prov_sf %>%
  left_join(bboxes, by = 'nam') %>%
  rename(pob = poblacion_total,
         cant_medios = cantidad_de_medios,
         cant_periodistas = cantidad_de_periodistas,
         pobXmedios = `relacion_poblacion_residente/medios`,
         pobXperiodistas = `relacion_poblacion_residente/periodistas`)  
  

mun_sf <- mun_sf %>%
  mutate(provincia = provincia_convert[provincia],
         nam = `departamento/municipio/barrio`,
         randId = row_number()) %>%
  left_join(bboxes, by = c('provincia' = 'nam')) %>%
  rename(pob = poblacion_residente,
         cant_medios = cantidad_de_medios,
         cant_periodistas = cantidad_de_periodistas,
         pobXmedios = `relacion_poblacion_residente/medios`,
         pobXperiodistas = `relacion_poblacion_residente/periodistas`,
         local = nome_local)

centr <- sf::st_centroid(mun_sf)

for (i in 1:nrow(centr)) {
  
  mun_sf[i, 'xc'] <- centr$geometry[[i]][1]
  mun_sf[i, 'yc'] <- centr$geometry[[i]][2]
  
}

mun_geo <- geojsonsf::sf_geojson(mun_sf)
#prov_geo <- geojsonsf::sf_geojson(prov_sf, digits = 6)

write_file(mun_geo, '../desiertos.github.io/data/maps/dep.json')
#write_file(prov_geo, "./geo_data/d3/prov_.geojson")

prov_geo <- geojsonsf::sf_geojson(prov_sf, digits = 6)
#prov_geo <- geojsonsf::sf_geojson(prov_sf, digits = 6)

write_file(prov_geo, '../desiertos.github.io/data/maps/prov2.json')
#write_file(prov_geo, "./geo_data/d3/prov_.geojson")



# lista

mun_names <- data.frame(
  local = mun_sf$local, 
  provincia = mun_sf$provincia,
  text = paste0(mun_sf$nam, " (", mun_sf$provincia, ")"),
  tipo = 'localidad')

prov_names <- data.frame(
  local = prov_sf$nam,
  provincia = prov_sf$nam,
  text = paste0(prov_sf$nam, " (", prov_sf$provincia, ")"),
  tipo = 'provincia')


lista_locais <- bind_rows(mun_names, prov_names)


# output ------------------------------------------------------------------

mun_out <- mun_sf
sf::st_geometry(mun_out) <- NULL

prov_out <- prov_sf
sf::st_geometry(prov_out) <- NULL

output_dash <- list(
  'localidad' = mun_out,
  'provincia' = prov_out,
  'lista_locais' = lista_locais
)

# interessante, se usar o <- ali em cima, ele ignora os nomes e gera uma array com as 3 arrays, em vez de um objeto com as 3 arrays.

jsonlite::write_json(output_dash, '../desiertos.github.io/data/output_dash.json')
