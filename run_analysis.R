##Shaan_Coursera Getting and Cleaning Data
##18-01-2018

##Cleaning up the workspace 
rm(list=ls())

##Downloading the file
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

##Unzip dataSet to the directory created
unzip(zipfile="./data/Dataset.zip",exdir="./data")

##setting up the working directory to the location where the UCI HAR Dataset was unzipped
setwd("F:/Data Science/part 3_Getting and Cleaning Data/week 4/data/UCI HAR Dataset");

##Step1_Assignment. Merging the training and the test sets to create as a single data set.

##Read all the data from files
features     = read.table('./features.txt',header=FALSE); #imports features.txt
activityType = read.table('./activity_labels.txt',header=FALSE); #imports activity_labels.txt
subjectTrain = read.table('./train/subject_train.txt',header=FALSE); #imports subject_train.txt
xTrain       = read.table('./train/x_train.txt',header=FALSE); #imports x_train.txt
yTrain       = read.table('./train/y_train.txt',header=FALSE); #imports y_train.txt


##Assigning the column names to the data which is imported 
colnames(activityType)  = c('activityId','activityType');
colnames(subjectTrain)  = "subjectId";
colnames(xTrain)        = features[,2]; 
colnames(yTrain)        = "activityId";


##Creating the final training set by merging all datas(yTrain, subjectTrain, and xTrain)
trainingData = cbind(yTrain,subjectTrain,xTrain);


##Read all the test data
subjectTest = read.table('./test/subject_test.txt',header=FALSE); #imports subject_test.txt
xTest       = read.table('./test/x_test.txt',header=FALSE); #imports x_test.txt
yTest       = read.table('./test/y_test.txt',header=FALSE); #imports y_test.txt

##Assigning the column names to the test data which is imported 
colnames(subjectTest) = "subjectId";
colnames(xTest)       = features[,2]; 
colnames(yTest)       = "activityId";


# Create the final test set by merging all the datas (xTest, yTest and subjectTest data)
testData = cbind(yTest,subjectTest,xTest);

# Combining both the training and test data to create it as a final data set
finalData = rbind(trainingData,testData);


## Column names for the final data
colNames  = colnames(finalData); 

##Step2_Assignment. Extract only the measurements on the mean and standard deviation for each measurement. 

## logical vector 
logicalVector = (grepl("activity..",colNames) | grepl("subject..",colNames) | grepl("-mean..",colNames) & !grepl("-meanFreq..",colNames) & !grepl("mean..-",colNames) | grepl("-std..",colNames) & !grepl("-std()..-",colNames));

##Subsetting finalData created from Step1 based on the logicalVector
finalData = finalData[logicalVector==TRUE];


##Step3_Assignment. Use descriptive activity names to name the activities in the data set

# Merge the finalData set with the acitivityType table
finalData = merge(finalData,activityType,by='activityId',all.x=TRUE);

# Updating the column Names of the vector 
colNames  = colnames(finalData); 


##Step4_Assignment. Appropriately label the data set with descriptive activity names. 

# Clean all variable names
for (i in 1:length(colNames)) 
{
  colNames[i] = gsub("\\()","",colNames[i])
  colNames[i] = gsub("-std$","StdDev",colNames[i])
  colNames[i] = gsub("-mean","Mean",colNames[i])
  colNames[i] = gsub("^(t)","time",colNames[i])
  colNames[i] = gsub("^(f)","freq",colNames[i])
  colNames[i] = gsub("([Gg]ravity)","Gravity",colNames[i])
  colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
  colNames[i] = gsub("[Gg]yro","Gyro",colNames[i])
  colNames[i] = gsub("AccMag","AccMagnitude",colNames[i])
  colNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames[i])
  colNames[i] = gsub("JerkMag","JerkMagnitude",colNames[i])
  colNames[i] = gsub("GyroMag","GyroMagnitude",colNames[i])
};

# Reassign the new descriptive column names to the finalData set
colnames(finalData) = colNames;


##Step5_Assignment. Create a second, independent tidy data set with the average of each variable for each activity and each subject. 

# Creating a new table
finalDataNoActivityType  = finalData[,names(finalData) != 'activityType'];

##Summarizing the finalDataNoActivityType table to include just the mean of the variables
tidyData    = aggregate(finalDataNoActivityType[,names(finalDataNoActivityType) != c('activityId','subjectId')],by=list(activityId=finalDataNoActivityType$activityId,subjectId = finalDataNoActivityType$subjectId),mean);

##Merging the tidyData 
tidyData    = merge(tidyData,activityType,by='activityId',all.x=TRUE);

##Exporting the final tidyData set
write.table(tidyData, './tidyData.txt',row.names=TRUE,sep='\t');

