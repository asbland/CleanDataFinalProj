# The following code will load, tidy, manipulate, and analyze the 
# Samsung Galaxy S II sensor data in fullfilment of the final project for the 
# Getting and Cleaning Data course.

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Download the zipped dataset to the current working directory it it does not 
# already exist. Either way, create a vector of file paths for all of the 
# downloaded files.

if(!dir.exists('./UCI HAR Dataset')) {
        zipfile <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
        download.file(zipfile, 'sensordata.zip')
        
        # Unzip the folder, and create a vector of file paths for all of the contents
        filepaths <- unzip('sensordata.zip')
        
        # Delete the zipped folder
        unlink("sensordata.zip", recursive = TRUE)
} else filepaths <- list.files('./UCI HAR Dataset', recursive = TRUE)

# Append the UCI folder name to the file path strings
filepaths <- paste("./UCI HAR Dataset/", filepaths, sep = "")

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Use some of the provided files to create a series of lookup vectors. These
# vectors will help create new variables based on the row or column positions of 
# the datapoints or from corresponding values in other data files. 

# Identify the filepath corresponding to the "features.txt" file, which indicates
# the features that are listed on each line of the data files, then load the 
# contents of that file to create a feature lookup vector

tempfilepath <- grep('/features\\.txt$', filepaths, value = TRUE)
features <- read.table(tempfilepath); features <- as.vector(features[,2])

# Identify the filepaths corresponding to the "subject_test.txt" file and the 
# "subject_train.txt" file, which indicate the rows of the data files that  
# correspond to each subject for the test and train data sets, then load the 
# contents of those files to create two subject lookup vectors

tempfilepath <- grep('/subject_test\\.txt$', filepaths, value = TRUE)
subjecttest <- read.table(tempfilepath); subjecttest <- as.vector(subjecttest[,1])

tempfilepath <- grep('/subject_train\\.txt$', filepaths, value = TRUE)
subjecttrain <- read.table(tempfilepath)
subjecttrain <- as.vector(subjecttrain[,1])

# Identify the filepath corresponding to the "activity_labels.txt" file, which 
# provides the description for the activity being performed for each numeric 
# value of the "Y_test.txt" and the "Y_train.txt" files, then load the contents 
# of that file to create an activity label lookup vector

tempfilepath <- grep('/activity_labels\\.txt$', filepaths, value = TRUE)
activitylabels <- read.table(tempfilepath)
activitylabels <- as.vector(activitylabels[,2])

# Identify the filepath corresponding to the "y_test.txt" and "y_train.txt"
# files, which indicate the activity being performed for each row of the data 
# files, then load the contents of that file to create an activity lookup vector

tempfilepath <- grep('/y_test\\.txt$', filepaths, value = TRUE)
ytest <- read.table(tempfilepath); ytest <- as.vector(ytest[,1])

tempfilepath <- grep('/y_train\\.txt$', filepaths, value = TRUE)
ytrain <- read.table(tempfilepath); ytrain <- as.vector(ytrain[,1])

# (3. Uses descriptive activity names to name the activities in the data set)

# Replace the activities (currently represented by numbers) in the 'ytest' and
# 'ytrain' vectors with descriptive activity labels using the 'activitylabels'
# lookup vector. When combining the tidy test and train dataframes, an activity
# variable will be created which includes the descriptive activity labels.

ytest <- activitylabels[ytest]
ytrain <- activitylabels[ytrain]

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 1. Merges the training and the test sets to create one data set.

# Load the training and test data sets. The values are in scientific notation,
# so load the data as character strings before converting to numeric.

# NOTE: The inertial data do not have mean or standard deviation calculations,
# and we are eventually only interested in those values. Therefore, they are not
# read into R at any point in this script.

tempfilepath <- grep('/X_test\\.txt$', filepaths, value = TRUE)
xtest <- read.table(tempfilepath, colClasses = 'character')
xtest <- as.data.frame(lapply(xtest, as.numeric))

tempfilepath <- grep('/X_train\\.txt$', filepaths, value = TRUE)
xtrain <- read.table(tempfilepath, colClasses = 'character')
xtrain <- as.data.frame(lapply(xtrain, as.numeric))

# Build new 'tidy' dataframes for the xtest and xtrain dataframes.
# Add a new column 'subject' indicating the subject of each observation . 
# Also, add a 'activity' column indicating the activity being performed for each
# observation. Finally, add a 'set' column to the tidy dataframes indicating 
# whether each datapoint is a member of the test or train data set

# NOTE: I consider the 'wide' form of the dataframe, where each measured feature
# is a unique column, to be tidier than the 'tall' form of the dataframe, where
# each measured feature is placed on an individual row and different features
# are labeled by a single 'feature' column. I believe it is more reasonable to
# consider the unique observations (and therefore the rows) for this dataset to
# be each subject performing a specific activity (within either the test or 
# training dataset), and that the features (the columns) are the many 
# measurements made on those observations. I expect this format would be more
# useful to an end user calculating relationships among the features for each
# subject performing each activity, for example.



# 

library(dplyr)

xtesttidy <- mutate(xtest, 
                    subject = subjecttest,
                    activity = ytest,
                    set = 'test')

xtraintidy <- mutate(xtrain, 
                     subject = subjecttrain, 
                     activity = ytrain,
                     set = 'train')

# Combine both data frames to make the complete 'tidy' dataframe

combined <- bind_rows(xtesttidy, xtraintidy)

# Cleanup the workspace by removing (large) objects that are no longer needed

rm(xtest, xtesttidy, xtrain, xtraintidy)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 2. Extract only the measurements on the mean and standard deviation for each 
# measurement.



# Identify the features corresponding to the mean and standard deviation
# of every measurement within the features lookup vector (found by exactly 
# matching the string 'mean()' or 'std()', then subset the tidy data frame on 
# those columns, plus the 'subject', 'activity', and 'set' columns (which are 
# the last three columns of the combined data frame)

targetcolumns <- grep('*mean\\(\\)*|*std\\(\\)*', features)
end <- dim(combined)[2]
targetcolumns <- c(targetcolumns, (end-2):(end))
combined <- combined[, targetcolumns]

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



# 4. Appropriately labels the data set with descriptive variable names.

# Replace the targeted feature column names with the provided feature names,
# without replacing the last three column names ('subject, 'set', 'activity')

columnnames <- grep('*mean\\(\\)*|*std\\(\\)*', features, value = TRUE)
end <- dim(combined)[2]
colnames(combined)[1:(end-3)] <- columnnames

# Reorder the columns, starting with variables that have few unique values
# (set, subject, activity) before the remaining feature variables

# v1 and v2 grab the names of the feature variable that 'bookend' all of the 
# feature variables, to make it easier to move them to the back using select

v1 <- colnames(combined)[1]
v2 <- colnames(combined)[end-3]

combined <- select(combined, set, subject, activity, v1:v2)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 5. From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject. 
# Start by removing the 'set' column, then group by the 'activity' and 'subject' 
# columns, finally calculate mean values for each feature.

summarized <- combined %>%
        select(-set) %>%
        group_by(activity, subject) %>%
        summarize_all(mean)

# Change the names of the feature columns to reflect that they are calculated
# mean values.

columnnames <- paste0('MEAN-', columnnames)
end <- dim(summarized)[2]
colnames(summarized)[3:end] <- columnnames

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Create a text file of the 'summarized' data frame output (commented out by
# default)

# write.table(summarized, 'summarizedoutput.txt', row.names = FALSE)