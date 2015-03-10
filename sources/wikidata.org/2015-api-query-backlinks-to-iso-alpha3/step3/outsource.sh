#!/bin/sh
cd "$(dirname "$0")"

year=2015
baseUrl='https://www.wikidata.org/wiki/Special:EntityData/'
extension='.xml'

# Create a separate source for each result,
# each in its own folder within 'sources/wikidata.org'
tail -n +2 ../data.csv |
while IFS=, read pageId pageNs pageTitle
do
  url="$baseUrl$pageTitle$extension"
  folder="$year-$( echo "$pageTitle" | tr '[:upper:]' '[:lower:]' )"
  echo "Page: $pageTitle"
  echo "  Folder: $folder"
  echo "  URL: $url"

  folderPath="../../$folder"
  mkdir -p "$folderPath/step1"
  mkdir -p "$folderPath/step2"

cat << EOF > "$folderPath/meta.txt"
Year: $year
Title: Wikidata > Entity > $pageTitle
URL: $url

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
  cp outsource-step2-parse.xsl "$folderPath/step2/parse.xsl"

  chmod +x "$folderPath/step1/acquire.sh"
  chmod +x "$folderPath/step2/parse.sh"

  "$folderPath/step1/acquire.sh" &&
  "$folderPath/step2/parse.sh"

  # delay to reduce stress on server for downloads
  sleep 1

  # empty line to separate log messages in output
  echo
done
