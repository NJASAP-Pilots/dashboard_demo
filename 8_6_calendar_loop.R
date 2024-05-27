library(tidyverse)
library(calendR)
library(glue)
library(readxl)

t2024_86_lines <- read_excel("~/Library/CloudStorage/OneDrive-Personal/Documents/R Studio/Schedule Calendars/2024-04-04 R 7-7 Calendar.xlsx", 
                             sheet = "CalendR Days 2024 8_6",
                             range = cell_cols(09:14))

var_list <- t2024_86_lines %>% 
  select(1:6) %>% 
  colnames()


for (i in 1:6) {
  
  # Variables
  
  line_data <- unlist(t2024_86_lines[i])
  line <- var_list[i]
  line_legend <- sub("_"," ",line)
  line_no <- ifelse(nchar(line) == 7, str_sub(line,-2), str_sub(line,-1))
  cal_title <- glue("2024 7&7-{line_no}")
  save_as <- glue("8_6_{line}.png")
  
  imp.dates <- rep(NA, 366)
  imp.dates[line_data] <- line_legend
  imp.dates[c(1,15,50,89,91,148,186,246,333,360)] <- "NJA Holidays"
  
  calendR(year = 2024, ncol = 1, # Year
          title = cal_title,
          mbg.col = "steelblue",           # Background color for the month names
          months.pos = 0.5,    # Horizontal alignment of the month names
          months.col = "white",  # Text color of the month names
          special.days = imp.dates,    # Color days of the year
          special.col = c("lightblue", "pink"), # Color of the special.days
          legend.pos = "bottom")
  
  ggsave(save_as, path = "images/2024_prod",
         width = 720,
         height = 4000,
         units =c("px"),
         device = png,
         dpi = 240
  )
}

### 2025 ###

t2025_86_lines <- read_excel("~/Library/CloudStorage/OneDrive-Personal/Documents/R Studio/Schedule Calendars/2024-04-04 R 7-7 Calendar.xlsx", 
                             sheet = "CalendR Days 2025 8_6",
                             range = cell_cols(11:16))

var_list <- t2024_86_lines %>% 
  select(1:6) %>% 
  colnames()


for (i in 1:6) {
  
  # Variables
  
  line_data <- unlist(t2025_86_lines[i])
  line <- var_list[i]
  line_legend <- sub("_"," ",line)
  line_no <- ifelse(nchar(line) == 7, str_sub(line,-2), str_sub(line,-1))
  cal_title <- glue("2025 8&6-{line_no}")
  save_as <- glue("8_6_{line}.png")
  
  imp.dates <- rep(NA, 365)
  imp.dates[line_data] <- line_legend
  imp.dates[c(1, 20, 48, 57, 108, 110, 185, 244, 331, 359)] <- "NJA Holidays"
  
  calendR(year = 2025, ncol = 1, # Year
          title = cal_title,
          mbg.col = "steelblue",           # Background color for the month names
          months.pos = 0.5,    # Horizontal alignment of the month names
          months.col = "white",  # Text color of the month names
          special.days = imp.dates,    # Color days of the year
          special.col = c("lightblue", "pink"), # Color of the special.days
          legend.pos = "bottom")
  
  ggsave(save_as, path = "images/2025_prod",
         width = 720,
         height = 4000,
         units =c("px"),
         device = png,
         dpi = 240
  )
}

----------------------------------------------------------------------
  # 2024-05-15 2302
  
  imp.dates <- rep(NA, 397)
imp.dates[t2024_86_lines$Line_2] <- "Line 2"
imp.dates[c(1,15,50,89,91,148,186,246,333,360)] <- "NJA Holidays"

calendR(from = "2024-01-01",
        to = "2025-01-31",
        title = "2024 7&7-2",
        mbg.col = "steelblue",           # Background color for the month names
        months.pos = 0.5,    # Horizontal alignment of the month names
        months.col = "white",  # Text color of the month names
        special.days = imp.dates,    # Color days of the year
        special.col = c("lightblue", "pink"), # Color of the special.days
        legend.pos = "bottom")

ggsave("7_7_Line_2_v10.png", path = "images",
       width = 360, 
       height = 2000,
       units =c("px"),
       device = png,
       dpi = 120
)