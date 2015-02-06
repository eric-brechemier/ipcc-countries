-- load database of sources
.read ../step2/sources.sql

.mode csv

.once debian_country_names.csv
SELECT *
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
SELECT *
FROM (
  SELECT `Alpha-3 Country Code` code, `Names` name
  FROM debian_2014_iso_codes
  WHERE `Date Withdrawn` <> ''
)
ORDER BY code, name
;

.once ipcc_country_names.csv
SELECT *
FROM (
  SELECT
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
)
ORDER BY code, name
;

