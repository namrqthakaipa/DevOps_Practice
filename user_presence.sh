#!/bin/bash


if [ -z "$1" ]; then
    echo "enter the argument"
    exit 1
fi

username=$1


user_list=$(cut -d: -f1 /etc/passwd | tr '\n' ' ')

# cut is used to remove sections from lines of file 
# tr is used to replace or translate 

if echo "$user_list" | grep -qw "$username"; then
#grep -q is used to  check for the existence of a pattern 
# -w will search for the exact word.
    echo "User '$username' exists on this system."
else
    echo "User '$username' does not exist on this system."
fi