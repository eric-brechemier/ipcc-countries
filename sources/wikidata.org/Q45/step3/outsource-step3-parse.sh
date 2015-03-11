#!/bin/sh
# Requires: xsltproc
cd "$(dirname "$0")"

input='step2'

# read file name from meta.txt
file=$(grep '^File:' ../meta.txt | cut -d' ' -f2)

# read URL from meta.txt
url=$(grep '^URL:' ../meta.txt | cut -d' ' -f2)

xsltproc \
  --stringparam url "$url" \
  --stringparam file "$file" \
  parse-meta.xsl "../$input/$file" > meta.txt
# replace meta.txt with updated version
cp meta.txt ..

imageFile="data/$(basename "$file" .html).svg"
xsltproc \
  --stringparam imageFile "$imageFile" \
  parse-data.xsl "../$input/$file" > data.csv
cp data.csv ..
