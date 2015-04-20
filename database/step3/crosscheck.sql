-- load database prepared at previous step
.read ../step2/sources.sql

.mode csv

.once ipcc_2009_vs_2012.csv
SELECT *
FROM
(
  SELECT '-' diff, ic.`WMO Region (Region Number)` region, ic.country
  FROM ipcc_2009_ipcc_countries ic LEFT JOIN ipcc_2012_ipcc_members im
  USING ( `WMO Region (Region Number)`, `Country` )
  WHERE im.Country IS NULL
  UNION
  SELECT '+' diff, im.`WMO Region (Region Number)` region, im.country
  FROM ipcc_2012_ipcc_members im LEFT JOIN ipcc_2009_ipcc_countries ic
  USING ( `WMO Region (Region Number)`, `Country` )
  WHERE ic.Country IS NULL
)
ORDER BY region, country, diff
;

.once un_members_growth_vs_members.csv
SELECT *
FROM
(
  SELECT
    '-' diff,
    mg.`Year of Admission` year,
    mg.`Member State` country
  FROM un_2015_members_growth mg LEFT JOIN un_2015_members m
  ON m.`Member State` = mg.`Member State`
  AND SUBSTR(m.`Date of Admission`,7) = mg.`Year of Admission`
  WHERE m.`Member State` IS NULL
  UNION
  SELECT
    '+' diff,
    SUBSTR(m.`Date of Admission`,7) year,
    m.`Member State` country
  FROM un_2015_members m LEFT JOIN un_2015_members_growth mg
  ON m.`Member State` = mg.`Member State`
  AND SUBSTR(m.`Date of Admission`,7) = mg.`Year of Admission`
  WHERE mg.`Member State` IS NULL

)
ORDER BY year DESC, country, diff
;

.once wmo_composition_vs_members.csv
SELECT *
FROM
(
  SELECT
    '-' diff,
    SUBSTR(
      c.`WMO Member Name in English - French`,
      1,
      INSTR(c.`WMO Member Name in English - French`,' - ') - 1
    ) country,
    SUBSTR(c.`Date of Membership`,7)
    || '-'
    || SUBSTR(c.`Date of Membership`,4,2)
    || '-'
    || SUBSTR(c.`Date of Membership`,1,2)
    AS date
  FROM wmo_2014_wmo_composition c LEFT JOIN wmo_2015_members_territories m
  ON
    SUBSTR(
      c.`WMO Member Name in English - French`,
      1,
      INSTR(c.`WMO Member Name in English - French`,' - ') - 1
    ) = m.`English Country Name`
    AND
       SUBSTR(c.`Date of Membership`,7)
    || '-'
    || SUBSTR(c.`Date of Membership`,4,2)
    || '-'
    || SUBSTR(c.`Date of Membership`,1,2)
     = m.`Date of Membership`
  WHERE m.`English Country Name` IS NULL
  UNION
  SELECT
    '+' diff,
    m.`English Country Name` country,
    m.`Date of Membership` date
  FROM wmo_2015_members_territories m LEFT JOIN wmo_2014_wmo_composition c
  ON
    SUBSTR(
      c.`WMO Member Name in English - French`,
      1,
      INSTR(c.`WMO Member Name in English - French`,' - ') - 1
    ) = m.`English Country Name`
    AND
       SUBSTR(c.`Date of Membership`,7)
    || '-'
    || SUBSTR(c.`Date of Membership`,4,2)
    || '-'
    || SUBSTR(c.`Date of Membership`,1,2)
     = m.`Date of Membership`
  WHERE c.`Date of Membership` IS NULL
)
ORDER BY country, date, diff
;

.once debian_vs_unicode_code_mappings.csv
SELECT *
FROM
(
  SELECT
    'Debian' source,
    deb.`Alpha-3 Country Code` alpha3,
    deb.`Alpha-2 Country Code` alpha2,
    deb.`Numeric Code` numeric
  FROM debian_2014_iso_codes deb LEFT JOIN unicode_2014_code_mappings unicode
  ON deb.`Alpha-3 Country Code` = unicode.`Alpha-3 ISO Country Code`
  AND deb.`Alpha-2 Country Code` = unicode.`Alpha-2 ISO Country Code`
  AND deb.`Numeric Code` = unicode.`Numeric ISO Country Code`
  WHERE unicode.`Alpha-3 ISO Country Code` IS NULL
  UNION
  SELECT
    'Unicode' source,
    unicode.`Alpha-3 ISO Country Code` alpha3,
    unicode.`Alpha-2 ISO Country Code` alpha2,
    unicode.`Numeric ISO Country Code` numeric
  FROM unicode_2014_code_mappings unicode LEFT JOIN debian_2014_iso_codes deb
  ON unicode.`Alpha-3 ISO Country Code` = deb.`Alpha-3 Country Code`
  AND unicode.`Alpha-2 ISO Country Code` = deb.`Alpha-2 Country Code`
  AND unicode.`Numeric ISO Country Code` = deb.`Numeric Code`
  WHERE deb.`Alpha-3 Country Code` IS NULL
)
ORDER BY alpha3, source
;

