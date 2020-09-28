## DONT FORGENT LINKS OF CODE ON GITHUB, MARKDOWN PRESENTATION AND RPUBS WITH
## ANALYSIS OF DATA

library(shiny)
library(shinythemes)

shinyUI(fluidPage(theme = shinytheme("journal"),

    navbarPage("Natural Language Processing Project", # Application title
               
        tabPanel("Predictive Text",
                        
            sidebarPanel(
                          
                h3("Input text:"),
                    
                    tags$textarea(id="user_text", rows=2, cols=20),
                    sliderInput("num_predictions", "Number of predictions:",
                                min = 1, max = 5, value = 1, step = 1),
                    submitButton("Submit")
            ),
                        
            mainPanel(
              
                h3("Predicted Next Word"),
                verbatimTextOutput("prediction"),
            )
        ),
               
        tabPanel("Instructions", 
                        
            mainPanel(
              
                h3("Instructions"),
                p("This Shiny web app predicts the next word based on the text you typed. Natural language processing techniques were used for the prediction."),
                br(),
                p(strong("The input fields (on the left) are as follows.")),
                p(strong("Input Text"),": Text entered for prediction."),
                p(strong("No. of Predictions"),": Number of words that the algorithm will predict."),
                br(),
                p(strong("The output field (on the right):")),
                p(strong("Predicted Next Word"), ": If you finished writing your phrase and ended it with a whitespace, it shows the predicted next word(s)"),
                p(strong("Current Word Being Typed"), "If you don't end your phrase with a whitespace, it is assumed that you don't finished writing and here it shows possible words that could be the ones you are currently writing"),
                br(),
                p("Please, after you entered you text, press the \"Submit\" button and allow a few seconds for the output to appear.")
            )
        ),
        
        ## If the user wants to predict the current word 
        ## (didn't finished writing - no whitespace- and wants suggestions)
        # Check that the user text do not end with whitespace and is not empty
        # Predict current word
        ## If the user finished writing a word (wants to predict the next one)
        # Clear current word prediction output
        
        
        tabPanel("About", 
                 
                 mainPanel(
                   
                   h3("Who made this?"),
                   p("Author: Juan Agustin Morello"),
                   p("Date: 27/09/2020"),
                   p("Purpose: As final project of the Data Science Capstone on Coursera, for the Data Science Specialization of John Hopkins University")
                 )
        )
    )
)
)