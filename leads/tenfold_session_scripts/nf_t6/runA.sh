#!/bin/bash
ulimit -v 2000000
cd /home/claude/hodge/discovery/checks/nf_t6
for lam in -1 -2 -1/2 3 1/3 1/2 2; do for sk in "1 al" "4 la"; do set -- $sk
 f=A_$(echo $lam|tr / o)_$1_$2.log; [ -s $f ] && grep -q HISTORY $f && continue
 nice -n 10 python3 gen_lam.py 67108837 0 $lam $1 $2 6 > $f 2>&1
done; done
echo DONE > runA.done
