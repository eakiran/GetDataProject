GetDataProject
==============
This script downloads wearable device data, removes unwanted data, merges test
and train data and summarizes the information of each variable by subject
observed (subjects 1 through 30) and by activity type (walking, standing...)

Working directory for downloading and unzipping the files
Zipped file is downloaded to c:/Users/Public/
Working directory for R is set to the same directory for ease of use

All needed files are read into the tables described below:

features  - table with measured variables
xTest     - table with measured values during testing phase
yTest     - table with activity number for each row in xTest (1:6)
subjTest  - table with numbers corresponding to subject (1:30) 
xTrain    - table with measured values during training phase
yTrai     - table with activity number for each row in xTrain (1:6)
subjTrain - table with numbers corresponding to subject (1:30)
activNames - table with activity numbers and corresponding activity description in plain English


variables - used to obtain the names of the columns for the measured variables
            and receive cleaned names - without unwanted characters

After all data tables are "filled" and column names are assigned, the tables are merged together.
xTest and xTrain are merged into xAll.
yTest and yTrain are merged into yAll.
yAll is combined with activNames using a loop to associate the activity number with the activity
    description without losing the sequence forming yAllEnglish
subjTest and subjTrain are merged into subjAll.

xAll, yAll and subjAll combine test and train data.
All three are merged together using cbind, forming tidyData with all data from downloaded files.

variablesNeeded - receives all variable names that are of interest.
    It is used to cut unwanted data.
    The choice for wanted / unwanted data was made based on if it was a "final data" or not.
    XYZ components were excluded as well as banded variables.
    Only variables with mean and std names were preserved.
    
tidyDataColVars - receives the names of the remaining variables so the main data can be molten.

The initial tidyData is molten and cast so averages can be calculated by subject and activity.
Results are exported to tidyData2 in txt tab separated format into the working directory.
