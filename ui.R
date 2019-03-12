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
                                 hidden(uiOutput("plotPF"), uiOutput("expPF")))
                  ),
                  
                  tabItem(tabName = "taille", 
                          tabsetPanel(
                            tabPanel("Données",
                                     br(),
                                     column(6, offset = 3, dataTableOutput("donnees"))
                            ),
                            tabPanel("Visualisation", 
                                     br(),
                                     fluidRow(column(8, offset = 2, box("On ajuste une loi de probabilités sur les variables afin de déterminer et comprendre le comportement des individus.", status = "primary", width = 12))),
                                     sidebarLayout(
                                       sidebarPanel(selectInput("selectedVar", choices = c("Height", "Weight"), label = NULL),
                                                    checkboxGroupInput("gender", "Genre :", c("Male", "Female"), selected = c("Male", "Female")),
                                                    uiOutput("slider")),
                                       mainPanel(plotOutput("distPlot"),
                                                 br(),
                                                 actionButton("show", "Montrer les paramètres optimaux"),
                                                 br(), br(),
                                                 hidden(uiOutput("param"), uiOutput("expTP"))
                                       )
                                     )
                            ),
                            tabPanel("Visualisation (II)",
                                     br(),
                                     plotlyOutput("plotTP")),
                            tabPanel("Classification",
                                     br(),
                                     fluidRow(column(12, box("La classification consiste à créer des groupes d'individus avec un comportements similaires.",
                                                             "Dans le cas présent, on cherche des comportements différents des personnes en fonction de la taille et du poids sans prendre en compte l'information sur le genre.",
                                                             width = 12, status = "primary"))),
                                     br(),
                                     plotOutput("plotClassif"),
                                     br(),
                                     box(tableOutput("paramClassifTP"), title = "Moyennes estimées", status = "primary"),
                                     box(tableOutput("compPartition"), title = "Comparaison de la partition avec le genre", status = "primary"),
                                     box("Pour 2 classes, l'algorithme de classification a trouvé une classe comprenant principalement le femmes et une autre les hommes.", 
                                         " Cela sans connaissances préalables sur le sexe. C'est la structure la plus vraisemblable dans les données en se basant sur des lois normales.", width = 12, status = "primary")),
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
                                     fluidRow(column(12, plotlyOutput("plotIris")))),
                            tabPanel("Visualisation (II)",
                                     br(),
                                     fluidRow(column(10, offset = 1, box("Créer un nouveau repère orthogonal qui maximise la variabilité des données. Les nouveaux axes sont des combinaisons linéaires des variables d'originies.", 
                                         title = "Analyses en composantes principales", solidHeader = TRUE, status = "primary", width = 10))),
                                     fluidRow(column(12, box(plotlyOutput("plotIris2"), width = 12, status = "primary"))),
                                     fluidRow(column(8, offset = 2, box("Ici le nouveau repère représente environ 96% de l'information du jeu de données de base.",
                                                                        " On a donc une représentation en 2 dimensions qui contient quasiment la même information que les 4 dimensions du jeu de données de base. C'est une méthode très utile pour visualiser des données.", width = 12, status = "primary"))),
                                     fluidRow(column(8, offset = 2, box(plotOutput("plotIris3"), width = 12, status = "primary"))),
                                     fluidRow(column(8, offset = 2, box("Les nouveaux axes sont des combinaisons linéaires des variables. Regarder la corrélation de ces axes avec les variables permet d'interpréter les nouveaux axes.",
                                                                        " Ainsi, le 1er axe est corrélé positivement avec Pepal.Width, Pepal.Length et Setal.Length, une valeur élevé sur le 1er axe est le signe de valeurs élevés sur ces 3 variables.", width = 12, status = "primary"))))
                          )
                          
                  )
                )
              )
)   
