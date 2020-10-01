## Load packages

library(tm) # Loads 'NPL' required package
library(RWeka) # For NGramTokenizer
library(tidytext)
library(dplyr)

## Load data and get a sample of each

blogFile <- './data/en_US/en_US.blogs.txt'
newsFile <- './data/en_US/en_US.news.txt'
twitterFile <- './data/en_US/en_US.twitter.txt'

blogsData <- readLines(blogFile, warn=FALSE, 
                       encoding="UTF-8", skipNul = TRUE)
newsData <- readLines(newsFile, warn=FALSE, 
                      encoding="UTF-8", skipNul = TRUE)
twitterData <- readLines(twitterFile, warn=FALSE,
                         encoding="UTF-8", skipNul = TRUE)

print("Step 1 Done")

# Get number of lines in the texts
blogsLength <- length(blogsData)
newsLength <- length(newsData)
twitterLength <- length(twitterData)

# Sample data sets
blogsSample <- sample(blogsData, blogsLength * 0.05)
newsSample <- sample(newsData, newsLength * 0.05)
twitterSample <- sample(twitterData, twitterLength * 0.05)

# Delete full data sets to liberate RAM
rm(blogsData); rm(newsData); rm(twitterData)

print("Step 2 Done")

## Create CORPUS of words

sampleData <- c(blogsSample, newsSample, twitterSample)

corpus <- VCorpus(VectorSource(sampleData),
                  readerControl = list(language = "eng"))

# Delete sample data
rm(blogsSample); rm(newsSample); rm(twitterSample); rm(sampleData) 

print("Step 3 Done")

## Preprocess corpus // Transformations

# Set character to lower case
corpus <- tm_map(corpus, content_transformer(tolower))

# Remove URLs
removeURL <- content_transformer(function(x) gsub("(f|ht)tp(s?)://\\S+", "", 
                                                  x, perl=T))
corpus <- tm_map(corpus, removeURL)

# Remove emails
RemoveEmail <- content_transformer(function(x) {
  require(stringr)
  str_replace_all(x,"[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+", "")}) 
corpus <- tm_map(corpus, RemoveEmail)

# Remove apostrophe
# This steps is necessary as the apostrophe character ( ' ) is a rare one and is better to have ( ' ) instead
removeApostrophe <- content_transformer( function(x) gsub("'", "'", x))
corpus <- tm_map(corpus, removeApostrophe)

print("Step 4 Done")

# Remove profanity words
# A list of profanity words provided by Google
# https://code.google.com/archive/p/badwordslist/downloads
profanityFile <- "./data/badwords.txt"
profanityWords <- readLines(profanityFile, warn=FALSE,
                            encoding="UTF-8", skipNul = TRUE)
profanityWords <- tolower(profanityWords)
profanityWords <- gsub("\\*|\\+|\\(", "", profanityWords)
corpus <- tm_map(corpus, removeWords, profanityWords)

print("Step 5 Done")

# Remove numbers
corpus <- tm_map(corpus, content_transformer(removeNumbers))

# Remove non-alphanumeric characters
removeExtras <- content_transformer( function(x){
  gsub("\\,|\\;|\\:|\\&|\\-|\\-|\\)|\\(|\\{|\\}|\\[|\\]|\\!|\\?|\\+|=|@|~|/|<|>|\\^", 
       " ", x)}) 
corpus <- tm_map(corpus, removeExtras)

# Remove any left punctuation
corpus <- tm_map(corpus, content_transformer(removePunctuation))

# Remove whitespace
corpus <- tm_map(corpus, content_transformer(stripWhitespace))

print("Step 6 Done")

### Functions related to n-grams
bigram <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
trigram <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
quadgram <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))

# Get n-gram frequencies
getFreq <- function(dtm) {
  freq_tibble <- select(tidy(dtm), term, count) %>%
    group_by(term) %>% summarise(freq = sum(count)) %>%
    arrange(desc(freq))
  return(freq_tibble)
}

print("Step 7 Done")

### Create Document Term Matrix

# 1-gram
dtm <- DocumentTermMatrix(corpus)

print("Step 8 Done")

# 2-gram, bigram
bigram_dtm <- DocumentTermMatrix(corpus, 
                                 control = list(tokenize = bigram))

print("Step 9 Done")

# 3-gram, trigram
trigram_dtm <- DocumentTermMatrix(corpus, 
                                  control = list(tokenize = trigram))

print("Step 10 Done")

# 4-gram, quadgram
quadgram_dtm <- DocumentTermMatrix(corpus, 
                                   control = list(tokenize = quadgram))

print("Step 11 Done")

# Delete from memory the corpus
rm(corpus)

print("Step 12 Done")

# Create Create n-grams / Get n-gram data frames
# unigram data frame
onigram_freq <- getFreq(dtm)
rm(dtm)

print("Step 13 Done")

# bigram data frame
bigram_freq <- getFreq(bigram_dtm)
rm(bigram_dtm)

print("Step 14 Done")

# trigram data frame
trigram_freq <- getFreq(trigram_dtm)
rm(trigram_dtm)

print("Step 15 Done")

# quadgram data frame
quadgram_freq <- getFreq(quadgram_dtm)
rm(quadgram_dtm) 

print("Step 16 Done")

saveRDS(onigram_freq, "./data/model/4_onigram_freq")
saveRDS(bigram_freq, "./data/model/4_bigram_freq")
saveRDS(trigram_freq, "./data/model/4_trigram_freq")
saveRDS(quadgram_freq, "./data/model/4_quadgram_freq")

print("DONE!!")