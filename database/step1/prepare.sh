#!/bin/sh
cd $(dirname "$0")

sed -f prepare.sed ../../sources/debian.org/2014-iso-codes/data.csv \
> debian_2014_iso_codes.csv

sed -f prepare.sed ../../sources/ipcc.ch/2009-ipcc-countries/data.csv \
> ipcc_2009_ipcc_countries.csv

sed -f prepare.sed ../../sources/ipcc.ch/2012-ipcc-members/data.csv \
> ipcc_2012_ipcc_members.csv

sed -f prepare.sed ../../sources/unicode.org/2014-code-mappings/data.csv \
> unicode_2014_code_mappings.csv

sed -f prepare.sed ../../sources/unicode.org/2014-scripts-languages-and-territories/data.csv \
> unicode_2014_scripts_languages_territories.csv

sed -f prepare.sed ../../sources/unicode.org/2014-territories/data.csv \
> unicode_2014_territories.csv

sed -f prepare.sed ../../sources/un.org/2015-members/data.csv \
> un_2015_members.csv

sed -f prepare.sed ../../sources/un.org/2015-members-growth/data.csv \
> un_2015_members_growth.csv

sed -f prepare.sed ../../sources/wmo.int/2014-wmo-composition/data.csv \
> wmo_2014_wmo_composition.csv

sed -f prepare.sed ../../sources/wmo.int/2015-country-matcher/data.csv \
> wmo_2015_country_matcher.csv

sed -f prepare.sed ../../sources/wmo.int/2015-members-and-territories/data.csv \
> wmo_2015_members_territories.csv

