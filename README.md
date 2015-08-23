# **Introduction**

Getting and Cleaning Data Course Project requires us to write a R script, run_analysis.R to demonstrate how we collect, work with, and clean a data set to get a tidy data set. 

run_analysis.R does the following -

1. Merges the training and the test sets to create one data set
2. Extracts only the measurements on the mean and standard deviation for each measurement
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

To run the script to generate tidy data set, run the following command under R prompt with setwd() set to the current working directory where run_analysis.R exists.

R> source(run_analysis.R)

## **Step 0. Read the instructions, README.md, prepare the working directory and Github repo, and read the data from the data files**

* Read the course project instructions
* Create local working directory to store downloaded data and codes
* Download the data files under a sub directory, "UCI HAR Dataset" of the working directory created on step 0.2
* Exam the content of the data files, README, activity_labels, features, feature_info, test/*, and train/* visually
* Create a github repo to upload the codes and results to github for peer reviews
* Create a R script under the working directory setup at step 0.2
* Load required libraries(dplyr, data.table, reshape2, tidyr) used in this script

...
    _library(dplyr)_
    _library(data.table)_
   
...

* Read raw data from the files to store in R data frames. 

    _df_x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header=FALSE)_

There are a few data sets we need and the data included is explained as the following:
* X_test, y_test have all the measurements of the signals
* subject_test has the data of the subjects(volunteer ID) who performs the activity
* features has the names of the measurements of the signals
* activity_lables has the descriptive activity labels for each activity id

## **Step 1. Merges the training and the test sets to create one data set**

1. Merge X, y, subject data under both test and train directories using rbind
2. Assign descriptive name to each column in the data frames
3. Merge with subject_test, activity using cbind
4. Remove duplicate columns with the same column names from the consolidated data frame

Use dim(), str(), head(). tail(). unique() after each step to exam the data set and ensure data is merged correctly without duplication.

The result of the data frame looks like the following -

    subject    activity   feature1  feature2 ... featureN

## **Step 2. Extracts only the measurements on the mean and standard deviation for each measurement**

1. Convert data frame, dt_allData to data table via tbl_df so we can use dplyr package to clean the data
2. Use select() function to get only the columns containing mean() or std() of the signal/measurements

    _dt_extractMeanStd <- select(dt_allData, subject, actyDescription, grep("mean\\(\\)|std\\(\\)", colnames(dt_allData), fixed=FALSE))_

## **Step 3. Uses descriptive activity names to name the activities in the data set**

Use setname() to rename descriptive activity column to 'activity'

    _setnames(dt_extractMeanStd, "actyDescription", "activity")_

## **Step 4. Appropriately labels the data set with descriptive variable names**

This step in the instruction is covered in step 1.2 above

## **Step 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject**

By examing the data, and assume that in the future, we would like to analyze and summarize the data to know who (subject), what activity,  what type of senor generates the data, what measurement of the signal presents, and its actual value, the tidy data set to be created requires to sepearate sensor type, signal type, and measurement (mean/std) from all the features. To achive this tidy data set, first, melt the data set to a narrow, skinny set. Next, add new columns to use one column to represent one variable.  The structure of this tidy data set will look as a database table in the 3rd normal form.

    subject    activity           sensor       signal             measurement       reading

Finally, we run_analysis.R create a tidy data with the average of the reading per subject, activity, sensor, signal, and measurement in the tidy data set, and write into a text file.

* Melt the data set

    _dt_narrowData <- melt(dt_extractMeanStd, id.vars=c("subject", "activity"))_

* Split the 'variable' volumn to represent 2 other variables (senor type, and measurement)

    _dt_splitVar <- colsplit(dt_narrowData$variable, "-", c("sensor", "measurement"))
dt_tidyData <- cbind(dt_narrowData, dt_splitVar)_

* Create initial tidy data set by selecting the columns we need, rename to more descriptive column names, and clean up the data value to reflect column name

...
    
    dt_tidyData <- select(dt_tidyData,subject, activity, sensor, variable, measurement, value)
    colnames(dt_tidyData) <- c("subject", "activity", "sensor", "signal", "measurement", "reading")

    dt_tidyData$sensor[grepl("acc", dt_tidyData$sensor, ignore.case=TRUE)] <- "accelerometer"
    dt_tidyData$sensor[grepl("gyro", dt_tidyData$sensor, ignore.case=TRUE)] <- "gyroscope"

    dt_tidyData[4] <- lapply(dt_tidyData[4], as.character)
    dt_tidyData$signal <- sub("-mean\\(\\)", "", dt_tidyData$signal, ignore.case=TRUE)
    dt_tidyData$signal <- sub("-std\\(\\)", "", dt_tidyData$signal, ignore.case=TRUE)

    dt_tidyData$measurement[grepl("mean", dt_tidyData$measurement, ignore.case=TRUE)] <- "mean"
    dt_tidyData$measurement[grepl("std", dt_tidyData$measurement, ignore.case=TRUE)] <- "std"
...

* Group the tidy data set by subject, activity, sensor, signal, and measurement

	_by_variables_tidyData <- group_by(dt_tidyData, subject, activity, sensor, signal, measurement)_

* Get average of readings by group

	_summary_tidyData <- summarize(by_variables_tidyData, mean(reading))_

* Use write.table to write to a text file

	_write.table(summary_tidyData, file="tidy-getdata-031-project.txt", row.names=FALSE)_


