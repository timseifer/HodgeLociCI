#!/bin/bash
cd /home/claude/hodge/discovery/checks/dp_t6
while pgrep -f run3.sh > /dev/null; do sleep 30; done
ulimit -v 1900000
for a in "1 32003" "2 31991"; do set -- $a
  ( time nice -n 10 M2 --script c1.m2 $1 $2 > c1_$1_$2.out 2> c1_$1_$2.err )
done
echo DONE > run4.done
