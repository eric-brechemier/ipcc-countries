#!/bin/sh
# Requires csvformat, from csvkit (0.9.0)
cd "$(dirname "$0")"

year=2015
baseUrl='https://www.wikidata.org/wiki/Special:EntityData/'
extension='.xml'

# Create a separate source for each result,
# each in its own folder within 'sources/wikidata.org'
tail -n +2 ../data.csv |
csvformat --out-tabs |
while IFS="	" read pageId pageNs pageTitle
do
  url="$baseUrl$pageTitle$extension"
  folder="$pageTitle"
  file="$(basename "$url")"
  echo "Page: $pageTitle"
  echo "Folder: $folder"
  echo "URL: $url"
  echo "File: $file"

  folderPath="../../$folder"
  mkdir -p "$folderPath/step1"
  mkdir -p "$folderPath/step2"
  mkdir -p "$folderPath/step3"

cat << EOF > "$folderPath/meta.txt"
Year: $year
Title: Wikidata > Entity > $pageTitle
URL: $url
File: $file

Description:
All structured data from the main and property namespace
is available under the Creative Commons CC0 License [CC0];
text in the other namespaces is available under the
Creative Commons Attribution-ShareAlike License [CC-BY-SA];
additional terms may apply.

CC0: https://creativecommons.org/publicdomain/zero/1.0/
CC-BY-SA: https://creativecommons.org/licenses/by-sa/3.0/
EOF

  cp ../step1/userAgent.property.sh "$folderPath/step1/"
  cp outsource-step1-acquire.sh "$folderPath/step1/acquire.sh"
  cp outsource-step2-parse.sh "$folderPath/step2/parse.sh"
  cp outsource-step2-parse-data.xsl "$folderPath/step2/parse-data.xsl"
  cp ../step2/xml2csv.xsl "$folderPath/step2/xml2csv.xsl"
  cp outsource-step2-parse-meta.xsl "$folderPath/step2/parse-meta.xsl"
  cp outsource-step3-outsource.sh "$folderPath/step3/outsource.sh"
  cp outsource-step3-outsource-step1-acquire.sh \
                                 "$folderPath/step3/outsource-step1-acquire.sh"
  cp outsource-step3-outsource-step2-cleanup.sh \
                                 "$folderPath/step3/outsource-step2-cleanup.sh"
  cp outsource-step3-outsource-step3-parse.sh \
                                   "$folderPath/step3/outsource-step3-parse.sh"
  cp outsource-step3-outsource-step3-parse-data.xsl \
                             "$folderPath/step3/outsource-step3-parse-data.xsl"
  cp outsource-step3-outsource-step3-parse-meta.xsl \
                             "$folderPath/step3/outsource-step3-parse-meta.xsl"
  cp outsource-step3-outsource-step4-download.sh \
                                "$folderPath/step3/outsource-step4-download.sh"

  chmod +x "$folderPath/step1/acquire.sh"
  chmod +x "$folderPath/step2/parse.sh"
  chmod +x "$folderPath/step3/outsource.sh"

  "$folderPath/step1/acquire.sh" &&
  "$folderPath/step2/parse.sh" &&
  sleep 1 &&
  echo &&
  "$folderPath/step3/outsource.sh"

  # delay to reduce stress on server for downloads
  sleep 1

  # empty line to separate log messages in output
  echo
done 2>&1 | tee log.txt
