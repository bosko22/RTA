library(tmap)
library(sf)
library(leaflet)
library(rmapshaper)

comuni <- st_read("https://raw.githubusercontent.com/openpolis/geojson-italy/master/geojson/limits_IT_municipalities.geojson")

province <- st_read("https://raw.githubusercontent.com/openpolis/geojson-italy/master/geojson/limits_IT_provinces.geojson")

regioni <- st_read("https://raw.githubusercontent.com/openpolis/geojson-italy/master/geojson/limits_IT_regions.geojson")


# From https://www.census.gov/geo/maps-data/data/cbf/cbf_state.html
states <- sf::st_read(here("data","cb_2013_us_state_20m","cb_2013_us_state_20m.shp"),
                      layer = "cb_2013_us_state_20m")

neStates <- subset(states, states$STUSPS %in% c(
  "CT","ME","MA","NH","RI","VT","NY","NJ","PA"
))

leaflet(neStates) %>%
  addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.5,
              fillColor = ~colorQuantile("YlOrRd", ALAND)(ALAND),
              highlightOptions = highlightOptions(color = "white", weight = 2,
                                                  bringToFront = TRUE))



# From https://www.census.gov/geo/maps-data/data/cbf/cbf_state.html
# comuni <- sf::st_read(here("data","Comuni2020-ETRS89-UTM32","V_COM_GPG_Ed_2020.shp"),
#                       layer = "V_COM_GPG_Ed_2020")

comuni <- st_read("https://raw.githubusercontent.com/openpolis/geojson-italy/master/geojson/limits_IT_municipalities.geojson")


comuniBO <- subset(comuni, comuni$prov_name == "Bologna")
provinceER <- subset(province, province$reg_name == "Emilia-Romagna")
regioneER <- subset(regioni, regioni$reg_name == "Emilia-Romagna")

leaflet(comuniBO) %>%
  # addPolygons(data = regioneER, fill = FALSE, weight = 1, color = "black") %>% 
  # addPolygons(data = provinceER, fill = FALSE, weight = 1, color = "black") %>% 
    addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.5,
              # fillColor = ~colorQuantile("YlOrRd", ALAND)(ALAND),
              highlightOptions = highlightOptions(color = "white", weight = 2,
                                                  bringToFront = TRUE)) %>%
  htmlwidgets::prependContent(htmltools::tags$style(".leaflet-container { background: transparent; }"))
