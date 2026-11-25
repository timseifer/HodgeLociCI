#!/bin/bash
# Production runs.  Usage:  ./run_jobs.sh small|medium|large
#   small  = PC, 8 cores / 32 GB      : EX-T6 arcs to order 14, generic directions to order 10
#   medium = 16 cores / 64 GB         : EX-T6 arcs to order 15, generic directions to order 11
#   large  = 64 cores / 256 GB        : EX-T6 arcs to order 15, generic directions to order 12
# Each run prints one block per order; a run to order N also reproduces all lower orders (checked against
# expected/ at the end).  Runs are sequential, each uses all cores (override with THREADS=...).
set -u
cd "$(dirname "$0")"
SIZE=${1:-small}; T=${THREADS:-$(nproc)}
case $SIZE in
  small)  NARC=14; NGEN=10;;
  medium) NARC=15; NGEN=11;;
  large)  NARC=15; NGEN=12;;
  *) echo "usage: $0 small|medium|large"; exit 1;;
esac
mkdir -p results
python3 estimate.py > results/estimate.txt
uname -a > results/machine.txt; nproc >> results/machine.txt; free -g >> results/machine.txt 2>/dev/null
for p in 67108837 67108819; do for k in al la; do
  L=results/exarc_${p}_0_${k}_N${NARC}.log
  [ -f $L ] && grep -q HISTORY $L && continue
  python3 run_arc.py $p 0 $k $NARC --threads $T --out results > $L 2>&1 || echo "run failed (see the end of $L; usually: not enough memory -> use a smaller size)"
done; done
for p in 67108837 67108819; do for s in 1 2 3 4 5 6; do k=al; [ $s -gt 3 ] && k=la
  L=results/generic_${p}_s${s}_${k}_N${NGEN}.log
  [ -f $L ] && grep -q HISTORY $L && continue
  python3 run_job.py inputs/dir_${p}_s${s}_${k}.json $NGEN --threads $T --out results > $L 2>&1 || echo "run failed (see the end of $L; usually: not enough memory -> use a smaller size)"
done; done
echo "== consistency with the original lower-order runs"
for L in results/exarc_*.log; do b=$(basename $L .log); key=${b%_N*}; e=$(ls expected/${key}_*.log 2>/dev/null | head -1); [ -n "$e" ] && echo "$b: $(python3 check_expected.py $L $e)"; done
for L in results/generic_*.log; do b=$(basename $L .log); key=${b%_N*}; e=$(ls expected/${key}_N*.log 2>/dev/null | head -1); [ -n "$e" ] && echo "$b: $(python3 check_expected.py $L $e)"; done
grep -H "HISTORY\|RESULT\|ERROR" results/*.log > results/SUMMARY.txt; cat results/SUMMARY.txt
echo "done: send back the folder results/ (see README)"
