#!/bin/sh
# Requires: xsltproc
cd $(dirname "$0")
xsltproc --novalid \
  parse.xsl ../step2/members.html > data.csv
cp data.csv ..
