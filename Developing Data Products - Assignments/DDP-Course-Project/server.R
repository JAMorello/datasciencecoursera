library(shiny)
library(ggplot2)

# Load data
data(airquality)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  model <- lm(Ozone ~ Solar.R + Wind + Temp, data=airquality)
  
  output$prediction <- renderPrint({
    data <- data.frame(Solar.R = input$pred_solar,
                       Wind = input$pred_wind,
                       Temp = input$pred_temp)
    
    predict(model, data)
  })
  
  # Display title of plot
  output$textout <- renderText(
    paste(input$predictor, "and",
          input$outcome, "in month", 
          input$month)
  )
  
  # Display graph given user input
  output$Plot <- renderPlot({
    
    y <- airquality[which(airquality$Month == input$month), input$outcome]
    x <- airquality[which(airquality$Month == input$month), input$predictor]
    df <- data.frame(y=y, x=x)
    
    plot <- ggplot(df, aes(x, y)) +
      geom_jitter(aes(color=y), size=4) +
      geom_smooth(method='lm') +
      scale_colour_gradientn(colours=rainbow(4)) +
      labs(x = input$predictor,
           y = input$outcome) +
      theme(legend.position = "none")
    plot
  })
})
