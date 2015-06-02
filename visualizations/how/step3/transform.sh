#!/bin/sh
# requires csvformat, from csvkit (0.9.0)
# requires xsltproc
cd "$(dirname "$0")"

# Name of the CSV file
csvFileName='ipcc-un-wmo-members.csv'

echo 'Copy CSV data to current folder'
cp "../step1/$csvFileName" .

echo 'Copy visualization PNG to current folder'
cp ../step2/how.png .

echo 'Convert CSV data to XML and transform to HTML'
csvformat -T "../step1/$csvFileName" |
awk --lint=fatal -f tsv2xml.awk |
xsltproc --novalid \
  --stringparam csvPath "$csvFileName" \
  --stringparam cssPath 'how.css' \
  --stringparam picturePath 'how.png' \
  transform.xsl - \
> how.html

echo 'Copy visualization to parent folder'
cp how.html ../index.html
cp "$csvFileName" how.png ..

lastLine="$(( $(grep -n 'LOCAL' how.css | cut -d: -f1) -2 ))"
echo "Remove local styles in parent folder (after line $lastLine)"
head -n "$lastLine" how.css > ../how.css
