#!/bin/bash
# usage: run.sh seed p typ ; 1 job, nice, 3.2 GB virtual cap; records peak RSS
cd /home/claude/hodge/discovery/checks/cs_t6d
ulimit -v 3200000
out=d3_$3_$1_$2.out
nice -n 10 M2 --script d3.m2 $1 $2 $3 > $out 2>&1 &
pid=$!; peak=0
while kill -0 $pid 2>/dev/null; do r=$(awk '/VmHWM/{print $2}' /proc/$pid/status 2>/dev/null); [ -n "$r" ] && peak=$r; sleep 5; done
wait $pid; echo "exit $? peakRSS_kB $peak" >> $out
