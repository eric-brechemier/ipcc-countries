ipcc-countries
==============

Database of countries member of the Intergovernmental Panel on Climate Change

## Folder Hierarchy

* sources - data sources, grouped by origin
  * example.tld - each source is identified by corresponding domain name
    * dataset - each data set, optionally prefixed by the year of publication
      * step1, step2,... - one folder for each step to acquire the data,
                           extract it from the source document and transform
                           the data into CSV
      * source document (e.g. PDF, HTML or XML)
      * data.csv - data extracted from the source,
                   in a structure and format
                   close to the original source
                   to facilitate the comparison
      * data - optionally, one folder for "attached files" downloaded
               from URLs described in the data. The relative path to
               these files is given in an extra column of data.csv.
      * meta.txt - metadata which describes the origin of the document,
                   with annotations in 'key: value' format (one per line),
                   optionally ending with an empty line and a multi-line
                   'description:' field.

* database - database with data aggregated, refined and cross-checked
  * step1, step2,... - one folder for each step to aggregate the data
                       from data sources, to refine it and cross-check it,
                       and to export each database table as a CSV file,
                       and the database schema as a picture
  * data - folder for "attached" files: country flags in CSV format
  * \*.csv - selection of database views in CSV format
  * database.sql - full sqlite database in SQL format;
                   can be loaded in sqlite3 with '.read database.sql'
  * database.png - diagram of database (entity/relationships)

* visualizations - data visualizations, grouped by question
  * what, where, when... - one folder for each question asked
    * step1, step2,... - one folder for each step to query the database and
                         export results in the format used in the data
                         visualization (e.g. HTML, CSV or JSON)
    * data visualization (e.g. HTML or Open Document Spreadsheet)
      which answers the question visually

## Online Visualizations

* [Who are the Member Countries of the Intergovernmental Panel on Climate Change (IPCC)?]
  (http://eric-brechemier.github.io/ipcc-countries/visualizations/who/)
* [How does a country become a member of the Intergovernmental Panel on Climate Change (IPCC)?]
  (http://eric-brechemier.github.io/ipcc-countries/visualizations/how/)
