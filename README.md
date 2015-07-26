[1]: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

# GCD - TidyData

#### Getting and Cleaning Data Course Project  
In this project we have used the data collected from the accelerometers from the Samsung Galaxy S smartphone, which was obtained from the [UCI Machine Learning Repository website][1]. The original data has been cleaned up and summarized in a way that is further described in the CodeBook file. In this repository you will find:  
1. R scripts performing the analysis  
2. A tidy data file generated from the original data  
3. CodeBook file describing the analysis and the variables included in the tidy data set  


### R scripts
* run_analysis.R - Reads the data and generates the tidy data set file
* generate_vardescription.R - Creates a text file with the variable decriptions to be used for the CodeBook.md file

### Tidy data
* tidy_data.txt - The tidy data set printed with the `write.table()` function

### CodeBook
* CodeBook.md - Describes the variables, the data, and the work that was performed to clean up the original data

