library(shiny)
library(stringr)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  # Load the R script with functions
  source("wp_functions.R")

  # Load the n-gram frequencies
  pred_df <- readRDS("../data/freq/predictive_text_df")
  
  output$prediction <- renderPrint({
    
    user_text <- as.character(input$user_text)
    num_pred <- input$num_predictions
    
    prediction <- ""
    
    ## If the user wants to predict the next word
    ## (finished writing with a white space) 
    if (str_sub(user_text, start=-1) == " " && trimws(user_text) != "") {
      prediction = predictNextWord(user_text, pred_df, num_pred)
      prediction = cat(prediction, sep = "\n")
      
    ## If the user wants to predict the current word 
    ## (didn't finished writing - no whitespace- and wants suggestions)
    } else if (str_sub(user_text, start=-1) != " " && trimws(user_text) != "") {
      prediction <- predictCurrentWord(user_text, pred_df, num_pred)
      prediction <-  cat(prediction, sep = "\n")
    }
      
    invisible(prediction)
      
    #} else if (!is.null(pcw) && lastWords(user_text, 1) %in% pcw) {
      # Full word detected; Predict next word
      #prediction = cat(predictNextWord(user_text, pred_df, num_pred), sep = "\n")
       #If the user wrote a partial word (wants suggestions)
  })
  
    
})
