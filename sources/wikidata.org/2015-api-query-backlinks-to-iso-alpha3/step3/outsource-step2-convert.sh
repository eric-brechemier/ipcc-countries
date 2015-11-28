#!/bin/sh
# Requires jq (1.4)
# Requires csvformat, from csvkit (0.9.0)
cd "$(dirname "$0")"

# read file name from meta.txt
file=$(grep '^File:' ../meta.txt | cut -d' ' -f2)

jq --from-file convert.jq \
  --raw-output \
  < "../step1/$file" \
| csvformat -M '
' \
> data.csv
cp data.csv ..
