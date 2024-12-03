#### Preamble ####
# Purpose: Cleans the raw plane data for predict common fruit price
# Author: Mingjin Zhan
# Date: 28 November 2024
# Contact: mingjin.zhan@mail.utoronto.ca
# License: MIT


#### Workspace setup ####
library(tidyverse)
library(lubridate)
library(arrow)

#### Clean data ####
raw_data <- read_csv("data/01-raw_data/hammer-4-raw.csv")
product_data <- read.csv("data/01-raw_data/hammer-4-product.csv")

combined_data <- raw_data %>% 
  inner_join(product_data, by = c("product_id" = "id")) %>%
  select(
    product_id,
    product_name,
    brand,
    vendor,
    nowtime,
    current_price,
    old_price,
    price_per_unit,
    units
    ) %>% 
  drop_na()

fruit_product_keywords <- "juice|jam|sauce|pie|cookie|cake|bar|drink|chocolate|smoothie|syrup|snack|muffin|jelly|pudding|gel|sorbet|crumble|crisp|turnover|compote|cheesecake|popsicle|pastry|strudel|bread|ice cream|granola|tart|fritter|wafer|chips|bites|extract|shake|donut|pop|oatmeal|cereal|marinade|spread|candy|flavour|punch|pepper|wood|yogurt|pork|maple|flaky|cereal|tea|supplement|crystal|croissant|cinnamon|smoked|honeydew|bottle"


cleaned_data <- combined_data %>%
  select(product_name,
         brand,
         nowtime, 
         current_price, 
         old_price, 
         price_per_unit,
         units, 
         vendor) %>%
  filter(str_detect(tolower(product_name), "banana|melon|apple|orange")) %>%
  filter(brand == "") %>%
  filter(!str_detect(tolower(product_name), fruit_product_keywords)) %>%
  filter(!str_detect(tolower(product_name), "pine")) %>%
  mutate(month = month(nowtime), 
         current_price = parse_number(current_price),
         old_price = parse_number(old_price),
  ) %>%
  mutate(fruit_category = case_when(
    str_detect(tolower(product_name), "apple") ~ "Apple",
    str_detect(tolower(product_name), "banana") ~ "Banana",
    str_detect(tolower(product_name), "orange") ~ "Orange",
    str_detect(tolower(product_name), "melon") ~ "Melon"
    )
  ) %>%  
  mutate(
    current_price_per_lb = case_when(
      str_detect(price_per_unit, "/100g") ~ as.numeric(str_extract(price_per_unit, "\\d+(\\.\\d+)?")) * 4.53592, # Convert /100g to /lb
      str_detect(price_per_unit, "/lb") ~ as.numeric(str_extract(price_per_unit, "\\d+(\\.\\d+)?")) # Keep /lb values as is
    ), 
      
    old_price_per_lb = case_when(
      str_detect(price_per_unit, "/100g") ~ (old_price / current_price) * current_price_per_lb,
      str_detect(price_per_unit, "/lb") ~ (old_price / current_price) * current_price_per_lb
    )
  ) %>%
  mutate(
    current_price_per_lb = round(current_price_per_lb, 2),
    old_price_per_lb = round(old_price_per_lb, 2)
  ) %>%
  select(-nowtime, -brand, -units, -price_per_unit, -current_price, -old_price) %>%
  drop_na()
  

#### Save data ####
write_csv(cleaned_data, "data/cleaned_data.csv")
write_parquet(x = cleaned_data, sink = "data/02-analysis_data/analysis_data.parquet")
  


