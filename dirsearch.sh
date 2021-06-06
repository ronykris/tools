#!/bin/bash

usage() { echo "Usage: $0 [-u subdomains.com.txt]" 1>&2; exit 1; }

while getopts ":u:" opt; do
        case ${opt} in
                u)
                        url=${OPTARG}
                        ;;
                *)
                        usage
                        ;;
        esac
done

if [[ -z "${url}" ]];
then
        echo "[-] No subdomains list supplied. Use -u subdomains.com.txt"
        echo "[!] Exiting..."
        exit 1
fi

exec /root/recon/dirsearch/dirsearch.py -l $url -e php,asp,aspx,jsp,py,txt,conf,config,bak,backup,swp,old,db,sqlasp,aspx,aspx~,asp~,py,py~,rb,rb~,php,php~,bak,bkp,cache,cgi,conf,csv,html,inc,jar,js,json,jsp,jsp~,lock,log,rar,old,sql,sql.gz,sql.zip,sql.tar.gz,sql~,swp,swp~,tar,tar.bz2,tar.gz,txt,wadl,zip -r --full-url -i 200
