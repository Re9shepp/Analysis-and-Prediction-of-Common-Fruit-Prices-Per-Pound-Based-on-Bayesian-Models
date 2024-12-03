# Analysis-and-Prediction-of-Common-Fruit-Prices-Per-Pound-Based-on-Bayesian-Models

## Overview

This repository provides a predictive framework for analyzing and forecasting the price per pound of common fruits, including apples, bananas, melons, and oranges. Leveraging a Bayesian model, this study evaluates how factors such as historical prices, vendor, month, and fruit category influence current pricing trends. This repository includes all materials related to the study, including datasets, scripts, models, and paper.


## File Structure

The repo is structured as:

-   `data/00-simulated_data` contains the simulated fruit price per pound.
-   `data/01-raw_data` contains the original raw fruit pricing data retrieved from Hammer Data, however, due to the large file size, only a compressed version of one dataset can be uploaded. The raw data must be downloaded manually from https://jacobfilipp.com/hammer/.
-   `data/02-analysis_data` includes the cleaned dataset constructed through rigorous preprocessing.
-   `model` stores fitted Bayesian models used in the study. 
-   `other` contains additional details, such as sketches for figures, llm usage and API for model.
-   `paper` includes the Quarto document and PDF of the final paper, along with the bibliography file.
-   `scripts` contains the R scripts used to simulate, download and clean data.

## Data Retrieval
The raw fruit pricing data was retrieved from Hammer Data. To access the original dataset:
1. Visit the Hammer Data website.
2. Click the "Zipped CSVs with full price data" link and save the file locally.

## Statement on LLM usage

Aspects of the code were written with the help of Chatgpt4.0, the entire chat history is available at other/llm_usage/usage.txt.
