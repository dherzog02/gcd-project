consolidate <- function()
{
  # I assume that the working directory contains a subdirectory called "UCI HAR Dataset"
  # and the subdirectories and files from the original data download. 
  # First I check if the all the files required during the script are there:
  filelist <- c("UCI HAR Dataset/features.txt",
                "UCI HAR Dataset/train/subject_train.txt",
                "UCI HAR Dataset/train/y_train.txt",
                "UCI HAR Dataset/train/X_train.txt",
                "UCI HAR Dataset/test/subject_test.txt",
                "UCI HAR Dataset/test/y_test.txt",
                "UCI HAR Dataset/test/X_test.txt",
                "UCI HAR Dataset/activity_labels.txt")
  
  if (sum(!file.exists(filelist)) >0) stop("One or more files ")
  
  dt.train <- as.data.table(read.table(filelist[2]))
  
  for (filename in filelist[3:4])
  {
    dt.train <- cbind(dt.train, read.table(filename))
  }
  
  dt.test <- as.data.table(read.table(filelist[5]))
  
  for (filename in filelist[6:7])
  {
    dt.test <- cbind(dt.test, read.table(filename))
  }
  
  newnames <- colnames(dt.train)
  newnames[1] <- "Subject"
  newnames[2] <- "Activity"
  
  setnames(dt.train, newnames)
  setnames(dt.test, newnames)
  
  rbind(dt.train, dt.test)
}

filterc <- function()
{
  # This function is designed to return a vector with the column indexes to filter
  
  #First we read the features data set
  fet <- read.table("UCI HAR Dataset/features.txt")
  
  # Extract columns 1, 2 and the indices from the features.txt column 1
  # Use regular expresions to only get the column names containing "mean()" and "std()"
  # Add 2 to the resulting vector to account for the subject and activity columns
  filtercols <- c(1,2, filter(fet, grepl('mean\\(\\)|std\\(\\)', fet$V2))[,1]+2)
  filtercols
}

activitynames <- function()
{
  # First we read the readable names, then name the columns according to the index
  mynames <- read.table("UCI HAR Dataset/activity_labels.txt")[,2]
  names(mynames) <- read.table("UCI HAR Dataset/activity_labels.txt")[,1]
  mynames
}

newnames <- function(olddt, filtercols)
{
  newdt <- setnames(olddt, gsub("\\(|\\)|,", "", c(c("Subject","Activity"), 
                    as.vector(read.table("UCI HAR Dataset/features.txt")[,2])))[][filtercols])
  newdt

}

run_analysis <- function()
{
  # This function completes the first four instructions of the assignment through the following steps:
  # 1. Reads the data from the various source files using the consolidate function
  # 2. Since Subject is stored using integers 1:30, this column is converted to a Factor
  # 3. Calculates a numeric vector of the columns to keep using the filterc() function
  # 4. The data is then transformed as follows:
  #   a. First the data is filtered using the vector from step 3
  #   b. New names are applied to the data set using the newnames() function
  #   c. The Activity column is converted to human readable activity names using the activitynames() function
  # 5. The resulting data table is returned by the function
  
  filtData <- consolidate() 
  filtData$Subject <- factor(filtData$Subject) 
  filtercols <- filterc() 
  
  filtData <- select(filtData, filtercols) %>%
    newnames(filtercols) %>% 
    mutate(Activity = activitynames()[Activity]) 
  
  filtData
}

# It is assumed that the data.table, dplyr and reshape2 packages have been installed.
library(data.table)
library(dplyr)
library(reshape2)

# The fun_analysis function completes the first four steps in the assignment
# The data is stored in a variable called filtData

filtData <- run_analysis()

# Starting with the filtData data table, a second data table is created through the following steps:
# 1. Set the grouping for the tidy data set
# 2. Using the mean function, summarizes each variable
# 3. Uses the Melt function to convert to the long form of the data
# 4. Renames the columns using setnames
# 5. Uses mutate to append "-summarized" to each variable name

tidyData <- group_by(filtData, Subject, Activity) %>% 
  summarise_each(funs(mean)) %>% 
  melt(id.vars = 1:2, measure.vars = 3:68) %>% 
  setnames(c("Subject","Activity","Measure","Value")) %>%
  mutate(Measure = paste(Measure, "summarized",sep="-"))