#!/bin/bash


TOOLS=$(pwd)
mkdir $TOOLS/$1.recon
cd $TOOLS/$1.recon
curl -s https://certspotter.com/api/v0/certs\?domain\=$1 | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $1 |tee 1.txt
curl -s https://crt.sh/?Identity=%.$1 | grep ">*.$1" | sed 's/<[/]*[TB][DR]>/\n/g' | grep -vE "<|^[\*]*[\.]*$1" | sort -u | awk 'NF' | tee 2.txt
subfinder.sh $1 
assetfinder $1 -subs-only | tee $1.assets.txt
amass enum -o $1.amass -d $1
cat 1.txt 2.txt $1.txt $1.assets.txt $1.amass | sort -u | httprobe -prefer-https |sort -u |tee subdomains_$1.txt
cat subdomains_$1.txt | sed 's|^https://||g' | sed 's|^http://||g' | tee assets_$1.txt
#cat subdomains_$1.txt | sort -u > subdomains_$1.txt
rm 1.txt 2.txt 

