
library(shinydashboard)
library(plotly)

dashboardPage(
  dashboardHeader(
    title = "Airbnb Dashboard",
    tags$li(class = "dropdown", actionButton("info", HTML("<i class='fa fa-info fa-fw'></i> About this App"), style = "color: #3c8dbc;"), style = "margin: 8px 20px 0px 0px;")
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Airbnb Listings Analysis", tabName = "airbnb_analysis", icon = icon("map-marker")),
      menuItem("Aggregated Analysis", tabName = "neighbourhood_analysis", icon = icon("bar-chart")),
      menuItem("Airbnb Search", tabName = "airbnb_search", icon = icon("search")),
      # menuItem("Host Search", tabName = "host_search", icon = icon("user")),
      menuItem("Data", tabName = "data", icon = icon("table"))
    )
  ),
  dashboardBody(
    tabItems(
      
      # Airbnb Analysis
      tabItem(
        tabName = "airbnb_analysis",
        
        # Description Box
        fluidRow(
          box(
            title = "Description", width = 12, collapsible = TRUE, solidHeader = TRUE, status = "info", 
            "On this Tab you can explore how the Airbnb listings are spread across Berlin via the map.
            By hovering over a point in the map you can get additional information about the listing. 
            Below the map you can get an overview of how listings are distributed across Neighbourhoods via the histogram.
            You can adjust the visualizations to your liking by changing the filter options in the box on the right side."
          )
        ), 
        
        # Plots Box
        fluidRow(
          column(
            width = 8, 
            box(
              title = "Map", width = 12, solidHeader = TRUE, status = "primary",
              plotlyOutput("map"),
            ),
            box(
              title = "Distribution", width = 12, solidHeader = TRUE, status = "primary",
              plotlyOutput("analysis_distribution")
            )
          ),
          column(
            width = 4,
            box(
              title = "Filter", width = 12, solidHeader = TRUE, status = "warning",
              sliderInput("analysis_price", "Price Span ", min = 0, max = 2000, value = c(0,2000)),
              selectInput("analysis_neighbourhood", "Neighbourhoods to include", 
                          choices = unique(airbnb_data$Neighbourhood.Group.Cleansed), 
                          selected = unique(airbnb_data$Neighbourhood.Group.Cleansed), 
                          multiple = TRUE),
              checkboxInput("analysis_log_scale", "Use Logarithmic Scale for Histogram", value = FALSE),
              sliderInput("analysis_number_airbnbs", "Number of Airbnbs to show", min = 0, max = 20000, value = 10000),
              helpText("Error will occur when the value of 'Number of Airbnbs to show' is higher than 
                       the available number of listings with a given filter setting.")
            )
          )
        )
      ),
      
      # Neighbourhood Analysis
      tabItem(tabName = "neighbourhood_analysis",
              
        # Description Box
        fluidRow(
          box(
            title = "Description", width = 12, collapsible = TRUE, solidHeader = TRUE, status = "info", 
            "On this Tab you can explore the data in an aggregated way. You can compare Neighbourhoods 
            on a variety of different variables in the bar chart below. In the bottom scatterplot 
            you can compare Hosts in an aggregated way. Here it is especially interesting to look at those hosts with a lot of listings.
            For both plots, you can adjust them to your liking with the filters in the filter boxes."
          )
        ), 
        
        # Aggregated Neighbourhood Plot              
        fluidRow(
          box(
            title = "Aggregated Neighbourhoods", width = 8, solidHeader = TRUE, status = "primary",
            plotlyOutput("analysis_neighbourhoods")
          ),
          box(
            title = "Filter", width = 4, solidHeader = TRUE, status = "warning",
            varSelectInput("analysis_aggregate_variable", selected = "Mean.Price",  "Y-Axis Variable:", grouped_airbnb)
          )
        ),
        
        # Aggregated Host Plot
        fluidRow(
          box(
            title = "Aggregated Hosts", width = 8, solidHeader = TRUE, status = "primary",
            plotlyOutput("analysis_hosts_scatter")
          ),
          box(
            title = "Filter", width = 4, solidHeader = TRUE, status = "warning",
            sliderInput("aggregate_host_min_listings", "Show only Hosts with minimum listings of", min = 1, max = 40, value = 2),
            varSelectInput("analysis_hosts_x", "X-Axis Variable:", selected = "Number.of.Listings", grouped_airbnb_host),
            varSelectInput("analysis_hosts_y", "Y-Axis Variable:", selected = "Mean.Review.Scores.Rating", grouped_airbnb_host),
            varSelectInput("analysis_hosts_color", "Color Variable:", selected = "Mean.Review.Scores.Cleanliness", grouped_airbnb_host),
            varSelectInput("analysis_hosts_size", "Size Variable:", selected = "Mean.Number.of.Reviews", grouped_airbnb_host)
          )
        )
      ),
      
      # Airbnb Search tab
      tabItem(tabName = "airbnb_search",
        
        # Tab Description
        fluidRow(
          box(
            title = "Description", width = 12, collapsible = TRUE, solidHeader = TRUE, status = "info", 
            "On this Tab you can look at specific Airbnb listings. The Datatable 
            below provides a way to search for individual listings with the Name filter. 
            You can learn more about a listings location via the map, the description, and the host. 
            Important metrics about a listing such as Price, Guests Included, 
            Number of Reviews, and the average rating of the listing are highlighted 
            below the hosts box.", br(), br(),
            strong("To select a listing, click on a row within the data table.")
          )
        ),
              
        # Datatable Box      
        fluidRow(
          box(
            title = "Data Table", width = 12,
            DT::DTOutput("individual_airbnb_datatable")
          )
        ),
        
        # Airbnb Search Content
        fluidRow(
          
          # Airbnb Data
          column(
            width = 8,
            box(
              title = "Airbnb Flat", status = "primary", solidHeader = TRUE, width = 12,
              h1(textOutput("individual_airbnb_name")),
              plotlyOutput("individual_airbnb_map", inline = TRUE),
              div(style = "max-width = 200px; max-height: 300px; text-align: center; margin-bottom: 20px; overflow: hidden;",
                  htmlOutput("individual_airbnb_image", class = "individual-airbnb-thumbnail", inline = TRUE), br()
              ),
              strong("Summary: "), textOutput("individual_airbnb_summary", inline = TRUE), br(),
              strong("Space: "), textOutput("individual_airbnb_space", inline = TRUE), br(),
              strong("Description: "), textOutput("individual_airbnb_description", inline = TRUE), br(),
              strong("Experiences Offered: "), textOutput("individual_airbnb_experiences_offered", inline = TRUE), br(),
              strong("Notes: "), textOutput("individual_airbnb_notes", inline = TRUE), br(),
              strong("Transit: "), textOutput("individual_airbnb_transit", inline = TRUE), br(),
              strong("Access: "), textOutput("individual_airbnb_access", inline = TRUE), br(),
              strong("Interaction: "), textOutput("individual_airbnb_interaction", inline = TRUE), br(),
              strong("House Rules: "), textOutput("individual_airbnb_house_rules", inline = TRUE), br()
            )
          ),
          
          # Host Data
          column(
            width = 4,
            box(
              title = "Host", status = "primary", solidHeader = TRUE, width = 12,
              div(style = "margin-bottom: 20px;",
                  htmlOutput("individual_airbnb_host_thumbnail", inline = TRUE), br()
              ),
              strong("Name: "), textOutput("individual_airbnb_host_name", inline = TRUE), br(),
              strong("About: "), textOutput("individual_airbnb_host_about", inline = TRUE), br(),
              strong("Location: "), textOutput("individual_airbnb_host_location", inline = TRUE), br(),
              strong("Neighbourhood: "), textOutput("individual_airbnb_host_neighbourhood", inline = TRUE), br(),
              strong("Response Rate: "), textOutput("individual_airbnb_host_response_rate", inline = TRUE), br()
            ),
            valueBoxOutput("individual_airbnb_price", width = 12),
            valueBoxOutput("individual_airbnb_guests_included", width = 12),
            valueBoxOutput("individual_airbnb_number_reviews", width = 12),
            valueBoxOutput("individual_airbnb_review_score", width = 12)
          )
        )
      ),
      
      # Data Tab
      tabItem(tabName = "data",
        
        # Description Box
        fluidRow(
          box(
            title = "Description", width = 12, collapsible = TRUE, solidHeader = TRUE, status = "info", 
            "On this Tab you can explore the data in detail. The whole dataset is 
            available as datatable which can be filtered. Due to sizing constraints it is not possible to show 
            all variables at once, you can however select and deselect the variables you wish to see."
          )
        ), 
        fluidRow(
          
          # Big Datatable and Legal information
          column(
            width = 10,
            box(
              title = "Data Table", status = "primary", solidHeader = TRUE, width = 12,
              DT::DTOutput("table_listings")
            ),
            box(
              p("The data is provided by the Inside Airbnb project and is 
                available under the Creative Commons CC0 1.0 Universal 'Public 
                Domain Dedication' License."),
              tags$a(
                href="https://public.opendatasoft.com/explore/dataset/airbnb-listings/information/?disjunctive.host_verifications&disjunctive.amenities&disjunctive.features&refine.city=Berlin", 
                     "Download the data here."),
              p("This app is developed by Raphael Reimann.")
            ),
          ),
          
          # Filter Box
          column(
            width = 2,
            box(
              title = "Filter", status = "primary", solidHeader = TRUE, width = 12, collapsible = TRUE,
              checkboxGroupInput("data_variables", "Variables to show:", 
                                 choices = colnames(airbnb_data), 
                                 selected = c("Name", "Neighbourhood.Group.Cleansed", "Price")),
            )
          )
        )
      )
    )
  )
)

