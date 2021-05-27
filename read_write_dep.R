library(tidyverse)
library(sf)
library(geojsonsf)


#arg_dept <- read_sf(dsn = "./geo_data/departamento", layer = "departamento")
arg_prov <- read_sf(dsn = "./geo_data/provincia", layer = "provincia")


the_crs <- sf::st_crs(arg_prov)

#mun <- geojson_sf("departamentos.json")
prov <- geojson_sf("../data/output/provincias.json")

# setando na mão o crs
#mun <- sf::st_set_crs(mun, 5343)
prov <- sf::st_set_crs(prov, 5343)

#mun_sf <- sf::st_transform(mun, the_crs)
prov_sf <-  sf::st_transform(prov, the_crs)

mun_sf <- readRDS('mun_completo.rds')


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

prov_sf2 <- prov_sf %>%
  mutate(nam = provincia_convert[provincia],
         local = nam)

bboxes <- data.frame()

for (i in 1:nrow(prov_sf2)) {
  bbox <- st_bbox(prov_sf2[i,])
  bboxes[i,"nam"] <- prov_sf2[i, "nam"]
  
  for (name in names(bbox)) {
    bboxes[i,name] <- bbox[[name]]
  }
}

prov_sf3 <- prov_sf2 %>%
  left_join(bboxes, by = 'nam') %>%
  rename(pob = poblacion_total,
         cant_medios = cantidad_de_medios,
         cant_periodistas = cantidad_de_periodistas,
         pobXmedios = `relacion_poblacion_residente/medios`,
         pobXperiodistas = `relacion_poblacion_residente/periodistas`) %>%
  mutate(pob = as.numeric(pob))

# this centroid will be useful to place province labels
centr_prov <- sf::st_centroid(prov_sf3)

for (i in 1:nrow(centr_prov)) {
  
  prov_sf3[i, 'xc'] <- centr_prov$geometry[[i]][1]
  prov_sf3[i, 'yc'] <- centr_prov$geometry[[i]][2]
  
}
  

mun_sf2 <- mun_sf %>%
  mutate(provincia = provincia_convert[provincia],
         nam = `departamento/municipio/barrio`,
         randId = row_number(),
         local = paste(nome_local, provincia, sep = '_')) %>%
  left_join(bboxes, by = c('provincia' = 'nam')) %>%
  rename(pob = poblacion_residente,
         cant_medios = cantidad_de_medios,
         cant_periodistas = cantidad_de_periodistas,
         pobXmedios = `relacion_poblacion_residente/medios`,
         pobXperiodistas = `relacion_poblacion_residente/periodistas`)

centr <- sf::st_centroid(mun_sf2)

for (i in 1:nrow(centr)) {
  
  mun_sf2[i, 'xc'] <- centr$geometry[[i]][1]
  mun_sf2[i, 'yc'] <- centr$geometry[[i]][2]
  
}


# update categories count -------------------------------------------------

cat_variables <- data.frame(
  categoria = c("1", "2", "3", "4"),
  variables = c("deserts_count", "semideserts_count", "semiforests_count", "forests_count")
)

mun_df <- mun_sf2
st_geometry(mun_df) <- NULL

cat_count_prov <- mun_df %>%
  group_by(provincia) %>%
  count(categoria) %>%
  left_join(cat_variables) %>%
  select(-categoria) %>%
  spread(variables, n) %>%
  mutate_at(vars(ends_with('_count')), ~replace_na(., 0)) %>%
  rename(nam = provincia)

# some problems with subtotals

subtotals_prov <- mun_df %>%
  group_by(provincia) %>%
  summarise_at(
    .vars = vars(pob, cant_medios, cant_periodistas),
    .funs = ~sum(as.numeric(.), na.rm = T)
  ) %>%
  ungroup()

#join with prov data

prov_sf4 <- prov_sf3 %>%
  select(-ends_with('_count')) %>%
  left_join(cat_count_prov)

# fixes

fix_pob <- c(
  'Chubut' = 509108,
  'Jujuy' = 673307,
  'Neuquén' = 551266,
  'Río Negro' = 638645,
  'Tucumán' = 1448188)

fix_cant_medios <- c(
  'Chubut' = 63
)

fix_cant_periodistas <- c(
  'Chubut' = 407
)

prov_sf5 <- prov_sf4 %>%
  mutate(
    pob = ifelse(nam %in% names(fix_pob),
                 fix_pob[nam],
                 pob),
    cant_medios = ifelse(nam %in% names(fix_cant_medios),
                         fix_cant_medios[nam],
                         cant_medios),
    cant_periodistas = ifelse(nam %in% names(fix_cant_periodistas),
                              fix_cant_periodistas[nam],
                              cant_periodistas)
  )

mun_sf3 <- mun_sf2 %>%
  mutate(nam = ifelse(provincia == 'San Luis',
                      str_to_title(nam, locale = 'es'),
                      nam))

#https://www.ign.gob.ar/NuestrasActividades/Geografia/DatosArgentina/Poblacion2

# provv <- prov_sf
# st_geometry(provv) <- NULL

# write files out ---------------------------------------------------------



mun_geo <- geojsonsf::sf_geojson(mun_sf3)
#prov_geo <- geojsonsf::sf_geojson(prov_sf, digits = 6)

write_file(mun_geo, '../desiertos.github.io/data/maps/dep.json')
#write_file(prov_geo, "./geo_data/d3/prov_.geojson")

prov_geo <- geojsonsf::sf_geojson(prov_sf5, digits = 6)
#prov_geo <- geojsonsf::sf_geojson(prov_sf, digits = 6)

write_file(prov_geo, '../desiertos.github.io/data/maps/prov2.json')
#write_file(prov_geo, "./geo_data/d3/prov_.geojson")



# lista

mun_names <- data.frame(
  local = mun_sf3$local, 
  provincia = mun_sf3$provincia,
  text = paste0(mun_sf3$nam, " (", mun_sf3$provincia, ")"),
  tipo = 'localidad')

prov_names <- data.frame(
  local = prov_sf5$nam,
  provincia = prov_sf5$nam,
  text = paste0(prov_sf5$nam, " (", prov_sf5$provincia, ")"),
  tipo = 'provincia')


lista_locais <- bind_rows(mun_names, prov_names)


# output ------------------------------------------------------------------

mun_out <- mun_sf3
sf::st_geometry(mun_out) <- NULL

prov_out <- prov_sf5
sf::st_geometry(prov_out) <- NULL

output_dash <- list(
  'localidad' = mun_out,
  'provincia' = prov_out,
  'lista_locais' = lista_locais
)

# interessante, se usar o <- ali em cima, ele ignora os nomes e gera uma array com as 3 arrays, em vez de um objeto com as 3 arrays.

jsonlite::write_json(output_dash, '../desiertos.github.io/data/output_dash.json')
