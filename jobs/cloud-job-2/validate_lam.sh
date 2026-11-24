#!/bin/bash
# cloud-job-2 VALIDATION for the other-lambda group (PK2).  Must pass before run_lam.py (which refuses otherwise).
# Requires that ../cloud-job-1/validate.sh has passed (the engine is the same CI-tested kernel).
# 1. inputs: the lambda = -1 and 2 T Cone_T files made by dev/export_mc_lam.py are identical to cloud-job-1's.
# 2. reproduces two stored NF-T6 gen_lam.py logs EXACTLY (apart from timings): lambda = -2 seed 1 a x l and
#    lambda = 1/2 seed 4 l x a, MOD 67108837, order 6 (both OBSTRUCTED_GENUINE, general analysis agreeing).
# About 1-2 min.  Exit 0 = PASS.   Usage: bash jobs/cloud-job-2/validate_lam.sh <output dir>   (run_lam.py calls it)
set -u
V=$(mkdir -p "${1:?usage: validate_lam.sh OUTDIR}" && cd "$1" && pwd)
cd "$(dirname "$0")"
rm -rf $V; mkdir -p $V
exec > >(tee $V/validate_lam.log) 2>&1
export FSC_SO_DIR=$(cd ../cloud-job-1 && pwd)/build OMP_NUM_THREADS=1   # the kernel built and validated by R000
FAIL=0
if [ -f ../cloud-job-1/results/validation/VALIDATION_PASS ]; then echo "   PASS cloud-job-1 validation present"
elif [ "${LOCAL_TEST:-0}" = 1 ]; then echo "   WARN cloud-job-1 validation missing (LOCAL_TEST=1: development machine only; never set on the cloud)"
else echo "   FAIL cloud-job-1/results/validation/VALIDATION_PASS missing (run R000 first)"; FAIL=1; fi
python3 ../cloud-job-1/hodge_build.py > $V/build.log 2>&1 && echo "   PASS kernel built" || { echo "   FAIL build"; exit 1; }
for p in 67108837 67108819; do for l in -1 2; do
  python3 -c "import json,sys; a=json.load(open('inputs/mc_${p}_lam$l.json')); b=json.load(open('../cloud-job-1/inputs/mc_${p}_lam$l.json')); sys.exit(0 if a['Mc']==b['Mc'] and a['z']==b['z'] else 1)" \
    && echo "   PASS inputs mc_${p}_lam$l identical to cloud-job-1" || { echo "   FAIL inputs mc_${p}_lam$l differ"; FAIL=1; }
done; done
for spec in "-2 1 al" "1/2 4 la"; do
  set -- $spec; lt=$(echo $1 | tr / o); tag=nf_A_${lt}_$2_$3
  python3 hodge_job_lam.py --lam=$1 --p 67108837 --seed $2 --kind $3 --N 6 --threads 1 --out $V --tag $tag > $V/$tag.log 2>&1
  r=$(python3 check_nf_log.py $V/$tag.log reference/nf_t6_A_${lt}_$2_$3.log)
  echo "$r" | grep -q '^PASS' && echo "   PASS $tag: $r" || { echo "   FAIL $tag: $r"; FAIL=1; }
  grep -q '^VERDICT OBSTRUCTED_GENUINE' $V/$tag.log && grep -q 'agree: True' $V/$tag.log && echo "   PASS $tag verdict OBSTRUCTED_GENUINE, analysis agrees" || { echo "   FAIL $tag verdict"; FAIL=1; }
done
rm -f $V/*.npy
if [ $FAIL = 0 ]; then date -u > $V/VALIDATION_PASS; echo "VALIDATION_LAM PASS"; exit 0; else echo "VALIDATION_LAM FAIL: do not run the L group"; exit 1; fi
