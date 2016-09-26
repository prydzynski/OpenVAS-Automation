#!/bin/bash

let itemsCount=$(xmllint --xpath 'count(//slave)' test)
declare -a names=( )

for (( i=1; i <= $itemsCount; i++ )); do 
    names[$i]="$(xmllint --xpath 'string(//slave['$i']/name/text())' test)"
    ids[$i]="$(xmllint --xpath 'string(//slave['$i']/@id)' test)"
done

for (( i=1; i <= $itemsCount; i++ )); do
	echo "ID: ${ids[$i]}     Name: ${names[$i]}"
done

read -p "Select a slave by name: " slave
for (( i=1; i <= $itemsCount; i++ )); do
	if [ "$slave" == "${names[$i]}" ]; then
		id=${ids[$i]}
	fi
done
echo $id
