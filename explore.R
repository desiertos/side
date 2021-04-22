library(tidyverse)
library(ggbeeswarm)
library(extrafont)
loadfonts()

cores <- c("1" = "#D77E5B", "2" = "#E1BA9B", "3" = "#CEBF74", "4" = "#7C9A68")
nomes <- c("1" = "Desiertos", "2" = "Semidesiertos", "3" = "Semibosques", "4" = "Bosques")

provincias <- readxl::excel_sheets("./data/provincias.xlsx")

datos <- list()

for (prov in provincias) {

  dados <- readxl::read_excel("./data/provincias.xlsx", sheet = prov) %>%
    mutate(provincia = prov) %>%
    mutate_at(.vars = vars(-Departamento, -provincia), .funs = ~as.numeric(.)) %>%
    mutate(`Categoría` = as.character(`Categoría`))
  
  datos[[prov]] <- dados
  
}

dados_consolidados <- datos %>% bind_rows()

dados_sumarizados <- dados_consolidados %>%
  group_by(provincia) %>%
  mutate(media_provincia = ifelse(row_number() == 1, mean(`Relación Población residente/medios`, na.rm = TRUE), NA)) %>%
  ungroup()

ggplot(dados_sumarizados, aes(y = provincia, x = `Relación Población residente/medios`)) +
  geom_tile(aes(x = media_provincia), width = 20) +
  geom_vline(xintercept = mean(dados_sumarizados$`Relación Población residente/medios`, na.rm = TRUE), size = .5, linetype = "dotted", color = "gray") +
  geom_quasirandom(groupOnX = FALSE, aes(color = `Categoría`), size = 2) +
  scale_x_continuous(limits = c(NA, 40e3), labels = function(x){format(x, big.mark = ".")}) +
  scale_color_manual(values = cores, labels = nomes) +
  labs(y = NULL, color = NULL) +
  theme_bw() +
  theme(text = element_text(family = "Inter"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.border = element_blank(),
        axis.line.x = element_line(),
        axis.text.x = element_text(size = 8),
        legend.position = "top")

ggsave("./plots/beeswarm.png", plot=last_plot(), width = 6, height = 4.5)

salta <- dados_sumarizados %>% 
  filter(provincia == "Salta") %>%
  mutate(
    media_provincia = mean(`Relación Población residente/medios`, na.rm = TRUE),
    media_nacional  = mean(dados_sumarizados$`Relación Población residente/medios`))
    


ggplot(salta, aes(y = Departamento, x = `Relación Población residente/medios`)) +
  geom_col(fill = "lavender") + 
  geom_vline(xintercept = mean(salta$`Relación Población residente/medios`, na.rm = TRUE), size = .5, linetype = "dotted", color = "purple") +
  geom_vline(xintercept = mean(dados_sumarizados$`Relación Población residente/medios`, na.rm = TRUE), size = .5, linetype = "dotted", color = "gray") +
  scale_x_continuous(labels = function(x){format(x, big.mark = ".")}) +
  scale_color_manual(values = cores, labels = nomes) +
  labs(y = NULL, color = NULL) +
  expand_limits(y = 0, x = 0) +
  theme_bw() +
  theme(text = element_text(family = "Inter"),
        panel.grid =element_blank(),
        panel.border = element_blank(),
        axis.line.x = element_line(),
        axis.text.x = element_text(size = 8),
        axis.ticks.y = element_blank(),
        legend.position = "top") 
