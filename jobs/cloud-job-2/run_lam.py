#!/usr/bin/env python3
"""[TOOLING] cloud-job-2 driver for OTHER LAMBDA VALUES (PK2; AI-generated, not reviewed by a human).
Runs hodge_job_lam.py tasks (lambda = r/s, Fermat cubic tenfold, generic rank-1 directions, orders <= 8, each
< 2 GB) in parallel, one thread each, at most --procs at a time.  First runs validate_lam.sh into
<out>/validation_lam (unless it already passed there) and refuses to continue if it fails.  Writes <out>/runs/<tag>.log/.json, <out>/manifest.csv (columns as
cloud-job-1, 'lambda' = r/s string), <out>/summary.md.  Restarting skips finished tasks.
Task file (CSV, '#' lines ignored): job,lam,p,seed,kind,N
    python3 jobs/cloud-job-2/run_lam.py jobs/cloud-job-2/tasks/l_lambdas_N7.csv --out jobs/queue/results/<id> --procs 8
"""
import argparse, csv, json, os, subprocess, sys, time, shutil
from concurrent.futures import ThreadPoolExecutor
HERE = os.path.dirname(os.path.abspath(__file__))
ap = argparse.ArgumentParser(); ap.add_argument('taskfile'); ap.add_argument('--out', required=True)
ap.add_argument('--procs', type=int, default=8); ap.add_argument('--nice', type=int, default=0)
ap.add_argument('--ulimit-v-kb', type=int, default=0); ap.add_argument('--deadline-min', type=float, default=0)
A = ap.parse_args()
A.out = os.path.abspath(A.out); RUNS = os.path.join(A.out, 'runs'); os.makedirs(RUNS, exist_ok=True)
VD = os.path.join(A.out, 'validation_lam')
if not os.path.exists(os.path.join(VD, 'VALIDATION_PASS')):
    print('running validate_lam.sh ->', VD, flush=True)
    if subprocess.call(['bash', os.path.join(HERE, 'validate_lam.sh'), VD]) != 0 or not os.path.exists(os.path.join(VD, 'VALIDATION_PASS')):
        sys.exit('refusing to run: validate_lam.sh FAILED (see %s/validate_lam.log)' % VD)
tasks = []
for r in csv.DictReader(l for l in open(A.taskfile) if l.strip() and not l.startswith('#')):
    t = {k: r[k].strip() for k in r}; t['N'] = int(t['N']); assert t['N'] <= 8, 'orders > 8 do not belong in this driver'
    t['tag'] = 'gen_lam%s_%s_s%s_%s_N%d' % (t['lam'].replace('/', 'o'), t['p'], t['seed'], t['kind'], t['N']); tasks.append(t)
subprocess.check_call([sys.executable, os.path.join(HERE, '..', 'cloud-job-1', 'hodge_build.py')],
                      env=dict(os.environ, FSC_SO_DIR=os.path.join(HERE, '..', 'cloud-job-1', 'build')))
T0 = time.time()
def pre():
    if A.nice: os.nice(A.nice)
    if A.ulimit_v_kb:
        import resource; resource.setrlimit(resource.RLIMIT_AS, (A.ulimit_v_kb * 1024,) * 2)
def run(t):
    side = os.path.join(RUNS, t['tag'] + '.json')
    if os.path.exists(side): return t
    if A.deadline_min and (time.time() - T0) / 60 > A.deadline_min:
        json.dump({'tag': t['tag'], 'lambda': t['lam'], 'prime': int(t['p']), 'seed': int(t['seed']), 'kind': t['kind'], 'order_requested': t['N'],
                   'order_reached': 0, 'verdict': 'NOT_RUN', 'note': 'deadline reached before start', 'runtime_s': 0, 'peak_rss_gb': 0}, open(side, 'w'))
        return t
    st = time.time()
    cmd = [sys.executable, os.path.join(HERE, 'hodge_job_lam.py'), '--lam=' + t['lam'], '--p', t['p'], '--seed', t['seed'], '--kind', t['kind'],
           '--N', str(t['N']), '--threads', '1', '--out', RUNS, '--tag', t['tag']]
    env = dict(os.environ, OMP_NUM_THREADS='1', OPENBLAS_NUM_THREADS='1', MKL_NUM_THREADS='1', FSC_SO_DIR=os.path.join(HERE, '..', 'cloud-job-1', 'build'))
    rc = subprocess.call(cmd, stdout=open(os.path.join(RUNS, t['tag'] + '.log'), 'w'), stderr=subprocess.STDOUT, preexec_fn=pre, env=env)
    if not os.path.exists(side):
        tail = open(os.path.join(RUNS, t['tag'] + '.log')).read().splitlines()[-3:]
        json.dump({'tag': t['tag'], 'lambda': t['lam'], 'prime': int(t['p']), 'seed': int(t['seed']), 'kind': t['kind'], 'order_requested': t['N'],
                   'order_reached': 0, 'verdict': 'ERROR', 'note': ('exit code %d: ' % rc + ' | '.join(tail))[:300], 'runtime_s': round(time.time() - st, 1),
                   'peak_rss_gb': 0}, open(side, 'w'))
    d = json.load(open(side))
    print(time.strftime('%H:%M:%S'), 'done', t['tag'], d['verdict'], 'order', d['order_reached'], flush=True)
    return t
with ThreadPoolExecutor(A.procs) as ex: list(ex.map(run, tasks))
try: commit = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=HERE, stderr=subprocess.DEVNULL).decode().strip()
except Exception: commit = 'unknown'
COLS = ['job', 'lambda', 'prime', 'seed', 'kind', 'order_requested', 'order_reached', 'verdict', 'runtime_s', 'peak_rss_gb',
        'code_commit', 'engine_version', 'threads', 'log', 'arc_digest', 'note']
rows = []
with open(os.path.join(A.out, 'manifest.csv'), 'w', newline='') as f:
    w = csv.writer(f); w.writerow(COLS)
    for t in tasks:
        d = json.load(open(os.path.join(RUNS, t['tag'] + '.json'))); rows.append((t, d))
        w.writerow([t['job'], d['lambda'], d['prime'], d['seed'], d['kind'], d['order_requested'], d['order_reached'], d['verdict'], d['runtime_s'],
                    d['peak_rss_gb'], commit, d.get('engine_version', ''), 1, 'runs/%s.log' % t['tag'], d.get('arc_digest', ''), d.get('note', '')])
with open(os.path.join(A.out, 'summary.md'), 'w') as f:
    ext = sorted({d['lambda'] for t, d in rows if d['verdict'] == 'EXTENDS'}); bad = [(t['tag'], d['verdict']) for t, d in rows if d['verdict'] in ('ERROR', 'OBSTRUCTED_UNRESOLVED', 'OBSTRUCTED_CHOICE')]
    f.write('# cloud-job-2 L: other lambda values at the Fermat cubic tenfold (MOD p, AI-generated, unreviewed)\n\n')
    f.write('lambda values with a run that EXTENDS to the requested order: %s\n\n' % (', '.join(ext) or 'none'))
    f.write('runs needing attention (ERROR / UNRESOLVED / CHOICE): %s\n\n' % (bad or 'none'))
    f.write('| lambda | p | seed | kind | N | reached | verdict | s |\n|---|---|---|---|---|---|---|---|\n')
    for t, d in rows: f.write('| %s | %s | %s | %s | %s | %s | %s | %s |\n' % (d['lambda'], d['prime'], d['seed'], d['kind'], d['order_requested'], d['order_reached'], d['verdict'], d['runtime_s']))
print(open(os.path.join(A.out, 'summary.md')).read().split('| lambda')[0])
