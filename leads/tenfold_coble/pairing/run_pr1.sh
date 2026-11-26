#!/bin/sh
# R1: both primes.  From this folder:  sh run_pr1.sh
for a in "32003 1" "31991 2"; do set -- $a
  (timeout 3000 M2 --script pr1_rungs.m2 $1 $2 > logs/pr1_$1_seed$2.log 2>&1; echo EXIT $? >> logs/pr1_$1_seed$2.log)
done
