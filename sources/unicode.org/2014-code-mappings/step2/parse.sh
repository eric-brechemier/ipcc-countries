#!/bin/sh
# Requires: xsltproc
cd "$(dirname "$0")"

xsltproc --novalid parse.xsl ../step1/supplementalData.xml |
xsltproc xml2csv.xsl - \
> data.csv
cp data.csv ..
