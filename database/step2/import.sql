-- import all CSV files into separate tables
.echo on
.mode csv

-- debian.org
.import ../step1/debian_2014_iso_codes.csv debian_2014_iso_codes
-- ipcc.ch
.import ../step1/ipcc_2009_ipcc_countries.csv ipcc_2009_ipcc_countries
.import ../step1/ipcc_2012_ipcc_members.csv ipcc_2012_ipcc_members
-- unicode.org
.import ../step1/unicode_2014_code_mappings.csv unicode_2014_code_mappings
.import ../step1/unicode_2014_scripts_languages_territories.csv unicode_2014_scripts_languages_territories
.import ../step1/unicode_2014_territories.csv unicode_2014_territories
-- un.org
.import ../step1/un_2015_members.csv un_2015_members.csv un_2015_members.csv un_2015_members
.import ../step1/un_2015_members_growth.csv un_2015_members_growth.csv un_2015_members_growth.csv un_2015_members_growth
-- wikidata.org
.import ../step1/wikidata_2015_api_query_backlinks_to_iso_alpha3.csv wikidata_2015_api_query_backlinks_to_iso_alpha3
.import ../step1/wikidata_entities.csv wikidata_entities
-- wikimedia.org
.import ../step1/wikimedia_2015_extinct_state_flags.csv wikimedia_2015_extinct_state_flags
.import ../step1/wikimedia_flags.csv wikimedia_flags
-- wikipedia.org
.import ../step1/wikipedia_2014_dependent_territory_flags.csv wikipedia_2014_dependent_territory_flags
.import ../step1/wikipedia_2015_sovereign_state_flags.csv wikipedia_2015_sovereign_state_flags
-- wmo.int
.import ../step1/wmo_2014_wmo_composition.csv wmo_2014_wmo_composition
.import ../step1/wmo_2015_country_matcher.csv wmo_2015_country_matcher
.import ../step1/wmo_2015_members_territories.csv wmo_2015_members_territories

.tables

.once sources.sql
.dump
