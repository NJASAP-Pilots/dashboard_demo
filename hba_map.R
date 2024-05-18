library(tidyverse)
library(readxl)
library(ggplot2)
library(airportr)
library(leaflet)
library(sf)

# Import current HBA list

thba_import <- dir(path = "~/Library/CloudStorage/OneDrive-NJASAP/Documents/_NJASAP General/HBA Quarterly LIst",
                   full.names = T,
                   pattern = "active.*\\.xlsx$")

thba <- read_excel(thba_import,
                   sheet = "Sheet1",
                   range = cell_cols(9:10)
)

# Import, bind, and clean seniority

imported_folder_2024 <- dir(path = "~/OneDrive - NJASAP/Documents/Seniority Related/Seniority List - Union/2024", 
                            full.names = T,
                            pattern = "\\d\\d\\d[34]-\\d\\d\\sSeniorityList_UnionCopy.xlsx"
)

read_snrty_files <- function(file){
  if(is.na(file)) stop("no file path")
  imported_snrty <- read_excel(file,
                               sheet = "UNION_EXCEL_FILE",
                               range = cell_cols("A:P")
  )
  imported_snrty
}

thba_seniority_bind <- map_dfr(.x = imported_folder_2024, .f = read_snrty_files)

thba_seniority <- thba_seniority_bind %>% 
  rename_all(tolower) %>% 
  select(cmi, co_snrty = `company seniority`, snrty = `union seniority`, 4:7,
         equip_lock = `equip lock`, 9:12, tsp_elect = `tsp election`,
         year_month = `year month`, published) %>% 
  mutate(doh = ymd(doh), equip_lock = ymd(equip_lock), published = ymd(published),
         yos_r = ceiling( as.duration(doh %--% published) / dyears(1) )
  )

thba_month_floor <- floor_date(max(thba_seniority$published), unit = "months")

# Create pilots per base table

thba_ppb <- thba_seniority %>% 
  filter(published > thba_month_floor) %>% 
  rename(hba = gateway) %>% 
  mutate(hba = paste0("K",hba), iata = str_sub(hba, -3, -1)) %>% 
  count(hba, name = "ppb", sort = TRUE)

# Prep HBA table

thba <- thba %>% 
  rename_all(tolower) %>% 
  mutate(iata = str_sub(hba, -3, -1))

thba

# Join HBA and PPB tables

glimpse(airports)

thba_map <- thba %>% 
  left_join(thba_ppb, by = "hba") %>% 
  left_join(airports, by = join_by("hba" == "ICAO")) %>% 
  mutate(popup = paste0(hba, "<br>", Name, "<br>", "Total Pilots: ", ppb),
         status_color = case_when(
           status == 1 ~"blue",
           status == 2 ~"orange",
           status == 3 ~"red",
           TRUE ~"blue"
         )) %>% 
  select(hba, status, status_color , ppb, Name, City, Latitude, Longitude, popup)

thba_map

glimpse(thba_map)

# Draw the map
# US Center 39.8283° N, 98.5795° W

icons <- awesomeIcons(icon = "plane",
                      markerColor = thba_map$status_color)

thba_map %>% 
  leaflet() %>%
    addTiles() %>% 
    setView(lng = -98.5795,
            lat = 39.283,
            zoom = 4) %>% 
    setMaxBounds(lng1 = -124.67,
                 lng2 = -66.95,
                 lat1 = 25.84,
                 lat2 = 49.38) %>% 
  addAwesomeMarkers(~Longitude, ~Latitude,
                    icon = icons,
                    heigh
                    popup = ~popup)
  
