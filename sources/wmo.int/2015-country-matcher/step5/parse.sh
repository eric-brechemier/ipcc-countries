#!/bin/sh
# Requires: xsltproc
cd $(dirname "$0")
# Note: xsltproc outputs an extra empty line, then removed with head -n -1
xsltproc --novalid \
  parse.xsl ../step4/countrymatcher.html \
| head -n -1 \
> data.csv
cp data.csv ..
