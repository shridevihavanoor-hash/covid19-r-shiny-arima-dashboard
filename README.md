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


