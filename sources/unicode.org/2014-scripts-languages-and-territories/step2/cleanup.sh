#!/bin/sh
# Requires: tidy5, from tidy-html5 (4.9.17)
cd $(dirname "$0")
tidy5 \
  -output scripts_languages_and_territories.html \
  -file log.txt \
  -numeric \
  -asxhtml \
  -utf8 \
  ../step1/scripts_languages_and_territories.html
