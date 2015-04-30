#!/bin/sh
# Requires xsltproc

cd "$(dirname "$0")"

echo 'Combine flags of current IPCC members into a single SVG file'
ls ../../../database/data/*.svg |
awk -f lines2xml.awk |
xsltproc --novalid combine.xsl - \
> flags.svg
