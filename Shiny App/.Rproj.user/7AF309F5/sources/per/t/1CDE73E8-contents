library(shiny)
library(shinydashboard)
library(plotly)
library(tidyverse)
library(ggthemes)

airbnb_data <- read.csv("airbnb-listings.csv", sep = ';', encoding = "UTF-8")

# Server Logic
server <- function(input, output) {
  set.seed(122)
  histdata <- rnorm(500)
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
  
  output$plot2 <- renderPlotly({
    plot_ly(
      data = airbnb_data,
      lat = ~Latitude,
      lon = ~Longitude,
      type = 'scattermapbox'
    ) %>%
      layout(
        mapbox = list(
          style = 'open-street-map',
          zoom = 4
        )
      )
  })
  
  # --- Individual Airbnb
  
  rval_airbnb <- reactive({
    airbnb_data %>%
      filter(ID == input$individual_airbnb)
  })
  
  output$image <- renderUI({
    # url <- filter(airbnb_data, ID == input$individual_airbnb)$Picture.Url
    url <- rval_airbnb()$Picture.Url
    tags$img(src = url)
  })
  
  
  output$table_listings <- DT::renderDT({
    airbnb_data %>%
      select("Name", "Host.Name", "Neighbourhood.Cleansed")
  })
  
  output$individual_airbnb_summary <- renderText({
    selected <- filter(airbnb_data, ID == input$individual_airbnb)
    paste("Summary: ", selected$Summary)
  })
  
  output$individual_airbnb_map <- renderPlotly({
    selected <- filter(airbnb_data, ID == input$individual_airbnb)
    plot_ly(
      data = selected,
      lat = ~Latitude,
      lon = ~Longitude,
      type = 'scattermapbox'
    ) %>%
      layout(
        mapbox = list(
          style = 'open-street-map',
          zoom = 4
        )
      )
  })
  
  # --- Individual Airbnb value boxes
  output$individual_airbnb_price <- renderValueBox({
    valueBox(
      "80€", "Price", icon = icon("thumbs-up", lib = "glyphicon"),
      color = "yellow"
    )
  })
  
  output$individual_airbnb_guests_included <- renderValueBox({
    valueBox(
      "80€", "Price", icon = icon("thumbs-up", lib = "glyphicon"),
      color = "yellow"
    )
  })
  
  output$individual_airbnb_number_reviews <- renderValueBox({
    valueBox(
      "80€", "Price", icon = icon("thumbs-up", lib = "glyphicon"),
      color = "yellow"
    )
  })
  
  output$individual_airbnb_review_score <- renderValueBox({
    valueBox(
      "80€", "Price", icon = icon("thumbs-up", lib = "glyphicon"),
      color = "yellow"
    )
  })
}