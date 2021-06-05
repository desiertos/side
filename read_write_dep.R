library(tidyverse)
library(sf)
library(geojsonsf)
library(jsonlite)

colors <- c(
  "1" = "#D27B51",
  "2" = "#DAB28D", 
  "3" = "#EEC471",
  "4" = "#99A860")

arg_dept <- read_sf(dsn = "./geo_data/departamento", layer = "departamento")
arg_prov <- read_sf(dsn = "./geo_data/provincia", layer = "provincia")
caba <- read_sf(dsn ="./geo_data/shp_barrios", layer = "barrios_badata")

the_crs <- sf::st_crs(arg_prov)

#mun <- geojson_sf("departamentos.json")
prov <- geojson_sf("../data/output/provincias.json")

# setando na mão o crs
#mun <- sf::st_set_crs(mun, 5343)
prov <- sf::st_set_crs(prov, 5343)

#mun_sf <- sf::st_transform(mun, the_crs)
prov_sf <-  sf::st_transform(prov, the_crs)
arg_dept <- sf::st_transform(arg_dept, the_crs)
caba_sf <- sf::st_transform(caba, the_crs)
#arg_dept <- st_simplify(arg_dept, preserveTopology = TRUE, dTolerance = .1)

mun_sf <- readRDS('mun_completo.rds')


provincia_convert = c(
  "misiones" = "Misiones", 
  "tierra_del_fuego" = "Tierra del Fuego, Antártida e Islas del Atlántico Sur", 
  "santiago_del_estero" = "Santiago del Estero", 
  "cordoba" = "Córdoba",
  "la_pampa" = "La Pampa", 
  "formosa" = "Formosa", 
  "santa_cruz" = "Santa Cruz", 
  "tucuman" = "Tucumán", 
  "chaco" = "Chaco", 
  "san_luis" = "San Luis", 
  "catamarca" = "Catamarca", 
  "rio_negro" = "Río Negro", 
  "salta" = "Salta", 
  "neuquen" = "Neuquén", 
  "corrientes" = "Corrientes", 
  "ciudad_autonoma_de_buenos_aires" = "Ciudad Autónoma de Buenos Aires",
  "buenos_aires" = "Buenos Aires", 
  "chubut" = "Chubut", 
  "jujuy" = "Jujuy", 
  "santa_fe" = "Santa Fe", 
  "la_rioja" = "La Rioja", 
  "entre_rios" = "Entre Ríos", 
  "san_juan" = "San Juan", 
  "mendoza" = "Mendoza")

prov_sf2 <- prov_sf %>%
  mutate(nam = provincia_convert[provincia],
         local = nam)

bboxes <- data.frame()

for (i in 1:nrow(prov_sf2)) {
  bbox <- st_bbox(prov_sf2[i,])
  bboxes[i,"nam"] <- prov_sf2[i, "nam"]
  
  for (name in names(bbox)) {
    bboxes[i,name] <- bbox[[name]]
  }
}

prov_sf3 <- prov_sf2 %>%
  left_join(bboxes, by = 'nam') %>%
  rename(pob = poblacion_total,
         cant_medios = cantidad_de_medios,
         cant_periodistas = cantidad_de_periodistas,
         pobXmedios = `relacion_poblacion_residente/medios`,
         pobXperiodistas = `relacion_poblacion_residente/periodistas`) %>%
  mutate(pob = as.numeric(pob))

# this centroid will be useful to place province labels
centr_prov <- sf::st_centroid(prov_sf3)

for (i in 1:nrow(centr_prov)) {
  
  prov_sf3[i, 'xc'] <- centr_prov$geometry[[i]][1]
  prov_sf3[i, 'yc'] <- centr_prov$geometry[[i]][2]
  
}
  

mun_sf2 <- mun_sf %>%
  mutate(provincia = provincia_convert[provincia],
         nam = `departamento/municipio/barrio`,
         randId = row_number(),
         local = paste(nome_local, provincia, sep = '_'),
         color_real = colors[categoria]) %>%
  left_join(bboxes, by = c('provincia' = 'nam')) %>%
  rename(pob = poblacion_residente,
         cant_medios = cantidad_de_medios,
         cant_periodistas = cantidad_de_periodistas,
         pobXmedios = `relacion_poblacion_residente/medios`,
         pobXperiodistas = `relacion_poblacion_residente/periodistas`)
  # fixes

