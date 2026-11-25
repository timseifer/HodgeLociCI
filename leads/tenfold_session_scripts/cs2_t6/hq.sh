#!/bin/bash
cd /home/claude/hodge/discovery/checks/cs2_t6; ulimit -v 3200000
for sp in "1 32003" "2 31991" "1 31991" "2 32003"; do set -- $sp
  [ -f h3v_$1_$2.out ] || nice -n 10 M2 --script h3v.m2 $1 $2 H3a > h3v_$1_$2.out 2>&1
  [ -f h1b_$1_$2.out ] || nice -n 10 M2 --script h1b.m2 $1 $2 H1 > h1b_$1_$2.out 2>&1
done; echo hqdone >> queue.log
