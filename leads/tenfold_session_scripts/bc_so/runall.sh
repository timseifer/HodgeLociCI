#!/bin/bash
cd /home/claude/hodge/discovery/checks/bc_so
ulimit -v 3300000
M2 --script pc0.m2 > pc0.out 2>&1
M2 --script pc1.m2 11 32003 > pc1_s11_32003.out 2>&1
M2 --script main2.m2 2 32003 > main2_s2_32003.out 2>&1
M2 --script main2.m2 1 31991 > main2_s1_31991.out 2>&1
M2 --script main2.m2 2 31991 > main2_s2_31991.out 2>&1
echo ALLDONE > runall.done
