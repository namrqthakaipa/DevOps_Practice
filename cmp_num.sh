#!/bin/bash

echo "Enter three numbers"

read num1 num2 num3

sum=$((num1 + num2))

echo "The sum of first two numbers are: $sum"

if [ $sum -eq $num3 ] 
then

	echo "It's equal"

else
	echo " Not equal"

fi