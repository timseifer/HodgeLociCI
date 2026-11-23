#!/usr/bin/env bash
# Default command of the Docker image: run examples/quickstart.m2 and compare its RESULT lines with
# examples/quickstart.expected. Exit status 0 if and only if they are identical. Also usable outside Docker, from
# any directory: docker/quickstart-check.sh  (needs M2 on the PATH, or M2=/path/to/M2).
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"
M2BIN="${M2:-M2}"
echo "Macaulay2 $("$M2BIN" --version)"
out="$(mktemp)"
trap 'rm -f "$out"' EXIT
"$M2BIN" --script examples/quickstart.m2 | grep '^RESULT ' > "$out"
cat "$out"
if diff -u examples/quickstart.expected "$out"; then
  echo "QUICKSTART OK: $(wc -l < "$out") RESULT lines equal examples/quickstart.expected"
  echo "AI-generated, not reviewed by a human mathematician."
else
  echo "QUICKSTART FAILED: output differs from examples/quickstart.expected (diff above)" >&2
  exit 1
fi
