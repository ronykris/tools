#!/bin/bash
mkdir links
OUTFILE=links/endpoints.txt
touch $OUTFILE
#mkdir scriptsresponse
RED='\033[0;31m'
NC='\033[0m'
CUR_PATH=$(pwd)
LINKFINDER_PATH=/root/recon
for x in $(ls "$CUR_PATH/scripts")
do
        printf "\n\n${RED}$x${NC}\n\n" | tee -a $OUTFILE
        END_POINTS=$(cat "$CUR_PATH/scripts/$x")
        for end_point in $END_POINTS
        do
		echo $end_point | tee -a $OUTFILE
		python3 $LINKFINDER_PATH/LinkFinder/linkfinder.py -i  $end_point -o cli | tee -a $OUTFILE
                #len=$(echo $end_point | grep "http" | wc -c)
                #mkdir "scriptsresponse/$x/"
                #URL=$end_point
                #if [ $len == 0 ]
                #then
                #        URL="https://$x$end_point"
                #fi
                #file=$(basename $end_point)
                #curl -X GET $URL -L > "scriptsresponse/$x/$file"
                #echo $URL >> "scripts/$x"
        done
done

