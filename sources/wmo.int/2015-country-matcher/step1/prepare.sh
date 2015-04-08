#!/bin/sh
# Requires: csvcut and csvformat, from csvkit

cd "$(dirname "$0")"

# Extract list of country names found in given column in given CSV file
#
# Parameter:
#   $1 - integer, position of the column which contains the country name
#   $2 - string, path to the input CSV file
#
# Standard Ouput:
#   the list of countries extracted, with one country name per line,
#   without quoting or escaping
#
getCountries(){
  echo "...Extract countries from '$2'" 1>&2
  csvcut -c "$1" -x "$2" \
  | csvformat -T \
  | tail -n +2
}

echo 'List all country names to identify'
rm -f countries.txt
touch countries.txt

getCountries 2 ../../../ipcc.ch/2009-ipcc-countries/data.csv \
>> countries.txt

getCountries 2 \
  ../../../ipcc.ch/2012-annex-A-of-ipcc-principles-elections-rules/data.csv \
>> countries.txt

getCountries 1 ../../../un.org/2015-members/data.csv \
>> countries.txt

getCountries 2 ../../../un.org/2015-members-growth/data.csv \
>> countries.txt

getCountries 1 ../../../wmo.int/2014-wmo-composition/data.csv \
| awk -f get-english-country-name.awk \
>> countries.txt

echo 'Sort countries and remove duplicates'
sort countries.txt | uniq > different-countries.txt
mv different-countries.txt countries.txt

