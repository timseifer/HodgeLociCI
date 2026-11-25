#!/bin/bash
cd /home/claude/hodge/discovery/checks/dp_t6
ulimit -v 1900000
for a in "1 32003" "2 32003" "1 31991" "2 31991"; do set -- $a
  ( time nice -n 10 M2 --script dp.m2 $1 $2 > dp_$1_$2.out 2> dp_$1_$2.err )
done
echo ALLDONE > run.done
