#!/bin/sh
# Requires csvformat, from csvkit (0.9.0)
# Requires uni2ascii (4.18)
cd $(dirname "$0")

baseUrl='https://en.wikipedia.org'

# Create and run the script to acquire the source
#
# Parameters:
#   $1 - string, relative path to the parent folder of the source
#   $2 - string, URL for the source to download
#   $3 - string, name for the source file, once saved locally
acquire()
{
  mkdir -p "$1/step1"
  cat << END > "$1/step1/acquire.sh"
#!/bin/sh
cd \$(dirname "\$0")

sourceUrl="$2"
sourceFile="$3"
wget -O "\$sourceFile" "\$sourceUrl"

cat << EOF > ../url.html
<meta http-equiv="refresh" content="0;
  url=\$sourceUrl
"/>
EOF
END
  chmod +x "$1/step1/acquire.sh"
  # "$1/step1/acquire.sh"
}

# Create and run the script to cleanup the source
#
# Parameters:
#   $1 - string, relative path to the parent folder of the source
#   $2 - string, name for the source file, once saved locally
cleanup()
{
  mkdir -p "$1/step2"
  cat << EOF > "$1/step2/cleanup.sh"
#!/bin/sh
# Requires: tidy5, from tidy-html5 (4.9.17)
cd \$(dirname "\$0")

file='$2'
tidy5 \\
  -output "\$file" \\
  -file log.txt \\
  -wrap 0 \\
  -numeric \\
  -asxhtml \\
  -utf8 \\
  "../step1/\$file"
EOF
  chmod +x "$1/step2/cleanup.sh"
  # "$1/step2/cleanup.sh"
}

# Create and run the script to parse the data and metadata
#
# Parameters:
#   $1 - string, relative path to the parent folder of the source
#   $2 - string, URL of the HTML source online
#   $3 - string, name for the HTML source file to process
#   $4 - string, name of the XSLT file to use to parse the data
parse()
{
  mkdir -p "$1/step3"
  cp "$4" "$1/step3/parse-data.xsl"
  cp "parse-meta.xsl" "$1/step3"
  cat << EOF > "$1/step3/parse.sh"
#!/bin/sh
# Requires: xsltproc
cd \$(dirname "\$0")

url='$2'
file='$3'
xsltproc --stringparam url "\$url" \
  --novalid parse-meta.xsl "../step2/\$file" > meta.txt
xsltproc --novalid parse-data.xsl "../step2/\$file" > data.csv
cp meta.txt ..
cp data.csv ..
EOF
  chmod +x "$1/step3/parse.sh"
  # "$1/step3/parse.sh"
}

# Create an external source in HTML format, and run the scripts
# to acquire, cleanup and parse the data and metadata
#
# Parameters:
#   $1 - string, relative path to the parent folder of the source
#   $2 - string, URL for the source to download
#   $3 - string, name for the HTML source file, once saved locally
#   $4 - string, name of the XSLT file to use to parse the data
outsource()
{
  acquire "$1" "$2" "$3"
  cleanup "$1" "$3"
  parse "$1" "$2" "$3" "$4"
}

tail -n +2 ../data.csv |
csvformat -T |
while IFS="	" read group country flagPictureUrl flagUrl countryUrl
do
  if test -z "$group"
  then
    # skip empty lines
    continue
  fi

  flagPictureUrl="$baseUrl$flagPictureUrl"
  flagUrl="$baseUrl$flagUrl"
  countryUrl="$baseUrl$countryUrl"

  folder=$(
    echo "$country" |
    tr '[:upper:] ' '[:lower:]-' |
    uni2ascii -d 2>/dev/null
  )

  flagFolder="$folder-flag-svg"
  flagFileName="flag-of-$folder.html"

  countryFolder="$folder"
  countryFileName="$folder.html"

  echo "Flag Folder: $flagFolder"
  echo "  Flag Picture URL: $flagPictureUrl"
  echo "Country Folder: $countryFolder"
  echo "  Country URL: $countryUrl"

  flagFolderPath="../../$flagFolder"
  flagXsl='parse-flag-data.xsl'
  outsource "$flagFolderPath" "$flagPictureUrl" "$flagFileName" "$flagXsl"

  countryFolderPath="../../$countryFolder"
  countryXsl='parse-country-data.xsl'
  outsource "$countryFolderPath" "$countryUrl" "$countryFileName" "$countryXsl"
done

