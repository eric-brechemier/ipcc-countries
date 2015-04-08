#!/bin/sh
# Requires: xsltproc
cd "$(dirname "$0")"

file='Flags_of_extinct_states.html'

# an empty record is generated on last line, removed with head -n -1
xsltproc --novalid \
  parse.xsl \
  "../step2/$file" |
xsltproc xml2csv.xsl - |
head -n -1 \
> data.csv
cp data.csv ..
