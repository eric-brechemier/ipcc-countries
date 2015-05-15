#!/bin/sh
# Requires xsltproc

cd "$(dirname "$0")"

echo 'List SVG file images as XML'
ls ../../../database/data/*.svg |
awk -f lines2xml.awk \
> flags-list.xml

echo 'Combine flags of current IPCC members into a single SVG file'
xsltproc --novalid combine.xsl flags-list.xml \
> flags.svg
