#!/bin/bash
#set -x

usage() { echo "Usage: $0 [-d domain.com]" 1>&2; exit 1; }

while getopts ":d:" opt; do
	case ${opt} in
		d)
			domain=${OPTARG}
			;;
		*)
			uasge
			;;
	esac
done

if [[ -z "${domain}" ]];
then
	echo "[-] No domain supplied. Use -d domain.com"
	echo "[!] Exiting..."
	exit 1
fi


TOOLSDIR=/root/recon/tools
TARGET=$TOOLSDIR/$domain.recon
PORTFILE=$TARGET/$domain.ports.txt
NMAPSCAN=$TARGET/$domain.nmap.txt

echo "[+] doing masscan..."
masscan $(dig +short $domain | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | head -1) -p0-10001 --rate 1000 --wait 3 2> /dev/null | grep -o -P '(?<=port ).*(?=/)' | tee -a ${PORTFILE}
echo "[+] doing nmap scan..."
nmap -p $(cat ${PORTFILE} | paste -sd "," -) $(dig +short ${domain} | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | head -1) | tee -a ${NMAPSCAN}



