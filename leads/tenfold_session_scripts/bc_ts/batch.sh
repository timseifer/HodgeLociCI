#!/bin/bash
# [BC-TS] order-6 grid with own engine, 1 thread, nice, 4 GB
cd /home/claude/hodge/discovery/checks/bc_ts
ulimit -v 4000000
for P in 67108837 67108819; do for lam in 2 -1 1 1/2; do for sk in "1 al" "4 la" "2 al" "5 la"; do
  set -- $sk; L=${lam/\//o}; out=runs/bc_g1_lam${L}_${P}_s$1_$2.log
  [ -s $out ] && grep -q BC-VERDICT $out && continue
  OMP_NUM_THREADS=1 OPENBLAS_NUM_THREADS=1 nice -n 10 python3 bcjob.py --lam $lam --p $P --seed $1 --kind $2 > $out 2>&1
done; done; done
echo done > runs/batch.done
