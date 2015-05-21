#!/bin/sh
cd "$(dirname "$0")"

dataset='territories'

curl "https://www.wmo.int/cpdb/data/$dataset" \
  > "$dataset.html"
curl "https://www.wmo.int/cpdb/data/$dataset.json" \
  > "$dataset.json"
