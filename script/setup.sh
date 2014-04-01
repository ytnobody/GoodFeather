#!/bin/sh
carton install &&
echo 'CREATE DATABASE good_feather' | mysql -u root &&
mysql -u root good_feather < ./sql/mysql.sql &&
echo 'SETUP DONE.'

