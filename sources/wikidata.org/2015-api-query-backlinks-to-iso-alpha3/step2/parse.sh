#!/bin/sh
# Requires: xsltproc
cd "$(dirname "$0")"

xsltproc parse.xsl ../step1/backlinks.xml > data.csv
cp data.csv ..
