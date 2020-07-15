corr <- function(directory, threshold = 0){
  data <- complete(directory)
  subdata <- data[which(data[, "nobs"] > threshold),]
  monitor <- subdata[["id"]]
  
  files_full <- list.files(directory, full.names=TRUE)
  vector <- c()
  
  for (i in monitor) {
    file <- read.csv(files_full[i])
    vector <- c(vector, cor(file$sulfate, file$nitrate, use="complete.obs"))
  }
  
  vector
}