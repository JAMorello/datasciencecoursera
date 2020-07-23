---
title: "CodeBook.md"
author: "Juan Agustín Morello"
date: "July 23, 2020"
---

# How "run_analysis.R" works

The code can be launched in the prompt by just importing the file; or in RStudio, by loading the file and submit to source.

**1st Prep Step:** 
* Download and unzip the files (makes subdirectory for the files in case there isn´t)

**2nd Prep Step: **
* Define the path where the new folder has been unziped
* Create a file vector which has all the file names

**1st Step:** 
* Read train, test, features, and activity .txt files and create tables
* Read the feature names
* _Variables_: `x_train`, `y_train`, `x_test`, `y_test`, `subject_train`, `subject_test` and `activity_labels` contain the data from the downloaded files. `features` contains the feature names of train and test tables.

**2nd Step:**
* Concatenate rows of data to have feature, activity and subject tables
* _Variables_: `subject_table`, `activity_table` and `features_table` created with `rbind` using tables from 1st Step.

**3rd Step:**
* Set the name (manually and with `feature` from 1st step) of the columns of the tables from 2nd Step and `activity_labels` from 1st Step

**4th Step:** 
* Merge all the tables
* _Variables_: `full_data` created using `cbind` with tables from 2nd Step

**5th Step:**
* Extract only the measurements on the mean and standard deviation for each measurement using `grep` command
* _Variables: `subset_data` created subsettig `full_data` from 4th Step with the extracted feature names of `grep`

**6th Step:** 
* Apply descriptive activity names to the activities ID in `subset_data` from 5th Step. Replacing integers with strings using `plyr::mapvalues`

**7th Step:** 
* Appropriately labels `subset_data` with descriptive variable names using `gsub` command.
* Names of Feteatures will labelled using descriptive variable names.
	prefix 't' is replaced by 'time'
	'Acc' is replaced by 'Accelerometer'
	'Gyro' is replaced by 'Gyroscope'
	prefix 'f' is replaced by 'frequency'
	'Mag' is replaced by 'Magnitude'
	'BodyBody' is replaced by 'Body'

**8th Step:**
* Create tidy data set with the average of each variable for each activity and each subject
* Order the tidy data by subject and then by activity type
* Write the tidy data to a text file
* _Variables_: `tidy_data` created with `aggregate` command on `subset_data`

# Raw Data Description

### Summary

One of the most exciting areas in all of data science right now (as in 2014) is wearable computing. Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. 

A full description is available at the site where the data was obtained: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

**DISCLAIMER** The data set was downloaded in 23/07/2020.

### Features

There are in total 10,299 observations along 563 features distribuited in all the train, test, subject and activity .txt files.

There were 30 subjects (within an age bracket of 19-48 years) performing 6 activities wearing a smartphone (Samsung Galaxy S II) on the waist

For each record it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

Also:

- Features are normalized and bounded within [-1,1].

The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

### Files

README.txt contains info about the experiments and feature_info.txt explains what the features name and variables mean.
The dataset contains a "Inertial Signals" folder both in train and test that is of no interest to us.
We are interested in the following files:

* features.txt
* activity_labels.txt
* test/subject_test.txt
* test/X_test.txt
* test/y_test.txt
* train/subject_train.txt
* train/X_train.txt
* train/y_train.txt

The variables in the files with 'X' are sensor signals measured with waist-mounted smartphone from 30 subjects.
The variable in the files with 'y' indicates activity type the subjects performed during the experiment.
The 'subject' files contains a subject ID number


# Tidy Data Description

**The variables in the 'tidy_data.txt' file**

Tidy data contains 180 rows and 68 columns. Each row has averaged variables for each subject and each activity.

**Only all the variables estimated from mean and standard deviation in the tidy set were kept.**

* mean(): Mean value
* std(): Standard deviation

**The data were averaged based on subject and activity group.**

Subject column is numbered sequentially from 1 to 30.
Activity column has 6 types as listed below.
1. LAYING
2. SITTING
3. STANDING
4. WALKING
5. WALKING_DOWNSTAIRS
6. WALKING_UPSTAIRS

### Features

 [1] "subjectID"                                     
 [2] "activityType"                                  
 [3] "timeBodyAccelerometer-mean()-X"                
 [4] "timeBodyAccelerometer-mean()-Y"                
 [5] "timeBodyAccelerometer-mean()-Z"                
 [6] "timeBodyAccelerometer-std()-X"                 
 [7] "timeBodyAccelerometer-std()-Y"                 
 [8] "timeBodyAccelerometer-std()-Z"                 
 [9] "timeGravityAccelerometer-mean()-X"             
