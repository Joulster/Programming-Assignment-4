#Download file from data source
if(!file.exists("./data")){dir.create("./data")}
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = "./data/UCIMLDataset.zip")
#Unzip file into a local directory
unzip(zipfile = "./data/UCIMLDataset.zip",exdir = "./data") 
# Read test & train datasets into R
x_test <- read.delim("./data/UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE)
y_test <- read.delim("./data/UCI HAR Dataset/test/y_test.txt", sep = "", header = FALSE)
subject_test <- read.delim("./data/UCI HAR Dataset/test/subject_test.txt", sep = "", header = FALSE)
x_train <- read.delim("./data/UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE)
y_train <- read.delim("./data/UCI HAR Dataset/train/y_train.txt", sep = "", header = FALSE)
subject_train <- read.delim("./data/UCI HAR Dataset/train/subject_train.txt", sep = "", header = FALSE)
# Read features and activity labels into R to define column names
features <- read.delim("./data/UCI HAR Dataset/features.txt", sep = "", header = FALSE)
activity_labels <- read.delim("./data/UCI HAR Dataset/activity_labels.txt", sep = "", header = FALSE)
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
feature_meansd <- grep("subject_id|activity_id|mean\\()|std\\()",columnnames)
library(dplyr)
meanstdset <- combined_set[,feature_meansd]
meanstdset <- merge(meanstdset,activity_labels,by = "activity_id", all = TRUE)
meanstdset <- meanstdset %>% select(-activity_id) %>% select(subject_id,activity_name,everything()) #Re-Ordering set and removing activityID variable

#renaming variables with descriptive values
names(meanstdset) <- gsub("^t","time",names(meanstdset))
names(meanstdset) <- gsub("^f","frequency",names(meanstdset))
names(meanstdset) <- gsub("Acc","Acceleration",names(meanstdset))
names(meanstdset) <- gsub("Gyro","Gyroscope",names(meanstdset))
names(meanstdset) <- gsub("Mag","Magnitude",names(meanstdset))
library(tidyr)
#Group the data by Subject and Activity, further create a tidy dataset with average of each variable for each of the subject and activity
summarized_set <- meanstdset %>% group_by(subject_id,activity_name) %>% summarize_all(mean)
write.table(summarized_set,"tidyset.txt",row.names = FALSE)