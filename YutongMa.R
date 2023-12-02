library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)
library(rsconnect)
# Set the working directory to the project directory
setwd("/Users/biubiu/Desktop/23fall/stat380/ExtraCredit/")

# Load merged dataset
merged_data <- read.csv("merged_dataset.csv")

# Define UI
ui <- fluidPage(
  titlePanel("Yutong Ma - World Bank Indicators Explorer"),
  sidebarLayout(
    sidebarPanel(
      selectInput("indicator", "Select Indicator", choices = unique(merged_data$Indicator.Name)),
      selectInput("countries", "Select Countries", choices = unique(merged_data$Country.Name), multiple = TRUE)
    ),
    mainPanel(
      plotOutput("line_plot")
    )
  )
)

# Define Server
server <- function(input, output) {
  filtered_data <- reactive({
    subset(merged_data, Country.Name %in% input$countries & Indicator.Name == input$indicator)
  })
  
  output$line_plot <- renderPlot({
    ggplot(filtered_data(), aes(x = Year, y = Value, color = Country.Name)) +
      geom_line() +
      labs(title = input$indicator, y = unique(filtered_data()$Unit.Measure))
  })
}
# Run the Shiny app
shinyApp(ui, server)

