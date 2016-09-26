#!/bin/bash

clear
echo "--------------------------------"
echo "--------Input File Name---------"
read -p "Please enter the file path and name [/path/to/file.csv]: " in_file

while read -u10 line
do 
	scanner=$(echo $line | awk -F',' '{ print $1 }')
	echo "Initializing $scanner"
	ssh -i /root/Documents/openvas/.slavekey.priv root@$scanner "
	./vas.init &>/dev/null &
	disown
	"
done 10<"$in_file"


echo "Back"
