
# Install necessary packages if missing
packages <- c(
  "shiny",
  "ggplot2",
  "plotly",
  "dplyr",
  "forecast"
)

for (pkg in packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
}

# Load packages
library(shiny)
library(ggplot2)
library(plotly)
library(dplyr)
library(forecast)
