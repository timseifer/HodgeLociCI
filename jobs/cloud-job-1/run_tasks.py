#!/usr/bin/env python3
"""[TOOLING] cloud-job-1 driver (PK; AI-generated, not reviewed by a human).

Runs a list of tasks in parallel with a CPU budget (sum of threads of running tasks <= --cores) and a MEMORY budget
(sum of the estimated peak memory of running tasks <= --mem-gb, estimates from estimate.py x --mem-safety).  A
watchdog kills the most recently started task if the machine's MemAvailable falls below --min-free-gb (that task is
recorded as ERROR 'killed by memory watchdog'; nothing else is touched).  Finished tasks (sidecar JSON present) are
skipped, so the same command can be restarted.  Every finished task appends one row to results/manifest.csv.

Task file (CSV with header; '#' lines ignored):  job,lam,p,seed,kind,N,threads
   job   : label (a = lambda=-1 generic, b = lambda=2 control, c = EX-T6 sparse arc, or any word)
   kind  : al | la (generic direction, hodge_job.py) or exarc_al | exarc_la (EX-T6 arc, run_arc.py; lam must be -1)

   python3 run_tasks.py tasks/recommended.csv --cores 30 --mem-gb 185
   python3 jobs/cloud-job-1/run_tasks.py jobs/cloud-job-1/tasks/g1_order12.csv --out jobs/queue/results/R002 --cores 30 --mem-gb 185
   python3 run_tasks.py tasks/test_small.csv --cores 2 --mem-gb 3 --nice 10 --ulimit-v-kb 2000000
"""
import argparse, csv, json, os, subprocess, sys, time, signal, hashlib
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from estimate import task_estimate

ap = argparse.ArgumentParser()
ap.add_argument('taskfile'); ap.add_argument('--cores', type=int, default=os.cpu_count())
ap.add_argument('--mem-gb', type=float, default=None, help='memory budget (default: 90%% of MemTotal)')
ap.add_argument('--mem-safety', type=float, default=1.25); ap.add_argument('--min-free-gb', type=float, default=4.0)
ap.add_argument('--out', default=os.path.join(HERE, 'results')); ap.add_argument('--nice', type=int, default=0)
ap.add_argument('--ulimit-v-kb', type=int, default=0, help='address-space cap per task (0 = none)')
ap.add_argument('--validation-dir', default=os.path.join(HERE, 'results', 'validation'),
                help='where validate.sh wrote VALIDATION_PASS (default jobs/cloud-job-1/results/validation)')
ap.add_argument('--skip-validation-check', action='store_true'); ap.add_argument('--dry-run', action='store_true')
ap.add_argument('--deadline-min', type=float, default=0, help='do not START new tasks after this many minutes (0 = no limit)')
A = ap.parse_args()

def meminfo(key):
    for l in open('/proc/meminfo'):
        if l.startswith(key + ':'): return int(l.split()[1]) / 2**20
    return 0.0
MEMB = A.mem_gb if A.mem_gb else 0.9 * meminfo('MemTotal')
if not A.skip_validation_check and not os.path.exists(os.path.join(A.validation_dir, 'VALIDATION_PASS')):
    sys.exit("refusing to run: %s/VALIDATION_PASS missing (run ./validate.sh first and make sure it passes)" % A.validation_dir)
A.out = os.path.abspath(A.out); os.makedirs(A.out, exist_ok=True)
import shutil
if os.path.isdir(A.validation_dir) and os.path.abspath(A.validation_dir) != os.path.join(A.out, 'validation'):
    shutil.copytree(A.validation_dir, os.path.join(A.out, 'validation'), dirs_exist_ok=True,
                    ignore=shutil.ignore_patterns('*.npy'))   # keep the validation evidence next to the results
RUNS = os.path.join(A.out, 'runs'); os.makedirs(RUNS, exist_ok=True)
MAN = os.path.join(A.out, 'manifest.csv')
COLS = ['job', 'lambda', 'prime', 'seed', 'kind', 'order_requested', 'order_reached', 'verdict', 'runtime_s', 'peak_rss_gb',
        'code_commit', 'engine_version', 'threads', 'log', 'arc_digest', 'note']
def commit():
    try: return subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=HERE, stderr=subprocess.DEVNULL).decode().strip()
    except Exception: return 'unknown'
COMMIT = commit()

tasks = []
for r in csv.DictReader(l for l in open(A.taskfile) if l.strip() and not l.startswith('#')):
    t = {k: r[k].strip() for k in r}
    t['lam'] = int(t['lam']); t['p'] = int(t['p']); t['seed'] = int(t['seed']); t['N'] = int(t['N']); t['threads'] = int(t.get('threads') or 1)
    if t['kind'].startswith('exarc'):
        assert t['lam'] == -1
        t['tag'] = 'exarc_%d_0_%s_N%d' % (t['p'], t['kind'][6:], t['N'])
    else:
        t['tag'] = 'gen_lam%d_%d_s%d_%s_N%d' % (t['lam'], t['p'], t['seed'], t['kind'], t['N'])
    mem, wall = task_estimate(t['lam'], t['kind'], t['N'], t['threads'])
    t['mem'] = mem * A.mem_safety; t['wall_h'] = wall
    if t['mem'] > MEMB: t['skip'] = 'estimated memory %.0f GB > budget %.0f GB' % (t['mem'], MEMB)
    tasks.append(t)
