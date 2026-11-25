#!/bin/bash
cd /home/claude/hodge/discovery/checks/cs_t6d
for j in "2 32003 R222" "1 31991 R222" "2 31991 R222" "1 31991 R33" "2 31991 R33"; do
  set -- $j; [ -f d3_$3_$1_$2.out ] && grep -q "^RESULT" d3_$3_$1_$2.out && continue
  ./run.sh $1 $2 $3
done
echo QUEUE DONE > queue.done
