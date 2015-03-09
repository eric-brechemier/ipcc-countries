#!/bin/sh
cd "$(dirname $0)"

file='backlinks.xml'

# read userAgent from property file
source userAgent.property.sh

# read URL from meta.txt
url=$(grep '^URL:' ../meta.txt | cut -d' ' -f2)

wget \
  --user-agent="$userAgent" \
  -O "$file" "$url"

cp "$file" ..
