#!/bin/bash
# Self-test (a few minutes): builds the compiled engine and reproduces two known runs exactly.
set -u
cd "$(dirname "$0")"
mkdir -p results/selftest
T=${THREADS:-$(nproc)}
echo "== engine unit test (compiled kernel vs numpy reference, orders <= 6)"
python3 engine/test_fermat_series.py > results/selftest/unit.log 2>&1; tail -1 results/selftest/unit.log
echo "== EX-T6 arc, p = 67108837, l x a, order 11 (expected: lines identical to the original run)"
python3 run_arc.py 67108837 0 la 11 --threads $T --out results/selftest > results/selftest/exarc_67108837_0_la_11.log 2>&1
python3 check_expected.py results/selftest/exarc_67108837_0_la_11.log expected/exarc_67108837_0_la_11.log
echo "== generic direction, p = 67108837, seed 2, order 7"
python3 run_job.py inputs/dir_67108837_s2_al.json 7 --threads $T --out results/selftest > results/selftest/generic_67108837_s2_al_N7.log 2>&1
python3 check_expected.py results/selftest/generic_67108837_s2_al_N7.log expected/generic_67108837_s2_al_N7.log
