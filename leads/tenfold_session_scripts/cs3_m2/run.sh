#!/bin/bash
# usage: run.sh script seed p [args...] ; 1 job, nice, 3.2 GB virtual cap; records peak RSS
cd /home/claude/hodge/discovery/checks/cs3_m2
ulimit -v 3200000
s=$1; shift; tag=$(echo "$@" | tr ' ' '_'); out=${s%.m2}_${tag}.out
nice -n 10 M2 --script $s "$@" > $out 2>&1 &
pid=$!; peak=0
while kill -0 $pid 2>/dev/null; do r=$(awk '/VmHWM/{print $2}' /proc/$pid/status 2>/dev/null); [ -n "$r" ] && peak=$r; sleep 5; done
wait $pid; echo "exit $? peakRSS_kB $peak $(date -u +%H:%MZ)" >> $out
