#!/bin/sh
cd "$(dirname "$0")"
wget http://unicode.org/repos/cldr/trunk/unicode-license.txt
wget http://unicode.org/repos/cldr/trunk/common/main/en.xml
cp en.xml ..
