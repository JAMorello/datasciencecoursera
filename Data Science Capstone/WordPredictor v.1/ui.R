library(shiny)
library(shinythemes)

shinyUI(fluidPage(theme = shinytheme("journal"),

    navbarPage("Natural Language Processing Project", # Application title
               
        tabPanel("Predictive Text",
                        
            sidebarPanel(
                          
                h3("Input text:"),
                    
                    tags$textarea(id="user_text", rows=2, cols=40),
                    sliderInput("num_predictions", "Number of predictions:",
                                min = 1, max = 10, value = 3, step = 1),
                    submitButton("Submit")
            ),
                        
            mainPanel(
              
                h3("Prediction"),
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
              p(strong("Prediction"), ": If you finished writing your phrase and ended it with a whitespace, it shows the predicted next word(s). If you don't end your phrase with a whitespace, it is assumed that you don't finished writing and here it shows possible words that could be the ones you are currently writing. The algorithm detects if you had typed a complete word if you don't end with whitespace; it then suggest the next word."),
              br(),
              p("Please, after you entered you text, press the \"Submit\" button and allow a few seconds for the output to appear.")
            )
        ),
        tabPanel("About", 
                 
                 mainPanel(
                   
                   h3("Who made this?"),
                   p("Author: Juan Agustin Morello"),
                   p("Date: 01/10/2020"),
                   p("Purpose: As final project of the Data Science Capstone on Coursera, for the Data Science Specialization of John Hopkins University"),
                   br(),
                   p("The source code of this web app is ", tags$a(href="https://github.com/JAMorello/datasciencecoursera/tree/master/Data%20Science%20Capstone/WordPredictor%20v.1", "here")),
                   p("You can see the code that manipulates the original data ", tags$a(href="https://github.com/JAMorello/datasciencecoursera/tree/master/Data%20Science%20Capstone", "here")), 
                   p("The Milestone Report is available ", tags$a(href="https://rpubs.com/Katriel/dsc-milestone-report", "here")),
                   p("And the presentation slides ", tags$a(href="https://rpubs.com/Katriel/dsc-presentation", "here"))
                 )
        )
    )
)
)