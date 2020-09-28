## Load packages

library(tm) # Loads 'NPL' required package
library(RWeka) # For NGramTokenizer

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

# Get number of lines in the texts
blogsLength <- length(blogsData)
newsLength <- length(newsData)
twitterLength <- length(twitterData)

set.seed(1993) # Set seed for reproducibility

# Sample data sets
blogsSample <- sample(blogsData, blogsLength * 0.05)
newsSample <- sample(newsData, newsLength * 0.05)
twitterSample <- sample(twitterData, twitterLength * 0.05)

# Delete full data sets to liberate RAM
rm(blogsData); rm(newsData); rm(twitterData)

## Create CORPUS of words

sampleData <- c(blogsSample, newsSample, twitterSample)

corpus <- Corpus(VectorSource(sampleData),
                 readerControl = list(language = "eng"))

# Delete sample data
rm(blogsSample); rm(newsSample); rm(twitterSample); rm(sampleData) 

## Preprocess corpus // Transformations

inspect(corpus[1][1]) # Checkout text every step

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

# Remove profanity words
# A list of profanity words provided by Google
# https://code.google.com/archive/p/badwordslist/downloads
profanityFile <- "./data/badwords.txt"
profanityWords <- readLines(profanityFile, warn=FALSE,
                            encoding="UTF-8", skipNul = TRUE)
profanityWords <- tolower(profanityWords)
profanityWords <- gsub("\\*|\\+|\\(", "", profanityWords)
corpus <- tm_map(corpus, removeWords, profanityWords)

# Remove numbers
corpus <- tm_map(corpus, content_transformer(removeNumbers))

# Remove non-alphanumeric characters
removeExtras <- content_transformer( function(x){
  gsub("\\,|\\;|\\:|\\&|\\-|\\)|\\(|\\{|\\}|\\[|\\]|\\!|\\?|\\+|=|@|~|/|<|>|\\^", 
       " ", x)}) 
corpus <- tm_map(corpus, removeExtras)

# Remove any left punctuation
corpus <- tm_map(corpus, content_transformer(removePunctuation))

# Remove whitespace
corpus <- tm_map(corpus, content_transformer(stripWhitespace))
nsw_corpus <- tm_map(nsw_corpus, content_transformer(stripWhitespace))

### Functions related to n-grams
bigram <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
trigram <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
quadgram <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))

# Get n-gram frequencies
getFreq <- function(dtm) {
  freq <- colSums(as.matrix(dtm))
  order <- order(freq, decreasing = TRUE)
  return(data.frame(word = names(freq[order]), freq = freq[order],
                    row.names=NULL))
}

### Create Document Term Matrix

# 1-gram
dtm <- DocumentTermMatrix(corpus)
nsw_dtm <- DocumentTermMatrix(nsw_corpus)

# 2-gram, bigram
bigram_dtm <- DocumentTermMatrix(corpus, 
                                 control = list(tokenize = bigram))
nsw_bigram_dtm <- DocumentTermMatrix(nsw_corpus, 
                                     control = list(tokenize = bigram))

# 3-gram, trigram
trigram_dtm <- DocumentTermMatrix(corpus, 
                                  control = list(tokenize = trigram))
nsw_trigram_dtm <- DocumentTermMatrix(nsw_corpus, 
                                      control = list(tokenize = trigram))

# 4-gram, quadgram
quadgram_dtm <- DocumentTermMatrix(corpus, 
                                   control = list(tokenize = quadgram))
nsw_quadgram_dtm <- DocumentTermMatrix(nsw_corpus, 
                                       control = list(tokenize = quadgram))

# Delete from memory the corpus
rm(corpus); rm(nsw_corpus)

# Remove Sparse Terms
dtm <- removeSparseTerms(dtm, 0.999) # Result: 1788 observations
nsw_dtm <- removeSparseTerms(nsw_dtm, 0.999) # Result: 1692 obs.

bigram_dtm <- removeSparseTerms(bigram_dtm, 0.999) # Result: 1448 obs.
nsw_bigram_dtm <- removeSparseTerms(nsw_bigram_dtm, 0.999) # Result: 87 obs.

trigram_dtm <- removeSparseTerms(trigram_dtm, 0.9997) # Result: 1295 obs.
nsw_trigram_dtm <- removeSparseTerms(nsw_trigram_dtm, 0.9999) # Result: 91 obs.

quadgram_dtm <- removeSparseTerms(quadgram_dtm, 0.9999) # Result: 903 obs.
nsw_quadgram_dtm <- removeSparseTerms(nsw_quadgram_dtm, 0.99995) # Result: 19

# Create Create n-grams / Get n-gram data frames
# unigram data frame
onegram_freq <- getFreq(dtm)
nsw_onegram_freq <- getFreq(nsw_dtm)
rm(dtm); rm(nsw_dtm) # Delete the DTM from memory

# bigram data frame
bigram_freq <- getFreq(bigram_dtm)
nsw_bigram_freq <- getFreq(nsw_bigram_dtm)
rm(bigram_dtm); rm(nsw_bigram_dtm) # Delete the DTM from memory

# trigram data frame
trigram_freq <- getFreq(trigram_dtm)
nsw_trigram_freq <- getFreq(nsw_trigram_dtm)
rm(trigram_dtm); rm(nsw_trigram_dtm) # Delete the DTM from memory

# quadgram data frame
quadgram_freq <- getFreq(quadgram_dtm)
nsw_quadgram_freq <- getFreq(nsw_quadgram_dtm)
rm(quadgram_dtm); rm(nsw_quadgram_dtm) # Delete the DTM from memory

## SAVE PREDICTIVE TEXT MODEL
freq <- list(unigram=onegram_freq, bigram=bigram_freq, 
             trigram=trigram_freq, quadgram=quadgram_freq)
saveRDS(freq, "predictive_text_df")