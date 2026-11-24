#!/usr/bin/env python3
"""[TOOLING] cloud-job-1 result checker (PK).  Run by the coordinator after pulling the branch cloud-job-1:

    python3 jobs/cloud-job-1/check_results.py [results_dir]

Checks: validation passed (VALIDATION_PASS + all PASS lines, no FAIL); manifest.csv has the required columns and
allowed verdicts; every row has its log and sidecar JSON and they agree (verdict, order reached); every log that
claims a verdict ends with the matching VERDICT line (generic runs) or HISTORY (EX-T6 arcs); for each generic run the
log's lines reproduce the stored reference run of the same direction at lower order where one exists (W3 / SP-T6
logs, via check_expected.py); every EXTENDS run has a HISTORY whose last order = order_reached = order_requested;
lambda = 2 rows are OBSTRUCTED_GENUINE at order 6 (control); no file > 50 MB; no obvious secrets.
Prints a verdict table and 'CHECK PASS' / 'CHECK FAIL'; exit code 0 only on PASS.  Any lambda = -1 row that is not
EXTENDS is printed as ATTENTION (that is a scientific finding to look at, not a checker failure)."""
import csv, json, os, re, subprocess, sys
HERE = os.path.dirname(os.path.abspath(__file__))
R = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, 'results')
VERDICTS = {'EXTENDS', 'OBSTRUCTED_GENUINE', 'OBSTRUCTED_CHOICE', 'OBSTRUCTED_UNRESOLVED', 'NOT_RUN', 'ERROR'}
COLS = ['job', 'lambda', 'prime', 'seed', 'kind', 'order_requested', 'order_reached', 'verdict', 'runtime_s', 'peak_rss_gb',
        'code_commit', 'engine_version']
fails, attn = [], []
def F(msg): fails.append(msg); print("FAIL", msg)

v = os.path.join(R, 'validation')
if not os.path.exists(os.path.join(v, 'VALIDATION_PASS')): F('validation: VALIDATION_PASS missing')
vl = [f for f in os.listdir(v)] if os.path.isdir(v) else []
for f in vl:
    if f.endswith('.log') and f.startswith('validate'):
        t = open(os.path.join(v, f)).read()
        if 'FAIL' in t: F('validation log %s contains FAIL' % f)
man = os.path.join(R, 'manifest.csv')
if not os.path.exists(man): F('manifest.csv missing'); rows = []
else:
    rows = list(csv.DictReader(open(man)))
    if rows and any(c not in rows[0] for c in COLS): F('manifest columns missing: %s' % [c for c in COLS if c not in rows[0]])
# keep the last row per log (a task may have been retried)
last = {}
for r in rows: last[r.get('log', r['job'] + r['seed'])] = r
for key, r in last.items():
    name = '%s lam %s p %s seed %s %s N%s' % (r['job'], r['lambda'], r['prime'], r['seed'], r['kind'], r['order_requested'])
    if r['verdict'] not in VERDICTS: F('%s: verdict %r not allowed' % (name, r['verdict'])); continue
    if r['verdict'] == 'NOT_RUN': continue
    lp = os.path.join(R, r['log'])
    if not os.path.exists(lp): F('%s: log %s missing' % (name, r['log'])); continue
    txt = open(lp).read()
    sc = lp[:-4] + '.json'
    if os.path.exists(sc):
        d = json.load(open(sc))
        if d['verdict'] != r['verdict'] or int(d['order_reached']) != int(r['order_reached']): F('%s: sidecar and manifest disagree' % name)
    else: F('%s: sidecar JSON missing' % name)
    if r['verdict'] == 'ERROR': attn.append('%s: ERROR (%s)' % (name, r.get('note', ''))); continue
    if not r['kind'].startswith('exarc'):
        m = re.findall(r'^VERDICT (\S+) order_reached (\d+)', txt, re.M)
        if not m or m[-1][0] != r['verdict'] or int(m[-1][1]) != int(r['order_reached']): F('%s: VERDICT line does not match manifest' % name)
        # reproduce stored lower-order reference runs of the same direction
        p, s, k, lam = r['prime'], r['seed'], r['kind'], int(r['lambda'])
        refs = []   # (path, order of the reference run)
        if lam == -1:
            for x in os.listdir(os.path.join(HERE, 'reference')):
                m1 = re.fullmatch(r'generic_%s_s%s_%s_N(\d+)\.log' % (p, s, k), x)
                if m1: refs.append((x, int(m1.group(1))))
                if re.fullmatch(r'w3_sp8_%s_s%s_%s\.log' % (p, s, k), x): refs.append((x, 8))
        elif lam == 2:
            refs = [('w3_gen_%s_2_%s_%s.log' % (p, s, k), 6)]
        for ref, nref in refs:
            ref = os.path.join(HERE, 'reference', ref)
            if os.path.exists(ref) and int(r['order_requested']) >= nref:
                out = subprocess.run([sys.executable, os.path.join(HERE, 'check_expected.py'), lp, ref], capture_output=True, text=True).stdout
                if not out.startswith('PASS'): F('%s: does not reproduce %s: %s' % (name, os.path.basename(ref), out.strip()[:200]))
                else: print("ok  ", name, "reproduces", os.path.basename(ref))
    else:
        kk = r['kind'][6:]
        for x in sorted(os.listdir(os.path.join(HERE, 'reference'))):
            m1 = re.fullmatch(r'exarc_%s_0_%s_(\d+)\.log' % (r['prime'], kk), x)
            if m1 and int(r['order_requested']) >= int(m1.group(1)):
                out = subprocess.run([sys.executable, os.path.join(HERE, 'check_expected.py'), lp, os.path.join(HERE, 'reference', x)],
                                     capture_output=True, text=True).stdout
                if not out.startswith('PASS'): F('%s: does not reproduce %s: %s' % (name, x, out.strip()[:200]))
                else: print("ok  ", name, "reproduces", x)
    if 'HISTORY' not in txt: F('%s: no HISTORY line' % name)
    if r['verdict'] == 'EXTENDS' and int(r['order_reached']) != int(r['order_requested']): F('%s: EXTENDS but order_reached != requested' % name)
    if int(r['lambda']) == 2 and not (r['verdict'] == 'OBSTRUCTED_GENUINE' and int(r['order_reached']) == 5):
        attn.append('%s: lambda = 2 CONTROL not obstructed at order 6 as expected: %s' % (name, r['verdict']))
    if int(r['lambda']) == -1 and r['verdict'] != 'EXTENDS':
        attn.append('%s: lambda = -1 run %s at order %d (%s)' % (name, r['verdict'], int(r['order_reached']) + 1, r.get('note', '')))
for root, _, files in os.walk(R):
    for f in files:
        fp = os.path.join(root, f)
        if os.path.getsize(fp) > 50 * 2**20: F('file > 50 MB: %s' % fp)
        if f.endswith(('.log', '.csv', '.md', '.txt', '.json')):
            t = open(fp, errors='replace').read()
            if re.search(r'(BEGIN [A-Z ]*PRIVATE KEY|ghp_[A-Za-z0-9]{20,}|AKIA[0-9A-Z]{16}|password\s*=)', t): F('possible secret in %s' % fp)
print()
print("verdicts:", {vv: sum(1 for r in last.values() if r['verdict'] == vv) for vv in sorted(VERDICTS)})
for a in attn: print("ATTENTION", a)
print("CHECK PASS" if not fails else "CHECK FAIL (%d problems)" % len(fails))
sys.exit(0 if not fails else 1)
