#!/bin/sh
# Requires csvcut, from csvkit (0.9.0)
cd "$(dirname "$0")"

# read URL from data.csv
record="$(tail -n 1 ../data.csv)"
url="$(echo "$record" | csvcut -c 2)"

case "$url"
in '//'*)
  protocol='https'
  echo "Add missing protocol '$protocol' to the URL"
  url="$protocol:$url"
  ;;
esac

# read local file path from data.csv
filePath="$(echo "$record" | csvcut -c 3)"
file="../$filePath"

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
  "$url" \
&& echo "Saved: $filePath"
