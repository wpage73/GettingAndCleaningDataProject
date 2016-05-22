# GettingAndCleaningDataProject ReadMe file

Date: 2016-05-16
Course: Johns Hopkins Getting and Cleaning Data
Week: 4
Assignment: "Getting and Cleaning Data Course Project" 

## This file explains the analysis

Steps taken in the r_analysis.R file

1. Set working directory (lines 26-36)
2. Download zip file from internet (lines 37-47)
3. Pull column names for subject_test and subject_train from features.csv (lines 52-54)
4.  read y_train.txt & y_test.txt then decode and add column w decoded values. (lines 56-63)
5. Read test data into R and combine test data with subject & activity (lines 65-76)
6. Read train data into R and combine test data with subject & activity (lines 79-90)
7. Use rbind function to combine the test and train datasets into 1 dataframe (lines 92-93)
8. Get only columns w/ mean or std. added [^fF] to get rid of meanFreq() using regular expression. Also added activity and subject id to regular expression to make sure those don't get left out (lines 100-103)
9. Clean up column names (lines 105-112)
10. Print clean data on screen (lines 114-115)
11. Summarize columns by getting mean and send that data to a csv called aggregateData.csv (lines 117-129)

##Required Libraries
1. regexr
2. plyr

##Requirements

You should create one R script called run_analysis.R that does the following.

 1.Merges the training and the test sets to create one data set.

 2.Extracts only the measurements on the mean and standard deviation 
 for each measurement.

 3.Uses descriptive activity names to name the activities in the data set

 4.Appropriately labels the data set with descriptive variable names.

 5.From the data set in step 4, creates a second, independent tidy data 
 set with the average of each variable for each activity and each subject.

##Review Criteria

1. The submitted data set is tidy.

2. The Github repo contains the required scripts.

3. GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.

4. The README that explains the analysis files is clear and understandable.

5. The work submitted for this project is the work of the student who submitted it.