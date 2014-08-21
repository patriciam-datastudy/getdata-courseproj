Readme - Course project
==================

Course project for Getting and Cleaning Data in Coursera (batch getdata-006)

run_analysis.R contains code to clean wearable computing data from Human Activity Recognition Using Smartphones Dataset Version 1

Assumes the file run_analysis.R and the folder UCI HAR Dataset (and its accompanying files) is located in the working directory

Steps done by run_analysis.R in order
- Opening the following text files into R: features, X_test, y_text, X_train, y_train, subject_test, subject_train
- Merges the xtest and xtrain data and apply the proper columnnames from features
- Merges the subjecttest and subjecttrain data
- Merges the ytest and ytrain data, and converts it to descriptive names (walking, walking upstairs, etc.)
- Searches the columns for the ones with mean() and std() in the name
- Creates a new dataframe with the chosen columns and reformats the column names to make it more readable
- Creates the final form of the dataframe by inserting the subject and activity data in front
- Reshapes the final dataframe into a tall and skinny dataframe for the final calculations
- Calculates the average of each variable per subject and per activity as per the tall and skinny dataframe
- Writes an output.txt file in the UCI HAR Dataset folder using write.table
