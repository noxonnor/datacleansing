## You should create one R script called run_analysis.R that does the following. 
##
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(reshape2)

## URL where file is stored
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
## If zip hasn't been downloaded, please download and unzip it. 
if (xor(!file.exists("./dataset.zip"),!file.exists("./UCI HAR Dataset"))){
  if (!file.exists("./dataset.zip")){
  download.file(fileUrl,destfile="./dataset.zip", method="curl")
  }
  unzip("./dataset.zip", files = NULL, list = FALSE, overwrite = TRUE,
        junkpaths = FALSE, exdir = ".", unzip = "internal",
        setTimes = FALSE)
}

## Read Datasets

trainx<-read.table("./UCI HAR Dataset/train/X_train.txt")
trainy<-read.table("./UCI HAR Dataset/train/Y_train.txt")
trainsub<-read.table("./UCI HAR Dataset/train/subject_train.txt")

testx<-read.table("./UCI HAR Dataset/test/X_test.txt")
testy<-read.table("./UCI HAR Dataset/test/Y_test.txt")
testsub<-read.table("./UCI HAR Dataset/test/subject_test.txt")

## Read features (column headers) and activity labels into tables
features = read.table("UCI HAR Dataset/features.txt")
labels = read.table("UCI HAR Dataset/activity_labels.txt")
names(labels)<-c('ActivityID','ActivityName')

## Clean features names to prepare for apply
features[,2]<-gsub('-mean', 'Mean', features[,2])
features[,2]<-gsub('-std', 'Std', features[,2])
features[,2]<-gsub(',', '_', features[,2])
features[,2]<-gsub('[-()]','', features[,2])
features_names <-features[,2]

## Rename columns in training and test datasets, and add activity label name from activity label file
names(trainx)=features_names
names(testx)=features_names
names(trainy)=c('ActivityID')
trainy<-merge(trainy,labels,by='ActivityID')
names(testy)=c('ActivityID')
testy<-merge(testy,labels,by='ActivityID')
names(trainsub)=c('SubjectID')
names(testsub)=c('SubjectID')


## Merges the training and test data sets to create one complete data set
train <- cbind(trainsub, trainy, trainx)
test <- cbind(testsub, testy,testx)
complete_data <- rbind(train,test)

## Extract only mean() and std() features
required_features <- grepl("Mean",features_names) | grepl("Std",features_names )
required_features <- c(TRUE,TRUE,TRUE,required_features)
required_data <- complete_data[, required_features]

## Calculate mean
meltedData <- melt(required_data,id=c("ActivityID","ActivityName","SubjectID"))
result <- dcast(meltedData, SubjectID + ActivityName + ActivityID ~ variable, mean)

## Write Tidy
write.table(result, "tidy-data-set.txt", row.names=FALSE)