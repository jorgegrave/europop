# This is a simple application that presents the estimations for the population
# most european countries between 1960 and 2300

library(shiny)

# Define UI for application
shinyUI(fluidPage(
  
  # Application title
  titlePanel("European Population by Countries"),
  
  # Sidebar with a slider input to select the year 
  sidebarLayout(
    sidebarPanel(
       sliderInput("year",
                   "Please select the year:", min = 1960, max = 2300, value = 1960,
                   step = 10,sep = ""),
       
        p("Select the year you want in the slider bar and two plots will be 
          created in the main panel:"), p("- on the first tab you have a map of 
          Europe with the countries displayed with a color scale according to 
          their population in the year selected (you main need to wait a few 
          seconds for plot to complete loading)"), p("- on the second tab you 
          have a barplot with the top 10 most populous countries for the year 
          selected."), p("These estimates are obtained through a linear model to
          the population from the years of 1960 and 2016. These data were 
          obtained from", a("www.pordata.pt",hfer = "www.pordata.pt"))
    ),
    
    # create the main panel
    mainPanel(
       tabsetPanel(
         
         # First tab with the map of europe showing the population for each country
         tabPanel("Map", h3(textOutput("maptitle")),htmlOutput("map")),
         
          # Second tab with a bar plot fo the top ten countries
         tabPanel("Country Ranking",plotOutput("barplot"))
       )
    )
  )
))
