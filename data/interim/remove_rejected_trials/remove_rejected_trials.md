---
title: "Transform subject data from wide to long"
author: "Kelly Miles, Nay San"
date: "Compiled 16:02 14 June 2017"
output: html_document
---

# About

Removes rejected trials as defined in `data/external/Behavioural_data.csv` from the long format data in `data/interim/subject_long/*.csv`.

## Load packages


```r
library(pacman)

p_load(tidyr, dplyr, stringr, pbapply)
```

## Load data on accepted/rejected trials

(type stuff here). Accepted = 0 means rejected.


```r
behavioural_data <- read.csv("../../external/Behavioural_data.csv",
                             stringsAsFactors = FALSE)
```


## Remove rejected trials


```r
list.files("../subjects_long/",
           pattern = ".csv",
           full.names = TRUE) %>%
        pblapply(function(csv_file) {
                
                all_long <- read.csv(csv_file,
                                     stringsAsFactors = FALSE)
                
                subject_id <- unique(all_long$SubjID)
                
                paste0("Processing ", subject_id, "...") %>% message()
                
                rejected_trials <- behavioural_data %>%
                        select(SubjID, trial, Accept) %>%
                        arrange(SubjID, trial) %>%
                        filter(SubjID == subject_id,
                               Accept == 0)
                
                anti_join(all_long, rejected_trials) %>%
                        write.csv(paste0(subject_id, ".csv"),
                                  row.names = FALSE)
        })
```

