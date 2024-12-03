#### Preamble ####
# Purpose: Simulates a dataset of fruit price
# Author: Mingjin Zhan
# Date: 28 November 2024
# Contact: mingjin.zhan@mail.utoronto.ca
# License: MIT


#### Workspace setup ####
library(tidyverse)
set.seed(123)


#### Simulate data ####
# Vendor names
vendors <- c("Walmart", "Metro", "Voila", "Galleria", "Loblaws", "NoFrills", "SaveOnFoods", "TandT")

# Generate simulated data
simulated_data <- tibble(
  vendor = sample(vendors, size = 1000, replace = TRUE),
  product_name = sample(c("Apple", "Banana", "Orange", "Melon"), size = 1000, replace = TRUE),
  current_price_per_lb = round(runif(1000, 0.5, 10), 2),
  old_price_per_lb = round(runif(1000, 1, 15), 2),
  month = sample(1:12, size = 1000, replace = TRUE)
)

#### Save simulated data ####
write_csv(simulated_data, "data/00-simulated_data/simulated_data.csv")
