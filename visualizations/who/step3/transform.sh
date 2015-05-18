#!/bin/sh
# requires csvformat, from csvkit (0.9.0)
# requires xsltproc
cd "$(dirname "$0")"

echo 'Copy flags.png to current folder'
cp ../step2/flags.png .

echo 'Copy CSS for sprites image for flags to current folder'
cp ../step2/flags.css .

echo 'Convert CSV data to XML and transform to HTML'
csvformat -T ../step1/ipcc-countries.csv |
awk --lint=fatal -f tsv2xml.awk |
xsltproc --novalid \
  --stringparam cssPath 'who.css' \
  --stringparam flagsPath 'flags.svg' \
  transform.xsl - \
> who.html

echo 'Copy visualization to parent folder'
cp who.html ../index.html
cp who.css flags.css flags.png ..
