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



TOOLS=/root/recon/tools
OUTDIR=$TOOLS/$domain.recon
mkdir $OUTDIR

cd $OUTDIR

#while read -r line
#	do
#		echo "$line.$domain" >> $domain.stub
#	done < ../$subs

#stubcmd="echo {}.${domain} >> ${domain}.stub"
#$TOOLS/mysplitter.sh -f $TOOLS/$subs -t 20 -c "${stubcmd}" -d $domain

cat ../$subs | parallel "echo {}.${domain} >> ${domain}.stub"
if [ -s $domain.stub ]
then
    echo "[+] " $domain.stub "file created!"
else
    echo "[-] " $domain.stub "file does not exist."
    echo "[!] Exiting..."
    exit 1
fi

massdnscmd="/root/recon/massdns/bin/massdns -r /root/recon/massdns/lists/resolvers.txt -q -t A -o S -w $domain-online.{}.txt {}"

$TOOLS/mysplitter.sh -f $OUTDIR/$domain.stub  -t 20 -c "${massdnscmd}" -d $domain
cat $domain-online.split* | tee $domain-online.txt
rm -rf $domain-online.split* split*
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

