# COVID-19 Interactive Dashboard and ARIMA Forecasting Using R

## Project Overview

This project develops an interactive COVID-19 analytics dashboard using R, Shiny, ggplot2, Plotly, and ARIMA forecasting.

It demonstrates data collection, preprocessing, exploratory data analysis, time-series visualisation, vaccination analysis, and predictive modelling.

## Objectives

- Analyse historical COVID-19 case and death trends.
- Compare pandemic patterns across India, the United Kingdom, the United States, Canada, and Germany.
- Visualise vaccination coverage over time.
- Explore correlations between vaccination coverage and case counts.
- Develop and evaluate an ARIMA forecasting model.
- Build an interactive dashboard with country and date filters.

## Tools and Technologies

- **Programming:** R
- **IDE:** RStudio
- **Data analysis:** dplyr
- **Visualisation:** ggplot2, Plotly
- **Time-series forecasting:** forecast (ARIMA)
- **Dashboard:** Shiny
- **Data source:** Our World in Data (OWID)
- **Version control:** Git and GitHub

## Project Structure

- `03_Data_Cleaning.R` — data preparation and country filtering
- `04_Exploratory_Data_Analysis.R` — descriptive statistics and country comparisons
- `05_Time_Series_Analysis.R` — historical case trends
- `06_Vaccination_Analysis.R` — vaccination coverage and correlation analysis
- `07_ARIMA_Forecasting.R` — forecasting and model evaluation
- `app.R` — interactive Shiny dashboard
- `outputs/` — generated charts and model results

## Dataset

Source: [Our World in Data COVID-19 Repository](https://github.com/owid/covid-19-data)

The project uses historical public COVID-19 data. The archived OWID GitHub data is not a live reporting source.

## Running the Project

1. Install R and RStudio.
2. Install the required R packages.
3. Download the historical OWID COVID-19 dataset into the `data` directory.
4. Run the data cleaning script.
5. Run the analysis and forecasting scripts.
6. Launch the dashboard with:

```r
shiny::runApp("app.R")
```

Run these commands from the project root directory.

## Forecasting Limitations

The ARIMA analysis is a historical forecasting exercise. Forecast performance depends on reporting quality, continuity, and model assumptions. Correlations between vaccination coverage and reported infections do not establish causation.

## Project Status

Educational and research implementation. Individual components and forecasting results should be validated against the downloaded dataset before being reported as completed findings.


## Project result:
1. Install R and RStudio.

2. Install the required R packages.

<img width="512" height="472" alt="image" src="https://github.com/user-attachments/assets/abcfcae4-7199-471d-8349-65f907b5b343" />

3. Download the historical OWID COVID-19 dataset into the `data` directory.
# Download only if the file is missing
if (!file.exists(file_path)) {
  download.file(
    url = dataset_url,
    destfile = file_path,
    mode = "wb",
    method = "libcurl"
  )
}

# Load the dataset
covid_data <- read.csv(file_path)

4. Run the data cleaning script.
<img width="1241" height="951" alt="image" src="https://github.com/user-attachments/assets/9b83a964-b654-4d89-b8c4-f9d395828df8" />

5. Run the analysis and forecasting scripts.
<img width="1911" height="963" alt="image" src="https://github.com/user-attachments/assets/68a131d2-299d-4228-80c9-d57a790bc42e" />
<img width="1917" height="962" alt="image" src="https://github.com/user-attachments/assets/1faa1e0b-ea5e-4d5d-ac2b-af7e5456522b" />
<img width="1907" height="975" alt="image" src="https://github.com/user-attachments/assets/e8e2642d-0b3a-4b58-adf0-49c0a8c01ca2" />
<img width="1231" height="531" alt="image" src="https://github.com/user-attachments/assets/f9ec400d-1ca2-40a6-8586-0a610278e0d9" />


7. Launch the dashboard with:
<img width="1121" height="962" alt="image" src="https://github.com/user-attachments/assets/a8d6fa16-954c-4661-8729-ba4a9b5a9933" />




# COVID-19 DATA ANALYSIS AND ARIMA FORECASTING DASHBOARD
# R + Shiny + ggplot2 + Plotly + ARIMA



# STEP 1: INSTALL REQUIRED PACKAGES

packages <- c(
  "shiny", "dplyr", "ggplot2",
  "plotly", "forecast"
)

for (pkg in packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(
      pkg,
      repos = "https://cloud.r-project.org"
    )
  }
}

library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(forecast)


# STEP 2: CREATE PROJECT FOLDERS

dir.create("data", showWarnings = FALSE)
dir.create("outputs", showWarnings = FALSE)


# STEP 3: DOWNLOAD COVID-19 DATASET

options(timeout = 600)

dataset_url <- paste0(
  "https://raw.githubusercontent.com/",
  "owid/covid-19-data/master/public/data/",
  "owid-covid-data.csv"
)

file_path <- "data/owid-covid-data.csv"

if (!file.exists(file_path)) {
  download.file(
    dataset_url,
    file_path,
    mode = "wb"
  )
}


