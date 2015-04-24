#!/bin/sh
# requires sqlite3 (3.8.8.2)
cd "$(dirname "$0")"

echo 'Export selected database views to CSV files'
sqlite3 < export.sql | tee log.txt

echo 'Export CSV files to parent folder'
cp *.csv ..
ls ../*csv

echo 'Copy IPCC country flags to parent data/ folder'
