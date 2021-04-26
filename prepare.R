library(tidyverse)
library(ggbeeswarm)
library(extrafont)
library(jsonify)
loadfonts()

cores <- c("1" = "#D77E5B", "2" = "#E1BA9B", "3" = "#CEBF74", "4" = "#7C9A68")
nomes <- c("1" = "Desiertos", "2" = "Semidesiertos", "3" = "Semibosques", "4" = "Bosques")


# cidades -----------------------------------------------------------------

file_cidades <- "./data/cidades.xlsx"

names_provincias <- readxl::excel_sheets(file_cidades)

colunas <- c("local", "pob", "cant_medios", "cant_periodistas", "pobXmedios", "pobXperiodistas", "categoria", "provincia")

datos_cidades <- list()

for (prov in names_provincias) {

  dados <- readxl::read_excel(file_cidades, sheet = prov) %>%
    mutate(provincia = prov) %>%
    mutate_at(.vars = vars(-Departamento, -provincia), .funs = ~as.numeric(.)) %>%
    mutate(`Categoría` = as.character(`Categoría`))
  
  names(dados) <- colunas
  
  datos_cidades[[prov]] <- dados
  
}

datos_cidades_cons <- datos_cidades %>% 
  bind_rows() %>%
  mutate(local = str_to_title(local))



# stats provincias -------------------------------------------------------

stats_provincias <- datos_cidades_cons %>%
  group_by(provincia) %>%
  summarise_if(is.numeric, list(
    'mean' = ~mean(., na.rm = T),
    'min' = ~min(., na.rm = T),
    'max' = ~max(., na.rm = T)))


# stats nacionais ---------------------------------------------------------

stats_nacionais <- datos_cidades_cons %>%
  mutate(nacional = "nacional") %>%
  group_by(nacional) %>%
  summarise_if(~is.numeric(.), list(
    'mean' = ~mean(., na.rm = T),
    'min' = ~min(., na.rm = T),
    'max' = ~max(., na.rm = T)))


# provincias --------------------------------------------------------------

file_provincias <- "./data/provincias.xlsx"

provincias_raw <- readxl::read_excel(file_provincias)

categorias_medias <- datos_cidades_cons %>%
  group_by(provincia) %>%
  summarise(cat_media = mean(as.integer(categoria)))

provincias <- provincias_raw %>%
  rename(provincia = Provincia) %>%
  left_join(stats_provincias) %>%
  left_join(categorias_medias) %>%
  rename(local = provincia)


# lista locais ------------------------------------------------------------

lista_locais <- bind_rows(
  
  datos_cidades_cons %>%
    filter(provincia %in% c("Salta", "San Luis")) %>%
    select(local, provincia) %>%
    mutate(tipo = "cidade"),
  
  provincias %>%
    select(local) %>%
    mutate(tipo = "provincia",
           provincia = local)
) %>%
  mutate(
    text = paste0(local, " (", ifelse(local == "Capital", provincia, tipo), ")")
  ) %>%
  arrange(text)

# output object -----------------------------------------------------------
bboxes <- readRDS('bboxes.rds')

datos_cidades_export <- datos_cidades_cons %>%
  filter(provincia %in% c('San Luis', 'Salta')) %>%
  mutate(name_lower = str_to_lower(local))%>%
  left_join(
    bboxes %>% 
      mutate(name_lower = str_to_lower(nam))
    )
  

output <- list(
  "cidade" = datos_cidades_export,
  "provincia" = provincias,
  "stats" = list(
    "provincias" = stats_provincias,
    "nacional"   = stats_nacionais
  ),
  "lista_locais" = lista_locais
)

jsonlite::write_json(output, "output.json")


