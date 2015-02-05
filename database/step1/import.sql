-- import all CSV files into separate tables
.echo on
.mode csv
.import ../../sources/debian.org/2014-iso-codes/data.csv debian_2014_iso_codes
.import ../../sources/ipcc.ch/2009-ipcc-countries/data.csv ipcc_2009_ipcc_countries
.import ../../sources/ipcc.ch/2012-ipcc-members/data.csv ipcc_2012_ipcc_members
.import ../../sources/unicode.org/2014-code-mappings/data.csv unicode_2014_code_mappings
.import ../../sources/unicode.org/2014-scripts-languages-and-territories/data.csv unicode_2014_scripts_languages_territories
.import ../../sources/unicode.org/2014-territories/data.csv unicode_2014_territories
.import ../../sources/un.org/2015-members/data.csv un_2015_members
.import ../../sources/un.org/2015-members-growth/data.csv un_2015_members_growth
.import ../../sources/wmo.int/2014-wmo-composition/data.csv wmo_2014_wmo_composition
.import ../../sources/wmo.int/2015-country-matcher/data.csv wmo_2015_country_matcher
.import ../../sources/wmo.int/2015-members-and-territories/data.csv wmo_2015_members_territories

.tables

.once sources.sql
.dump
