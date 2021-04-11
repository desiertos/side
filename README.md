# Um milhão (talvez um pouco menos) de coisas aleatórias relacionadas ao desenvolvimento do projeto

https://www.fopea.org/

## to-do

[ ] video Mapbox x Greensock
[ ] mascara

Pode ser útil para o "dashboard"
https://docs.mapbox.com/mapbox-gl-js/example/offset-vanishing-point-with-padding/

Ler:
https://web.dev/variable-fonts/



## Proposta

https://www.notion.so/Propuesta-de-visualizaci-n-de-datos-desiertos-de-noticias-en-Argentina-001e7890915941c383da597579698c40

## Mapas / Shapefiles

Shapefiles: https://www.ign.gob.ar/NuestrasActividades/InformacionGeoespacial/CapasSIG
Opção: Polígono, Provincia

## Mapbox


Bem o que eu estava procurando, Mapbox e Greensock, no Learn with Jason:
https://www.youtube.com/watch?v=BY59_8jMrbg&list=PLz8Iz-Fnk_eTpvd49Sa77NiF8Uqq5Iykx&index=111

Otimizar GeoJson
https://docs.mapbox.com/help/troubleshooting/working-with-large-geojson-data/
geojson-pick to remove unused properties 
geojson-precision to limit the number of decimal places for coordinates

https://docs.mapbox.com/help/troubleshooting/mapbox-gl-js-performance/

### 3D

https://blog.mapbox.com/3d-mapping-global-population-density-how-i-built-it-141785c91107
Change type to fill-extrusion.

## CLI Cartography

https://mapshaper.org/
https://medium.com/@mbostock/command-line-cartography-part-1-897aa8f8ca2c

## Ideias

Animação
http://assets.eli.wtf/talks/animation-talk-webu-2018/#

ANimation to provide a "mental map of what's out of view"
http://assets.eli.wtf/talks/animation-talk-webu-2018/#/49

## Inspiration

### US

https://www.cislm.org/what-exactly-is-a-news-desert/
https://www.cislm.org/2018-report-the-expanding-news-desert/
https://www.cislm.org/unc-media-hub-examines-n-c-news-deserts/
https://www.cislm.org/resources/report/the-rise-of-a-new-media-baron/
https://www.cislm.org/wp-content/uploads/2016/10/Abernathy_full.pdf
https://www.poynter.org/locally/2020/unc-news-deserts-report-2020/
https://en.wikipedia.org/wiki/News_desert
https://www.usnewsdeserts.com/
https://www.usnewsdeserts.com/states-main/
https://www.usnewsdeserts.com/states/colorado/#1591292034492-8808d6e0-1270 (nice that they have a "who owns your newspaper?" section)

### Brazil

https://www.atlas.jor.br/docs/Atlas_da_Not%C3%ADcia-jornais_online-resultados.pdf
https://www.em.com.br/app/noticia/politica/2019/12/12/interna_politica,1107743/deserto-de-noticias-afeta-37-milhoes-de-brasileiros.shtml
http://www.observatoriodaimprensa.com.br/atlas-da-noticia/70-milhoes-de-brasileiros-vivem-em-deserto-de-noticias/
https://www.atlas.jor.br/desertos-de-noticia/

### France

https://www.franceinter.fr/emissions/l-instant-m/l-instant-m-05-decembre-2018
https://www.lagazettedescommunes.com/681861/la-crise-risque-de-reduire-le-pluralisme-de-la-presse-locale-cyrille-frank-directeur-de-lesj-pro-paris/


# Referência

## Mapbox

map.getStyle().sources
map.getStyle().layers
map.getCenter()
map.getZoom()

https://docs.mapbox.com/mapbox-gl-js/style-spec/expressions/
https://docs.mapbox.com/mapbox-gl-js/api/map/#map
https://docs.mapbox.com/studio-manual/guides/

#### Patterns

Using an imagem as a fill-pattern to a polygon.
https://docs.mapbox.com/mapbox-gl-js/example/fill-pattern/

https://docs.mapbox.com/mapbox-gl-js/style-spec/layers/#paint-fill-fill-pattern
For seamless patterns, image width and height must be a factor of two (2, 4, 8, ..., 512). 

https://docs.mapbox.com/mapbox-gl-js/api/map/#map#addimage

Sprite
https://docs.mapbox.com/help/glossary/sprite/


## App utilities

It is really important to have in mind the structure of the features array.

Gets a given property from 'provinces' dataset:

```js
app.data.provinces.features.map(d => d.properties.gid);
```

List names of provinces

```js
app.data.provinces.features.map(d => d.properties.nam)
```

Change properties of a given layer

```js
app.map_obj.setPaintProperty("provinces", "fill-outline-color", "ghostwhite")
```

Get rendered features, get layers

```js
app.map_obj.queryRenderedFeatures();

// gera lista das layers (pega os ids de cada feature e filtra a primeira ocorrência de cada)
app.map_obj.queryRenderedFeatures()
  .map(d => d.layer.id)
  .filter((d,i,a) => i == a.indexOf(d));

// all style layers
app.map_obj.getStyle().layers;

```

Move layers

```js

// puts "provinces" behind "road-label"
app.map_obj.moveLayer("provinces", "road-label")
```

## R

magick
https://cran.r-project.org/web/packages/magick/vignettes/intro.html

```r
caminho <- "./icons/"

icons <- list.files(path = caminho)

tipos <- c("tipo1", "tipo2", "tipo3", "tipo4")

start <- 0 # para começar do 5 elemento, use 4

for (i in 1:4) {
  img <- image_read_svg(paste0(caminho, icons[i+start]), width = 60)
  image_write(img, path = paste0(caminho,tipos[i], ".png"), format = "png")
  print(paste("Writing image ", i, "... com o nome ", tipos[i]))
}
```

# Guidelines

Add a step by adding the corresponding div in the markup, and the corresponding property in app.scroller.render.

# Making Of

A Fernanda perguntando no grupo de plantas sobre os cactos da Argentina.

O artigo do Matt sobre 3D.

It is really important to have in mind the structure of the features array, and of the man objects with which we deal.