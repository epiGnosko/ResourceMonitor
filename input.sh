#!/bin/bash

filename=$1

if [[ filename = "init.csv" && -f finl.csv ]]; then
  mv finl.csv init.csv;
  exit 0
fi 

cat /proc/stat | grep cpu | sed "s/\s/,/g" | sed "1s/,,/,/" > $1
