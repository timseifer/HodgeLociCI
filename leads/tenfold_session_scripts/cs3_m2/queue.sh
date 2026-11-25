#!/bin/bash
# sequential queue; skips jobs with a finished output; usage: queue.sh jobsfile
cd /home/claude/hodge/discovery/checks/cs3_m2
while read -r job; do
  set -- $job; s=$1; shift; tag=$(echo "$@" | tr ' ' '_'); o=${s%.m2}_${tag}.out
  [ -f $o ] && grep -q "^exit 0" $o && continue
  echo "$(date -u +%H:%MZ) start $job" >> queue.log; ./run.sh $s "$@"; echo "$(date -u +%H:%MZ) end $job" >> queue.log
done < $1
echo "done $1 $(date -u +%H:%MZ)" >> queue.log
