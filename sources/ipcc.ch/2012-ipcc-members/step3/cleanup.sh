#!/bin/sh
cd "$(dirname "$0")"
inputFile='../step2/annexA.txt'
outputFile='annexA.txt'

awk -f cleanup.awk "$inputFile" > "$outputFile"
