README.md
========================================================

This repository consists of a single R script (run_analysis.R), a "cookbook" (CodeBook.md) and this README.md file.
 
The CodeBook.md file explains the origin and treatment of the data as processed by the run_analysis.R script.

Input data are to be downloaded from: 
* https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

IMPORTANT NOTE: Each user must unzip the downloaded file and move the "UCI HAR Dataset" directory into their working directory before running the script. Otherwise the paths will be wrong and the script will not work correctly.

Once the input data directory is in place, the run_analysis.R file can be run as a stand-alone script, requiring no input parameters.  It creates a single output file, "har_tidy_avg.txt", in the working directory.

