library(shiny)
library(shinyjs)
library(DT)

fluidPage(
  useShinyjs(),
  tabsetPanel(
    tabPanel("Données",
             br(),
             column(6, offset = 3, dataTableOutput("donnees"))
    ),
    tabPanel("Visualisation", 
             br(),
             sidebarLayout(
               sidebarPanel(selectInput("selectedVar", choices = c("Height", "Weight"), label = NULL),
                            uiOutput("slider")),
               mainPanel(plotOutput("distPlot"),
                         actionButton("show", "Montrer les paramètres optimaux"),
                         br(), br(),
                         hidden(uiOutput("param"))
               )
             )
    )
  )
)