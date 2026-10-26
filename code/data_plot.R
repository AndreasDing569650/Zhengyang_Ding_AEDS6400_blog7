# ============================================================
# Blog 7 - Interactive Data Visualization with Plotly
# Real GDP per Capita and Urban Population
# ============================================================


# ============================================================
# 0. Load packages
# ============================================================

library(dplyr)
library(ggplot2)
library(plotly)


# ============================================================
# 1. Load cleaned data
# ============================================================

world_data <- read.csv(
  "D:/Rproject/6400-blog7/world_bank_gdp_urban_country_2000_2024.csv"
)

head(world_data)
str(world_data)
summary(world_data)


# ============================================================
# 2. Basic data checks
# ============================================================

# Number of observations
nrow(world_data)

# Number of countries/entities
world_data |>
  distinct(country_code, country) |>
  nrow()

# Year range
range(world_data$year)

# Number of countries by continent
world_data |>
  distinct(country_code, country, continent) |>
  count(continent)

# Check missing values
colSums(is.na(world_data))

# Check duplicated country-year observations
world_data |>
  count(country_code, year) |>
  filter(n > 1)


# ============================================================
# 3. Summary statistics by continent
# ============================================================

continent_summary <- world_data |>
  group_by(continent) |>
  summarise(
    n_countries = n_distinct(country_code),
    mean_gdp = mean(real_gdp_per_capita, na.rm = TRUE),
    mean_urban = mean(urban_population, na.rm = TRUE),
    .groups = "drop"
  )

continent_summary


# ============================================================
# 4. Summary statistics by year
# ============================================================

year_summary <- world_data |>
  group_by(year) |>
  summarise(
    mean_gdp = mean(real_gdp_per_capita, na.rm = TRUE),
    mean_urban = mean(urban_population, na.rm = TRUE),
    .groups = "drop"
  )

year_summary


# ============================================================
# 5. Create log GDP per capita
# ============================================================

world_data <- world_data |>
  mutate(
    log_gdp_per_capita = log10(real_gdp_per_capita)
  )

summary(world_data$log_gdp_per_capita)


# ============================================================
# 6. Static scatterplot for initial inspection
# ============================================================

ggplot(
  world_data |> filter(year == 2024),
  aes(
    x = log_gdp_per_capita,
    y = urban_population,
    color = continent
  )
) +
  geom_point(
    alpha = 0.7,
    size = 2.5
  ) +
  labs(
    title = "Urban Population and Real GDP per Capita, 2024",
    x = "Real GDP per Capita (log scale)",
    y = "Urban Population (%)",
    color = "Continent"
  ) +
  theme_minimal()


# ============================================================
# 7. Calculate correlation for each year
# ============================================================

year_correlation <- world_data |>
  group_by(year) |>
  summarise(
    correlation = cor(
      log_gdp_per_capita,
      urban_population,
      use = "complete.obs"
    ),
    .groups = "drop"
  )

year_correlation


# ============================================================
# 8. Correlation over time
# ============================================================

ggplot(
  year_correlation,
  aes(
    x = year,
    y = correlation
  )
) +
  geom_line(
    linewidth = 1
  ) +
  geom_point(
    size = 2
  ) +
  geom_hline(
    yintercept = 0,
    linetype = "dashed"
  ) +
  labs(
    title = "Correlation Between GDP per Capita and Urban Population",
    x = "Year",
    y = "Correlation"
  ) +
  theme_minimal()


# ============================================================
# 9. Prepare data for Plotly
# ============================================================

plot_data <- world_data |>
  filter(
    !is.na(log_gdp_per_capita),
    !is.na(urban_population),
    !is.na(continent)
  ) |>
  arrange(year, continent, country)


# ============================================================
# 10. Interactive Plotly scatterplot
# ============================================================

p <- plot_ly(
  data = plot_data,
  x = ~log_gdp_per_capita,
  y = ~urban_population,
  frame = ~year,
  color = ~continent,
  colors = "Set2",
  type = "scatter",
  mode = "markers",
  marker = list(
    size = 9,
    opacity = 0.75
  ),
  text = ~paste(
    "<b>", country, "</b>",
    "<br>Year: ", year,
    "<br>Real GDP per capita: $",
    format(round(real_gdp_per_capita, 0), big.mark = ","),
    "<br>Urban population: ",
    round(urban_population, 1), "%",
    "<br>Continent: ", continent
  ),
  hoverinfo = "text"
) |>
  layout(
    title = list(
      text = "Urban Population and Real GDP per Capita"
    ),
    xaxis = list(
      title = "Real GDP per Capita (log scale)"
    ),
    yaxis = list(
      title = "Urban Population (%)",
      range = c(0, 100)
    ),
    legend = list(
      title = list(
        text = "Continent"
      )
    )
  ) |>
  animation_opts(
    frame = 1000,
    transition = 500,
    redraw = FALSE
  ) |>
  animation_slider(
    currentvalue = list(
      prefix = "Year: "
    )
  ) |>
  animation_button(
    x = 1,
    xanchor = "right",
    y = 0,
    yanchor = "top"
  )

p


# ============================================================
# 11. Save interactive visualization
# ============================================================

htmlwidgets::saveWidget(
  p,
  "gdp_urban_interactive.html",
  selfcontained = TRUE
)