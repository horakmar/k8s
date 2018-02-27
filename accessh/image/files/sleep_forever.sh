#!/bin/sh
set -eu

i=0

while true ; do 
  echo "Sleeping $i day(s)."
  i=$((i + 1))
  sleep 86400
done

