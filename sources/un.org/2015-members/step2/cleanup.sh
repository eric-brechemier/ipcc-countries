#!/bin/sh
# Requires: tidy
cd $(dirname "$0")
tidy \
  -output members.html \
  -file log.txt \
  -asxhtml \
  -utf8 \
  ../step1/members.html
