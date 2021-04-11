library(tidyverse)
library(magick)

caminho <- "./icons/"

icons <- list.files(path = caminho)

tipos <- c("tipo1", "tipo2", "tipo3", "tipo4")

tiger <- image_read_svg(paste0(caminho, icons[5]), width = 60)

start <- 4 # para começar do 5 elemento (florestinhas), use 4

# arvores usei 8
# florestinhas usei 40

for (i in 1:4) {
  img <- image_read_svg(paste0(caminho, icons[i+start]), width = 40)
  image_write(img, path = paste0(caminho,tipos[i], ".png"), format = "png")
  print(paste("Writing image ", i, "... com o nome ", tipos[i]))
}
