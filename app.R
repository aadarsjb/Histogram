# LIBRARIES ----

# Shiny
library(shiny)
library(bslib)

# Modeling
library(modeldata)
library(DataExplorer)

# Widgets
library(plotly)

# Core
library(tidyverse)


# LOAD DATASETS ----
utils::data("stackoverflow", "car_prices", "Sacramento", package = "modeldata")

data_list = list(
  "StackOverflow" = stackoverflow,
  "Car Prices"    = car_prices,
  "Sacramento Housing" = Sacramento
)

# 1.0 USER INTERFACE ----
ui <- navbarPage(
  
  title = "Data Explorer",
  
  theme = bslib::bs_theme(version = 4, bootswatch = "minty"),
  
  tabPanel(
    title = "Explore",
    
    sidebarLayout(
      
      sidebarPanel(
        width = 3,
        h1("Explore a Dataset"),
        
        # Requires Reactive Programming Knowledge
        # - Taught in Shiny Dashboards (DS4B 102-R)
        shiny::selectInput(
          inputId = "dataset_choice",
          label   = "Data Connection",
          choices = c("StackOverflow", "Car Prices", "Sacramento Housing")
        ),
        
      ),
      
      mainPanel(
        h1("Correlation"),
        plotlyOutput("corrplot", height = 700)
      )
    )
    
  )
  
  
)

# SERVER ----
server <- function(input, output) {
  
  rv <- reactiveValues()
  
  observe({
    
    rv$data_set <- data_list %>% pluck(input$dataset_choice)
    
  })
  
  output$corrplot <- renderPlotly({
    
    g <- DataExplorer::plot_correlation(rv$data_set)
    
    plotly::ggplotly(g)
  })
  
}

# Run the application
shinyApp(ui = ui, server = server)