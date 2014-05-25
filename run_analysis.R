##-------1---------2---------3---------4---------5---------6---------7---------8
## run_analysis.R  does the following, using data from the "Human Activity 
## Recognition Using Smartphones" dataset downloaded from 
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip:


## 1. Merges the training and the test sets to create one dataset.
## 2. Extracts only the mean-values and standard-deviation measurements. 
## 3. Applies descriptive activity names to the activities in the dataset.
## 4. Creates a second, independent tidy dataset with the average of each 
##    variable for each activity and each subject.  
## 5. Labels the contents in the dataset with descriptive names. 
##
## =============================================================================

## Begin run_analysis.R

## NOTE: Make sure the run_analysis.R script file and "UCI HAR Dataset" 
## directory are in the working directory.
## setwd("C:/Users/524663/Documents/R/DMCworking/cleaningdata/UCI HAR Dataset")


## Read the activities files for the Test and Train datasets into separate 
## dataframes (activity.test, activity.train).
activity.test  <- read.table("./UCI HAR Dataset/test/y_test.txt")
activity.train <- read.table("./UCI HAR Dataset/train/y_train.txt")


## Apply descriptive activity labels for the activities in the two dataframes. 
len <- nrow(activity.test)
for (i in 1:len) {
        if (activity.test[i,1] == 1) {activity.test[i,2] <- "WALKING"}
        if (activity.test[i,1] == 2) {activity.test[i,2] <- "WALKING_UPSTAIRS"}
        if (activity.test[i,1] == 3) {activity.test[i,2] <- "WALKING_DOWNSTAIRS"}
        if (activity.test[i,1] == 4) {activity.test[i,2] <- "SITTING"}
        if (activity.test[i,1] == 5) {activity.test[i,2] <- "STANDING"}
        if (activity.test[i,1] == 6) {activity.test[i,2] <- "LAYING"}
}
len <- nrow(activity.train)
for (i in 1:len) {
        if (activity.train[i,1] == 1) {activity.train[i,2] <- "WALKING"}
        if (activity.train[i,1] == 2) {activity.train[i,2] <- "WALKING_UPSTAIRS"}
        if (activity.train[i,1] == 3) {activity.train[i,2] <- "WALKING_DOWNSTAIRS"}
        if (activity.train[i,1] == 4) {activity.train[i,2] <- "SITTING"}
        if (activity.train[i,1] == 5) {activity.train[i,2] <- "STANDING"}
        if (activity.train[i,1] == 6) {activity.train[i,2] <- "LAYING"}
}
colnames(activity.test)  <- c("code", "activity")
colnames(activity.train) <- c("code", "activity")


## Read the subject data for the Test and Training datasets into separate 
## dataframes (subject.test, subject.train).
subject.test  <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subject.train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
colnames(subject.test)  <- c("subject")
colnames(subject.train) <- c("subject")


## Read the measurements data for the Test and Training datasets into separate
## dataframes (har.test.df, har.train.df).
har.test.df <- read.table("./UCI HAR Dataset/test/X_test.txt")
har.train.df <- read.table("./UCI HAR Dataset/train/X_train.txt")


## Merge the activity, subject, and measurement dataframes together, first by 
## columns and then by rows, into a single dataframe (har.feature.df).
har.test.df <- cbind(activity.test, subject.test, har.test.df)
har.train.df <- cbind(activity.train, subject.train, har.train.df)
har.feature.df <- rbind(har.train.df, har.test.df)


## Read the features.txt file and apply its activity names (2nd column), plus 
## the strings "activity" and "subject", to construct a vector (features.v)
features.data <- read.table("./UCI HAR Dataset/features.txt")
features.v <- c("code", "activity", "subject", as.character(features.data[,2]))


## Create an integer vector  (mean.std.cols.v) of the columns IDs for the 
## activity, subject, mean-values, and standard-deviation measurements, based 
## on the *-mean() and *-std() names in the features.v vector.
mean.std.cols.v <- c((grep("activity", features.v, value=FALSE)),
                     (grep("subject", features.v, value=FALSE)), 
                     (grep("mean()", features.v, value=FALSE)), 
                     (grep("std()", features.v, value=FALSE)))


## Clean up the features.v column names to make them R-friendly and apply them
## to the har.feature.df dataframe.
features.v <- sub("\\(\\)-" , "_", features.v)
features.v <- sub("\\(\\)" , "_", features.v)
features.v <- sub("\\(" , "_", features.v)
features.v <- sub("\\)" , "_", features.v)
features.v <- sub("*-", "_", features.v)
features.v <- sub(",", "_", features.v)
features.v <- sub("_$", "", features.v)
colnames(har.feature.df) <- features.v


## Use the mean.std.cols.v vector to extract only those columns from the 
## har.feature.df dataframe into a new dataframe (har.mean.std.df).
har.mean.std.df <- har.feature.df[,mean.std.cols.v]


## Create a set of variables and an empty dataframe to be used in processing 
## the har.mean.std.df dataframe.
act.v <- unique(har.mean.std.df[,1])
subj.v <- sort(unique(har.mean.std.df[,2]))
meas.v <- c(3:81)
har.tidy.df <- data.frame()
df.row <- 1

## For each activity...
for (x in c(1:6)) {
        k <- subset(j, subset=(j[,1] == act.v[x]))

        ## For each test subject...
        for (y in subj.v) {
                l <- subset(k, subset=(k[,2] == y))
                
                ## For each measurement...
                for (z in meas.v) {

                        ## Compute the average for the measurement and store it
                        ## in the target dataframe (har.tidy.df).
                        har.tidy.df[df.row, 1] <- act.v[x]
                        har.tidy.df[df.row, 2] <- y
                        har.tidy.df[df.row, z] <- mean(l[,z])
                }
                df.row <- as.integer(df.row + 1)
        }
}

## Apply descriptive column names to the har.tidy.df dataframe.
cols.v <- colnames(har.mean.std.df)
for (q in c(3:81)) { cols.v[q] <- paste("AVG", cols.v[q], sep="_") }
colnames(har.tidy.df) <- cols.v

## Save the har.tidy.df dataframe as a separate tab-delimited file, 
## "har_tidy_avg.txt", in the working directory.
write.table(har.tidy.df, file="./har_tidy_avg.txt", sep="\t", row.names=FALSE)

## End run_analysis.R