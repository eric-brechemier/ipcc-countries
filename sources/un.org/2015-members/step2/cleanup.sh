#!/bin/sh
# Requires: tidy
cd $(dirname "$0")
tidy \
  -output members.html \
  -file log.txt \
  -numeric \
  -asxhtml \
  -utf8 \
  ../step1/members.html
