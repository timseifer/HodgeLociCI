#!/bin/bash
# [TS-T6] step 2: gseed 2 order 6 (lambda 1, 2, -1), then lambda = -1 order 8 at gseed 1 (runs2/), 1 thread
cd /home/claude/hodge/discovery/checks/ts_t6
ulimit -v 4000000
while [ ! -f runs2/batch2.done ]; do sleep 20; done
run() { # lam P G S K N
  L=${1/\//o}; out=runs2/ts_g$3_lam${L}_$2_s$4_$5_N$6.log
  [ -s $out ] && grep -q VERDICT $out && return
  OMP_NUM_THREADS=1 OPENBLAS_NUM_THREADS=1 nice -n 10 python3 tsjob.py --lam $1 --p $2 --gseed $3 --seed $4 --kind $5 --N $6 --threads 1 --out runs2 --tables tables2 > $out 2>&1
}
for P in 67108837 67108819; do for lam in 1 2 -1; do for sk in "1 al" "4 la" "2 al" "5 la"; do run $lam $P 2 $sk 6; done; done; done
echo g2done > runs2/batch3.g2done
for sk in "1 al" "4 la" "2 al" "5 la"; do for P in 67108837 67108819; do run -1 $P 1 $sk 8; done; done
echo done > runs2/batch3.done
