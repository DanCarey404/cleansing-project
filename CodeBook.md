CodeBook.md for run_analysis.R
========================================================
Purpose: To document the activities taken to acquire, prepare, and process the 
dataset required for the Coursera/JHU "Getting & Cleansing Data" course project.  The goal of the course project is to prepare tidy data that can be used for later analysis.


### HAR Source Data description
* The Human Activity Recognition Using Smartphones (HAR) data elements are described in detail in the README.txt file that is part of the HAR downloaded zip file.  We will not repeat all that information here, but will focus on those elements pertinent to the course project.

* The HAR experiments recorded a group of 30 volunteers performing six activities (Walking, Walking Up Stairs, Walking Down Stairs, Sitting, Standing, and Laying)  while wearing a smartphone.  Using the phone's embedded accelerometer and gyroscope, the experimenters captured 3-axial linear acceleration and 3-axial angular velocity data.

* For each record, the original data files contained:
     * An integer value (1-6) denoting the activity. 
     * An integer value (1-30) identifying the subject who performed the experimental activities.
     * A 561-feature vector with time and frequency domain variables.  Each feature vector is a row in its text file. These vectors record:
          * Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration, normalized and bounded within [-1,1].
          * Triaxial Angular velocity from the gyroscope, normalized and bounded within [-1,1].

* The dataset obtained by the HAR team was randomly partitioned into two sets, where 70% of the volunteers was selected for generating the "training"" data, and 30% the "test"" data.


### HAR Tidy Data description
* This dataset (“har_tidy_avg.csv”) re-combines the test and training partitions into a single dataset, and then includes only those elements identified as mean-value measurements and standard-deviation measurements for each activity and subject.

* This dataset captures the following in each of 180 records:
     * A text description of the activity.
     * An integer value (1-30) identifying the subject who performed the experimental activities.
     * 79 elements representing the computed average (based on activity and subject) of the mean-value and standard-deviation measurements.


METHOD
-------------------------
### OUTSIDE OF R
* Downloaded the "Human Activity Recognition Using Smartphones" dataset zip file 
from the following URL:
   * https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
   
* Unzipped the file and moved the "UCI HAR Dataset" directory into the working 
directory.  
     * The dataset directory contains two sub-directories ("test" and "train"), 
and four explanatory files ("README.txt", "features.txt", "features_info.txt", 
"activity_labels.txt").
     * The run_analysis.R program uses the X_test.txt, y_test.txt, X_train.txt, y_train.txt, and features.txt files as direct inputs.

* IMPORTANT NOTE: Each user must customize in their copy of the run_analysis.R script the path for the working directory before running the script. 


### WITHIN R
* Set the working directory to be the "UCI HAR Dataset" directory.

* Read the activities files for the Test and Train datasets ("./test/y_test.txt", "./train/y_train") into separate dataframes (activity.test, activity.train).

* Read the subject data files for the Test and Training datasets ("./train/subject_train.txt", "./test/subject_test.txt") into separate dataframes (subject.test, subject.train).

* Read the measurements data files ("./test/X_test.txt", "./train/X_train.txt") for the Test and Training datasets into separate dataframes (har.test.df, har.train.df).

* Merged the activity, subject, and measurement dataframes together into a single dataframe (har.feature.df).

* Read the "./features.txt" file and applied its activity names (plus the strings "activity" and "subject") to construct a vector (features.v)

* Created an integer vector (mean.std.cols.v) of columns IDs for the activity, subject, mean-values, and standard-deviation measurements, based on the *-mean() and *-std() names in the features.v vector.

     * Cleaned up the features.v column names to make them R-friendly and applied them to the har.feature.df dataframe.

     * Used the mean.std.cols.v vector to extract only those columns from the har.feature.df dataframe into a new dataframe (har.mean.std.df).

* For each activity...
     * For each test subject...
          * For each measurement...
               * Compute the average for the measurement and store it in the target dataframe (har.tidy.df).
               
* Applied descriptive column names to the har.tidy.df dataframe.

* Saved the har.tidy.df dataframe as a separate file, "har_tidy_avg.csv", in the working directory.
