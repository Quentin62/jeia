library(shiny)
library(shinyjs)
library(shinydashboard)
library(DT)

dashboardPage(skin = "red",
              dashboardHeader(title = "JEIA 2019"),
              
              dashboardSidebar(
                sidebarMenu(id = "tabs",
                            menuItem("Taille et poids", tabName = "taille", icon = icon("ruler-vertical")))),
              dashboardBody(
                useShinyjs(),
                tabItems(
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
                )
              )
)
