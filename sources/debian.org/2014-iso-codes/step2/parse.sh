#!/bin/sh
# Requires: xsltproc
cd $(dirname "$0")

xsltproc --novalid \
  parse.xsl ../step1/iso_3166.xml \
> data.csv
cp data.csv ..
