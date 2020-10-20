#!/bin/bash

TOOLS_HOME=$(pwd)
mkdir $TOOLS_HOME/$1.recon
cd $TOOLS_HOME/$1.recon

$TOOLS_HOME/getAllHeadersandResponses.sh subdomains_$1.txt
$TOOLS_HOME/getJSFiles.sh
$TOOLS_HOME/getLinks.sh
