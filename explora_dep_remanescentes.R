library(tidyverse)
library(sf)
library(geojsonsf)

#arg <- read_sf(dsn = "./geo_data/pais", layer = "pais")
arg_dept <- read_sf(dsn = "./geo_data/departamento", layer = "departamento")
sf::st_crs(arg_dept)
arg_prov <- read_sf(dsn = "./geo_data/provincia", layer = "provincia")
locales <- read_sf(dsn = "./geo_data/pais_locales", layer = "pxlocdatos")
depto_censo <- read_sf(dsn = "./geo_data/pais_depto", layer = "pxdptodatosok")
mun_censo <- read_sf(dsn ="./geo_data/ign_municipio", layer = "ign_municipio")
barrios <- read_sf(dsn ="./geo_data/shp_barrios", layer = "barrios_badata")

the_crs <- sf::st_crs(arg_prov)
sf::st_crs(barrios)

mun <- geojson_sf("departamentos.json")



# para ler as tabelas :/ --------------------------------------------------

arg_prov_sem_geom <- arg_prov
sf::st_geometry(arg_prov_sem_geom) <- NULL

mun_sem_geom <- mun
sf::st_geometry(mun_sem_geom) <- NULL


# CABA --------------------------------------------------------------------

caba <- arg_prov %>% filter(nam == "Ciudad Autónoma de Buenos Aires")

a<-st_contains(caba, arg_dept)
depts_inside_caba <- st_intersection(arg_dept, caba)

arg_dept$nam[a[[1]]]

ggplot() + 
  geom_sf(data = caba, fill = "white", color = "black") +
  geom_sf_text(data = depts_inside_caba, aes(label = gid)) +
  geom_sf(data = barrios, fill ="lightpink", alpha = .4, color = "tomato") +
geom_sf(data = depts_inside_caba, fill ="transparent", alpha = .4, color = "hotpink")
  

# PBA ---------------------------------------------------------------------

pba <- arg_prov %>% filter(nam == "Buenos Aires")

depts_inside_pba <- st_intersection(arg_dept, pba)

# para o excel ------------------------------------------------------------

mun_empty <- mun %>%
  filter(sf::st_is_empty(mun))

sf::st_geometry(mun_empty) <- NULL

dept <- arg_dept %>%
  select(nam, gid, geometry)

lista_dept <- dept
sf::st_geometry(lista_dept) <- NULL

write.csv2(lista_dept, "para_comparar_dept.csv")
write.csv2(mun_empty, "para_comparar_mun.csv")

# The problem: argentina's shapefiles do not indicate the province. trying to figure the gid of the missing departments by looking at the map


# Finding capital missiones
ggplot() +
  geom_sf(data = arg_prov %>% filter(nam == "Misiones"), fill =  "darkgrey") +
  geom_sf(data = arg_dept %>% filter(nam == "Capital"), fill = "ghostwhite", color = "hotpink", alpha = .5) +
  geom_sf_text(data = arg_dept %>% filter(nam == "Capital"), aes(label = gid))


# Finding capital mendoza
ggplot() +
  geom_sf(data = arg_prov %>% filter(nam == "Mendoza"), fill =  "darkgrey") +
  geom_sf(data = arg_dept %>% filter(nam == "Capital"), fill = "ghostwhite", color = "hotpink", alpha = .5) +
  geom_sf_text(data = arg_dept %>% filter(nam == "Capital"), aes(label = gid))


# Finding Río Chico
ggplot() +
  geom_sf(data = arg_prov %>% filter(nam %in% c("Santiago del Estero", "Santa Cruz")), fill =  "darkgrey") +
  geom_sf(data = arg_dept %>% filter(nam == "Río Chico"), fill = "ghostwhite", color = "hotpink", alpha = .5) +
  geom_sf_text(data = arg_dept %>% filter(nam == "Río Chico"), aes(label = gid)) +
  geom_sf_label(data = arg_prov %>% filter(nam %in% c("Santiago del Estero", "Santa Cruz")), aes(label = nam))

# Finding Libertador General San Martín, de San Luis

ggplot() +
  geom_sf(data = arg_prov %>% filter(nam == "San Luis"), fill =  "darkgrey") +
  geom_sf(data = arg_dept %>% filter(nam == "Libertador General San Martín"), fill = "ghostwhite", color = "hotpink", alpha = .5) +
  geom_sf_text(data = arg_dept %>% filter(nam == "Libertador General San Martín"), aes(label = gid))

