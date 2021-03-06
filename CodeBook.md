---
title:"CodeBook"  
author:"dherzog02"  
date:"June 20,2015"  
output:html_document  
---

#Description

##Summary

This script creates two data sets in the global environment called filtData and tidyData. The data set "tidyData.txt" is the output from the final step in the "run_analysis.R" script. The specific steps taken in the script are outlined in the [README.md](README.md) file. After running the script the "tidyData.txt" file is created with the following line of code:

write.table(tidyData, row.name = FALSE, file = "tidyData.txt")

*Note: The write.table function actually has a "row.names" argument. The instructions for the project indicate that the write.table function should be called with "row.name=FALSE" which works because it is a partial match for the argument.*

filtData is the combined & filtered data set that is the result of the first four steps of the Getting and Cleaning Data Course project. A second data table is created called tidyData that meets the requirements of step 5.

The data can be read into R using the following code, assuming that tidyData.txt has been downloaded into the working directory:

tidyData <- read.table(file = "tidyData.txt", header =  TRUE, colClasses = c("factor","factor","character","numeric"))

To convert this back to the "wide form" use the following code:

widetidyData <- dcast(tidyData, Subject + Activity ~ Measure, mean, value.var = "Value")

##Source of the data

The source of the data is from the Human Activity Recognition Using Smartphones Data Set available through the Machine Learning Repository at the University of California, Irvine. The project is URL is <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

The original data is available here: <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

The experiment measured the accelerometer and gyroscope data from a Samsung Galaxy S II.  The original observations were from thirty subjects performing six different tasks a number of times. The data was then summarized into 561 different features of the data. The data used as input to this script has already been through a number of transformations and calculations. Those calculations are described in detail in the "features_info.txt" and "README.txt" files located in the original zip file.

#Contents

##Columns

The tidyData.txt file uses the melted form of tidy data as described by Hadley Wickham's paper available at <http://vita.had.co.nz/papers/tidy-data.pdf>. The four columns in this data set are:

- Subject - One of thirty subjects numbers 1:30. The original script coerces this column to a Factor.
- Activity - One of six different activities: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
- Measure - One of sixty-six different measures described below.
- Value - The numeric value for that measure. All measures were normalized and bounded within [-1,1] in the original data set.

The total number of rows in this data set if 11,880 (30 subjects * 6 activities * 66 measures).

##Measures:

###Description of names

The measures column contains 66 possible values summarized below. 

* Prefix Letter: 
  * 't' indicates a "time domain" value
  * 'f' indicates a "frequency domain" value
* Measurement type:
  * BodyAcc - Body Accelerometer
  * GravityAcc - Gravity Accelerometer
  * BodyGyro - Body Gyroscope
  * ...Jerk - Indicates "Jerk" data calculated using the Body Accelerometer or Body Gyroscope with the angular velocity
  * ...Mag - Indicates "Magnitude" values which were calculated using the "Euclidean norm"
* Calculation:
  * mean - Mean measurement 
  * std - Standard deviation measurement
* XYZ - Denotes that this measurement has 3-axial signals separated into three different measurements, one for each direction
* '-summarized' - This is appended to the names of the variables to distinguish these values from the values in the intermediate source table filtData

###List of values:

- tBodyAcc-mean-XYZ-summarized
- tBodyAcc-std-XYZ-summarized
- tGravityAcc-mean-XYZ-summarized
- tGravityAcc-std-XYZ-summarized
- tBodyAccJerk-mean-XYZ-summarized
- tBodyAccJerk-std-XYZ-summarized
- tBodyGyro-mean-XYZ-summarized
- tBodyGyro-std-XYZ-summarized
- tBodyGyroJerk-mean-XYZ-summarized
- tBodyGyroJerk-std-XYZ-summarized
- tBodyAccMag-mean-summarized
- tBodyAccMag-std-summarized
- tGravityAccMag-mean-summarized
- tGravityAccMag-std-summarized
- tBodyAccJerkMag-mean-summarized
- tBodyAccJerkMag-std-summarized
- tBodyGyroMag-mean-summarized
- tBodyGyroMag-std-summarized
- tBodyGyroJerkMag-mean-summarized
- tBodyGyroJerkMag-std-summarized
- fBodyAcc-mean-XYZ-summarized
- fBodyAcc-std-XYZ-summarized
- fBodyAccJerk-mean-XYZ-summarized
- fBodyAccJerk-std-XYZ-summarized
- fBodyGyro-mean-XYZ-summarized
- fBodyGyro-std-XYZ-summarized
- fBodyAccMag-mean-summarized
- fBodyAccMag-std-summarized
- fBodyBodyAccJerkMag-mean-summarized
- fBodyBodyAccJerkMag-std-summarized
- fBodyBodyGyroMag-mean-summarized
- fBodyBodyGyroMag-std-summarized
- fBodyBodyGyroJerkMag-mean-summarized
- fBodyBodyGyroJerkMag-std-mean