#!/bin/bash

intervalSecs=1

cleanup() {
  rm init.csv finl.csv details.csv 2> /dev/null
  exit 0
}

trap cleanup EXIT
trap cleanup INT
trap cleanup TERM

clear
while true; do 
  ./input.sh init.csv
  sleep $intervalSecs
  ./input.sh finl.csv
  
  echo "CPU/Core,%usage,Status" > details.csv
  
  exec 3<init.csv
  exec 4<finl.csv
  
  while true; do
    IFS= read -r initline <&3 || break
    IFS= read -r finlline <&4 || break

    core=$(echo $initline | cut -d, -f1)
    inittotal=$(echo $initline | cut -d, -f1 --complement | sed "s/,/+/g" | bc)
    finltotal=$(echo $finlline | cut -d, -f1 --complement | sed "s/,/+/g" | bc)

    initidle=$(echo $initline | cut -d, -f5)
    finlidle=$(echo $finlline | cut -d, -f5)

    deltatotal=$(echo "$finltotal-$inittotal" | bc)
    deltaidle=$(echo "$finlidle-$initidle" | bc)

    usage=$(echo "($deltatotal-$deltaidle)*100/$deltatotal" | bc)

    if [[ $usage -gt 80 ]]; then
      echo "$core,$usage,\x1b[31mHIGH\x1b[0m" >> details.csv
    else
      echo "$core,$usage,\x1b[32m OK \x1b[0m" >> details.csv
    fi
  done;

  ./draw.sh 
done
