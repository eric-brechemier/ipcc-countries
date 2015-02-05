#!/bin/sh
# Requires: xsltproc
cd $(dirname "$0")
# Note: xstlproc outputs an extra empty line, then removed with head -n -1
# Note(2): --maxdepth increases the size of allowed recursion stack
xsltproc --novalid \
  --maxdepth 20000 \
  parse.xsl \
  ../step2/scripts_languages_and_territories.html \
| head -n -1 \
> data.csv
cp data.csv ..
