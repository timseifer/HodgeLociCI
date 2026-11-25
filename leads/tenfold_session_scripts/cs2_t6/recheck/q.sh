#!/bin/bash
cd /home/claude/hodge/discovery/checks/cs2_t6/recheck; ulimit -v 3200000
run() { o=$1_$4_$2_$3.out; [ -f $o ] && grep -q "^exit 0" $o && return; nice -n 10 M2 --script $1.m2 $2 $3 $4 > $o 2>&1; echo "exit $?" >> $o; }
if [ "$1" = A ]; then
 for j in "1 32003 R22" "2 32003 R22" "1 31991 R22" "2 31991 R22" "1 32003 R23" "2 32003 R23" "1 31991 R23" "2 31991 R23" "1 32003 R33" "1 31991 R33"; do run rd $j; done
else
 for j in "1 32003 PL" "2 32003 PL" "1 32003 PL2"; do run re $j; done
 for j in "1 32003 R222" "1 31991 R222" "2 32003 R33"; do run rd $j; done
fi
echo done$1 >> ../queue.log
