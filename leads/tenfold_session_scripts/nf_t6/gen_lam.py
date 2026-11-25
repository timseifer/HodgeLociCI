# W3 task 2: FULLY generic directions v = (random element of T Cone_T, mod p) + bOf(a x l or l x a) (a, l uniform mod p).
# lambda = 2: order-6 test incl. the quadratic-freedom criterion (Lambda via the exact first-order formula);
# lambda = -1: arc to order N with top-term corrections and exact recomputation (run2 logic, own engine).
# NF-T6 copy of W3's gen_dirs.py: lambda may be a fraction r/s (exact lam = fmpq(r,s), mod p lam = r/s mod p);
# optional 7th arg engine fast|py (fast = SP-T6 compiled kernel).  Logic otherwise unchanged.
# python3 gen_lam.py p zidx r/s seed kind N [engine]
import sys, os, time, pickle, numpy as np
sys.path.insert(0, '/home/claude/hodge/discovery/checks/sp_t6/remote_job/engine'); sys.path.insert(0, '/home/claude/hodge/discovery/checks/ex_t6')
from w3eng import W3Engine
from sympy import sqrt_mod
from flint import fmpq
p = int(sys.argv[1]); zidx = int(sys.argv[2]); lamstr = sys.argv[3]; seed = int(sys.argv[4]); kind = sys.argv[5]; N = int(sys.argv[6])
eng = sys.argv[7] if len(sys.argv) > 7 else 'py'
_r, _s = (lamstr.split('/') + ['1'])[:2]; _r = int(_r); _s = int(_s)
lam = _r * pow(_s, p - 2, p) % p; lamq = fmpq(_r, _s)
t00 = time.time()
def say(*a): print(*a, "(%.0fs)" % (time.time() - t00), flush=True)
r = sqrt_mod(-3, p, all_roots=True); inv2 = pow(2, p - 2, p)
zp = sorted(set((1 + x) * inv2 % p for x in r))[zidx]
if eng == 'fast':
    os.environ.setdefault('FSC_SO_DIR', '/home/claude/hodge/discovery/checks/nf_t6')
    from fsc import FastEngine
    W = FastEngine(p, lam, z=zp, nthreads=1)
else:
    W = W3Engine(p, lam, z=zp)
SL = W.solveL_matrix(); kerL = W.kerL; Kl = W.Kl; nk = kerL.shape[1]
WP1 = W3Engine(p, 0, z=zp)       # P1 alone
# T Cone_T conditions mod p (mc_exact reduced: entries are small integers / Z[z])
from fex import ExactEngine, red_real_mat
from mc_exact import mc_exact
XX = ExactEngine(lamq); Mc_ex, _ = mc_exact(XX, lamq); Mc = red_real_mat(Mc_ex, p, zp)
TCb = W.kernel(Mc)
say("p", p, "z", zp, "lam", lamstr, "= %d mod p" % lam, "disc 8r^2-2rs+8s^2 =", 8*_r*_r-2*_r*_s+8*_s*_s, "seed", seed, "kind", kind, "rank L", W.Lrank, "dim T Cone_T", TCb.shape[1], "T Cone_T in ker L:", not (W.L @ TCb % p).any())
rng = np.random.default_rng(seed)
def mono(idx):
    e = [0] * 12
    for i in idx: e[i] += 1
    return tuple(e)
def bOf(M):
    z = W.z; d = {}
    for i in range(3):
        for j in range(3):
            fi = {mono([6 + 2 * i]): 1, mono([7 + 2 * i]): (-z) % p}
            hj = {mono([6 + 2 * j]): 1, mono([7 + 2 * j]): 1}
            for uk, cu in M[i][j].items():
                for e1, c1 in fi.items():
                    for e2, c2 in hj.items():
                        e = tuple(a + b for a, b in zip(e1, e2)); e = tuple(a + (1 if k == uk else 0) for k, a in enumerate(e))
                        d[e] = (d.get(e, 0) + c1 * c2 % p * cu) % p
    v = np.zeros(len(W.mons), np.int64)
    for e, c in d.items():
        if max(e) <= 1: v[W.mons.index(e)] = (v[W.mons.index(e)] + c) % p
    return v
a = rng.integers(1, p, 3); l = rng.integers(0, p, (3, 3))
if kind == 'al': M = [[{u: int(a[i] * l[j, k] % p) for k, u in enumerate((1, 3, 5))} for j in range(3)] for i in range(3)]
else: M = [[{u: int(a[j] * l[i, k] % p) for k, u in enumerate((1, 3, 5))} for j in range(3)] for i in range(3)]
c0 = TCb @ rng.integers(0, p, TCb.shape[1]) % p
v = (c0 + bOf(M)) % p
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

import resource
np.save('/home/claude/hodge/discovery/checks/nf_t6/arc_%d_%s_%d_%s_N%d.npy' % (p, lamstr.replace('/', 'o'), seed, kind, N), np.array(Ts, np.int64))
say("peak RSS %.2f GB" % (resource.getrusage(resource.RUSAGE_SELF).ru_maxrss / 2**20))
