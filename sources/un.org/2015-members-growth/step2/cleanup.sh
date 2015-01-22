#!/bin/sh
# Requires: tidy
cd $(dirname "$0")
tidy \
  -output growth.shtml \
  -file log.txt \
  -numeric \
  -asxhtml \
  -utf8 \
  ../step1/growth.shtml
