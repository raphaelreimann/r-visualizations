
# Load packages
library(shiny)
library(shinydashboard)
library(plotly)
library(tidyverse)
library(ggthemes)
library(DT)

library(viridis) 

# Server Logic
server <- function(input, output) {
  # set.seed(122)
  Sys.setenv("MAPBOX_TOKEN" = "pk.eyJ1IjoicmVpbWFubnIiLCJhIjoiY2tybHpoOW04MGh6czJ2bWRtdng1Y3U0diJ9.ekctxVtZcu5dB18vB6XI4A")
  
### Modal (Info Button)
  observeEvent(input$info, {
    showModal(modalDialog(
      title = "What is this app?",
      HTML("<p>This is a visualizer for the Berlin Airbnb market. Here are some functionalities of this app:</p>
           <ul>
            <li>Visualize individual Airbnb listings on a map and as a histogram</li>
            <li>Visualize aggregated data to compare listings within neighbourhoods and compare Airbnb hosts</li>
            <li>Search and filter individual Airbnb listings and get detailed data about the listing and the host</li>
            <li>Get a complete overview over the entire dataset and decide which variables are shown</li>
           </ul>
           <p>This is a university project developed as part of the 'Data Visualization' of Professor Müller and is maintained by Raphael Reimann of the University of Paderborn.</p>
           "),
      easyClose = TRUE
    ))
  })
  
  
### Airbnb Analysis
  
##### Reactive conductor data source
  
  rval_analysis <- reactive({
    airbnb_data %>%
      filter(Price < input$analysis_price[2], 
             Price > input$analysis_price[1],
             Neighbourhood.Group.Cleansed %in% input$analysis_neighbourhood) %>%
      sample_n(input$analysis_number_airbnbs)
  })

##### Individual Airbnb Map Plot
  
  output$map <- renderPlotly({
    plot <- rval_analysis() %>%
      plot_mapbox() %>%
      layout(mapbox = list(style = "open-street-map", center = list(lon = 13.3783, lat = 52.5163), zoom = 10)) %>%
      add_markers(x = ~Longitude, y = ~Latitude, 
                  text = ~str_c("Name: '", Name, "'\nPrice: ", Price, "€\n", "Accomodates: ", Accommodates,  sep = ""), hoverinfo = "text",
                  size = ~Accommodates, color = ~Price)
    plot
  })
  
##### Individual Airbnb Distribution Histogram
  
  output$analysis_distribution <- renderPlotly({
    plot <- rval_analysis() %>%
      plot_ly(x = ~Price, color = ~Neighbourhood.Group.Cleansed, text = ~Name, type = "histogram")
    
    if(input$analysis_log_scale) {
      plot <- plot %>%
        layout(xaxis = list(type = "log"))
    }
    plot
  })
  
### Neighbourhood Analysis
  
##### Neighbourhood Grouped Bar Plot
  
  output$analysis_neighbourhoods <- renderPlotly({
    plot <- grouped_airbnb %>%
      ggplot() +
      geom_bar(
        mapping = aes(
          x = Neighbourhood.Group.Cleansed, 
          y = !!input$analysis_aggregate_variable
          ), stat = "identity") +
      scale_color_viridis(option = "D") +
      theme(axis.text.x = element_text(angle = 45)) # rotate text on x-axis to be readable
    
    ggplotly(plot)
  })
  
  output$analysis_hosts_scatter <- renderPlotly({
    hosts_scatter <- grouped_airbnb_host %>%
      filter(Number.of.Listings >= input$aggregate_host_min_listings)
    
    plot <- ggplot(data = hosts_scatter) +
      geom_point(
        mapping = aes(
          x = !!input$analysis_hosts_x, 
          y = !!input$analysis_hosts_y, 
          color = !!input$analysis_hosts_color,
          size = !!input$analysis_hosts_size,
          text = Host.Name)) +
      scale_color_viridis(option = "D")
    ggplotly(plot)
  })
  
  
### Airbnb Search
  
##### Reactive conductor data source
  
  rval_airbnb <- reactive({ 
    selected <- input$individual_airbnb_datatable_rows_selected # get selected row of datatable
    if (length(selected)) {
      airbnb_data[selected, ]  
    } else {
      airbnb_data[1, ] # if no row is selected, show first row arbitrarily 
    }
  })
  
##### Datatable to select individual rows
  
  output$individual_airbnb_datatable <- DT::renderDataTable({
    DT::datatable(
      airbnb_data %>% select(c("Name", "Neighbourhood.Group.Cleansed", "Price")), 
      filter = "top", 
      class = "compact cell-border", 
      selection = "single" # make rows in datatable selectable
    )
  })
  
##### Airbnb Search Map
  
  output$individual_airbnb_map <- renderPlotly({
    rval_airbnb() %>%
      plot_mapbox() %>%
      layout(mapbox = list(
        style = "open-street-map", 
        center = list(lon = ~Longitude, lat = ~Latitude), 
        zoom = 10)) %>%
      add_markers(
        x = ~Longitude, 
        y = ~Latitude, 
        text = ~str_c(Name, ", EUR ", Price, sep = ""), 
        hoverinfo = "text",
        size = 20, 
        color = I("red")
      ) %>% 
      highlight(on = "plotly_selected")
  })
  
##### Render UI Elements
  
  output$individual_airbnb_image <- renderUI({
    url <- rval_airbnb()$Picture.Url
    tags$img(src = url)
  })
  
  output$individual_airbnb_host_thumbnail <- renderUI({
    url <- rval_airbnb()$Host.Picture.Url
    tags$img(src = url)
  })
  
  output$individual_airbnb_name <- renderText({ rval_airbnb()$Name })
  
  output$individual_airbnb_summary <- renderText({ rval_airbnb()$Summary })
  
  output$individual_airbnb_space <- renderText({ rval_airbnb()$Space })
  
  output$individual_airbnb_description <- renderText({ rval_airbnb()$Description })
  
  output$individual_airbnb_experiences_offered <- renderText({ rval_airbnb()$Experiences.Offered })
  
  output$individual_airbnb_notes <- renderText({ rval_airbnb()$Notes })
  
  output$individual_airbnb_transit <- renderText({ rval_airbnb()$Transit })
  
  output$individual_airbnb_access <- renderText({ rval_airbnb()$Access })
  
  output$individual_airbnb_interaction <- renderText({ rval_airbnb()$Interaction })
  
  output$individual_airbnb_link <- renderText({ rval_airbnb()$Listings.Url })
  
  output$individual_airbnb_house_rules <- renderText({ rval_airbnb()$House.Rules })
  
  output$individual_airbnb_host_name <- renderText({ rval_airbnb()$Host.Name })
  
  output$individual_airbnb_host_about <- renderText({ rval_airbnb()$Host.About })
  
  output$individual_airbnb_host_location <- renderText({ rval_airbnb()$Host.Location })
  
  output$individual_airbnb_host_neighbourhood <- renderText({ rval_airbnb()$Host.Neighbourhood })
  
  output$individual_airbnb_host_response_rate <- renderText({ rval_airbnb()$Host.Response.Rate })
  
##### Individual Airbnb value boxes
  
  output$individual_airbnb_price <- renderValueBox({
    valueBox(
      rval_airbnb()$Price, "Price per Night", icon = icon("eur", lib = "glyphicon"),
      color = "purple"
    )
  })
  
  output$individual_airbnb_guests_included <- renderValueBox({
    valueBox(
      rval_airbnb()$Guests.Included, "Guests Included", icon = icon("user", lib = "glyphicon"),
      color = "yellow"
    )
  })
  
  output$individual_airbnb_number_reviews <- renderValueBox({
    valueBox(
      rval_airbnb()$Number.of.Reviews, "Number of Reviews", icon = icon("comment", lib = "glyphicon"),
      color = "blue"
    )
  })
  
  output$individual_airbnb_review_score <- renderValueBox({
    valueBox(
      paste(rval_airbnb()$Review.Scores.Rating, "/100"), "Avg. Rating", icon = icon("thumbs-up", lib = "glyphicon"),
      color = "red"
    )
  })
  
  
### Data Tab
  
##### Data Table  

  output$table_listings <- DT::renderDataTable({
    DT::datatable(
      airbnb_data[, input$data_variables, drop = FALSE], 
      filter = "top", 
      class = "compact cell-border", 
      selection = "single"
    )
  })
}