# Finding Capital, de Corrientes

ggplot() +
  geom_sf(data = arg_prov %>% filter(nam == "Corrientes"), fill =  "darkgrey") +
  geom_sf(data = arg_dept %>% filter(nam == "Capital"), fill = "ghostwhite", color = "hotpink", alpha = .5) +
  geom_sf_text(data = arg_dept %>% filter(nam == "Capital"), aes(label = gid)) +
  scale_y_continuous(limits = c(-32, -26))


# Finding Capital, de La Rioja

ggplot() +
  geom_sf(data = arg_prov %>% filter(nam == "La Rioja"), fill =  "darkgrey") +
  geom_sf(data = arg_dept %>% filter(nam == "Capital"), fill = "ghostwhite", color = "hotpink", alpha = .5) +
  geom_sf_text(data = arg_dept %>% filter(nam == "Capital"), aes(label = gid)) +
  scale_y_continuous(limits = c(-32, -26))

# Finding Islas, de Entre Ríos

ggplot() +
  geom_sf(data = arg_prov %>% filter(nam == "Entre Ríos"), fill =  "darkgrey") +
  geom_sf(data = arg_dept %>% filter(str_detect(nam, "Islas")), fill = "ghostwhite", color = "hotpink", alpha = .5) +
  geom_sf_text(data = arg_dept %>% filter(str_detect(nam, "Islas")), aes(label = gid)) +
  scale_y_continuous(limits = c(-35, -30)) +
  scale_x_continuous(limits = c(-65, -55))


# Finding Capital, de Santiago del Estero

ggplot() +
  geom_sf(data = arg_prov %>% filter(nam == "Santiago del Estero"), fill =  "darkgrey") +
  geom_sf(data = arg_dept %>% filter(nam == "Capital"), fill = "ghostwhite", color = "hotpink", alpha = .5) +
  geom_sf_text(data = arg_dept %>% filter(nam == "Capital"), aes(label = gid))


ggplot() +
  geom_sf(data = arg_prov %>% filter(nam == "Santiago del Estero"), fill =  "darkgrey") +
  geom_sf(data = arg_dept %>% filter(str_detect(nam, "Belgrano")), fill = "ghostwhite", color = "hotpink", alpha = .5) +
  geom_sf_text(data = arg_dept %>% filter(str_detect(nam, "Belgrano")), aes(label = gid))


ggplot() +
  geom_sf(data = arg_prov %>% filter(nam == "Santiago del Estero"), fill =  "darkgrey") +
  geom_sf(data = arg_dept %>% filter(str_detect(nam, "Sarmiento")), fill = "ghostwhite", color = "hotpink", alpha = .5) +
  geom_sf_text(data = arg_dept %>% filter(str_detect(nam, "Sarmiento")), aes(label = gid))



# misiones ----------------------------------------------------------------

misiones <- arg_prov %>% filter(nam == "Misiones")

deps_misiones <- st_contains(misiones, arg_dept)
deps_inside_misiones <- st_intersection(arg_dept, misiones)

ggplot(deps_inside_misiones) + geom_sf(fill = 'lavender') + geom_sf_text(aes(label = gid))


# la rioja ----------------------------------------------------------------

prov <- arg_prov %>% filter(nam == "La Rioja")

deps_prov <- st_contains(prov, arg_dept)
deps_inside_prov <- st_intersection(arg_dept, prov)

ggplot(deps_inside_prov) + 
  geom_sf(fill = 'lavender') + 
  geom_sf_text(aes(label = gid))


# la rioja ----------------------------------------------------------------

ggplot(barrios) + geom_sf(fill = 'lavender') + geom_sf_text(aes(label = BARRIO), size = 2)




ggplot(mun_sf3 %>% filter(provincia == 'San Luis')) + geom_sf() + geom_sf_text(aes(label = nam), size = 2)

ggplot(arg_dept %>% filter(str_detect(nam, 'Juan M'))) + geom_sf() + geom_sf_text(aes(label = nam), size = 2)

ggplot(arg_dept %>% filter(nam %in% c('Río Grande', 'Tolhuin', 'Ushuaia'))) + geom_sf()

ggplot(arg_dept %>% filter(nam %in% c('Loncopué', 'Picunches'))) + geom_sf()


# san luis 

san_luis <- prov_sf5 %>% filter(nam == 'San Luis')

