#!/bin/bash
# @ Ayan Aharya, Date: Nov 19, 2011
# file for sift feature extraction

echo "process starts..."

echo "$ipfilename"

ipfilename=$1                 
opfilename=$2
./sift -o $opfilename $ipfilename

echo "process done..."

exit #  The right and proper method of "exiting" from a script.
     #  A bare "exit" (no parameter) returns the exit status
     #+ of the preceding command. 
