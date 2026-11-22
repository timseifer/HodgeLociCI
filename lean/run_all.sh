#!/usr/bin/env bash
# Re-run the Lean certificates. Usage:
#   ./run_all.sh core                      # the 13 library-free files (needs only `lean` 4.36.0 on PATH)
#   ./run_all.sh mathlib /path/to/mathlib4 # the 5 Mathlib files and the negative tests (needs a built Mathlib v4.36.0)
# Prints one PASS / FAIL line per file. Exit status: 0 if every line is PASS, 1 if some line is FAIL,
# 2 if nothing was run (wrong usage, or `lean` / `lake` is not on the PATH).
set -u
here="$(cd "$(dirname "$0")" && pwd)"
mode="${1:-core}"
fail=0
# need TOOL: stop before running anything if TOOL is not on the PATH
need() {
  command -v "$1" >/dev/null 2>&1 && return 0
  echo "$1 not found on the PATH: nothing was run. The certificates need Lean 4.36.0; see lean/README.md, section 'How to re-run'."
  exit 2
}
# accepted RC OUTPUT: a positive file passes if Lean exits with status 0 and prints no error, warning or sorryAx
accepted() { [ "$1" -eq 0 ] && ! grep -q -e 'error' -e 'warning' -e 'sorryAx' <<<"$2"; }
# rejected RC OUTPUT: a negative test counts as rejected only if Lean actually ran and reported an error.
# Status 126 / 127 mean that the command could not be executed or was not found; that is not a rejection.
rejected() { [ "$1" -ne 0 ] && [ "$1" -ne 126 ] && [ "$1" -ne 127 ] && grep -q 'error' <<<"$2"; }
negative() { # negative NAME RC OUTPUT
  if rejected "$2" "$3"; then echo "PASS $1 is rejected, as it must be"
  elif [ "$2" -eq 0 ]; then echo "FAIL $1 was accepted"; fail=1
  else echo "FAIL $1: Lean did not run or reported no error (exit status $2), so this is not a rejection"; fail=1
  fi
}
if [ "$mode" = core ]; then
  need lean
  for f in "$here"/core/*.lean; do
    out=$(lean "$f" 2>&1); rc=$?
    if accepted "$rc" "$out"; then echo "PASS $(basename "$f")"; else echo "FAIL $(basename "$f")"; fail=1; fi
  done
  out=$(lean "$here"/mathlib/negative_tests/Neg0.lean 2>&1); rc=$?
  negative Neg0.lean "$rc" "$out"
elif [ "$mode" = mathlib ]; then
  ml="${2:-}"
  [ -n "$ml" ] || { echo "usage: $0 mathlib /path/to/mathlib4   (a built mathlib4 checkout, tag v4.36.0)"; exit 2; }
  need lake
  cd "$ml" || { echo "cannot enter $ml: nothing was run"; exit 2; }
  posfail=0
  for f in SpecialCoefficient SecondOrderLawModule PointwiseFormula EveryR SecondProof; do
    out=$(lake env lean "$here/mathlib/$f.lean" 2>&1); rc=$?
    if accepted "$rc" "$out"; then echo "PASS $f.lean"; else echo "FAIL $f.lean"; fail=1; posfail=1; fi
  done
  for i in 1 2 3 4 5 6 7 8 9 10 11; do
    out=$(lake env lean "$here/mathlib/negative_tests/Neg$i.lean" 2>&1); rc=$?
    negative "Neg$i.lean" "$rc" "$out"
  done
  if [ "$posfail" = 1 ]; then
    echo "NOTE: some of the five Mathlib files FAILED. If the cause is the setup (for example Mathlib is not built), the"
    echo "      negative tests above are rejected for the same reason and their PASS lines mean nothing."
  fi
else
  echo "usage: $0 core | mathlib /path/to/mathlib4"; exit 2
fi
exit $fail
