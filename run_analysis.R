# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average 
# of each variable for each activity and each subject.

library(data.table)

# find feature columns with mean & std
setwd('UCI HAR Dataset')
features <- read.table('features.txt',stringsAsFactors = FALSE)
mean_cols <- grep("mean", features[,2])
std_cols <- grep("std", features[,2])
feature_cols = c(mean_cols,std_cols)

# read activity type labels
activities <- read.table('activity_labels.txt',stringsAsFactors = FALSE)
setwd('..')

# read training data
setwd('UCI HAR Dataset\\train')
train.subject <- read.table('subject_train.txt',col.names="subject")
train.X <- fread('X_train.txt',select=feature_cols, col.names=features[feature_cols,2])
train.y <- read.table('y_train.txt',col.names="activity")
train.y$activity <- factor(train.y$activity,levels=activities$V1,labels=activities$V2)
setwd('..\\..')
train <- cbind(train.subject,train.y,train.X)
rm(train.subject,train.y,train.X)

# read test data
setwd('UCI HAR Dataset\\test')
test.subject <- read.table('subject_test.txt',col.names="subject")
test.X <- fread('X_test.txt',select=feature_cols, col.names=features[feature_cols,2])
test.y <- read.table('y_test.txt',col.names="activity")
test.y$activity <- factor(test.y$activity,levels=activities$V1,labels=activities$V2)
setwd('..\\..')
test <- cbind(test.subject,test.y,test.X)
rm(test.subject,test.y,test.X)

data <- rbind(train,test)
rm(train,test)

# Create a second, independent tidy data set with the average of each variable 
# for each activity and each subject.
library(dplyr)
data2 <- group_by(data, subject, activity)
data2 <- summarize_each(data2, funs(mean))
write.csv(data2,"tidy_data.csv")
