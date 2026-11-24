#!/usr/bin/env python3
"""Resource model for cloud-job-1 (PK, from SP-T6's remote_job/estimate.py; AI-generated, rough: +-50%).

    python3 estimate.py                 # table for the cloud machine (30 cores, 200 GB)
    python3 estimate.py --cores 30 --eff 0.6

Model (calibrated by SP-T6 on a 2-core shared machine, compiled engine, 1 thread):
  * stored terms per level: dense (generic) directions |E'_m| = C(3m+11, 11) (measured m = 7: 129,018,619 vs
    129,024,480); EX-T6 sparse arcs measured to m = 11, then ratios 2.30, 2.19, 2.10, 2.03.
  * CPU time of level m: c * S_(m-1), S_k = |E'_0| + ... + |E'_k|; c_dense = 4.1 us, c_sparse = 0.8 us.
  * a run to order N rebuilds about 4 levels per order.  lambda = 2 control: order 6 plus 2 exact rebuilds to 5.
  * memory: 12 bytes per stored term for levels 0..N-2, one extra copy of the largest stored level, + 0.5 GB.
  * parallel efficiency of the OpenMP bucket split: NOT measured on many cores (eff parameter, default 0.6).
"""
from math import comb
import argparse

def counts(kind, mmax=16):
    if kind == 'dense':
        return [comb(3 * m + 11, 11) for m in range(mmax + 1)]
    E = [1, 35, 520, 4871, 32281, 165495, 695432, 2499584, 7922418, 22651163, 59428420, 144963001]
    for r in (2.30, 2.19, 2.10, 2.03, 1.97):
        E.append(int(E[-1] * r))
    return E

def cpu_hours(kind, N):
    E = counts(kind); S = [sum(E[:k + 1]) for k in range(len(E))]
    c = 4.1e-6 if kind == 'dense' else 0.8e-6
    t = [0.0] + [c * S[m - 1] for m in range(1, len(E))]
    tot = sum(t[n - k] for n in range(5, N + 1) for k in range(1, 5) if n - k >= 1)
    return tot / 3600.0

def mem_gb(kind, N):
    E = counts(kind); S = [sum(E[:k + 1]) for k in range(len(E))]
    return 12 * (S[N - 2] + E[N - 2]) / 1e9 + 0.5

def task_estimate(lam, kind, N, threads, eff=0.6):
    """(memory GB, wall hours) for one task. kind: 'al'/'la' (generic dense) or 'exarc_al'/'exarc_la' (sparse)."""
    k = 'sparse' if kind.startswith('exarc') else 'dense'
    if lam == 2:
        cpu = cpu_hours(k, 6) + 2 * cpu_hours(k, 6) / 4.0
        mem = mem_gb(k, 6)
    else:
        cpu, mem = cpu_hours(k, N), mem_gb(k, N)
    e = 1.0 if threads <= 1 else (0.85 if threads <= 4 else eff)
    return mem + 0.3, cpu / (threads * e)

if __name__ == '__main__':
    ap = argparse.ArgumentParser(); ap.add_argument('--cores', type=int, default=30); ap.add_argument('--mem', type=float, default=200)
    ap.add_argument('--eff', type=float, default=0.6)
    ap.add_argument('--speed', type=float, default=None, help='CALIBRATION speed factor printed by validate.sh (replaces --eff)')
    A = ap.parse_args()
    if A.speed: A.eff = A.speed
    print("Machine: %d cores, %.0f GB RAM, parallel efficiency %.2f (assumed)" % (A.cores, A.mem, A.eff))
    print("job                         N   stored |E'_(N-2)|   mem GB   CPU-h   wall h (all %d cores)   fits RAM" % A.cores)
    for kind, lab in (('dense', 'lambda=-1 generic'), ('sparse', 'lambda=-1 EX-T6 sparse')):
        for N in range(8, 16):
            m = mem_gb(kind, N); c = cpu_hours(kind, N)
            print("%-26s %2d  %16.3e  %7.1f  %6.2f  %8.2f                 %s" % (lab, N, counts(kind)[N - 2], m, c, c / (A.cores * A.eff),
                                                                          'yes' if m < 0.9 * A.mem else 'NO'))
    m, w = task_estimate(2, 'al', 6, 1)
    print("%-26s %2d  %16s  %7.1f  %6.2f  (1 thread per task)" % ('lambda=2 generic control', 6, '-', m, w))