mun_sf2[mun_sf2$provincia == 'Formosa' & mun_sf2$nam == 'Patiño', 'categoria'] <- "1"
mun_sf2[mun_sf2$provincia == 'Santa Fe' & mun_sf2$nam == 'La Capital', 'nam'] <- "Capital"

centr <- sf::st_centroid(mun_sf2)

for (i in 1:nrow(centr)) {
  
  mun_sf2[i, 'xc'] <- centr$geometry[[i]][1]
  mun_sf2[i, 'yc'] <- centr$geometry[[i]][2]
  
}

# entre rios data changed later
entre_rios_corr <- readxl::read_excel('./data/entre_rios_corregido.xlsx')
col_names_entre_rios <- colnames(entre_rios_corr)[-1]

for ( i in 1:nrow(entre_rios_corr) ) {
  
  linha <- which(
    mun_sf2$nam == stringr::str_trim(entre_rios_corr[i, 'nam'])
    & mun_sf2$provincia == 'Entre Ríos')
  
  for ( col in col_names_entre_rios ) {
    
    print(paste(linha, col))
    
    mun_sf2[linha, col] <- entre_rios_corr[i, col]
    
  }
  
}


# update categories count -------------------------------------------------

cat_variables <- data.frame(
  categoria = c("1", "2", "3", "4"),
  variables = c("deserts_count", "semideserts_count", "semiforests_count", "forests_count")
)

mun_df <- mun_sf2
st_geometry(mun_df) <- NULL

cat_count_prov <- mun_df %>%
  group_by(provincia) %>%
  count(categoria) %>%
  left_join(cat_variables) %>%
  select(-categoria) %>%
  spread(variables, n) %>%
  mutate_at(vars(ends_with('_count')), ~replace_na(., 0)) %>%
  rename(nam = provincia)

# some problems with subtotals

subtotals_prov <- mun_df %>%
  group_by(provincia) %>%
  summarise_at(
    .vars = vars(pob, cant_medios, cant_periodistas),
    .funs = ~sum(as.numeric(.), na.rm = T)
  ) %>%
  ungroup()

#join with prov data

prov_sf4 <- prov_sf3 %>%
  select(-ends_with('_count')) %>%
  left_join(cat_count_prov)

# fixes

# o ideal aqui era fazer um join com os subtotais.

fix_pob <- c(
  'Chubut' = 509108,
  'Jujuy' = 673307,
  'Neuquén' = 551266,
  'Río Negro' = 638645,
  'Tucumán' = 1448188)

fix_cant_medios <- c(
  'Chubut' = 63,
  'Entre Ríos' = 104
)

fix_cant_periodistas <- c(
  'Chubut' = 407,
  'Entre Ríos' = 463
)

prov_sf5 <- prov_sf4 %>%
  mutate(
    pob = ifelse(nam %in% names(fix_pob),
                 fix_pob[nam],
                 pob),
    cant_medios = ifelse(nam %in% names(fix_cant_medios),
                         fix_cant_medios[nam],
                         cant_medios),
    cant_periodistas = ifelse(nam %in% names(fix_cant_periodistas),
                              fix_cant_periodistas[nam],
                              cant_periodistas)
  )


# fixes to localities

mun_sf3 <- mun_sf2 %>%
  mutate(nam = ifelse(provincia == 'San Luis',
                      str_to_title(nam, locale = 'es'),
                      nam))

#https://www.ign.gob.ar/NuestrasActividades/Geografia/DatosArgentina/Poblacion2

# provv <- prov_sf
# st_geometry(provv) <- NULL


# geometry fixes ----------------------------------------------------------

# tierra del fuego
to_fix_tierra <- c('Río Grande', 'Tolhuin', 'Ushuaia')

for (nam in to_fix_tierra) {
  
  linha <- which(
    mun_sf3$nam == nam & mun_sf3$provincia == 'Tierra del Fuego, Antártida e Islas del Atlántico Sur')
  
  linha_dept <- which(arg_dept$nam == nam)
  
  mun_sf3[linha, 'geometry'] <- arg_dept[linha_dept, 'geometry']

}

# test
# ggplot(mun_sf3 %>% filter(provincia == 'Tierra del Fuego, Antártida e Islas del Atlántico Sur')) + geom_sf()

# Neuquén

to_fix_neuquen <- c('Loconpué', 'Picunches')

