# Code Book of Getting and Cleaning Data Course Project
## Data Set Information:
The data set are from the experiments which have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. 

Each person (subject) performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) earing a Samsung Galaxy S II smartphone on the waist. 

Using its embedded accelerometer and gyroscope(sensor signal), we captured 3-axial linear aceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partioned into two sets (test and train), where 70% of the volunteers was selected for gather the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.
The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

* tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

* mean(): Mean value
* std(): Standard deviation
* mad(): Median absolute deviation 
* max(): Largest value in array
* min(): Smallest value in array
* sma(): Signal magnitude area
* energy(): Energy measure. Sum of the squares divided by the number of values. 
* iqr(): Interquartile range 
* entropy(): Signal entropy
* arCoeff(): Autorregresion coefficients with Burg order equal to 4
* correlation(): correlation coefficient between two signals
* maxInds(): index of the frequency component with largest magnitude
* meanFreq(): Weighted average of the frequency components to obtain a mean frequency
* skewness(): skewness of the frequency domain signal 
* kurtosis(): kurtosis of the frequency domain signal 
* bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
* angle(): Angle between to vectors.

What we will be using in this project are only mean() and std() measurement variables. angle() is not the direct measurement variable of these signals. It is the angle between to vectors so we will need need to select measurement like this, angle(tBodyAccMean,gravity).

## What is tidy data set in the context of this data set?
The goal of tidy data -
* Each variable forms a column
* Each observations forms a row
* Each table/file stores data about one kind of observation

The tidy data set I would like to create can offer the view of data group by the volunteer, the activity they do, the sensor signal being measured in multiple directions.

To transform this data set to tidy data set, a few steps below are followed:
1. Merge the data in the test and train 2 data sets
2. Give each column a descriptive names
3. Remove duplicate columns. Use dim(), str(), unique(), head(), tail(), nrow() to help examing the data
4. Select only mean() and std() variables/features we would like to keep

After we get a consolidated data set without duplications, we get a data set with 10299 observations and 68 columns. 66 of them are feature names which represent different measurements from 2 senor signals - accelerometer and gyroscope).
The problem we can observe is this data consolidated data set has column headers that are values, not variable names.  

Take tBodyAcc-mean()-X as example,  it can be splitted to 3 different values: senor signal(Acc or Accelerometer), time domain signal type(tBodyAcc-X), and measurement it is taken(mean of the values).
 
To create the tidy data set, we follow the procedures list below -
1. Melt the data. id.vars are subject and activity; the variables are all the features/measurements to get a narrow, skinny data set
2. Split the variable column based on "_" to create 2 separate columns: senor (signal) and measurement. And add the 2 columns to the melted data set created on step 1
3. Give each column a meaningful names: subject, activity, senor, signal, measurement, and reading.

Now, we can clean the data in each column by only subtract the strings we can use to represent the column name. There are 3 columns to be further processed -
sensor - If the value contatins "acc" or "Acc" (case incensitive), "accelerometer" is the senor signal. If the value contains "gyro" or "Gyro" (case incensitive), "gyroscope" is the senor signal. Use the following code to transform the data. When try to find the sub string in a given string, use grep() and ignore the case (ignore.case=TRUE) - find sub string regardless the case.

...

    dt_tidyData$sensor[grepl("acc", dt_tidyData$sensor, ignore.case=TRUE)] <- "accelerometer"
    dt_tidyData$sensor[grepl("gyro", dt_tidyData$sensor, ignore.case=TRUE)] <- "gyroscope"
    signal - since mean and std is embedded in the column value, the following code will remove the mean() and std(). In other words, use "" to substitute mean() and std() when the sub string is found in t given string. 
...

One thing to note is: we can tell by str() that signal is current a factor variable, which does not allow us to convert to different value. We will convert the factor to character class first before we substitute the value. Use lapply and as.character to convert factor to character.

...

    dt_tidyData[4] <- lapply(dt_tidyData[4], as.character)
    dt_tidyData$signal <- sub("-mean\\(\\)", "", dt_tidyData$signal, ignore.case=TRUE)
    dt_tidyData$signal <- sub("-std\\(\\)", "", dt_tidyData$signal, ignore.case=TRUE)
    measurement - only mean and std are our measurements. Use grep to find the value with mean and replace the whole string with mean. Same for std.
    dt_tidyData$measurement[grepl("mean", dt_tidyData$measurement, ignore.case=TRUE)] <- "mean"
    dt_tidyData$measurement[grepl("std", dt_tidyData$measurement, ignore.case=TRUE)] <- "std"
...

group the data by subject, activity, senor, signal, measurement so we can get average of the reading.

...

    by_variables_tidyData <- group_by(dt_tidyData, subject, activity, sensor, signal, measurement)
    summary_tidyData <- summarize(by_variables_tidyData, mean(reading))
...

write the final data set to a text file using write.table() function to create a text file, tidy-getdata-031-project.txt.

...

    write.table(summary_tidyData, file="tidy-getdata-031-project.txt", row.names=FALSE)
...

## **Attribute Information:**
For each record in the dataset it is porvided:
* Triaxial acceleration from the accelerometer(total acceleration) and the estimated body acceleration.
* Triaxial Angular velocity from the gyroscope.
* A 561-feature vector with time and frequency domain variables.
its activity label
* An identifier of the subject who carried out the experiment.

