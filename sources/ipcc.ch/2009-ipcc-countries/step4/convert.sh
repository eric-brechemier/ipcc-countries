#!/bin/sh
# Convert the text file to CSV
cd $(dirname "$0")
awk -f convert.awk ../step3/ipcc-countries.txt > data.csv
cp data.csv ..
