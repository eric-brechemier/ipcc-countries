#!/bin/sh
# Requires: xsltproc
cd $(dirname "$0")

xsltproc --novalid \
  parse.xsl ../step4/countrymatcher.html \
> data.csv
cp data.csv ..