.once wikidata_vs_unicode_code_mappings.csv
SELECT *
FROM
(
  SELECT
    'Wikidata' source,
    alpha3.Value alpha3,
    alpha2.Value alpha2,
    numeric.Value numeric
  FROM wikidata_entities alpha3
  LEFT JOIN wikidata_entities alpha2
  ON alpha3.Entity = alpha2.Entity
  LEFT JOIN wikidata_entities numeric
  ON alpha2.Entity = numeric.Entity
  LEFT JOIN unicode_2014_code_mappings unicode
  ON alpha3.Value = unicode.`Alpha-3 ISO Country Code`
  AND alpha2.Value = unicode.`Alpha-2 ISO Country Code`
  AND numeric.Value = unicode.`Numeric ISO Country Code`
  WHERE alpha3.`Value Name` = 'P298'
  AND alpha2.`Value Name` = 'P297'
  AND numeric.`Value Name` = 'P299'
  AND unicode.`Alpha-3 ISO Country Code` IS NULL
  UNION
  SELECT
    'Unicode' source,
    unicode.`Alpha-3 ISO Country Code` alpha3,
    unicode.`Alpha-2 ISO Country Code` alpha2,
    unicode.`Numeric ISO Country Code` numeric
  FROM unicode_2014_code_mappings unicode
  LEFT JOIN wikidata_entities alpha3
  ON alpha3.`Value Name` = 'P298'
  AND unicode.`Alpha-3 ISO Country Code` = alpha3.Value
  LEFT JOIN wikidata_entities alpha2
  ON alpha3.Entity = alpha2.Entity
  AND alpha2.`Value Name` = 'P297'
  AND unicode.`Alpha-2 ISO Country Code` = alpha2.Value
  LEFT JOIN wikidata_entities numeric
  ON numeric.`Value Name` = 'P299'
  AND alpha3.Entity = numeric.Entity
  AND unicode.`Numeric ISO Country Code` = numeric.Value
  WHERE alpha3.Value IS NULL
  OR alpha2.Value IS NULL
  OR numeric.Value IS NULL
)
ORDER BY alpha3, source
;

.once unicode_territories_vs_scripts_languages_territories.csv
SELECT *
FROM (
  SELECT '-' diff, t.`Territory Code` code, t.`Territory Name` name
  FROM unicode_2014_territories t
  LEFT JOIN unicode_2014_scripts_languages_territories slt
  USING ( `Territory Code`, `Territory Name` )
  WHERE slt.`Territory Code` IS NULL
  AND t.`Name Type`=''
  UNION
  SELECT '+' diff, slt.`Territory Code` code, slt.`Territory Name` name
  FROM unicode_2014_scripts_languages_territories slt
  LEFT JOIN unicode_2014_territories t
  USING ( `Territory Code`, `Territory Name` )
  WHERE t.`Territory Code` IS NULL
)
ORDER BY code, name, diff
;

.mode list
.separator ' '
.output asserts.tap.txt
SELECT '-- assertions results in TAP format (http://testanything.org)';
SELECT '1..2';
SELECT
  CASE COUNT(*)
    WHEN 0 THEN 'ok'
    ELSE 'not ok'
  END,
  1,
  'all entities from the API main query results are expected'
FROM wikidata_2015_api_query_backlinks_to_iso_alpha3 master
LEFT JOIN wikidata_entities entities
ON master.`Page Title` = entities.Entity
WHERE entities.Entity IS NULL
;
SELECT
  CASE COUNT(*)
    WHEN 0 THEN 'ok'
    ELSE 'not ok'
  END,
  2,
  'no extra entity is expected outside of the API main query results'
FROM wikidata_entities entities
LEFT JOIN wikidata_2015_api_query_backlinks_to_iso_alpha3 master
ON entities.Entity = master.`Page Title`
WHERE master.`Page Title` IS NULL
;
