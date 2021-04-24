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

colunas <- c("cidade", "pob", "cant_medios", "cant_periodistas", "pobXmedios", "pobXperiodistas", "categoria", "provincia")

datos_cidades <- list()

for (prov in names_provincias) {

  dados <- readxl::read_excel(file_cidades, sheet = prov) %>%
    mutate(provincia = prov) %>%
    mutate_at(.vars = vars(-Departamento, -provincia), .funs = ~as.numeric(.)) %>%
    mutate(`Categoría` = as.character(`Categoría`))
  
  names(dados) <- colunas
  
  datos_cidades[[prov]] <- dados
  
}

datos_cidades_cons <- datos_cidades %>% bind_rows()


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


# output object -----------------------------------------------------------

output <- list(
  "cidades" = datos_cidades_cons,
  "stats" = list(
    "provincias" = stats_provincias,
    "nacional"   = stats_nacionais
  )
)

jsonlite::write_json(output, "output.json")
