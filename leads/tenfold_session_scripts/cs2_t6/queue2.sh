#!/bin/bash
cd /home/claude/hodge/discovery/checks/cs2_t6
while read -r job; do
  set -- $job; o=${1%.m2}_$4$5_$2_$3.out; [ -f $o ] && grep -q "^exit 0" $o && continue
  echo "$(date -u +%H:%MZ) start $job" >> queue.log; ./run.sh $1 $2 $3 $4 $5; echo "$(date -u +%H:%MZ) end $job" >> queue.log
done < jobs2.txt
echo done2 >> queue.log
