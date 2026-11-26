#!/bin/sh
# R8 at both primes.  From this folder:  sh run_pr8.sh
for a in "32003 1" "31991 2"; do set -- $a
  (timeout 1500 M2 --script pr8_equisingular.m2 $1 $2 > logs/pr8_$1_seed$2.log 2>&1; echo EXIT $? >> logs/pr8_$1_seed$2.log)
done
