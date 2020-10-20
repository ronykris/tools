#!/bin/bash

Help()
{
	#Display help
	echo 
	echo "Syntax:rxss.sh target.com assets.txt endpoint.txt hiddenparam.txt"
	echo "options:"
	echo "h   Print this Help."
	echo
}
while getopts ":h" option; do
	case $option in
		h) # display help
		   Help
		   exit;;
		\?) # incorrect option
		   echo "Error: Invalid option"
		   exit;;
	esac
done

RED='\033[0;31m'
NC='\033[0m'
TOOLS_HOME=/root/recon
RECON_DIR=$TOOLS_HOME/$1.recon
OUTFILE=$RECON_DIR/$1.xss.txt
touch $OUTFILE

if [ -e $2 ];
then
	printf "\n${RED}$2\n"
	cat $2 | gau | grep '=' | qsreplace hack\" -a | while read url;do target=$(curl -s -l $url | egrep -o '(hack"|hack\\")'); echo -e "${NC}" "$url" "$target" | tee -a $OUTFILE; done 
fi

if [ -f $3 ];
then
	printf "\n${RED}$3\n"
	cat $3 | grep '=' | qsreplace hack\" -a | while read url;do target=$(curl -s -l $url | egrep -o '(hack"|hack\\")'); echo -e "${NC}" "$url" "$target" | tee -a $OUTFILE; done 
fi

if [ -f $4 ];
then
	printf "\n${RED}$4\n"
	cat $4 | grep '=' | qsreplace hack\" -a | while read url;do target=$(curl -s -l $url | egrep -o '(hack"|hack\\")'); echo -e "${NC}" "$url" "$target" | tee -a $OUTFILE; done
fi

cat $OUTFILE | sort -u | tee $OUTFILE
