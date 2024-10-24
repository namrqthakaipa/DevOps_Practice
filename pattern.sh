#! /bin/bash

#Pattern
#1
#1 2
#1 2 3
#1 2 3 4

echo "enter the number"
read num

echo "The entered number is $num " 

n=0

for ((i=1; i<num ; i++)) 
do
	for ((j=1;j<=i;j++))
	do
		
		echo -n "$j"
	done
	echo " "
done