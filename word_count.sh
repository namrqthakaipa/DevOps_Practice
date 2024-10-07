#!/bin/bash

echo " Program to have a word count "

filename=$1

if [ ! -f "$filename" ]
then
	echo "file dosent exist "
	exit 1
fi

word="ABC"

count=$(wc -w < "$filename" | awk '{print $1}')
lines=$(wc -l < "$filename" | awk '{print $1}')
charecters=$(wc -c < "$filename" | awk '{print $1}')

word_count=$(grep -o -i "$word" "$filename" | wc -l)

echo "The number of words in the given text is $count"

echo " The number of lines in the given text is $lines "

echo " The number of charecters in the given text is $charecters "

echo " The number ABC Charecters is $word_count"
