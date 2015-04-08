#!/bin/sh
cd "$(dirname "$0")"
currentPath=$(pwd)

cd ../../../..
git submodule update --init

cd "$currentPath"
cp -v iso-codes/iso_3166/iso_3166.xml .
cp -v iso_3166.xml ..
