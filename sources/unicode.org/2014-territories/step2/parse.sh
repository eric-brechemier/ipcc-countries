#!/bin/sh
# Requires: xsltproc
cd "$(dirname "$0")"

xsltproc --novalid parse.xsl ../step1/en.xml |
xsltproc xml2csv.xsl - \
> data.csv
cp data.csv ..
