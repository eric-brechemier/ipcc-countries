#!/bin/sh
cd "$(dirname "$0")"
curl https://www.wmo.int/cpdb/data/membersandterritories \
  > membersandterritories.html
curl https://www.wmo.int/cpdb/data/membersandterritories.json \
  > membersandterritories.json
