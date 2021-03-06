# Um milhão (talvez um pouco menos) de coisas aleatórias relacionadas ao desenvolvimento do projeto

https://www.fopea.org/

Figma: https://www.figma.com/file/9tjXVWYgSJLKOECbWsW1r0/Desiertos-Informativos-de-la-Argentina?node-id=101%3A985

Notion: 

https://www.notion.so/Roteiro-para-introdu-o-explicativa-e3522d603f164ae68279ab80f9294b3b

https://www.notion.so/Resumen-de-informaciones-en-el-dashboard-81701429043d4f7fb288ed1bd664a2af

## to-do protótipo

[x] gerar lista de locais
[ ] usar style de satélite
[ ] tela de busca está confusa
[ ] nomes locais planilhas x shapefiles
[ ] mensagem de erro para quando valor da busca é inválido
[ ] tirar valores de autocompletar da busca?


## to-do conceitual

[ ] video Mapbox x Greensock
[ ] mascara

## to-do dashboard

[x] throttling mousemove events? (outra solução na verdade)
[ ] labels mapa
[x] avoid re-rendering if selection is the currentplace
[ ] mudar para grid
[x] separation lines
[x] labelchros min max stripplot
[ ] oportunidades de melhoria da performance. se está gerando o mesmo gráfico para o mesmo tipo de local, não precisa regerar as escalas, por exemplo.
[ ] trocar nomes 'province' para 'provincia'
[ ] force-layout
[ ]


[ ] usar o mesmo polígono para a máscara e para as províncias, para se encaixarem direitinho


!!! Refatorar código do render_selected_place, e do highlight_feature (que hoje é só "centraliza feature")


Pode ser útil para o "dashboard"
https://docs.mapbox.com/mapbox-gl-js/example/offset-vanishing-point-with-padding/

Ler:
https://web.dev/variable-fonts/
https://chartability.fizz.studio/

https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/search
https://developer.mozilla.org/en-US/docs/Web/HTML/Element/datalist



## Proposta

https://www.notion.so/Propuesta-de-visualizaci-n-de-datos-desiertos-de-noticias-en-Argentina-001e7890915941c383da597579698c40

## Mapas / Shapefiles

Shapefiles: https://www.ign.gob.ar/NuestrasActividades/InformacionGeoespacial/CapasSIG
Opção: Polígono, Provincia

https://datos.gob.ar/dataset/ign-unidades-territoriales/archivo/ign_01.02.02

(Priscilla, RSpatial_ES)
Las unidades territoriales pueden ser descargadas desde varios portales oficiales como IGN, datos.gob.ar o el iel INDEC (instituto nacional de estadística y censos de Argentina).  El INDEC tiene una pagina todavia desponible para descargar poligonos de las unidades territoriales que se usaron en el censo 2010  y usan su propia definicion de atributos. SE puede reconstruiresa relacion provincia departamento que buscas  a partir del shp de departamentos  https://sitioanterior.indec.gob.ar/codgeo.asp  . Tambien podes encontrar listada esa relacion de codigos de indec aqui   https://redatam.indec.gob.ar/redarg/CENSOS/CPV2010A/Docs/codigos_provincias.pdf

## Mapbox

Bem o que eu estava procurando, Mapbox e Greensock, no Learn with Jason:
https://www.youtube.com/watch?v=BY59_8jMrbg&list=PLz8Iz-Fnk_eTpvd49Sa77NiF8Uqq5Iykx&index=111

Otimizar GeoJson
https://docs.mapbox.com/help/troubleshooting/working-with-large-geojson-data/
geojson-pick to remove unused properties 
geojson-precision to limit the number of decimal places for coordinates

https://docs.mapbox.com/help/troubleshooting/mapbox-gl-js-performance/

https://blog.mapbox.com/how-the-pudding-team-uses-mapbox-4b5b8577001f

### Hillshade

https://blog.mapbox.com/realistic-terrain-with-custom-styling-ce1fe98518ab
https://docs.mapbox.com/mapbox-gl-js/example/hillshade/
https://blog.mapbox.com/mapbox-cali-terrain-style-bea8cd410523
https://github.com/mzdraper/maptime-mapbox-parks/blob/master/Beginner/beginner.md


### 3D

https://blog.mapbox.com/3d-mapping-global-population-density-how-i-built-it-141785c91107
Change type to fill-extrusion.

## Accessibility

https://www.w3.org/WAI/WCAG21/Techniques/aria/ARIA8.html

