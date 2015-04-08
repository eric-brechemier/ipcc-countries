#!/bin/sh
# Requires: xsltproc
cd "$(dirname "$0")"

file='Gallery_of_flags_of_dependent_territories.html'
# Note: the transformation outputs an empty record at end of file,
# removed with head -n -1
xsltproc --novalid \
  parse.xsl \
  "../step2/$file" |
xsltproc xml2csv.xsl - |
head -n -1 \
> data.csv
cp data.csv ..
