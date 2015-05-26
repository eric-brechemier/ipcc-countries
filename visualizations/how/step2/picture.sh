#!/bin/sh
# requires csvformat, from csvkit (0.9.0)
# requires xsltproc
# requires inkscape (0.48.3.1)
# uses optipng (0.6.4) if available

cd "$(dirname "$0")"

echo 'Convert CSV data to XML and transform to HTML'
csvformat -T ../step1/ipcc-un-wmo-members.csv |
awk --lint=fatal -f tsv2xml.awk |
tee ipcc-un-wmo-members.xml |
xsltproc --novalid \
  picture.xsl - \
> how.svg
