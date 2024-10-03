#!/bin/bash

folder_name=$(basename "$1")

# Compressing the folder

tar -czvf "$folder_name.tar.gz" "$1"

echo "Folder is compressed"


# Backing the folder

destination="$2"

if [[ ! -d "$destination" ]]; then
    mkdir -p "$destination"
    echo "Created backup directory: $destination"
fi

echo "The Destination is: $destination"

cp -r "$1" "$destination"

echo " Backup created "