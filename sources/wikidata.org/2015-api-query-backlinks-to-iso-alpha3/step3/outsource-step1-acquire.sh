#!/bin/sh
cd "$(dirname "$0")"

# read URL from meta.txt
url=$(grep '^URL:' ../meta.txt | cut -d' ' -f2)

# read file name from meta.txt
file=$(grep '^File:' ../meta.txt | cut -d' ' -f2)

# read userAgent from property file
. ./userAgent.property.sh

curl \
  --silent --show-error \
  --user-agent "$userAgent" \
  --time-cond "$file" \
  --remote-time \
  --output "$file" \
  "$url"

cp "$file" ..
