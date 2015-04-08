#!/bin/sh
# Requires: pdftk
cd "$(dirname "$0")"
wget http://www.wmo.int/wmocomposition/documents/wmocomposition.pdf
pdftk A=wmocomposition.pdf cat A4-16 output membership.pdf
cp membership.pdf ..
