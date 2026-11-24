#!/usr/bin/env python3
"""Write <results>/summary.md from <results>/manifest.csv (PK).   python3 make_summary.py [results_dir]"""
import csv, os, collections
import sys
HERE = os.path.dirname(os.path.abspath(__file__)); R = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, 'results')
rows = list(csv.DictReader(open(os.path.join(R, 'manifest.csv'))))
last = collections.OrderedDict()
for r in rows: last[r['log']] = r
L = ["# cloud-job-1 results (AI-generated computation, MOD p, not reviewed by a human)", ""]
val = os.path.join(R, 'validation', 'VALIDATION_PASS')
L.append("Validation: %s" % ('PASS (' + open(val).read().strip() + ')' if os.path.exists(val) else 'NOT PASSED'))
mt = os.path.join(R, 'validation', 'machine.txt')
if os.path.exists(mt): L += ["", "Machine:", "", "```", open(mt).read().strip(), "```"]
lam1 = [r for r in last.values() if r['lambda'] == '-1']
bad = [r for r in lam1 if r['verdict'] not in ('EXTENDS', 'NOT_RUN')]
L += ["", "## Headline", ""]
if bad:
    L.append("**ATTENTION: %d lambda = -1 run(s) did NOT extend to the requested order** (see the table; verdicts "
             "OBSTRUCTED_GENUINE / OBSTRUCTED_CHOICE / OBSTRUCTED_UNRESOLVED / ERROR are explained in README.md)." % len(bad))
ext = [r for r in lam1 if r['verdict'] == 'EXTENDS']
if ext:
    mx = max(int(r['order_reached']) for r in ext)
    L.append("lambda = -1: %d run(s) EXTEND to their requested order (highest order reached: %d)." % (len(ext), mx))
l2 = [r for r in last.values() if r['lambda'] == '2']
if l2:
    L.append("lambda = 2 control: %d of %d OBSTRUCTED_GENUINE at order 6." % (sum(r['verdict'] == 'OBSTRUCTED_GENUINE' for r in l2), len(l2)))
L.append("A finite order is evidence only; it cannot prove that a component exists (checks/w4 REPORT.md).")
L += ["", "## All runs", "", "| job | lambda | prime | seed | kind | N req | N reached | verdict | runtime s | peak RSS GB | note |",
      "|---|---|---|---|---|---|---|---|---|---|---|"]
for r in last.values():
    L.append("| %s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s |" % (r['job'], r['lambda'], r['prime'], r['seed'], r['kind'], r['order_requested'],
             r['order_reached'], r['verdict'], r['runtime_s'], r['peak_rss_gb'], r.get('note', '')[:120]))
L += ["", "code_commit: %s; engine_version: %s" % (sorted({r['code_commit'] for r in rows}), sorted({r['engine_version'] for r in rows}))]
open(os.path.join(R, 'summary.md'), 'w').write('\n'.join(L) + '\n'); print('\n'.join(L))
