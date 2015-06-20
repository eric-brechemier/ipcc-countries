#!/bin/sh
cd "$(dirname "$0")"

# read URL from meta.txt
url="$(grep '^URL:' ../meta.txt | cut -d' ' -f2)"

file="$(basename "$url")"

curl "$url" > "$file"
