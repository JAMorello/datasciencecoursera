library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(fluidPage(theme = shinytheme("journal"),
                  
          navbarPage("New York Air Quality Measurements", # Application title
                             
            tabPanel("Graphs",
                                      
                    # Sidebar with a slider input for graph settings
                    sidebarPanel(
                                        
                    h3("Graph Settings:"),
                                        
                    selectInput("outcome", label="Outcome",
                                choices=list("Ozone", "Solar.R",
                                             "Wind", "Temp"),
                                selected="Ozone"),
                                        
                    selectInput("predictor", label="Predictor",
                                choices=list("Ozone", "Solar.R",
                                             "Wind", "Temp"),
                                 selected="Solar.R"),
                                        
                    sliderInput("month", "Month:",
                                min = 5, max = 9, value = 5),
                                        
                    submitButton("Submit")
                      ),
                                      
                    # Show a plot of the generated distribution
                    mainPanel(
                             h3(textOutput("textout")),
                             plotOutput("Plot")
                              )
                    ),
            
            tabPanel("Prediction",
                     
                     # Sidebar with a slider input for graph settings
                     sidebarPanel(
                       
                       h3("Predictors:"),
                       
                       sliderInput("pred_solar", "Solar.R:",
                                   min = 0, max = 350, value = 150),
                       
                       sliderInput("pred_wind", "Wind",
                                   min = 0, max = 25, value = 12),
                       
                       sliderInput("pred_temp", "Temp:",
                                   min = 0, max = 100, value = 50),
                       
                       submitButton("Submit")
                     ),
                     
                     # Show a plot of the generated distribution
                     mainPanel(
                       h3("Prediction:"),
                       p("The Ozone value for the predictors inputed is:"),
                       verbatimTextOutput("prediction")
                     )
                     
                     ),
                             
            tabPanel("Documentation", 
                                      
                    mainPanel(
                      h3("Documentation"),
                      p("This web app uses the \"airquiality\" data set that comes in the \"datasets\" package in R.
                        It builds a graph using \"ggplot2\" package), more specificly, a scatter plot with outcome and predictor
                        selected by the user. Selecting a certain month is also possible. To the plot is added a linear regression model."),
                      h3("Data"),
                      p("Daily readings of the air quality measurements in New York, 
                        from May 1 to September 30, 1973."),
                      h5("Ozone:"),
                      p("Mean ozone in parts per billion from 1300 to 1500 hours at Roosevelt Island"),
                      h5("Solar.R:"),
                      p("Solar radiation in Langleys in the frequency band 4000-7700 Angstroms from 0800 to 1200 hours at Central Park"),
                      h5("Wind:"),
                      p("Average wind speed in miles per hour at 0700 and 1000 hours at LaGuardia Airport"),
                      h5("Temp:"),
                      p("Maximum daily temperature in degrees Fahrenheit at La Guardia Airport"),
                      h3("Source"),
                      p("The data were obtained from the New York State Department of Conservation (ozone data) and the National Weather Service (meteorological data)."),
                      h3("Reference"),
                      p("Chambers, J. M., Cleveland, W. S., Kleiner, B. and Tukey, P. A. (1983) Graphical Methods for Data Analysis. Belmont, CA: Wadsworth.")
                      )
                    )
      )
  )
)