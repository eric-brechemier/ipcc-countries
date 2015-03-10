#!/bin/sh
# Requires: xsltproc
cd "$(dirname "$0")"

xsltproc parse-meta.xsl ../step1/*.xml > meta.txt
lines=$(wc -l meta.txt | cut -d' ' -f1)
start=$(expr $lines + 1)
cat meta.txt
tail -n "+$start" ../meta.txt >> meta.txt
cp meta.txt ..

xsltproc parse-data.xsl ../step1/*.xml > data.csv
cp data.csv ..
