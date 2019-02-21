library(shiny)
library(DT)

fluidPage(
  mainPanel(
    tabsetPanel(
      tabPanel("Données",
               br(),
               dataTableOutput("donnees")
      ),
      tabPanel("Visualisation", 
               br(),
               selectInput("selectedVar", choices = c("Height", "Weight"), label = NULL),
               uiOutput("slider"),
               plotOutput("distPlot")
      )
    )
  )
)