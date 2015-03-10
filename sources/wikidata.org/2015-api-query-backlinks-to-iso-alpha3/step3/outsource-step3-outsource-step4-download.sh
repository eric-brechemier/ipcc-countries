#!/bin/sh
# Requires csvcut, from csvkit (0.9.0)
cd "$(dirname "$0")"

protocol='https:'

# read URL from data.csv
record="$(tail -n 1 ../data.csv)"
url="$protocol$(echo "$record" | csvcut -c 2)"

# read local file path from data.csv
file="../$(echo "$record" | csvcut -c 3)"

# create directory
mkdir -p "$(dirname "$file")"

# read userAgent from property file
. ../step1/userAgent.property.sh

curl \
  --silent --show-error \
  --user-agent "$userAgent" \
  --time-cond "$file" \
  --remote-time \
  --output "$file" \
  "$url"

echo "Saved: $file"
