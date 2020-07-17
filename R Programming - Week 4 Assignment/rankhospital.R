rankhospital <- function(state, outcome, num) {
  ##Read the file
  df_outcome <- read.csv("data/outcome-of-care-measures.csv", colClasses = "character")
  
  ## Check if an invalid state value was passed to the function
  if (!(state %in% unique(df_outcome[,"State"]))) stop("invalid state")
  
  ## Check if an invalid outcome value was passed to the function
  check_outcome <- c("heart attack", "heart failure", "pneumonia") ##cols: 11, 17, 23
  if (!(outcome %in% check_outcome)) stop("invalid outcome")
  
  ## Get the outcome column
  col_outcomes <- c("heart attack"=11, "heart failure"=17, "pneumonia"=23)
  col_name <- colnames(df_outcome)[col_outcomes[[outcome]]]
  
  ## Get dataframe according to specified state and outcome
  mask <- which(df_outcome[,"State"] == state)
  df_bystate <- df_outcome[mask, c("Hospital.Name", "State", col_name)]
  df_bystate[,col_name] <- as.numeric(df_bystate[,col_name])
  
  # Check if there are a minimum of 5 ranked hospitals in the specified state
  removed_na <- sum(!is.na(df_bystate[,col_name]))
  if (num == "best") num <- 1
  else if (num == "worst") num <- removed_na
  if (removed_na < num) return(NA)
  
  # Sort the dataframe by outcome and then by Hospital name
  rank <- df_bystate[
    order(df_bystate[,col_name], df_bystate[,"Hospital.Name"] ),
  ]

  # Return Hospital name in num rank
  rank[num,"Hospital.Name"]
}