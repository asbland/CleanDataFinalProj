---
title: "CodeBook"
author: "Aaron Bland"
date: "11/30/2019"
output: html_document
---

## activity
The activity being performed during the observation.
        
        WALKING
        WALKING_UPSTAIRS
        WALKING_DOWNSTAIRS
        SITTING
        STANDING
        LAYING

## subject
Indicates the volunteer subject performing the activity, ranges from 1-30.
        
## Features (various)
The remainder of the variables in the code output are the average values, by subject and activity, of the features of interest, meaning the normalized mean ('-mean()') and standard deviation ('-std()') values calculated from the accelerometer and gyroscope signals. Values in the original dataset were presented in scientific notation, but here, they are represented without scientific notation. 

The name of each averaged feature comes from the original dataset (listed in the features.txt and features_info.txt files), with 'MEAN-' appended to the start to indicate that the listed values are calculated mean values. For example, 'MEAN-tBodyAcc-mean()-X' corresponds to the 'tBodyAcc-mean()-X' values in the original dataset.
For a description of the individual features prior to averaging (from the features_info.txt file):

        The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 
        
        Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 
        
        Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 
        
        These signals were used to estimate variables of the feature vector for each pattern:  
        '-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.
        
        tBodyAcc-XYZ
        
        tGravityAcc-XYZ
        
        tBodyAccJerk-XYZ
        
        tBodyGyro-XYZ
        
        tBodyGyroJerk-XYZ
        
        tBodyAccMag
        
        tGravityAccMag
        
        tBodyAccJerkMag
        
        tBodyGyroMag
        
        tBodyGyroJerkMag
        
        fBodyAcc-XYZ
        
        fBodyAccJerk-XYZ
        
        fBodyGyro-XYZ
        
        fBodyAccMag
        
        fBodyAccJerkMag
        
        fBodyGyroMag
        
        fBodyGyroJerkMag
        
        The set of variables that were estimated from these signals are: 
        
        mean(): Mean value
        
        std(): Standard deviation
