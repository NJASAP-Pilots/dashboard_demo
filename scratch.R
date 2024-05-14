
sessionInfo()

glue("Data current as of {year(roster_max_pull_floor)}-{str_pad(month(roster_max_pull_floor),2, pad = 0)} NJASAP Pilot Seniority List")
)

color = "#33B7FF"

tSeniorityMerge %>% 
  select(cmi,name, aircraft, sdp, published) %>% 
  pivot_wider(names_from = published, values_from = sdp) %>% 
  mutate(new_sdp = ifelse( is.na(`2024-02-15`) & !is.na(`2024-03-19`), 1, 0)
  )%>% 
  filter(new_sdp == 1) %>% 
  select(name, aircraft, "2024-02-15", "2024-03-19") %>% 
  gt(rowname_col = "name", groupname_col = "aircraft") %>% 
  tab_header(title = md("March SDP Awards")) %>% 
  tab_style(
    style = cell_text(align = "left"),
    locations = cells_title("title")
  ) %>% 
  tab_style(
    style = cell_fill("lightgray"),
    locations = cells_row_groups()
  ) %>% 
  cols_label(
    "2024-02-15" = md("*2024-02*"),
    "2024-03-19" = md("*2024-03*")
  ) %>% 
  cols_width(
    starts_with("2024") ~px(100),
    everything() ~px(200)
  ) %>% 
  cols_align(
    align = "right",
    columns = "name"
  ) %>% 
  cols_align(
    align = "center",
    columns = starts_with("2024")
  ) %>% 
  sub_missing(
    columns = everything(),
    rows = everything(),
    missing_text = "--"
  )