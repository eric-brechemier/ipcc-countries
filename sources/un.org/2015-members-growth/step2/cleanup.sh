#!/bin/sh
# Requires: tidy5, from tidy-html5 (4.9.17)
cd $(dirname "$0")
tidy5 \
  -output growth.shtml \
  -file log.txt \
  -numeric \
  -asxhtml \
  -utf8 \
  ../step1/growth.shtml
