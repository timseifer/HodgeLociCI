#!/usr/bin/env python3
"""[TOOLING] cloud-job-2 M group (PK2; AI-generated, not reviewed by a human): T6c step (c) jump-divisor scans that
were left unfinished, one Macaulay2 process per degree type, over --procs cores.  MOD 32003; checker at lambda = 2.

Modes
  validate : (also run automatically by sextic/retry when <out>/VALIDATION_PASS is missing; they stop on failure)
             reruns 5 types whose results are stored in reference/jump_*.out (T6c, seed 5, MaxRoots 2) and compares
             every output line EXACTLY (apart from the cpu time 't=').  Writes <out>/VALIDATION_PASS on success; the
             scan modes refuse to start without it.
  sextic   : the sextic-fourfold (6,2) types never run for general points of J (enum index >= 49, tau != 6;
             T6c's jump_62.out stopped after 49 types), seed 5 first.
  retry    : the types where T6c's random line had NO F_p-rational root (63 quartic (4,3), 22 tenfold (3,5), and the
             21 sextic (6,2) among the first 49), new random lines (seeds 6, 7, ...).
  For sextic/retry: if a line has no F_p-rational root, the next seed is tried, up to --tries lines per type.

  python3 jobs/cloud-job-2/m2scan/m2scan.py validate --out jobs/queue/results/<id>
  python3 jobs/cloud-job-2/m2scan/m2scan.py sextic   --out jobs/queue/results/<id> --procs 16
Output: <out>/scan_<mode>.csv (d,k,idx,type,seed,status,info,n_points,points,verdicts,runtime_s), <out>/raw/*.out,
        <out>/summary_<mode>.md.  Restarting skips types already in the CSV.
"""
import argparse, csv, os, re, subprocess, sys, time
from concurrent.futures import ThreadPoolExecutor
HERE = os.path.dirname(os.path.abspath(__file__))
ap = argparse.ArgumentParser(); ap.add_argument('mode', choices=['validate', 'sextic', 'retry'])
ap.add_argument('--out', required=True); ap.add_argument('--procs', type=int, default=8)
ap.add_argument('--tries', type=int, default=3, help='random lines per type (seeds start, start+1, ...)')
ap.add_argument('--timeout-s', type=int, default=1800, help='per M2 process'); ap.add_argument('--mem-gb', type=float, default=8, help='address-space cap per M2 process')
ap.add_argument('--nice', type=int, default=0); ap.add_argument('--limit', type=int, default=0, help='only the first L types (testing)')
ap.add_argument('--deadline-min', type=float, default=0, help='start no new type after this many minutes')
ap.add_argument('--m2', default='M2', help='Macaulay2 command (e.g. "docker run --rm -i -v $PWD:/w -w /w/jobs/cloud-job-2/m2scan hodgelocici M2")')
A = ap.parse_args()
A.out = os.path.abspath(A.out); RAW = os.path.join(A.out, 'raw'); os.makedirs(RAW, exist_ok=True)
KEY = re.compile(r'F=(\{[^}]*\}) H=(\{[^}]*\}) P=(\{[^}]*\})')
ENUM = {}
for l in open(os.path.join(HERE, 'enum_types.out')):
    if l.startswith('TYPE '):
        d, k = int(l.split()[1]), int(l.split()[2]); ENUM.setdefault((d, k), []).append(l.strip())
def idx_of(d, k, typ):
    for i, l in enumerate(ENUM[(d, k)]):
        if KEY.search(l).groups() == typ: return i
    raise KeyError(typ)
def ref_lines(d, k, typ):
    out = []
    for f in ('jump_43.out', 'jump_35.out', 'jump_62.out'):
        for l in open(os.path.join(HERE, 'reference', f)):
            if l.startswith('JUMP %d %d ' % (d, k)) and KEY.search(l) and KEY.search(l).groups() == typ: out.append(l.rstrip())
    return out
norm = lambda ls: [re.sub(r' t=[0-9.e-]+$', '', l.rstrip()) for l in ls if l.startswith('JUMP ')]

def run_m2(d, k, i, seed, maxroots=2):
    tag = '%d_%d_%03d_s%d' % (d, k, i, seed); raw = os.path.join(RAW, tag + '.out')
    cmd = A.m2.split() + ['--script', 'run_one.m2', str(d), str(k), str(i), str(seed), str(maxroots)]
    lim = int(A.mem_gb * 2**20)
    pre = 'ulimit -v %d; ' % lim + ('nice -n %d ' % A.nice if A.nice else '')
    st = time.time()
    try:
        p = subprocess.run(['bash', '-c', pre + ' '.join("'%s'" % c for c in cmd)], cwd=HERE, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=A.timeout_s)
        txt = p.stdout.decode(errors='replace'); status = 'OK' if p.returncode == 0 else 'ERROR rc=%d' % p.returncode
    except subprocess.TimeoutExpired as e:
        txt = (e.stdout or b'').decode(errors='replace'); status = 'TIMEOUT'
    open(raw, 'w').write(txt)
    return txt, status, round(time.time() - st, 1)

def parse(txt):
    J = [l for l in txt.splitlines() if l.startswith('JUMP ')]
    info = next((l.split(' info=')[1].rsplit(' t=', 1)[0] for l in J if ' info=' in l), '')
    pts = [l.split(' point', 1)[1].rsplit(' t=', 1)[0].strip(' =') for l in J if ' point' in l]
    verd = [re.search(r'verdict=([A-Z ]+?) rankQ', p).group(1) if 'verdict=' in p else p for p in pts]
    return info, pts, verd

