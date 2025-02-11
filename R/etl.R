# https://takechargeregistry.com/canine-cancer-interactive-us-map/
library(here)
library(tidyverse)
library(readxl)
library(writexl)
library(fst)
library(sf)

cod_diagnosi <- read_excel(here("data", "raw", "codici_diagnosi.xlsx")) %>% 
  janitor::clean_names()

syn <- cod_diagnosi %>% 
  mutate(categoria = str_to_sentence(categoria)) %>% 
  filter(level == "Synonym") %>% 
  group_by(vet_icd_o, classe, categoria) %>% 
  summarise(synonym = paste(term,collapse = "<br>"), .groups = "drop")

rel <- cod_diagnosi %>% 
  mutate(categoria = str_to_sentence(categoria)) %>% 
  filter(level == "Related") %>% 
  group_by(vet_icd_o, classe, categoria) %>% 
  summarise(related = paste(term,collapse = "<br>"), .groups = "drop")

gt_diagnosi <- cod_diagnosi %>% 
  mutate(categoria = str_to_sentence(categoria)) %>% 
  filter(level == "Preferred") %>% 
  left_join(syn,
            join_by(vet_icd_o, classe, categoria)) %>% 
  left_join(rel,
            join_by(vet_icd_o, classe, categoria)) %>% 
  select(-level) %>% 
  mutate(
    across(everything(), ~replace_na(.x, "-"))
  )

fst::write_fst(gt_diagnosi, here("data", "tidy", "gt_diagnosi.fst"))




capBO <- read_excel(here("data", "raw", "capBO.xlsx"))
capBO <- capBO %>%
  group_by(cap) %>% 
  summarise(comune = factor(paste(comune, collapse=' - '))) %>% 
  separate(cap, c("cap1", "cap2")) %>%
  mutate(across(starts_with("cap"), as.numeric)) %>%
  mutate(cap2 = ifelse(is.na(cap2), cap1, cap2)) %>% 
  relocate(comune) %>% 
  add_row(comune = "Bologna", cap1 = 40100, cap2 = 40100)

dati <- read_excel(here("data", "raw", "RTA con dimevet+izs+anicura.xlsx")) %>% 
  janitor::clean_names()

dati <- dati %>% 
  filter(!str_detect(data_compilazione, "/")) %>% 
  mutate(data = janitor::convert_to_date(data_compilazione), .after = data_compilazione) %>% 
  bind_rows(dati %>% 
              filter(str_detect(data_compilazione, "/")) %>% 
              mutate(data = lubridate::dmy(data_compilazione), .after = data_compilazione)) %>% 
  mutate(cap = as.numeric(cap),
         specie = str_to_lower(specie),
         razza = str_to_title(razza)
  ) %>% 
  left_join(capBO,
            join_by(between(cap, cap1, cap2))) %>%
  select(-c(cap1,cap2)) %>% 
  relocate(comune, .after = cap) %>% 
  mutate(vet_icd_o_1_code = ifelse(vet_icd_o_1_code == ".", NA, vet_icd_o_1_code)) %>%
  
  filter(!is.na(vet_icd_o_1_code))

ncasi <- dati %>%
  group_by(comune, specie) %>%
  summarise(casi = n(), .groups = "drop") %>% 
  pivot_wider(names_from = specie, values_from = casi, names_prefix = "casi_") 

fst::write_fst(ncasi, here("data", "tidy", "ncasi.fst"))
fst::write_fst(dati, here("data", "tidy", "dati.fst"))

