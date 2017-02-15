#!/bin/sh

#./update_wiki.py
\rm -rf ./workbook
cp -rf ../doc/workbook .
.scripts/update_workbook.py
