#!/bin/bash

usage() { echo "Usage: $0 [-f filename to split] [-t no. of files to split into] [-c cmd or script to run] [-d domain]" 1>&2; exit 1; }

while getopts ":f:t:c:d:" opt; do
        case ${opt} in
                f)
                        filename=${OPTARG}
                        ;;
                t)
                        files=${OPTARG}
                        ;;
		c)
			script=${OPTARG}
			;;
		d)	
			domain=${OPTARG}
			;;
                *)
                        usage
                        ;;
        esac
done

if [[ -z "${filename}" ]];
then
        echo "[-] No file supplied. Use -f file.txt"
        echo "[!] Exiting..."
        exit 1
fi

if [[ -z "${files}" ]];
then
        echo "[-] No of files to split into was not specified. Use -t 10"
        echo "[!] Exiting..."
        exit 1
fi

if [[ -z "${script}" ]];
then
        echo "[-] No script to execute was supplied. Use -c scriptname with param"
        echo "[!] Exiting..."
        exit 1
fi

if [[ -z "${domain}" ]];
then
	echo "[-] No domain was supplied. Use -d domain.com"
	echo "[!] Exiting..."
	exit 1
fi

TOOLS=/root/recon/tools
OUTDIR=$TOOLS/$domain.recon

t_lines=`wc -l < $filename`
s_line=$(($t_lines/$files))
cd $OUTDIR
split -l $s_line -d $filename split.$domain
ls split.* | parallel $script  #specify full path to command if not in path
