{\rtf1\ansi\ansicpg1252\deff0\deflang1033{\fonttbl{\f0\fnil\fcharset0 Calibri;}{\f1\fnil\fcharset0 Courier New;}{\f2\fnil\fcharset2 Symbol;}}
{\*\generator Msftedit 5.41.21.2510;}\viewkind4\uc1\pard\sa200\sl276\slmult1\lang9\b\f0\fs28 Code Book of Getting and Cleaning Data Course Project\par
\b0\fs24 Data Set Information:\fs22\par
\pard\sa200\sl240\slmult1 The data set are from the experiments which have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person (subject) performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) earing a Samsung Galaxy S II smartphone on the waist. Using its embedded accelerometer and gyroscope(sensor signal), we captured 3-axial linear aceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partioned into two sets (test and train), where 70% of the volunteers was selected for gather the training data and 30% the test data.\par
The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.\par
\pard\sl240\slmult1\lang1033 The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. \par
\par
Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). \par
\par
Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). \par
\par
These signals were used to estimate variables of the feature vector for each pattern:  \par
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.\par
\par
tBodyAcc-XYZ\par
tGravityAcc-XYZ\par
tBodyAccJerk-XYZ\par
tBodyGyro-XYZ\par
tBodyGyroJerk-XYZ\par
tBodyAccMag\par
tGravityAccMag\par
tBodyAccJerkMag\par
tBodyGyroMag\par
tBodyGyroJerkMag\par
fBodyAcc-XYZ\par
fBodyAccJerk-XYZ\par
fBodyGyro-XYZ\par
fBodyAccMag\par
fBodyAccJerkMag\par
fBodyGyroMag\par
fBodyGyroJerkMag\par
\par
The set of variables that were estimated from these signals are: \par
\par
mean(): Mean value\par
std(): Standard deviation\par
mad(): Median absolute deviation \par
max(): Largest value in array\par
min(): Smallest value in array\par
sma(): Signal magnitude area\par
energy(): Energy measure. Sum of the squares divided by the number of values. \par
iqr(): Interquartile range \par
entropy(): Signal entropy\par
arCoeff(): Autorregresion coefficients with Burg order equal to 4\par
correlation(): correlation coefficient between two signals\par
maxInds(): index of the frequency component with largest magnitude\par
meanFreq(): Weighted average of the frequency components to obtain a mean frequency\par
skewness(): skewness of the frequency domain signal \par
kurtosis(): kurtosis of the frequency domain signal \par
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.\par
angle(): Angle between to vectors.\par
\lang9\par
\pard\sl240\slmult1 What we will be using in this project are only mean() and std() measurement variables. angle() is not the direct measurement variable of these signals. It is the angle between to vectors so we will need need to select measurement like this, \lang1033 angle(tBodyAccMean,gravity).\f1\par
\pard\sa200\sl276\slmult1\lang9\f0\fs24\par
What is tidy data set in the context of this data set?\par
\fs22 The goal of tidy data -\par
\pard{\pntext\f2\'B7\tab}{\*\pn\pnlvlblt\pnf2\pnindent0{\pntxtb\'B7}}\fi-360\li720\sa200\sl240\slmult1 Each variable forms a column\par
{\pntext\f2\'B7\tab}Each observations forms a row\par
{\pntext\f2\'B7\tab}Each table/file stores data about one kind of observation\par
\pard\sa200\sl240\slmult1 To transform this data set to tidy data set, a few steps below are followed:\par
\pard{\pntext\f0 1.\tab}{\*\pn\pnlvlbody\pnf0\pnindent0\pnstart1\pndec{\pntxta.}}
\fi-360\li720\sa200\sl240\slmult1 merge the data in the test and train 2 data sets\par
{\pntext\f0 2.\tab}give each column a descriptive names\par
{\pntext\f0 3.\tab}remove duplicate columns. Use dim(), str(), unique(), head(), tail(), nrow() to help examing the data\par
{\pntext\f0 4.\tab}select only mean() and std() variables/features we would like to keep\par
\pard\sa200\sl240\slmult1 After we get a consolidated data set without duplications, we get a data set with 10299 observations and 68 columns. 66 of them are feature names which represent different measurements from 2 senor signals - accelerometer and gyroscope).\par
\pard The problem we can observe is this data consolidated data set has column headers that are values, not variable names.  \par
\par
Take \lang1033 tBodyAcc-mean()-X as example,  it can be splitted to 3 different values: senor signal(Acc or Accelerometer), time domain signal type(tBodyAcc-X), and measurement it is taken(mean of the values).\par
\pard\sa200\sl240\slmult1\lang9  \par
To create the tidy data set, we follow the procedures list below -\par
\pard{\pntext\f2\'B7\tab}{\*\pn\pnlvlblt\pnf2\pnindent0{\pntxtb\'B7}}\fi-360\li720\sa200\sl240\slmult1 melt the data. id.vars are subject and activity; the variables are all the features/measurements to get a narrow, skinny data set\par
{\pntext\f2\'B7\tab}split the variable column based on "_" to create 2 separate columns: senor (signal) and measurement. And add the 2 columns to the melted data set created on step 1\par
{\pntext\f2\'B7\tab}give each column a meaningful names: subject, activity, senor, signal, measurement, and reading.\par
\pard\sa200\sl240\slmult1 Now, we can clean the data in each column by only subtract the strings we can use to represent the column name. There are 3 columns to be further processed -\par
\pard{\pntext\f2\'B7\tab}{\*\pn\pnlvlblt\pnf2\pnindent0{\pntxtb\'B7}}\fi-360\li720\sa200\sl240\slmult1 sensor - If the value contatins "acc" or "Acc" (case incensitive), "accelerometer" is the senor signal. If the value contains "gyro" or "Gyro" (case incensitive), "gyroscope" is the senor signal. Use the following code to transform the data. When try to find the sub string in a given string, use grep() and ignore the case (ignore.case=TRUE) - find sub string regardless the case.\par
\pard\sa200\sl240\slmult1\i dt_tidyData$sensor[grepl("acc", dt_tidyData$sensor, ignore.case=TRUE)] <- "accelerometer"\par
dt_tidyData$sensor[grepl("gyro", dt_tidyData$sensor, ignore.case=TRUE)] <- "gyroscope"\i0\par
\pard{\pntext\f2\'B7\tab}{\*\pn\pnlvlblt\pnf2\pnindent0{\pntxtb\'B7}}\fi-360\li720\sa200\sl240\slmult1 signal - since mean and std is embedded in the column value, the following code will remove the mean() and std(). In other words, use "" to substitute mean() and std() when the sub string is found in t given string. \par
\pard\sa200\sl240\slmult1 One thing to note is: we can tell by str() that signal is current a factor variable, which does not allow us to convert to different value. We will convert the factor to character class first before we substitute the value. Use lapply and as.character to convert factor to character.\par
\i dt_tidyData[4] <- lapply(dt_tidyData[4], as.character)\par
dt_tidyData$signal <- sub("-mean\\\\(\\\\)", "", dt_tidyData$signal, ignore.case=TRUE)\par
dt_tidyData$signal <- sub("-std\\\\(\\\\)", "", dt_tidyData$signal, ignore.case=TRUE)\par
\pard{\pntext\f2\'B7\tab}{\*\pn\pnlvlblt\pnf2\pnindent0{\pntxtb\'B7}}\fi-360\li720\sa200\sl240\slmult1\i0 measurement - only mean and std are our measurements. Use grep to find the value with mean and replace the whole string with mean. Same for std.\par
\pard\sa200\sl240\slmult1\i dt_tidyData$measurement[grepl("mean", dt_tidyData$measurement, ignore.case=TRUE)] <- "mean"\par
dt_tidyData$measurement[grepl("std", dt_tidyData$measurement, ignore.case=TRUE)] <- "std"\par
\pard{\pntext\f2\'B7\tab}{\*\pn\pnlvlblt\pnf2\pnindent0{\pntxtb\'B7}}\fi-360\li720\sa200\sl240\slmult1\i0 group the data by subject, activity, senor, signal, measurement so we can get average of the reading.\par
\pard\sa200\sl240\slmult1\i by_variables_tidyData <- group_by(dt_tidyData, subject, activity, sensor, signal, measurement)\par
summary_tidyData <- summarize(by_variables_tidyData, mean(reading))\par
\pard{\pntext\f2\'B7\tab}{\*\pn\pnlvlblt\pnf2\pnindent0{\pntxtb\'B7}}\fi-360\li720\sa200\sl240\slmult1\i0 write the final data set to a text file using write.table() function to create a text file, tidy-getdata-031-project.txt.\par
\pard\sa200\sl240\slmult1\i write.table(summary_tidyData, file="tidy-getdata-031-project.txt", row.names=FALSE)\par
\i0\par
\fs24 Attribute Information:\par
\pard{\pntext\f2\'B7\tab}{\*\pn\pnlvlblt\pnf2\pnindent0{\pntxtb\'B7}}\fi-360\li720\sa200\sl240\slmult1\fs22 For each record in the dataset it is porvided:\par
{\pntext\f2\'B7\tab}Triaxial acceleration from the accelerometer(total acceleration) and the estimated body acceleration.\par
{\pntext\f2\'B7\tab}Triaxial Angular velocity from the gyroscope.\par
{\pntext\f2\'B7\tab}A 561-feature vector with time and frequency domain variables.\par
{\pntext\f2\'B7\tab}its activity label\par
{\pntext\f2\'B7\tab}An identifier of the subject who carried out the experiment.\par
\pard\sa200\sl276\slmult1\b Column Name: Subject\par
Description: \b0 Volunteer id. The individual who participanted in the experiments. They are a group of 30 volunteers within an age bracket of 19-48 years.\b\par
Data Type: \b0 integer\par
\b Values: \b0 1, 2, 3, 4, 5, ..., 30\par
\b N/A\b0 : no\par
\b Column Name: activity\par
Description: \b0 6 activities are performed by the 30 volunteers who wears Samsung Galaxy S II smartphone on the waist. WALKING represents the data collected when the volunteer is walking. WALKING_UPSTAIRS represents the data collected when the volunteer is walking upstairs. etc.\par
\b Data Type: \b0 character\par
\b Values: \b0 6 factors. Their values are - WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING.\b\par
N/A: \b0 no\par
\b Data Type: \b0 integer\par
\b Values: \b0 1, 2, 3, 4, 5, ..., 30\par
\b N/A\b0 : no\par
\b Column Name: sensor\par
Description: \b0 2 sensor signals are measured for 3-axial linear aceleration and 3-axial angular velocity at a constant rate of 50Hz. \par
\b Data Type: \b0 character\par
\b Values: \b0 accelerometer,  gyroscope\b\par
N/A: \b0 no\par
\b Column Name: signal\par
\pard\sl240\slmult1 Description: \lang1033\b0 The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals. The acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. \par
\par
Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). \par
\par
These signals were used to estimate variables of the feature vector for each pattern:  \par
\pard\sa200\sl276\slmult1 '-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.\par
The signal value is a composite value of the following elements -\par
f: frequency domain signal\par
t: time domain signal\par
Body: body motion\par
Gravity: gravity motion\par
Acc: accelerometer\par
Gyro: gyroscope\par
Jerk: derieved in time from the body linear acceleration and angular velocity\par
Mag: magnitude of the three-dimensional signal which is calculated using the Eclidean norm\par
X: X motion direction\par
Y: Y motion direction\par
Z: Z motion direction\lang9\par
\b Data Type: \b0 character\par
\b Values: \b0 33 unique values -\par
fBodyAcc-X: body acceleration signal of frequency domain in X motion direction\par
fBodyAcc-Y: body acceleratoin signal of frequency domain in Y motion direction\par
fBodyAcc-Z: body acceleration signal of frequency domain in Z motion direction\par
fBodyAccJerk-X: body acceleration jerk signal of frequency domain in X motion direction\par
fBodyAccJerk-Y: body acceleration jerk signal of frequency domain in Y motion direction\par
fBodyAccJerk-Z: body acceleration jerk signal of frequency domain in Z motion direction\par
fBodyAccMag: magnitude of body acceleration signal of frequency domain\par
fBodyBodyAccJerkMag: magnitude of body acceleration jerk signal of frequency domain\par
tBodyAcc-X: body acceleration signal of time domain in X motion direction\par
tBodyAcc-Y: body acceleration signal of time domain in Y motion direction\par
tBodyAcc-Z: body acceleration signal of time domain in Z motion direction\par
tBodyAccJerk-X: body accelertaion jerk signal of time domain in X motion direction\par
tBodyAccJerk-Y: body accelertaion jerk signal of time domain in Y motion direction\par
tBodyAccJerk-Z: body accelertaion jerk signal of time domain in Z motion direction\par
tBodyAccJerkMag: magnitude of body acceleration jerk signal of time domain\par
tBodyAccMag: magnitude of body acceleration of time domain\par
tGravityAcc-X: gravity acceleration signal of time domain in X motion direction\par
tGravityAcc-Y: gravity acceleration signal of time domain in Y motion direction\par
tGravityAcc-Z: gravity acceleration signal of time domain in Z motion direction\par
tGravityAccMag: magnitude of gravity acceleration of time domain\par
fBodyBodyGyroJerkMag: magnitude of body motion of body gyroscope jerk signal of frequency domain in body motion\par
fBodyBodyGyroMag: magnitutude of body motion of body gyroscope signal of frequency domain\par
fBodyGyro-X: body gyroscope signal of frequency domain in X motion direction\par
fBodyGyro-Y: body gyroscope signal of frequency domain in Y motion direction\par
fBodyGyro-Z: body gyroscope signal of frequency domain in Z motion direction\par
tBodyGyro-X: body gyroscope signal of time domain in X motion direction\par
tBodyGyro-Y:  body gyroscope signal of time domain in Y motion direction\par
tBodyGyro-Z:  body gyroscope signal of time domain in Z motion direction\par
tBodyGyroJerk-X: body gyroscpoe jerk signal of time domain in X motion direction\par
tBodyGyroJerk-Y: body gyroscpoe jerk signal of time domain in Y motion direction\par
tBodyGyroJerk-Z: body gyroscpoe jerk signal of time domain in Z motion direction\par
tBodyGyroJerkMag: magnitude of body gyroscope jerk signal of time domain\par
tBodyGyroMag: magnitude of body grroscope signal of time domain\b\par
N/A: \b0 no\par
\b Column Name: measurement\par
Description: \b0 The values of the signals are summarized in many different ways. In the data set we are interested, we are only interested in mean and standard deviation 2 values.\par
\b Data Type: \b0 character\par
\b Values: \b0 mean(average), std(standard deviation)\b\par
N/A: \b0 no\par
\b Column Name: mean(reading)\par
Description: \b0 average of the readings from experiment per subject, activity, sensor, signal, measurement\par
\b Data Type: \b0 numeric\par
\b Values: \b0 the average value of the readings from experiement group by subject, activity, sensor, signal, and measurement.\par
\b N/A: \b0 no\par
\par
\par
\par
}
 