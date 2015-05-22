.print 'Load database'
.read ../../../database/database.sql

CREATE VIEW all_members
AS
SELECT DISTINCT iso3_code
FROM (
  SELECT iso3_code
  FROM current_un_members
  UNION
  SELECT iso3_code
  FROM current_wmo_members
  UNION
  SELECT iso3_code
  FROM current_ipcc_members
) every
;

CREATE VIEW cross_counts
AS
SELECT
  CASE WHEN un.iso3_code IS NULL THEN 'NOT UN' ELSE 'UN' END AS UN,
  IFNULL('WMO ' || wmo.state_or_territory, 'NOT WMO') AS WMO,
  CASE WHEN ipcc.iso3_code IS NULL THEN 'NOT IPCC' ELSE 'IPCC' END AS IPCC,
  COUNT(*) AS count
FROM all_members
LEFT JOIN
(
  SELECT iso3_code
  FROM current_un_members
) un
USING (iso3_code)
LEFT JOIN
(
  SELECT iso3_code, state_or_territory
  FROM current_wmo_members
) wmo
USING (iso3_code)
LEFT JOIN
(
  SELECT iso3_code
  FROM current_ipcc_members
) ipcc
USING (iso3_code)
GROUP BY UN, WMO, IPCC
;

.mode csv
.headers on

.print 'Query the database to build the crosstabulation table'
.once crosstab.csv
SELECT *
FROM cross_counts
ORDER BY UN DESC, WMO, IPCC
;
