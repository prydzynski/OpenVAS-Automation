#!/bin/bash

mkdir openvastmp
cd openvastmp

line=$(head -1 /root/vas.ext)

ext=$(echo $line | awk -F',' '{ print $1 }')
target=$(echo $line | awk -F',' '{ print $2 }')

if [ $ext == "html" ]; then
report="6c248850-1f62-11e1-b082-406186ea4fc5"
ext=html

elif [ $ext == "pdf"  ]; then
report="c402cc3e-b531-11e1-9163-406186ea4fc5"
ext=pdf

elif [ $ext == "txt" ]; then
report="a3810a62-1f62-11e1-9219-406186ea4fc5"
ext=txt

elif [ $ext == "xml" ]; then
report="a994b278-1f62-11e1-96ac-406186ea4fc5"
ext=xml

fi

omp -u admin -w password -G > vas.scan_id
scan_id=$(head -c 36 vas.scan_id)
echo "Scan id: $scan_id:"

omp -u admin -w password -iX "<get_tasks task_id='$scan_id' details='1'/>" | grep 'report id' > reportid
reportid=$(awk '{print substr($0,23,36)}' reportid | head -n 1)
echo "Report id: $reportid"

when=$(date +'%y-%m-%d')
ip=$(hostname -I)
out_file=$(echo ${when}_${target}.${ext})

echo $out_file

omp -u admin -w password --get-report $reportid --format $report > /root/reports/$out_file
