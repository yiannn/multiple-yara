#!/bin/bash
OIFS="$IFS"
IFS=$'\n'
echo "Output file location: ${PWD}/output.txt"

read -p "Input rules location(full path):" -r rules

read -p "location of file/folder to scan:" -r location
read -p "extension of files to scan (if only one file, input here the file's extension). To scan every file in folder,leave empty.:" -r extension

if [ -z "$extension" ]
then
	printf "\n======\nRESULTS\n" > output.txt && 
	for p in $(find $rules -type f -name "*.yar");
	do yara -rw $p $location; 
	done >> output.txt &&  for p in $(find $rules -type f -name "*.yara"); do yara -wr $p $location  ; done >> output.txt
else
	printf "\n======\nRESULTS\n" > output.txt && 
	for k in $(find $location -type f -name "*.${extension}");
	do
		for p in $(find $rules -type f -name "*.yar"); 
		do
			yara -rw $p $k; 
		done >> output.txt &&  
		
		for p in $(find $rules -type f -name "*.yara"); 
		do 
		yara -wr $p $k; 
		done >> output.txt
	done
fi

cat output.txt
IFS="$OIFS"
exit 0
