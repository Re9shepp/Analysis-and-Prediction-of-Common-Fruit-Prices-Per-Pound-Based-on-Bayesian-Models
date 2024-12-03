#### Preamble ####
# Purpose: Tests the structure and validity of the simulated predict price 
# Author: Mingjin Zhan
# Date: 28 November 2024
# Contact: mingjin.zhan@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # - The `tidyverse` package must be installed and loaded
  # - 00-simulate_data.R must have been run



#### Workspace setup ####
library(tidyverse)
library(testthat)

simulated_data <- read_csv("data/00-simulated_data/simulated_data.csv")

# Test if the data was successfully loaded
if (exists("simulated_data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}


#### Test data ####
# Test that the dataset has 1000 rows
test_that("dataset has 1000 rows", {
  expect_equal(nrow(simulated_data), 1000)
})

# Test that the 'vendor' column contains only predefined values
test_that("'vendor' column contains only predefined values", {
  predefined_vendors <- c("Walmart", "Metro", "Voila", "Galleria", "Loblaws", "NoFrills", "SaveOnFoods", "TandT")
  expect_true(all(simulated_data$vendor %in% predefined_vendors))
})

# Test that the 'product_name' column contains only predefined values
test_that("'product_name' column contains only predefined fruit names", {
  predefined_fruits <- c("Apple", "Banana", "Orange", "Melon")
  expect_true(all(simulated_data$product_name %in% predefined_fruits))
})

# Test that the 'current_price_per_lb' and 'old_price_per_lb' columns are numeric types
test_that("'current_price_per_lb' and 'old_price_per_lb' are numeric", {
  expect_type(simulated_data$current_price_per_lb, "double")
  expect_type(simulated_data$old_price_per_lb, "double")
})



# Test that the 'month' column contains values from 1 to 12
test_that("Variable 'month' has unique values 1 to 12", {
  expect_true(all(simulated_data$month %in% 1:12))
})