Per the Accessible Name and Description Computation and the HTML to Platform Accessibility APIs Implementation Guide, the aria-label text will override the text supplied within the link. As such the text supplied will be used instead of the link text by AT. Due to this it is recommended to start the text used in aria-label with the text used within the link. This will allow consistent communication between users.

https://a11y.coffee/quick-wins/
https://www.a11yproject.com/checklist/
https://www.deque.com/blog/accessible-aria-buttons/

https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Roles/Tab_Role


## CLI Cartography

https://mapshaper.org/
https://medium.com/@mbostock/command-line-cartography-part-1-897aa8f8ca2c

## Ideias

Animação
http://assets.eli.wtf/talks/animation-talk-webu-2018/#

ANimation to provide a "mental map of what's out of view"
http://assets.eli.wtf/talks/animation-talk-webu-2018/#/49

Comparar vegetação real x vegetação de notícias
https://docs.mapbox.com/mapbox-gl-js/example/mapbox-gl-compare/

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
https://docs.mapbox.com/mapbox-gl-js/style-spec/layers/

Here I did a small exploration tool with tooltips
https://github.com/epicenter-usa/side/blob/master/mapbox_experiments/test-manhattan.html

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

app.map_obj.queryRenderedFeatures({ layers: ['my-layer-name'] });

// gera lista das layers (pega os ids de cada feature e filtra a primeira ocorrência de cada)
app.map_obj.queryRenderedFeatures()
  .map(d => d.layer.id)
  .filter((d,i,a) => i == a.indexOf(d));

// all style layers
app.map_obj.getStyle().layers;

// get Features from a given layer

dash.map_obj.querySourceFeatures(type, {sourceLayer: type})

// or

app.map_obj.queryRenderedFeatures({layers : ['localidad']})

```

Move layers

```js

// puts "provinces" behind "road-label"
app.map_obj.moveLayer("provinces", "road-label")
```

```js
// highlights provincia border
app.map.province.toggle_highlight_border_provincia('San Luis');
```

Para ver os valores amarrados a cada elemento de uma seleção:

```js
d3.selectAll('circle').each(function(d) { console.log(d3.select(this).datum().x)})

d3.selectAll('circle').each(function(d) { 

  let node = d3.select(this);  
  let dat = d3.select(this).datum();
  
  console.log(dat.x, node.attr('cx'), dat.y, node.attr('cy'))

  
})
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

### Shapefiles treatment

Read shapefiles, simplified, exported to geojson with a 6-digit precision, but the file was still too large.

Then uploaded it to mapshaper, simplified it there (12%) and exported to geojson.

# Guidelines

Add a step by adding the corresponding div in the markup, and the corresponding property in app.scroller.render.

# Making Of

A Fernanda perguntando no grupo de plantas sobre os cactos da Argentina.

O artigo do Matt sobre 3D.

It is really important to have in mind the structure of the features array, and of the man objects with which we deal.

Frio na barriga quando vi o protótipo da Fernanda.



### applicação js

O resultado da busca dispara um succesful_result
O resultado do clique também

os campos a preencher têm sempre uma mesma classe, e um data atribute "data-text_field". o valor desse text_field corresponde às chaves de dash.vis.location_card.text_field, onde constam funções que retrieve a informação em questão do local apropriado.

a vantagem de usar this é que se o componente está bem fechado e definido, é mais fácil movê-lo de um lado para o outro.

no próprio monitor de click de províncias, já chama o highlight

## bizarrices encontradas

```js
let tipos = ["a", "b"]

let data = [{name: "tiago"}, {name: "melissa"}]

data_double = [];

tipos.forEach(tipo => {

  let data_temp = [...data];

  data_temp.forEach(d => {
    d['tipo'] = tipo;
  })
  
  data_double.push(...data_temp)
})

// data_double
// (4) [{…}, {…}, {…}, {…}]
// 0:
// name: "tiago"
// tipo: "b"
// __proto__: Object
// 1:
// name: "melissa"
// tipo: "b"
// __proto__: Object
// 2:
// name: "tiago"
// tipo: "b"
// __proto__: Object
// 3:
// name: "melissa"
// tipo: "b"

```

Todos ficaram com tipo "b"! Alguma loucura de referência aí. Corrigi fazendo uma cópia do elemento primeiro:

```js
let tipos = ["a", "b"]

let data = [{name: "tiago"}, {name: "melissa"}]

data_double2 = [];

tipos.forEach(tipo => {

  let data_temp = [...data];

  data_temp.forEach(d => {

    new_d = {...d};

    new_d['tipo'] = tipo;

    data_double2.push(new_d);

  })
  
})

```


