#!/bin/sh
# Requires: xsltproc
cd "$(dirname "$0")"

xsltproc parse-meta.xsl ../step1/*.xml > meta.txt
lines=$(wc -l meta.txt | cut -d' ' -f1)
echo "Update $lines first lines of meta.txt:"
cat meta.txt
tail -n "+$lines" ../meta.txt >> meta.txt
cp meta.txt ..

xsltproc parse-data.xsl ../step1/*.xml > data.csv
cp data.csv ..
