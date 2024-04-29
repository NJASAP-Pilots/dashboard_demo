library(glue)


### Import and merge seniority lists ###

imported_seniority <- dir(path = "data/", 
                            full.names = T,
                            pattern = "\\d\\d\\d[34]-\\d\\d\\sSeniorityList_UnionCopy.xlsx"
)


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

merged_seniority <- map_dfr(.x = imported_seniority, .f = read_snrty_files)

### Seniority Clean-up ###

seniority <- merged_snrty %>% 
  rename_all(tolower) %>% 
  select(cmi, co_snrty = `company seniority`, snrty = `union seniority`, 4:7,
         equip_lock = `equip lock`, 9:12, tsp_elect = `tsp election`,
         year_month = `year month`, published) %>% 
  mutate(doh = ymd(doh), equip_lock = ymd(equip_lock), published = ymd(published),
         yos_r = ceiling( as.duration(doh %--% published) / dyears(1) )
  )

### Date Variables ###

max_pub_floor <- floor_date(max(seniority$published), unit = "months")
# m12_lb <- max_pub_floor %m-% months(12)
pub_12m_lb <- add_with_rollback(max_pub_floor,
                  months(-12),
                  roll_to_first = F)

max_doh_floor <- floor_date(max(seniority$doh), unit = "months")
doh_12m_lb <- add_with_rollback(max_doh_floor,
                                months(-12),
                                roll_to_first = T)
### PLOT ###

seniority %>% 
  select(cmi, doh, year_month, published) %>% 
  mutate(moh = str_pad(month(doh),2,pad = "0"),
         ymh = glue("{year(doh)}-{moh}"),
         ymh = as.character(ymh)) %>% 
  filter(doh > doh_12m_lb & published > max_pub_floor) %>% 
  select(cmi, ymh) %>% 
  count(ymh) %>% 
  ggplot(aes(x = ymh, y = n)) +
  geom_line(aes(group = "ymh"))+
  geom_point(size = 3)+
  geom_point(size = 6, shape = "circle open")+
  theme_bw()+
  labs(x = NULL,
       y = "Count")

seniority %>% 
  select(cmi, doh, year_month, published) %>% 
  filter(published > pub_12m_lb) %>% 
  select(cmi, year_month) %>% 
  count(year_month) %>% 
  ggplot(aes(x = year_month, y = n)) +
  geom_line(aes(group = "year_month"))+
  geom_point(size = 3)+
  geom_point(size = 6, shape = "circle open")+
  theme_bw()+
  labs(x = NULL,
       y = "Count")
