#!/bin/sh
# Requires: xsltproc
cd "$(dirname "$0")"

xsltproc parse.xsl ../step1/*.xml > data.csv
cp data.csv ..
