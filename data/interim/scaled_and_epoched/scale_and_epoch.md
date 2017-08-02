---
title: "Scale and epoch data"
author: "Kelly Miles, Nay San"
date: "Compiled 16:20 14 June 2017"
output: html_document
---

# About

Read all .csv files from `../remove_rejected_trials` and prepare for baseline correction and export for different models by ... scale, latency, and epoch (describe this better, give motivations).

## Load packages


```r
library(pacman)

p_load(dplyr, stringr, pbapply)
```


```r
list.files(path = "../remove_rejected_trials",
           pattern = ".csv",
           full.names = TRUE) %>%
        pblapply(function(csv_file) {

                # derive aggregate data over each trial
                subject_data <- read.csv(csv_file, stringsAsFactors = FALSE)
                
                subject_id <- subject_data$SubjID %>% unique()
                
                paste0("Processing ", subject_id) %>% message()
                
                subject_data %<>%
                        group_by(trial) %>%
                        mutate(raw        = measurement,
                               min        = min(measurement),
                               max        = max(measurement),
                               range      = max - min,
                               rangeScale = (measurement - min) / range,
                               mean       = mean(measurement),
                               meanScale  = measurement / mean)
                
                # get max value of raw data per trial (e.g. T1, T2...)
                latency_to_max <- filter(subject_data,
                                         time >= 2001, time <= 6001) %>%
                        group_by(trial) %>%
                        summarise(latency = max(raw))
                
                        
                # for each compute group (bln, blq, roi) get mean and max, then cast into wide data frame
                # then join with latency data
                select(subject_data, SubjID, trial, time, raw, rangeScale, meanScale) %>%
                        group_by(trial) %>% 
                        mutate(comp_group = ifelse(time <= 1000, "blq",
                                                   ifelse(time <= 2001, "bln", "roi"))) %>%
                        left_join(latency_to_max) %>%
                   
                   write.csv(paste0(subject_id, ".csv"),
                                  row.names = FALSE)

        })
```
