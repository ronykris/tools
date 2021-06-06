#!/bin/bash

usage() { echo "Usage: $0 [-d domain.com]" 1>&2; exit 1; }

while getopts ":d:" opt; do
        case ${opt} in
                d)
                        domain=${OPTARG}
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

TOOLS=/root/recon/tools
OUTDIR=$TOOLS/$domain.recon
PARAMSPIDER=/root/recon/ParamSpider
f_out=$OUTDIR/$domain.paramspider.txt
final_out=$OUTDIR/$domain.paramspider.final.txt

while read -r line
	do
		t_out=$OUTDIR/$line.paramspider.txt
		python3 $PARAMSPIDER/paramspider.py -d $line -e png,woff,jpg,svg -l high -o $t_out
		cat $t_out | tee -a $f_out
		rm -rf $t_out
	done < $OUTDIR/assets_$domain.txt
cat $f_out | uniq | tee -a $final_out
rm -rf $f_out
