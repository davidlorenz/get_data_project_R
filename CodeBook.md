### CodeBook.md - Coursera Getting and Cleaning Data (getdata-012) Course Project
#### Data, variable and transformation descriptions.

Raw data referenced from the course website represent data collected from the 
accelerometers from the Samsung Galaxy S smartphone ("UCI_HAR_Dataset", see:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).
The study design included measurements of 561 variables for 30 subjects randomly assigned
to test and training groups. Data collection occcured during one of six activities.
Aims of the project were to parse and combine test/training raw data and activity/
feature/subject identifier text files, select the  mean- and std- raw variables, and 
output the mean of each of these for each Subject/Activity (see: 
UCI_HAR_Dataset/README.txt for additional information on study design).

The merged output data (get_data_project_outData.txt) is in tidy format: one column per 
variable, one row per observation. Selected variables included the mean (-mean()) and 
standard deviation (-std()) for each of the folowing measurements provided in the raw
data files (66 data variables total):

- tBodyAcc-XYZ
- tGravityAcc-XYZ
- tBodyAccJerk-XYZ
- tBodyGyro-XYZ
- tBodyGyroJerk-XYZ
- tBodyAccMag
- tGravityAccMag
- tBodyAccJerkMag
- tBodyGyroMag
- tBodyGyroJerkMag
- fBodyAcc-XYZ
- fBodyAccJerk-XYZ
- fBodyGyro-XYZ
- fBodyAccMag
- fBodyAccJerkMag
- fBodyGyroMag
- fBodyGyroJerkMag

where X,Y,Z denote separate measurements in each of three spatial axes. Identifier 
variables include: 
*  SubjectID - integer 1 - 30 subject identifier
* TestTrain - categorical TEST/TRAIN denoting whether subject in test or training group
* ActivityID - integer 1 - 6 activity identifier
* Activity - categorical activity description: WALKING, WALKING_UPSTAIRS, 
    WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING

Output file data were summarized for each Subject - Activity using the mean of all 
observations. Output data is 180 rows (30 Subjects x 6 Activities) by 70 columns 
(4 identifier variables + 66 data variables).

