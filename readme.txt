https://www.github.com/mileskm/analyses README.txt
analyses/data/pre-processing/
Contains MATLAB script for pupil dilation pre-processing
analyses/data/raw
Contains data that has been pre-processed (using the MATLAB pre-processing script) but has not been further processed (e.g., no scaling or baseline corrections, etc)
analyses/data/external:
Contains information in a .csv which has the results of the behavioural measures.
Column headings are coded data are as follows:
•	RatedEffort: Listening effort rating (out of 10)
•	SNR: signal-to-noise ratio for each condition
•	Task accuracy: 0 = incorrect/ no answer, 1 = some words correct, 2 = all words correct
•	Accept: whether trials were accepted/ rejected based on pupil parameters
analyses/data/interim/
Contains the codes for the different data analysis steps
•	subject_long: takes raw files from data/raw and transforms from wide to long
•	remove_rejected_trials: removes rejected trials based on pupil specifications (e.g., in blink, etc)
•	scaled_and_epoched: scales data according to different methods and epochs into regions of interest
•	baseline_corrected: baseline corrects data 
•	export_for_models: aggregates data for each statistical model
