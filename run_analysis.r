###############################################################################
## Date: 2016-05-16
## Course: Johns Hopkins Getting and Cleaning Data
## Week: 4
## Assignment: "Getting and Cleaning Data Course Project" 
## 
## INSTRUCTIONS
## You should create one R script called run_analysis.R that does the following.
##
## 1.Merges the training and the test sets to create one data set.
##
## 2.Extracts only the measurements on the mean and standard deviation 
## for each measurement.
##
## 3.Uses descriptive activity names to name the activities in the data set
##
## 4.Appropriately labels the data set with descriptive variable names.
##
## 5.From the data set in step 4, creates a second, independent tidy data 
## set with the average of each variable for each activity and each subject.
###############################################################################

library(regexr)
library(plyr)

###############################################################################
##  Check working directory & data existence                                                           
###############################################################################

## Set Working Directory
working_directory <- "/Users/wpage6/Documents/MyRFolder/Course3/GettingAndCleaningDataProject"

if(getwd() != working_directory) {
setwd(working_directory)
}

## file url to download
url1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

## Set/check this file name locally in the working directory
destfile1 <- "UCI_HAR_Dataset.zip"

## We don't want to download the same thing over and over again. check a file in that dataset to see if it exists
if(!file.exists("UCI HAR Dataset/features.txt")) {
  download.file(url = url1,destfile = destfile1, method = "curl")
  unzip(destfile1)
  }

###############################################################################
##  Data Merging                                                             
###############################################################################
## Pull column names for subject_test and subject_train from features.csv
featurestable <-read.table("UCI HAR Dataset/features.txt")
column_names <- as.character(featurestable$V2)

## read y_train.txt & y_test.txt then decode and add column w decoded values. transform before rbind
## codes from activity_labels.txt.. easier to hard code w/ only 6
code_type <-  c(WALKING = 1
               ,WALKING_UPSTAIRS = 2
               ,WALKING_DOWNSTAIRS = 3
               ,SITTING = 4
               ,STANDING = 5
               ,LAYING = 6)

##Combining test data with subject & activity
## Read the test data
testData <- read.table("UCI HAR Dataset/test/X_test.txt",header = FALSE, col.names = column_names)

## read and attach column for subjectId from txt file.. 
subjectId_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
testData$subjectId <- as.factor(subjectId_test$V1)

##add decoded activity names to the dataset
test_code <- read.table("UCI HAR Dataset/test/y_test.txt")
test_code$activity <- names(code_type)[match(test_code$V1,code_type)]
testData$activity <- as.factor(test_code$activity)


## Combining train data with subject & activity
## Read the train data
trainData <- read.table("UCI HAR Dataset/train/X_train.txt",header = FALSE, col.names = column_names)

## read and attach column for subjectId from txt file..
subjectId_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
trainData$subjectId <- as.factor(subjectId_train$V1)

##add decoded activity names to the dataset
train_code <- read.table("UCI HAR Dataset/train/y_train.txt")
train_code$activity <- names(code_type)[match(train_code$V1,code_type)]
trainData$activity <- as.factor(train_code$activity)

## rbind to create one data set 
completeData <- rbind(testData,trainData)


###############################################################################
## Data Cleansing 
###############################################################################

## get only columns w/ mean or std. added [^fF] to get rid of meanFreq(). 
## also added activity and subject id to make sure those don't get left out
x <- grep("mean[^fF]|.std|activity|subjectId",colnames(completeData))
filteredData <- completeData[,x]

## Clean up column names
names(filteredData) <- gsub(".std", "_StandardDeviation",names(filteredData))
names(filteredData) <- gsub(".mean", "_Mean",names(filteredData))
names(filteredData) <- gsub(".X","_X",names(filteredData))
names(filteredData) <- gsub(".Y", "_Y",names(filteredData))
names(filteredData) <- gsub(".Z", "_Z",names(filteredData))
##find all the remaining periods and replace with blank
names(filteredData) <- gsub("\\.", "",names(filteredData))

## Returns clean data
print(filteredData)

###############################################################################
## Data Summation 
###############################################################################
## use ddply to subset and get means of columns 1 through 66. 
##Don't want columns 67 and 68 because those are our subset factors
aggregateData <- ddply(filteredData, .(activity, subjectId), function(x) colMeans(x[, 1:66]))

##convert activity and subjectid to char and numeric respectively to ensure order works correctly
aggregateData$activity <- as.character(aggregateData$activity)
aggregateData$subjectId <- as.numeric(aggregateData$subjectId)

## write ordered, aggregated data to csv file in working directory
write.csv(aggregateData[order(aggregateData$subjectId,aggregateData$activity),],"aggregateData.csv",row.names = FALSE)
