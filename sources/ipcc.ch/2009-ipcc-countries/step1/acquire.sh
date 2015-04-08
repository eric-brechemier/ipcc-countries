#!/bin/sh
cd "$(dirname "$0")"
wget https://ipcc.ch/pdf/ipcc-principles/ipcc-countries.pdf
cp ipcc-countries.pdf ..