## d3 maps

argentina
```js

d3.geoTransverseMercator().center([2.5, -38.5]).rotate([66, 0]).scale((height * 56.5) / 33).translate([(width / 2), (height / 2)]);

d3.geoTransverseMercator().center([2.5, -38.5]).rotate([66, 0]).scale((590 * 56.5) / 33).translate([(460 / 2), (590 / 2)]);
```

1. Projection

```bash

geoproject 'd3.geoTransverseMercator().center([2.5, -38.5]).rotate([66, 0]).scale((590 * 56.5) / 33).translate([(460 / 2), (590 / 2)])' < provincias.json > provincias_1proj.json

geoproject 'd3.geoTransverseMercator().center([2.5, -38.5]).rotate([66, 0]).scale((590 * 56.5) / 33).translate([(460 / 2), (590 / 2)])' < municipios.json > municipios_1proj.json

```

2. convert to ndjson

```bash

ndjson-split 'd.features' \
  < provincias_1proj.json \
  > provincias_2proj.ndjson

ndjson-split 'd.features' \
  < municipios_1proj.json \
  > municipios_2proj.ndjson

```

3. convert to topojson

```bash
geo2topo -n \
  provincia=provincias_2proj.ndjson \
  localidad=municipios_2proj.ndjson \
  > argentina_3topo.json

```

4. simplify

```bash
toposimplify -p 1 -f \
  < argentina_3topo.json \
  > argentina_4topo_simp.json

```
5. quantize

```bash
topoquantize 1e5 \
  < argentina_4topo_simp.json \
  > argentina.json
```


reflections

always keep at hand an element from the data, so you don't lose time trying to remember its structure, variable names etc.




dash.map_obj.on('click', 'provincia', dash.map.province.click_event_handler);

                    // como tem o layer aqui, dá para no handler pegar o e.features!


                                // handler_click_event : function(e) {

            //     let features = dash.map_obj.queryRenderedFeatures(
            //         e.point, 
            //         //{ layers: ['provincia'] });
            //         { layers: ['provincia', 'localidad'] });
    
            //     if (features.length) {
    
            //         let type = features[0].layer.id;
    
            //         if (type == 'provincia') type = 'province';
    
            //         console.log("Clicked on a", type, ". Detalhes: ", features, e);
    
            //         dash.map[type].click_event_handler(features[0]);
    
            //     }
    
            // },


```js
                app.map_obj.addSource('localidad', {
                    type: 'geojson',
                    'data' : app.data.localidad
                });

                app.map_obj.addLayer({
                    'id': 'localidad',
                    'type': 'circle',
                    'source': 'localidad',
                    'layout': {},
                    'paint': {
                      'circle-color': ['get', 'color_real'],
                      'circle-opacity': 0.5,
                      'circle-stroke-color' : ['get', 'color_real'],
                      'circle-stroke-width' : 1,
                      'circle-stroke-opacity' : 1,
                      'circle-radius' : [
                            'let',
                            'sqrt_pob',
                            ['sqrt', ['to-number', ['get', 'pob'] ] ],

                            [
                                'interpolate', ['linear'], ['zoom'],

                                3, [
                                    'interpolate', ['linear'],
                                    ['var', 'sqrt_pob'],
                                    //0, 0,
                                    Math.sqrt(app.data.min_pob), 2,
                                    Math.sqrt(app.data.max_pob), 15
                                ],

                                12, [
                                    'interpolate', ['linear'],
                                    ['var', 'sqrt_pob'],
                                    //0, 0,
                                    Math.sqrt(app.data.min_pob), 6,
                                    Math.sqrt(app.data.max_pob), 45
                                ]
                                
                            ]
                        ]
                    }
                }, 'road-label'); // puts behind road-label

```

local: "iguazu_Misiones"
provincia: "Misiones"
text: "Iguazú  (Misiones)"
tipo: "localidad"


ant_medios: "1"
cant_periodistas: "2"
categoria: "1"
codpcia: "54"
departamento/municipio/barrio: "Iguazú "
index: 8
local: "iguazu_Misiones"
nam: "Iguazú "
nome_local: "iguazu"
pob: "82227"
pobXmedios: "82227"
pobXperiodistas: "41113.5"
provincia: "Misiones"
randId: 9
tipo_entidade: "departamento"


## Problems with Names, Municipalities

eldorado -> El dorado
Burrayacú -> Burruyacú
Río Chico (Santa Cruz del Estero) -> ?

na verdade, dados de Santiago e Santa Cruz estão trocados.

