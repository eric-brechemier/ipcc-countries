-- import all CSV files into separate tables
.echo on
.mode csv

.read import_csv.sql

.tables

.once sources.sql
.dump
