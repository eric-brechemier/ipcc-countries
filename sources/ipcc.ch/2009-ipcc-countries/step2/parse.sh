#!/bin/sh
# Requires: pdftotext (from poppler-utils)
cd $(dirname "$0")
pdftotext ../step1/ipcc-countries.pdf ipcc-countries.txt