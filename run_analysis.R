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
  dt.activityLables <<- read.table(file.path(dataDir, file.activity_labels)) 
  dt.features <<- read.table(file.path(dataDir, file.features))  
  
  # Test dir.
  dt.test.x <<- read.table(file.path(dataDir, file.test.x))  
  dt.test.y <<- read.table(file.path(dataDir, file.test.y))
  dt.subject.test <<- read.table(file.path(dataDir, file.test.subject))
  
  # Train dir.
  dt.train.x <<- read.table(file.path(dataDir, file.train.x)) 
  dt.train.y <<- read.table(file.path(dataDir, file.train.y)) 
  dt.subject.train <<- read.table(file.path(dataDir, file.train.subject)) 
}

# Run here.
DownloadDataIfMissing()
LoadFilesToDt()


