pkg()

library(tmap)
library(sf)
library(leaflet)
library(rmapshaper)



comuni <- st_read("https://raw.githubusercontent.com/openpolis/geojson-italy/master/geojson/limits_IT_municipalities.geojson")

province <- st_read("https://raw.githubusercontent.com/openpolis/geojson-italy/master/geojson/limits_IT_provinces.geojson")

regioni <- st_read("https://raw.githubusercontent.com/openpolis/geojson-italy/master/geojson/limits_IT_regions.geojson")


