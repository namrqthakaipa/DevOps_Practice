#!/bin/bash

# You needs to print a given Number say 10572, 
# in reverse order using a Shell script such that 
# the input is provided using command Line Argument 
# only. If the input data is not provided as Command 
# Line Argument, it should throw and error and should suggest, 
# how to use the script. Write the script but before that tell me 
# the algorithm that needs to be implemented here.

if [ $# -ne 1 ]
then
    echo "The number of rguments should be more that the 1"
    exit 1
fi

n=$1
rev=0
sd=0
while [ $n -gt 0 ]
do 
    sd=$((n % 10))
    rev=$(($rev * 10 + $sd))
    n=$(($n / 10))
done
echo "Reverse is $rev"