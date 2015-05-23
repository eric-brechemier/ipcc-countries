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
  wikimedia.path AS flag_image_path,
  -- URL of Country page on Wikipedia
  'https://en.wikipedia.org/wiki/' || REPLACE(enwiki.Value,' ','_')
  AS wikipedia_url
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
LEFT JOIN wikidata_entities iso3
ON ipcc.code = iso3.Value
AND iso3.`Value Name` = 'P298'
LEFT JOIN wikidata_entities enwiki
ON iso3.Entity = enwiki.Entity
AND enwiki.`Value Name` = 'site'
AND enwiki.`Value Type` = 'enwiki'
ORDER BY common_name
;

CREATE VIEW current_un_members
AS
-- A list of current members of the UN
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
  AS un_member_since
FROM un_country_names un
JOIN un_2015_members un2
ON un.name = replace(un2.`Member State`,char(0x200E),'')
JOIN unicode_2014_code_mappings mapping
ON un.code = mapping.`Alpha-3 ISO Country Code`
JOIN unicode_2014_territories unicode
ON mapping.`Alpha-2 ISO Country Code` = unicode.`Territory Code`
AND unicode.`Name Type` = ""
ORDER BY common_name
;

CREATE VIEW current_wmo_members
AS
-- A list of current WMO Members
SELECT
  -- ISO Alpha-3 Country Code, for identification
  wmo.`ISO Country Code` AS iso3_code,
  -- Common Country Name, for display
  IFNULL(unicode.`Territory Name`,wmo.`English Country Name`) AS common_name,
  -- State (Member Country) or Territory (Member Territory)
  wmo.state_or_territory AS state_or_territory,
  -- Start Date of WMO membership
  -- in YYYY-MM-DD format, or NULL if not a WMO member
  SUBSTR(wmo.`Date of Membership`,1,10) AS wmo_member_since
FROM (
  SELECT *, 'State' AS state_or_territory
  FROM wmo_2015_members
  UNION
  SELECT *, 'Territory' AS state_or_territory
  FROM wmo_2015_territories
) wmo
LEFT JOIN unicode_2014_code_mappings mapping
ON wmo.`ISO Country Code` = mapping.`Alpha-3 ISO Country Code`
LEFT JOIN unicode_2014_territories unicode
ON mapping.`Alpha-2 ISO Country Code` = unicode.`Territory Code`
AND unicode.`Name Type` = ""
ORDER BY common_name
;

.print "Info:"

SELECT COUNT(*) || " Current IPCC Members"
FROM current_ipcc_members
;

SELECT COUNT(*) || " Current UN Members"
FROM current_un_members
;

SELECT COUNT(*) || " Current WMO Members"
FROM current_wmo_members
;

.print
.print "Checks:"
.mode list
.separator ' '

.print '1..6'
SELECT
  CASE
    WHEN COUNT(DISTINCT iso3_code) = COUNT(*)
    THEN "ok"
    ELSE "not ok"
  END,
  1,
  "All IPCC members must be distinct."
FROM current_ipcc_members
;

SELECT
  CASE
    WHEN COUNT(DISTINCT iso3_code) = COUNT(*)
    THEN "ok"
    ELSE "not ok"
  END,
  2,
  "All UN members must be distinct."
FROM current_un_members
;

SELECT
  CASE
    WHEN COUNT(DISTINCT iso3_code) = COUNT(*)
    THEN "ok"
    ELSE "not ok"
  END,
  3,
  "All WMO members must be distinct."
FROM current_wmo_members
;

SELECT
  CASE
    WHEN COUNT(*) = 0
    THEN "ok"
    ELSE "not ok"
  END,
  4,
  "Every UN Member is an IPCC Member"
FROM current_un_members un
LEFT JOIN current_ipcc_members ipcc
USING (iso3_code)
WHERE ipcc.iso3_code IS NULL
;

SELECT
  CASE
    WHEN COUNT(*) = 0
    THEN "ok"
    ELSE "not ok"
  END,
  5,
  "Every WMO Member State is an IPCC Member"
FROM current_wmo_members wmo
LEFT JOIN current_ipcc_members ipcc
USING (iso3_code)
WHERE wmo.state_or_territory = 'State'
AND ipcc.iso3_code IS NULL
;

SELECT
  CASE
    WHEN COUNT(*) = 0
    THEN "ok"
    ELSE "not ok"
  END,
  6,
  "No IPCC Member is neither a UN Member nor a WMO Member State"
FROM current_ipcc_members
LEFT JOIN (
  SELECT iso3_code
  FROM current_un_members
  UNION
  SELECT iso3_code
  FROM current_wmo_members
  WHERE state_or_territory = 'State'
) eligible_ipcc_members
USING (iso3_code)
WHERE eligible_ipcc_members.iso3_code IS NULL
;

.mode csv
.headers on

.once current_ipcc_members.csv
SELECT *
FROM current_ipcc_members
;

.once current_un_members.csv
SELECT *
FROM current_un_members
;

.once current_wmo_members.csv
SELECT *
FROM current_wmo_members
;

.once database.sql
.dump

