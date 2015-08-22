##
## run_analysis.R by Huey-Lin Cheng @2015/08/15
##

## load the required libraries:
##     dplyr(), data.table(), tidyr()

library(dplyr)
library(data.table)
library(reshape2)
library(tidyr)

##
## Step 0. Read the data from the files into data frames.
##    Read raw data files (read.table) into data frames without header
##    Based on the dim(), both test and train has 561 columns
##    feaures includes the descriptive names of columns
## 
df_x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header=FALSE)
df_y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header=FALSE)
df_subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE)
df_x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header=FALSE)
df_y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header=FALSE)
df_subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE)

features <- read.table("./UCI HAR Dataset/features.txt", header=FALSE)
activity_lables <- read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE)

##
## create tidy data set
## The final tidy data set should look like -
##    subject, activity(lable), sensor type, signal, estimates(mean/std), readings

##
##
## Step 1. Merges the training and the test sets to create one data set.
##

##   1.1. assign meaningful column names to each column
df_x_allData <- rbind(df_x_test, df_x_train)
df_y_allData <- rbind(df_y_test, df_y_train)
df_subject_allData <- rbind(df_subject_test, df_subject_train)

##   1,2, assign column name to each column
colnames(df_x_allData) <- features[,2]
colnames(df_y_allData) <- c("activity")
colnames(df_subject_allData) <- c("subject")
colnames(activity_lables) <- c("activity","actyDescription")

##   1.3. group x, y, subject 3 dimensional data into one data frame
df_allData <- cbind(df_subject_allData, df_y_allData)
df_allData <- cbind(df_allData, df_x_allData)

##   1.4. exam the data, and add one more column to give more descriptive wording by merging activty_lables
##   Now we have df_allData which includes all data and columns
##   Exam the data with dim(), str(), unique(), head(), tail()  to ensure data is merged correctly.
##   Remove duplicated column names. Without this step, select function gives error for duplicated column names
df_allData <- df_allData[,!duplicated(colnames(df_allData))]
df_allData <- merge(df_allData, activity_lables, by="activity")

##
## Step 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 

##   2.1. convert data frame to data table to take advantages of dplyr() library
dt_allData <- tbl_df(df_allData)

##   2.2. select subset of the columns required.
##   We only need mean() and std() signal's measurements. 
##   That is the feature names include any string as mean() or std().
##   Note: Excluding all angle() and Fre() variables since they are not the means of the measurements.
##         angle() is the angle between vectors, not the measurement of one sensor's signal 
##         meanFreq() is the weighted mean of frequency, not the mean of measurements
dt_extractMeanStd <- select(dt_allData, subject, actyDescription, grep("mean\\(\\)|std\\(\\)", colnames(dt_allData), fixed=FALSE))

##
## Step 3. Uses descriptive activity names to name the activities in the data set
##         by including actyDescription in the data set but still name it as activity
##

setnames(dt_extractMeanStd, "actyDescription", "activity")

## 
## Step 4. Appropriately labels the data set with descriptive variable names
##

## 
## Step 5. Reshape data to create tidy data
##   Tidy data set will meet 5 criteria -
##     1. each row is a complete observation
##     2. each column contains the one variable.
##        The data set created up to Step 4 violates thie rule.
##          for example, tBodyAcc-mean, represents 3 values: 
##             Acc, Gyro - senor type, tBodayAcc - signal,
##             and measurements(mean, std)
##    To create tidy data set, we melt the data to narrow skinny data set first.
##

##   5.1. melt the data set
##        id vars: subject, activity
##        measure vars: all the measurements of features
##        As a result, we will have a very narrow data frame
dt_narrowData <- melt(dt_extractMeanStd, id.vars=c("subject", "activity"))

##   5.2. In this melted data set, variable column represents more than one variable: sensor type, signal, and measurements
## 
dt_splitVar <- colsplit(dt_narrowData$variable, "-", c("sensor", "measurement"))
dt_tidyData <- cbind(dt_narrowData, dt_splitVar)

##   5.3. Create initial tidy data set by selecting the columns we want in sequence
## 
dt_tidyData <- select(dt_tidyData,subject, activity, sensor, variable, measurement, value)

## rename columns to meaningful names
colnames(dt_tidyData) <- c("subject", "activity", "sensor", "signal", "measurement", "reading")

## clean up the data in each column so each value represents one variable
## sensor: accelerometer and gryroscope
## signal: tBodyAcc-X, -Y, -XYZ, tGravityAcc-XYZ, tBodyAccJerk-XYZ, tBodyGyro-XYZ
## measure: mean, std

dt_tidyData$sensor[grepl("acc", dt_tidyData$sensor, ignore.case=TRUE)] <- "accelerometer"
dt_tidyData$sensor[grepl("gyro", dt_tidyData$sensor, ignore.case=TRUE)] <- "gyroscope"

## convert signal factor as character so we can 
dt_tidyData[4] <- lapply(dt_tidyData[4], as.character)
dt_tidyData$signal <- sub("-mean\\(\\)", "", dt_tidyData$signal, ignore.case=TRUE)
dt_tidyData$signal <- sub("-std\\(\\)", "", dt_tidyData$signal, ignore.case=TRUE)

dt_tidyData$measurement[grepl("mean", dt_tidyData$measurement, ignore.case=TRUE)] <- "mean"
dt_tidyData$measurement[grepl("std", dt_tidyData$measurement, ignore.case=TRUE)] <- "std"

##   5.4. group the tidy data set by subject, activity, sensor, signal, and measurement
by_variables_tidyData <- group_by(dt_tidyData, subject, activity, sensor, signal, measurement)

##   5.5. get average of readings by group
summary_tidyData <- summarize(by_variables_tidyData, mean(reading))

##   5.6. use write.table to write to a text file
write.table(summary_tidyData, file="tidy-getdata-031-project.txt", row.names=FALSE)

    
    

