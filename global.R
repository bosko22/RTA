# https://www.acarcinom.org.au/
# https://takechargeregistry.com/canine-cancer-interactive-us-map/
# https://rstudio.github.io/bslib/articles/theming/
# https://cran.r-project.org/web/packages/bslib/bslib.pdf
# https://unleash-shiny.rinterface.com/beautify-with-bootstraplib
# https://www.w3schools.com/bootstrap4/bootstrap_utilities.asp


# PLOTLY MODAL
# https://stackoverflow.com/questions/57369827/show-modal-onclick-plotly-bar-plot
# https://forum.posit.co/t/show-modal-onclik-plotly-bar-plot/35168/4

library(here)
library(tidyverse)
library(readxl)
library(fst)
library(shiny)
library(shinyjs)
library(shinyWidgets)
library(bslib)
library(htmltools)
library(DT)
library(gt)
library(plotly)


library(leaflet)
library(sf)
library(htmltools)
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

diagnosi <- read_excel(here("data", "raw", "codici_diagnosi.xlsx")) %>% 
  janitor::clean_names() %>% 
  mutate(categoria = str_to_sentence(categoria))

gt_diagnosi <- fst::read_fst(here("data", "tidy", "gt_diagnosi.fst"))


# comuni <- sf::st_read("https://raw.githubusercontent.com/openpolis/geojson-italy/master/geojson/limits_IT_municipalities.geojson")
# comuniBO <- subset(comuni, comuni$prov_name == "Bologna")
# provinceER <- subset(province, province$reg_name == "Emilia-Romagna")
# regioneER <- subset(regioni, regioni$reg_name == "Emilia-Romagna")


comuni <- sf::st_read(here("data","tidy", "comuniBO.shp"))
# maxLong = max(comuni$xmax)
# maxLat = max(comuni$ymax)
# minLong = min(comuni$xmin)
# minLat = min(comuni$ymin)

# mappacap <- sf::st_read(here("data","tidy", "capBO.shp"))


comuni <- comuni %>% 
  rename(
    # casi_totali = cas_Ttl,
    casi_cane = casi_Cn,
    lon_centroid = ln_cntr,
    lat_centroid = lt_cntr
    )

# mappacap <- mappacap %>% 
#   left_join(comuni %>% 
#               as.data.frame() %>% 
#               select(comune_1, casi_cane),
#             join_by(comune_1))

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
  border-radius: 4px;
  background: rgba(255,255,255,0.75);
  font-weight: bold;
  font-family: Montserrat;
  font-size: 18px;
  cursor:default;
  }
"))

title <- tags$div(
  tag.map.title, HTML("PROVINCIA DI BOLOGNA")
)  


# # https://datatables.net/blog/2015-04-10
# # https://github.com/DataTables/Plugins/tree/master/features/pageResize
# # https://github.com/DataTables/Plugins/blob/master/features/pageResize/dataTables.pageResize.js
# # https://stackoverflow.com/questions/72169187/r-shiny-making-datatable-columns-manuallly-resizable
dep <- htmlDependency(
  name = "PageResize",
  version = "1.1.0",
  src = normalizePath("./www"),
  script = "dataTables.pageResize.js",
  # stylesheet = "jquery.dataTables.colResize.css",
  all_files = FALSE
)


# jscode.autoHeightDT <- '
#   autoHeightDT = function() {
#     var offset = 100; // pixels used for other elements like title, buttons, etc
# 
#     // compute the number of rows to show in window
#     var n = Math.floor(($(window).height() - offset) / $("#vet tr").height());
# 
#     // set the new number of rows in table
#     t = $("#vet .dataTable").DataTable().page.len(n).draw();
#   }
# 
#   // to adjust the height when the app starts, it will wait 0.8 seconds
#   setTimeout(autoHeightDT, 800);
# 
#   // to react to changes in height of window 
#   $(window).resize(function() {
#     autoHeightDT();
#   });
# 
# '

conditional <- function(condition, success) {
  if (condition) {
    success
  } else {
    TRUE
  }
}