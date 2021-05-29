library(tidyverse)
library(readxl)

informes <- read_xlsx('./data/Informes.xlsx', sheet = 'transposto')

html <- ""

for (i in 1:nrow(informes)) {
  
  atual <- informes[i,]
  
  print(atual$provincia)
  
  result <- paste(sep = '\n',
                  paste0('<div data-provincia-informe="', atual$provincia, '" aria-hidden="true">'),
                  paste0('  <article', ifelse(!is.na(atual$id), paste0(' id="', atual$id, '">'), '>')),
                  '    <header>',
                  '       <h2>',
                  paste0('        <span class="retranca-informe">', atual$chapeu, '</span>'),
                  paste0('        ', atual$titulo),
                  '       </h2>',
                  paste0('       <p class="lead-informe">', atual$lead, '</p>'),
                  paste0('       <p class="investigator">', atual$credito, '</p>'),
                  '    </header>',
                  ifelse(!is.na(atual$p1),
                         paste0('    <p>', atual$p1, '</p>'), ''),
                  ifelse(!is.na(atual$p2),
                         paste0('    <p>', atual$p2, '</p>'), ''),
                  ifelse(!is.na(atual$p3),
                         paste0('    <p>', atual$p3, '</p>'), ''),
                  ifelse(!is.na(atual$p4),
                         paste0('    <p>', atual$p4, '</p>'), ''),
                  ifelse(!is.na(atual$p5),
                         paste0('    <p>', atual$p5, '</p>'), ''),
                  ifelse(!is.na(atual$p6),
                         paste0('    <p>', atual$p6, '</p>'), ''),
                  ifelse(!is.na(atual$p7),
                         paste0('    <p>', atual$p7, '</p>'), ''),
                  ifelse(!is.na(atual$p8),
                         paste0('    <p>', atual$p8, '</p>'), ''),
                  ifelse(!is.na(atual$p9),
                         paste0('    <p>', atual$p9, '</p>'), ''),
                  ifelse(!is.na(atual$p10),
                         paste0('    <p>', atual$p10, '</p>'), ''),
                  ifelse(!is.na(atual$p11),
                         paste0('    <p>', atual$p11, '</p>'), ''),
                  '  </article>',
                  '</div>'
                  
  )
  
  html <- paste(sep = '\n', html, result)
  
}

write_file(html, 'informes.html')             
             