for (nam in to_fix_neuquen) {
  
  linha <- which(
    mun_sf3$nam == nam & mun_sf3$provincia == 'Neuquén')
  
  
  linha_dept <- which(arg_dept$nam == ifelse(nam == 'Loconpué', 'Loncopué', nam))
  
  print(paste(linha, linha_dept))
  
  mun_sf3[linha, 'geometry'] <- arg_dept[linha_dept, 'geometry']
  
}

#test
#ggplot(mun_sf3 %>% filter(provincia == 'Neuquén')) + geom_sf()

# San Luis

san_luis_namesXarg_dept_gid <- c("Ayacucho" = 81, "Belgrano" = 188, "Chacabuco" = 502, "Coronel Pringles" = 501, "General Pedernera" = 388, 
                                 "Gobernador Dupuy" = 41, "Junin" = 390, "Juan M. De Pueyrredon" = 387, "Lib. General San Martin" = 500
)

depts_san_luis <- mun_sf3 %>% filter(provincia == 'San Luis') %>% .$nam

for (dept in depts_san_luis) {
  
  linha_mun <- which(
    mun_sf3$nam == dept & mun_sf3$provincia == 'San Luis')
  
  gid = san_luis_namesXarg_dept_gid[dept]
  
  linha_dept <- which(arg_dept$gid == gid)
  
  print(paste(linha_mun, linha_dept))
  
  mun_sf3[linha_mun, 'geometry'] <- arg_dept[linha_dept, 'geometry']
  
}

# La Rioja

la_rioja_namesXgid <- c("Arauco" = 66, "Castro Barros" = 353, "Chamical" = 65, "Chilecito" = 355, "Famatina" = 361, 
                        "General Belgrano" = 169, "General Lamadrid" = 80, "General San Martín" = 360, 
                        "Independencia" = 63, "Rosario Vera Peñaloza" = 359, "San Blas de los Sauces" = 362, 
                        "Sanagasta" = 354, "Vinchina" = 183, "General Ángel Vicente Peñaloza" = 356, 
                        "General Felipe Varela" = 294, "General Juan Facundo Quiroga" = 358, "General Ortiz de Ocampo" = 64, 
                        "La Rioja (Capital)" = 184)

depts_la_rioja <- mun_sf3 %>% filter(provincia == 'La Rioja') %>% .$nam

for (dept in depts_la_rioja) {
  
  linha_mun <- which(
    mun_sf3$nam == dept & mun_sf3$provincia == 'La Rioja')
  
  gid = la_rioja_namesXgid[dept]
  
  linha_dept <- which(arg_dept$gid == gid)
  
  print(paste(linha_mun, linha_dept))
  
  mun_sf3[linha_mun, 'geometry'] <- arg_dept[linha_dept, 'geometry']
  
}

# misiones

misiones_namesXgid <- c("Apóstoles" = 485, "Cainguás " = 474, "Candelaria " = 473, "Concepción" = 484, "General Manuel Belgrano " = 476, 
                        "Guaraní" = 477, "Iguazú " = 478, "Leandro N. Alem" = 482, "Libertador General San Martín" = 475, 
                        "Montecarlo" = 157, "Oberá" = 480, "San Ignacio" = 481, "San Javier" = 483, "San Pedro" = 159, 
                        "25 de Mayo" = 479, "Capital (Posadas)" = 472, "El Dorado" = 158)

depts_misiones <- mun_sf3 %>% filter(provincia == 'Misiones') %>% .$nam

for (dept in depts_misiones) {
  
  linha_mun <- which(
    mun_sf3$nam == dept & mun_sf3$provincia == 'Misiones')
  
  gid = misiones_namesXgid[dept]
  
  linha_dept <- which(arg_dept$gid == gid)
  
  print(paste(linha_mun, linha_dept))
  
  mun_sf3[linha_mun, 'geometry'] <- arg_dept[linha_dept, 'geometry']
  
}

# San Juan

names_san_juanXgid <- c("25 de Mayo " = 517, "9 de Julio " = 512, "Albardón" = 513, "Angaco " = 514, "Calingasta" = 519, 
                        "Capital" = 504, "Caucete" = 516, "Chimbas " = 511, "Iglesia " = 520, "Jáchal" = 521, "Pocito " = 508, 
                        "Rawson " = 507, "Rivadavia " = 505, "San Martín" = 515, "Santa Lucía " = 506, "Sarmiento " = 518, 
                        "Ullum" = 510, "Valle Fértil" = 522, "Zonda" = 509)

