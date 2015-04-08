#!/bin/sh
# Requires: pdftotext (from poppler-utils)
cd "$(dirname "$0")"
pdftotext -layout -nopgbrk ../step1/membership.pdf membership.txt
