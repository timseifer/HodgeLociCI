#!/bin/bash
export GC_MARKERS=1 OMP_NUM_THREADS=1
cd /home/claude/blind_check3
for ps in "32003 2" "31991 1" "31991 2"; do
  set -- $ps
  timeout 300 M2 --script c456.m2 $1 $2 > c456_$1_$2.log 2>&1
done
for ps in "32003 2" "31991 1" "31991 2"; do
  set -- $ps
  timeout 300 M2 --script c3.m2 $1 $2 > c3_$1_$2.log 2>&1
done
timeout 300 M2 --script c1.m2 31991 2 > c1_31991_2.log 2>&1
timeout 460 M2 --script c2.m2 31991 2 > c2_31991_2.log 2>&1
echo CHAIN1 DONE > chain1.done
