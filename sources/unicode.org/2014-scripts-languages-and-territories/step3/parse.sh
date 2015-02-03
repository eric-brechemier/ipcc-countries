#!/bin/sh
# Requires: xsltproc
cd $(dirname "$0")
xsltproc --novalid \
  --maxdepth 20000 \
  parse.xsl \
  ../step2/scripts_languages_and_territories.html \
  > data.csv
cp data.csv ..
