#!/bin/sh
# Requires: xsltproc
cd "$(dirname "$0")"

xsltproc parse.xsl ../step1/backlinks.xml |
xsltproc xml2csv.xsl - \
> data.csv
cp data.csv ..
