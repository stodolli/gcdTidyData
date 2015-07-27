### Feature Selection - original data

---

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc\_XYZ and tGyro\_XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc\_XYZ and tGravityAcc\_XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk\_XYZ and tBodyGyroJerk\_XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc\\_XYZ, fBodyAccJerk\_XYZ, fBodyGyro\_XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'\_XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

- tBodyAcc_XYZ
- tGravityAcc_XYZ
- tBodyAccJerk_XYZ
- tBodyGyro_XYZ
- tBodyGyroJerk_XYZ
- tBodyAccMag
- tGravityAccMag
- tBodyAccJerkMag
- tBodyGyroMag
- tBodyGyroJerkMag
- fBodyAcc_XYZ
- fBodyAccJerk_XYZ
- fBodyGyro_XYZ
- fBodyAccMag
- fBodyAccJerkMag
- fBodyGyroMag
- fBodyGyroJerkMag

   
The set of variables that were estimated from these signals are:

- mean: Mean value
- std: Standard deviation

---

The original data on the variables consist of time series readings/estimates for each of the subjects (1-30) for each activity:

1. Walking
2. Walking upstairs
3. Walking downstairs
4. Sitting
5. Standing
6. Laying

---

### Data processing

---

The order of steps performed in the analysis is slightly different from the steps listed in the requirements.  

* We start by reading in the feature labels and the activity ID labels provided in the data set.
```
library(dplyr)
features <- read.csv("../UCI_HAR_Dataset/features.txt", sep = " ", header = FALSE)
features[,2] <- as.character(features[,2])
activitylabels <- read.csv("../UCI_HAR_Dataset/activity_labels.txt", sep = " ", header = FALSE)
```
From the original features, only the mean and standard deviation variables will selected - `mean()` and `std()`. The selected variables names were also changed a little bit to look less technical.
```
attributeids <- c(grep("mean()", features[,2]), grep("std()", features[,2]))
features[,2] <- gsub("-", "_", features[,2])
features[,2] <- gsub("\\()", "", features[,2])
```

* The next step was to read in the time series data for the selected variables (mean and std) from both the test set and the training set. The names of the variables for the imported data frames were also changed to reflect the change from above.
```
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
```

* The two data sets were then merged and ordered by subject and by activity.
```
combodata <- rbind(traindata, testdata)
combodata <- arrange(combodata, subject, activity)
```

* This made it easier to perform the last step of the analysis, which was creating a new data frame, consisting of the means of each of the variables over the time series, for each subject, for each activity. The new data frame was written to the file `tidy_data.txt`.
```
by_subject_activity <- group_by(combodata, subject, activity)
means_summary <- summarise_each(by_subject_activity, funs(mean))
write.table(means_summary, file = "tidy_data.txt", row.names = FALSE)
```

* Lastly, the R script `generate_vardescription.R` creates a text file `tidy_features.txt` which contains a list of all the variable names included in the final tidy data set. This was useful to copy and paste at the end of this CodeBook file. Before copying and pasting, however, one more preprocessing step was necessary and performed in Vim inside the terminal (linux), in order for the text to be a numbered list and follow the Markdown syntax:
```
:%s/ /. /g
:%s/_/\\_/g
```

---

### After processing - `tidy_data.txt`

---

Each row (180 tota) in the tidy data set represents one subject (30 total) and one activity (6 total). Each column, besides the subject number and the activity label (first 2 columns), represents a time series average for that particular variable. The complete list of variables (79) in the tidy data is:

1. tBodyAcc\_mean\_X
2. tBodyAcc\_mean\_Y
3. tBodyAcc\_mean\_Z
4. tGravityAcc\_mean\_X
5. tGravityAcc\_mean\_Y
6. tGravityAcc\_mean\_Z
7. tBodyAccJerk\_mean\_X
8. tBodyAccJerk\_mean\_Y
9. tBodyAccJerk\_mean\_Z
10. tBodyGyro\_mean\_X
11. tBodyGyro\_mean\_Y
12. tBodyGyro\_mean\_Z
13. tBodyGyroJerk\_mean\_X
14. tBodyGyroJerk\_mean\_Y
15. tBodyGyroJerk\_mean\_Z
16. tBodyAccMag\_mean
17. tGravityAccMag\_mean
18. tBodyAccJerkMag\_mean
19. tBodyGyroMag\_mean
20. tBodyGyroJerkMag\_mean
21. fBodyAcc\_mean\_X
22. fBodyAcc\_mean\_Y
23. fBodyAcc\_mean\_Z
24. fBodyAcc\_meanFreq\_X
25. fBodyAcc\_meanFreq\_Y
26. fBodyAcc\_meanFreq\_Z
27. fBodyAccJerk\_mean\_X
28. fBodyAccJerk\_mean\_Y
29. fBodyAccJerk\_mean\_Z
30. fBodyAccJerk\_meanFreq\_X
31. fBodyAccJerk\_meanFreq\_Y
32. fBodyAccJerk\_meanFreq\_Z
33. fBodyGyro\_mean\_X
34. fBodyGyro\_mean\_Y
35. fBodyGyro\_mean\_Z
36. fBodyGyro\_meanFreq\_X
37. fBodyGyro\_meanFreq\_Y
38. fBodyGyro\_meanFreq\_Z
39. fBodyAccMag\_mean
40. fBodyAccMag\_meanFreq
41. fBodyBodyAccJerkMag\_mean
42. fBodyBodyAccJerkMag\_meanFreq
43. fBodyBodyGyroMag\_mean
44. fBodyBodyGyroMag\_meanFreq
45. fBodyBodyGyroJerkMag\_mean
46. fBodyBodyGyroJerkMag\_meanFreq
47. tBodyAcc\_std\_X
48. tBodyAcc\_std\_Y
49. tBodyAcc\_std\_Z
50. tGravityAcc\_std\_X
51. tGravityAcc\_std\_Y
52. tGravityAcc\_std\_Z
53. tBodyAccJerk\_std\_X
54. tBodyAccJerk\_std\_Y
55. tBodyAccJerk\_std\_Z
56. tBodyGyro\_std\_X
57. tBodyGyro\_std\_Y
58. tBodyGyro\_std\_Z
59. tBodyGyroJerk\_std\_X
60. tBodyGyroJerk\_std\_Y
61. tBodyGyroJerk\_std\_Z
62. tBodyAccMag\_std
63. tGravityAccMag\_std
64. tBodyAccJerkMag\_std
65. tBodyGyroMag\_std
66. tBodyGyroJerkMag\_std
67. fBodyAcc\_std\_X
68. fBodyAcc\_std\_Y
69. fBodyAcc\_std\_Z
70. fBodyAccJerk\_std\_X
71. fBodyAccJerk\_std\_Y
72. fBodyAccJerk\_std\_Z
73. fBodyGyro\_std\_X
74. fBodyGyro\_std\_Y
75. fBodyGyro\_std\_Z
76. fBodyAccMag\_std
77. fBodyBodyAccJerkMag\_std
78. fBodyBodyGyroMag\_std
79. fBodyBodyGyroJerkMag\_std
