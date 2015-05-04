#!/bin/sh
# requires csvformat, from csvkit (0.9.0)
cd "$(dirname "$0")"

csvformat -T ../step1/ipcc-countries.csv |
awk --lint=fatal -f tsv2xml.awk \
> ipcc-countries.xml
