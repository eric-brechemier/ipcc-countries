#!/bin/sh
cd "$(dirname "$0")"

# read URL from meta.txt
url="$(grep '^URL:' ../meta.txt | cut -d' ' -f2)"

file="$(basename "$url")"
folder="$(basename "$url" '.zip')"

curl --location "$url" > "$file"

unzip "$file" -d "$folder"