depts_inside_san_luis <- st_intersection(arg_dept, san_luis)

names_san_luis <- mun_sf3 %>% filter(provincia == 'San Luis') %>% .$nam

names(names_san_luis) <- NULL
dput(names_san_luis)

# agora compara os nomes com o depts_inside_san_luis para pegar na mão os gid

san_luis_namesXarg_dept_gid <- c("Ayacucho" = 81, "Belgrano" = 188, "Chacabuco" = 502, "Coronel Pringles" = 501, "General Pedernera" = 388, 
  "Gobernador Dupuy" = 41, "Junin" = 390, "Juan M. De Pueyrredon" = 387, "Lib. General San Martin" = 500
)

ggplot(arg_prov %>% filter(nam == 'San Luis')) + geom_sf() + 
  geom_sf(data = depts_inside_san_luis) + 
  geom_sf_text(data = depts_inside_san_luis, aes(label = nam), size = 2)


# la rioja

la_rioja <- prov_sf5 %>% filter(nam == 'La Rioja')

depts_inside_la_rioja <- st_intersection(arg_dept, la_rioja)

names_la_rioja <- mun_sf3 %>% filter(provincia == 'La Rioja') %>% .$nam

names(names_la_rioja) <- NULL
dput(names_la_rioja)

la_rioja_namesXgid <- c("Arauco" = 66, "Castro Barros" = 353, "Chamical" = 65, "Chilecito" = 355, "Famatina" = 361, 
                        "General Belgrano" = 169, "General Lamadrid" = 80, "General San Martín" = 360, 
                        "Independencia" = 63, "Rosario Vera Peñaloza" = 359, "San Blas de los Sauces" = 362, 
                        "Sanagasta" = 354, "Vinchina" = 183, "General Ángel Vicente Peñaloza" = 356, 
                        "General Felipe Varela" = 294, "General Juan Facundo Quiroga" = 358, "General Ortiz de Ocampo" = 64, 
                        "La Rioja (Capital)" = 184)


# missiones

misiones <- prov_sf5 %>% filter(nam == 'Misiones')

depts_inside_misiones <- st_intersection(arg_dept, misiones)

names_misiones <- mun_sf3 %>% filter(provincia == 'Misiones') %>% .$nam

names(names_misiones) <- NULL
dput(names_misiones)

misiones_namesXgid <- c("Apóstoles" = 485, "Cainguás " = 474, "Candelaria " = 473, "Concepción" = 484, "General Manuel Belgrano " = 476, 
                        "Guaraní" = 477, "Iguazú " = 478, "Leandro N. Alem" = 482, "Libertador General San Martín" = 475, 
                        "Montecarlo" = 157, "Oberá" = 480, "San Ignacio" = 481, "San Javier" = 483, "San Pedro" = 159, 
                        "25 de Mayo" = 479, "Capital (Posadas)" = 472, "El Dorado" = 158)

# san juan

san_juan <- prov_sf5 %>% filter(nam == 'San Juan')

depts_inside_san_juan <- st_intersection(arg_dept, san_juan)

names_san_juan <- mun_sf3 %>% filter(provincia == 'San Juan') %>% .$nam

names(names_san_juan) <- NULL
dput(names_san_juan)

names_san_juanXgid <- c("25 de Mayo " = 517, "9 de Julio " = 512, "Albardón" = 513, "Angaco " = 514, "Calingasta" = 519, 
                        "Capital" = 504, "Caucete" = 516, "Chimbas " = 511, "Iglesia " = 520, "Jáchal" = 521, "Pocito " = 508, 
                        "Rawson " = 507, "Rivadavia " = 505, "San Martín" = 515, "Santa Lucía " = 506, "Sarmiento " = 518, 
                        "Ullum" = 510, "Valle Fértil" = 522, "Zonda" = 509)


# catamarca

catamarca <- prov_sf5 %>% filter(nam == 'Catamarca')

depts_inside_catamarca <- st_intersection(arg_dept, catamarca)

names_catamarca <- mun_sf3 %>% filter(provincia == 'Catamarca') %>% .$nam

names(names_catamarca) <- NULL
dput(names_catamarca)

names_catamarcaXgid <- c("Ambato" = 366, "Ancasti" = 198, "Andalgalá" = 365, "Antofagasta de la Sierra" = 222, 
                         "Belén" = 191, "Capayán" = 267, "Capital" = 197, "El Alto" = 369, "Fray Mamerto Esquiú" = 130, 
                         "La Paz" = 74, "Paclín" = 367, "Pomán" = 206, "Santa María" = 71, "Santa Rosa" = 73, 
                         "Tinogasta" = 377, "Valle Viejo" = 489)


