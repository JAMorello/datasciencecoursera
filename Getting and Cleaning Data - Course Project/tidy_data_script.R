## While using UCI HAR dataset, I acknowledge the following publication:
##
## Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra 
## and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones 
## using a Multiclass Hardware-Friendly Support Vector Machine. 
## International Workshop of Ambient Assisted Living (IWAAL 2012). 
## Vitoria-Gasteiz, Spain. Dec 2012


# 1st Step: Download and unzip the files

  # Make sure that the directory where the data is to be stored exist
  if(!file.exists("./data")){dir.create("./data")}
  # Create a URL named vector with the URL address
  URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  # Set download path directory
  dwnld_path <- "./data/UCI_HAR_Dataset.zip"
  # Download file
  download.file(URL, destfile=dwnld_path, method="curl")
  # Unzip file
  unzip(zipfile=dwnld_path, exdir="./data")


# 2nd Step: See what files the dataset contains

  # Define the path where the new folder has been unziped
  pathdata = file.path("./data", "UCI HAR Dataset")
  # Create a file vector which has all the file names
  files = list.files(pathdata, recursive=TRUE)

  # The dataset contains a "Inertial Signals" folder both in train and test that
  # is of no interest to us.
  
  # README.txt contains info about the experiments and
  # feature_info.txt explains what the features name and variables mean.
  
  # We can categorize the data files into four segments:
  # training set / test set / features / activity 
  # Those are of our interest!
  
  
# 3rd Step: Read files and create tables 

  # Read training data
  x_train = read.table(file.path(pathdata, "train", "X_train.txt"),
                      header = FALSE)
  y_train = read.table(file.path(pathdata, "train", "y_train.txt"),
                      header = FALSE)
  subject_train = read.table(file.path(pathdata, "train", "subject_train.txt"),
                            header = FALSE)

  # Reading testing data
  x_test = read.table(file.path(pathdata, "test", "X_test.txt"),
                      header = FALSE)
  y_test = read.table(file.path(pathdata, "test", "y_test.txt"),
                      header = FALSE)
  subject_test = read.table(file.path(pathdata, "test", "subject_test.txt"),
                            header = FALSE)

  # Read the features data
  features = read.table(file.path(pathdata, "features.txt"),
                        header = FALSE)

  # Read activity labels data
  activity_labels = read.table(file.path(pathdata, "activity_labels.txt"),
                               header = FALSE)

  
# 4th Step: concatenate rows of data to have feature, activity and subject tables
  
  subject_table <- rbind(subject_train, subject_test)
  activity_table<- rbind(y_train, y_test)
  features_table<- rbind(x_train, x_test)
  

# 5th Step: set the name of the columns of the tables
  
  colnames(subject_table) <- "subjectID"
  colnames(activity_table) <- "activityID"
  colnames(activity_labels) <- c("activityID","activityType")
  colnames(features_table) <- features[,2]
  
  
# 6th Step: merge the tables
  
  full_data <- cbind(subject_table, activity_table, features_table)

  
# 7th Step: Extract only the measurements on the mean 
#           and standard deviation for each measurement

  subset_features <- features[,2][grep("mean\\(\\)|std\\(\\)",
                                       features[,2])]
  
  selected_names<-c("subjectID", "activityID", as.character(subset_features))
  subset_data <- subset(full_data, select=selected_names)
  
  
# 8th Step: Use descriptive activity names to name 
#           the activities in the data set

  activityID <- activity_labels[,1]
  activityType <- activity_labels[,2]
  subset_data$activityID <- plyr::mapvalues(subset_data$activityID, 
                                            from=activityID, to=activityType)
  colnames(subset_data)[colnames(subset_data) == "activityID"] <- "activityType"
  
# 9th Step: Appropriately labels the data set with descriptive variable names

  # Names of Feteatures will labelled using descriptive variable names.
  #
  # prefix 't' is replaced by 'time'
  # 'Acc' is replaced by 'Accelerometer'
  # 'Gyro' is replaced by 'Gyroscope'
  # prefix 'f' is replaced by 'frequency'
  # 'Mag' is replaced by 'Magnitude'
  # 'BodyBody' is replaced by 'Body'
  
  colnames(subset_data) <- gsub("^t", "time", colnames(subset_data))
  colnames(subset_data) <- gsub("^f", "frequency", colnames(subset_data))
  colnames(subset_data) <- gsub("Acc", "Accelerometer", colnames(subset_data))
  colnames(subset_data) <- gsub("Gyro", "Gyroscope", colnames(subset_data))
  colnames(subset_data) <- gsub("Mag", "Magnitude", colnames(subset_data))
  colnames(subset_data) <- gsub("BodyBody", "Body", colnames(subset_data))
  

# 10th Step: Create a second,independent tidy data set and ouput it

  # Create tidy data set
  tidy_data <- aggregate(. ~subjectID + activityType, subset_data, mean)
  tidy_data <- tidy_data[order(tidy_data$subjectID,tidy_data$activityType),]
  
  # Write the ouput to a text file
  write.table(tidy_data, file = "data/tidy_data.txt",row.name=FALSE)
  