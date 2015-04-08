#!/bin/sh
# Requires: tidy
cd "$(dirname "$0")"

file='Gallery_of_sovereign_state_flags.html'
tidy \
  -output "$file" \
  -file log.txt \
  -wrap 0 \
  -numeric \
  -asxhtml \
  -utf8 \
  "../step1/$file"
