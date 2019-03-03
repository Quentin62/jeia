library(shiny)
library(shinyjs)
library(shinydashboard)
library(DT)
library(plotly)

dashboardPage(dashboardHeader(title = "JEIA 2019"),
              
              dashboardSidebar(
                sidebarMenu(id = "tabs",
                            menuItem("Pile ou face", tabName = "pile", icon = icon("coins")),
                            menuItem("Taille et poids", tabName = "taille", icon = icon("ruler-vertical"))
                            )
                ),
              
              dashboardBody(
                useShinyjs(),
                tabItems(
                  tabItem(tabName = "pile",
                          br(),
                          column(12, 
                                 sliderInput("nObsPF", "Nombre d'observations :", min = 10, max = 1000, value = 50, step = 10),
                                 verbatimTextOutput("donneesPF")),
                          column(10, offset = 1, actionButton("showPlotPF", "Graphiques"),
                                 br(), br(),
                                 hidden(uiOutput("plotPF")))
                  ),
                  
                  tabItem(tabName = "taille", 
                          tabsetPanel(
                            tabPanel("Données",
                                     br(),
                                     column(6, offset = 3, dataTableOutput("donnees"))
                            ),
                            tabPanel("Visualisation", 
                                     br(),
                                     sidebarLayout(
                                       sidebarPanel(selectInput("selectedVar", choices = c("Height", "Weight"), label = NULL),
                                                    checkboxGroupInput("gender", "Genre :", c("Male", "Female"), selected = c("Male", "Female")),
                                                    uiOutput("slider")),
                                       mainPanel(plotOutput("distPlot"),
                                                 br(),
                                                 actionButton("show", "Montrer les paramètres optimaux"),
                                                 br(), br(),
                                                 hidden(uiOutput("param"))
                                       )
                                     )
                            ),
                            tabPanel("Visualisation (II)",
                                     br(),
                                     plotlyOutput("plotTP")),
                            tabPanel("Classification",
                                     br(),
                                     plotOutput("plotClassif"),
                                     br(),
                                     box(tableOutput("paramClassifTP"), title = "Moyennes estimées", status = "primary"),
                                     box(tableOutput("compPartition"), title = "Comparaison de la partition avec le genre", status = "primary"))
                          )
                  )
                )
              )
)   
              