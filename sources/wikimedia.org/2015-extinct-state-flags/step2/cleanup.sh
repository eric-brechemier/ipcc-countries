#!/bin/sh
# Requires: tidy
cd $(dirname "$0")

file='Flags_of_extinct_states.html'
tidy \
  -output "$file" \
  -file log.txt \
  -wrap 0 \
  -numeric \
  -asxhtml \
  -utf8 \
  "../step1/$file"
