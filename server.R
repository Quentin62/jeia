



function(input, output, session) {
 
  # Pile ou face ------------------------------------------------------------
  
  output$donneesPF <- renderText({
    nObsPF <- ifelse(is.null(input$nObsPF), 100, input$nObsPF)
    set.seed(42)
    pf <- c("P", "F")
    datPF <- rbinom(nObsPF, 1, 0.6)
    
    pf[datPF + 1]
  })
  
  output$plotPF1 <- renderPlotly({
    nObsPF <- ifelse(is.null(input$nObsPF), 100, input$nObsPF)
    set.seed(42)
    pf <- c("P", "F")
    datPF <- rbinom(nObsPF, 1, 0.6)
    datPF = pf[datPF + 1]

    
    p <- plot_ly(x = pf, y = c(mean(datPF == pf[1]), mean(datPF == pf[2])), type = "bar") %>%
      layout(yaxis = list(title = "Proportion")) %>% 
      config(displayModeBar = FALSE)
    p
    
  })
  
  
  output$plotPF2 <- renderPlotly({
    set.seed(42)
    pf <- c("P", "F")
    datPF <- rbinom(50000, 1, 0.6)
    plot_ly(x = seq_along(datPF), y = cumsum(datPF)/seq_along(datPF), type = "scatter", mode = "lines") %>%
      layout(xaxis = list(title = "Nombre d'observations"), yaxis = list(title = "Proportion de face")) %>% 
      config(displayModeBar = FALSE)
  })

  
  output$plotPF <- renderUI({
    tabBox(title = "Graphiques", width = 12,
      tabPanel("Proportion", plotlyOutput("plotPF1")),
      tabPanel("Convergence", plotlyOutput("plotPF2"))
    )
  })
  
  observeEvent(input$showPlotPF, { 
    toggle("plotPF", TRUE)
  })
  

  
  
  
  # taille et poids ---------------------------------------------------------
  
  # source : https://the-eye.eu/public/Books/IT%20Various/machine_learning_for_hackers.pdf
  donnees <- read.table("weight-height.csv", sep = ",", header = TRUE)
  
  # conversion de la taille de inch en cm
  donnees$Height = 2.54 * donnees$Height
  
  # conversion du poids de pounds en kg
  donnees$Weight = 0.453592 * donnees$Height
  
  output$donnees <- renderDataTable({
    datatable(donnees, options = list(pageLength = 20, dom = "tip", ordering = TRUE)) %>%
      formatRound("Height", digits = 2) %>%
      formatRound("Weight", digits = 2)
  })
  
  
  
  output$slider <- renderUI({
    meanRef <- ifelse(input$selectedVar == "Height", 170, 70)
    sdRef <- ifelse(input$selectedVar == "Height", 10, 5)
    list(sliderInput("nObs", "Nombre d'observations :", min = 10, max = 1000, value = 100, step = 10),
         sliderInput("mean", "Moyenne :", min = meanRef - ceiling(0.3*meanRef), max = meanRef + ceiling(0.3*meanRef), value = meanRef, step = 0.5),
         sliderInput("sd", "Écart-type :", min = sdRef - ceiling(0.3*sdRef), max = sdRef + ceiling(0.3*sdRef), value = sdRef, step = 0.25))
    
  })
  
  output$distPlot <- renderPlot({
    set.seed(42)
    nObs <- ifelse(is.null(input$nObs), 100, input$nObs)
    meanG <- ifelse(is.null(input$mean), ifelse(input$selectedVar == "Height", 170, 70), input$mean)
    sdG <- ifelse(is.null(input$sd), ifelse(input$selectedVar == "Height", 10, 6), input$sd)
    ind <- sample(nrow(donnees), nObs)
    
    hist(donnees[[input$selectedVar]][ind], col = "darkgray", border = "white", breaks = 12, probability = TRUE, main = "", xlab = input$selectedVar)
    abscisse <- qnorm(seq(0, 1, length = 500), meanG, sdG)
    lines(abscisse, dnorm(abscisse, meanG, sdG), col = "red", lwd = 2)
  })
  
  output$estimateParameter <- renderText({
    set.seed(42)
    nObs <- ifelse(is.null(input$nObs), 100, input$nObs)
    ind <- sample(nrow(donnees), nObs)
    
    meanEst <- mean(donnees[[input$selectedVar]][ind])
    sdEst <- sd(donnees[[input$selectedVar]][ind]) * (nObs-1)/nObs
    
    paste0("moyenne : ", round(meanEst, 3), "\n     sd : ", round(sdEst, 3))
  })
  
  output$param <- renderUI({
    column(6, tags$b("Paramètres optimaux :"), verbatimTextOutput("estimateParameter"))
  })
  
  observeEvent(input$show, { 
    toggle("param", TRUE)
  })
  

  
}

