#!/bin/bash

clear
echo "hello"
list=($(ls path))
len=${#list[@]}
let len=len-1
counter=0
while [ $counter -lt $len ]; do
	if [[ ${list[$counter]} == yolo-obj-big_*000.weights ]] || [[ ${list[$counter]} == yolo-obj-big_*500.weights ]]; then
		echo good ;	
	elif [[ ${list[$counter]} == yolo-obj-big_* ]]; then
		rm -f path/${list[$counter]};		
	fi
	let counter=counter+1
done

