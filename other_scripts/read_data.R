library(tidyverse)
library(readxl)

path <- './data/original_data'

files <- list.files(path = path)

data_raw <- list()

nomes <- c("categ", "resp", "perfil")

# initializes lists that will receive the data within data_raw list
for (nome in nomes) {
  data_raw[[nome]] <- list()
}

# read data

read_data <- function(file, nome) {
  
  print(paste(file, nome))
  
  filepath <- paste0(path, '/', file)
  
  detect_name <- str_detect(readxl::excel_sheets(path = filepath), fixed(nome, ignore_case=TRUE))
  sheet_name <- readxl::excel_sheets(path = filepath)[detect_name]
  
  df <- read_excel(path = filepath, sheet = sheet_name, range = cell_cols("A:G"))
  
  if (nome == "categ") {
    df <- df %>%
      mutate_at(.vars = -1, .funs = ~as.numeric(.))
    
    names(df) <- c(names(df)[1], "pop", "ctd_meios", "ctd_periodistas", "popXmeios", "popXperiodistas", "categoria")
    
    # padronizar DEPARTAMENTO, departamento etc.
  }
  
  return(df)
  
}

for (nome in nomes) {
  
  data_raw[[nome]] <- purrr::map(files, read_data, nome)
    
}
  
categ <- bind_rows(data_raw[["categ"]])

categ <- 
file_categ <- readxl::excel_sheets(path = paste0(path, '/', files[1]))[categ]


# had to change neuquen and salta sheet name for "respuestas" by hand
