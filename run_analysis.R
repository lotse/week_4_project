setwd("D:/github/data_clean/project_week_4")

#Read in data
xtest <- read.table("test/X_test.txt", header=FALSE, sep="")
xtrain <- read.table("train/x_train.txt", header=FALSE, sep="")
ytest <- read.table("test/y_test.txt", header=FALSE, sep="")
ytrain <- read.table("train/y_train.txt", header=FALSE, sep="")
subtest <- read.table("test/subject_test.txt", header=FALSE, sep="")
subtrain <- read.table("train/subject_train.txt", header=FALSE, sep="")


#Combine all the data into one table
test <- cbind(subtest, ytest, xtest)
train <- cbind(subtrain, ytrain, xtrain)
alldata <- rbind(test, train)


#Read features
features <- read.table("./features.txt", header=FALSE, sep="")
features[,2] <- as.character(features[,2])


#Header names based on features vector
colnames(alldata) <- c("Subject", "Activity", features[,2])

str(alldata)

subdata <- alldata[, c(1, 2, grep('mean\\(\\)|std\\(\\)', colnames(alldata)))]

#Read activity labels
activities <- read.table("./activity_labels.txt", header=FALSE, sep="")
activities[, 2] <- gsub("_", " ", tolower(activities[, 2])) #Removes underscore & makes it lowercase
 
#Adds descriptive names for activties
subdata$Activity <- activities[subdata$Activity, 2]

names(subdata)

savedData <- subdata
subdata <- savedData
names(subdata) <- sub('^t','time_',names(subdata))
names(subdata) <- sub('^f','freq_',names(subdata))
names(subdata) <- sub('-mean\\(\\)','_mean',names(subdata))
names(subdata) <- sub('-std\\(\\)','_std',names(subdata))
names(subdata) <- sub('-X$','_x',names(subdata))
names(subdata) <- sub('-Y$','_y',names(subdata))
names(subdata) <- sub('-Z$','_z',names(subdata))
names(subdata)

install.packages("reshape")
library(reshape)

meltdata <- melt(subdata, id=c("Subject","Activity"))
dt <- cast(meltdata, Subject + Activity ~ variable, mean)
head(dt)

#Outputs tidy data to a txt file in the working directory
write.table(dt, file="tidy_data.txt", row.names=FALSE)

