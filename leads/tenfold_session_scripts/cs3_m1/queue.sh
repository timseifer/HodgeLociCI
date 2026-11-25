#!/bin/sh
cd /home/claude/hodge/discovery/checks/cs3_m1
for job in "1 32003 G 3" "1 31991 G 3" "1 32003 cp 2"; do
  set -- $job; t=$3_$1_$2
  if grep -q "^END" log_$t.txt 2>/dev/null; then continue; fi
  nice -n 5 M2 --script m1run.m2 $job >> run_$t.out 2>&1
done
grep -q "c0a" log_c0a.txt 2>/dev/null || nice -n 5 M2 --script c0.m2 31981 > log_c0a.txt 2>&1
grep -q "c0b " log_c0b_1_31981.txt 2>/dev/null && grep -q "c0b PASS\|c0b FAIL" log_c0b_1_31981.txt || nice -n 5 M2 --script c0b.m2 1 31981 > run_c0b.out 2>&1
echo done $(date -u) >> queue.log
