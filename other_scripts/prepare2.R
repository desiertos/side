library(tidyverse)
library(sf)
library(geojsonsf)
library(jsonlite)

# geodata -----------------------------------------------------------------

dados_geo_depto <- read_sf(dsn = './geo_data/pais_depto', layer = 'pxdptodatosok')

dados_geo_locales <- read_sf(dsn = './geo_data/pais_locales', layer = 'pxlocdatos')

sf::st_crs(dados_geo_depto)
sf::st_crs(dados_geo_locales)

# teste
ggplot() + 
  geom_sf(data = arg_prov) +
  geom_sf(data= dados_geo_locales %>% filter(provincia == "Salta"), color = " hotpink", size = 1)

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
  filter(Provincia %in% provincias_disponiveis) %>%
  #left_join(arg_prov, by = c("Provincia" = "nam"))
  left_join(bboxes, by = c("Provincia" = "nam"))

## aggregate data from lower level

summary_prov_from_locales <- datos_locales_geom %>%
  group_by(provincia) %>%
  summarise_at(.vars = vars('pob', 'cant_medios', 'cant_periodistas'), .funs = ~sum(., na.rm = T))

provincias_export <- provincias %>%
  rename(local = Provincia) %>%
  left_join(summary_prov_from_locales, by = c("local" = "provincia"))


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

locales_export <- datos_locales_geom %>% 
  select(-geometry) %>% 
  rename(local = localidad)

output <- list(
  "localidad" = locales_export ,
  "provincia" = provincias_export,
  "lista_locais" = lista_locais
)

jsonlite::write_json(output, "../desiertos.github.io/data/output_dash.json")

arg_prov_geojson <- geojsonsf::sf_geojson(arg_prov, digits = 6)
write_file(arg_prov_geojson, "../desiertos.github.io/data/maps/arg_prov.geojson")

datos_locales_geom_sf <- sf::st_as_sf(datos_locales_geom)

datos_locales_geom_sf <- sf::st_transform(datos_locales_geom_sf, sf::st_crs(dados_geo_depto))

arg_localidads_geojson <- geojsonsf::sf_geojson(
  datos_locales_geom_sf, 
  digits = 6)

write_file(arg_localidads_geojson, "../desiertos.github.io/data/maps/arg_localidads.geojson")



# plot --------------------------------------------------------------------

cores <- c("1" = "#D77E5B", "2" = "#E1BA9B", "3" = "#CEBF74", "4" = "#7C9A68")

nomes <- c("1" = "Desiertos", "2" = "Semidesiertos", "3" = "Semibosques", "4" = "Bosques")

ggplot(locales_export, aes(y = provincia, x = pobXmedios, color = categoria)) +
  geom_point(size = 3, alpha = .5) +
  scale_color_manual(values = cores, labels = nomes) +
  scale_x_continuous(labels = function(x){format(x, big.mark = ".")}) +
  labs(y = NULL) +
  theme_bw() +
  theme(text = element_text(family = "Inter"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.border = element_blank(),
        axis.line.x = element_line(),
        axis.text.x = element_text(size = 8),
        legend.position = "none")
