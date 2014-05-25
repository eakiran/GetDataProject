#This script downloads wearable device data, removes unwanted data, merges test
#and train data and summarizes the information of each variable by subject
#observed (subjects 1 through 30) and by activity type (walking, standing...)

#sets working directory for downloading and unzipping the files
setwd("c:/Users/Public/")
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL,destfile="dataRaw.zip")
unzip("dataRaw.zip")

#Reads all files from test and train subdirectories into data tables
#also reads the files with activities and measured variables information
features <- read.table("c:/Users/Public/UCI HAR Dataset/features.txt", stringsAsFactors=FALSE)
xTest <- read.table("c:/Users/Public/UCI HAR Dataset/test/X_test.txt")
yTest <- read.table("c:/Users/Public/UCI HAR Dataset/test/Y_test.txt")
subjTest <- read.table("c:/Users/Public/UCI HAR Dataset/test/subject_test.txt")
xTrain <- read.table("c:/Users/Public/UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("c:/Users/Public/UCI HAR Dataset/train/Y_train.txt")
subjTrain <- read.table("c:/Users/Public/UCI HAR Dataset/train/subject_train.txt")
activNames <- read.table("c:/Users/Public/UCI HAR Dataset/activity_labels.txt")

#Remove unwanted characters from measured variable names
variables<- features[,2]
variables <- gsub("-", "", variables)
variables <- gsub(",", ".", variables)
variables <- gsub("\\(", "", variables)
variables <- gsub("\\)", "", variables)

#gives names to columns in table with activity names in plain English
colnames(activNames) <- c("Activity", "Activity Name")

#"Merges" all variable data from test and train with test coming first
#Assign names to columns using the variables names
xAll <- rbind(xTest, xTrain)
colnames(xAll) <- variables
#Merges the activities numbers for Test and Train and assign column name
yAll <- rbind(yTest, yTrain)
colnames(yAll) <- c("activityNBR")

#Loops to associate activity numbers with activity names in the correct
#sequence
yAllEnglish <- data.frame()
for (i in 1:nrow(yAll)) {
    yAllEnglish[i,1] <- i
    yAllEnglish[i,2] <- yAll[i,1]
    yAllEnglish[i,3] <- activNames[yAll[i,1],2]
                        }
colnames(yAllEnglish) <- c("seq", "activityNBR", "activityName")

#"Merges" the subject information from test and train. Assign column names.
subjAll <- rbind(subjTest, subjTrain)
colnames(subjAll) <- c("Subject")

#"Merges" all data.tables
tidyData <- cbind(subjAll, yAllEnglish, xAll)

#Removes the unwanted data.
variablesNeeded <- c(1,3,4,205,206,218,219,231,232,244,245,257,258,507,508,520,521,533,534,546,547,559:565)
tidyData <- tidyData[,variablesNeeded]

#Captures the column names from tidyData. Identifies columns that are variables
tidyDataColNames <- colnames(tidyData)
tidyDataColVars <- tidyDataColNames[4:28]

#Melts the data using Subject and Activity Name
molten <- melt(tidyData, id=c("Subject", "activityName"),measure.vars=tidyDataColVars)

#Casts the data to generate the final tidyData2 with averages of each chosen variables
#by subject and activity name
tidyData2 <- dcast(molten,Subject+activityName~variable,mean)

#Exports the final tidy dataset
write.table(tidyData2, file="tidyData2.txt", sep="\t")
