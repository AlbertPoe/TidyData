setwd("F:/MyDocs/Analytics/R_Workspace/")
if(!file.exists("./data")){dir.create("./data")}
setwd("./data")

# download and unzip the files and move the files into the same working folder
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile="./DataSet.zip",mode="wb")
unzip("./DataSet.zip")
setwd("./UCI HAR Dataset/test/")
file.exists("./subject_test.txt")
file.copy("./subject_test.txt","F:/MyDocs/Analytics/R_Workspace/data/subject_test.txt")
file.copy("./y_test.txt","F:/MyDocs/Analytics/R_Workspace/data/y_test.txt",)
file.copy("./X_test.txt","F:/MyDocs/Analytics/R_Workspace/data/X_test.txt",)
setwd("F:/MyDocs/Analytics/R_Workspace/data/UCI HAR Dataset/train")
getwd()
file.copy("./subject_train.txt","F:/MyDocs/Analytics/R_Workspace/data/subject_train.txt")
file.copy("./X_train.txt","F:/MyDocs/Analytics/R_Workspace/data/X_train.txt")
file.copy("./y_train.txt","F:/MyDocs/Analytics/R_Workspace/data/y_train.txt")
file.copy("./features.txt","F:/MyDocs/Analytics/R_Workspace/data/feature.txt")
setwd("F:/MyDocs/Analytics/R_Workspace/data")

# parse the features file to determine which columns to keep and the column names.
featureKeep <- read.table("feature.txt")
featureKeep <- data.frame(index=c(1:nrow(featureKeep)),featureKeep)
featureMean <- grep("-mean()", featureKeep$V2,fixed=T)
featureSTD <- grep("-std()", featureKeep$V2,fixed=T)
fKeep <- c(featureMean,featureSTD)
fKeep <- sort(fKeep, decreasing = FALSE)
keep <- fKeep
# At this point i have scanned through the file to determine which rows to keep and set keep
#keep <-c(1:6,41:46,81:86,121:126,161:166,201,202,214,215,227,228,240,241,253,254,266:271,345:350,424:429,503,504,516,517,529,530,542,543)
featureNames <- read.table("feature.txt")
featureNames <- featureNames[keep,]
ColNames <- as.character(featureNames$V2)
ColNames <- sub("-m","_M",ColNames)
ColNames <- sub("-s","_S",ColNames)
ColNames <- sub("\\()-X","X",ColNames)
ColNames <- sub("\\()-Y","Y",ColNames)
ColNames <- sub("\\()-Z","Z",ColNames)
featureNames$V2 <- ColNames
X_testNames <- featureNames


subject_test <- read.table("subject_test.txt")
y_test <- read.table("y_test.txt")
x_test <- read.table("X_test.txt")

# Now we're ready to merge the files together.
# The "test" and "train" files are the same where test represents 30% of the total dataset.
# The "subject" file represent the participents. The "Y" files represent the activities, i.e.
# walking, etc. The "X" files represent the variables collected, of which we are interested in the
# std() and mean() for each variable.
subject_test <- data.frame(index=c(1:nrow(subject_test)),subject_test)
y_test <- data.frame(index=c(1:nrow(y_test)),y_test)
temp1_test <- merge(subject_test,y_test,by.x="index", by.y="index")
# rename the columns
names(temp1_test)[names(temp1_test)=="V1.x"] <- "Subject"
names(temp1_test)[names(temp1_test)=="V1.y"] <- "Activity"
# I did the same thing for the column names for the data

# subset the "x" data
temp_xtest <- x_test[keep]
# add an index column so we can merge temp_xtest with temp1_test 
temp_xtest <- data.frame(index=c(1:nrow(temp_xtest)),temp_xtest)
#Now merge the two pieces into one tidy data set
test <- merge(temp1_test,temp_xtest,by.x="index", by.y="index")

# Now repeat the above for the train data
subject_train <- read.table("subject_train.txt")
y_train <- read.table("y_train.txt")
x_train <- read.table("X_train.txt")

subject_train <- data.frame(index=c(1:nrow(subject_train)),subject_train)
y_train <- data.frame(index=c(1:nrow(y_train)),y_train)
temp1_train <- merge(subject_train,y_train,by.x="index", by.y="index")
# rename the columns
names(temp1_train)[names(temp1_train)=="V1.x"] <- "Subject"
names(temp1_train)[names(temp1_train)=="V1.y"] <- "Activity"

# subset the "x" data
temp_xtrain <- x_train[keep]

# add an index column so we can merge temp_xtest with temp1_test 
temp_xtrain <- data.frame(index=c(1:nrow(temp_xtrain)),temp_xtrain)
#Now merge the two pieces into one tidy data set
train <- merge(temp1_train,temp_xtrain,by.x="index", by.y="index")

# combinethe two pieces
MyTidyData <- rbind(test,train)
MyTidyData <- MyTidyData[order(MyTidyData[,2],MyTidyData[,3]),]
# We can now remove the index 
MyTidyData <- MyTidyData[,-1]

# Change the Activity numbers to Labels - 1 WALKING, 2 WALKING_UPSTAIRS, 
# 3 WALKING_DOWNSTAIRS, 4 SITTING, 5 STANDING, 6 LAYING
 
MyTidyData$Activity[which(MyTidyData$Activity==1)] <-"WALKING"
MyTidyData$Activity[which(MyTidyData$Activity==2)] <-"WALKING_UPSTAIRS"
MyTidyData$Activity[which(MyTidyData$Activity==3)] <-"WALKING_DOWNSTAIRS"
MyTidyData$Activity[which(MyTidyData$Activity==4)] <-"SITTING"
MyTidyData$Activity[which(MyTidyData$Activity==5)] <-"STANDING"
MyTidyData$Activity[which(MyTidyData$Activity==6)] <-"LAYING"

# reset the column names
for(i in 1:nrow(X_testNames)){
  j <- paste("V",X_testNames[i,1],sep = "")
  names(MyTidyData)[names(MyTidyData) == j] <- X_testNames[i,2] #
}

## We now have MyTidyData ready to melt and cast into a summary
library("reshape2")
MySumData <- MyTidyData
MySumDatamelt <- melt(MySumData, id=c("Subject","Activity"))
MySumDatacast <- dcast(MySumDatamelt, Subject+Activity~variable, mean)
write.table(MySumDatacast, "MyTidyDataSet.txt",quote=F,sep=";")
#head(MySumDatacast, n=12) # Just here to check if it worked
#str(MySumDatacast)