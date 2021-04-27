# ______________________________________________
# NLP ^ Deep Learning Project
# Goal: Clean input data
# Procedure: load data, preprocess, save
# ______________________________________________
# Date:  Mon Apr 26 14:33:25 2021
# Author: Nicolai Berk
#  R version 4.0.3 (2020-10-10)
# ______________________________________________


# Setup ####
library(tidyverse)
library(here)
library(data.table)

# load data ####
dta <- fread('_dt/germanyPPRs.csv', encoding = 'UTF-8')


# preprocess ####


## filter by date & remove non-essential vars
dta <- dta %>% 
  filter(2013 >= year) %>% 
  select(rawtext, label, date)
colnames(dta) <- c('text', 'label', 'date')


## replace mis-coded characters (this is not working)

Cleaner <- function(string) {
  out <- tryCatch({
    expr = eval(parse(text=paste0("'", string, "'")))
  }, error = function(e) {
    print(paste0("Error, returning unaltered string."))
    string
  })
  return(out)
}

dta$text_clean <- lapply(dta$text, Cleaner) # this allows addressing false unicode strings
dta$text_clean <- gsub(dta$text_clean, pattern = '<e4>', replacement = 'ä')
dta$text_clean <- gsub(dta$text_clean, pattern = '<f6>', replacement = 'ö')
dta$text_clean <- gsub(dta$text_clean, pattern = '<fc>', replacement = 'ü')
dta$text_clean <- gsub(dta$text_clean, pattern = '<df>', replacement = 'ß')
dta$text_clean <- gsub(dta$text_clean, pattern = '<c4>', replacement = 'Ä')
dta$text_clean <- gsub(dta$text_clean, pattern = '<d6>', replacement = 'Ö')
dta$text_clean <- gsub(dta$text_clean, pattern = '<dc>', replacement = 'Ü')
dta$text_clean <- gsub(dta$text_clean, pattern = '<U\\+0096>', replacement = '-')


## remove party references in text (inefficient, but works)
dta$text_clean <- dta$text_clean %>% gsub(pattern = 'CDU', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = 'Christlich Demokratische Union', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = 'Christlich-[Dd]emokratische Union', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = 'CSU', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = 'Christlich-[Ss]oziale Union', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = 'Christlich Soziale Union', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = '[Ss]chwarzes', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = '[Ss]chwarzer', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = '[Ss]chwarzem', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = '[Ss]chwarzen', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = '[Ss]chwarze', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = '[Ss]chwarz', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = 'Union', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = 'SPD', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = '[Ss]ozialdemokratische Partei Deutschlands', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = '[Ss]ozialdemokratisch', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = '[Ss]ozialdemokraten', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = '[Ss]ozialdemokratinnen', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = '[Ss]ozialdemokrat', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = '[Rr]oter', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = '[Rr]otes', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = '[Rr]otem', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = '[Rr]oten', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = '[Rr]ote', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = '[Rr]ot', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = 'Bündnis90/die Grünen', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = 'Bündnis90 / die Grünen', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = '[Gg]rünes', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = '[Gg]rüner', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = '[Gg]rünem', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = '[Gg]rünen', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = '[Gg]rüne', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = '[Gg]rün', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = '[Ll]inke', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = 'Linkspartei', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = 'Freie Demokratische Partei', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = 'FDP', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = '[Gg]elber', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = '[Gg]elbes', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = '[Gg]elbem', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = '[Gg]elben', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = '[Gg]elbe', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = '[Gg]elb', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = 'A[fF]D', replacement = ' ')
dta$text_clean <- dta$text_clean %>% gsub(pattern = 'Alternative für Deutschland', replacement = ' ')


## remove whitespace
dta$text_clean <- gsub(dta$text_clean, pattern = '\\s\\s|\\t', replacement = ' ')

## drop original text
dta <- dta[,c("text_clean", "label", "date")]
colnames(dta) <- c("text", "label", "date")

# save ####
fwrite(dta, file = "_dt/PPRs_cleaned.csv")
