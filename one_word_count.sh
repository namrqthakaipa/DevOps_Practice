#!/bin/bash


echo "Enter the file name :"
read file

echo "enter the word to search"
read word


count=$(grep -o -w "$word" "$file"  | wc -l)

echo "The count is $count"