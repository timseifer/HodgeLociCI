# Remote job (SP-T6 package of W3's gen_dirs.py, lambda = -1 path unchanged): formal arc of the Hodge locus at the
# Fermat cubic tenfold along a FIXED direction v (read from inputs/), extended order by order with top-term
# corrections and exact recomputation, MOD p.  Engine: compiled kernel (engine/fsc.cpp) or the numpy reference.
# python3 run_job.py DIRFILE N [--threads T] [--engine fast|py] [--out results]
import sys, os, time, json, argparse, numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, os.path.join(HERE, 'engine'))
from w3eng import W3Engine
ap = argparse.ArgumentParser(); ap.add_argument('dirfile'); ap.add_argument('N', type=int)
ap.add_argument('--threads', type=int, default=os.cpu_count()); ap.add_argument('--engine', default='fast')
ap.add_argument('--out', default=os.path.join(HERE, 'results'))
A = ap.parse_args(); N = A.N
D = json.load(open(A.dirfile))
p = D['p']; zidx = D['zidx']; lam = D['lam']; seed = D['seed']; kind = D['kind']
assert lam == -1
t00 = time.time()
def say(*a): print(*a, "(%.0fs)" % (time.time() - t00), flush=True)
zp = D['z']
if A.engine == 'fast':
    from fsc import FastEngine
    W = FastEngine(p, lam, z=zp, nthreads=A.threads)
else:
    W = W3Engine(p, lam, z=zp)
SL = W.solveL_matrix(); kerL = W.kerL; Kl = W.Kl; nk = kerL.shape[1]
WP1 = W3Engine(p, 0, z=zp)       # P1 alone
Mc = np.array(D['Mc'], np.int64) % p
TCb = W.kernel(Mc)
say("p", p, "z", zp, "lam", lam, "seed", seed, "kind", kind, "rank L", W.Lrank, "dim T Cone_T", TCb.shape[1], "T Cone_T in ker L:", not (W.L @ TCb % p).any())
rng = np.random.default_rng(seed)
_a = rng.integers(1, p, 3); _l = rng.integers(0, p, (3, 3)); _c = rng.integers(0, p, TCb.shape[1])   # same rng state as gen_dirs.py
v = np.array(D['v'], np.int64) % p
c0 = np.array(D['c0'], np.int64) % p

say("v: nnz", int(np.count_nonzero(v)), " L v = 0:", not (W.L @ v % p).any(), " Mc v != 0 (not in T Cone_T):", bool((Mc @ v % p).any()),
    " L_P1 v != 0 (not in T V_Z):", bool((WP1.L @ v % p).any()), " nnz of c0 in x-variables:", int(sum(1 for i, m in enumerate(W.mons) if c0[i] and any(m[:6]))))

Ts = [v]; Es = [W.poly_one()]; MHs = [W.L]; xs = {}
def rebuild(m0, m1, store_upto):
    global Es, MHs
    Es = Es[:m0]; MHs = MHs[:m0]
    Tp = [W.vec_to_poly(T) for T in Ts]
    for m in range(m0, m1 + 1):
        t = time.time()
        E, acc, nt = W.Eprime(m, Tp, Es, store=(m <= store_upto))
        Es.append(E if m <= store_upto else None); MHs.append(W.MH_from_acc(acc))
        say("   E'_%d: %d terms (%.0fs)" % (m, nt, time.time() - t))
def coeff(m):
    inv = pow(m, p - 2, p); c = np.zeros(221, np.int64)
    for j in range(1, m):
        c = (c + j * (MHs[m - j] @ Ts[j - 1] % p)) % p
    return c * inv % p
def lin(j, dT0, n):
    dT = {j: dT0 % p}; dc = {}
    for m in range(j + 1, n + 1):
        acc = np.zeros((221, dT0.shape[1]), np.int64)
        for i in range(j, m):
            acc = (acc + MHs[m - i] @ dT[i]) % p
        dc[m] = acc; dT[m] = SL @ acc % p
    return dc, dT
def build_to(n, start=1):
    """T_m = SL c_m + kerL x_m for m < n; returns c dict"""
    global Ts
    cs = {}
    Ts = Ts[:max(1, start)]
    rebuild(start if start >= 1 else 1, start, n - 2) if start >= 1 else None
    for m in range(2, n + 1):
        if m - 1 > len(MHs) - 1: rebuild(m - 1, m - 1, n - 2)
        cs[m] = coeff(m)
        if m == n: break
        if len(Ts) < m:
            T = SL @ cs[m] % p
            if m in xs: T = (T + kerL @ xs[m]) % p
            Ts.append(T)
    return cs
