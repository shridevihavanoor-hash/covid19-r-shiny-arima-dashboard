
# ===========================================
# LESSON 6: COVID-19 VACCINATION ANALYSIS
# ===========================================

# STEP 1: Load packages
library(dplyr)
library(ggplot2)

# STEP 2: Load cleaned dataset
covid_clean <- read.csv(
  "data/processed/covid_clean.csv"
)

# STEP 3: Convert date column
covid_clean$date <- as.Date(covid_clean$date)

# STEP 4: Check the column names
names(covid_clean)

# STEP 5: Select vaccination information
vaccination_data <- covid_clean %>%
  select(
    location,
    date,
    people_vaccinated_per_hundred,
    new_cases
  )

# STEP 6: Remove missing vaccination values
vaccination_data <- vaccination_data %>%
  filter(
    !is.na(people_vaccinated_per_hundred)
  )

# STEP 7: Display first 10 rows
head(vaccination_data, 10)

# STEP 8: Count records for each country
table(vaccination_data$location)




# ======================================
# VACCINATION PROGRESS LINE CHART
# ======================================

p4 <- ggplot(
  vaccination_data,
  aes(
    x = date,
    y = people_vaccinated_per_hundred,
    color = location
  )
) +
  geom_line(linewidth = 1) +
  labs(
    title = "COVID-19 Vaccination Progress",
    subtitle = "Vaccination Coverage Across Five Countries",
    x = "Date",
    y = "People Vaccinated Per Hundred",
    color = "Country"
  ) +
  theme_minimal()

# Display chart
print(p4)

# Create outputs folder
dir.create("outputs", showWarnings = FALSE)

# Save chart
ggsave(
  "outputs/vaccination_progress.png",
  plot = p4,
  width = 12,
  height = 6,
  dpi = 300
)



# ======================================
# VACCINATION COUNTRY COMPARISON
# ======================================

# Sort by country and date
vaccination_summary <- vaccination_data %>%
  arrange(location, desc(date)) %>%
  group_by(location) %>%
  slice_head(n = 1) %>%
  ungroup()

# Display summary
print(vaccination_summary)

# Create bar chart
p5 <- ggplot(
  vaccination_summary,
  aes(
    x = reorder(
      location,
      people_vaccinated_per_hundred
    ),
    y = people_vaccinated_per_hundred
  )
) +
  geom_col(fill = "darkgreen") +
  coord_flip() +
  labs(
    title = "Latest Available Vaccination Coverage",
    x = "Country",
    y = "People Vaccinated Per Hundred"
  ) +
  theme_minimal()

# Display chart
print(p5)

# Save chart
ggsave(
  "outputs/vaccination_comparison.png",
  plot = p5,
  width = 10,
  height = 6,
  dpi = 300
)


