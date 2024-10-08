#!bin/bash

read "Enter the file to search" FILENAME

if [ ! -f $FILENAME ]
then
	echo "The file is not present"
else
	echo "The file is present"