# dtBO <- read_excel(here("data", "raw", "dtBO_mod.xlsx"))
# dtBO <- dtBO %>% 
#   janitor::clean_names() %>% 
#   mutate(cap = as.numeric(cap)) %>% 
#   mutate(data = dmy(data)) %>% 
#   left_join(capBO,
#             join_by(between(cap, cap1, cap2))) %>% 
#   filter(!is.na(specie)) %>%
#   filter(!is.na(vet_icd_o_1_code)) %>%
#   select(-c(cap1,cap2))
# 
# casi <- dtBO %>%
#   group_by(comune, specie) %>%
#   summarise(casi = n(), .groups = "drop") %>% 
#   # ungroup() %>% 
#   pivot_wider(names_from = specie, values_from = casi, names_prefix = "casi_") 
# 
# fst::write_fst(casi, here("data", "tidy", "casi.fst"))
# fst::write_fst(dtBO, here("data", "tidy", "dtBO.fst"))














# # CODICE COMMENTATO MA DA LANCIARE:
# # CODICE PER MAPPA COMUNI
# comuni <- st_read(here("data", "raw", "Limiti01012023", "Com01012023", "Com01012023_WGS84.shp"))
# comuniBO <- subset(comuni, comuni$COD_PROV == 37)
# comuniBO <- st_transform(comuniBO, crs = 4326)
# 
# cap <- read_excel(here("data", "raw", "capBO.xlsx"))
# 
# comuniBO <- comuniBO %>%
#   left_join(cap %>%
#               mutate(cap = ifelse(comune == "Bologna", 40100, cap)),
#             join_by(COMUNE == comune)) %>%
#   mutate(cap = as.numeric(cap)) %>%
#   left_join(capBO,
#             join_by(between(cap, cap1, cap2)))
#   # group_by(comune) %>%
#   # mutate(geometry = sf::st_union(geometry)) %>%
#   # ungroup() %>%
#   # distinct(comune, cap, geometry)
# 
# #Extract coordinates
# bbox_list <- lapply(st_geometry(comuniBO), st_bbox)
# maxmin <- as.data.frame(matrix(unlist(bbox_list),nrow=nrow(comuniBO),byrow = T ))
# names(maxmin) <- names(bbox_list[[1]])
# comuniBO <- bind_cols(comuniBO,maxmin)
# 
# centroidi <- comuniBO %>%
#   st_centroid() %>%
#   dplyr::mutate(lon_centroid = sf::st_coordinates(.)[,1],
#                 lat_centroid = sf::st_coordinates(.)[,2]) %>%
#   st_drop_geometry() %>%
#   select(COMUNE, lon_centroid, lat_centroid)
# 
# # ATTENZIONE
# # CONTROLLA CORRISPONDENZA NOMI COMUNI TRA comuniBO e capBO
# # RICORDA CHE HAI UNITO COMUNI IN capBO CHE HANNO LO STESSO CAP
# 
# comuniBO <- comuniBO %>%
#   left_join(centroidi,
#             join_by(COMUNE)) %>%
#   left_join(casi,
#             join_by(comune)) %>%
#   mutate(across(starts_with('casi'), ~replace_na(., 0)))
# 
# 
# sf::st_write(comuniBO, here("data", "tidy", "comuniBO.shp"), append = FALSE)
# 
# 
# # # cap
# comuni <- st_read(here("data", "raw", "Limiti01012023", "Com01012023", "Com01012023_WGS84.shp"))
# comuniBO <- subset(comuni, comuni$COD_PROV == 37)
# comuniBO <- st_transform(comuniBO, crs = 4326)
# 
# cap <- read_excel(here("data", "raw", "capBO.xlsx"))
# 
# capBO <- comuniBO %>%
#   left_join(cap %>%
#               mutate(cap = ifelse(comune == "Bologna", 40100, cap)),
#             join_by(COMUNE == comune)) %>%
#   mutate(cap = as.numeric(cap)) %>%
#   left_join(capBO,
#             join_by(between(cap, cap1, cap2))) %>% 
#   group_by(comune) %>%
#   mutate(geometry = sf::st_union(geometry)) %>%
#   ungroup() %>%
#   distinct(comune, cap, geometry, .keep_all = T)
#   
# sf::st_write(capBO, here("data", "tidy", "capBO.shp"), append = FALSE)
#   
