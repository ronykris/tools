#!/bin/bash

Help()
{
   # Display Help
   echo
   echo "Syntax: hiddenparamfinder.sh domain.txt"
   echo "options:"
   echo "h     Print this Help."
   echo
}
while getopts ":h" option; do
   case $option in
      h) # display Help
         Help
         exit;;
     \?) # incorrect option
         echo "Error: Invalid option"
         exit;;
   esac
done


TOOLS_HOME=$(pwd)
mkdir $TOOLS_HOME/$1.param

cat $1 | waybackurls | tee -a $TOOLS_HOME/$1.param/$1.urls.txt
#assetfinder $1 -subs-only | waybackurls | tee -a $TOOLS_HOME/$1.param/$1.urls.txt
#lines = `wc -l $TOOLS_HOME/$1.param/$1.urls.txt`
#mkdir $TOOLS_HOME/$1.param/temp

cat $TOOLS_HOME/$1.param/$1.urls.txt | hakcheckurl | sed -e 's/^200\ //g' | grep -v '[0-9]' | tee $TOOLS_HOME/$1.param/$1.urls.200.txt
cat $TOOLS_HOME/$1.param/$1.urls.200.txt | uniq | grep -v "robot" | tee $TOOLS_HOME/$1.param/$1.urls.200.uniq.txt
touch $TOOLS_HOME/$1.param/$1.urls.param.txt
cat $TOOLS_HOME/$1.param/$1.urls.200.uniq.txt | while read url;
do
	curl -s -L $url | grep \"hidden\" | egrep -o "name=('|\")[a-z_A-Z_0-9-]*('|\")" | sed -e 's/\"/=/g' -e "s|name==|$url/?|g" | tee -a $TOOLS_HOME/$1.param/$1.urls.param.txt;
done
cat $TOOLS_HOME/$1.param/$1.urls.param.txt | sort -u | tee $TOOLS_HOME/$1.param/$1.urls.hiddenparam.txt
