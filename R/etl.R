# https://takechargeregistry.com/canine-cancer-interactive-us-map/
library(here)
library(tidyverse)
library(readxl)
library(writexl)
library(fst)
library(sf)

cod_diagnosi <- read_excel(here("data", "raw", "codici_diagnosi.xlsx")) %>% 
  janitor::clean_names()

syn <- diagnosi %>% 
  mutate(categoria = str_to_sentence(categoria)) %>% 
  filter(level == "Synonym") %>% 
  group_by(vet_icd_o, classe, categoria) %>% 
  summarise(synonym = paste(term,collapse = "<br>"))

rel <- diagnosi %>% 
  mutate(categoria = str_to_sentence(categoria)) %>% 
  filter(level == "Related") %>% 
  group_by(vet_icd_o, classe, categoria) %>% 
  summarise(related = paste(term,collapse = "<br>"))

gt_diagnosi <- diagnosi %>% 
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

dtBO <- read_excel(here("data", "raw", "dtBO_mod.xlsx"))
dtBO <- dtBO %>% 
  janitor::clean_names() %>% 
  mutate(cap = as.numeric(cap)) %>% 
  mutate(data = dmy(data)) %>% 
  left_join(capBO,
            join_by(between(cap, cap1, cap2))) %>% 
  filter(!is.na(specie)) %>%
  filter(!is.na(vet_icd_o_1_code)) %>%
  select(-c(cap1,cap2))

casi <- dtBO %>%
  group_by(comune, specie) %>%
  summarise(casi = n(), .groups = "drop") %>% 
  # ungroup() %>% 
  pivot_wider(names_from = specie, values_from = casi, names_prefix = "casi_") 
  # mutate(casi_Totali = sum(across(starts_with("casi")), na.rm = T))
  # bind_rows(summarise(.,
  #                     across(where(is.numeric), sum),
  #                     # across(where(is.character), ~"Total"),
  #                     across(comune, ~"Provincia di Bologna")))

# dtBO %>% 
#   mutate(
#     eta_anno = as.integer(str_extract(eta, "\\d+(?=a)")),
#     eta_mese = as.integer(str_extract(eta, "\\d+(?=m)"))
#   ) %>% View()

# # top 3
# dtBO %>%
#   group_by(comune, specie, vet_icd_o_1_code) %>%
#   summarise(casi = n()) %>% 
#   slice_max(order_by = casi, n = 3)

fst::write_fst(casi, here("data", "tidy", "casi.fst"))
fst::write_fst(dtBO, here("data", "tidy", "dtBO.fst"))

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
