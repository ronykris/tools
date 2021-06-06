#!/bin/bash
set -x
TOOLS=/root/recon/tools
OUTDIR=$TOOLS/sonarcloud.io.recon

massdnscmd="/root/recon/massdns/bin/massdns -r /root/recon/massdns/lists/resolvers.txt -q -t A -o S -w sonarcloud.io-online.{}.txt {}"
cd $OUTDIR

../mysplitter.sh -f $OUTDIR/sonarcloud.io.stub  -t 20 -c "${massdnscmd}" -d sonarcloud.io
cat sonarcloud.io-online.split* | tee sonarcloud.io-online.txt
rm -rf sonarcloud.io-online.split* split*
