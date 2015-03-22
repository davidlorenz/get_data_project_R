### run_analysis.R -- Coursera data science get-data course project
#     20150220: script creation
#     - loads column/row identifier files and test/train data using readLines,
#       coerced to matrix/data.frame using custom function
#     - adds column names (features) and 
#       row ids (Subject ID - Train/Test group - ActivityID - Activity Name)
#     - merges all train (7352 x 561) + test (2947 x 561) data
#     - selects only -mean() and -std() variables (10,299 x 70, incl. 4 row ID columns)
#     - creates output data with aggregate mean for each activity and each subject
#       (180 x 70 columns) in tidy format (1 column/variable, 1 row/observation)
#     - writes out to .txt file (space-delim)
#     see README.md for detailed explanation

library(dplyr)

setwd("~/Dropbox/Coursera/20150300_GettingCleaningData/project")


## function to load text files using readLines, parse whitespace-separated
#    vectors into data.frame using strsplit %>% unlist %>% matrix pipe
#    output data.frame has N 0rows matching lines in input file
fileParse <- function(in.file) {
  filedata <- readLines(con <- file(in.file)); close(con);
  fileDF <- filedata %>% stringr::str_trim() %>% strsplit("\\s+") %>% 
    unlist() %>% matrix(nrow=length(filedata), byrow=TRUE) %>% 
    as.data.frame(stringsAsFactors=FALSE) %>% tbl_df()
  fileDF
}    


## parse features and activity labels file data
# Features data.frame (561 x 2) - column names for X_ data
features.df <- fileParse("data/UCI_HAR_Dataset/features.txt")
features.df <- features.df %>% rename(FeatureID = V1, Feature = V2)
# Features data.frame (6 x 2) - table to match ActivityIDs to text description
activity_labels.df <- fileParse("data/UCI_HAR_Dataset/activity_labels.txt")
activity_labels.df <- activity_labels.df %>% rename(ActivityID = V1, Activity = V2)


## train data folder file parsing
# subject_train.df - SubjectID row labels (7352 x 1) 
# - 21 unique subjects (conistent with data readme file)
# - add column TestTrain <- train to track if subject in Test/Train group
subject_train.df <- fileParse("data/t")
subject_train.df <- subject_train.df %>% rename(SubjectID = V1)
subject_train.df$TestTrain <- "TRAIN"
#length(unique(subject_train.df$SubjectID))  # n=21

# y_train.df - ActivityID row labels (7352 x 1)
#   add activity text tanslations from activity_labels.df by left_join
y_train.df <- fileParse("data/UCI_HAR_Dataset/train/y_train.txt")
y_train.df <- y_train.df %>% rename(ActivityID = V1)
y_train.df <- left_join(y_train.df, activity_labels.df)

# X_train.df - features data matrix (7352 x 561)
#   row labels match SubjectID (subject_train.df) - ActivityID (y_train.df)
#   column labels match Feature (features.df)
X_train.df <- fileParse("data/UCI_HAR_Dataset/train/X_train.txt")
#   convert X_train.df data from character to numeric
X_train.df <- lapply(X_train.df, as.numeric) %>% as.data.frame() %>% tbl_df()
#   add names from features.df and convert class to numeric
names(X_train.df) <- features.df$Feature
#   combine columns
train.df <- bind_cols(subject_train.df, y_train.df, X_train.df) %>% tbl_df()


## test data folder 
#  repeat steps as for train data (X_test.df = 2947 x 561)
subject_test.df <- fileParse("data/UCI_HAR_Dataset/test/subject_test.txt")
subject_test.df <- subject_test.df %>% rename(SubjectID = V1)
subject_test.df$TestTrain <- "TEST"
#length(unique(subject_test.df$SubjectID))  # n=9
y_test.df <- fileParse("data/UCI_HAR_Dataset/test/y_test.txt")
y_test.df <- y_test.df %>% rename(ActivityID = V1)
y_test.df <- left_join(y_test.df, activity_labels.df)
X_test.df <- fileParse("data/UCI_HAR_Dataset/test/X_test.txt")
X_test.df <- lapply(X_test.df, as.numeric) %>% as.data.frame() %>% tbl_df()
names(X_test.df) <- features.df$Feature
test.df <- bind_cols(subject_test.df, y_test.df, X_test.df) %>% tbl_df()


## bind train and test data together
all_data.df <- bind_rows(train.df, test.df)


## select only id and -mean() and -std() columns per assignment instructions
#   dim 10,299 x 70
all_data.mean_std.df <- bind_cols(
  all_data.df[, c(1:4)], 
  all_data.df %>% select(matches("\\-mean\\(\\)")),
  all_data.df %>% select(matches("\\-std\\(\\)"))
) %>% tbl_df()
# convert SubjectID to numeric for sorting
all_data.mean_std.df$SubjectID <- as.numeric(all_data.mean_std.df$SubjectID)

# check all -mean() -std() features included: 33 each in features_info.txt file
#  - okay: 70 columns = 4 ID columns + 33 mean + 33 std
#names(all_data.mean_std.df)[grep("mean", names(all_data.mean_std.df))]
#names(all_data.mean_std.df)[grep("std", names(all_data.mean_std.df))]


## create output data.frame with the average of each variable for each activity - subject
#   180 x 70
out_data.mean.df <- 
  all_data.mean_std.df %>% group_by(SubjectID, TestTrain, ActivityID, Activity) %>%
  summarise_each(funs(mean))


## write output to .tsv
write.table(out_data.mean.df, "get_data_project_outData.txt", row.names=FALSE, quote=FALSE)

