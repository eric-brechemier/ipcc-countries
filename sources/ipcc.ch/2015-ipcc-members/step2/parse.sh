#!/bin/sh
# Requires: pdftotext (from poppler-utils)
cd "$(dirname "$0")"
pdftotext -nopgbrk ../step1/annexA.pdf annexA.txt
