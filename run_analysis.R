getwd()

#Creating a directory

if(!file.exists("./data")){
          dir.create("./data")}

#Download the files for the project

DirArc <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(DirArc, destfile = "./data/Dataset.zip", method = "curl")

unzip(zipfile = "./data/Dataset.zip", exdir = "./data")

#Save in a variable the path for all the files
dirarcus <- file.path("./data", "UCI HAR Dataset")

arch <- list.files(dirarcus, recursive = TRUE)
arch

#Save the files with information to analize 
dataActivityTest <- read.table(file.path(dirarcus, "test", "Y_test.txt"), header = FALSE)
dataActivityTrain <- read.table(file.path(dirarcus, "train", "Y_train.txt"), header = FALSE)

dataSubjectTest <- read.table(file.path(dirarcus, "test", "subject_test.txt"), header = FALSE)
dataSubjectTrain <- read.table(file.path(dirarcus, "train", "subject_train.txt"), header = FALSE)

dataFeaturesTest <- read.table(file.path(dirarcus, "test", "X_test.txt"), header = FALSE)
dataFeaturesTrain <- read.table(file.path(dirarcus, "train", "X_Train.txt"), header = FALSE)

#Explore the data files
str(dataActivityTest)
str(dataActivityTrain)
str(dataSubjectTrain)
str(dataSubjectTest)
str(dataFeaturesTest)
str(dataFeaturesTrain)

#Merge the rows of the cells 
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

#Set the variables names
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(dirarcus, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

#Merge the columns to get the complete data
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

#Subset the data frame
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data <- subset(Data,select=selectedNames)
str(Data)

activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

head(Data$activity,30)

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

names(Data)

install.packages("plyr")
library(plyr)
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)

install.packages("knitr")
library(knitr)
knit2html("codebook.Rmd");
