#!/bin/bash

collect()
{
scp -i /root/Documents/openvas/.slavekey.priv vas.ext root@$1:/root/vas.ext
ssh -i /root/Documents/openvas/.slavekey.priv root@$1 "
bash vas.report
cd .. && rm -rf openvastmp
echo 'Press ctrl+c to continue'
exit
"
scp -i /root/Documents/openvas/.slavekey.priv root@$1:/root/reports/*$2* /root/Documents/openvas/reports
clear
}

clear
echo "--------------------------------"
echo "------------Welcome-------------"
echo "Input methods for scanners to collect reports from"
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
                num_lines=$((num_lines+1))
        done <"$in_file"
fi

clear
echo "--------------------------------"
echo "-------Report Output Type-------" 
echo "[1] HTML"
echo "[2] PDF"
echo "[3] Text"
echo "[4] XML"
echo "[5] Quit"
read -p "Select your desired report output format: " c
clear

if [ $c -eq 5 ]; then
	exit 0;

elif [ $c -eq 1 ]; then
	report="6c248850-1f62-11e1-b082-406186ea4fc5"
	ext=html

elif [ $c -eq 2 ]; then
	report="c402cc3e-b531-11e1-9163-406186ea4fc5"
	ext=pdf

elif [ $c -eq 3 ]; then
	report="a3810a62-1f62-11e1-9219-406186ea4fc5"
	ext=txt

elif [ $c -eq 4 ]; then
	report="a994b278-1f62-11e1-96ac-406186ea4fc5"
	ext=xml

fi


for (( i=0; i<$num_lines; i++ ));
do
        echo "$ext,${target[$i]}" > vas.ext
	clear
        echo "Connecting to Scanner: ${scanner[$i]}"
        echo "Collecting $ext report for target ${target[$i]}..."
        collect ${scanner[$i]} ${target[$i]}
done
