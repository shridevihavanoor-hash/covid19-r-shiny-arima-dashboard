
# =============================================
# LESSON 5: COVID-19 TIME SERIES ANALYSIS
# =============================================

# 1. Load required libraries
library(dplyr)
library(ggplot2)

# 2. Load cleaned COVID-19 dataset
covid_clean <- read.csv(
  "data/processed/covid_clean.csv"
)

# 3. Convert date column to Date format
covid_clean$date <- as.Date(covid_clean$date)

# 4. Remove records with missing total cases
covid_trends <- covid_clean %>%
  filter(!is.na(total_cases))

# 5. Create a line chart
p2 <- ggplot(
  covid_trends,
  aes(
    x = date,
    y = total_cases,
    color = location
  )
) +
  geom_line(linewidth = 0.8) +
  labs(
    title = "COVID-19 Cumulative Cases Over Time",
    subtitle = "Comparison of Five Countries",
    x = "Date",
    y = "Total Reported Cases",
    color = "Country"
  ) +
  theme_minimal()

# 6. Display chart
print(p2)

# 7. Save chart
dir.create("outputs", showWarnings = FALSE)

ggsave(
  "outputs/covid_time_series.png",
  plot = p2,
  width = 12,
  height = 6,
  dpi = 300
)

# 8. Verify saved file
file.exists("outputs/covid_time_series.png")



# ==========================================
# DAILY COVID-19 CASES
# ==========================================

# Remove missing observations
covid_daily <- covid_clean %>%
  filter(!is.na(new_cases))

# Create daily cases chart
p3 <- ggplot(
  covid_daily,
  aes(
    x = date,
    y = new_cases,
    color = location
  )
) +
  geom_line(linewidth = 0.6) +
  labs(
    title = "Daily Reported COVID-19 Cases",
    x = "Date",
    y = "New Cases",
    color = "Country"
  ) +
  theme_minimal()

# Display chart
print(p3)

# Save chart
ggsave(
  "outputs/covid_daily_cases.png",
  plot = p3,
  width = 12,
  height = 6,
  dpi = 300
)

