#!/bin/bash
# cloud-job-1 VALIDATION (must pass before any main job; run_tasks.py refuses to start otherwise).
# Reproduces stored reference runs line for line (apart from timings).  Exit code 0 = PASS, nonzero = FAIL.
#   ./validate.sh                 # all threads;  THREADS=8 ./validate.sh  to limit
# Time: about 3 min on 30 cores; about 12 min on 2 shared cores.
set -u
cd "$(dirname "$0")"
T=${THREADS:-$(nproc)}
V=results/validation
rm -rf $V; mkdir -p $V
exec > >(tee $V/validate.log) 2>&1
export FSC_SO_DIR=$PWD/build
FAIL=0
step() { echo "== $*"; }
ok()   { echo "   PASS $*"; }
bad()  { echo "   FAIL $*"; FAIL=1; }
cmpq() { python3 check_expected.py "$1" "$2" > $V/cmp.tmp 2>&1; if grep -q '^PASS' $V/cmp.tmp; then ok "$(basename $1): $(cat $V/cmp.tmp)"; else bad "$(basename $1): $(cat $V/cmp.tmp)"; fi; }

step "0. environment"
{ uname -a; nproc; free -g; python3 --version; python3 -c 'import numpy; print("numpy", numpy.__version__)'; ${CXX:-g++} --version | head -1; } > $V/machine.txt 2>&1
cat $V/machine.txt | sed 's/^/   /'
python3 hodge_build.py > $V/build.log 2>&1 && ok "compiled kernel built (build/libfsc.so)" || { bad "build failed: see $V/build.log"; exit 1; }

step "1. engine unit test (tooling/fermat_series, compiled kernel vs numpy references, about 40 s)"
python3 ../../tooling/fermat_series/test_fermat_series.py > $V/unit.log 2>&1 && ok "$(tail -1 $V/unit.log)" || bad "unit test: $(tail -3 $V/unit.log)"

step "2. direction generator: W3's 12 lambda = -1 generic directions regenerated from (p, seed, kind) and Mc"
for f in inputs/dir_*_s*_*.json; do
  b=$(basename $f .json); p=$(echo $b | cut -d_ -f2); s=$(echo $b | cut -d_ -f3 | tr -d s); k=$(echo $b | cut -d_ -f4)
  python3 hodge_job.py --lam -1 --p $p --seed $s --kind $k --N 4 --threads 1 --out $V --tag dir_$b --direction-only > $V/dir_$b.log 2>&1
  python3 -c "import json,sys; a=json.load(open('$f')); b=json.load(open('$V/dir_${b}_v.json')); sys.exit(0 if (a['v']==b['v'] and a['c0']==b['c0']) else 1)" \
    && ok "$b identical" || bad "$b differs"
done

step "3. (i) lambda = -1, EX-T6 arc a x l, MOD 67108837, z index 0, ORDER 11 (vs W3 hi_67108837_0_al_11 / SP-T6 expected)"
python3 run_arc.py 67108837 0 al 11 --threads $T --out $V > $V/exarc_67108837_0_al_11.log 2>&1
cmpq $V/exarc_67108837_0_al_11.log reference/exarc_67108837_0_al_11.log
grep -h '^HISTORY' $V/exarc_67108837_0_al_11.log | sed 's/ ([0-9]*s)$//' > $V/h1.txt; grep -h '^HISTORY' reference/exarc_67108837_0_al_11.log | sed 's/ ([0-9]*s)$//' > $V/h2.txt
cmp -s $V/h1.txt $V/h2.txt && ok "HISTORY identical" || bad "HISTORY differs"
python3 -c "import numpy as np,sys; a=np.load('$V/exarc_67108837_0_al_N11.npy'); b=np.load('reference/w3_arc_67108837_0_al_11.npy'); sys.exit(0 if a.shape==b.shape and (a%67108837==b%67108837).all() else 1)" \
  && ok "final arc identical to reference/w3_arc_67108837_0_al_11.npy" || bad "final arc differs"

step "4. (ii) lambda = 2, generic directions, ORDER 6 obstruction test (vs W3 gen logs: same ranks, same verdict)"
for spec in "67108837 1 al" "67108819 4 la"; do
  set -- $spec; tag=gen_lam2_$1_s$2_$3_N6
  python3 hodge_job.py --lam 2 --p $1 --seed $2 --kind $3 --N 6 --threads $T --out $V --tag $tag > $V/$tag.log 2>&1
  cmpq $V/$tag.log reference/w3_gen_$1_2_$2_$3.log
  grep -q '^VERDICT OBSTRUCTED_GENUINE' $V/$tag.log && grep -q 'agree: True' $V/$tag.log && ok "$tag: verdict OBSTRUCTED_GENUINE, general analysis agrees with W3's criterion" || bad "$tag: verdict/agreement wrong"
done

step "5. (iii) lambda = -1, generic direction seed 1 (a x l), MOD 67108837, ORDER 8 (vs W3 gen_67108837_-1_1_al / SP-T6 expected)"
tag=gen_lam-1_67108837_s1_al_N8
python3 hodge_job.py --lam -1 --p 67108837 --seed 1 --kind al --N 8 --threads $T --out $V --tag $tag > $V/$tag.log 2>&1
cmpq $V/$tag.log reference/generic_67108837_s1_al_N8.log
grep -h '^HISTORY' $V/$tag.log | sed 's/ ([0-9]*s)$//' > $V/h1.txt; grep -h '^HISTORY' reference/generic_67108837_s1_al_N8.log | sed 's/ ([0-9]*s)$//' > $V/h2.txt
cmp -s $V/h1.txt $V/h2.txt && ok "HISTORY identical" || bad "HISTORY differs"
grep -q '^VERDICT EXTENDS order_reached 8' $V/$tag.log && ok "verdict EXTENDS to 8" || bad "verdict"
python3 -c "
import json; d = json.load(open('$V/$tag.json')); m = 0.0771 * 3600
print('   CALIBRATION generic order 8: %.0f s wall with %d threads; model (1 thread, SP-T6 machine) %.0f s -> speed factor %.2f (then: python3 estimate.py --speed %.2f)' % (d['runtime_s'], d['threads'], m, m / d['runtime_s'] / d['threads'], m / d['runtime_s'] / d['threads']))" | tee $V/calibration.txt

step "6. obstruction-analysis code path (forced at order 7 on a lambda = -1 direction that extends; expected TEST_OBSTRUCTED_CHOICE)"
tag=forced7_67108837_s2_al
python3 hodge_job.py --lam -1 --p 67108837 --seed 2 --kind al --N 7 --threads $T --out $V --tag $tag --force-analysis-at 7 > $V/$tag.log 2>&1
grep -q '^VERDICT TEST_OBSTRUCTED_CHOICE' $V/$tag.log && ok "forced analysis: linear solution re-applied, exact recomputation passes" || bad "forced analysis: $(grep '^VERDICT\|^ANALYSIS' $V/$tag.log | tail -2)"

rm -f $V/cmp.tmp $V/h1.txt $V/h2.txt $V/*_v.json
echo
if [ $FAIL = 0 ]; then date -u > $V/VALIDATION_PASS; echo "VALIDATION PASS"; exit 0
else echo "VALIDATION FAIL: STOP, do not run main jobs; commit results/validation/ and report"; exit 1; fi
