#!/bin/bash

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

TOOLS=/root/recon/tools
TARGET=$TOOLS/$domain.recon
PORTFILE=$TARGET/$domain.ports.txt

for port in `sed '/^$/d' "${PORTFILE}"`; do
  url="$domain:$port"
  http=false
  https=false
  protocol=""

  if [[ $(echo "http://$url" | online) ]]; then http=true; else http=false; fi
  if [[ $(echo "https://$url" | online) ]]; then https=true; else https=false; fi

  if [[ "$http" = true ]]; then protocol="http"; fi
  if [[ "$https" = true ]]; then protocol="https"; fi

  if [[ "$http" = true && "$https" = true ]]; then
    # If the content length of http is greater than the content length of https, then we choose http, otherwise we go with https
    contentLengthHTTP=$(curl -s http://$url | wc -c)
    contentLengthHTTPS=$(curl -s https://$url | wc -c)
    if [[ "$contentLengthHTTP" -gt "$contentLengthHTTPS" ]]; then protocol="http"; else protocol="https"; fi

    if [[ "$port" == "80" ]]; then protocol="http"; fi
    if [[ "$port" == "443" ]]; then protocol="https"; fi
  fi

  if [[ ! -z "$protocol" ]]; then
    echo "$protocol://$domain:$port"
  fi
done
