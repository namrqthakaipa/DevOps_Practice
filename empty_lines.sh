#!/bin/bash


if [ "$#" -ne 1 ]; then
    echo "Provide the file name"
    exit 1
fi

file="$1"
temp_file="$(mktemp)"


sed '/^$/d' "$file" > "$temp_file"

mv "$temp_file" "$file"

echo "Empty lines removed from $file."

