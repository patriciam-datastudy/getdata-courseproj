## Read the following files into R
## features.txt
## X_test.txt y_test.txt subject_test.txt
## X_train.txt y_train.txt subject_train.txt
## Note: The folder UCI HAR Dataset is contained in the working directory.

columnnamesfile <- file.path(getwd(),"UCI HAR Dataset","features.txt")
columnnames <- read.table(columnnamesfile, colClasses="character")
## column names are stored in columnnames$V2

xtestfile <- file.path(getwd(),"UCI HAR Dataset","test","X_test.txt")
xtest <- read.table(xtestfile, colClasses="numeric")

ytestfile <- file.path(getwd(),"UCI HAR Dataset","test","y_test.txt")
ytest <- read.table(ytestfile, colClasses="numeric")

subjecttestfile <- file.path(getwd(),"UCI HAR Dataset","test","subject_test.txt")
subjecttest <- read.table(subjecttestfile, colClasses="numeric")

xtrainfile <- file.path(getwd(),"UCI HAR Dataset","train","X_train.txt")
xtrain <- read.table(xtrainfile, colClasses="numeric")

ytrainfile <- file.path(getwd(),"UCI HAR Dataset","train","y_train.txt")
ytrain <- read.table(ytrainfile, colClasses="numeric")

subjecttrainfile <- file.path(getwd(),"UCI HAR Dataset","train","subject_train.txt")
subjecttrain <- read.table(subjecttrainfile, colClasses="numeric")

## Merge the test and train files, apply proper columnnames
whole <- rbind(xtest,xtrain)
colnames(whole) <- columnnames$V2

## Merge the subjects
subject <- rbind(subjecttest,subjecttrain)

## Merge the activities, convert to descriptive names
activitytemp <- rbind(ytest,ytrain)
activity <- vector("character",length=length(activitytemp[,1]))
actnames <- c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying")
for (i in 1:length(activitytemp[,1])){
    activity[i] <- actnames[activitytemp[i,]]
}

## Search for features(i.e. column names) that contain the string "mean()" or "std()"
chosencols <- logical()
chosenmean <- logical()
chosenstd <- logical()
for (i in 1:length(colnames(whole))){
    chosenmean[i] <- grepl("mean()",colnames(whole)[i],fixed=TRUE)
    chosenstd[i] <- grepl("std()",colnames(whole)[i],fixed=TRUE)
    chosencols[i] <- chosenmean[i] | chosenstd[i]
}

## Collapse dataframe whole into only the chosen columns
part <-subset(whole,select=which(chosencols))

## Reformat remaining column names into readable format
tempstrings <- vector("list",length(colnames(part)))
finalnames <- vector("character",length(colnames(part)))
for (i in 1:length(colnames(part))){
    ## Separate column name into parts separated by -
    tempstrings[i] <- strsplit(colnames(part)[i],'-')
    
    ## Remove leading letter, append dimension and Mean or StdDev as necessary
    if (length(tempstrings[[i]])==3){
        if (tempstrings[[i]][2]=="mean()"){
            finalnames[i] <- paste(substr(tempstrings[[i]][1],2,nchar(tempstrings[[i]][1])),tempstrings[[i]][3],"Mean")
        } else {
            finalnames[i] <- paste(substr(tempstrings[[i]][1],2,nchar(tempstrings[[i]][1])),tempstrings[[i]][3],"StdDev")
        }
    } else {
        if (tempstrings[[i]][2]=="mean()"){
            finalnames[i] <- paste(substr(tempstrings[[i]][1],2,nchar(tempstrings[[i]][1])),"Mean")
        } else {
            finalnames[i] <- paste(substr(tempstrings[[i]][1],2,nchar(tempstrings[[i]][1])),"StdDev")
        }
    }
}

## Apply new column names to part

colnames(part) <- finalnames

## Append subject and activity information

almost <- cbind(subject,activity,part)
colnames(almost)[1] <- "Subject"
colnames(almost)[2] <- "Activity"

## Calculate average of each variable for each activity and each subject

library(plyr)
library(reshape2)
## Reshape data into tall and narrow form
melted <- melt(almost,id.vars=c("Subject","Activity"))
## Final tidy data set with calculated average per subject and activity
final <- ddply(melted,c("Subject","Activity","variable"),summarise,mean(value))

## Rename column name to Average
colnames(final)[4] <- "Average"

## Write to output file
outputfile <- file.path(getwd(),"UCI HAR Dataset","output.txt")
write.table(final,outputfile,row.names=FALSE)
