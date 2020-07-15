complete <- function(directory, id=1:332){
  files_full <- list.files(directory, full.names=TRUE)
  frame <- data.frame()

  for (i in id) {
    file <- read.csv(files_full[i])
    info <- data.frame(id=i, nobs=sum(complete.cases(file)))
    frame <- rbind(frame, info)
  }
  
  frame
}