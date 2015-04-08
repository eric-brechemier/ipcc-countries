#!/bin/sh
# Requires: xsltproc
cd "$(dirname "$0")"

xsltproc --novalid parse.xsl ../step2/growth.shtml |
xsltproc xml2csv.xsl - \
> data.csv
cp data.csv ..
