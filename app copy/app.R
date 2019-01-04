#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(lubridate)


full_game_log <- readRDS("data/FullGameLog.rds")
PlayerSummaryStats <- readRDS("data/PlayerSummaryStats.rds")
max_exp <- max(PlayerSummaryStats$Experience)
player_names <- unique((PlayerSummaryStats$Player))

stats_of_interest <- c("Minutes", "FGM3", "TRB", "AST", "STL", "BLK", "PTS", "GameScore")

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Season Summary"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("experience",
                     "Years Experience:",
                     min = 0,
                     max = max_exp,
                     value = 30),
         
         textInput(inputId = "name",
                   label = "Player Name",
                   value = ""),
         
        
         selectInput(inputId = "stat",
                     label = "Stat to analyse",
                     choices = stats_of_interest)
      ),
      
      # Main panel for displaying outputs ----
      mainPanel(
        
        # Output: Tabset w/ plot, summary, and table ----
        tabsetPanel(type = "tabs",
                    tabPanel("Table", DT::dataTableOutput("stats_table")),
                    tabPanel("Per Game", plotOutput(outputId = "lineplot"))
        )
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  output$lineplot <- renderPlot({
    full_game_log %>% 
      filter(str_trim(PlayerName) == input$name) %>%
      ggplot(aes(x= as.numeric(Rk), group = 1)) + 
      geom_line(aes_string(, y= input$stat), color = "midnightblue", size = 1) +
      theme_minimal() +
      labs(x = "Game", title = paste(input$name, input$stat, "per game", sep = " "))
  })
  
  
  # Create data table
  output$stats_table <- DT::renderDataTable({
    PlayerSummaryStats_exp <- PlayerSummaryStats %>%
      filter(Experience <= input$experience)
    DT::datatable(data = PlayerSummaryStats_exp, 
                  options = list(pageLength = 10), 
                  rownames = FALSE)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

