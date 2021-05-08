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

variable_names <- rownames(municipios_transp)

municipios <- municipios_transp %>%
  data.table::transpose()
  
names(municipios) <- variable_names

muns[[1]] %>% values()

for (i in 1:421) { if (nrow(muns[[i]]) != 11) {print(i)}}
