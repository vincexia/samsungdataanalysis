# Samsung Data Analysis
## General Descriptions
In this data analysis, the following steps are  required:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The Samsung data set is placed at the project home folder. 

The key R source file is `run_analysis.R`.

The output tidy data file is `avg_data_by_activity_and_subjectj.txt`.

## Detailed Procedures
The `run_analysis.R` file imports the training data and testing data using read.fwd() function.
The process will combine the activity and subject data, and finally merge the two data sets into one data set.

After that, the script use grepl() function to search mean and standard deviation variables, extract the desired indice subset 
from the merged data set.

The activity names are read from the `activity_labels.txt` file, and merged into the extracted data set. The activity labels will show in the extracted data set. 

The descriptive variable names are extracted from the search of mean and std variables. The feature names about mean and std variables are mapped into the data set as column names.

Use aggregate() function to get the average of the variables grouped by activity and subject. Output the txt file by write.table() function using row.names=FALSE.
