#!/bin/sh
cd "$(dirname "$0")"
inputFile='../step2/membership.txt'
outputFile='membership.txt'

awk -f cleanup.awk "$inputFile" > "$outputFile"
