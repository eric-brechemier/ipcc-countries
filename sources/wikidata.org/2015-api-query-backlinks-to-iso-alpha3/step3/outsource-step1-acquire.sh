#!/bin/sh
cd "$(dirname "$0")"

# read URL from meta.txt
url=$(grep '^URL:' ../meta.txt | cut -d' ' -f2)
file="${url##*/}"

# read userAgent from property file
. ./userAgent.property.sh

curl --silent --show-error --user-agent "$userAgent" "$url" > "$file"

cp *.xml ..
