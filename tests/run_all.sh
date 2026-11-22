#!/usr/bin/env bash
# tests/run_all.sh  (agent PC; AI-written, not reviewed by a human)
# Runs the validation suite of HodgeLociCI from a clean checkout and prints a PASS/FAIL table.
# The package is loaded from ../M2/HodgeLociCI.m2; nothing needs to be installed except Macaulay2 (tested with 1.22).
#
#   tests/run_all.sh                 the fast suite (tests/validation/[0-9]*.m2)
#   tests/run_all.sh --slow          also the tests in tests/slow/
#   tests/run_all.sh --update        rewrite tests/expected/*.out from this run (maintainers only)
#   tests/run_all.sh PATTERN         only the tests whose name contains PATTERN
# Environment: M2=<path to M2>, HLCI_TIMEOUT=<seconds per test, default 900>.
# Exit status 0 if and only if every test passes. Column "disagree": recorded disagreements between a published
# number (as read by machine) and the package; they are printed in every run and neither side is adjusted.
set -u
here="$(cd "$(dirname "$0")" && pwd)"
M2BIN="${M2:-M2}"
TMO="${HLCI_TIMEOUT:-900}"
slow=0; update=0; pattern=""
for a in "$@"; do
  case "$a" in
    --slow) slow=1 ;;
    --update) update=1 ;;
    *) pattern="$a" ;;
  esac
done
command -v "$M2BIN" >/dev/null 2>&1 || { echo "Macaulay2 ($M2BIN) not found; set M2=/path/to/M2"; exit 2; }
out="$here/out"; mkdir -p "$out" "$here/expected"
files=("$here"/validation/[0-9]*.m2)
[ "$slow" = 1 ] && files+=("$here"/slow/[0-9]*.m2)
total=0; failed=0; ndis_all=0; t_all=$(date +%s)
printf '%-44s %-8s %7s %9s %8s\n' "test" "status" "checks" "disagree" "seconds"
printf '%-44s %-8s %7s %9s %8s\n' "--------------------------------------------" "--------" "-------" "---------" "--------"
for f in "${files[@]}"; do
  [ -e "$f" ] || continue
  name="$(basename "$f" .m2)"
  case "$name" in *"$pattern"*) ;; *) continue ;; esac
  total=$((total+1))
  t0=$(date +%s.%N)
  timeout "$TMO" "$M2BIN" --script "$f" > "$out/$name.out" 2> "$out/$name.err"
  rc=$?
  t1=$(date +%s.%N)
  secs=$(awk -v a="$t0" -v b="$t1" 'BEGIN{printf "%.1f", b-a}')
  nchk=$(grep -c '^RESULT' "$out/$name.out" || true)
  ndis=$(grep -c '^DISAGREE' "$out/$name.out" || true)
  ndis_all=$((ndis_all+ndis))
  status=PASS
  if [ "$rc" = 124 ]; then status=TIMEOUT
  elif [ "$rc" != 0 ] || ! grep -q '^ALL [0-9]* CHECKS PASSED' "$out/$name.out"; then status=FAIL
  fi
  exp="$here/expected/$name.out"
  if [ "$update" = 1 ] && [ "$status" = PASS ]; then
    grep -E '^(RESULT|DISAGREE|INFO|ALL )' "$out/$name.out" > "$exp"
  elif [ "$status" = PASS ] && [ -e "$exp" ]; then
    if ! diff -q <(grep -E '^(RESULT|DISAGREE|INFO|ALL )' "$out/$name.out") "$exp" >/dev/null; then status=DIFF; fi
  elif [ "$status" = PASS ]; then status="PASS*"
  fi
  case "$status" in PASS|"PASS*") ;; *) failed=$((failed+1)) ;; esac
  printf '%-44s %-8s %7s %9s %8s\n' "$name" "$status" "$nchk" "$ndis" "$secs"
done
t_end=$(date +%s)
echo
echo "$((total-failed)) of $total tests passed in $((t_end-t_all)) s.  Outputs: $out/"
[ "$ndis_all" != 0 ] && echo "$ndis_all RECORDED DISAGREEMENT(S) between a published number (as read by machine) and the package: lines DISAGREE in the outputs; see tests/README.md."
echo "PASS = all checks passed and the RESULT lines equal tests/expected/NAME.out;  PASS* = passed, no expected file;"
echo "DIFF = passed its own checks but the output differs from the expected file;  FAIL / TIMEOUT: see NAME.out, NAME.err."
[ "$failed" = 0 ]
