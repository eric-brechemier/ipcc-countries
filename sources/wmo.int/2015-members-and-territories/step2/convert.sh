#!/bin/sh
# Requires: jq (1.4)

cd $(dirname "$0")
jq --from-file convert.jq \
  --raw-output \
  < ../step1/membersandterritories.json \
  > data.csv
cp data.csv ..
