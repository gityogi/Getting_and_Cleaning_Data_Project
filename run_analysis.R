library(reshape2)

# Clena workspace.
rm(list=ls())

# Set dir.
setwd("~/R Projects/Coursera/3 - Getting and Cleaning Data/Getting and Cleaning Data Course Project")

# Files and folders.
dataDir <- "UCI HAR Dataset"

# Main dir.
file.activity_labels <- "activity_labels.txt"
file.features <- "features.txt"
file.features <- "features.txt"

# Test dir. 
file.test.subject <- "test/subject_test.txt" 
file.test.x <- "test/X_test.txt" 
file.test.y <- "test/y_test.txt" 

# Train dir.
file.train.subject <- "train/subject_train.txt" 
file.train.x <- "train/X_train.txt" 
file.train.y <- "train/y_train.txt" 


# Download data from Coursera if file is missing and unzip it into the workdir.
DownloadDataIfMissing <- function(){

  # Filename to check.
  fileName <- "UCI HAR Dataset.zip"

  # If missing - download.
  if (!file.exists(fileName)){
    message("Data is missing, downloading from Coursera into: ", getwd())
    
    # Donload.
    url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(url, fileName) # Don't use curl on Windows.
  }
  
  # TODO: use dir.exists.
  # If dir doesn't exist - unzip.
  if (!file.exists(dataDir)){
    message("Unzipping...")
    unzip(fileName)  
  }
}

# Load files to global tables using the special assignment operator '<<-'.
LoadFilesToDt <- function(){

  # Load all data.
  
  # Main dir.
  dt.activityLables <<- read.table(file.path(dataDir, file.activity_labels), header=FALSE) 
  dt.features <<- read.table(file.path(dataDir, file.features), header=FALSE)  
  
  # Test dir.
  dt.test.x <<- read.table(file.path(dataDir, file.test.x), header=FALSE)  
  dt.test.y <<- read.table(file.path(dataDir, file.test.y), header=FALSE)
  dt.subject.test <<- read.table(file.path(dataDir, file.test.subject), header=FALSE)
  
  # Train dir.
  dt.train.x <<- read.table(file.path(dataDir, file.train.x), header=FALSE) 
  dt.train.y <<- read.table(file.path(dataDir, file.train.y), header=FALSE) 
  dt.subject.train <<- read.table(file.path(dataDir, file.train.subject), header=FALSE) 
}

# Assign names to dt's according to files.
AssignNamesToDt <- function(){
  # Links the class labels with their activity name.
  colnames(dt.activityLables) <<- c('activityId','activityType');
  
  # the subject who performed the activity for each window sample. 
  # Its range is from 1 to 30.
  colnames(dt.subject.train) <<- "subjectId";
  colnames(dt.subject.test) <<- "subjectId";
  
  # Feaures.
  colnames(dt.train.x) <<- dt.features[,2]
  colnames(dt.test.x) <<- dt.features[,2];
  
  # Assign Y names. activity label.
  colnames(dt.train.y) <<- "activityType";
  colnames(dt.test.y) <<- "activityType";
}

# Merge all sets to a single table.
MergeTablesToOne <- function(){
  # 1.Merges the training and the test sets to create one data set.
  dt.merged.subject <<- rbind(dt.subject.test, dt.subject.train)
  dt.merged.x <<- rbind(dt.train.x, dt.test.x)
  dt.merged.y <<- rbind(dt.train.y, dt.test.y) 
  
  # Merge all datasets by rows. 
  dataAll <<- cbind(dt.merged.subject, dt.merged.y, dt.merged.x) 
  
  # For private use.
  data.size <<- object.size(dataAll)                 
  data.size <<- format(data.size, quote = FALSE, units = "MB") # Appr. 42Mb.
  message("Merged table size = ", data.size)
}

# Convert activity names from factors to text.
SetDescriptiveActivityNames <- function(){
  # Both class() are factors, but can't use <- because they are different factors
  # and simple assignment will prduce error "invalid factor level, NA generated".
  # So must cast both sides to char, assign and then cast back.
  dataFiltered$activityType <<- as.character(dataFiltered$activityType)
  
  # Loop every activity and replace with its descrition.
  for(i in 1:6)
    dataFiltered$activityType[dataFiltered$activityType == i] <<- as.character(dt.activityLables$activityType[i])
  
  dataFiltered$activityType <<- as.factor(dataFiltered$activityType) # cast back.  
}

# Convert activity names from factors to text.
SetDescriptiveLabels <- function(){
  # gsub() replaces all instances of the pattern in each column name.
  # http://www.cookbook-r.com/Manipulating_data/Renaming_columns_in_a_data_frame/
  # From features.txt. There is probably a better way.
  
  names(dataFiltered) <<- gsub("Acc", "Accelerometer", names(dataFiltered), ignore.case = TRUE)
  names(dataFiltered) <<- gsub("Gyro", "Gyroscope", names(dataFiltered), ignore.case = TRUE)
  names(dataFiltered) <<- gsub("Mag", "Magnitude", names(dataFiltered), ignore.case = TRUE)
  names(dataFiltered) <<- gsub("^t", "Time", names(dataFiltered), ignore.case = TRUE)
  names(dataFiltered) <<- gsub("^f", "Frequency", names(dataFiltered), ignore.case = TRUE)
  names(dataFiltered) <<- gsub("tBody", "TimeBody", names(dataFiltered), ignore.case = TRUE)
  names(dataFiltered) <<- gsub("-mean()", "Mean", names(dataFiltered), ignore.case = TRUE)
  names(dataFiltered) <<- gsub("-std()", "STD", names(dataFiltered), ignore.case = TRUE)
  names(dataFiltered) <<- gsub("-freq()", "Frequency", names(dataFiltered), ignore.case = TRUE)
  names(dataFiltered) <<- gsub("angle", "Angle", names(dataFiltered), ignore.case = TRUE)
  names(dataFiltered) <<- gsub("gravity", "Gravity", names(dataFiltered), ignore.case = TRUE)  
}

# -----------------------------------------------------------------------------
# Run here. Order of execution MAY be important.
# -----------------------------------------------------------------------------

# Download the set into current workdir.
DownloadDataIfMissing()

# Load data into the GLOBAL tables.
LoadFilesToDt()

# 3.Uses descriptive activity names to name the activities in the data set.
# Names are following during the merge @ 1.
AssignNamesToDt()

# 1.Merges the training and the test sets to create one data set.
MergeTablesToOne()

# 2.Extracts only the measurements on the mean and standard deviation for 
# each measurement. Id's must stay.
dataFiltered  <- dataAll[,grepl("mean|std|subjectId|activityType", names(dataAll))]

# 3.Uses descriptive activity names to name the activities in the data set.
SetDescriptiveActivityNames()

# Can now remove original tables and save some memory.
rm(dt.activityLables, dt.features)
rm(dt.test.x, dt.test.y, dt.subject.test)
rm(dt.train.x, dt.train.y, dt.subject.train)
rm(dt.merged.subject, dt.merged.x, dt.merged.y)

#4. Appropriately labels the data set with descriptive variable names
SetDescriptiveLabels()

# 5.From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.

dataFiltered$subjectId <- as.factor(dataFiltered$subjectId)
tidyData <- aggregate(. ~subjectId + activityType, dataFiltered, mean)

write.table(tidyData, file = "tidydata.txt", row.names = FALSE)
