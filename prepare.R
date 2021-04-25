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

datos_cidades_cons <- datos_cidades %>% 
  bind_rows() %>%
  mutate(cidade = str_to_title(cidade))



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
  left_join(categorias_medias)


# lista locais ------------------------------------------------------------

lista_locais <- bind_rows(
  
  datos_cidades_cons %>% 
    select(localidade = cidade) %>%
    mutate(tipo = "Departamento"),
  
  provincias %>%
    select(localidade = provincia) %>%
    mutate(tipo = "Provincia")
) %>%
  mutate(
    text = paste0(localidade, " (", tipo, ")")
  ) %>%
  arrange(text)

# output object -----------------------------------------------------------

output <- list(
  "cidades" = datos_cidades_cons,
  "provincias" = provincias,
  "stats" = list(
    "provincias" = stats_provincias,
    "nacional"   = stats_nacionais
  ),
  "lista_locais" = lista_locais
)

jsonlite::write_json(output, "output.json")
