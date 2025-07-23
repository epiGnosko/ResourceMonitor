#!/bin/bash

echo -e "\033[2J\033[H"
while IFS= read -r line; do 
  echo -e $line
done < details.csv | column -s"," -t
