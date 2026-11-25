#!/usr/bin/env python3
"""Compare a result log with an expected log (from the original runs), ignoring timings.
    python3 check_expected.py results/LOG expected/LOG
The expected log may be for a LOWER order than the result: then every line of the expected run (apart from its
first line, which names N, and its final-order lines HISTORY / DIGEST / 'final order') must appear, in order, at the
start of the result log.  Prints PASS or FAIL and the first differing line."""
import re, sys
def norm(f):
    out = []
    for l in open(f):
        l = re.sub(r'\(\d+s\)', '', l).replace('[streamed, not stored]', '').rstrip()
        out.append(re.sub(r'\s+', ' ', l))
    return out
res, exp = norm(sys.argv[1]), norm(sys.argv[2])
hdr = lambda l: re.sub(r' N \d+ ', ' N * ', l)
if not res or not exp or hdr(res[0]) != hdr(exp[0]):
    print("FAIL first line differs (different prime / direction?)"); print(" result  :", res[:1]); print(" expected:", exp[:1]); sys.exit(1)
body = [l for l in exp[1:] if not (l.startswith('HISTORY') or l.startswith('DIGEST') or l.startswith(' final order'))]
for i, l in enumerate(body):
    if i + 1 >= len(res) or res[i + 1] != l:
        print("FAIL at expected line %d" % (i + 2)); print(" expected:", l); print(" result  :", res[i + 1] if i + 1 < len(res) else '(missing)'); sys.exit(1)
print("PASS (%d expected lines reproduced)" % (len(body) + 1))
