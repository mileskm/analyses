---
title: "Transform subject data from wide to long"
author: "Kelly Miles, Nay San"
date: "Compiled 16:02 14 June 2017"
output: html_document
---

# About

Grabs all .csv files in `data/raw/` and saves long-format .csv files into this directory, `/data/interim/subject_long`.


```r
library(pacman)

p_load(tidyr, dplyr, stringr, pbapply)
```

# Script


```r
list.files(path = "../../raw",
           pattern = ".csv",
           full.names = TRUE) %>%
   
   pblapply(function(csv_file) {
                subject_id <- str_extract(csv_file, "S\\d+")
                
                paste0("Processing ", subject_id, "...") %>% message()
                
                read.csv(csv_file, header = TRUE) %>%
                gather(trial, measurement, T1:T220, factor_key=TRUE) %>%
                rename(time = TrialPoint) %>%
                cbind(SubjID = subject_id, ., 
                      stringsAsFactors = FALSE) %>% 
                write.csv(paste0(subject_id, ".csv"), row.names = FALSE)
        })
```

