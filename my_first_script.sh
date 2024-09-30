#!/bin/bash

echo "This is my first shell script"

echo "1. The present working directory is"

pwd

echo " =============================="

#####################################
echo "2. Listing all the present working directorys"

ls -ltr

echo "================================"

#####################################
echo "3. Navigate to the temp directory "

cd /tmp || {echo "failed to navigate to /temp";}

echo "================================"

#####################################
echo "4. Creating a newly created directory"

mkdir example_dir1

echo "================================"

#####################################
echo "5.Navigate to example_dir1"

cd example_dir1 || {echo "Failed to navigate"}

#####################################
echo "6. Create a new file and write text into it"

touch myfile.txt
echo "This is a sample text file. " > "myfile.txt"

#####################################
echo "7. Display the file "

cat myfile.txt

#####################################
echo "8.Copying myfile.txt to another location"

cp  myfile.txt /namratha/devOps/myfile_copy.txt

#####################################
echo "9.Moving myfile.txt to another location"

mv  myfile.txt /namratha/devOps/myfile_moved.txt

#####################################
echo "10. Deleting the copied file "
rm /namratha/devOps/myfile_copy.txt

#####################################
echo "11. Display system information"
uname -a

#####################################
echo "12. Display disk usage"
df -h

#####################################
echo "13. Display memory usage" 
free -h

#####################################
echo "14. Display current running process"
ps aux

input_file = "myfile"

search_string ="sample"

#####################################
echo "15. Find a string in the file"

if grep -q "$search_string" "$input_file"; then
    echo " the string exist"
else
    echo " dose not exist"
fi

#####################################
echo "16. Display last 1- lines of a file"
tail -n 10 myfile.txt

#####################################
echo "exit the script" 
exit 0