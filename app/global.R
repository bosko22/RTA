library(shiny)
library(shinydashboard)
library(bslib)
library(leaflet)
library(ggplot2)


#Import data

# codediag <-read_excel(here("data", "raw", "codici_diagnosi.xlsx"))#tabella codici diagnosi
# dt <- read_excel(here("data", "raw", "dtBO.xlsx"))

#data(penguins, package = "palmerpenguins")
#mappe


# cards <- list(
#   card(
#     full_screen = TRUE,
#     card_header("Bill Length"),
#     plotOutput("bill_length")
#   ),
#   card(
#     full_screen = TRUE,
#     card_header("Bill depth"),
#     plotOutput("bill_depth")
#   ),
#   card(
#     full_screen = TRUE,
#     card_header("Body Mass"),
#     plotOutput("body_mass")
#   )
# )
# 
# color_by <- varSelectInput(
#   "color_by", "Color by",
#   penguins[c("species", "island", "sex")],
#   selected = "species"
# )