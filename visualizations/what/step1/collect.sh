#!/bin/sh
# Requires xsltproc

cd "$(dirname "$0")"

echo 'Collect list of current IPCC members'
cp ../../../database/current_ipcc_members.csv .

echo 'Combine flags of current IPCC members into a single SVG file'
ls ../../../database/data/*.svg |
awk -f lines2xml.awk |
xsltproc --novalid combine.xsl - \
> flags.svg
