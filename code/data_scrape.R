library(jsonlite)
library(dplyr)


# ============================================================
# 1. Download Real GDP per Capita
# ============================================================

gdp_url <- paste0(
  "https://api.worldbank.org/v2/country/all/indicator/",
  "NY.GDP.PCAP.KD",
  "?date=2000:2024",
  "&format=json",
  "&per_page=20000"
)

gdp_raw <- fromJSON(
  gdp_url,
  flatten = TRUE
)

# Check whether the API returned data
str(gdp_raw)

# Extract observations
gdp_data <- gdp_raw[[2]]

# Keep relevant variables
gdp <- gdp_data |>
  transmute(
    country_code = countryiso3code,
    country = country.value,
    year = as.integer(date),
    real_gdp_per_capita = as.numeric(value)
  )


# ============================================================
# 2. Download Urban Population
# ============================================================

urban_url <- paste0(
  "https://api.worldbank.org/v2/country/all/indicator/",
  "SP.URB.TOTL.IN.ZS",
  "?date=2000:2024",
  "&format=json",
  "&per_page=20000"
)

urban_raw <- fromJSON(
  urban_url,
  flatten = TRUE
)

# Check whether the API returned data
str(urban_raw)

# Extract observations
urban_data <- urban_raw[[2]]

# Keep relevant variables
urban <- urban_data |>
  transmute(
    country_code = countryiso3code,
    country = country.value,
    year = as.integer(date),
    urban_population = as.numeric(value)
  )


# ============================================================
# 3. Merge the Two Datasets
# ============================================================

world_data <- gdp |>
  inner_join(
    urban,
    by = c("country_code", "country", "year")
  ) |>
  filter(
    !is.na(real_gdp_per_capita),
    !is.na(urban_population)
  ) |>
  arrange(country, year)


# ============================================================
# 4. Check the Final Dataset
# ============================================================

head(world_data)

str(world_data)

summary(world_data)


# ============================================================
# 5. Save the Cleaned Dataset
# ============================================================

write.csv(
  world_data,
  "world_bank_gdp_urban_2000_2024.csv",
  row.names = FALSE
)