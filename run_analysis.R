library(dplyr)

### Reading feature labels and activity labels and row IDs
features <- read.csv("../UCI_HAR_Dataset/features.txt", sep = " ", 
                     header = FALSE)
features[,2] <- as.character(features[,2])
attributeids <- c(grep("mean()", features[,2]), grep("std()", features[,2]))
features[,2] <- gsub("-", "_", features[,2])
features[,2] <- gsub("\\()", "", features[,2])
activitylabels <- read.csv("../UCI_HAR_Dataset/activity_labels.txt", sep = " ", 
                           header = FALSE)

### Reading activity ids and subject ids
## Test data set
testactivityids <- as.numeric(readLines("../UCI_HAR_Dataset/test/y_test.txt"))
testsubjectids <- as.numeric(readLines("../UCI_HAR_Dataset/test/subject_test.txt"))
rawtestdata <- read.table("../UCI_HAR_Dataset/test/X_test.txt", header = FALSE)
names(rawtestdata) <- features[,2]
testdata <- rawtestdata[, attributeids]
rm(rawtestdata)
testdata$activity <- activitylabels[testactivityids,2]
testdata$subject <- testsubjectids
## Training data set
trainactivityids <- as.numeric(readLines("../UCI_HAR_Dataset/train/y_train.txt"))
trainsubjectids <- as.numeric(readLines("../UCI_HAR_Dataset/train/subject_train.txt"))
rawtraindata <- read.table("../UCI_HAR_Dataset/train/X_train.txt", header = FALSE)
names(rawtraindata) <- features[,2]
traindata <- rawtraindata[, attributeids]
rm(rawtraindata)
traindata$activity <- activitylabels[trainactivityids,2]
traindata$subject <- trainsubjectids

### Merging the data vertically
combodata <- rbind(traindata, testdata)
combodata <- arrange(combodata, subject, activity)

### Finding means for each subject and each activity
by_subject_activity <- group_by(combodata, subject, activity)
means_summary <- summarise_each(by_subject_activity, funs(mean))

### Write the final tidy data frame into a file
write.table(means_summary, file = "tidy_data.txt", row.names = FALSE)

