.read ../step4/database.sql

.nullvalue NULL

CREATE VIEW current_ipcc_members
AS
-- A list of current members of the IPCC
SELECT
  -- ISO Alpha-3 Country Code, for identification
  ipcc.code AS iso3_code,
  -- Common Country Name in English, for display
  unicode.`Territory Name` AS common_name,
  -- Official Name in English, for disambiguation
  CASE INSTR(debian.name,', ')
  AND (
    -- transform names of the form:
    --   'X, Y of' -> 'Y of X'
    --   'X, Y of the' -> 'Y of the X'
       SUBSTR(debian.name, - LENGTH(' of') ) = ' of'
    OR SUBSTR(debian.name, - LENGTH(' of the') ) = ' of the'
  )
  WHEN 0 THEN debian.name
  ELSE
    SUBSTR(debian.name, INSTR(debian.name,', ') + LENGTH(', ') ) ||
    ' ' ||
    SUBSTR(debian.name, 1, INSTR(debian.name,', ') - 1)
  END
  AS official_name,
  -- Relative Path to Flag Image, in SVG format
  wikimedia.path AS flag_image_path
FROM ipcc_country_names ipcc
LEFT JOIN unicode_2014_code_mappings mapping
ON ipcc.code = mapping.`Alpha-3 ISO Country Code`
LEFT JOIN unicode_2014_territories unicode
ON mapping.`Alpha-2 ISO Country Code` = unicode.`Territory Code`
AND unicode.`Name Type` = ""
LEFT JOIN (
  SELECT
    `Alpha-3 Country Code` code,
    CASE `Official Name`
      WHEN '' THEN Name
      ELSE `Official Name`
    END AS name
  FROM debian_2014_iso_codes
  WHERE `Date Withdrawn` = ''
) debian
ON ipcc.code = debian.code
LEFT JOIN wikimedia_country_flags wikimedia
ON ipcc.code = wikimedia.code
ORDER BY common_name
;

-- TODO: ipcc_members_history
-- A list of current and past members of the IPCC
  -- ISO Alpha-3 Country Code, for identification
  -- Common Country Name in English, for display
  -- Official Name in English, for disambiguation
  -- Start Date of IPCC Membership, in YYYY-MM-DD format
  -- End Date of IPCC Membership, in YYYY-MM-DD format (or NULL when ongoing)

CREATE VIEW eligible_ipcc_members
AS
-- A list of eligible IPCC members (i.e. members of UN and/or WMO)
-- NOTE: actual IPCC members are included

-- List of UN Members |>< WMO Members
SELECT
  -- ISO Alpha-3 Country Code, for identification
  un.code AS iso3_code,
  -- Common Country Name, for display
  unicode.`Territory Name` AS common_name,
  -- Convert from DD-MM-YYYY to YYYY-MM-DD:
  -- 1234567890
  -- DD-MM-YYYY
  SUBSTR(un2.`Date of Admission`,7,4) -- YYYY
  || "-"
  || SUBSTR(un2.`Date of Admission`,4,2) -- MM
  || "-"
  || SUBSTR(un2.`Date of Admission`,1,2) -- DD
  -- Start Date of UN membership
  -- in YYYY-MM-DD format, or NULL if not a UN member
  AS un_member_since,
  -- Start Date of WMO membership
  -- in YYYY-MM-DD format, or NULL if not a WMO member
  wmo.`Date of Membership` AS wmo_member_since
FROM un_country_names un
JOIN un_2015_members un2
ON un.name = replace(un2.`Member State`,char(0x200E),'')
JOIN unicode_2014_code_mappings mapping
ON un.code = mapping.`Alpha-3 ISO Country Code`
JOIN unicode_2014_territories unicode
ON mapping.`Alpha-2 ISO Country Code` = unicode.`Territory Code`
AND unicode.`Name Type` = ""
LEFT JOIN wmo_2015_members_territories wmo
ON un.code = wmo.`ISO Country Code`

UNION

-- List of WMO Members |>< UN Members
-- filtered to keep only WMO Members with no matching UN Member
SELECT
  -- ISO Alpha-3 Country Code, for identification
  wmo.`ISO Country Code` AS iso3_code,
  -- Common Country Name, for display
  unicode.`Territory Name` AS common_name,
  -- Start Date of UN membership
  -- in YYYY-MM-DD format, or NULL if not a UN member
  NULL AS un_member_since,
  -- Start Date of WMO membership
  -- in YYYY-MM-DD format, or NULL if not a WMO member
  wmo.`Date of Membership` AS wmo_member_since
FROM wmo_2015_members_territories wmo
JOIN unicode_2014_code_mappings mapping
ON wmo.`ISO Country Code` = mapping.`Alpha-3 ISO Country Code`
JOIN unicode_2014_territories unicode
ON mapping.`Alpha-2 ISO Country Code` = unicode.`Territory Code`
AND unicode.`Name Type` = ""
LEFT JOIN un_country_names un
ON un.code = wmo.`ISO Country Code`
WHERE un.code IS NULL -- no matching UN Member

ORDER BY common_name
;

.print "Info:"

SELECT COUNT(*) || " Current IPCC Members"
FROM current_ipcc_members
;

SELECT COUNT(*) || " Eligible IPCC Members"
FROM eligible_ipcc_members
;

SELECT COUNT(*) || " IPPC Members not part of Eligible IPCC Members"
FROM current_ipcc_members
JOIN eligible_ipcc_members
USING (iso3_code)
WHERE eligible_ipcc_members.iso3_code IS NULL
;

SELECT COUNT(*) || " Eligible IPCC Members not part of IPCC Members:"
FROM eligible_ipcc_members
LEFT JOIN current_ipcc_members
USING (iso3_code)
WHERE current_ipcc_members.iso3_code IS NULL
;

.headers on
SELECT eligible_ipcc_members.*
FROM eligible_ipcc_members
LEFT JOIN current_ipcc_members
USING (iso3_code)
WHERE current_ipcc_members.iso3_code IS NULL
;
.headers off

.print
.print "Checks:"
.mode list
.separator ' '

.print '1..2'
SELECT
  CASE
    WHEN COUNT(DISTINCT iso3_code) = COUNT(*)
    THEN "ok"
    ELSE "not ok"
  END,
  1,
  "Distinct IPCC Members expected: " || COUNT(DISTINCT iso3_code) ||
  ", found: " || COUNT(*)
FROM current_ipcc_members
;

SELECT
  CASE
    WHEN COUNT(DISTINCT iso3_code) = COUNT(*)
    THEN "ok"
    ELSE "not ok"
  END,
  2,
  "Distinct Eligible IPCC Members expected: " || COUNT(DISTINCT iso3_code) ||
  ", found: " || COUNT(*)
FROM eligible_ipcc_members
;

.mode csv
.headers on

.once current_ipcc_members.csv
SELECT *
FROM current_ipcc_members
;

.once eligible_ipcc_members.csv
SELECT *
FROM eligible_ipcc_members
;

.once database.sql
.dump

