
#| label: sidebar paking lot
#| results: hide

# #  {.sidebar}
# 
# \
# This dashboard displays statistics for:
# 
# |              |                     |
# |--------------|---------------------|
# | **Hospital** | Grey Sloan Memorial |
# | **Unit**     | Labor and Delivery  |
# | **Month**    | `{r} time_period`   |
# 
# ------------------------------------------------------------------------
# 
# In `{r} time_period` the staff breakdown in the unit was as follows:
# 
# |                          |     |
# |--------------------------|-----|
# | **Attending physicians** |  14 |
# | **Residents**            |  21 |
# | **Nurses**               |  12 |
# 
# ------------------------------------------------------------------------
# 
# ::: {.callout-note collapse="true"}
# ## Disclaimer
# 
# This is a fictional hospital. The data are simulated based on realistic birth characteristics and risk factors from [this report by the CDC](https://www.cdc.gov/nchs/data/nvsr/nvsr72/nvsr72-01.pdf).
# :::


# Schedules (Mobile) {scrolling="true"}

## row {.tabset}

### 7&7

#### column {.tabset}

###### Line 2
![](images/2024_prod/7_7_Line_2.png)

###### 3
![](images/2024_prod/7_7_Line_3.png)

###### 4
![](images/2024_prod/7_7_Line_4.png)

###### 5
![](images/2024_prod/7_7_Line_5.png)

###### 6
![](images/2024_prod/7_7_Line_6.png)

###### 7
![](images/2024_prod/7_7_Line_7.png)

###### 9
![](images/2024_prod/7_7_Line_9.png)

###### 10
![](images/2024_prod/7_7_Line_10.png)

###### 11
![](images/2024_prod/7_7_Line_11.png)

###### 12
![](images/2024_prod/7_7_Line_12.png)

###### 13
![](images/2024_prod/7_7_Line_13.png)

###### 14
![](images/2024_prod/7_7_Line_14.png)

#### column {.tabset}

##### 2025 7&7 Line 2
![](images/2025_prod/7_7_Line_2.png)

##### 3
![](images/2025_prod/7_7_Line_3.png)

##### 4
![](images/2025_prod/7_7_Line_4.png)

##### 5
![](images/2025_prod/7_7_Line_5.png)

##### 6
![](images/2025_prod/7_7_Line_6.png)

##### 7
![](images/2025_prod/7_7_Line_7.png)

##### 9
![](images/2025_prod/7_7_Line_9.png)

##### 10
![](images/2025_prod/7_7_Line_10.png)

##### 11
![](images/2025_prod/7_7_Line_11.png)

##### 12
![](images/2025_prod/7_7_Line_12.png)

##### 13
![](images/2025_prod/7_7_Line_13.png)

##### 14
![](images/2025_prod/7_7_Line_14.png)

### 8&6

#### column {.tabset}

##### Line 12
![](images/2024_prod/7_7_Line_12.png)

##### Line 13
![](images/2024_prod/7_7_Line_13.png)

---------------------



## column {width="50%"}

### row {.tabset}

#### 2024 7&7 Line 2
![](images/2024_prod/7_7_Line_2.png)

#### 3
![](images/2024_prod/7_7_Line_3.png)

#### 4
![](images/2024_prod/7_7_Line_4.png)

#### 5
![](images/2024_prod/7_7_Line_5.png)

#### 6
![](images/2024_prod/7_7_Line_6.png)

#### 7
![](images/2024_prod/7_7_Line_7.png)

#### 9
![](images/2024_prod/7_7_Line_9.png)

#### 10
![](images/2024_prod/7_7_Line_10.png)

#### 11
![](images/2024_prod/7_7_Line_11.png)

#### 12
![](images/2024_prod/7_7_Line_12.png)

#### 13
![](images/2024_prod/7_7_Line_13.png)

#### 14
![](images/2024_prod/7_7_Line_14.png)

### row {.tabset}

#### 2024 8&6 Line 2
![](images/2024_prod/7_7_Line_2.png)

#### 3
![](images/2024_prod/7_7_Line_3.png)

#### 4
![](images/2024_prod/7_7_Line_4.png)

#### 5
![](images/2024_prod/7_7_Line_5.png)

#### 6
![](images/2024_prod/7_7_Line_6.png)

#### 7
![](images/2024_prod/7_7_Line_7.png)

#### 9
![](images/2024_prod/7_7_Line_9.png)

#### 10
![](images/2024_prod/7_7_Line_10.png)

#### 11
![](images/2024_prod/7_7_Line_11.png)

#### 12
![](images/2024_prod/7_7_Line_12.png)

#### 13
![](images/2024_prod/7_7_Line_13.png)

#### 14
![](images/2024_prod/7_7_Line_14.png)

## column {width="50%"}

### row {.tabset height="100%"}

#### 2025 7&7 Line 2
![](images/2025_prod/7_7_Line_2.png)

#### 3
![](images/2025_prod/7_7_Line_3.png)

#### 4
![](images/2025_prod/7_7_Line_4.png)

#### 5
![](images/2025_prod/7_7_Line_5.png)

#### 6
![](images/2025_prod/7_7_Line_6.png)

#### 7
![](images/2025_prod/7_7_Line_7.png)

#### 9
![](images/2025_prod/7_7_Line_9.png)

#### 10
![](images/2025_prod/7_7_Line_10.png)

#### 11
![](images/2025_prod/7_7_Line_11.png)

#### 12
![](images/2025_prod/7_7_Line_12.png)

#### 13
![](images/2025_prod/7_7_Line_13.png)

#### 14
![](images/2025_prod/7_7_Line_14.png)




install.packages("maps")
install.packages("mapproj")

library(tidyverse)
library(maps)
library(mapproj)

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
