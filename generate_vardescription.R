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
