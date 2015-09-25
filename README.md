# Getting and Cleaning Data Project
Getting and Cleaning Data course project at Coursera.org

##How does the run_analysis.R work?

File is organized using function and global varibles (which is a kind of a bad thing). That is why the scoping assignment `<<-` operator is used a lot. The double arrow operator can modify variables in parent levels, in my case it means the 'global' file rather the function body.

Some parts of code may produce a debug messages using the `message` function.

###Functions

Program flow is set below the functions and calls them one by one. The only part outside the function is assignment #5 at the end of the file and filtering for part #2. Function are then calld in order. 

####DownloadDataIfMissing()
Download data from Coursera if file is missing and unzip it into the workdir. Will create a `UCI HAR Dataset` directory with raw files if the data is missing.

####LoadFilesToDt()
Load files to global tables using the special assignment operator `<<-`. Because those variables doesn't exist inside the function or at the parent level they will be created inside the global environment.

Following data frames are created from corresponding files: 

- dt.activityLables
- dt.features
- dt.test.x
- dt.test.y
- dt.subject.test
- dt.train.x
- dt.train.y
- dt.subject.train

####AssignNamesToDt()
Assign names to data frames from `LoadFilesToDt()` according to data inside the files. This is a pre-step for later naming functions, column names are kept during the merge and it's easier to name them early. Following column names are set for train and test data frames:

- activityLables
- subjectId
- features
- activityType

####MergeTablesToOne()
Merge all data frames from into a single table. Temporary frames are created:
`dt.merged.subject, dt.merged.x, dt.merged.y.
Data frames are first merged by the test/train values and then by the axis (x, y).
After that, the temporary frames are merged together into one big dataframe `dataAll`. Frame size is printed just for fun (appr. 42Mb)

####SetDescriptiveActivityNames()
Convert activity names from factors to text. Uses `dataFiltered` frame created before which consist of filtered columns of mean and std of the `dataAll` frame. 

Uses activity labels from `activity_labels.txt` to convert activity as int factor to activity as string factior. In other words `2` to `WALKING_UPSTAIRS. Simple for-loop.

####After the functions
Average of each variable for each activity and each subject is calculated and written into the `tidydata.txt` file.
All temporary and original sets are removed before the `SetDescriptiveLabels()`.

####SetDescriptiveLabels()
Appropriately labels the data set with descriptive variable names.
Uses `gsub` (regular expressions) to rename columns to decent names.

- `t` to `Time`
- `Acc` to `Accelerometer`

and so on.

##How to run run_analysis.R?

1. Current working directory should be changed inside the run_analysis.R file and must exist.
2. Package **reshape2** must be installed.
3. **UCI HAR Dataset.zip** may be missing or not extracted. In such case the file will be downloaded and unzipped. `dataDir` var can be changed to point to another directory for data. Also, required file names are set as file.* parameters and can be changed in case file is moved.
4. File can be sourced and runned as:
    `source("run_analysis.R")`

##Result
The results (tidy data) are saved into the file `tidydata.txt`.
File consists of 180x81 data table with header names, but without row numbers. Space is used as the separator.

#License:
Use of this dataset in publications must be acknowledged by referencing the following publication: 


1. Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.