library(tidyverse)
library(sf)
library(geojsonsf)
library(jsonlite)

# geodata -----------------------------------------------------------------

dados_geo_depto <- read_sf(dsn = './geo_data/pais_depto', layer = 'pxdptodatosok')

dados_geo_locales <- read_sf(dsn = './geo_data/pais_locales', layer = 'pxlocdatos')


## Provincias 

arg_prov <- read_sf(dsn = "./geo_data/provincia", layer = "provincia")

## BBoxes das Provincias

bboxes <- data.frame()

for (i in 1:nrow(arg_prov)) {
  bbox <- st_bbox(arg_prov[i,])
  bboxes[i,"nam"] <- arg_prov[i, "nam"]
  
  for (name in names(bbox)) {
    bboxes[i,name] <- bbox[[name]]
  }
}

arg_prov <- arg_prov %>%
  left_join(bboxes)

arg_prov_geojson <- geojsonsf::sf_geojson(arg_prov, digits = 6)
write_file(arg_prov_geojson, "./geo_data/arg_prov.geojson")


# fopea data --------------------------------------------------------------

nomes <- c("1" = "Desiertos", "2" = "Semidesiertos", "3" = "Semibosques", "4" = "Bosques")

file_cidades <- "./data/cidades.xlsx"

names_provincias <- readxl::excel_sheets(file_cidades)

colunas <- c("localidad", "pob", "cant_medios", "cant_periodistas", "pobXmedios", "pobXperiodistas", "categoria", "provincia")

datos_locales_list <- list()

for (prov in names_provincias) {
  
  dados <- readxl::read_excel(file_cidades, sheet = prov) %>%
    mutate(provincia = prov) %>%
    mutate_at(.vars = vars(-Departamento, -provincia), .funs = ~as.numeric(.)) %>%
    mutate(`Categoría` = as.character(`Categoría`))
  
  names(dados) <- colunas
  
  datos_locales_list[[prov]] <- dados
  
}

datos_locales <- datos_locales_list %>% 
  bind_rows() %>%
  mutate(localidad = str_to_title(localidad))


# join with geodata -------------------------------------------------------

datos_locales_geom <- datos_locales %>%
  left_join(dados_geo_locales) %>%
  filter(!is.na(link))

provincias_disponiveis <- datos_locales_geom %>% select(provincia) %>% distinct() %>% .$provincia

# provincias --------------------------------------------------------------

file_provincias <- "./data/provincias.xlsx"

provincias_raw <- readxl::read_excel(file_provincias)

provincias <- provincias_raw %>%
  filter(Provincia %in% provincias_disponiveis) #%>%
  #left_join(arg_prov, by = c("Provincia" = "nam"))



# lista de locais para pesquisa -------------------------------------------

lista_locais <- bind_rows(
  
  datos_locales_geom %>%
    mutate(local = paste0(localidad, " (", provincia, ")"),
           nome = localidad,
           prov = provincia,
           tipo = "localidad") %>%
    select(local, nome, prov, tipo),
  
  provincias %>%
    mutate(local = paste0(Provincia, " (Provincia)"),
           nome = Provincia,
           tipo = "provincia") %>%
    select(local, nome, tipo)
  
) %>%
  arrange(local)



# output ------------------------------------------------------------------

output <- list(
  "localidad" = datos_locales_geom,
  "provincia" = provincias,
  "lista_locais" = lista_locais
)

jsonlite::write_json(output, "output_dash.json")
