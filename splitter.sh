#!/bin/bash

usage() { echo "Usage: $0 [-d domain.com] [-s subdomains.txt] [-t no. of files to split into]" 1>&2; exit 1; }

while getopts ":d:s:t:" opt; do
        case ${opt} in
                d)
                        domain=${OPTARG}
                        ;;
                s)
                        subs=${OPTARG}
                        ;;
		t)
			files=${OPTARG}
			;;
                *)
                        usage
                        ;;
        esac
done

if [[ -z "${domain}" ]];
then
        echo "[-] No domain supplied. Use -d domain.com"
        echo "[!] Exiting..."
        exit 1
fi

if [[ -z "${subs}" ]];
then
        echo "[-] No subdomain list supplied. Use -s subdomains.txt"
        echo "[!] Exiting..."
        exit 1
fi

if [[ -z "${files}" ]];
then
        echo "[-] No subdomain list supplied. Use -s subdomains.txt"
        echo "[!] Exiting..."
        exit 1
fi

TOOLS=/root/recon/tools
OUTDIR=$TOOLS/$domain.recon

t_lines=`wc -l < $subs`
s_line=$(($t_lines/$files))
cd $OUTDIR
split -l $s_line -d $subs split.$subs
ls split.* | parallel $TOOLS/hiddenparamfinder.sh -d $domain -s 
