library(Rmixmod)



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
      layout(shapes=list(type = "line", x0 = 1, x1 = 50000, y0 = 0.6, y1 = 0.6, line = list(dash = "dot", width = 1))) %>%
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
  donnees$Weight = 0.453592 * donnees$Weight
  
  
  resClassifTP <- mixmodCluster(donnees[,c(2, 3)], nbCluster = 2)
  
  
  output$donnees <- renderDataTable({
    datatable(donnees, options = list(pageLength = 20, dom = "tip", ordering = TRUE)) %>%
      formatRound("Height", digits = 2) %>%
      formatRound("Weight", digits = 2)
  })
  
  
  
  output$slider <- renderUI({
    meanRef <- ifelse(input$selectedVar == "Height", 170, ifelse(length(input$gender) == 2, 70, ifelse(input$gender == "Male", 80, 60)))
    sdRef <- ifelse(input$selectedVar == "Height", 9, 14)
    sdRef = sdRef - ifelse(length(input$gender) == 1, ceiling(0.3 * sdRef), 0)
    nMaxObs <- ifelse(length(input$gender) == 1, 5000, 10000)
    
    list(sliderInput("nObs", "Nombre d'observations :", min = 10, max = nMaxObs, value = 100, step = 10),
         sliderInput("mean", "Moyenne :", min = meanRef - ceiling(0.2*meanRef), max = meanRef + ceiling(0.2*meanRef), value = meanRef, step = 0.5),
         sliderInput("sd", "Écart-type :", min = sdRef - ceiling(0.3*sdRef), max = sdRef + ceiling(0.3*sdRef), value = sdRef, step = 0.25))
    
  })
  
  output$distPlot <- renderPlot({
    validate(need(length(input$gender) > 0, "Sélectionnez Male, Female ou les deux"))
    set.seed(42)
    nObs <- ifelse(is.null(input$nObs), 100, input$nObs)
    meanG <- ifelse(is.null(input$mean), ifelse(input$selectedVar == "Height", 170, 70), input$mean)
    sdG <- ifelse(is.null(input$sd), ifelse(input$selectedVar == "Height", 10, 6), input$sd)
    ind <- sample(which(donnees$Gender %in% input$gender), min(nObs, sum(donnees$Gender %in% input$gender)))
    
    hist(donnees[[input$selectedVar]][ind], col = "darkgray", border = "white", probability = TRUE, main = "", xlab = input$selectedVar)
    abscisse <- qnorm(seq(0, 1, length = 500), meanG, sdG)
    lines(abscisse, dnorm(abscisse, meanG, sdG), col = "red", lwd = 2)
  })
  
  output$estimateParameter <- renderText({
    validate(need(length(input$gender) > 0, "Sélectionnez Male, Female ou les deux"))
    set.seed(42)
    nObs <- ifelse(is.null(input$nObs), 100, input$nObs)
    ind <- sample(which(donnees$Gender %in% input$gender), min(nObs, sum(donnees$Gender %in% input$gender)))
    
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
  
  output$plotTP <- renderPlotly({
    plot_ly(x = donnees$Height, y = donnees$Weight, color = donnees$Gender, colors = RColorBrewer::brewer.pal(3, "Set1")[1:2], type = "scatter", mode = "markers") %>%
      layout(xaxis = list(title = "Taille", range = range(donnees$Height) * c(0.95, 1.04)), 
             yaxis = list(title = "Poids", range = range(donnees$Weight) * c(0.95, 1.04))) %>%
      config(displayModeBar = FALSE)
  })
  
  output$plotClassif <- renderPlot({
    invisible(capture.output(plot(resClassifTP)))
  })
  
  output$paramClassifTP <- renderTable({
    param <- round(resClassifTP@bestResult@parameters@mean, 2)
    colnames(param) = c("Height", "Weight")
    rownames(param) = c("Classe 1", "Classe 2")
    
    param
  }, rownames = TRUE)
  
  
  output$compPartition <- renderTable({
    comp <- table(resClassifTP@bestResult@partition, donnees$Gender)
    class(comp) = "matrix"
    comp
  }, rownames = TRUE)
  
  
  
  output$slider2 <- renderUI({
    nMaxObs <- ifelse(length(input$gender) == 1, 5000, 10000)
    
    list(sliderInput("nObs2", "Nombre d'observations :", min = 10, max = nMaxObs, value = 50, step = 10),
         sliderInput("const", "Constante :", min = 80, max = 180, value = 140, step = 0.5),
         sliderInput("coeff", "Coefficient directeur :", min = -2, max = 2, value = 0, step = 0.05))
    
  })
  
  output$plotTP2 <- renderPlotly({
    validate(need(length(input$gender2) > 0, "Sélectionnez Male, Female ou les deux"))
    set.seed(42)
    nObs <- ifelse(is.null(input$nObs2), 100, input$nObs2)
    ind <- sample(which(donnees$Gender %in% input$gender2), min(nObs, sum(donnees$Gender %in% input$gender2)))
    
    coeff <- ifelse(is.null(input$coeff), 0, input$coeff)
    const <- ifelse(is.null(input$const), 140, input$const)
    
    
    p <- plot_ly(x = donnees$Weight[ind], y = donnees$Height[ind], type = "scatter", mode = "markers") %>%
      layout(xaxis = list(title = "Poids", range = range(donnees$Weight) * c(0.95, 1.04)), 
             yaxis = list(title = "Taille", range = range(donnees$Height) * c(0.95, 1.04))) %>%
      config(displayModeBar = FALSE) %>% 
      add_trace(x = range(donnees$Weight) * c(0.95, 1.04), 
                y = range(donnees$Weight) * c(0.95, 1.04) * coeff + const, type = "scatter", mode = "lines") %>%
      layout(showlegend = FALSE)
  })
  
  
  output$estimateParameter2 <- renderText({
    validate(need(length(input$gender2) > 0, "Sélectionnez Male, Female ou les deux"))
    set.seed(42)
    nObs <- ifelse(is.null(input$nObs2), 100, input$nObs2)
    ind <- sample(which(donnees$Gender %in% input$gender2), min(nObs, sum(donnees$Gender %in% input$gender2)))
    
    reslm <- lm(Height ~ Weight, data = donnees[ind,])
    
    paste0("Constante : ", round(reslm$coefficients[1], 3), "\nCoefficient directeur : ", round(reslm$coefficients[2], 3))
  })
  
  output$param2 <- renderUI({
    column(6, tags$b("Paramètres optimaux :"), verbatimTextOutput("estimateParameter2"))
  })
  
  observeEvent(input$show2, { 
    toggle("param2", TRUE)
  })
  
  
  # Iris --------------------------------------------------------------------
  output$dataIris <- renderDT({
    datatable(iris, options = list(pageLength = 20, dom = "tip", ordering = TRUE))
  })
  
  output$plotIris <- renderPlotly({
    plot_ly(x = iris[[input$abscisseIris]], y = iris[[input$ordonneesIris]], colors = RColorBrewer::brewer.pal(3, "Set1"), color = iris$Species, type = "scatter", mode = "markers") %>%
      layout(xaxis = list(title = input$abscisseIris), yaxis = list(title = input$ordonneesIris)) %>%
      config(displayModeBar = FALSE)
  })
  
}

