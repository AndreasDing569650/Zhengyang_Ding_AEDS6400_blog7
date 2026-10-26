library(dplyr)

world_data <- read.csv(
  "D:/Rproject/6400-blog7/world_bank_gdp_urban_2000_2024.csv"
)

# ============================================================
# 1. Show all unique entities
# ============================================================

all_entities <- world_data |>
  distinct(country_code, country) |>
  arrange(country)

all_entities
# ============================================================
# Remove World Bank aggregate entities
# ============================================================

aggregate_codes <- c(
  "AFE", "AFW", "ARB", "CEB",
  "CSS", "EAR", "EAS", "TEA", "EAP",
  "EMU", "ECS", "TEC", "ECA", "EUU",
  "FCV", "HPC", "HIC", "IBD", "IBT",
  "IDB", "IDX", "IDA", "LTE", "LCN",
  "LAC", "TLA", "LDC", "LMY", "MEA",
  "TMN", "MNA", "MIC", "NAC", "OED",
  "OSS", "PSS", "PST", "PRE", "SAS",
  "TSA", "SSF", "TSS", "SSA", "WLD"
)

world_data_country <- world_data |>
  filter(
    !country_code %in% aggregate_codes
  )

# Check remaining entities
country_list <- world_data_country |>
  distinct(country_code, country) |>
  arrange(country)

country_list
nrow(country_list)
head(country_list, 20)
tail(country_list, 20)
# ============================================================
# Remove remaining aggregate entities
# ============================================================

world_data_country <- world_data |>
  filter(
    !country_code %in% aggregate_codes,
    !is.na(country_code),
    country_code != "",
    country_code != "SST"
  )

# Check remaining entities
country_list <- world_data_country |>
  distinct(country_code, country) |>
  arrange(country)

nrow(country_list)

country_list

# ============================================================
# Add Continent Information
# ============================================================

continent_data <- data.frame(
  country_code = c(
    # Africa
    "DZA", "AGO", "BEN", "BWA", "BFA", "BDI",
    "CPV", "CMR", "CAF", "TCD", "COM", "COD",
    "COG", "CIV", "DJI", "EGY", "GNQ", "ERI",
    "SWZ", "ETH", "GAB", "GMB", "GHA", "GIN",
    "GNB", "KEN", "LSO", "LBR", "LBY", "MDG",
    "MWI", "MLI", "MRT", "MUS", "MAR", "MOZ",
    "NAM", "NER", "NGA", "RWA", "STP", "SEN",
    "SLE", "SOM", "ZAF", "SSD", "SDN", "TZA",
    "TGO", "TUN", "UGA", "ZMB", "ZWE",
    
    # Asia
    "AFG", "ARM", "AZE", "BHR", "BGD", "BTN",
    "BRN", "KHM", "CHN", "CYP", "GEO", "HKG",
    "IND", "IDN", "IRN", "IRQ", "ISR", "JPN",
    "JOR", "KAZ", "KWT", "KGZ", "LAO", "LBN",
    "MAC", "MYS", "MDV", "MNG", "MMR", "NPL",
    "OMN", "PAK", "PHL", "QAT", "SAU", "SGP",
    "KOR", "LKA", "SYR", "TJK", "THA", "TLS",
    "TUR", "TKM", "ARE", "UZB", "VNM", "PSE",
    "YEM",
    
    # Europe
    "ALB", "AUT", "BLR", "BEL", "BIH", "BGR",
    "HRV", "CZE", "DNK", "EST", "FIN", "FRA",
    "DEU", "GRC", "HUN", "ISL", "IRL", "ITA",
    "LVA", "LTU", "LUX", "MLT", "MDA", "MNE",
    "NLD", "MKD", "NOR", "POL", "PRT", "ROU",
    "RUS", "SRB", "SVK", "SVN", "ESP", "SWE",
    "CHE", "UKR", "GBR",
    
    # North America
    "BHS", "BRB", "BLZ", "CAN", "CRI", "CUB",
    "DOM", "SLV", "GTM", "HTI", "HND", "JAM",
    "MEX", "NIC", "PAN", "PRI", "TTO", "USA",
    "VIR",
    
    # South America
    "ARG", "BOL", "BRA", "CHL", "COL", "ECU",
    "GUY", "PRY", "PER", "SUR", "URY", "VEN",
    
    # Oceania
    "AUS", "FJI", "GUM", "NCL", "NZL", "PNG",
    "WSM", "SLB", "TON", "VUT", "PYF"
  ),
  
  continent = c(
    # Africa
    rep("Africa", 53),
    
    # Asia
    rep("Asia", 49),
    
    # Europe
    rep("Europe", 39),
    
    # North America
    rep("North America", 19),
    
    # South America
    rep("South America", 12),
    
    # Oceania
    rep("Oceania", 11)
  ),
  
  stringsAsFactors = FALSE
)

# ============================================================
# Merge continent information
# ============================================================

world_data_country <- world_data_country |>
  left_join(
    continent_data,
    by = "country_code"
  )

# ============================================================
# Check continent assignment
# ============================================================

world_data_country |>
  distinct(country_code, country, continent) |>
  arrange(continent, country)

# Check whether any country is missing a continent
world_data_country |>
  filter(is.na(continent)) |>
  distinct(country_code, country)

# Number of countries in each continent
table(
  continent_data$continent
)
# ============================================================
# Save cleaned country-level data
# ============================================================

write.csv(
  world_data_country,
  "D:/Rproject/6400-blog7/world_bank_gdp_urban_country_2000_2024.csv",
  row.names = FALSE
)