library(tm)

cleanText <- function(text) {
  text <- VCorpus(VectorSource(text))
  
  # Set character to lower case
  text <- tm_map(text, content_transformer(tolower))
  
  # Remove URLs
  removeURL <- content_transformer(function(x) gsub("(f|ht)tp(s?)://\\S+", "", 
                                                    x, perl=T))
  text <- tm_map(text, removeURL)
  
  # Remove emails
  RemoveEmail <- content_transformer(function(x) {
    require(stringr)
    str_replace_all(x,"[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+", "")}) 
  text <- tm_map(text, RemoveEmail)
  
  # Remove apostrophe
  # This steps is necessary as the apostrophe character ( ' ) is a rare one and is better to have ( ' ) instead
  removeApostrophe <- content_transformer( function(x) gsub("'", "'", x))
  text <- tm_map(text, removeApostrophe)
  
  # Remove profanity words
  # A list of profanity words provided by Google
  # https://code.google.com/archive/p/badwordslist/downloads
  profanityFile <- "../data/badwords.txt"
  profanityWords <- readLines(profanityFile, warn=FALSE,
                              encoding="UTF-8", skipNul = TRUE)
  profanityWords <- tolower(profanityWords)
  profanityWords <- gsub("\\*|\\+|\\(", "", profanityWords)
  text <- tm_map(text, removeWords, profanityWords)
  
  # Remove numbers
  text <- tm_map(text, content_transformer(removeNumbers))
  
  # Remove non-alphanumeric characters
  removeExtras <- content_transformer( function(x){
    gsub("\\,|\\;|\\:|\\&|\\-|\\)|\\(|\\{|\\}|\\[|\\]|\\!|\\?|\\+|=|@|~|/|<|>|\\^", 
         " ", x)}) 
  text <- tm_map(text, removeExtras)
  
  # Remove any left punctuation
  text <- tm_map(text, content_transformer(removePunctuation))
  
  # Remove whitespace
  text <- tm_map(text, content_transformer(stripWhitespace))

  return(as.character(text[[1]][1]))
}

lastWords <- function(text, n) {
  paste(tail(unlist(strsplit(text, " ")), n), collapse = " ")
}


wordCount <- function(text) {
  length(unlist(strsplit(text, " ")))
}


# Predict current word being typed based on the partial last word
predictCurrentWord <- function(user_text, pred_df, num_pred) {
  user_text <- cleanText(user_text)
  prediction <- findBestMatches(user_text, 1, 
                                pred_df$unigram, num_pred, nxt=FALSE)
  
  # Full word detected, predict next word
  if (lastWords(user_text, 1) %in% prediction) {
    prediction <- predictNextWord(user_text, pred_df, num_pred)
  }
  
  # If there are no predictions
  if(length(prediction) == 0) return(prediction <- "NO PREDICTIONS")
  
  return(prediction)
}

# Predict next word, first try guadgram, then trigram, and then bigram
predictNextWord <- function(user_text, pred_df, num_pred) {
  user_text <- cleanText(user_text)
  nwords <- wordCount(user_text)
  
  prediction <- NULL
  
  if(nwords >= 3) prediction <- findBestMatches(user_text, 3, 
                                                pred_df$quadgram, num_pred, nxt=TRUE)
  if(length(prediction) >= 1) return(prediction)
  
  if(nwords >= 2) prediction <- findBestMatches(user_text, 2, 
                                                pred_df$trigram, num_pred, nxt=TRUE)
  if(length(prediction) >= 1) return(prediction)
  
  if(nwords >= 1) prediction <- findBestMatches(user_text, 1, 
                                                pred_df$bigram, num_pred, nxt=TRUE)
  if(length(prediction) >= 1) return(prediction)
  
  # If there are no predictions
  return(prediction <- "NO PREDICTIONS")
  
  }

# Match n-gram based on frequencies
findBestMatches <- function(words, n, pred_df, num_pred, nxt=FALSE) {
  words <- lastWords(words, n)
  if (nxt) words <- paste(words, " ", sep="")
  f <- head(pred_df[grep(paste("^", words, sep = ""),
                         pred_df$word), "word"],
            num_pred)
  if (nxt) {
    f <- gsub(paste("^", words, sep = ""), "", f)
  }
  return(f)
}
