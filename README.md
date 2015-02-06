Getting and Cleaning Data: Course Project
=========================================

About the data
--------------
The data consists of two sets of files (training and test) that both contain three files: 
subject_*.txt
X_*.txt
Y_*.txt

The X_*.txt files contain the dataset, of which there are 561 columns. The Y_*.txt contain the activity labels connected to each row of the X_*.txt dataset. The subject_*.txt contain the subject identifier which is connected to each row of the X_*.txt dataset.

In addition to these files there exists two more interesting files in the dataset:
activity_labels.txt
features.txt

activity_lables.txt contain data describing the activity labels seen in the Y_*.txt files. Basically, they'll map a number to an actual text value which describes the activity. The features.txt file contain column names for the X_*.txt dataset. 


About the script
----------------

run_analysis.R performs a task of tidying the downloaded dataset and presenting the result to the user as a text-file.

Here's a step by step description of what it does:
1. Check if zip-file containing the dataset is downloaded OR if there exists a folder with the expected name of the extracted dataset. 
2. If not, download and unzip.
3. Read the datasets into tables.
4. Read the additional files
5. Rename the columns of all the tables for better readability.
6. Join together the different datafiles (first training and test sets seperate, then the resulting two sets as as a complete dataset)
7. Extract only the columns we need for the tidy dataset (where the name contains either Mean or Std)
8. Calculate the mean over activity and subject.
9. Print the result to a file.