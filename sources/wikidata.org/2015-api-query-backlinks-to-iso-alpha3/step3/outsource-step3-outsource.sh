#!/bin/sh
# Requires csvgrep, from csvkit (0.9.0)
# Requires csvcut, from csvkit (0.9.0)
# Requires uni2ascii (4.18)
cd "$(dirname "$0")"

year='2015'
baseUrl='https://commons.wikimedia.org/wiki/File:'
extension='.svg'
relativePath='../../../wikimedia.org/'

# select first flag (P41) currently valid (empty end date)
fileName="$(
  csvgrep -c 3 -r '^P41$' ../data.csv | # select flags (P41)
  csvgrep -c 8 -r '^$' | # keep only currently valid flags (empty end date)
  head -n 2 | # keep only header and first record
  tail -n 1 | # keep only first record
  csvcut -c 5
)"
if test -z "$fileName"
then
  echo "Abort: no flag found."
  exit 1
fi

echo "Flag File: $fileName"

# URL with spaces redirects to URL with underscores instead
# on commons.wikimedia.org
url="$baseUrl$(
  echo "$fileName" |
  tr ' ' '_' |
  uni2ascii -a J 2>/dev/null
)"
echo "Flag URL: $url"

folder="$(
  basename "$fileName" "$extension" |
  uni2ascii -d 2>/dev/null |
  tr '[:upper:] ' '[:lower:]-' |
  tr -d '()'
)"
file="$folder.html"

echo "Local File: $file"
echo "Local Folder: $folder"

folderPath="$relativePath$folder"

mkdir -p "$folderPath/step1"
mkdir -p "$folderPath/step2"
mkdir -p "$folderPath/step3"
mkdir -p "$folderPath/step4"

cat << EOF > "$folderPath/meta.txt"
Year: $year
Title: File:$fileName
URL: $url
File: $file

Description:
From Wikimedia Commons, the free media repository
EOF

cp ../step1/userAgent.property.sh "$folderPath/step1/"
cp outsource-step1-acquire.sh "$folderPath/step1/acquire.sh"
chmod +x "$folderPath/step1/acquire.sh"
cp outsource-step2-cleanup.sh "$folderPath/step2/cleanup.sh"
chmod +x "$folderPath/step2/cleanup.sh"
cp outsource-step3-parse.sh "$folderPath/step3/parse.sh"
chmod +x "$folderPath/step3/parse.sh"
cp outsource-step3-parse-data.xsl "$folderPath/step3/parse-data.xsl"
cp ../step2/xml2csv.xsl "$folderPath/step3/xml2csv.xsl"
cp outsource-step3-parse-meta.xsl "$folderPath/step3/parse-meta.xsl"
cp outsource-step4-download.sh "$folderPath/step4/download.sh"
chmod +x "$folderPath/step4/download.sh"

"$folderPath/step1/acquire.sh" &&
"$folderPath/step2/cleanup.sh" &&
"$folderPath/step3/parse.sh" &&
"$folderPath/step4/download.sh"
