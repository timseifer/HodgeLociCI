#!/usr/bin/env python3
"""Rough resource estimate for run_job.py (generic dense directions) and run_arc.py (EX-T6 sparse arcs).

    python3 estimate.py            # table for orders 9..15, 1 / 16 / 64 cores

Model (calibrated on the 2-core development machine, compiled engine, 1 thread; see README):
  * |E'_m| = number of stored terms at level m.  Dense (generic) directions saturate all monomials of degree 3m in
    12 variables: |E'_m| = C(3m + 11, 11) (measured: m = 7 gives 129,018,619 vs C(32, 11) = 129,024,480).
    EX-T6 sparse arcs: measured up to m = 11 (144,963,001), then extrapolated with ratios 2.30, 2.19, 2.10, 2.03.
  * CPU time of level m: t_m = c * S_(m-1), S_k = |E'_0| + ... + |E'_k| (the work is dominated by the products
    T_j * E'_(m-j), whose number of raw terms is about |T_j| * S_(m-1)).  c_dense = 4.1 us, c_sparse = 0.8 us per
    core (measured 6.2 / 1.2 us wall on a shared machine at about 2/3 of a core; +-50%).
  * A run to order N rebuilds about four levels per order: total = sum_(n <= N) (t_(n-1) + t_(n-2) + t_(n-3) + t_(n-4)).
  * Memory: 12 bytes per stored term for levels 0..N-2, plus one extra copy of the largest stored level while it is
    built, plus 0.5 GB.  The top level N-1 is streamed (not stored).
  * Threads: parallel efficiency assumed 0.85 at 16 cores and 0.6 at 64 cores (NOT measured).
"""
from math import comb

def counts(kind, mmax=16):
    if kind == 'dense':
        return [comb(3 * m + 11, 11) for m in range(mmax + 1)]
    E = [1, 35, 520, 4871, 32281, 165495, 695432, 2499584, 7922418, 22651163, 59428420, 144963001]
    for r in (2.30, 2.19, 2.10, 2.03, 1.97):
        E.append(int(E[-1] * r))
    return E

def estimate(kind, N, cores):
    E = counts(kind); S = [sum(E[:k + 1]) for k in range(len(E))]
    c = 4.1e-6 if kind == 'dense' else 0.8e-6
    t = [0.0] + [c * S[m - 1] for m in range(1, len(E))]
    tot = sum(t[n - k] for n in range(5, N + 1) for k in range(1, 5) if n - k >= 1)
    eff = 1.0 if cores == 1 else (0.85 if cores <= 16 else 0.6)
    mem = 12 * (S[N - 2] + E[N - 2]) / 1e9 + 0.5
    return E[N - 1], E[N - 2], mem, tot / 3600.0, tot / (cores * eff) / 3600.0

if __name__ == '__main__':
    for kind in ('dense', 'sparse'):
        print("%s directions (%s)" % (kind, 'W3 generic, run_job.py' if kind == 'dense' else 'EX-T6 arcs, run_arc.py'))
        print("  N  |E'_(N-1)| streamed  |E'_(N-2)| stored   memory GB   CPU-hours   wall h @1   @16    @64")
        for N in range(9, 16):
            e1, e2, mem, cpu, _ = estimate(kind, N, 1)
            w = [estimate(kind, N, k)[4] for k in (1, 16, 64)]
            print("  %2d  %16.3e  %16.3e  %10.1f  %10.2f  %9.2f  %6.2f  %6.2f" % (N, e1, e2, mem, cpu, *w))
        print()
