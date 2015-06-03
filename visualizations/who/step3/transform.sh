#!/bin/sh
# requires csvformat, from csvkit (0.9.0)
# requires xsltproc
cd "$(dirname "$0")"

echo 'Copy CSV data to current folder'
cp ../step1/ipcc-countries.csv .

echo 'Copy flags.png to current folder'
cp ../step2/flags.png .

echo 'Copy CSS for sprites image for flags to current folder'
cp ../step2/flags.css .

echo 'Convert CSV data to XML and transform to HTML'
csvformat -T ../step1/ipcc-countries.csv |
awk --lint=fatal -f tsv2xml.awk |
xsltproc --novalid \
  --stringparam csvPath 'ipcc-countries.csv' \
  --stringparam cssPath 'who.css' \
  transform.xsl - \
> who.html

echo 'Copy visualization to parent folder'
cp who.html ../index.html
cp ipcc-countries.csv flags.css flags.png ..

lastLine="$(( $(grep -n 'LOCAL' who.css | cut -d: -f1) -2 ))"
echo "Remove local styles in parent folder (after line $lastLine)"
head -n "$lastLine" who.css > ../who.css
