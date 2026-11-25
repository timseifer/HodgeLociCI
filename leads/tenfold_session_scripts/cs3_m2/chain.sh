#!/bin/bash
cd /home/claude/hodge/discovery/checks/cs3_m2
while pgrep -f "queue.sh jobs" > /dev/null; do sleep 10; done
for f in "$@"; do ./queue.sh $f; done
