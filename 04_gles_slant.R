# ______________________________________________
# NLP and Deep Learning Project
# Goal: Estimate Newspaper Bias from GLES RCS
# Procedure: load data, visualise, tables
# ______________________________________________
# Date:  Mon Apr 26 11:09:50 2021
# Author: Nicolai Berk
#  R version 4.0.3 (2020-10-10)
# ______________________________________________


# Setup ####
library(tidyverse)
library(here)
library(data.table)
library(ggridges)
library(haven)
library(magrittr)
library(tidyr)

# load & prepare data ####
gles_rcs <- read_sav('_dt/gles/ZA6834_v1-0-0.sav')

## restrict to 2017
gles_rcs %<>%
  filter(year == 2017)

# ## wide -> long
# gles_rcs$lfdn <- factor(gles_rcs$lfdn)
# 
# gles_long <- gather(gles_rcs, pre2501, pre_2501_p, pre2501_1:)



## 2501: was Bild news more positive for some parties than for others?

# visualise ####
ggplot(gles_rcs, aes(x = pre2501_1)) +
  geom_bar() +
  ggtitle('Bild slant toward CDU/CSU')

ggplot(gles_rcs, aes(x = pre2501_2)) +
  geom_bar(fill = 'red') +
  ggtitle('Bild slant toward SPD')

ggplot(gles_rcs, aes(x = pre2501_3)) +
  geom_bar(fill = 'gold') +
  ggtitle('Bild slant toward FDP')

ggplot(gles_rcs, aes(x = pre2501_4)) +
  geom_bar(fill = 'green') +
  ggtitle('Bild slant toward Greens')

ggplot(gles_rcs, aes(x = pre2501_5)) +
  geom_bar(fill = 'darkred') +
  ggtitle('Bild slant toward Left')




# tables ####


## Bild readers' indication of Bild slant

### recode CDU/CSU as one if either is mentioned
gles_rcs$bild_union <- NA
gles_rcs$bild_union[!is.na(gles_rcs$pre2501_1)] <- 0
gles_rcs$bild_union[gles_rcs$pre2501_1 == 1] <- 1
gles_rcs$bild_union[gles_rcs$pre2501_2 == 1] <- 1
gles_rcs$bild_union[gles_rcs$pre2501_3 == 1] <- 1

gles_rcs$pre2501_3 <- gles_rcs$bild_union

### calculate share of respondents indicating favorabilioty for X
varnames <- paste0('pre2501_', c(3:8))

bild <- data.frame(init = 0)

for (var in varnames){
  
  bild[var] <- gles_rcs %>%
    select(all_of(var)) %>% 
    filter(!is.na(.)) %>% 
    summarise(var = sum(.)/nrow(.))
  
}

bild <- bild[-1]

colnames(bild) <- c('CDU/CSU', 'SPD', 'Left', 'Greens', 'FDP', 'AfD')
bild['N'] <- nrow(gles_rcs[!is.na(gles_rcs$pre2501_3),])

row.names(bild) <- 'bild'


## FAZ readers' indication of FAZ slant

newspapers <- c('FAZ', 'SZ', 'taz', 'Welt')
indicator <- 2:5


output <-  data.frame('CDU/CSU' = c(), 
                      'SPD' = c(), 
                      'Left' = c(), 
                      'Greens' = c(), 
                      'FDP' = c(), 
                      'AfD' = c(),
                      'N' = c())
  
for (i in (1:length(newspapers))){
  
  temp <- gles_rcs %>% filter(pre2601 == indicator[i])
  
  ## recode responses indicating conservatives
  temp$temp <- 0
  temp$temp[temp$pre2701_1 == 1] <- 1
  temp$temp[temp$pre2701_2 == 1] <- 1
  temp$temp[temp$pre2701_3 == 1] <- 1
  
  
  temp$pre2701_3 <- temp$temp
  
  varnames <- paste0('pre2701_', c(3:8))
  
  gles_sum <- data.frame(init = 0)
  
  for (var in varnames){
    
    gles_sum[var] <- temp %>%
      select(all_of(var)) %>% 
      filter(!is.na(.)) %>% 
      summarise(var = sum(.)/nrow(.))
    
  }
  
  gles_sum <- gles_sum[-1]
  
  colnames(gles_sum) <- c('CDU/CSU', 'SPD', 'Left', 'Greens', 'FDP', 'AfD')
  
  gles_sum['N'] <- nrow(temp)
  
  output <- rbind(output, gles_sum)
  row.names(output)[i] <- newspapers[i]
  
}

slant <- rbind(bild, output)
knitr::kable(round(slant, 2))
