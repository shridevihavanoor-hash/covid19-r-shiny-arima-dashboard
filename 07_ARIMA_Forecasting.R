
# ======================================
# LESSON 7: ARIMA FORECASTING
# ======================================

# Install packages if needed
if (!requireNamespace("forecast", quietly = TRUE)) {
  install.packages("forecast")
}

if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2")
}

# Load packages
library(forecast)
library(ggplot2)

# Load cleaned data
covid_clean <- read.csv(
  "data/processed/covid_clean.csv"
)



# ======================================
# BUILD ARIMA MODEL
# ======================================

# Create weekly time series
cases_ts <- ts(
  weekly_cases$new_cases,
  frequency = 1
)

# Split data: 80% training, 20% testing
train_size <- floor(length(cases_ts) * 0.80)

training_data <- window(
  cases_ts,
  end = train_size
)

testing_data <- window(
  cases_ts,
  start = train_size + 1
)

# Train ARIMA on historical training data
arima_model <- auto.arima(
  training_data,
  seasonal = FALSE,
  stepwise = FALSE,
  approximation = FALSE
)

# Display model
summary(arima_model)


# Convert dates
covid_clean$date <- as.Date(covid_clean$date)

# Check dataset
head(covid_clean)




# ======================================
# PREPARE WEEKLY COVID-19 CASES
# ======================================

# Filter India and historical dates
india_data <- subset(
  covid_clean,
  location == "India" &
    date >= as.Date("2021-01-01") &
    date <= as.Date("2022-12-31")
)

# Keep valid dates
india_data <- india_data[
  !is.na(india_data$date),
]

# Inspect daily reporting values
summary(india_data$new_cases)

# Check whether new_cases is available
sum(!is.na(india_data$new_cases))

# Group dates into 7-day periods
india_data$week <- as.Date(
  cut(india_data$date, breaks = "week")
)

# Aggregate into weekly cases.
# Incomplete weeks remain missing.
weekly_cases <- aggregate(
  new_cases ~ week,
  data = india_data,
  FUN = function(x) {
    if (any(is.na(x)) || length(x) != 7) {
      return(NA_real_)
    }
    sum(x)
  },
  na.action = na.pass
)

# Exclude any partial or missing weeks
weekly_cases <- weekly_cases[
  !is.na(weekly_cases$new_cases),
]

# Ensure we have enough observations
if (nrow(weekly_cases) < 30) {
  stop(
    "Insufficient weekly observations. Check date range and missing data."
  )
}

# Check continuity of weeks
if (any(diff(weekly_cases$week) != 7)) {
  stop(
    "Missing weekly periods detected. Review reporting gaps before modelling."
  )
}

# Display first observations
head(weekly_cases, 10)

# Display number of weeks
nrow(weekly_cases)



# ======================================
# EVALUATE ARIMA MODEL
# ======================================

# Forecast the test period
test_forecast <- forecast(
  arima_model,
  h = length(testing_data)
)

# Predicted values
predicted <- as.numeric(test_forecast$mean)

# Actual values
actual <- as.numeric(testing_data)

# Mean Absolute Error
MAE <- mean(abs(actual - predicted))

# Root Mean Squared Error
RMSE <- sqrt(mean((actual - predicted)^2))

# Display results
cat("MAE:", round(MAE, 2), "\n")
cat("RMSE:", round(RMSE, 2), "\n")

# Create evaluation table
evaluation_results <- data.frame(
  Model = "ARIMA",
  MAE = MAE,
  RMSE = RMSE
)

# Save results
dir.create("outputs", showWarnings = FALSE)

write.csv(
  evaluation_results,
  "outputs/arima_evaluation.csv",
  row.names = FALSE
)





# ======================================
# 14-WEEK ARIMA FORECAST
# ======================================

# Refit using all available observations
final_model <- auto.arima(
  cases_ts,
  seasonal = FALSE
)

# Forecast next 14 weeks
future_forecast <- forecast(
  final_model,
  h = 14,
  level = 95
)

# Display forecast
print(future_forecast)

# Visualise
plot(
  future_forecast,
  main = "India COVID-19 ARIMA Forecast",
  xlab = "Weeks",
  ylab = "Weekly Reported Cases",
  col = "blue"
)

# Export forecast values
forecast_results <- data.frame(
  week = seq(
    from = max(weekly_cases$week) + 7,
    by = "7 days",
    length.out = 14
  ),
  predicted_cases = as.numeric(future_forecast$mean),
  lower_95 = as.numeric(future_forecast$lower[, 1]),
  upper_95 = as.numeric(future_forecast$upper[, 1])
)

write.csv(
  forecast_results,
  "outputs/arima_forecast.csv",
  row.names = FALSE
)

print(forecast_results)

#####

nrow(weekly_cases)
head(weekly_cases, 10)
