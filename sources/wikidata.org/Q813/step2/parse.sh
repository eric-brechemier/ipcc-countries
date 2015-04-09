#!/bin/sh
# Requires: xsltproc
cd "$(dirname "$0")"

# read file name from meta.txt
file=$(grep '^File:' ../meta.txt | cut -d' ' -f2)

xsltproc parse-meta.xsl "../step1/$file" > meta.txt
lines=$(wc -l meta.txt | cut -d' ' -f1)
start=$(expr $lines + 1)
cat meta.txt
tail -n "+$start" ../meta.txt >> meta.txt
cp meta.txt ..

xsltproc parse-data.xsl "../step1/$file" |
xsltproc xml2csv.xsl - \
> data.csv
cp data.csv ..