#### **Column Name: Subject**
##### **Description:** Volunteer id. The individual who participanted in the experiments. They are a group of 30 volunteers within an age bracket of 19-48 years.
##### **Data Type:** integer
##### **Values:** 1, 2, 3, 4, 5, ..., 30
##### **N/A:** no

#### **Column Name: activity**
##### **Description:** 6 activities are performed by the 30 volunteers who wears Samsung Galaxy S II smartphone on the waist. WALKING represents the data collected when the volunteer is walking. WALKING_UPSTAIRS represents the data collected when the volunteer is walking upstairs. etc.
##### **Data Type:** character
##### **Values:** 6 factors. Their values are - WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING.
##### **N/A:** no
##### **Data Type:** integer
##### **Values:** 1, 2, 3, 4, 5, ..., 30
##### **N/A:** no

#### **Column Name: sensor**
##### **Description:** 2 sensor signals are measured for 3-axial linear aceleration and 3-axial angular velocity at a constant rate of 50Hz. 
##### **Data Type:** character
##### **Values:** accelerometer,  gyroscope
##### **N/A:** no

#### **Column Name: signal**
##### **Description:** The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals. The acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.
The signal value is a composite value of the following elements -
* f: frequency domain signal
* t: time domain signal
* Body: body motion
* Gravity: gravity motion
* Acc: accelerometer
* Gyro: gyroscope
* Jerk: derieved in time from the body linear acceleration and angular velocity
* Mag: magnitude of the three-dimensional signal which is calculated using the Eclidean norm
* X: X motion direction
* Y: Y motion direction
* Z: Z motion direction

##### **Data Type:** character
##### **Values:** 33 unique values -
* fBodyAcc-X: body acceleration signal of frequency domain in X motion direction
* fBodyAcc-Y: body acceleratoin signal of frequency domain in Y motion direction
* fBodyAcc-Z: body acceleration signal of frequency domain in Z motion direction
* fBodyAccJerk-X: body acceleration jerk signal of frequency domain in X motion direction
* fBodyAccJerk-Y: body acceleration jerk signal of frequency domain in Y motion direction
* fBodyAccJerk-Z: body acceleration jerk signal of frequency domain in Z motion direction
* fBodyAccMag: magnitude of body acceleration signal of frequency domain
* fBodyBodyAccJerkMag: magnitude of body acceleration jerk signal of frequency domain
* tBodyAcc-X: body acceleration signal of time domain in X motion direction
* tBodyAcc-Y: body acceleration signal of time domain in Y motion direction
* tBodyAcc-Z: body acceleration signal of time domain in Z motion direction
* tBodyAccJerk-X: body accelertaion jerk signal of time domain in X motion direction
* tBodyAccJerk-Y: body accelertaion jerk signal of time domain in Y motion direction
* tBodyAccJerk-Z: body accelertaion jerk signal of time domain in Z motion direction
* tBodyAccJerkMag: magnitude of body acceleration jerk signal of time domain
* tBodyAccMag: magnitude of body acceleration of time domain
* tGravityAcc-X: gravity acceleration signal of time domain in X motion direction
* tGravityAcc-Y: gravity acceleration signal of time domain in Y motion direction
* tGravityAcc-Z: gravity acceleration signal of time domain in Z motion direction
* tGravityAccMag: magnitude of gravity acceleration of time domain
* fBodyBodyGyroJerkMag: magnitude of body motion of body gyroscope jerk signal of frequency domain in body motion
* fBodyBodyGyroMag: magnitutude of body motion of body gyroscope signal of frequency domain
* fBodyGyro-X: body gyroscope signal of frequency domain in X motion direction
* fBodyGyro-Y: body gyroscope signal of frequency domain in Y motion direction
* fBodyGyro-Z: body gyroscope signal of frequency domain in Z motion direction
* tBodyGyro-X: body gyroscope signal of time domain in X motion direction
* tBodyGyro-Y:  body gyroscope signal of time domain in Y motion direction
* tBodyGyro-Z:  body gyroscope signal of time domain in Z motion direction
* tBodyGyroJerk-X: body gyroscpoe jerk signal of time domain in X motion direction
* tBodyGyroJerk-Y: body gyroscpoe jerk signal of time domain in Y motion direction
* tBodyGyroJerk-Z: body gyroscpoe jerk signal of time domain in Z motion direction
* tBodyGyroJerkMag: magnitude of body gyroscope jerk signal of time domain
* tBodyGyroMag: magnitude of body grroscope signal of time domain

##### **N/A:** no

#### **Column Name: measurement**
##### **Description:** The values of the signals are summarized in many different ways. In the data set we are interested, we are only interested in mean and standard deviation 2 values.
##### **Data Type:** character
##### **Values:** mean(average), std(standard deviation)
##### **N/A:** no

#### **Column Name: mean(reading)**
##### **Description:** average of the readings from experiment per subject, activity, sensor, signal, measurement
##### **Data Type:** numeric
##### **Values:** the average value of the readings from experiement group by subject, activity, sensor, signal, and measurement.
##### N/A: no


