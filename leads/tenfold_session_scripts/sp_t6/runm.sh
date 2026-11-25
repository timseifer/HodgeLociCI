#!/bin/bash
# runm.sh LOG cmd...  : run with nice 10, 2.5 GB cap, record wall time, CPU time and peak RSS (from /proc) in LOG.time
LOG=$1; shift
( ulimit -v 2500000; exec nice -n 10 "$@" ) > "$LOG" 2>&1 &
PID=$!; PEAK=0; T0=$(date +%s)
while kill -0 $PID 2>/dev/null; do
  for c in $PID $(pgrep -P $PID); do r=$(awk '/VmHWM/{print $2}' /proc/$c/status 2>/dev/null); [ -n "$r" ] && [ "$r" -gt "$PEAK" ] && PEAK=$r; done
  sleep 1
done
wait $PID; RC=$?
echo "rc $RC wall $(( $(date +%s) - T0 ))s peakRSS ${PEAK}kB" > "$LOG.time"; cat "$LOG.time"
