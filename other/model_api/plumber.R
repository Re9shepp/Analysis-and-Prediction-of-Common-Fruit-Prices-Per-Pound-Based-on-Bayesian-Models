# Load required libraries
library(plumber)
library(rstanarm)
library(tidyverse)

# Load the Bayesian model
model <- readRDS("model.rds")

# Define the model version
version_number <- "0.0.1"

# Define the variables
variables <- list(
  old_price_per_lb = "The previous price per pound of the product, numeric value.",
  vendor = "The vendor identifier, categorical - e.g., 'Metro' or 'Voila'.",
  month = "The month of the year, numeric (1 to 12).",
  fruit_category = "The category of the fruit, categorical - e.g., 'Apple', 'Banana', 'Melon', or 'Orange'."
)

# API Function to predict price
#* @param old_price_per_lb Previous price per pound of the product
#* @param vendor Vendor name (categorical, e.g., 'Metro', 'Voila')
#* @param month Month of the year (1 to 12)
#* @param fruit_category Category of the fruit (e.g., 'Apple' , 'Orange', 'Banana', 'Melon')
#* @get /predict_price
predict_price <- function(old_price_per_lb = 1.75, vendor = "Metro", month = 6, fruit_category = "Apple") {
  # Convert inputs to appropriate types
  old_price_per_lb <- as.numeric(old_price_per_lb)
  vendor <- as.character(vendor)
  month <- as.integer(month)
  fruit_category <- as.character(fruit_category)
  
  # Prepare the input payload as a data frame
  payload <- data.frame(
    old_price_per_lb = old_price_per_lb,
    vendor = vendor,
    month = month,
    fruit_category = fruit_category
  )
  
  # Extract posterior samples from the model
  posterior_samples <- as.matrix(model)
  
  # Extract coefficients from posterior samples
  beta_old_price_per_lb <- posterior_samples[, "old_price_per_lb"]
  beta_vendor <- posterior_samples[, "vendorVoila"]
  beta_month <- posterior_samples[, "month"]
  alpha <- posterior_samples[, "(Intercept)"]
  
  # Handle beta_fruit_category using an if-else structure
  beta_fruit_category <- if (fruit_category == "Apple") {
    0
  } else if (fruit_category == "Banana") {
    posterior_samples[, "fruit_categoryBanana"]
  } else if (fruit_category == "Melon") {
    posterior_samples[, "fruit_categoryMelon"]
  } else if (fruit_category == "Orange") {
    posterior_samples[, "fruit_categoryOrange"]
  } else {
    stop("Invalid fruit category. Please use one of: Apple, Banana, Melon, Orange.")
  }
  
  # Compute predicted values based on the generative process
  predicted_values <- alpha +
    beta_old_price_per_lb * payload$old_price_per_lb +
    ifelse(payload$vendor == "Voila", beta_vendor, 0) +
    beta_month * payload$month +
    beta_fruit_category
  
  # Calculate mean prediction
  mean_prediction <- mean(predicted_values)
  
  # Return the result as a list
  result <- list(
    version = version_number,
    estimated_price = mean_prediction
  )
  
  return(result)
}




