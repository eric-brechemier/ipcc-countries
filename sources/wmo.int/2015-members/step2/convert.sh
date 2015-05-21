#!/bin/sh
# Requires: jq (1.4)

dataset='members'

cd "$(dirname "$0")"
jq --from-file convert.jq \
  --raw-output \
  < "../step1/$dataset.json" \
  > data.csv
cp data.csv ..
