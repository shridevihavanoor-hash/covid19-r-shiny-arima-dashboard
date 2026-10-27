
# ==========================================
# COVID-19 PROJECT - LESSON 4
# EXPLORATORY DATA ANALYSIS (EDA)
# ==========================================

# STEP 1: Install dplyr if not installed
if (!requireNamespace("dplyr", quietly = TRUE)) {
  install.packages("dplyr")
}

# STEP 2: Load library
library(dplyr)

# STEP 3: Import cleaned dataset
covid_clean <- read.csv(
  "data/processed/covid_clean.csv"
)

# STEP 4: Convert date column
covid_clean$date <- as.Date(covid_clean$date)

# STEP 5: Check data structure
str(covid_clean)

# STEP 6: Check countries
unique(covid_clean$location)

# STEP 7: Count records per country
table(covid_clean$location)

# STEP 8: Create country-level summary
country_summary <- covid_clean %>%
  group_by(location) %>%
  summarise(
    total_cases = if (all(is.na(total_cases))) NA_real_
    else max(total_cases, na.rm = TRUE),
    
    total_deaths = if (all(is.na(total_deaths))) NA_real_
    else max(total_deaths, na.rm = TRUE),
    
    .groups = "drop"
  )

# STEP 9: Display country summary
print(country_summary)

# STEP 10: Save country summary
write.csv(
  country_summary,
  "data/processed/country_summary.csv",
  row.names = FALSE
)

# STEP 11: Open country summary
View(country_summary)

install.packages("ggplot2")
