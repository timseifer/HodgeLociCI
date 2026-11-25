#!/bin/bash
# [TS-T6] resumed 14:1xZ: order-6 runs at split point g1 into runs2/ (fresh tables in tables2/), 1 thread
cd /home/claude/hodge/discovery/checks/ts_t6
ulimit -v 4000000
for P in 67108837 67108819; do
  for lam in 1 2 -1 1/2; do
    for sk in "1 al" "4 la" "2 al" "5 la"; do
      set -- $sk; S=$1; K=$2
      L=${lam/\//o}
      out=runs2/ts_g1_lam${L}_${P}_s${S}_${K}_N6.log
      [ -s $out ] && grep -q VERDICT $out && continue
      OMP_NUM_THREADS=1 OPENBLAS_NUM_THREADS=1 nice -n 10 python3 tsjob.py --lam $lam --p $P --gseed 1 --seed $S --kind $K --N 6 --threads 1 --out runs2 --tables tables2 > $out 2>&1
    done
  done
done
echo done > runs2/batch2.done
