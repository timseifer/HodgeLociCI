#!/bin/bash
cd /home/claude/hodge/discovery/checks/cs2_t6
for job in "g1.m2 1 32003 L1" "g1.m2 1 31991 L1" "g1.m2 2 32003 L1" "g1.m2 2 31991 L1" "g1.m2 1 32003 L2" "g1.m2 1 31991 L2" "g1.m2 2 32003 L2" "g1.m2 2 31991 L2" "g3.m2 1 32003 L3" "g3.m2 1 31991 L3" "g3.m2 2 32003 L3" "g3.m2 2 31991 L3"; do
  set -- $job; o=${1%.m2}_$4_$2_$3.out; [ -f $o ] && grep -q "^exit 0" $o && continue
  echo "$(date -u +%H:%MZ) start $job" >> queue.log; ./run.sh $1 $2 $3 $4; echo "$(date -u +%H:%MZ) end $job" >> queue.log
done
echo done >> queue.log
