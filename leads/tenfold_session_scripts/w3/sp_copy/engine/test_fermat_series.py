#!/usr/bin/env python3
# [TOOLING] test: the compiled Fermat-series kernel (fsc.cpp via fsc.py) must reproduce the Python reference engines
# EXACTLY on small cases (orders <= 6): the polynomials E'_m (keys and values) and the period accumulators H(E'_m)
# (hence all MH matrices), for 1 and 2 threads, with and without the visibility filter on streamed levels.
# References: w3eng.W3Engine.Eprime (bucketed numpy engine) and, for orders <= 3, fe_ref.Engine (mul/add + H with
# 11-bit limbs).  Runs in well under a minute.  Exit code 0 = PASS.
#   python3 test_fermat_series.py
import os, sys, time, numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
from w3eng import W3Engine
from fe_ref import Engine as RefEngine
from fsc import FastEngine
t0 = time.time(); ok_all = True
def check(name, cond):
    global ok_all
    ok_all &= bool(cond); print(("PASS " if cond else "FAIL ") + name, flush=True)
def sparse_slice(rng, p, nnz=35):
    v = np.zeros(220, np.int64); idx = rng.choice(220, nnz, replace=False); v[idx] = rng.integers(1, p, nnz); return v
for (p, lam, seed, M) in [(67108837, -1, 1, 6), (32029, 2, 2, 5), (999979, -1, 3, 4)]:
    rng = np.random.default_rng(seed)
    W = W3Engine(p, lam)                     # z = default root of unity of order 6 (same in all engines)
    F1 = FastEngine(p, lam, z=W.z, nthreads=1); F2 = FastEngine(p, lam, z=W.z, nthreads=2)
    Ts = [sparse_slice(rng, p) for _ in range(M)]
    Tp = [W.vec_to_poly(T) for T in Ts]
    Ew = [W.poly_one()]; E1 = [W.poly_one()]
    for m in range(1, M + 1):
        a, aa, na = W.Eprime(m, Tp, Ew)
        b, bb, nb = F1.Eprime(m, Tp, E1)
        c, cc, nc = F2.Eprime(m, Tp, E1)
        F1.visfilter = True; _, dd, nd = F1.Eprime(m, Tp, E1, store=False); F1.visfilter = False
        same = (na == nb == nc == nd and np.array_equal(a[0], b[0]) and np.array_equal(a[1].astype(np.int64), b[1].astype(np.int64))
                and np.array_equal(b[0], c[0]) and np.array_equal(b[1], c[1])
                and np.array_equal(aa, bb) and np.array_equal(aa, cc) and np.array_equal(aa, dd))
        check("p=%d lam=%d E'_%d (%d terms): poly + H identical (W3Engine, compiled 1 and 2 threads, filtered stream)" % (p, lam, m, na), same)
        if m <= 3:
            R = RefEngine(p, lam, z=W.z) if m == 1 else R
            inv = pow(m, p - 2, p)
            Er = R.add(*[(j * inv, R.mul(Tp[j - 1], Ew[m - j])) for j in range(1, m + 1)])
            check("p=%d lam=%d E'_%d: fe_ref mul/add + MH identical" % (p, lam, m),
                  np.array_equal(Er[0], b[0]) and np.array_equal(Er[1] % p, b[1].astype(np.int64)) and np.array_equal(R.MH(Er), F1.MH_from_acc(bb)))
        Ew.append(a); E1.append(b)
print("RESULT", "PASS" if ok_all else "FAIL", "(%.1fs)" % (time.time() - t0))
sys.exit(0 if ok_all else 1)
