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
  ipcc.wikipedia_url
FROM current_ipcc_members ipcc
ORDER BY common_name
;
