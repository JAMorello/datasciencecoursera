library(tidyr)
library(dplyr)

# Merge unigrams
first <- as_tibble(readRDS("./data/model/1_onigram_freq"))
second <- as_tibble(readRDS("./data/model/2_onigram_freq"))
third <- as_tibble(readRDS("./data/model/3_onigram_freq"))
fourth <- as_tibble(readRDS("./data/model/4_onigram_freq"))

final_onigram <- bind_rows(first, second, third, fourth) %>%
                 group_by(term) %>% summarise(freq = sum(freq)) %>%
                 arrange(desc(freq))

# Merge bigrams
first <- as_tibble(readRDS("./data/model/1_bigram_freq"))
second <- as_tibble(readRDS("./data/model/2_bigram_freq"))
third <- as_tibble(readRDS("./data/model/3_bigram_freq"))
fourth <- as_tibble(readRDS("./data/model/4_bigram_freq"))

final_bigram <- bind_rows(first, second, third, fourth) %>%
                 group_by(term) %>% summarise(freq = sum(freq)) %>%
                 arrange(desc(freq))

# Merge trigrams
first <- as_tibble(readRDS("./data/model/1_trigram_freq"))
second <- as_tibble(readRDS("./data/model/2_trigram_freq"))
third <- as_tibble(readRDS("./data/model/3_trigram_freq"))
fourth <- as_tibble(readRDS("./data/model/4_trigram_freq"))

final_trigram <- bind_rows(first, second, third, fourth) %>%
                 group_by(term) %>% summarise(freq = sum(freq)) %>%
                 arrange(desc(freq))

# Merge quadgrams
first <- as_tibble(readRDS("./data/model/1_quadgram_freq"))
second <- as_tibble(readRDS("./data/model/2_quadgram_freq"))
third <- as_tibble(readRDS("./data/model/3_quadgram_freq"))
fourth <- as_tibble(readRDS("./data/model/4_quadgram_freq"))

final_quadgram <- bind_rows(first, second, third, fourth) %>%
                 group_by(term) %>% summarise(freq = sum(freq)) %>%
                 arrange(desc(freq))

# Remove 'lonely' tibbles
rm(first); rm(second); rm(third); rm(fourth)

########
# final_onigram = 242,871 observations
# final_bigram = 3,075,211 obs.
# final_trigram = 7,489,917 obs.
# final_quadgram = 9,788,506 obs.
########

# Take log of 'freq' to reduce number
final_onigram[,"freq"] <- log(final_onigram[,"freq"])
final_bigram[,"freq"] <- log(final_bigram[,"freq"])
final_trigram[,"freq"] <- log(final_trigram[,"freq"])
final_quadgram[,"freq"] <- log(final_quadgram[,"freq"])

# Remove from the tables all 'freq' equal to zero
# (those that originally accounts with 1 freq) to reduce size of tables
final_onigram <- filter(final_onigram, freq > 0)
final_bigram <- filter(final_bigram, freq > 0)
final_trigram <- filter(final_trigram, freq > 0)
final_quadgram <- filter(final_quadgram, freq > 0)

########
# final_onigram = 108,725 observations
# final_bigram = 951,221 obs.
# final_trigram = 1,421,581 obs.
# final_quadgram = 1,176,960 obs.
########

# Save reduced tables
saveRDS(final_onigram, "./data/model/final_onigram_red")
saveRDS(final_bigram, "./data/model/final_bigram_red")
saveRDS(final_trigram, "./data/model/final_trigram_red")
saveRDS(final_quadgram, "./data/model/final_quadgram_red")

# Put the tables in variable and save them in RDS
final_model <- list(final_onigram, final_bigram, final_trigram, final_quadgram)
saveRDS(final_model, "./data/model/final_model")