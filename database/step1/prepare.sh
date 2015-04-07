#!/bin/sh
cd $(dirname "$0")

# debian.org
sed -f prepare.sed ../../sources/debian.org/2014-iso-codes/data.csv \
> debian_2014_iso_codes.csv

# ipcc.ch
sed -f prepare.sed ../../sources/ipcc.ch/2009-ipcc-countries/data.csv \
> ipcc_2009_ipcc_countries.csv
sed -f prepare.sed ../../sources/ipcc.ch/2012-ipcc-members/data.csv \
> ipcc_2012_ipcc_members.csv

# unicode.org
sed -f prepare.sed ../../sources/unicode.org/2014-code-mappings/data.csv \
> unicode_2014_code_mappings.csv
sed -f prepare.sed ../../sources/unicode.org/2014-scripts-languages-and-territories/data.csv \
> unicode_2014_scripts_languages_territories.csv
sed -f prepare.sed ../../sources/unicode.org/2014-territories/data.csv \
> unicode_2014_territories.csv

# un.org
sed -f prepare.sed ../../sources/un.org/2015-members/data.csv \
> un_2015_members.csv
sed -f prepare.sed ../../sources/un.org/2015-members-growth/data.csv \
> un_2015_members_growth.csv

# wikidata.org
sed -f prepare.sed \
  ../../sources/wikidata.org/2015-api-query-backlinks-to-iso-alpha3/data.csv \
> wikidata_2015_api_query_backlinks_to_iso_alpha3.csv

# wikimedia.org
sed -f prepare.sed \
  ../../sources/wikimedia.org/2015-extinct-state-flags/data.csv \
> wikimedia_2015_extinct_state_flags.csv

# wikipedia.org
sed -f prepare.sed \
  ../../sources/wikipedia.org/2014-dependent-territory-flags/data.csv \
> wikipedia_2014_dependent_territory_flags.csv
sed -f prepare.sed \
  ../../sources/wikipedia.org/2015-sovereign-state-flags/data.csv \
> wikipedia_2015_sovereign_state_flags.csv

# wmo.int
sed -f prepare.sed ../../sources/wmo.int/2014-wmo-composition/data.csv \
> wmo_2014_wmo_composition.csv
sed -f prepare.sed ../../sources/wmo.int/2015-country-matcher/data.csv \
> wmo_2015_country_matcher.csv
sed -f prepare.sed ../../sources/wmo.int/2015-members-and-territories/data.csv \
> wmo_2015_members_territories.csv