def validate():
    picks = [(6, 2, ('{1}', '{1}', '{1, 4}')), (6, 2, ('{1}', '{1}', '{1, 1}')), (4, 3, ('{1}', '{1}', '{2, 2, 3}')),
             (4, 3, ('{1}', '{3}', '{1, 1, 1}')), (3, 5, ('{1}', '{1}', '{1, 1, 1, 1, 2}'))]
    ok = True; log = []
    def one(pk):
        d, k, typ = pk; i = idx_of(d, k, typ); txt, status, rt = run_m2(d, k, i, 5)
        a, b = norm(txt.splitlines()), norm(ref_lines(d, k, typ))
        return d, k, typ, a, b, status, rt
    with ThreadPoolExecutor(A.procs) as ex:
        for d, k, typ, a, b, status, rt in ex.map(one, picks):
            good = (a == b and len(b) > 0 and status == 'OK')
            ok &= good
            log.append('%s (%d,%d) F=%s H=%s P=%s: %s (%.0fs)' % ('PASS' if good else 'FAIL', d, k, *typ, '%d lines identical' % len(b) if good else 'expected %s got %s [%s]' % (b, a, status), rt))
    open(os.path.join(A.out, 'validate_m2.log'), 'w').write('\n'.join(log) + '\n'); print('\n'.join(log))
    if ok:
        open(os.path.join(A.out, 'VALIDATION_PASS'), 'w').write(time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()) + '\n'); print('VALIDATION_M2 PASS', flush=True); return True
    print('VALIDATION_M2 FAIL: do not run the scans', flush=True); return False


if A.mode == 'validate': sys.exit(0 if validate() else 1)
if not os.path.exists(os.path.join(A.out, 'VALIDATION_PASS')):
    print('no VALIDATION_PASS in %s: running the validation first' % A.out, flush=True)
    if not validate(): sys.exit('refusing to run the scan: validation failed (see validate_m2.log)')
todo = []
if A.mode == 'sextic':
    for i, l in enumerate(ENUM[(6, 2)]):
        if i >= 49 and ' tau=6 ' not in l: todo.append((6, 2, i, 5))
else:
    for f, (d, k) in (('jump_43.out', (4, 3)), ('jump_35.out', (3, 5)), ('jump_62.out', (6, 2))):
        for l in open(os.path.join(HERE, 'reference', f)):
            if ' info=' in l and 'linear factors 0' in l: todo.append((d, k, idx_of(d, k, KEY.search(l).groups()), 6))
if A.limit: todo = todo[:A.limit]
CSV = os.path.join(A.out, 'scan_%s.csv' % A.mode); COLS = ['d', 'k', 'idx', 'type', 'seed', 'status', 'info', 'n_points', 'points', 'verdicts', 'runtime_s']
done = set()
if os.path.exists(CSV):
    for r in csv.DictReader(open(CSV)): done.add((int(r['d']), int(r['k']), int(r['idx'])))
else:
    csv.writer(open(CSV, 'w', newline='')).writerow(COLS)
todo = [t for t in todo if t[:3] not in done]
print('%s: %d types to run (%d already in %s)' % (A.mode, len(todo), len(done), CSV), flush=True)
T0 = time.time()
import threading; LOCK = threading.Lock()
def work(t):
    d, k, i, s0 = t
    if A.deadline_min and (time.time() - T0) / 60 > A.deadline_min: return
    for s in range(s0, s0 + A.tries):
        txt, status, rt = run_m2(d, k, i, s); info, pts, verd = parse(txt)
        if status != 'OK' or 'linear factors 0' not in info: break
    typ = 'F=%s H=%s P=%s' % KEY.search(ENUM[(d, k)][i]).groups()
    with LOCK:
        csv.writer(open(CSV, 'a', newline='')).writerow([d, k, i, typ, s, status, info, len(pts), ' || '.join(pts), ';'.join(verd), rt])
        print(time.strftime('%H:%M:%S'), d, k, i, typ, 'seed', s, status, info, verd, flush=True)
with ThreadPoolExecutor(A.procs) as ex: list(ex.map(work, todo))
rows = list(csv.DictReader(open(CSV)))
from collections import Counter
vc = Counter(v for r in rows for v in r['verdicts'].split(';') if v); sc = Counter(r['status'] for r in rows)
noroot = sum(1 for r in rows if 'linear factors 0' in r['info'])
alert = [r for r in rows for v in r['verdicts'].split(';') if v and v not in ('ALL DIE', 'SINGULAR')]
with open(os.path.join(A.out, 'summary_%s.md' % A.mode), 'w') as f:
    f.write('# cloud-job-2 M (%s): T6c jump-divisor scan, MOD 32003 (AI-generated, unreviewed)\n\n' % A.mode)
    if alert: f.write('**ALERT: %d point(s) with a verdict other than ALL DIE / SINGULAR (pre-registered surprise): %s**\n\n' % (len(alert), [(r['d'], r['k'], r['type'], r['verdicts']) for r in alert]))
    f.write('types in CSV: %d; status: %s; still no F_p-rational root after %d lines: %d; point verdicts: %s\n' % (len(rows), dict(sc), A.tries, noroot, dict(vc)))
print(open(os.path.join(A.out, 'summary_%s.md' % A.mode)).read())