print("budget: %d cores, %.1f GB; %d tasks" % (A.cores, MEMB, len(tasks)))
for t in tasks:
    print("  %-34s threads %2d  est. mem %7.1f GB  est. wall %6.2f h %s" % (t['tag'], t['threads'], t['mem'], t['wall_h'], t.get('skip', '')))
if A.dry_run: sys.exit(0)

def side(t): return os.path.join(RUNS, t['tag'] + '.json')
def logf(t): return os.path.join(RUNS, t['tag'] + '.log')
def engine_version():
    ed = os.environ.get('HODGE_ENGINE_DIR', os.path.join(HERE, '..', '..', 'tooling', 'fermat_series'))
    h = hashlib.sha256()
    for f in ('fsc.cpp', 'fsc.py', 'w3eng.py', 'fe_ref.py'): h.update(open(os.path.join(ed, f), 'rb').read())
    h.update(open(os.path.join(HERE, 'run_arc.py'), 'rb').read()); return h.hexdigest()[:12]

def exarc_sidecar(t, rc, runtime):
    """verdict for run_arc.py (EX-T6 sparse arcs) from its log"""
    txt = open(logf(t)).read(); verdict, note, reached = 'ERROR', 'no HISTORY line (crash or out of memory? see log)', 0
    rss = 0.0
    for l in txt.splitlines():
        if l.startswith('peak RSS'): rss = float(l.split()[2])
        if l.startswith('HISTORY'):
            h = eval(l[len('HISTORY'):l.rfind('(')].strip())
            ok = [n for n, s in h if s == 'zero' or s.startswith('corrected')]
            reached = max(ok) if ok else 8
            if any('NOT in Im DG4' in s for n, s in h):
                verdict = 'OBSTRUCTED_UNRESOLVED'
                note = 'EX-T6 arc: K.c_n NOT removable by the top term at order %d; full linear freedom printed in the log; obstr_*.pkl saved; quadratic-freedom analysis NOT done by run_arc.py: REPORT' % (reached + 1)
            elif reached == t['N']: verdict, note = 'EXTENDS', 'arc to order %d' % reached
            else: verdict, note = 'ERROR', 'stopped at order %d' % reached
        if l.startswith('ERROR'): verdict, note = 'ERROR', l.strip()
    if verdict == 'EXTENDS' and rc != 0: verdict, note = 'ERROR', 'exit code %d' % rc
    dig = ''
    for l in txt.splitlines():
        if l.startswith('DIGEST arc'): dig = l.split()[2]
    json.dump({'tag': t['tag'], 'lambda': -1, 'prime': t['p'], 'seed': 0, 'kind': t['kind'], 'order_requested': t['N'],
               'order_reached': reached, 'verdict': verdict, 'note': note, 'runtime_s': round(runtime, 1), 'peak_rss_gb': rss,
               'engine_version': engine_version(), 'arc_digest': dig, 'threads': t['threads']}, open(side(t), 'w'), indent=1)

def manifest_row(t, d):
    new = not os.path.exists(MAN)
    with open(MAN, 'a', newline='') as f:
        w = csv.writer(f)
        if new: w.writerow(COLS)
        w.writerow([t['job'], d['lambda'], d['prime'], d['seed'], d['kind'], d['order_requested'], d['order_reached'], d['verdict'],
                    d['runtime_s'], d['peak_rss_gb'], COMMIT, d['engine_version'], d.get('threads', t['threads']),
                    os.path.relpath(logf(t), A.out), d.get('arc_digest', ''), d.get('note', '').replace('\n', ' ')])

def launch(t):
    if t['kind'].startswith('exarc'):
        cmd = [sys.executable, os.path.join(HERE, 'run_arc.py'), str(t['p']), '0', t['kind'][6:], str(t['N']), '--threads', str(t['threads']), '--out', RUNS]
    else:
        cmd = [sys.executable, os.path.join(HERE, 'hodge_job.py'), '--lam', str(t['lam']), '--p', str(t['p']), '--seed', str(t['seed']),
               '--kind', t['kind'], '--N', str(t['N']), '--threads', str(t['threads']), '--out', RUNS, '--tag', t['tag']]
    def pre():
        os.setsid()
        if A.nice: os.nice(A.nice)
        if A.ulimit_v_kb:
            import resource; resource.setrlimit(resource.RLIMIT_AS, (A.ulimit_v_kb * 1024, A.ulimit_v_kb * 1024))
    env = dict(os.environ, OMP_NUM_THREADS=str(t['threads']), OPENBLAS_NUM_THREADS='1', MKL_NUM_THREADS='1')
    return subprocess.Popen(cmd, stdout=open(logf(t), 'w'), stderr=subprocess.STDOUT, preexec_fn=pre, env=env)

