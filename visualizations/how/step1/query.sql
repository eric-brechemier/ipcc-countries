.print 'Load database'
.read ../../../database/database.sql

CREATE VIEW all_members
AS
SELECT DISTINCT iso3_code, common_name
FROM (
  SELECT iso3_code, common_name
  FROM current_un_members
  UNION
  SELECT iso3_code, common_name
  FROM current_wmo_members
  UNION
  SELECT iso3_code, common_name
  FROM current_ipcc_members
) every
;

CREATE VIEW cross_members
AS
SELECT
  CASE WHEN ipcc.iso3_code IS NULL THEN 'NOT IPCC' ELSE 'IPCC' END AS IPCC,
  CASE WHEN un.iso3_code IS NULL THEN 'NOT UN' ELSE 'UN' END AS UN,
  IFNULL('WMO ' || wmo.state_or_territory, 'NOT WMO') AS WMO,
  all_members.iso3_code,
  all_members.common_name,
  ipcc.wikipedia_url,
  wmo.cpdb_url
FROM all_members
LEFT JOIN
(
  SELECT iso3_code
  FROM current_un_members
) un
USING (iso3_code)
LEFT JOIN
(
  SELECT iso3_code, state_or_territory, cpdb_url
  FROM current_wmo_members
) wmo
USING (iso3_code)
LEFT JOIN
(
  SELECT iso3_code, wikipedia_url
  FROM current_ipcc_members
) ipcc
USING (iso3_code)
ORDER BY IPCC, UN DESC, WMO, common_name
;

.mode csv
.headers on

.print 'Query the database for the consolidated list of IPCC/UN/WMO Members'
.once ipcc-un-wmo-members.csv
SELECT *
FROM cross_members
;