hist = []
Ts = [v]; Es = [W.poly_one()]; MHs = [W.L]
for n in range(4, N + 1):
    # (re)build: T's up to n-1 from scratch starting at the first changed one
    cs = {}
    for m in range(2, n + 1):
        if len(MHs) < m: rebuild(m - 1, m - 1, N - 2)
        cs[m] = coeff(m)
        if m == n: break
        if len(Ts) < m:
            T = SL @ cs[m] % p
            if m in xs: T = (T + kerL @ xs[m]) % p
            Ts.append(T)
    Kc = {m: Kl @ cs[m] % p for m in cs}
    low = [m for m in range(2, n) if Kc[m].any()]
    say("ORDER", n, ": K.c_m nonzero for m < n:", low, " K.c_n nnz", int(np.count_nonzero(Kc[n])))
    if low: say("RESULT order", n - 1 if low else n, "linear correction did not survive the exact recomputation (nonlinear needed)"); hist.append((low[0], 'nonlinear')); break
    if n == 5 or (n == 4):
        pass
    if not Kc[n].any():
        hist.append((n, 'zero')); continue
    if n == 4: say("RESULT G4(v) != 0: v not in V(G4)"); hist.append((4, 'G4 != 0')); break
    j = n - 3
    dc, dT = lin(j, kerL, n)
    Dn = Kl @ dc[n] % p
    if n == 5:
        DG = Dn; say("   rank DG4(v) =", W.rank(DG))
    inIm = W.in_span(Dn, Kc[n])
    say("   x_%d effect rank %d, equals DG4(v): %s; K.c_n in Im DG4(v): %s" % (j, W.rank(Dn), np.array_equal(Dn, DG), inIm))
    if not inIm:
        if n == 6:
            # quadratic-freedom criterion: Lambda(ker DG4(v)) via the first-order formula (x_2 -> k in ker DG4)
            kD = W.kernel(DG)                     # coordinates in ker L
            dc2, _ = lin(2, kerL @ kD % p, 6)
            Lam = Kl @ dc2[6] % p
            low2 = [m for m in (3, 4, 5) if (Kl @ dc2[m] % p).any()]
            rIL = W.rank(np.concatenate([DG, Lam], 1))
            inIL = W.in_span(np.concatenate([DG, Lam], 1), Kc[6])
            say("   dim ker DG4(v) = %d; k in ker DG4 leaves K.c3..5 unchanged to first order: %s; rank [Im DG4 | Lambda(ker)] = %d; K.c6 in it: %s"
                % (kD.shape[1], not low2, rIL, inIL))
            # quadratic part check at one random k: K.c6(x2* + k) - K.c6(x2*) - Lambda(k) in Im DG4 ?
            k = kD @ rng.integers(0, p, kD.shape[1]) % p
            save = (list(Ts), list(Es), list(MHs), dict(xs))
            xs[2] = (xs.get(2, np.zeros(nk, np.int64)) + k) % p
            Ts = Ts[:1]; Es = Es[:2]; MHs = MHs[:2]
            cs2 = {}
            for m in range(2, 7):
                if len(MHs) < m: rebuild(m - 1, m - 1, 5)
                cs2[m] = coeff(m)
                if m == 6: break
                if len(Ts) < m:
                    T = SL @ cs2[m] % p
                    if m in xs: T = (T + kerL @ xs[m]) % p
                    Ts.append(T)
            q = (Kl @ cs2[6] - Kc[6] - Lam @ (np.zeros(kD.shape[1], np.int64)) ) % p
            lamk = Kl @ (lin(2, (kerL @ k % p)[:, None], 6)[0][6]) % p
            Ts, Es, MHs, xs = save
            q = (Kl @ cs2[6] - Kc[6] - lamk[:, 0]) % p
            say("   random k: K.c3..5 still 0:", all(not (Kl @ cs2[m] % p).any() for m in (3, 4, 5)), "; quadratic part in Im DG4(v):", W.in_span(DG, q))
            res = 'OBSTRUCTED at order 6 (K.c6 not in Im DG4 + Lambda(ker DG4))' if not inIL else 'order 6 removable with quadratic freedom'
            say("RESULT", res); hist.append((6, res)); break
        say("RESULT order", n, "not in Im DG4(v) (top term); stop"); hist.append((n, 'not in Im DG4')); break
    x = W.solve(Dn, (-Kc[n]) % p)
    xs[j] = (xs.get(j, np.zeros(nk, np.int64)) + x) % p
    if n == N:
        dTx = {m: dT[m] @ x % p for m in dT}; dcx = {m: dc[m] @ x % p for m in dc}
        aff = all(not (Kl @ ((cs[m] + dcx.get(m, 0)) % p) % p).any() for m in range(2, n + 1))
        say("   final order: corrected x_%d, K.c_m = 0 (m = 2..%d) by the exact affine formula (valid for n >= 7): %s" % (j, n, aff))
        hist.append((n, 'corrected x%d (affine)' % j)); break
    hist.append((n, 'corrected x%d' % j))
    Ts = Ts[:j - 1]; Es = Es[:j]; MHs = MHs[:j]
else:
    pass
say("HISTORY", hist)
import hashlib
os.makedirs(A.out, exist_ok=True)
tag = "%d_%d_%s_N%d" % (p, seed, kind, N)
np.save(os.path.join(A.out, "arc_%s.npy" % tag), np.array(Ts, np.int64))
say("DIGEST arc", hashlib.sha256(np.array(Ts, np.int64).tobytes()).hexdigest()[:16])

import resource
say("peak RSS %.2f GB" % (resource.getrusage(resource.RUSAGE_SELF).ru_maxrss / 2**20))
