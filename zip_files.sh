#!/bin/bash


if [ "$#" -lt 2 ]; then
    echo "The number of arguments is less"
    exit 1
fi

archive_name=$1
shift  

# Create the text files
for file in "$@"; do
    echo "Creating file: $file"
    touch $file
done


zip $archive_name $@  ||
 
echo " The Archive of file has failed"
