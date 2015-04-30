.print 'Load database'
.read ../../../database/database.sql

.mode csv
.headers on

.print 'Query the database for the list of IPCC countries'
.once ipcc-countries.csv
SELECT
  SUBSTR(ipcc.common_name,1,1) first_letter,
  ipcc.iso3_code,
  ipcc.common_name,
  ipcc.official_name,
  SUBSTR(
    ipcc.flag_image_path
    ,
      LENGTH('data/')
    + 1
    ,
      LENGTH(ipcc.flag_image_path)
    - LENGTH('data/')
    - LENGTH('.svg')
  ) AS flag,
  'https://en.wikipedia.org/wiki/' || REPLACE(enwiki.Value,' ','_')
  AS wikipedia_url
FROM current_ipcc_members ipcc
LEFT JOIN wikidata_entities iso3
ON ipcc.iso3_code = iso3.Value
AND iso3.`Value Name` = 'P298'
LEFT JOIN wikidata_entities enwiki
ON iso3.Entity = enwiki.Entity
AND enwiki.`Value Name` = 'site'
AND enwiki.`Value Type` = 'enwiki'
ORDER BY common_name
;
