#### Preamble ####
# Purpose: Tests analysis data for predict common fruit price
# Author: Mingjin Zhan
# Date: 28 November 2024
# Contact: mingjin.zhan@mail.utoronto.ca
# License: MIT


#### Workspace setup ####
library(tidyverse)
library(testthat)
library(arrow)

analysis_data <- read_parquet("data/02-analysis_data/analysis_data.parquet")


# Test if the data was successfully loaded
if (exists("analysis_data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}


#### Test data ####
# Test that the dataset has 1630 rows
test_that("dataset has 1630 rows", {
  expect_equal(nrow(analysis_data), 1630)
})

# Test that the 'vendor' column contains only predefined values
test_that("'vendor' column contains only predefined values", {
  predefined_vendors <- c("Walmart", "Metro", "Voila", "Galleria", "Loblaws", "NoFrills", "SaveOnFoods", "TandT")
  expect_true(all(analysis_data$vendor %in% predefined_vendors))
})

# Test that the 'product_name' column contains only predefined values
test_that("'fruit_category' column contains only predefined fruit names", {
  predefined_fruits <- c("Apple", "Banana", "Orange", "Melon")
  expect_true(all(analysis_data$fruit_category %in% predefined_fruits))
})

# Test that the 'current_price_per_lb' and 'old_price_per_lb' columns are numeric types
test_that("'current_price_per_lb' and 'old_price_per_lb' are numeric", {
  expect_type(analysis_data$current_price_per_lb, "double")
  expect_type(analysis_data$old_price_per_lb, "double")
})

# Test that the 'month' column contains values from 1 to 12
test_that("Variable 'month' has unique values 1 to 12", {
  expect_true(all(analysis_data$month %in% 1:12))
})