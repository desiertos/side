library(tidyverse)
library(gganimate)
library(ggbeeswarm)

load("downloads.RData")

# mini_exploration --------------------------------------------------------

cores <- c("1" = "#D27B51", 
           "2" = "#DAB28D", 
           "3" = "#EEC471", 
           "4" = "#99A860")

ggplot(deptos_out, aes(x = as.numeric(pobXmedios), y = as.numeric(pobXperiodistas), color = categoria)) +
  geom_point(alpha = .7) +
  geom_point(data = categorias, shape = 21) +
  scale_color_manual(values = cores) +
  facet_wrap(~categoria)

ggplot(deptos_out, aes(y = as.numeric(pobXperiodistas), color = categoria, x = 1)) +
  geom_quasirandom() +
  geom_point(data = categorias, shape = 21, x = 0.8) +
  scale_color_manual(values = cores)

ggplot(deptos_out, aes(x = as.numeric(cant_medios), y = as.numeric(cant_periodistas), color = categoria)) +
  geom_point(alpha = .7) +
  scale_color_manual(values = cores) +
  scale_x_log10() +
  scale_y_log10() +
  facet_wrap(~categoria)

ggplot(deptos_out, aes(x = as.numeric(cant_medios), y = as.numeric(cant_periodistas), color = categoria)) +
  geom_point(alpha = .7) +
  scale_color_manual(values = cores) +
  scale_x_log10() +
  scale_y_log10() +
  gganimate::transition_states(categoria)

