# Urbanization and Real GDP per Capita: World Bank Data Visualization

## Project Overview

This project examines the relationship between urban population share and real GDP per capita across countries from 2000 to 2024 using World Bank indicators. The analysis is designed to show how countries move through the urbanization–income space over time and how that relationship changes across regions.

The repository follows a simple reproducible workflow:

1. Download world development data from the World Bank API.
2. Clean the raw indicators and remove non-country aggregate entities.
3. Add continent labels and prepare the country-year dataset.
4. Explore the relationship with summary statistics and visual diagnostics.
5. Build an interactive Plotly visualization to animate the country-level relationship over time.

This project is implemented in R and is structured as a small data analysis pipeline for exploratory data visualization.

## Data

The raw World Bank series are pulled from the World Bank API in `data/raw_data/`:

- `world_bank_gdp_urban_2000_2024.csv`

This file contains combined country-year records for:

- `country_code`
- `country`
- `year`
- `real_gdp_per_capita`
- `urban_population`

The cleaned country-level dataset is stored in `data/cleaned_data/`:

- `world_bank_gdp_urban_country_2000_2024.csv`

This cleaned dataset adds a `continent` field and removes aggregate world-region entries (for example, World Bank regional and income-group totals), so the analysis focuses on actual countries and territories.

## Repository Structure

```text
Zhengyang_Ding_AEDS6400_blog7/
├── .gitignore
├── README.md
├── Zhengyang_Ding_AEDS6400_blog7.Rproj
├── code/
│   ├── data_clean.R
│   ├── data_plot.R
│   └── data_scrape.R
├── data/
│   ├── cleaned_data/
│   │   └── world_bank_gdp_urban_country_2000_2024.csv
│   └── raw_data/
│       └── world_bank_gdp_urban_2000_2024.csv
└── figure/
    └── gdp_urban_interactive.html
```

## Workflow Summary

### 1) Data acquisition — `code/data_scrape.R`

This script downloads two World Bank indicators from the API:

- `NY.GDP.PCAP.KD`: real GDP per capita (constant 2015 US$)
- `SP.URB.TOTL.IN.ZS`: urban population as a percentage of total population

The script:

- requests the 2000-2024 time window,
- extracts the relevant columns from the JSON response,
- merges the GDP and urbanization series by country and year,
- filters incomplete observations,
- saves the raw merged dataset as `data/raw_data/world_bank_gdp_urban_2000_2024.csv`.

This stage is the foundation of the project because it assembles a long-form country-year panel for later exploration.

### 2) Data cleaning and country filtering — `code/data_clean.R`

This script prepares the analysis-ready dataset. It:

- reads the raw merged World Bank file,
- removes aggregate and non-country entities using World Bank country codes,
- checks the remaining country list for consistency,
- assigns each country to a continent using a manually defined code map,
- saves the cleaned data as `data/cleaned_data/world_bank_gdp_urban_country_2000_2024.csv`.

This step reduces noise from aggregate regional series and ensures the subsequent visualization is based on actual country observations.

### 3) Exploratory analysis and interactive visualization — `code/data_plot.R`

This script builds the core analysis and visual output. It:

- loads the cleaned data,
- computes summary statistics by continent and year,
- generates a log-transformed GDP series for more interpretable scatter patterns,
- creates a static exploratory scatterplot,
- evaluates the Pearson correlation between GDP per capita and urbanization over time,
- produces an animated Plotly scatterplot where each frame represents a year,
- saves the final interactive chart to `figure/gdp_urban_interactive.html`.

The final visualization is the main deliverable: a dynamic view showing how countries move through the urbanization-income space over time.

## Reproduction Instructions

To reproduce the project from the repository root:

### 1. Open the R project

```r
open Zhengyang_Ding_AEDS6400_blog7.Rproj
```

### 2. Run the scripts in order

```r
source("code/data_scrape.R")
source("code/data_clean.R")
source("code/data_plot.R")
```

### 3. View the output

- cleaned dataset: `data/cleaned_data/world_bank_gdp_urban_country_2000_2024.csv`
- interactive figure: `figure/gdp_urban_interactive.html`

Open the HTML file in a browser to explore the animated relationship between GDP per capita and urban population over time.

## Expected Interpretation

The project is designed to examine whether countries with higher real GDP per capita also tend to have larger urban populations. A positive relationship would suggest that economic development and urbanization are closely linked across the global country panel.

By comparing countries within and across continents, the project provides a concise but informative macro-level view of how economic development and urbanization evolve together.

## Notes

The workflow is intentionally modular:

- `data_scrape.R` obtains the raw inputs,
- `data_clean.R` standardizes and filters the data,
- `data_plot.R` generates the actual analytical output.

This separation keeps the project easy to extend, debug, and rerun.

The repository is configured to keep all required data, scripts, and generated analytical outputs tracked, while ignoring only transient editor, system, and R runtime files.
