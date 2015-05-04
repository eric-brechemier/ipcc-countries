#!/bin/sh
# requires csvformat, from csvkit (0.9.0)
# requires xsltproc
cd "$(dirname "$0")"

echo 'Convert CSV data to XML and transform to HTML'
csvformat -T ../step1/ipcc-countries.csv |
awk --lint=fatal -f tsv2xml.awk |
xsltproc --novalid transform.xsl - \
> who.html
