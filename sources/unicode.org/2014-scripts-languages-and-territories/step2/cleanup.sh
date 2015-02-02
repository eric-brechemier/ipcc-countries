#!/bin/sh
# Requires: tidy
cd $(dirname "$0")
tidy \
  -output scripts_languages_and_territories.html \
  -file log.txt \
  -numeric \
  -asxhtml \
  -utf8 \
  ../step1/scripts_languages_and_territories.html
