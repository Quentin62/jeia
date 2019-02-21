# source : https://the-eye.eu/public/Books/IT%20Various/machine_learning_for_hackers.pdf
donnees <- read.table("weight-height.csv", sep = ",", header = TRUE)

# conversion de la taille de inch en cm
donnees$Height = 2.54 * donnees$Height

# conversion du poids de pounds en kg
donnees$Weight = 0.453592 * donnees$Height


function(input, output, session) {
 

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

