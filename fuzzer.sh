#!/bin/bash

TOOLS=/root/recon
inputfile = $1
while IFS= read -r line
do
	#echo $line | tee -a $1.ffuf	
	ffuf -u "$line/FUZZ" -w $TOOLS/SecLists/Discovery/Web-Content/common.txt | tee -a $1.ffuf
done < "$1"
