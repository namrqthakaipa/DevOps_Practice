#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Enter more numbers"
    exit 1
fi

largest=$1


for i in "$@"; do
   
    if [ $i -gt $largest ]; then
        largest=$i
    fi
done

echo "$largest"