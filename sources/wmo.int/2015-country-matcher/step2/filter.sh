#!/bin/sh
cd "$(dirname "$0")"

cat ../step1/countries.txt no-match.txt \
| sort \
| uniq -u \
> countries.txt
