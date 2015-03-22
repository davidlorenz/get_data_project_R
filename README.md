### README.md - Coursera Getting and Cleaning Data (getdata-012) Course Project
#### run_analysis.R script description

20150220: script creation

The aim of the script is to merge raw data test and training .txt files (space-delim)
with files linking data rows to subject - activity IDs and file linking column IDs
to variable names. The script then selects only -mean() and -std() variables and returns 
a tidy data output (one column per variable, one row per observation) with mean for each 
subject - activity combination.

Summary of script functionality/specific details:
* loads and parses column/row identifier files:
	- UCI_HAR_Dataset/features.txt - 561 x 2 -  maps data columns to feature (variable) names
	- UCI_HAR_Dataset/activity_labels.txt - 6 x 2 - maps activity integer IDs to descriptions

* loads and parses raw data/row identifier files in test/ and train/ directories:
	- UCI_HAR_Dataset/train/X_train.txt - 7352 x 561 - raw train data set
	- UCI_HAR_Dataset/train/subject_train.txt - 7352 x 1 - maps train data rows to subject IDs
	- UCI_HAR_Dataset/train/y_train.txt - 7352 x 1 - maps train data rows to activity IDs

	- UCI_HAR_Dataset/test/X_test.txt - 2947 x 561 - raw test data set
	- UCI_HAR_Dataset/test/subject_test.txt - 2947 x 1 - maps test data rows to subject IDs
	- UCI_HAR_Dataset/test/y_test.txt - 2947 x 1 - maps test data rows to activity IDs

	- train data has 21 unique subjects, test data, 9 unique subjects, consistent with
    raw data README.txt

* custom function "fileParse" uses readLines() to import lines as character vector, 
  one vector element for each line in file, then stringr::str_trim() to remove line 
  leading whitespace (if present), then strsplit() %>% unlist() %>% matrix %>% data.frame
  pipeline to separate string elements by whitespace and coerce to a matrix/data.frame
  with nrows == number of lines in input file
  - function operates correctly on all data files, regardless of number of elements 
    per line

* row and column labels for test/train data.frames (X_test/X_train.txt raw data files) are 
  added from identifier files data:
  - rows id labels: 
    - SubjectID - from subject_test/subject_train.txt file data (added in column bind)
    - TestTrain - denotes if subject in TEST or TRAIN group
    - ActivityID - from y_test/y_train.txt file data (added in column bind)
    - Activity - descriptions from activity_labels.txt (left_join with key ActivityID)
  - column id labels from features.txt

* test and train data.frames merged by row binding:
  - dimensions 10299 x 565: train (7352 x 565) and test data (2947 x 565)

* -mean() and -std() variables selected for output (using dplyr::select(match()))
  - dimensions 10299 x 70: 4 identifier columns + 33 -mean(), 33 -std()
  - raw variables include others labeled with "Mean" e.g. "gravityMean" which according
    to features_info.txt are composite variables of "-angle()" measurements -- therefore
    not included in output

* the mean value of rows for each subject - activity combination was determined 
  using dplyr::summarise_each(funs(mean())) in combination with dplyr::group_by()
  - final output for .tsv file: 
      180 rows (30 subjects x 6 activities) x 
      70 columns (4 Identifiers + 33 -mean() + 33 -std() variables)




