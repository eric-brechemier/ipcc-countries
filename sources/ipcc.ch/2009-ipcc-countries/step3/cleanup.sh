#!/bin/sh
cd "$(dirname "$0")"
inputFile='../step2/ipcc-countries.txt'
outputFile='ipcc-countries.txt'

awk -f cleanup.awk "$inputFile" > "$outputFile"
