#!/bin/bash

#1
#2 3
#4 5 6
#7 8 9 10



echo "Enter the number"
read num

n=1
echo "The entered number is $num " 

for ((i=1; i<num ; i++)) 
do
	for ((j=1;j<=i;j++))
	do
		
		echo -n "$n"
		n=$((n+1))
	done
	echo " "
done