#!/bin/sh
# Requires: tidy
cd $(dirname "$0")

file='Gallery_of_flags_of_dependent_territories.html'
tidy \
  -output "$file" \
  -file log.txt \
  -wrap 0 \
  -numeric \
  -asxhtml \
  -utf8 \
  "../step1/$file"
