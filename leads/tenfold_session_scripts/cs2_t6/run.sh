#!/bin/bash
# usage: run.sh script seed p typ ; 1 job, nice, 3.2 GB virtual cap; records peak RSS
cd /home/claude/hodge/discovery/checks/cs2_t6
ulimit -v 3200000
s=$1; out=${s%.m2}_$4$5_$2_$3.out
nice -n 10 M2 --script $s $2 $3 $4 $5 > $out 2>&1 &
pid=$!; peak=0
while kill -0 $pid 2>/dev/null; do r=$(awk '/VmHWM/{print $2}' /proc/$pid/status 2>/dev/null); [ -n "$r" ] && peak=$r; sleep 5; done
wait $pid; echo "exit $? peakRSS_kB $peak" >> $out