# STEP 4: LOAD DATASET

covid_data <- read.csv(file_path)

print(dim(covid_data))
print(head(covid_data))


# STEP 5: CLEAN DATASET

countries <- c(
  "India",
  "United Kingdom",
  "United States",
  "Canada",
  "Germany"
)

covid_clean <- covid_data %>%
  filter(location %in% countries) %>%
  select(
    iso_code,
    continent,
    location,
    date,
    total_cases,
    new_cases,
    total_deaths,
    new_deaths,
    people_vaccinated_per_hundred
  ) %>%
  mutate(date = as.Date(date)) %>%
  filter(!is.na(date)) %>%
  distinct(iso_code, date, .keep_all = TRUE) %>%
  arrange(location, date)

# Check missing values
print(colSums(is.na(covid_clean)))

# Save cleaned dataset
write.csv(
  covid_clean,
  "data/covid_clean.csv",
  row.names = FALSE
)


# STEP 6: COUNTRY SUMMARY

latest_value <- function(x) {
  x <- x[!is.na(x)]

  if (length(x) == 0) {
    return(NA_real_)
  }

  tail(x, 1)
}

country_summary <- covid_clean %>%
  group_by(location) %>%
  summarise(
    total_cases = latest_value(total_cases),
    total_deaths = latest_value(total_deaths),
    vaccination = latest_value(
      people_vaccinated_per_hundred
    ),
    .groups = "drop"
  )

print(country_summary)

write.csv(
  country_summary,
  "outputs/country_summary.csv",
  row.names = FALSE
)


# STEP 7: CREATE COUNTRY COMPARISON CHART

p1 <- ggplot(
  country_summary,
  aes(
    x = reorder(location, total_cases),
    y = total_cases
  )
) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(
    title = "COVID-19 Cases by Country",
    x = "Country",
    y = "Reported Cases"
  ) +
  theme_minimal()

ggsave(
  "outputs/country_comparison.png",
  plot = p1,
  width = 10,
  height = 6
)


# STEP 8: CREATE CASE TREND CHART

p2 <- ggplot(
  covid_clean,
  aes(
    x = date,
    y = total_cases,
    color = location
  )
) +
  geom_line(linewidth = 0.7, na.rm = TRUE) +
  labs(
    title = "COVID-19 Case Trends",
    x = "Date",
    y = "Cumulative Cases"
  ) +
  theme_minimal()

ggsave(
  "outputs/case_trends.png",
  plot = p2,
  width = 12,
  height = 6
)


# STEP 9: CREATE VACCINATION CHART

p3 <- ggplot(
  covid_clean,
  aes(
    x = date,
    y = people_vaccinated_per_hundred,
    color = location
  )
) +
  geom_line(linewidth = 0.7, na.rm = TRUE) +
  labs(
    title = "COVID-19 Vaccination Progress",
    x = "Date",
    y = "People Vaccinated Per Hundred"
  ) +
  theme_minimal()

ggsave(
  "outputs/vaccination_progress.png",
  plot = p3,
  width = 12,
  height = 6
)


# STEP 10: CREATE SHINY USER INTERFACE

ui <- fluidPage(

  titlePanel(
    "COVID-19 Interactive Dashboard"
  ),

  sidebarLayout(

    sidebarPanel(

      selectInput(
        "country",
        "Select Country",
        choices = countries,
        selected = "India"
      ),

      dateRangeInput(
        "dates",
        "Select Date Range",
        start = min(covid_clean$date),
        end = max(covid_clean$date)
      ),

      downloadButton(
        "download",
        "Download Filtered Data"
      )
    ),

    mainPanel(

      tabsetPanel(

        tabPanel(
          "Overview",
          h3("COVID-19 Summary"),
          tableOutput("summary")
        ),

        tabPanel(
          "Case Trends",
          plotlyOutput("cases_plot")
        ),

        tabPanel(
          "Vaccination",
          plotlyOutput("vaccination_plot")
        ),

        tabPanel(
          "ARIMA Forecast",
          h3("Historical Weekly Case Forecast"),
          p("Forecast horizon: 14 weeks"),
          verbatimTextOutput("model_info"),
          plotOutput("forecast_plot"),
          tableOutput("forecast_table")
        )
      )
    )
  )
)


# STEP 11: CREATE SERVER LOGIC

