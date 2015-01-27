#!/bin/sh
cd $(dirname "$0")

curl \
  --data-urlencode _method=POST \
  --data-urlencode \
    data%5Bcountryform%5D%5Bcountries%5D@../step1/countries.txt \
  https://www.wmo.int/cpdb/tools/countrymatcher \
> countrymatcher.html
