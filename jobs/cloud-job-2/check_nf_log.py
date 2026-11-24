#!/usr/bin/env python3
"""[TOOLING] cloud-job-2 (PK2): compare a hodge_job_lam.py log with a stored NF-T6 gen_lam.py log, EXACTLY apart
from timings.  gen_lam.py prints no ANALYSIS / DIGEST / VERDICT lines and its own 'peak RSS' line; these are dropped
from both sides, and so are the lines of hodge_job_lam.py's extra obstruction analysis (from its first ANALYSIS
line up to HISTORY: exact rebuilds that gen_lam.py does not do); every other line (first line with lambda, p, z, seed, kind, rank L, dim T Cone_T; all E'_m term
counts; ORDER lines; ranks; RESULT; HISTORY) must be identical and in the same order.
    python3 check_nf_log.py RESULT_LOG EXPECTED_LOG      -> prints PASS or FAIL (exit 0 / 1)"""
import re, sys
DROP = ('ANALYSIS', 'DIGEST', 'VERDICT', 'peak RSS')
def norm(f):
    out = []; skip = False
    for l in open(f):
        if l.startswith('ANALYSIS'): skip = True
        if l.startswith('HISTORY'): skip = False
        if skip: continue
        l = re.sub(r'\(\d+s\)', '', l).replace('[streamed, not stored]', '').rstrip()
        l = re.sub(r'\s+', ' ', l).strip()
        if l and not l.startswith(DROP): out.append(l)
    return out
r, e = norm(sys.argv[1]), norm(sys.argv[2])
if not e or not any(l.startswith('HISTORY') for l in e):
    print('FAIL expected log has no HISTORY line (incomplete reference)'); sys.exit(1)
for i in range(max(len(r), len(e))):
    a = r[i] if i < len(r) else '(missing)'; b = e[i] if i < len(e) else '(missing)'
    if a != b:
        print('FAIL at line %d' % (i + 1)); print(' expected:', b); print(' result  :', a); sys.exit(1)
print('PASS (%d lines identical)' % len(e))