server <- function(input, output, session) {

  # Filter selected country and dates

  filtered_data <- reactive({

    req(input$country, input$dates)

    covid_clean %>%
      filter(
        location == input$country,
        date >= input$dates[1],
        date <= input$dates[2]
      ) %>%
      arrange(date)
  })


  # STEP 12: SHOW COUNTRY SUMMARY

  output$summary <- renderTable({

    df <- filtered_data()

    data.frame(
      Country = input$country,

      Total_Cases = latest_value(
        df$total_cases
      ),

      Total_Deaths = latest_value(
        df$total_deaths
      ),

      Vaccinated_Per_Hundred = latest_value(
        df$people_vaccinated_per_hundred
      )
    )
  })


  # STEP 13: INTERACTIVE CASE CHART

  output$cases_plot <- renderPlotly({

    df <- filtered_data()

    p <- ggplot(
      df,
      aes(
        x = date,
        y = total_cases
      )
    ) +
      geom_line(
        color = "blue",
        linewidth = 1,
        na.rm = TRUE
      ) +
      labs(
        title = "COVID-19 Case Trends",
        x = "Date",
        y = "Total Cases"
      ) +
      theme_minimal()

    ggplotly(p)
  })


  # STEP 14: INTERACTIVE VACCINATION CHART

  output$vaccination_plot <- renderPlotly({

    df <- filtered_data()

    p <- ggplot(
      df,
      aes(
        x = date,
        y = people_vaccinated_per_hundred
      )
    ) +
      geom_line(
        color = "darkgreen",
        linewidth = 1,
        na.rm = TRUE
      ) +
      labs(
        title = "Vaccination Progress",
        x = "Date",
        y = "People Vaccinated Per Hundred"
      ) +
      theme_minimal()

    ggplotly(p)
  })


  # STEP 15: PREPARE ARIMA DATA
  # Use seven-day reporting periods.
  # Missing weeks are not replaced with zero.

  weekly_data <- reactive({

    df <- filtered_data() %>%
      filter(
        !is.na(date),
        !is.na(new_cases)
      )

    validate(
      need(
        nrow(df) >= 30,
        "Not enough reported case observations."
      )
    )

    df <- df %>%
      mutate(
        week = as.Date(
          cut(date, breaks = "week")
        )
      ) %>%
      group_by(week) %>%
      summarise(
        weekly_cases = sum(new_cases),
        .groups = "drop"
      ) %>%
      arrange(week)

    # Retain only the latest continuous
    # sequence of reported weeks.

    if (nrow(df) > 1) {

      gaps <- which(diff(df$week) != 7)

      if (length(gaps) > 0) {
        df <- df[
          (tail(gaps, 1) + 1):nrow(df),
        ]
      }
    }

    validate(
      need(
        nrow(df) >= 30,
        paste(
          "Insufficient continuous weekly data.",
          "Try another country or date range."
        )
      )
    )

    df
  })


  # STEP 16: BUILD ARIMA MODEL

  arima_result <- reactive({

    df <- weekly_data()

    cases_ts <- ts(
      df$weekly_cases,
      frequency = 1
    )

    # Train using first 80%
    n <- length(cases_ts)
    train_n <- floor(n * 0.80)

    train <- ts(cases_ts[1:train_n])

    test <- as.numeric(
      cases_ts[(train_n + 1):n]
    )

    model <- auto.arima(
      train,
      seasonal = FALSE
    )

    test_forecast <- forecast(
      model,
      h = length(test)
    )

    predictions <- as.numeric(
      test_forecast$mean
    )

    MAE <- mean(abs(test - predictions))

    RMSE <- sqrt(
      mean((test - predictions)^2)
    )

    # Refit model on all available data

    final_model <- auto.arima(
      cases_ts,
      seasonal = FALSE
    )

    future <- forecast(
      final_model,
      h = 14,
      level = 95
    )

    list(
      model = final_model,
      future = future,
      MAE = MAE,
      RMSE = RMSE,
      last_week = max(df$week)
    )
  })


  # STEP 17: DISPLAY MODEL ACCURACY

  output$model_info <- renderText({

    result <- arima_result()

    paste0(
      "ARIMA Model: ",
      as.character(result$model),
      "\n\nMAE: ",
      round(result$MAE, 2),
      "\nRMSE: ",
      round(result$RMSE, 2)
    )
  })


  # STEP 18: DISPLAY ARIMA FORECAST

  output$forecast_plot <- renderPlot({

    result <- arima_result()

    plot(
      result$future,
      main = paste(
        "Historical ARIMA Forecast -",
        input$country
      ),
      xlab = "Weeks",
      ylab = "Weekly Reported Cases"
    )
  })


  # STEP 19: FORECAST RESULTS TABLE

  output$forecast_table <- renderTable({

    result <- arima_result()

    data.frame(
      Week = seq(
        result$last_week + 7,
        by = "7 days",
        length.out = 14
      ),

      Forecast = round(
        as.numeric(result$future$mean)
      ),

      Lower_95 = round(
        as.numeric(result$future$lower[, 1])
      ),

      Upper_95 = round(
        as.numeric(result$future$upper[, 1])
      )
    )
  })


  # STEP 20: DOWNLOAD FILTERED DATA

  output$download <- downloadHandler(

    filename = function() {
      paste0(
        "COVID19_",
        gsub(" ", "_", input$country),
        ".csv"
      )
    },

    content = function(file) {
      write.csv(
        filtered_data(),
        file,
        row.names = FALSE
      )
    }
  )

}


# STEP 21: RUN SHINY DASHBOARD

shinyApp(
  ui = ui,
  server = server
)



