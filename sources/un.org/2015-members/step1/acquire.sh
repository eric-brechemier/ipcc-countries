#!/bin/sh
cd $(dirname "$0")
wget \
  -O members.html \
  --user-agent='' \
  'http://www.un.org/en/members/'