[10] "timeGravityAccelerometer-mean()-Y"             
[11] "timeGravityAccelerometer-mean()-Z"             
[12] "timeGravityAccelerometer-std()-X"              
[13] "timeGravityAccelerometer-std()-Y"              
[14] "timeGravityAccelerometer-std()-Z"              
[15] "timeBodyAccelerometerJerk-mean()-X"            
[16] "timeBodyAccelerometerJerk-mean()-Y"            
[17] "timeBodyAccelerometerJerk-mean()-Z"            
[18] "timeBodyAccelerometerJerk-std()-X"             
[19] "timeBodyAccelerometerJerk-std()-Y"             
[20] "timeBodyAccelerometerJerk-std()-Z"             
[21] "timeBodyGyroscope-mean()-X"                    
[22] "timeBodyGyroscope-mean()-Y"                    
[23] "timeBodyGyroscope-mean()-Z"                    
[24] "timeBodyGyroscope-std()-X"                     
[25] "timeBodyGyroscope-std()-Y"                     
[26] "timeBodyGyroscope-std()-Z"                     
[27] "timeBodyGyroscopeJerk-mean()-X"                
[28] "timeBodyGyroscopeJerk-mean()-Y"                
[29] "timeBodyGyroscopeJerk-mean()-Z"                
[30] "timeBodyGyroscopeJerk-std()-X"                 
[31] "timeBodyGyroscopeJerk-std()-Y"                 
[32] "timeBodyGyroscopeJerk-std()-Z"                 
[33] "timeBodyAccelerometerMagnitude-mean()"         
[34] "timeBodyAccelerometerMagnitude-std()"          
[35] "timeGravityAccelerometerMagnitude-mean()"      
[36] "timeGravityAccelerometerMagnitude-std()"       
[37] "timeBodyAccelerometerJerkMagnitude-mean()"     
[38] "timeBodyAccelerometerJerkMagnitude-std()"      
[39] "timeBodyGyroscopeMagnitude-mean()"             
[40] "timeBodyGyroscopeMagnitude-std()"              
[41] "timeBodyGyroscopeJerkMagnitude-mean()"         
[42] "timeBodyGyroscopeJerkMagnitude-std()"          
[43] "frequencyBodyAccelerometer-mean()-X"           
[44] "frequencyBodyAccelerometer-mean()-Y"           
[45] "frequencyBodyAccelerometer-mean()-Z"           
[46] "frequencyBodyAccelerometer-std()-X"            
[47] "frequencyBodyAccelerometer-std()-Y"            
[48] "frequencyBodyAccelerometer-std()-Z"            
[49] "frequencyBodyAccelerometerJerk-mean()-X"       
[50] "frequencyBodyAccelerometerJerk-mean()-Y"       
[51] "frequencyBodyAccelerometerJerk-mean()-Z"       
[52] "frequencyBodyAccelerometerJerk-std()-X"        
[53] "frequencyBodyAccelerometerJerk-std()-Y"        
[54] "frequencyBodyAccelerometerJerk-std()-Z"        
[55] "frequencyBodyGyroscope-mean()-X"               
[56] "frequencyBodyGyroscope-mean()-Y"               
[57] "frequencyBodyGyroscope-mean()-Z"               
[58] "frequencyBodyGyroscope-std()-X"                
[59] "frequencyBodyGyroscope-std()-Y"                
[60] "frequencyBodyGyroscope-std()-Z"                
[61] "frequencyBodyAccelerometerMagnitude-mean()"    
[62] "frequencyBodyAccelerometerMagnitude-std()"     
[63] "frequencyBodyAccelerometerJerkMagnitude-mean()"
[64] "frequencyBodyAccelerometerJerkMagnitude-std()" 
[65] "frequencyBodyGyroscopeMagnitude-mean()"        
[66] "frequencyBodyGyroscopeMagnitude-std()"         
[67] "frequencyBodyGyroscopeJerkMagnitude-mean()"    
[68] "frequencyBodyGyroscopeJerkMagnitude-std()" 

**Variables data type**

ActivityType variable is character type.
Subject variable is integer type.
All the other variables are numeric type.