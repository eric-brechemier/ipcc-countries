#!/bin/sh
# Requires: tidy5, from tidy-html5 (4.9.17)
cd "$(dirname "$0")"

# read file name from meta.txt
file=$(grep '^File:' ../meta.txt | cut -d' ' -f2)

tidy5 \
  -output "$file" \
  -file log.txt \
  -wrap 0 \
  -numeric \
  -asxhtml \
  -utf8 \
  "../step1/$file"

# bypass non-zero value returned by tidy5 even with only warnings
return 0
