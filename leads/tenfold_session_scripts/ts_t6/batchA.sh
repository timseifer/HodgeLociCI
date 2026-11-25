#!/bin/bash
# order-6 tests at the split point (TS-T6)
cd /home/claude/hodge/discovery/checks/ts_t6
ulimit -v 2500000
for spec in "67108837 1" "67108819 1" "67108837 2" "67108819 2"; do
  set -- $spec; P=$1; G=$2
  for lam in -1 2 1/2 1; do
    for sk in "1 al" "4 la"; do
      set -- $sk; S=$1; K=$2
      L=${lam/\//o}
      out=runs/ts_g${G}_lam${L}_${P}_s${S}_${K}_N6.log
      [ -s $out ] && grep -q VERDICT $out && continue
      nice -n 10 python3 tsjob.py --lam $lam --p $P --gseed $G --seed $S --kind $K --N 6 --threads 2 --out runs > $out 2>&1
    done
  done
done
echo done > batchA.done
