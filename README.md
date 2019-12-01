---
title: "README"
author: "Aaron Bland"
date: "11/30/2019"
output: html_document
---

This repository contains all the materials required to fulfill the objectives of the Getting and Cleaning Data final project.

## run_analysis.R

This script will create a local folder of the Human Activity Recognition Using Smartphones Dataset, if not already in the working directory, and will use the datafiles within to create two tidier datasets:

1. combined: contains all of the motion data that are calculated mean or standard deviation values labeled by set (training or test), activity, and subject
2. summarized: contains the above motion data averaged for each subject and activity, with the set information discarded. This dataframe is the final output required for the project, and the end of the script has a comment with code for writing the summarized dataframe to a text file.

This script performs all of the functions described by the assignment, listed below:

        1. Merges the training and the test sets to create one data set.
        2. Extracts only the measurements on the mean and standard deviation for each measurement.
        3. Uses descriptive activity names to name the activities in the data set
        4. Appropriately labels the data set with descriptive variable names.
        5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
        
The script includes comments that make it clear which section of code corresponds to each of the above steps. Note that step 3 is performed early in the script, before step 1, as the descriptive activity names replace the numbers in the activity lookup vectors right after the lookup vectors are created.

Note that the original data are normalized values presented in scientific notation. This script reads those values as character vectors before converting to numeric data, and the output does not include scientific notation.

Also note that the data contained within the inertial folders are not read in. These values do not have associated mean or standard deviation calculations associated with them, so they would not be included in either of the tidy datasets. 

For the combined and summarized datasets, I consider the 'wide' form of the dataframe, where each measured feature is a unique column, to be tidier than the 'tall' form of the dataframe, where each measured feature is placed on an individual row and different features are labeled by a single 'feature' column. According to Hadley Wickham’s Tidy Data paper, a tidy dataset has each observation represented by a single row. I believe it is more reasonable to consider the unique observations (and therefore the rows) for this dataset to be each subject performing a specific activity (within either the test or training dataset), and that the features (the columns) are the many measurements made on those observations. I expect this format would be more useful to an end user calculating relationships among the features for each subject performing each activity, for example.

## CodeBook.md

The codebook for the summarizedoutput.txt output file. Describes each of the varibles (columns) of the dataset.

## summarizedoutput.txt

The final output of the run_analysis.R script, and the final output for the project.

The following code may be helpful to view the output data.

```{}
# Note that check.names = FALSE is required to properly load the variable names
data <- read.table('./summarizedoutput.txt', header = TRUE, check.names = FALSE) 
View(data)
```