depts_san_juan <- mun_sf3 %>% filter(provincia == 'San Juan') %>% .$nam

for (dept in depts_san_juan) {
  
  linha_mun <- which(
    mun_sf3$nam == dept & mun_sf3$provincia == 'San Juan')
  
  gid = names_san_juanXgid[dept]
  
  linha_dept <- which(arg_dept$gid == gid)
  
  print(paste(linha_mun, linha_dept))
  
  mun_sf3[linha_mun, 'geometry'] <- arg_dept[linha_dept, 'geometry']
  
}

# Catamarca

names_catamarcaXgid <- c("Ambato" = 366, "Ancasti" = 198, "Andalgalá" = 365, "Antofagasta de la Sierra" = 222, 
                         "Belén" = 191, "Capayán" = 267, "Capital" = 197, "El Alto" = 369, "Fray Mamerto Esquiú" = 130, 
                         "La Paz" = 74, "Paclín" = 367, "Pomán" = 206, "Santa María" = 71, "Santa Rosa" = 73, 
                         "Tinogasta" = 377, "Valle Viejo" = 489)

depts_catamarca <- mun_sf3 %>% filter(provincia == 'Catamarca') %>% .$nam

for (dept in depts_catamarca) {
  
  linha_mun <- which(
    mun_sf3$nam == dept & mun_sf3$provincia == 'Catamarca')
  
  gid = names_catamarcaXgid[dept]
  
  linha_dept <- which(arg_dept$gid == gid)
  
  print(paste(linha_mun, linha_dept))
  
  mun_sf3[linha_mun, 'geometry'] <- arg_dept[linha_dept, 'geometry']
  
}

#ggplot(mun_sf3 %>% filter(provincia == 'Catamarca')) + geom_sf()

# tucuman

names_tucumanXgid <- c("Capital" = 421, "Chicligasta" = 417, "Cruz Alta" = 422, "Famaillá" = 420, "Graneros" = 413, 
                       "La Cocha" = 412, "Leales" = 419, "Lules" = 423, "Monteros" = 418, "Río Chico" = 415, "Simoca" = 416, 
                       "Tafí del Valle" = 428, "Tafí Viejo" = 425, "Trancas" = 427, "Yerba Buena" = 424, "Burruyacú" = 426, 
                       "Juan Bautista Alberdi" = 414)

depts_tucuman <- mun_sf3 %>% filter(provincia == 'Tucumán') %>% .$nam

for (dept in depts_tucuman) {
  
  linha_mun <- which(
    mun_sf3$nam == dept & mun_sf3$provincia == 'Tucumán')
  
  gid = names_tucumanXgid[dept]
  
  linha_dept <- which(arg_dept$gid == gid)
  
  print(paste(linha_mun, linha_dept))
  
  mun_sf3[linha_mun, 'geometry'] <- arg_dept[linha_dept, 'geometry']
  
}

#ggplot(mun_sf3 %>% filter(provincia == 'Tucumán')) + geom_sf()


# CABA

dput(mun_df %>% filter(provincia == "Ciudad Autónoma de Buenos Aires") %>% .$nam)

# aqui fui plotando um por cima do outro e vendo no mapa interativo os nomes dos bairros, e ia acrescentando bairros nesta lista
caba_to_fix <- c("Barracas", "Belgrano", "Boca", "Caballito", "Colegiales", "Nueva Pompeya", "Nuñez", "Palermo", "Parque Patricios", "Paternal", "Puerto Madero", "Recoleta", "Retiro", "Villa Crespo", "Villa Soldati")

caba_sf_to_fix <- caba_sf %>%
  filter(str_to_title(BARRIO) %in% caba_to_fix) %>%
  mutate(BARRIO = str_to_title(BARRIO))

for (barrio in caba_to_fix) {
  
  print(barrio)
  
  linha_mun <- which(
    mun_sf3$nam == barrio & mun_sf3$provincia == 'Ciudad Autónoma de Buenos Aires')
  
  linha_caba <- which(caba_sf_to_fix$BARRIO == barrio)
  
  print(paste(linha_mun, linha_caba))
  
  mun_sf3[linha_mun, 'geometry'] <- caba_sf_to_fix[linha_caba, 'geometry']
  
}

#comparar

ggplot(mun_sf3 %>% filter(provincia == 'Ciudad Autónoma de Buenos Aires')) +
  geom_sf(data = caba_sf, fill = 'yellow') +
  geom_sf(fill = "lightpink")

