#!/bin/bash
#SCRIPT: extractSIFT_from_all.h
#PURPOSE: Reads filepaths and computes SIFT features for all files

FILENAME=$1
count=0

while read LINE
do
      let count++
      opfilename=$LINE.txt
      echo "$LINE"
      ./sift -b $LINE
done < $FILENAME

echo -e "\nTotal $count Lines read"
