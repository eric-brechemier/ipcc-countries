#!/bin/sh
# Requires: xsltproc
cd "$(dirname "$0")"

file='Gallery_of_sovereign_state_flags.html'

# Note: the transformation returns an empty record at end of file,
# which is removed with head -n -1
xsltproc --novalid \
  parse.xsl \
  "../step2/$file" |
xsltproc xml2csv.xsl - |
head -n -1 \
> data.csv
cp data.csv ..
