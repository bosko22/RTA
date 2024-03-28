# https://www.acarcinom.org.au/
# https://takechargeregistry.com/canine-cancer-interactive-us-map/
# https://rstudio.github.io/bslib/articles/theming/
# https://cran.r-project.org/web/packages/bslib/bslib.pdf
# https://unleash-shiny.rinterface.com/beautify-with-bootstraplib

library(here)
library(tidyverse)
library(fst)
library(shiny)
library(shinyjs)
library(shinyWidgets)
library(bslib)
library(DT)
library(plotly)

library(leaflet)
library(sf)
# library(htmltools)
# library(htmlwidgets)

link_shiny <- tags$a(
  shiny::icon("github"), "Shiny",
  href = "https://github.com/rstudio/shiny",
  target = "_blank"
)
link_posit <- tags$a(
  shiny::icon("r-project"), "Posit",
  href = "https://posit.co",
  target = "_blank"
)

# comuni <- sf::st_read("https://raw.githubusercontent.com/openpolis/geojson-italy/master/geojson/limits_IT_municipalities.geojson")
# comuniBO <- subset(comuni, comuni$prov_name == "Bologna")
# provinceER <- subset(province, province$reg_name == "Emilia-Romagna")
# regioneER <- subset(regioni, regioni$reg_name == "Emilia-Romagna")

comuni <- sf::st_read(here("data","tidy", "comuniBO.shp"))
# maxLong = max(comuni$xmax)
# maxLat = max(comuni$ymax)
# minLong = min(comuni$xmin)
# minLat = min(comuni$ymin)

comuni <- comuni %>% 
  
  rename(
    casi_totali = cas_Ttl,
    casi_cane = casi_Cn,
    lon_centroid = ln_cntr,
    lat_centroid = lt_cntr
    )


dtBO <- fst::read_fst(here("data", "tidy", "dtBO.fst"))

# assignInNamespace(
#   "collapse_icon", 
#   function() {
#     bsicons::bs_icon(
#       "chevron-double-down", class = "collapse-icon", size = NULL
#     ) 
#   },
#   ns = "bslib"
# )


# https://stackoverflow.com/questions/49072510/r-add-title-to-leaflet-map
tag.map.title <- tags$style(HTML("
  .leaflet-control.map-title { 
  /*  transform: translate(-50%,20%); */
  /*  position: fixed !important; */
  /*  left: 50%; */
  text-align: center;
  padding-left: 10px; 
  padding-right: 10px; 
  border: 1px black solid;
  border-radius: 10px;
  background: rgba(255,255,255,0.75);
  font-weight: bold;
  font-family: Montserrat;
  font-size: 18px;
  }
"))

title <- tags$div(
  tag.map.title, HTML("PROVINCIA DI BOLOGNA")
)  
