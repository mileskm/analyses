---
title: "Baseline corrector"
author: "Kelly Miles, Nay San"
date: "Compiled 17:06 14 June 2017"
output: html_document
---

# About

Wrangle data from `../baseline_corrected` for use in Linear Mixed Effects modelling (`LME_dat.csv`), Repeated Measures ANOVA (`rmANOVA_dat.csv`), Baysian (`bayes_dat.csv`), all models which require the input data to be in different forms.

## Load packages


```r
library(pacman)

p_load(dplyr, stringr, pbapply)
```

## Read in data


```r
message("Reading in behavioural data from ../../external/Behavioural_data.csv")
```

```
## Reading in behavioural data from ../../external/Behavioural_data.csv
```

```r
bh <- read.csv("../../external/Behavioural_data.csv",
               stringsAsFactors = FALSE)

message("Reading all .csv files in from ../baseline_corrected")
```

```
## Reading all .csv files in from ../baseline_corrected
```

```r
baseline_corrected_df <- 
   list.files(path = "../baseline_corrected",
              pattern = ".csv",
              full.names = TRUE) %>%
   pblapply(function(csv_file) {
      read.csv(csv_file, stringsAsFactors = FALSE)
   }) %>%
   bind_rows %>%
   left_join(bh)
```

```
## Joining, by = c("SubjID", "trial")
```

## Write out data

### Write out for rmANOVA


```r
baseline_corrected_df %>%
   group_by(SubjID, SRT, Vocoding) %>%
   summarise_each(funs(mean), raw_mean_abs, rangeScale_mean_abs, meanScale_mean_abs, raw_mean_perc) %>%
   write.csv(file = "rmANOVA_dat.csv", row.names = FALSE)
```

### Write out for LME and Bayes


```r
baseline_corrected_df %>%
   group_by(SubjID, trial, SRT, Vocoding) %>% 
   summarise_each(funs(mean), raw_mean_abs, rangeScale_mean_abs, meanScale_mean_abs, raw_mean_perc) %>%
   write.csv("LME_dat.csv", row.names = FALSE)

file.copy("LME_dat.csv", "Bayes_dat.csv")
```

