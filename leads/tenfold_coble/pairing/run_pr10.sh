#!/bin/sh
# R10: formal arcs to order 6 at both primes (in parallel; about 25 minutes each on one core).  From this folder:  sh run_pr10.sh
(timeout 3000 M2 --script pr10_arcs.m2 32003 1 6 > logs/pr10_32003_seed1_order6.log 2>&1; echo EXIT $? >> logs/pr10_32003_seed1_order6.log) &
(timeout 3000 M2 --script pr10_arcs.m2 31991 2 6 > logs/pr10_31991_seed2_order6.log 2>&1; echo EXIT $? >> logs/pr10_31991_seed2_order6.log) &
wait
