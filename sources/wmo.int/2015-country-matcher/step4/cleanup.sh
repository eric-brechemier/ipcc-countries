#!/bin/sh
# Requires: tidy
cd "$(dirname "$0")"
tidy \
  -output countrymatcher.html \
  -file log.txt \
  -numeric \
  -asxhtml \
  -utf8 \
  ../step3/countrymatcher.html
