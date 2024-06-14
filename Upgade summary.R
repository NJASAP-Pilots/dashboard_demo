#| label: load-and-prep-seniority
#| message: false

library(tidyverse)
library(readxl)
library(scales)
library(DT)
library(gt)
library(gtExtras)
library(glue)
library(plotly)
library(cellranger)
library(writexl)

imported_folder_2023 <- dir(path = "~/OneDrive - NJASAP/Documents/Seniority Related/Seniority List - Union/2023", 
                            full.names = T,
                            pattern = "\\d\\d\\d[34]-\\d\\d\\sSeniorityList_UnionCopy.xlsx"
)

imported_folder_2024 <- dir(path = "~/OneDrive - NJASAP/Documents/Seniority Related/Seniority List - Union/2024", 
                            full.names = T,
                            pattern = "\\d\\d\\d[34]-\\d\\d\\sSeniorityList_UnionCopy.xlsx"
)

imported_master_snrty_folder <- c(imported_folder_2023, imported_folder_2024)

rm(imported_folder_2023)
rm(imported_folder_2024)

### Create Function to build list of files ###

read_snrty_files <- function(file){
  if(is.na(file)) stop("no file path")
  imported_snrty <- read_excel(file,
                               sheet = "UNION_EXCEL_FILE",
                               range = cell_cols("A:P")
  )
  imported_snrty
}

### Bind files by folder ###

merged_seniority <- map_dfr(.x = imported_master_snrty_folder, .f = read_snrty_files)

rm(imported_master_snrty_folder)

seniority <- merged_seniority %>% 
  rename_all(tolower) %>% 
  select(cmi, co_snrty = `company seniority`, snrty = `union seniority`, 4:7,
         equip_lock = `equip lock`, 9:12, tsp_elect = `tsp election`,
         year_month = `year month`, published) %>% 
  mutate(doh = ymd(doh), equip_lock = ymd(equip_lock), published = ymd(published),
         yos_r = ceiling( as.duration(doh %--% published) / dyears(1) )
  )

### Date Variables ###

max_pub_floor <- floor_date(max(seniority$published), unit = "months")

rm(merged_seniority)

### Filter for Fleet Changes ###

seniority %>% 
  group_by(cmi) %>% 
  arrange(published) %>% 
  rowid_to_column(var = "id")

seniority_1 <- seniority %>% 
  select(cmi, name, doh, snrty, aircraft, seat, year_month, published) %>% 
  mutate(fleet_seat = as.character( glue("{aircraft}-{seat}")) ) %>% 
  arrange(cmi, published) %>% 
  rowid_to_column(var = "id")

seniotiry_2 <- seniority_1 %>% 
  select(id, cmi, name, doh, snrty, aircraft, seat, year_month, published) %>% 
  mutate(fleet_seat = as.character( glue("{aircraft}-{seat}")),
         id_2 = id + 1) %>% 
  arrange(cmi, published)

### Master Report ###

join_seniority <- seniotiry_2 %>% 
  left_join(seniority_1, by = join_by(id_2 == id)) %>% 
  filter(cmi.x == cmi.y,
         fleet_seat.x != fleet_seat.y) %>% 
  mutate(last_name = str_match(name.x, "(.*),")[,2],
         first_init = str_match(name.x, ", (\\w)")[,2],
         last_fi = glue("{last_name}, {first_init}")) %>%
  select(CMI = cmi.x, `Name` = last_fi, DOH = doh.x, Seniority = snrty.x, `Prev. Year Month` = year_month.x,
         `Prev. Fleet` = fleet_seat.x, `Upgrade Snrty.` = snrty.y,
         `Upgrd. Year Month` = year_month.y, `Upgrade Fleet` = fleet_seat.y)

write_xlsx(join_seniority, "Upgrade Report.xlsx")

### Function to Sort ###

fupgrade_fleet <- function(upgrade_fleet){
 
  upgrade_fleet <- seniotiry_2 %>% 
      left_join(seniority_1, by = join_by(id_2 == id)) %>% 
      filter(cmi.x == cmi.y,
             fleet_seat.x != fleet_seat.y) %>% 
      mutate(last_name = str_match(name.x, "(.*),")[,2],
             first_init = str_match(name.x, ", (\\w)")[,2],
             last_fi = glue("{last_name}, {first_init}")) %>%
      select(cmi.x, last_fi, doh.x, snrty.x, year_month.x, fleet_seat.x,
             snrty.y, year_month.y, fleet_seat.y) %>% 
      filter(str_detect(fleet_seat.y, glue("^{upgrade_fleet}.*")))
  
  return(upgrade_fleet)
}

fupgrade_fleet("EMB")

  ### GT Report ###

min_month_year = glue("{str_pad(month(min(seniotiry_2$published)), 2, pad = '0')}-{year(min(seniotiry_2$published))}")
max_month_year = glue("{str_pad(month(max(seniotiry_2$published)), 2, pad = '0')}-{year(max(seniotiry_2$published))}")


upgrade_summary <- seniotiry_2 %>% 
  left_join(seniority_1, by = join_by(id_2 == id)) %>% 
  filter(cmi.x == cmi.y,
         fleet_seat.x != fleet_seat.y,
         seat.y != "SIC") %>% 
  mutate(last_name = str_match(name.x, "(.*),")[,2],
         first_init = str_match(name.x, ", (\\w)")[,2],
         last_fi = glue("{last_name}, {first_init}")) %>%
  select(aircraft.y, last_fi, doh.x, snrty.x, year_month.x, fleet_seat.x, snrty.y,
         year_month.y, fleet_seat.y) %>% 
  group_by(aircraft.y) %>% 
  arrange(aircraft.y, doh.x) %>% 
  gt(groupname_col = "aircraft.y") %>% 
  gt_theme_538() %>% 
  tab_header(title = "NJASAP Crew Upgrade Summary",
             subtitle = md(glue("*From {min_month_year} to {max_month_year}*"))) %>% 
  cols_label(last_fi = "Name",
             doh.x = "DOH",
             snrty.x = "Snrty",
             year_month.x = "Year Month",
             fleet_seat.x = "Fleet-Seat",
             snrty.y = "Snrty",
             year_month.y = "Year Month",
             fleet_seat.y = "Fleet-Seat") %>% 
  cols_align(align = "left",
             columns = everything()) %>% 
  fmt_date(columns = "doh.x",
           date_style = "yMd" ) %>% 
  tab_spanner("Previous Fleet & Seat", 4:6) %>% 
  tab_spanner("Current Fleet & Seat", 7:9) %>% 
  tab_options(row_group.as_column = TRUE)

upgrade_summary %>% 
  gtsave("upgrade_summary.tex")
