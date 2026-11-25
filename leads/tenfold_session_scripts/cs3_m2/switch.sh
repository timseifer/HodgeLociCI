#!/bin/bash
cd /home/claude/hodge/discovery/checks/cs3_m2
while ! grep -q "end nl.m2 1 32003 R5" queue.log; do sleep 2; done
pkill -f "queue.sh jobs4"; sleep 1; pkill -f "run.sh nl.m2 1 32003 U15"; pkill -f "M2-binary --script nl.m2 1 32003 U15"; sleep 1; rm -f nl_1_32003_U15.out
echo "$(date -u +%H:%MZ) switched to jobs5 (low-bound DS first)" >> queue.log
./queue.sh jobs5.txt
