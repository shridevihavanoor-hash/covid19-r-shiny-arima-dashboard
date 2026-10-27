
# STEP 2: Download COVID-19 Dataset

# Create a folder called data
dir.create("data", showWarnings = FALSE)

# Official historical dataset from Our World in Data
dataset_url <- paste0(
  "https://raw.githubusercontent.com/",
  "owid/covid-19-data/master/public/data/",
  "owid-covid-data.csv"
)

# Download the CSV file
download.file(
  url = dataset_url,
  destfile = "data/owid-covid-data.csv",
  mode = "wb"
)

# Load the dataset
covid_data <- read.csv(
  "data/owid-covid-data.csv"
)

# Display first 6 rows
head(covid_data)

# Check number of rows and columns
dim(covid_data)

# Display column names
names(covid_data)


# STEP 1: Increase download timeout to 10 minutes
options(timeout = 600)

# STEP 2: Create data folder
dir.create("data", showWarnings = FALSE)

# STEP 3: Dataset URL
dataset_url <- paste0(
  "https://raw.githubusercontent.com/",
  "owid/covid-19-data/master/public/data/",
  "owid-covid-data.csv"
)

# STEP 4: Delete incomplete download if present
if (file.exists("data/owid-covid-data.csv")) {
  file.remove("data/owid-covid-data.csv")
}

# STEP 5: Download real dataset
download.file(
  url = dataset_url,
  destfile = "data/owid-covid-data.csv",
  method = "libcurl",
  mode = "wb"
)

# STEP 6: Load dataset into R
covid_data <- read.csv(
  "data/owid-covid-data.csv"
)

# STEP 7: Check dataset
dim(covid_data)

# STEP 8: Display first 6 rows
head(covid_data)

# STEP 9: Check column names
names(covid_data)

# STEP 10: Open dataset viewer
View(covid_data)



# COVID-19 DATA CLEANING
# Lesson 3 - Step 1

# Load the downloaded dataset if needed
if (!exists("covid_data")) {
  covid_data <- read.csv(
    "data/owid-covid-data.csv"
  )
}

# 1. Check total rows and columns
dim(covid_data)

# 2. View first 10 records
head(covid_data, 10)

# 3. Check column names
names(covid_data)

# 4. Check data structure and data types
str(covid_data)

# 5. Count missing values in every column
missing_values <- colSums(is.na(covid_data))

# 6. Display the columns with most missing values
sort(missing_values, decreasing = TRUE)[1:15]

# 7. Count duplicate country-date combinations
sum(duplicated(covid_data[c("iso_code", "date")]))


# =====================================
# COVID-19 DATA CLEANING - LESSON 3.2
# =====================================

# 1. Load dataset if not already loaded
if (!exists("covid_data")) {
  covid_data <- read.csv(
    "data/owid-covid-data.csv"
  )
}

# 2. Convert date column to Date format
covid_data$date <- as.Date(covid_data$date)

# Check date column
class(covid_data$date)

# 3. Check duplicate records by country and date
sum(duplicated(
  covid_data[c("iso_code", "date")]
))

# 4. Remove duplicate country-date records
covid_data <- covid_data[
  !duplicated(covid_data[c("iso_code", "date")]),
]

# 5. Select five countries
selected_countries <- c(
  "India",
  "United Kingdom",
  "United States",
  "Canada",
  "Germany"
)

# 6. Filter selected countries
covid_filtered <- subset(
  covid_data,
  location %in% selected_countries
)

# 7. Select important columns
required_columns <- c(
  "iso_code",
  "continent",
  "location",
  "date",
  "total_cases",
  "new_cases",
  "total_deaths",
  "new_deaths",
  "people_vaccinated_per_hundred"
)

# Check whether all required columns exist
missing_columns <- setdiff(
  required_columns,
  names(covid_filtered)
)

if (length(missing_columns) > 0) {
  stop(
    "Missing columns: ",
    paste(missing_columns, collapse = ", ")
  )
}

covid_clean <- covid_filtered[
  , required_columns
]

# 8. Sort by country and date
covid_clean <- covid_clean[
  order(covid_clean$location, covid_clean$date),
]

# 9. Reset row numbers
rownames(covid_clean) <- NULL

# 10. Inspect cleaned dataset
head(covid_clean, 10)

# 11. Check dimensions
dim(covid_clean)

# 12. Check missing values
colSums(is.na(covid_clean))

# 13. Check number of records per country
table(covid_clean$location)

# 14. Create processed data folder
dir.create(
  "data/processed",
  recursive = TRUE,
  showWarnings = FALSE
)

# 15. Save cleaned dataset
write.csv(
  covid_clean,
  "data/processed/covid_clean.csv",
  row.names = FALSE
)

# 16. Open data viewer
View(covid_clean)




