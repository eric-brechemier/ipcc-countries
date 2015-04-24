#!/bin/sh
# requires sqlite3 (3.8.8.2)
# requires csvcut, from csvkit (0.9.0)

cd "$(dirname "$0")"

echo 'Export selected database views to CSV files'
sqlite3 < export.sql | tee log.txt

echo 'Export CSV files to parent folder'
cp *.csv ..
ls ../*csv

echo 'Copy IPCC country flags to parent data/ folder'
rm -rf ../data
mkdir ../data
csvcut -c3 current_ipcc_members.csv |
tail -n +2 | # skip header
while read svgFilePath
do
  cp "../step2/$svgFilePath" "../$svgFilePath"
done