ggplot() + geom_sf(data = caba_sf, fill = 'yellow')

# PBA

names_pba_gid <- c("Avellaneda" = 494, "Lanús" = 492)


for (dept in names(names_pba_gid)) {
  
  print(dept)
  
  linha_mun <- which(
    mun_sf3$nam == dept & mun_sf3$provincia == 'Buenos Aires')
  
  gid = names_pba_gid[dept]
  
  linha_dept <- which(arg_dept$gid == gid)
  
  print(paste(linha_mun, linha_dept))
  
  mun_sf3[linha_mun, 'geometry'] <- arg_dept[linha_dept, 'geometry']
  
}

# San Luis province geometry

# fix Loncopué
linha_loncopue <- which(mun_sf3$`departamento/municipio/barrio` == "Loconpué")
mun_sf3[linha_loncopue, "departamento/municipio/barrio"] <- 'Loncopué'
mun_sf3[linha_loncopue, "nam"] <- 'Loncopué'
mun_sf3[linha_loncopue, "nome_provincia"] <- 'loncopue_neuquen'
mun_sf3[linha_loncopue, "local"] <- 'loncopue_Neuquén'
mun_sf3[linha_loncopue, "nome_local"] <- 'loncopue'

# linha_burruyacu <- which(mun_sf3$`departamento/municipio/barrio` == "Burrayacú")
# mun_sf3[linha_burruyacu, "departamento/municipio/barrio"] <- 'Burruyacú'
# mun_sf3[linha_burruyacu, "nam"] <- 'Burruyacú'
# mun_sf3[linha_burruyacu, "nome_provincia"] <- 'burruyacu_tucuman'
# mun_sf3[linha_burruyacu, "local"] <- 'burruyacu_Tucumán'
# mun_sf3[linha_burruyacu, "nome_local"] <- 'burruyacu'



# provinces geometries ----------------------------------------------------

for (i in 1:nrow(arg_prov)) {
  
  provincia_atual <- arg_prov$nam[i]
  print(provincia_atual)
  
  linha_em_prov_sf5 <- which(prov_sf5$nam == provincia_atual)
  
  prov_sf5[linha_em_prov_sf5, 'geometry'] <- arg_prov[i, 'geometry']
  
}


# mask argentina ----------------------------------------------------------


argentina <- prov_sf5 %>% group_by() %>% summarise()

#ggplot(argentina) + geom_sf()

world <- geojson_sf("./geo_data/world.json")

world <- st_transform(world, the_crs)

arg_mask <- sf::st_difference(world, argentina)


#ggplot(prov_geometries_from_depts) + geom_sf()

# write files out ---------------------------------------------------------

arg_mask_geo <- geojsonsf::sf_geojson(arg_mask, digits = 6)
write_file(arg_mask_geo, "../desiertos.github.io/data/maps/arg_mask.geojson")

mun_geo <- geojsonsf::sf_geojson(mun_sf3, digits = 6)
#prov_geo <- geojsonsf::sf_geojson(prov_sf, digits = 6)

write_file(mun_geo, '../desiertos.github.io/data/maps/dep.json')
#write_file(prov_geo, "./geo_data/d3/prov_.geojson")

prov_geo <- geojsonsf::sf_geojson(prov_sf5, digits = 6)
#prov_geo <- geojsonsf::sf_geojson(prov_sf, digits = 6)

write_file(prov_geo, '../desiertos.github.io/data/maps/prov2.json')
#write_file(prov_geo, "./geo_data/d3/prov_.geojson")



# lista

mun_names <- data.frame(
  local = mun_sf3$local, 
  provincia = mun_sf3$provincia,
  text = paste0(mun_sf3$nam, " (", mun_sf3$provincia, ")"),
  name = mun_sf3$nam,
  tipo = 'localidad') %>%
  arrange(text)

prov_names <- data.frame(
  local = prov_sf5$nam,
  provincia = prov_sf5$nam,
  name = prov_sf5$nam,
  text = prov_sf5$nam,
  tipo = 'provincia') %>%
  arrange(text)

municipios_transformados <- readxl::read_excel('./data/dados_desertos_municipios_departamentos_lista.xlsx')

teste <- unique(c(municipios_transformados$Provincia, mun_names$provincia))

