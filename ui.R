library(shiny)
library(DT)

fluidPage(
    tabsetPanel(
      tabPanel("Données",
               br(),
               column(6, offset = 3, dataTableOutput("donnees"))
      ),
      tabPanel("Visualisation", 
               br(),
               fluidRow(
                 column(4, 
                        selectInput("selectedVar", choices = c("Height", "Weight"), label = NULL),
                        uiOutput("slider")),
                 column(6, offset = 1,  plotOutput("distPlot")))
      )
    )
)