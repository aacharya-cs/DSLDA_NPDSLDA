1. run prepconfdata(maxtags) with varying number of maxtags i.e. maximum number of tags...the foiles will be written by <conference_name>_data.mat in the current folder; modify forbidden tags inside this file if necessary..point to the directories for "tag", "abstract" and "tagdistribution"..I have already shared them with you via dropbox..these folders are available under confdatarefined. 

2. run split_train_test_confdata(sourcepath,savepath) to split the datasets into training and test set -- sourcepath is the path to the files whose names are <conference_name>_data.mat, output is written to "savepath" with names <conference_name>_train.mat or <conference_name>_test.mat -- you wil find some files already inside the forconfdata/ 
folder which were obtained with maxtags = 25;

3. run mainfile_confdata() under the folder myLDA; details of the arguments for this matlab function are listed inside the file. 
If you want to run on condor, this one will be the gateway file.

4. look for example on how I run on condor inside the folder mccfiles/ . the main file there is compile_mcc_confdata.m..look for instructions inside the file if needed..there are some other files inside this folder that correspond to the vision data that I am using. 

