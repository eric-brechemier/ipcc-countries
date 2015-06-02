#!/bin/sh
# requires xsltproc
cd "$(dirname "$0")"

# Name of the data file, without extension
dataFileName='ipcc-un-wmo-members'

csvFileName="$dataFileName.csv"
xmlFileName="$dataFileName.xml"

echo 'Copy CSV data to current folder'
cp "../step1/$csvFileName" .

echo 'Copy visualization PNG to current folder'
cp ../step2/how.png .

echo 'Transform XML data to HTML'
xsltproc --novalid \
  --stringparam csvPath "$csvFileName" \
  --stringparam cssPath 'how.css' \
  --stringparam picturePath 'how.png' \
  transform.xsl "../step2/$xmlFileName" \
> how.html

echo 'Copy visualization to parent folder'
cp how.html ../index.html
cp "$csvFileName" how.png ..

lastLine="$(( $(grep -n 'LOCAL' how.css | cut -d: -f1) -2 ))"
echo "Remove local styles in parent folder (after line $lastLine)"
head -n "$lastLine" how.css > ../how.css
