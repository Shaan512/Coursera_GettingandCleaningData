# Coursera_GettingandCleaningData
Coursera_Getting and Cleaning Data final project

following are the details about this particular assignment and a brief description of my implementation

1)To clean up the workspace and to Download and unzip the file needed

2)Setting up the working directory to the location where the UCI HAR Dataset was unzipped

3)Merging the training and the test sets to create as a single data set
   This is done by creating one final training set and one final test set and then  Combining both the training and test data to create it    as a final data set
   
4)Extract only the measurements on the mean and standard deviation for each measurement
    This is done by creating one logical vector and then Subsetting finalData created earlier based on the logicalVector
    
5)Use descriptive activity names to name the activities in the data set
     This is done by Merging the finalData set with the acitivityType table
     
6)Reassigning the new descriptive column names to the finalData set

7)Created a second independent tidy data set with the average of each variable for each activity and each subject
