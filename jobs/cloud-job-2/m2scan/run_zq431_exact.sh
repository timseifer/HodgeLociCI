#!/bin/bash
# cloud-job-2 M4 (PK2): the EXACT (QQ) second-order check at T6c's explicit point of the stratum Z_431 (quartic sixfold,
# (4;1;1;1,1,1)), which did not finish in 25 min on the development machine.  Single process, 1 core.
#   bash jobs/cloud-job-2/m2scan/run_zq431_exact.sh <out dir> [timeout minutes, default 90] [M2 command, default M2]
# Step 1: the M2 validation (m2scan.py validate: 5 stored T6c jump-scan results reproduced exactly) into <out>;
#         refuses to continue on mismatch.  Step 2: zq431_exact.m2 -> <out>/zq431_exact.out (timeout -> TIMEOUT line).
set -u
OUT=$(mkdir -p "${1:?usage: run_zq431_exact.sh OUTDIR [minutes] [M2]}" && cd "$1" && pwd); MIN=${2:-90}; M2CMD=${3:-M2}
cd "$(dirname "$0")"
if [ ! -f "$OUT/VALIDATION_PASS" ]; then
  python3 m2scan.py validate --out "$OUT" --procs 5 --m2 "$M2CMD" || { echo "VALIDATION_M2 FAIL: not running zq431_exact"; exit 1; }
fi
date -u +"start %H:%M:%SZ" | tee "$OUT/zq431_exact.status"
timeout $((MIN * 60)) $M2CMD --script zq431_exact.m2 > "$OUT/zq431_exact.out" 2>&1; rc=$?
[ $rc = 124 ] && echo "TIMEOUT after $MIN min (partial output above)" >> "$OUT/zq431_exact.out"
date -u +"end %H:%M:%SZ rc=$rc" | tee -a "$OUT/zq431_exact.status"
cat "$OUT/zq431_exact.out" | cut -c1-400
