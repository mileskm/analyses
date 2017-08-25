This function will output two files 
1. An Excel file which contain the following information 
2. A '*.mat' file which contain the trial data

Excel file info :
Column No.:
1. Baseline mean from 0-1second
2. Baseline mean from 1-2 second
3. Maximum value which lies between 2-6 seconds (Note that this max value have not been normalised to the baseline)
4. Maximum value latency 
6. Trial indicator (1 == accept; 0 == reject)
7. Trial TTL-code (e.g 101 102)
8. Mean value of the trial (from 2-6 seconds)
9. Gradient1 = calculated between baseline1 and the max amplitude
10. Gradient2 =calculated between baseline2 and the max amplitude

The rows corresponds to the trial number 

Mat file info :
Rows : time samples (6001)
Columns : trial number (100)


An example on how to use this function - you will need to type the following in the command window:
analyse_pupil(input_filename,trial_size,ID,ii)

Replace each of the input argument as follow:
input_filename == the loaded filename which contain the raw pupil data. e.g. 'Sample.mat'
trial size == the trial size e.g. 6001
ID == the TTL-code e.g   [101 102 103]
ii == whether an extra interpolation is  necessary