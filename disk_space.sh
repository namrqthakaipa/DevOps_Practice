#!/bin/bash

storage=$(df -h) 

current_treshold=$( df / | grep -v Filesystem | awk '{print $5}' | sed 's/%//' )

echo "The storage structure is: "

echo 

echo "$storage"

echo "The currect threshold is: $current_treshold"

echo 

read -p "Enter threshold you want to set it:" input_threshold


echo "The input threshold is : $input_threshold"

echo

if [ $current_treshold -gt $input_threshold ]; then
	echo "The currect storage is greater that Threshold"
else 
	echo "The currect storage is lesser that Threshold"
fi

