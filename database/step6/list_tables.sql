.read ../step5/database.sql

.mode csv
.headers on

.once database_tables.csv
SELECT type AS table_type, name AS table_name
FROM sqlite_master
;
