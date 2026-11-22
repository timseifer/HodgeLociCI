#!/usr/bin/env bash
# Re-run the Lean certificates. Usage:
#   ./run_all.sh core                      # the 13 library-free files (needs only `lean` 4.36.0 on PATH)
#   ./run_all.sh mathlib /path/to/mathlib4 # the 5 Mathlib files and the negative tests (needs a built Mathlib v4.36.0)
set -u
here="$(cd "$(dirname "$0")" && pwd)"
mode="${1:-core}"
fail=0
if [ "$mode" = core ]; then
  for f in "$here"/core/*.lean; do
    out=$(lean "$f" 2>&1); rc=$?
    if [ $rc -eq 0 ] && ! grep -q -e 'error' -e 'warning' -e 'sorryAx' <<<"$out"; then echo "PASS $(basename "$f")"; else echo "FAIL $(basename "$f")"; fail=1; fi
  done
  out=$(lean "$here"/mathlib/negative_tests/Neg0.lean 2>&1); rc=$?
  if [ $rc -ne 0 ]; then echo "PASS Neg0.lean is rejected, as it must be"; else echo "FAIL Neg0.lean was accepted"; fail=1; fi
elif [ "$mode" = mathlib ]; then
  ml="${2:?path to a built mathlib4 checkout (tag v4.36.0)}"
  cd "$ml" || exit 2
  for f in SpecialCoefficient SecondOrderLawModule PointwiseFormula EveryR SecondProof; do
    out=$(lake env lean "$here/mathlib/$f.lean" 2>&1); rc=$?
    if [ $rc -eq 0 ] && ! grep -q -e 'error' -e 'warning' -e 'sorryAx' <<<"$out"; then echo "PASS $f.lean"; else echo "FAIL $f.lean"; fail=1; fi
  done
  for i in 1 2 3 4 5 6 7 8 9 10 11; do
    out=$(lake env lean "$here/mathlib/negative_tests/Neg$i.lean" 2>&1); rc=$?
    if [ $rc -ne 0 ]; then echo "PASS Neg$i.lean is rejected, as it must be"; else echo "FAIL Neg$i.lean was accepted"; fail=1; fi
  done
else
  echo "usage: $0 core | mathlib /path/to/mathlib4"; exit 2
fi
exit $fail
