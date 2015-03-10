#!/bin/sh
# Requires: xsltproc
cd "$(dirname "$0")"

xsltproc parse-data.xsl ../step1/*.xml > data.csv
cp data.csv ..
