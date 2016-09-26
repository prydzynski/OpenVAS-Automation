#!/bin/bash

target=$(head -1 vas.target)
name=$(date +%D)

omp -u admin -w password -T | grep "$target" > target

if [ -s target ]; then
	targetid=$(head -c 36 target)
else
	omp -u admin -w password --xml="
	<create_target>
	<name>"$target"</name>
	<hosts>"$target"</hosts>
	</create_target>"

	omp -u admin -w password -T | grep "$target" > target
	targetid=$(head -c 36 target)
fi

omp -u admin -w password --xml="
<create_task>
<name>$name</name>
<config id='708f25c4-7489-11df-8094-002264764cea'/>
<target id='$targetid'/>
</create_task>"

omp -u admin -w password -G | grep "$name" > scan
scanid=$(head -c 36 scan)
omp -u admin -w password --xml="<start_task task_id='$scanid'/>"
