#!/bin/bash

FILE="/home/namratha/DevOps/Shell_folder/cpu_file1.txt"

if [ -f "$FILE" ]; then
	sudo rm -f "$FILE"
else 
	sudo touch "$FILE"
	top >> $FILE

fi