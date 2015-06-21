#Summary

This file describes the contents of the run_analysis.R file and how that file completes the steps required by the Coursera Getting and Cleaning Data course project. The instructions for the course project are to create a script that does the following:  
1. Merges the training and the test sets to create one data set.  
2. Extracts only the measurements on the mean and standard deviation for each measurement.  
3. Uses descriptive activity names to name the activities in the data set  
4. Appropriately labels the data set with descriptive variable names.  
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  

This file describes each function and the steps taken by the script to reach step 5. The resulting data set is described in the [CodeBook.md] file.

#Function Descriptions

##consolidate()
The consolidate() function takes no arguments and returns the merged data set described in Step 1 of the assignment directions. 

Before starting, the function verifies that all of the data files required for the script are available in the expected location. The script must start from the working directory that contains a sub-folder called "UCI HAR Dataset" which was within the original zip file. 

The function then loads the training data set into a variable called dt.train by reading each of the following files from the train directory:
* subject_train.txt
* y_train.txt
* x_train.txt

A similar variable called dt.test is created by loading the corresponding files from the test directory. In each case, the first file is read as the first variable and the subsequent files are appended as column using the cbind function. This results in the first column being the subject, the second column being the activity and 561 "feature" columns.

At this point, the first three columns are named "V1" due to the way read.table reads the data. This would cause problems later on if not addressed so the first two column names are set to be "Subject" and "Activity". This is done for both the dt.train and dt.test variables.

Finally, the merged data set is returned using rbind and passing the dt.train and dt.test data tables as arguments.

##filterc()

The filterc function takes no arguments and returns a numeric vector that contains the column numberss we want to keep from the merged data set.

This function first reads the "features.txt" file into a variable called fet. Another variable called filtercols is created by combining columns 1, 2 and any column number containing "mean()" or "std()". The column numbers are identified using regular expressions and the grepl function. The value of 2 is added to the result to account for the first two columns "Subject" and "Activity" which are not present in the "features.txt" file.

The result excludes columns that are not strictly a "mean" or "standard deviation" such as "fBodyAcc-meanFreq". In the original data, these variables are described as a "Weighted average of the frequency components to obtain a mean frequency." The end result of this is a vector of 68 numbers: Subject, Activity and 66 different measurements.

The filtercols vector is returned.

##activitynames()

The activitynames function takes no arguments and returns a vector contain the activity names.

The "activity_labels.txt" file contains two columns, a numeric index and the text label such as "WALKING_UPSTAIRS", etc. The first step is to read the second column, the readable names, into a variable called mynames. 

The second step reads the first column and assigns those values and names.

The mynames vector is returned.

##newnames(olddt, filtercols)

The newnames function takes a data table (olddt) and a numeric vector (filtercols) as its arguments. The data table should already be filtered down to the Subject, Activity and 66 different measurements identified. The function returns a data table with the names read from the "features.txt" file.

The new data table is created calls newdt. The names are set with a single statement that does the following:
* Call the function setnames with olddt as the source data
* Set the new names based on the result of the following steps:
  * Read column 2 from the "features.txt" file
  * Coerce the result to a vector data type
  * Combine "Subject" and "Activity" as the first two values followed by the results from the previous step
  * Remove parentheses and commas in the names using the gsub function
  * Subset the resulting vector based on the filtercols argument that was supplied
  * Assign the values from this vector as the names in the newdt variable
* Return the newdt variable

##run_analysis()

The run_ananlysis function takes no arguments and returns a data table that meets the requirements of steps 1-4 from the assignment instructions. 

1. Reads the data from the various source files using the consolidate function
2. Since Subject is stored using integers 1:30, this column is converted to a Factor
3. Calculates a numeric vector of the columns to keep using the filterc() function
4. The data is then transformed as follows:
  a. First the data is filtered using the vector from step 3
  b. New names are applied to the data set using the newnames() function
  c. The Activity column is converted to human readable activity names using the activitynames() function
5. The resulting data table is returned by the function

##Commands

The following commands are executed at the end of this script to complete the requirements are the assignment.

First, the required libraries are loaded. It is assumed that they are already installed. This script uses the data.table, dplyr and reshape2 libraries.

A variable called filtData is created by calling the run_analysis() function. This variable meets the requirements of steps 1-4.

To meet the requirements of step 5, a second data table is created called tidyData. The following steps are used to create this data set:
1. The filtData is grouped by Subject and Activity using the group_by function
2. All of the remaining 66 columns are summarized using the summarise_each function, providing it with the "mean" function.
3. The data set is melted using the melt function. Columns 1:2 (Subject, Actviity) are assigned as id variables and the remaining columns 3:68 are measures.
4. The columns of the melted data set are renamed to "Subject","Activity","Measure", and "Value"
5. "-summarized" is appended to the values in the Measure column using the mutate and paste functions

The final result is two variables in the global environment called filtData and tidyData. The tidyData.txt file is created with the following command:

write.table(tidyData, row.name = FALSE, file = "tidyData.txt")

*Note: The final step of adding "-summarized" is included because the original data is already a summary, either the "mean" or "standard deviation" of a measured value.  We are further summarizing by taking the __mean__ of that feature over multiple instances of each subject performing each activity. It was also because filtData and tidyData would contain very similar column names & Measure values and this served to highlight that they are different.*