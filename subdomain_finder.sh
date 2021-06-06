#!/bin/bash

usage() { echo "Usage: $0 [-d domain.com] [-s subdomain-wordlist.txt]" 1>&2; exit 1; }

while getopts ":d:s:" opt; do
	case ${opt} in
		d)
			domain=${OPTARG}
			;;
		s)
			subs=${OPTARG}
			;;
		*)
			usage
			;;
	esac
done

if [[ -z "${domain// }" ]];
then
	echo "[-] No domain supplied. Use -d domain.com"
	echo "[!] Exiting..."
	exit 1
fi

if [[ -z "${subs// }" ]];
then
	echo "[-] No subdoamin wordlist supplied. Use -s subdomains.txt"
	echo "[!] Exiting..."
	exit 1
fi



TOOLS=$(pwd)
mkdir $TOOLS/$domain.recon
cd $TOOLS/$domain.recon

while read -r line
	do
		echo "$line.$domain" >> $domain.stub
	done < ../$subs

../../massdns/bin/massdns -r  ../../massdns/lists/resolvers.txt -q -t A -o S -w "$domain-online.txt" "$domain.stub"
awk -F ". " '{print $1}' "$domain-online.txt" > "$domain-filtered.txt" && "$domain-filtered.txt" "$domain-online.txt"


curl -s https://certspotter.com/api/v0/certs\?domain\=$domain | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $domain |tee 1.txt
curl -s https://crt.sh/?Identity=%.$domain | grep ">*.$domain" | sed 's/<[/]*[TB][DR]>/\n/g' | grep -vE "<|^[\*]*[\.]*$domain" | sort -u | awk 'NF' | tee 2.txt
subfinder.sh $domain 
assetfinder $domain -subs-only | tee $domain.assets.txt
amass enum -o $domain.amass -d $domain
cat $domain-online.txt 1.txt 2.txt $domain.txt $domain.assets.txt $domain.amass | sort -u | httprobe -prefer-https |sort -u |tee subdomains_$domain.txt
cat subdomains_$domain.txt | sed 's|^https://||g' | sed 's|^http://||g' | tee assets_$domain.txt
#cat subdomains_$domain.txt | sort -u > subdomains_$domain.txt
rm 1.txt 2.txt 

