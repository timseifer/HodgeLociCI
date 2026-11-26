#!/bin/sh
# second prime for R4 and R5.  From this folder:  sh run_rest.sh
(timeout 900 M2 --script pr4_identity.m2 31991 2 > logs/pr4_31991_seed2.log 2>&1; echo EXIT $? >> logs/pr4_31991_seed2.log)
(timeout 1500 M2 --script pr5_tangent.m2 31991 2 > logs/pr5_31991_seed2.log 2>&1; echo EXIT $? >> logs/pr5_31991_seed2.log)
