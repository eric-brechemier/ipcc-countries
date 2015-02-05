#!/bin/sh
# Requires: xsltproc
cd $(dirname "$0")
# Note: xsltproc outputs an extra empty line, then removed with head -n -1
xsltproc --novalid \
  parse.xsl ../step1/iso_3166.xml \
| head -n -1 \
> data.csv
cp data.csv ..
