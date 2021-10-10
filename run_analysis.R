# run analysis 
library(tidyverse)
library(dplyr)

#############################################
#Import train data
widths = rep(c(16), times = 561)

xTrain <- read.fwf("./train/X_train.txt", widths = widths, header = FALSE)
yTrain <- read.fwf("./train/y_train.txt", widths = c(1), header = FALSE, col.names=c("activity"))
subjectTrain <- read.fwf("./train/subject_train.txt", widths = c(1), header = FALSE, col.names=c("subject"))
train <- cbind(xTrain, yTrain)
trainAll <- cbind(train, subjectTrain)

#Import test data
xTest <- read.fwf("./test/X_test.txt", widths = widths, header = FALSE)
yTest <- read.fwf("./test/y_test.txt", widths = c(1), header = FALSE, col.names=c("activity"))
subjectTest <- read.fwf("./test/subject_test.txt", widths = c(1), header = FALSE, col.names=c("subject"))
test <- cbind(xTest, yTest)
testAll <- cbind(test, subjectTest)

#1. Merge train and test data
all <- trainAll %>% add_row(testAll)

#####################################
#2. Extracts only the measurements on the mean and standard deviation
features <- read.csv("./features.txt", sep=" ", header=FALSE)
logVector <- grepl("mean|std", features$V2)
searched_features <- features %>% mutate(flag = logVector) %>% filter(flag==TRUE)
#get the first column of the filtered mean std data set
mean_std_index <- as.integer(searched_features$V1)
activity_index <- grep("activity", colnames(all))
subject_index <- grep("subject", colnames(all))
col_indice <- c(mean_std_index, activity_index, subject_index)

#get mean and std with activity and subject column
extraction <- all[, col_indice]

####################################
#3. Uses descriptive activity names to name the activities in the data set
activities <- read.csv("./activity_labels.txt", sep=" ", header=FALSE)
colnames(activities) <- c("activity_id", "activity_label")
merged_data <- merge(extraction, activities, by.x="activity", by.y="activity_id", all=TRUE)
labeled_data <- merged_data[, -c(1)]

#####################################
#4.  labels the data set with descriptive variable names. 
feature_names <- searched_features$V2
all_col_names <- c(feature_names, "subject", "activity_label")
colnames(labeled_data) = all_col_names

######################################
#5. creates a second, independent tidy data set with the average of each variable for each activity and each subject
avg_data <- aggregate(labeled_data, list(labeled_data$activity_label, labeled_data$subject), mean)
# remove the last two column "subject" and "activity_label"
tidy_data <- avg_data[, -c(82, 83)]
# rename col names
result_data <- tidy_data %>% rename(Activity = Group.1, Subject = Group.2)
#output data with write.table() using row.names=FALSE
write.table(result_data, "./avg_data_by_activity_and_subject.txt", row.names=FALSE)

