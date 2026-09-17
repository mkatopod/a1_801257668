#!/bin/sh
set -eu

printf 'level,bytes\n'
lscpu | awk '
  /L1d cache:/ { gsub(/K/, "", $3); print "L1," $3 * 1024 }
  /L2 cache:/  { gsub(/K/, "", $3); print "L2," $3 * 1024 }
  /L3 cache:/  { gsub(/M/, "", $3); print "L3," $3 * 1024 * 1024 }
'