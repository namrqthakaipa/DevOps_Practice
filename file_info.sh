#!/bin/bash

current_dir=$(pwd)

echo "File Information in Directory: $current_dir"

printf  "Filename    Size      Permission        Type \n"


for file in "$current_dir"; do
  
    if [ -e "$file" ]; then
        filename=$(basename "$file")
        filesize=$(stat -c%s "$file")
        permissions=$(stat -c%A "$file")
        
        if [ -d "$file" ]; then
            filetype="Directory"
        elif [ -f "$file" ]; then
            filetype="File"
        else
            filetype="Other"
        fi
        
        printf "%s %s %s %s\n" "$filename" "$filesize" "$permissions" "$filetype"
    fi
done
