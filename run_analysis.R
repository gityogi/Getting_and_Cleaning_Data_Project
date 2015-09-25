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


# Download data from COursera if file is missing and unzip it into the workdir.
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
}

# Run here. Order of execution MAY be important,
DownloadDataIfMissing()
LoadFilesToDt() # Now everithing is in global.

# 3.Uses descriptive activity names to name the activities in the data set.
# Names are following during the merge @ 1.
AssignNamesToDt() # New names.

# 1.Merges the training and the test sets to create one data set.
dt.merged.subject <- rbind(dt.subject.test, dt.subject.train)
dt.merged.x <- rbind(dt.train.x, dt.test.x)
dt.merged.y <- rbind(dt.train.y, dt.test.y) 

# Merge all datasets by rows. 
data <- cbind(dt.merged.subject, dt.merged.y, dt.merged.x) 

# For private use.
data.size <- object.size(data)                 
data.size <- format(data.size, quote = FALSE, units = "MB") # Appr. 42Mb.
message("Merged table size = ", data.size)