# build the engine once (avoids a compile race between concurrent tasks)
subprocess.check_call([sys.executable, '-c', 'import sys,os; sys.path.insert(0,%r); import hodge_build' % HERE])

pending = [t for t in tasks if 'skip' not in t]
for t in tasks:
    if 'skip' in t and not os.path.exists(side(t)):
        d = {'lambda': t['lam'], 'prime': t['p'], 'seed': t['seed'], 'kind': t['kind'], 'order_requested': t['N'], 'order_reached': 0,
             'verdict': 'NOT_RUN', 'runtime_s': 0, 'peak_rss_gb': 0, 'engine_version': engine_version(), 'note': t['skip']}
        json.dump(dict(d, tag=t['tag']), open(side(t), 'w'), indent=1); manifest_row(t, d)
running = []; T0 = time.time()
while pending or running:
    # start what fits, in task-file order (a big task at the head blocks smaller ones only if cores/memory are short)
    used_c = sum(t['threads'] for t, _, _ in running); used_m = sum(t['mem'] for t, _, _ in running)
    late = A.deadline_min and (time.time() - T0) / 60 > A.deadline_min
    for t in list(pending):
        if os.path.exists(side(t)): pending.remove(t); print("skip (done):", t['tag']); continue
        if late: break
        if used_c + t['threads'] <= A.cores and used_m + t['mem'] <= MEMB:
            print(time.strftime('%H:%M:%S'), "start", t['tag'], "threads", t['threads'], "est mem %.1f GB" % t['mem'], flush=True)
            running.append((t, launch(t), time.time())); pending.remove(t)
            used_c += t['threads']; used_m += t['mem']
    if late and pending:
        for t in pending:
            d = {'lambda': t['lam'], 'prime': t['p'], 'seed': t['seed'], 'kind': t['kind'], 'order_requested': t['N'], 'order_reached': 0,
                 'verdict': 'NOT_RUN', 'runtime_s': 0, 'peak_rss_gb': 0, 'engine_version': engine_version(), 'note': 'deadline reached before start'}
            json.dump(dict(d, tag=t['tag']), open(side(t), 'w'), indent=1); manifest_row(t, d)
        pending = []
    if not running and pending:
        t = pending.pop(0); print("cannot fit", t['tag'], "(threads > cores?)"); continue
    time.sleep(2)
    if running and meminfo('MemAvailable') < A.min_free_gb:
        t, pr, st = running[-1]
        print(time.strftime('%H:%M:%S'), "MEMORY WATCHDOG: MemAvailable < %.1f GB, killing %s" % (A.min_free_gb, t['tag']), flush=True)
        os.killpg(pr.pid, signal.SIGKILL); pr.wait()
        d = {'lambda': t['lam'], 'prime': t['p'], 'seed': t['seed'], 'kind': t['kind'], 'order_requested': t['N'], 'order_reached': 0,
             'verdict': 'ERROR', 'runtime_s': round(time.time() - st, 1), 'peak_rss_gb': 0, 'engine_version': engine_version(),
             'note': 'killed by memory watchdog (machine out of memory); rerun alone or with a smaller order'}
        json.dump(dict(d, tag=t['tag']), open(side(t), 'w'), indent=1); manifest_row(t, d); running.pop()
    for item in list(running):
        t, pr, st = item
        rc = pr.poll()
        if rc is None: continue
        running.remove(item); rt = time.time() - st
        if t['kind'].startswith('exarc'): exarc_sidecar(t, rc, rt)
        elif not os.path.exists(side(t)):
            tail = open(logf(t)).read().splitlines()[-3:]
            json.dump({'tag': t['tag'], 'lambda': t['lam'], 'prime': t['p'], 'seed': t['seed'], 'kind': t['kind'], 'order_requested': t['N'],
                       'order_reached': 0, 'verdict': 'ERROR', 'note': 'exit code %d: %s' % (rc, ' | '.join(tail))[:300], 'runtime_s': round(rt, 1),
                       'peak_rss_gb': 0, 'engine_version': engine_version(), 'threads': t['threads']}, open(side(t), 'w'), indent=1)
        d = json.load(open(side(t)))
        manifest_row(t, d)
        flag = '   <<<<< REPORT PROMINENTLY' if d['verdict'] not in ('EXTENDS',) and not (t['lam'] == 2 and d['verdict'] == 'OBSTRUCTED_GENUINE') else ''
        print(time.strftime('%H:%M:%S'), "done ", t['tag'], d['verdict'], "order", d['order_reached'], "%.0fs" % rt, flag, flush=True)
print("all tasks finished; now run: python3 make_summary.py %s && python3 check_results.py %s" % (A.out, A.out))
