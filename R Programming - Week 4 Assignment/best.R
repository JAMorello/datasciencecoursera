best <- function(state, outcome) {
  ##Read the file
  df_outcome <- read.csv("data/outcome-of-care-measures.csv", colClasses = "character")
  
  ## Check if an invalid state value was passed to the function
  if (!(state %in% unique(df_outcome[,"State"]))) stop("invalid state")
  
  ## Check if an invalid outcome value was passed to the function
  check_outcome <- c("heart attack", "heart failure", "pneumonia") ##cols: 11, 17, 23
  if (!(outcome %in% check_outcome)) stop("invalid outcome")
  
  ## Get the outcome column
  col_outcomes <- c("heart attack"=11, "heart failure"=17, "pneumonia"=23)
  col <- col_outcomes[[outcome]]
  
  ## Get value of lowest 30-day mortality for the specified outcome 
  ## in the specified state
  df_bystate <- df_outcome[which(df_outcome[,"State"] == state),]
  result <- min(as.numeric(df_bystate[,col]), na.rm =TRUE)

  # Get a dataframe with the rows with the lowest mortality
  best <- df_bystate[which(as.numeric(df_bystate[,col]) == result),]
  
  # Check if there is a tie
  if (nrow(best) > 1) {
    best <- best[order(best$Hospital.Name),]
  }

  # Return Hospital name with lowest mortality
  best[1,"Hospital.Name"]
}