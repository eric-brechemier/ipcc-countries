#!/bin/sh
cd $(dirname "$0")
sqlite3 < refine.sql
