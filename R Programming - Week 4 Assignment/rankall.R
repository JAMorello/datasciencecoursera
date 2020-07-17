rankall <- function(outcome, num = "best") {
  ##Read the file
  df_outcome <- read.csv("data/outcome-of-care-measures.csv", colClasses = "character")
  
  ## Check if an invalid outcome value was passed to the function
  check_outcome <- c("heart attack", "heart failure", "pneumonia") ##cols: 11, 17, 23
  if (!(outcome %in% check_outcome)) stop("invalid outcome")
  
  ## Get the outcome column
  col_outcomes <- c("heart attack"=11, "heart failure"=17, "pneumonia"=23)
  col_name <- colnames(df_outcome)[col_outcomes[[outcome]]]
  
  # Get a list of states
  states <- unique(df_outcome[, "State"])
  
  # Create a new data frame
  df_final <- data.frame(matrix(ncol = 2, nrow = 0))
  colnames(df_final) <- c("hospital", "state")
  
  for (state in states) {
    ## Get dataframe according to specified state and outcome
    mask <- which(df_outcome[,"State"] == state)
    df_bystate <- df_outcome[mask, c("Hospital.Name", col_name)]
    df_bystate[,col_name] <- as.numeric(df_bystate[,col_name])
    
    # Check if there are a minimum of 5 ranked hospitals in the specified state
    removed_na <- !is.na(df_bystate[,col_name])
    
    if (num == "best") {
      num <- 1
    } else if (num == "worst") {
      num <- sum(removed_na)
    }
    
    if (sum(removed_na) < num) {
      hospital <- (NA)
    } else {
      # Sort the dataframe by outcome and then by Hospital name
      df_bystate <- df_bystate[removed_na,]
      rank <- df_bystate[
        order(df_bystate[,col_name], df_bystate[,"Hospital.Name"] ),
      ]
    
      # Return Hospital name in num rank
      rownames(rank) <- 1:nrow(rank)
      hospital <- rank[num,"Hospital.Name"]
    }
      row <- c(hospital, state)
      df_final[nrow(df_final)+1,] <- row
    
  }
  df_final <- df_final[order(df_final$state),]
  df_final
}

## There are troubles when using the function with the parameter "worst",
## the output isn´t what is expected. But when using rankhospital all is fine.