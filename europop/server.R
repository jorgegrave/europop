# This is a simple application that presents the estimations for the population
# most european countries between 1960 and 2300

library(shiny)
library(googleVis)


# read the data and create the linear models for each country
DF <- read.csv('europop.csv')
models <- NULL
for (i in 1:nrow(DF)){
  fit <- lm(as.numeric(DF[i,2:3]) ~ c(1960,2016))
  models <- rbind(models,fit$coefficients[1:2])
}

shinyServer(function(input, output,session) {

  # create the title for the first tab, including the input year  
  output$maptitle <- renderText({paste("Population in the year",
                                       as.character(input$year))})
  
  # obtain the predictions based on the previous models and on the input year
  newpop <- reactive({
    pop <- NULL
    DF2 <- DF
    for (i in 1:nrow(DF)){
      pred <- models[i,1]+models[i,2]*input$year
      pop <- c(pop,as.numeric(round(pred)))
    }
    DF2$pop <- pop
    DF2 <- DF2[order(-pop),]
    DF2
  })
  
  # draw european map with the population for the respective year
  output$map <- renderGvis({
    gvisGeoChart(data = newpop(),locationvar = "countries", 
                 colorvar = "pop", options = list(region="150",
                 displayMode="regions", resolution="countries",
                 width=600, height=400))
    })
  
  # draw a barplot with the top ten countries
  output$barplot <- renderPlot({
    table <- newpop()
    countrycode <- substr(table$countries,1,2) 
    barplot(table$pop[10:1]/1000000,horiz=TRUE,names.arg=countrycode[10:1],las=1,
            main=paste("Top 10 most populous european countries in",
                       as.character(input$year)),
            xlab = "Population (in millions)",col="forestgreen")
  })
})

