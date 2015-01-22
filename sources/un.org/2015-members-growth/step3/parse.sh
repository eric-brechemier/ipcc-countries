#!/bin/sh
# Requires: xsltproc
cd $(dirname "$0")
xsltproc --novalid \
  parse.xsl ../step2/growth.shtml > data.csv
cp data.csv ..
