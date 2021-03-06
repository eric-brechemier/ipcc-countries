#!/bin/sh
# requires sqlite3 (3.8.8.2)
# requires csvcut, from csvkit (0.9.0)
# requires csvformat, from csvkit (0.9.0)
# requires erd (master branch of my own fork)

cd "$(dirname "$0")"

echo 'List tables'
sqlite3 < list_tables.sql

cat << EOF > list_table_fields.sql
-- queries to export the fields of each table, generated by document.sh
.read ../step5/database.sql
.headers on
.nullvalue NULL
.mode csv
EOF

csvcut -c2 database_tables.csv |
tail -n +2 | # skip header
while read tableName
do
  echo ".once table_info_$tableName.csv"
  echo "pragma table_info($tableName);"
done >> list_table_fields.sql

echo 'Delete previous lists of fields'
rm -f table_info_*.csv

echo 'List fields of each database table'
sqlite3 < list_table_fields.sql

echo 'Combine table fields in a single file,'
echo 'adding type and name of table for disambiguation.'

tableHeader=''
while IFS="$IFS" read tableRecord
do
  if test -z "$tableHeader"
  then
    tableHeader="$tableRecord"
  else
    tableName="$(echo "$tableRecord" | csvcut -c2)"
    fieldsHeader=''

    while IFS='' read fieldsRecord
    do
      if test -z "$fieldsHeader"
      then
        fieldsHeader="$fieldsRecord"
        if test -z "$combinedHeader"
        then
          combinedHeader="$tableHeader,$fieldsHeader"
          echo "$combinedHeader"
        fi
      else
        echo "$tableRecord,$fieldsRecord"
      fi
    done < "table_info_$tableName.csv"
  fi
done < database_tables.csv > database_table_fields.csv

echo 'Convert the unified table information to erd format'
mainTableStyles="$(tail -n 1 main_tables_styles.erd)"
tableName=''
csvformat -D\| database_table_fields.csv |
tail -n +2 | # skip header
while IFS='|' read \
  table_type table_name cid name type notnull dflt_value pk
do
  if test "$tableName" != "$table_name"
  then
    tableName="$table_name"
    separator=''
    if test "$table_type" = 'view'
    then
      tableLabel="label: \"$table_type\""
      separator=', '
    else
      tableLabel=''
    fi
    if test -f "../$tableName.csv"
    then
      tableStyles="$separator$mainTableStyles"
    else
      tableStyles=''
    fi
    echo
    echo "[\`$tableName\`] {$tableLabel$tableStyles}"
  fi
  if test "$pk" = '1'
  then
    pkSymbol='*'
  else
    pkSymbol=''
  fi
  if test "$notnull" = '1'
  then
    notNull=', not null'
  else
    notNull=''
  fi
  if test -n "$type"
  then
    label=" {label: \"$type$notNull\"}"
  else
    label=''
  fi
  echo "$pkSymbol\`$name\`$label"
done > database_tables.erd

echo 'Add styles and relationships to the E/R diagram file'
cat \
  database_styles.erd \
  database_tables.erd \
  ../*/database_relationships.erd \
> database.erd

echo 'Convert erd file to a PNG picture of the E/R diagram'
erd -i database.erd -o database.png

if test $? -eq 0
then
  cp database.png ..
  echo 'Done.'
else
  rm database.png
  echo 'Conversion failed.'
fi
