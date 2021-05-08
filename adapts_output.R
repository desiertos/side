library(tidyverse)
library(sf)
library(geojsonsf)
library(jsonlite)
library(data.table)

mun <- jsonlite::read_json("../data/output/municipios.json")

muns <- list()

for (i in 1:421) {
  
  df <- mun[["features"]][[i]][["properties"]] %>% 
    unlist() %>%
    as.data.frame()
  
  if (nrow(df) == 9) {
      
      df["relacion_poblacion_residente/medios",1] <- NA
      df["relacion_poblacion_residente/periodistas",1] <- NA
      
  }
  
  if (nrow(df) == 7) {
    
    df["relacion_poblacion_residente/medios",1] <- NA
    df["relacion_poblacion_residente/periodistas",1] <- NA
    df["cantidad_de_medios",1] <- NA
    df["cantidad_de_periodistas",1] <- NA
    
  }
  
  variable_names <- rownames(df)
  df_t <- df %>% data.table::transpose()
  
  names(df_t) <- variable_names
  
  muns[[i]] <- df_t
}

municipios_transp <- data.frame(do.call(rbind, muns))

names_var <- names(mun[["features"]][[1]][["properties"]])

names(municipios_transp) <- names_var

localidad <- municipios_transp %>%
  rename(local = 1)




# provincia ---------------------------------------------------------------


prov <- jsonlite::read_json("../data/output/provincias.json")

provs <- list()

for (i in 1:13) {
  
  df <- prov[["features"]][[i]][["properties"]] %>% 
    unlist() %>%
    as.data.frame()
  
  variable_names <- rownames(df)
  df_t <- df %>% data.table::transpose()

  names(df_t) <- variable_names
  
  provs[[i]] <- df_t
}

provincias <- provs %>% bind_rows()

#provs[[1]]

names_var_prov <- names(prov[["features"]][[1]][["properties"]])

names(provincias) <- names_var_prov

provincias_export <- provincias %>%
  rename(local = 1)


# lista locais ------------------------------------------------------------

lista_muns <- localidad %>%
  mutate(
    tipo = 'localidad',
    text = paste0(local, " (", provincia, ")" )
  ) %>%
  select(local, tipo, provincia, text)

lista_prov <- provincias_export %>%
  mutate(
    tipo = 'provincia',
    text = paste0(local, " (Provincia)")
  ) %>%
  select(local, tipo, text)

locais <- bind_rows(lista_muns, lista_prov)



# output ------------------------------------------------------------------

output <- list(
  
  localidad = localidad,
  provincia = provincias_export,
  lista_locais = locais
  
)

write_json(output, 'output2.json')
