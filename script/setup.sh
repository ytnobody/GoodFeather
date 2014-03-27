#!/bin/sh
carton install &&
sqlite3 ./var/db.sqlite3 < ./sql/create.sql &&
echo 'SETUP DONE.'

