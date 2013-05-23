#!/bin/bash
# @ Ayan Aharya, Date: Nov 19, 2011
# file for condor submission

echo "condor submission starts..."

LIMIT=$1                 
expname=$2
a=1

while [ "$a" -le $LIMIT ]
do
  # echo "condor_submit run_$expname$a.sh"
  condor_submit run_$expname$a.sh 
  let "a+=1"
done                 

echo "condor submission done..."

exit #  The right and proper method of "exiting" from a script.
     #  A bare "exit" (no parameter) returns the exit status
     #+ of the preceding command. 
