# ______________________________________________
# NLPDL
# Goal: Visualisation of Baseline Predictions for subset
# Procedure: prepare data, visualise
# ______________________________________________
# Date:  Fri Mar 26 15:27:19 2021
# Author: Nicolai Berk
#  R version 4.0.3 (2020-10-10)
# ______________________________________________


# Setup ####
library(tidyverse)
library(here)
library(data.table)
library(gridExtra)

# prepare data ####
dta <- read.csv('_dt/subset_news_pred.csv')

## turn logit into probability
for (i in 10:15){
  dta[i] <- dta[i] %>% lapply(plogis)
}

# visualise ####
plot <- function(party, fillcol) {
  ggplot(dta) +
    geom_histogram(aes_string(x = party), fill = fillcol) +
    facet_grid(~source) +
    xlab(party) + 
    scale_x_continuous(limits = c(0,1),
                       breaks = c(0, 0.5))
  
}

greens <- plot('green', 'lightgreen')
union  <- plot('union', 'black')
afd    <- plot('afd',   'lightblue')
spd    <- plot('spd',   'red')
linke  <- plot('linke', 'darkred')
fdp    <- plot('fdp',   'yellow')

grid.arrange(linke, greens, spd, union, fdp, afd,
             ncol=1) %>% 
  ggsave(filename = 'reports/midterm-report-latex/figures/preds.png', plot = ., 
         width = 5, height = 10)