Os que estão como Santiago viram Santa Cruz
Os que estão como Santa Cruz, excluem-se.
Adiciona os de Santiago
Faz o join com o shape de deptos.
Adiciona Villa General Mitre

## Informes

Catamarca



## Melhorias

criar referencias aos objetos em si, para não ficar repetindo os querySelector

## Aprendizados

às vezes vc acha que vai dar tempo de refatora, reorganizar... mas não dá. então é melhor já fazer bem-feito desde o começo.

eu deveria ter construído cada módulo como um arquivo JS independente. e depois juntava tudo, para evitar acabar com duas versões de cada coisa. mesmo para o css.



<a href="https://twitter.com/share?ref_src=twsrc%5Etfw" class="twitter-share-button" data-show-count="false">Tweet</a><script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>


options.preserveDrawingBuffer
boolean
default: false

If true , the map's canvas can be exported to a PNG using map.getCanvas().toDataURL() . This is false by default as a performance optimization.


https://developer.mozilla.org/en-US/docs/Web/HTML/Element/a#using_the_download_attribute_to_save_a_%3Ccanvas%3E_as_a_png


mostrar a importância de se conhecer a estrutura dos dados

dash.data.localidad.features[0].properties

a ideia da camada que vai ser ativada por filtro...


"sticky hover on mobile"
https://stackoverflow.com/questions/17233804/how-to-prevent-sticky-hover-effects-for-buttons-on-touch-devices

3/6/2021 -- em PG. orgulhoso da versão mobile e do filtro de categoria.


para pegar um bosque na visao do mapa
let locs = app.map_obj.queryRenderedFeatures({layers : ['localidad']})
locs.filter(d => d.properties.categoria == "4")


alerta de bruxaria!!!!
string.normalize('NFD').replace(/[\u0300-\u036f]/g, "")


tippecanoe -zg -o localidad.mbtiles -l localidad --coalesce-densest-as-needed --extend-zooms-if-still-dropping dep.json

tippecanoe -zg -o provincia.mbtiles -l provincia --coalesce-densest-as-needed --extend-zooms-if-still-dropping prov2.json

Mapbox como cancelar um processamento?
como fazer hover num layer composite?

dash.map_obj.getStyle().layers


https://blog.mapbox.com/going-live-with-electoral-maps-a-guide-to-feature-state-b520e91a22d

--generate-ids

tippecanoe -zg -o localidad.mbtiles -l localidad --coalesce-densest-as-needed --extend-zooms-if-still-dropping --generate-ids dep_raw.json

tippecanoe -zg -o provincia.mbtiles -l provincia --coalesce-densest-as-needed --extend-zooms-if-still-dropping --generate-ids prov_raw.json


mudando o nome do layer no studio, muda no GL tb.

map.featureSetState o source-layer tem que ser sourceLayer


https://developers.facebook.com/tools/debug


mapbox://styles/tiagombp/ckpcy0bxc0jru18o6eskk8r8u
https://api.mapbox.com/styles/v1/tiagombp/ckpcy0bxc0jru18o6eskk8r8u/static/pin-s+555555(-59.6985,-36.7913)/[-63.3927,-41.0454,-56.664,-33.2669]/300x200?access_token=pk.eyJ1IjoidGlhZ29tYnAiLCJhIjoiY2thdjJmajYzMHR1YzJ5b2huM2pscjdreCJ9.oT7nAiasQnIMjhUB-VFvmw

https://api.mapbox.com/styles/v1/tiagombp/ckpcy0bxc0jru18o6eskk8r8u/static/pin-s+555555(-59.6985,-36.7913)/[-63.3927,-41.0454,-56.664,-33.2669]/300x200?access_token=pk.eyJ1IjoidGlhZ29tYnAiLCJhIjoiY2thdjJmajYzMHR1YzJ5b2huM2pscjdreCJ9.oT7nAiasQnIMjhUB-VFvmw


https://api.mapbox.com/styles/v1/tiagombp/ckpcy0bxc0jru18o6eskk8r8u/static/pin-l+212121(-59.6985,-36.7913)/[-63.3927,-41.0454,-56.664,-33.2669]/900x600?access_token=pk.eyJ1IjoidGlhZ29tYnAiLCJhIjoiY2thdjJmajYzMHR1YzJ5b2huM2pscjdreCJ9.oT7nAiasQnIMjhUB-VFvmw



https://developer.mozilla.org/en-US/docs/Web/HTML/CORS_enabled_image



para destacar sem usar borda e aumentar o tamanho: box-shadow: inset 0px 0px 0 2px;