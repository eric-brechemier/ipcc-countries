#!/bin/sh
# Requires: xsltproc
cd $(dirname "$0")

# --maxdepth increases the size of allowed recursion stack
# which is needed due to the high level of recursion in the table parsing
xsltproc --novalid \
  --maxdepth 20000 \
  parse.xsl \
  ../step2/scripts_languages_and_territories.html \
> data.csv
cp data.csv ..
