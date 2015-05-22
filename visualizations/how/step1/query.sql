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

CREATE VIEW cross_members
AS
SELECT
  CASE WHEN un.iso3_code IS NULL THEN 'NOT UN' ELSE 'UN' END AS UN,
  IFNULL('WMO ' || wmo.state_or_territory, 'NOT WMO') AS WMO,
  CASE WHEN ipcc.iso3_code IS NULL THEN 'NOT IPCC' ELSE 'IPCC' END AS IPCC
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
;

CREATE VIEW cross_counts
AS
SELECT UN, WMO, IPCC, COUNT(*) AS count
FROM cross_members
GROUP BY UN, WMO, IPCC
ORDER BY UN DESC, WMO, IPCC
;

.mode csv
.headers on

.print 'Query the database to build the crosstabulation table'
.once crosstab.csv
SELECT *
FROM cross_counts
UNION
SELECT '*' AS UN, '*' AS WMO, '*' AS IPCC, COUNT(*) AS count
FROM cross_members
UNION
SELECT UN, '*' AS WMO, '*' AS IPCC, COUNT(*) AS count
FROM cross_members
GROUP BY UN
UNION
SELECT '*' AS UN, WMO, '*' AS IPCC, COUNT(*) AS count
FROM cross_members
GROUP BY WMO
UNION
SELECT '*' AS UN, '*' AS WMO, IPCC, COUNT(*) AS count
FROM cross_members
GROUP BY IPCC
;