lista_mun <- municipios_transformados %>%
  rename(provincia = Provincia, name = Departamento) %>%
  filter(provincia != name) %>%
  #filter(provincia == "Rí́o Negro")
  left_join(mun_names) %>%
  mutate(text = paste(Municipio, text, sep = ", ")) %>%
  select(-Municipio)

#lista_mun %>% filter(is.na(local))

lista_locais <- bind_rows(lista_mun, mun_names, prov_names) %>%
  arrange(name)
#%>%
#   mutate(
#     text = ifelse(text == "Ciudad Autónoma de Buenos Aires", "Ciudad Autónoma de Buenos Aires - CABA", text)
#   )


# output ------------------------------------------------------------------

# medios
medios_prototipicos <- read.csv('./data/medios_prototipicos.csv')
lista_prov <- prov_sf5 %>% arrange(nam) %>% .$nam
medios_prototipicos$nam <- lista_prov
medios_prototipicos <- medios_prototipicos %>% select(
  provincia = 3,
  desc = 2
)

mun_out <- mun_sf3
sf::st_geometry(mun_out) <- NULL



prov_out <- prov_sf5
sf::st_geometry(prov_out) <- NULL

output_dash <- list(
  'localidad' = mun_out,
  'provincia' = prov_out,
  'lista_locais' = lista_locais,
  'medios_prototipicos' = medios_prototipicos
)

# interessante, se usar o <- ali em cima, ele ignora os nomes e gera uma array com as 3 arrays, em vez de um objeto com as 3 arrays.

jsonlite::write_json(output_dash, '../desiertos.github.io/data/output_dash.json')



# other outputs -----------------------------------------------------------

ranking <- cat_count_prov %>% 
  janitor::adorn_percentages() %>%
  arrange(desc(deserts_count)) %>%
  mutate(semidesert_start = deserts_count,
         semiforest_start = deserts_count + semideserts_count,
         forests_start = deserts_count + semideserts_count + semiforests_count)

jsonlite::write_json(ranking, '../desiertos.github.io/data/ranking.json')

sum(as.numeric(prov_out$cant_medios), na.rm = T) == sum(as.numeric(mun_out$cant_medios), na.rm = T)
sum(as.numeric(prov_out$cant_periodistas), na.rm = T) == sum(as.numeric(mun_out$cant_periodistas), na.rm = T)

provincias_download <- medios_prototipicos %>%
  left_join(prov_out, by = c("provincia" = "nam")) %>%
  select(
    provincia,
    pob = populacion_en_areas_recenseadas,
    cant_medios,
    cant_periodistas,
    bosques = forests_count,
    semibosques = semiforests_count,
    semidesiertos = semideserts_count,
    desiertos = deserts_count,
    medios_prototipico = desc
    ) %>%
  mutate(
    departamentos = bosques + semibosques + semidesiertos + desiertos)
  
mun_out %>% count(provincia) %>% .$n ==
provincias_download$departamentos

write.csv2(provincias_download, "provincias.csv", fileEncoding = 'UTF-8')

deptos_out <- mun_out %>%
  select(
    departamento = 1,
    provincia,
    categoria,
    pob,
    cant_medios,
    cant_periodistas,
    pobXmedios,
    pobXperiodistas)

max(as.numeric(mun_out$pobXmedios) - as.numeric(mun_out$pob) / as.numeric(mun_out$cant_medios), na.rm = T)

write.csv2(deptos_out, "departamentos.csv", fileEncoding = 'UTF-8')

categorias_qde <- mun_out %>%
  count(categoria)

nomes_categorias <- c("1" = "Desiertos", "2" = "Semidesiertos", "3" = "Semibosques", "4" = "Bosques")

categorias <- mun_out %>%
  group_by(categoria) %>%
  summarise_at(
    .vars = vars(pob, cant_medios, cant_periodistas),
    .funs = ~sum(as.numeric(.), na.rm = T)
  ) %>%
  ungroup() %>%
  left_join(categorias_qde) %>%
  rename(cant_departamentos = n) %>%
  mutate(
    pobXmedios = as.numeric(pob) / as.numeric(cant_medios),
    pobXperiodistas = as.numeric(pob) / as.numeric(cant_periodistas)) %>%
  mutate(
    categoria_desc = nomes_categorias[categoria], .after = categoria
  )

write.csv2(categorias, "categorias.csv", fileEncoding = 'UTF-8')

save(deptos_out, provincias_download, categorias, file = "downloads.RData")