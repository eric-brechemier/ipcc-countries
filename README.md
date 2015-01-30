ipcc-countries
==============

Database of countries member of the Intergovernmental Panel on Climate Change

## Folder Hierarchy

* sources - data sources, grouped by origin
  * example.tld - each source is identified by corresponding domain name
    * step1, step2,... - one folder for each step to acquire the data,
                         extract it from the source document and transform
                         the data into CSV
    * source document (e.g. PDF, HTML or XML)
    * data.csv - data extracted from the source, in a close structure and format
    * meta.txt - metadata which describes the origin of the document,
                 with annotations in 'key: value' format (one per line),
                 optionally ending with an empty line and a multi-line
                 'description:' field.

* database - SQLite database with data aggregated, refined and cross-checked
  * step1, step2,... - one folder for each step to aggregate the data
                       from data sources, to refine it and cross-check it,
                       and export the database schema as a picture
  * database.sqlite3 - database in SQLite 3 format
  * schema.png - diagram of the database structure

* visualizations - data visualizations, grouped by question
  * who, what, where... - one folder for each question asked
    * step1, step2,... - one folder for each step to query the database and
                         export results in the format used in the data
                         visualization (e.g. CSV or JSON)
    * data visualization (e.g. HTML or Open Document Spreadsheet)
      which answers the question visually
