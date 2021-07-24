library(shinydashboard)
library(plotly)

dashboardPage(
  skin = "red",
  dashboardHeader(title = "Airbnb Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Airbnb Search", tabName = "airbnb_search", icon = icon("search")),
      menuItem("Host Search", tabName = "host_search", icon = icon("user")),
      menuItem("Widgets", tabName = "widgets", icon = icon("th"))
    )
  ),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    tabItems(
      tabItem(tabName = "dashboard",
        fluidRow(
          
        )        
      ),
      tabItem(tabName = "airbnb_search",
        fluidRow(
          box(
            uiOutput("image"),
            plotlyOutput("individual_airbnb_map")
          ),
          box(
            selectInput("individual_airbnb", "Select a flat:", c(18323163, 13888679)),
            sliderInput("individual_airbnb_price", "Price", min = 10, max = 300, value = 50)
          ),
          box(
            textOutput("individual_airbnb_summary")
          )
        ),         
        fluidRow(
          valueBoxOutput("individual_airbnb_price"),
          valueBoxOutput("individual_airbnb_guests_included"),
          valueBoxOutput("individual_airbnb_number_reviews"),
          valueBoxOutput("individual_airbnb_review_score")
        )
      ),
      tabItem(
        tabName = "host_search",
          fluidRow(
            
          )        
      ),
      tabItem(tabName = "widgets",
        fluidRow(
          box(
            plotlyOutput("plot2", height = 500, width = 600)
          )
        ), 
        fluidRow(
          box(
            DT::DTOutput("table_listings")
          )
        )
      )
    )
  )
)

