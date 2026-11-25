#!/bin/bash
ulimit -v 2000000
cd /home/claude/hodge/discovery/checks/nf_t6
for lam in -3 -1/3 4 1; do f=A_$(echo $lam|tr / o)_1_al.log; nice -n 10 python3 gen_lam.py 67108837 0 $lam 1 al 6 > $f 2>&1; done
echo DONE > runA2.done
