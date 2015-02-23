#!/bin/sh
# Requires: xsltproc
cd $(dirname "$0")

file='Gallery_of_flags_of_dependent_territories.html'
# Note: xstlproc outputs an extra empty line, then removed with head -n -1
xsltproc --novalid \
  parse.xsl \
  "../step2/$file" \
| head -n -1 \
> data.csv
cp data.csv ..
