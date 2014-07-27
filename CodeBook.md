Run Analysis CodeBook
========================================================

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING-UPSTAIRS, WALKING-DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, data were captured by 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. (adapted from the README.txt file that came with the data,)

The "test" and "train" files that came with the data set are the same, where test represents 30% of the total dataset and train represent the other 70 %. The "subject" files represent the participents. The "Y" files represent the activities, i.e. walking, etc. The "X" files represent the variables collected, of which we are interested in the std() and mean() for each variable. 

One of the initial difficulties is the discovery of how the data are to fit together. Using the test set of file as an example, with a little exploration you find that there are six values in the y-test file, these correspond to the activities listed in the activity-label file and that these map to the subjects in the subject file. from this it is clear that the test file contains all of the data measurements.

The first step I took was to download, unzip and move the files all into the same working directory. I then started to parse the feature file which contains the columns that we want to keep, i.e. all the columns the have either mean() or std() information. I used these columns to set a variable called keep that I will use later on the test files to copy only those columns needed for our data set.

Next I added an index to the subject and y files and combined them using merge. I set the column names to Subject and Activity. Then I subset the test file using the keep variable, add an index and merge this with the combined data from the previous step. I repeat this process for the train files and I now have two pieces of the cleaned data set that are ready to combine.

Using rbind I now combined the two pieces the were produced by the above steps. I ordered the data, first by subject an then by activity. finally I removed the index column and I now have a clean data set that is ready to work with.

The next step was to change the column names and the activity names to comthing more meaningfuk then numbers. Using the information from the activity-labels file I set the activity names to their corresponding names. I used parsed feature file, which contains the column names that I kept, to set the names of the columns for the variable that I kept. 

The final step of the preject was to create a summary of the data. To do this I used the melt and cast functions and produced a data set that shows the average value for each of the variables for each subject and each activity. Then I finally used the wtite.table function to produce a txt file.

Below is the information that was provided by the original authors of the study and their descriptions of the experiment, the data collection process and variable descriptions.

Feature Selection 
=================

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation

mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

The complete list of variables of each feature vector is available in 'features.txt'

