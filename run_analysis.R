setwd("~/R Projects/Coursera/3 - Getting and Cleaning Data/Getting and Cleaning Data Course Project")

dataDir <- "UCI HAR Dataset"

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
  
  # If dir doesn't exist - unzip.
  if (!file.exists(dataDir)){
    message("Unzipping...")
    unzip(fileName)  
  }
}

