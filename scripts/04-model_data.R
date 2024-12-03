#### Preamble ####
# Purpose: Models for predict common fruit price
# Author: Mingjin Zhan
# Date: 28 November 2024
# Contact: mingjin.zhan@mail.utoronto.ca
# License: MIT


#### Workspace setup ####
library(tidyverse)
library(arrow)
library(rstanarm)


#### Read data ####
analysis_data <- read_parquet("data/02-analysis_data/analysis_data.parquet")

### Model data ####
model_1 <- lm(current_price_per_lb ~ old_price_per_lb, data = analysis_data)
model_2 <- lm(current_price_per_lb ~ old_price_per_lb + month, data = analysis_data)
model_3 <- lm(current_price_per_lb ~ old_price_per_lb + month + vendor, data = analysis_data)
model_4 <- lm(current_price_per_lb ~ old_price_per_lb + month + vendor + fruit_category, data = analysis_data)

model_5 <-
  stan_glm(
    formula = current_price_per_lb ~ old_price_per_lb + month + vendor + fruit_category,
    data = analysis_data,
    family = gaussian(),
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_aux = exponential(rate = 1, autoscale = TRUE),
    seed = 853
  ) 

simulated_prior <- stan_glm(
  current_price_per_lb ~ old_price_per_lb + month + vendor + fruit_category,
  data = analysis_data,
  family = gaussian(),
  prior_PD = TRUE, # Generates predictions based on priors only
  prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_aux = exponential(rate = 1, autoscale = TRUE),
  seed = 123
)

#### Save model ####
saveRDS(model_1, file = "models/model_1.rds")
saveRDS(model_2, file = "models/model_2.rds")
saveRDS(model_3, file = "models/model_3.rds")
saveRDS(model_4, file = "models/model_4.rds")
saveRDS(model_5, file = "models/model_5.rds")
saveRDS(model_5, file = "other/model_api/model.rds")
saveRDS(simulated_prior, file = "models/model_simulated.rds")



