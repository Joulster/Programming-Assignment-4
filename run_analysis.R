filepath <- file.path(getwd(),"R","Test Material","PA 4") # Directory where dataset is downloaded, unzipped and saved
setwd(filepath) # Set WD to appropriate location  
# Read test & train datasets into R
x_test <- read.delim("./UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE)
y_test <- read.delim("./UCI HAR Dataset/test/y_test.txt", sep = "", header = FALSE)
subject_test <- read.delim("./UCI HAR Dataset/test/subject_test.txt", sep = "", header = FALSE)
x_train <- read.delim("./UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE)
y_train <- read.delim("./UCI HAR Dataset/train/y_train.txt", sep = "", header = FALSE)
subject_train <- read.delim("./UCI HAR Dataset/train/subject_train.txt", sep = "", header = FALSE)
# Read features and activity labels into R to define column names
features <- read.delim("./UCI HAR Dataset/features.txt", sep = "", header = FALSE)
activity_labels <- read.delim("./UCI HAR Dataset/activity_labels.txt", sep = "", header = FALSE)
names(activity_labels) <- c("activity_id","activity_name")
#merge activity and corresponding dataset
combined_trainset <- cbind(subject_train,y_train,x_train)
combined_testset <- cbind(subject_test,y_test,x_test)
#set column names
names(combined_trainset) <- c("subject_id","activity_id",as.character(features$V2))
names(combined_testset) <- c("subject_id","activity_id",as.character(features$V2))
#merge train and test sets
combined_set <- rbind(combined_trainset,combined_testset)
#extract column names of combined set to subset mean and std dev values
columnnames <- names(combined_set)
feature_meansd <- grep("mean\\()|std\\()",columnnames)
meanstdset <- combined_set[,1&2&feature_meansd]
meanstdset <- merge(meanstdset,activity_labels,by = "activity_id", all = TRUE)
library(dplyr)
meanstdset <- meanstdset %>% select(subject_id,activity_name,3:563) #Re-Ordering set and removing activityID variable
library(tidyr)

