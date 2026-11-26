#!/bin/sh
# all runs of PREREG_plane.md; logs in logs/
cd "$(dirname "$0")"
for p in 32003 31991; do for s in 1 2; do for m in B G; do
  [ -f logs/pl1_${p}_seed${s}_${m}.log ] && grep -q RESULT logs/pl1_${p}_seed${s}_${m}.log && continue
  timeout 1500 M2 --script pl1_count.m2 $p $s $m > logs/pl1_${p}_seed${s}_${m}.log 2>&1; echo EXIT $? >> logs/pl1_${p}_seed${s}_${m}.log
done; done; done
echo ALLDONE > logs/done.flag
