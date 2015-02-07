-- load database of sources
.read ../step2/sources.sql

.mode csv

.once debian_country_names.csv
SELECT DISTINCT *
FROM (
  SELECT `Alpha-3 Country Code` code, `Common Name` name
  FROM debian_2014_iso_codes
  WHERE `Common Name` <> ''
  AND `Date Withdrawn` = ''
  UNION
  SELECT `Alpha-3 Country Code` code, `Name` name
  FROM debian_2014_iso_codes
  WHERE `Name` <> ''
  AND `Date Withdrawn` = ''
  UNION
  SELECT `Alpha-3 Country Code` code, `Official Name` name
  FROM debian_2014_iso_codes
  WHERE `Official Name` <> ''
  AND `Date Withdrawn` = ''
)
ORDER BY code, name
;

.once debian_former_country_names.csv
SELECT `Alpha-3 Country Code` code, `Names` name
FROM debian_2014_iso_codes
WHERE `Date Withdrawn` <> ''
ORDER BY code, name
;

.once ipcc_country_names.csv
SELECT DISTINCT
  coalesce(
    matcher.`ISO Country Code`,
    debian.`Alpha-3 Country Code`,
    'N/A'
  ) code,
  ipcc.Country name
FROM ipcc_2012_ipcc_members ipcc
LEFT JOIN wmo_2015_country_matcher matcher
ON ipcc.Country = matcher.`Country Name To Identify`
LEFT JOIN debian_2014_iso_codes debian
ON ipcc.Country = debian.`Common Name`
OR ipcc.Country = debian.Name
OR ipcc.Country = debian.`Official Name`
-- names of the form 'ABC, Republic of'
OR SUBSTR( ipcc.Country, INSTR(ipcc.Country,', ') +2 )
|| ' '
|| SUBSTR( ipcc.Country, 1, INSTR(ipcc.Country,', ') -1 )
= debian.`Official Name`
ORDER BY code, name
;

.once un_country_names.csv
SELECT DISTINCT
  coalesce(
    matcher.`ISO Country Code`,
    debian.`Alpha-3 Country Code`,
    'N/A'
  ) code,
  replace(un.`Member State`,char(0x200E),'') name
FROM un_2015_members un
LEFT JOIN wmo_2015_country_matcher matcher
ON un.`Member State` = matcher.`Country Name To Identify`
LEFT JOIN debian_2014_iso_codes debian
ON un.`Member State` = debian.`Common Name`
OR un.`Member State` = debian.Name
OR un.`Member State` = debian.`Official Name`
ORDER BY code, name
;

.once unicode_country_names.csv
SELECT DISTINCT *
FROM (
  SELECT
    map.`Alpha-3 ISO Country Code` code,
    ter.`Territory Name` name
  FROM unicode_2014_territories ter
  JOIN unicode_2014_code_mappings map
  ON ter.`Territory Code` = map.`Alpha-2 ISO Country Code`
  -- ZZZ = 'Unknown Region'
  WHERE map.`Alpha-3 ISO Country Code` NOT IN ('','ZZZ')
  UNION
  SELECT
    map.`Alpha-3 ISO Country Code` code,
    ter.`Territory Name` name
  FROM unicode_2014_scripts_languages_territories ter
  JOIN unicode_2014_code_mappings map
  ON ter.`Territory Code` = map.`Alpha-2 ISO Country Code`
  -- ZZZ = 'Unknown Region'
  WHERE map.`Alpha-3 ISO Country Code` NOT IN ('','ZZZ')
  UNION
  SELECT
    map.`Alpha-3 ISO Country Code` code,
    ter.`Territory's Native Name` name
  FROM unicode_2014_scripts_languages_territories ter
  JOIN unicode_2014_code_mappings map
  ON ter.`Territory Code` = map.`Alpha-2 ISO Country Code`
  -- ZZZ = 'Unknown Region'
  WHERE ter.`Territory's Native Name` <> 'n/a'
  AND map.`Alpha-3 ISO Country Code` NOT IN ('','ZZZ')
)
ORDER BY code, name
;

.once wmo_country_names.csv
SELECT DISTINCT *
FROM (
  SELECT `ISO Country Code` code, `English Country Name` name
  FROM wmo_2015_members_territories
  UNION
  SELECT `ISO Country Code` code, `French Country Name` name
  FROM wmo_2015_members_territories
)
ORDER BY code, name
;

