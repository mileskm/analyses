---
title: "Baseline corrector"
author: "Kelly Miles, Nay San"
date: "Compiled 16:36 14 June 2017"
output: html_document
---

# About

Read all .csv files from `../scaled_and_epoched` and baseline correct the data. Then baseline correct data save `s01.csv` ... in this folder, `data/interim/baseline_corrected`.

## Load packages


```r
library(pacman)

p_load(dplyr, stringr, pbapply)

# Install plyr if it does not exist
# install but do not load plyr (will clash with dplyr)
# basically, just to use plyr::join_all
ifelse(!p_isinstalled("plyr"), p_install("plyr"), "Plyr is installed.")
```

## Baseline correct


```r
list.files(path = "../scaled_and_epoched",
           pattern = ".csv",
           full.names = TRUE) %>%
   
   pblapply(function(csv_file) {
      
      subject_data <- read.csv(csv_file, stringsAsFactors = FALSE)
      
      subject_id <- subject_data$SubjID %>% unique()
      
      paste0("Processing ", subject_id, "...") %>% message()
      
      subject_data %>%
         filter(comp_group =="bln") %>%
         group_by(trial) %>%
         summarise_each(funs(mean, max), raw:meanScale) -> bln_table
      
      names(bln_table)[-1] <-paste0("bln_", names(bln_table)[-1])
      
      subject_data %>%
         filter(comp_group == "roi") %>%
         left_join(bln_table) %>%
         mutate(raw_mean_abs        = raw        - bln_raw_mean,
                rangeScale_mean_abs = rangeScale - bln_rangeScale_mean,
                meanScale_mean_abs  = meanScale  - bln_meanScale_mean,
                raw_mean_perc       = (raw - bln_raw_mean)/bln_raw_mean*100) %>%
         
         write.csv(paste0(subject_id, ".csv"),
                   row.names = FALSE)
      
   })
```


