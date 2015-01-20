#!/bin/sh
# Requires: pdftk
cd $(dirname "$0")
wget http://www.ipcc.ch/pdf/ipcc-principles/ipcc-principles-elections-rules.pdf
pdftk A=ipcc-principles-elections-rules.pdf cat A8-10 output annexA.pdf
cp annexA.pdf ..