#  PBA --------------------------------------------------------------------

pba <- prov_sf5 %>% filter(nam == 'Buenos Aires')
probs_pba <- arg_dept %>% filter(nam %in% c('Avellaneda', "Lanús"))

ggplot(probs_pba) + geom_sf(fill = "khaki") + geom_sf_text(size = 2, aes(label = gid)) +
  geom_sf(data = pba, fill = "transparent", color = "hotpink")

names_pba_gid <- c("Avellaneda" = 494, "Lanús" = 492)



# tucuman

tucuman <- prov_sf5 %>% filter(nam == 'Tucumán')

depts_inside_tucuman <- st_intersection(arg_dept, tucuman)

names_tucuman <- mun_sf3 %>% filter(provincia == 'Tucumán') %>% .$nam

names(names_tucuman) <- NULL
dput(names_tucuman)

names_tucumanXgid <- c("Capital" = 421, "Chicligasta" = 417, "Cruz Alta" = 422, "Famaillá" = 420, "Graneros" = 413, 
                       "La Cocha" = 412, "Leales" = 419, "Lules" = 423, "Monteros" = 418, "Río Chico" = 415, "Simoca" = 416, 
                       "Tafí del Valle" = 428, "Tafí Viejo" = 425, "Trancas" = 427, "Yerba Buena" = 424, "Burruyacú" = 426, 
                       "Juan Bautista Alberdi" = 414)


# salta

salta <- prov_sf5 %>% filter(nam == 'Salta')

depts_inside_salta <- st_intersection(arg_dept, salta)
st_geometry(depts_inside_salta) <- NULL

names_salta <- mun_sf3 %>% filter(provincia == 'Salta') %>% .$nam

names(names_salta) <- NULL
dput(names_salta)

#ggplot(arg_dept %>% filter(nam == "General Güemes")) + geom_sf() + geom_sf_text(aes(label = gid)) + geom_sf(data = arg_prov %>% filter(nam == "Salta"), fill = "transparent", color = "hotpink")

names_saltaXgid <- c("Anta" = 118, "Cachi" = 42, "Cafayate" = 350, "Capital" = 343, "Cerrillos" = 94, "Chicoana" = 43, 
                     "General Güemes" = 50, "General José de San Martín" = 398, "Guachipas" = 347, 
                     "Iruya" = 139, "La Caldera" = 116, "La Candelaria" = 345, "La Poma" = 408, "La Viña" = 44, 
                     "Los Andes" = 141, "Metán" = 46, "Molinos" = 47, "Orán" = 142, "Rivadavia" = 399, "Rosario de la Frontera" = 240, 
                     "Rosario de Lerma" = 400, "San Carlos" = 51, "Santa Victoria" = 397)



# cordoba

cordoba <- prov_sf5 %>% filter(nam == 'Córdoba')

depts_inside_cordoba <- st_intersection(arg_dept, cordoba)
st_geometry(depts_inside_cordoba) <- NULL

names_cordoba <- mun_sf3 %>% filter(provincia == 'Córdoba') %>% .$nam

names(names_cordoba) <- NULL
dput(names_cordoba)

ggplot(arg_dept %>% filter(nam == "General San Martín")) + geom_sf() + geom_sf_text(aes(label = gid)) + geom_sf(data = arg_prov %>% filter(nam == "Córdoba"), fill = "transparent", color = "hotpink")

names_cordobaXgid <- c("Calamuchita" = 384, "Capital" = 221, "Colón " = 357, "Cruz del Eje" = 85, "General Roca" = 114, 
  "General San Martín" = 374, "Ischilín" = 372, "Juárez Celman" = 342, "Marcos Juárez" = 378, 
  "Minas" = 88, "Pocho" = 529, "Presidente Roque Sáenz Peña" = 112, "Punilla " = 86, 
  "Río Cuarto" = 95, "Río Primero" = 376, "Río Seco" = 185, "Río Segundo" = 90, "San Alberto" = 89, 
  "San Javier" = 375, "San Justo" = 91, "Santa María" = 87, "Sobremonte" = 207, "Tercero Arriba" = 93, 
  "Totoral " = 373, "Tulumba" = 84, "Unión" = 92)
