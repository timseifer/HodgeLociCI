#!/bin/bash
cd /home/claude/hodge/discovery/checks/so_t6
for job in "1 32003 h" "2 31991 G" "2 32003 h"; do
  set -- $job
  out=t10f_${3}_${1}_${2}_r.out
  echo "start $job $(date -u +%H:%M:%SZ)" >> run_resume.log
  nice -n 10 M2 --script t10f.m2 $1 $2 $3 > $out 2>&1
  echo "end $job rc=$? $(date -u +%H:%M:%SZ)" >> run_resume.log
done
