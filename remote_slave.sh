#!/bin/bash

# Script to manually initiate and collect scans from remote scanners

declare -a scanner=()
declare -a target=()

#Function to ssh in and start the initialization script on the scanners
#Takes two arguments (in order), scanner ip, target ip 
init_vas()
{
echo "$2" > target.vas
scp -i /root/Documents/openvas/.slavekey.priv target.vas root@$1:/root/target.vas
ssh -i /root/Documents/openvas/.slavekey.priv root@$1 "
bash vas.start
echo 'Press ctrl+c to continue'
exit
"
clear
}


mkdir openvastemp
cd openvastemp

clear
echo "--------------------------------"
echo "------------Welcome-------------"
echo "Input methods for scanners and targets"
echo ""
echo "[1] CSV"
echo "[2] Manually (not recommended)"
echo "[3] Exit"
echo ""

read -p "Please select an option: " input_method

if [ $input_method -eq 3 ]; then
	exit 0;

elif [ $input_method -eq 1 ]; then
	clear
	echo "--------------------------------"
	echo "--------Input File Name---------"
	read -p "Please enter the file path and name [/path/to/file.csv]: " in_file
	
	num_lines=0
	
	while read -r line
	do
		scanner[$num_lines]="$(echo $line | awk -F',' '{ print $1 }')"
		target[$num_lines]="$(echo $line | awk -F',' '{ print $2 }')"
		echo "Scanner: ${scanner[$num_lines]}"
		echo "Target: ${target[$num_lines]}"
		echo "Number: $num_lines"
		num_lines=$((num_lines+1))
	done <"$in_file"
fi

for (( i=0; i<$num_lines; i++ ));
do
	clear
	echo "Connecting to Scanner: ${scanner[$i]}"
	echo "Adding Target: ${target[$i]}"
	init_vas ${scanner[$i]} ${target[$i]}
done

cd .. && rm -rf openvastemp
