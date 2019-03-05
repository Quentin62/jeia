library(shiny)
library(shinyjs)
library(shinydashboard)
library(DT)
library(plotly)

dashboardPage(dashboardHeader(title = "JEIA 2019"),
              
              dashboardSidebar(
                sidebarMenu(id = "tabs",
                            menuItem("Pile ou face", tabName = "pile", icon = icon("coins")),
                            menuItem("Taille et poids", tabName = "taille", icon = icon("ruler-vertical")),
                            menuItem("Iris", tabName = "iris", icon = icon("leaf"))
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
                                     box(tableOutput("compPartition"), title = "Comparaison de la partition avec le genre", status = "primary")),
                            tabPanel("Régression",
                                     br(),
                                     h2("Prédire la taille en fonction du poids"),
                                     
                                     sidebarLayout(
                                       sidebarPanel(checkboxGroupInput("gender2", "Genre :", c("Male", "Female"), selected = c("Male", "Female")),
                                                    uiOutput("slider2")),
                                       mainPanel(plotlyOutput("plotTP2"),
                                                 br(),
                                                 actionButton("show2", "Montrer les paramètres optimaux"),
                                                 br(), br(),
                                                 hidden(uiOutput("param2"))
                                       )
                                     )
                            )
                          )
                  ),
                  
                  tabItem("iris",
                          tabsetPanel(
                            tabPanel("Données",
                                     br(),
                                     column(10, dataTableOutput("dataIris"))),
                            tabPanel("Visualisation",
                                     fluidRow(column(6, selectInput("abscisseIris", "Abscisse", colnames(iris)[-5], selected = "Sepal.Width")),
                                              column(6, selectInput("ordonneesIris", "Ordonnée", colnames(iris)[-5]))),
                                     fluidRow(column(12, plotlyOutput("plotIris"))))
                          )
                          
                  )
                )
              )
)   
