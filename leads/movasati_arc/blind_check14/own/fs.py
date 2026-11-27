#!/usr/bin/env python3
"""Own full-space test of order-6 obstruction (MOD p).  Unknowns T_2..T_5 squarefree cubics (T_6 only enters
linearly via L T_6, so order 6 is projected to coker L).  Parametrisation: T_n = k_n - X c'_n with k_n in ker L,
c'_n = c_n evaluated with T_n = 0, X a fixed right inverse of L on im L.  Then c_n = (I - L X) c'_n and the
equations are ob_n(k) := Kl c'_n = 0 (Kl: basis of the left kernel of L).  Exact reformulation (no loss)."""
import sys; sys.path.insert(0, "/home/claude/blind_check14/own")
from own import *
from flint import nmod_mat

def mat_mod(A, p):
    A = np.array(A, dtype=np.int64) % p
    return nmod_mat(A.shape[0], A.shape[1], [int(v) for v in A.flatten()], p)
def to_np(Mf):
    return np.array([[int(Mf[i, j]) for j in range(Mf.ncols())] for i in range(Mf.nrows())], dtype=np.int64)
def rref(A, p):
    Mf = mat_mod(A, p); R, r = Mf.rref(); R = to_np(R)[:r]
    piv = [int(np.flatnonzero(R[i])[0]) for i in range(r)]
    return R, piv
def rank(A, p):
    A = np.array(A); return 0 if A.size == 0 else mat_mod(A, p).rank()
def nullspace(A, p):
    A = np.array(A, dtype=np.int64) % p; nc = A.shape[1]
    R, piv = rref(A, p); free = [c for c in range(nc) if c not in set(piv)]
    N = np.zeros((nc, len(free)), dtype=np.int64)
    for a, c in enumerate(free):
        N[c, a] = 1
        for i, pc in enumerate(piv): N[pc, a] = (-R[i, c]) % p
    return N
def in_span(Wcols, v, p):
    return rank(np.hstack([Wcols, v.reshape(-1, 1)]), p) == rank(Wcols, p) if Wcols.shape[1] else not (v % p).any()

class FS:
    def __init__(s, S, P, T1, seed=1):
        s.S = S; p = s.p = S.p; s.tab = S.ptable(P); s.T1 = T1
        s.rng = np.random.default_rng(seed)
        s.m3 = [tuple(1 if i in c else 0 for i in range(M)) for c in itertools.combinations(range(M), 3)]
        s.i3 = {m: i for i, m in enumerate(s.m3)}
        s.m6 = sorted({tuple(a + b for a, b in zip(u, v)) for u in s.m3 for v in s.m3})
        s.i6 = {m: i for i, m in enumerate(s.m6)}
        one = S.ctx.from_dict({(0,)*M: 1})
        F = [one]
        for k in range(1, 7): F.append(F[-1] * T1 * pow(k, p-2, p))
        s.F = F
        s.M3 = [s.batch(F[k], s.m3) for k in range(5)]
        s.M6 = [s.batch(F[k], s.m6) for k in range(3)]
        s.fper = [S.periods(F[n], s.tab) for n in range(7)]
        L = s.M3[0]; s.L = L
        s.rkL = rank(L, p)
        s.K = nullspace(L, p)                       # 120 x dimK
        s.Kl = nullspace(L.T, p).T                  # 26 x 45
        # right inverse X: pivot rows/cols
        R, pc = rref(L, p); Rt, pr = rref(L.T, p)
        sub = L[np.ix_(pr, pc)] % p
        inv = to_np(mat_mod(sub, p).inv())
        X = np.zeros((120, 45), dtype=np.int64); X[np.ix_(pc, pr)] = inv; s.X = X
        assert not ((L @ X @ L - L) % p).any()
    def batch(s, f, mons):
        """45 x len(mons): Psi(Q f x^g)"""
        S = s.S; p = s.p; n = len(f)
        ex = np.fromiter(itertools.chain.from_iterable(f.monoms()), dtype=np.int64, count=n*M).reshape(n, M)
        co = np.fromiter((int(c) for c in f.coeffs()), dtype=np.int64, count=n)
        G = np.array(mons, dtype=np.int64); out = np.zeros((45, len(mons)), dtype=np.int64)
        pw2 = 1 << np.arange(M, dtype=np.int64)
        ch = max(1, 400000 // n)
        for s0 in range(0, len(mons), ch):
            g = G[s0:s0+ch]; k = len(g)
            base = (g[:, None, :] + ex[None, :, :]).reshape(k*n, M)
            grp = np.repeat(np.arange(k), n); cc = np.tile(co, k)
            for i, q in enumerate(S.Q):
                h = base + np.array(q)[None, :]; r = h % 3
                ok = (r != 2).all(axis=1)
                hh = h[ok]; w = cc[ok].copy()
                for j in range(M): w = w * S.W[hh[:, j]] % p
                w = w * s.tab[((1 - r[ok]) * pw2).sum(axis=1)] % p
                out[i, s0:s0+k] = np.round(np.bincount(grp[ok], weights=w.astype(np.float64), minlength=k)).astype(np.int64) % p
        return out
    def poly3(s, v):
        return s.S.ctx.from_dict({s.m3[i]: int(v[i]) % s.p for i in range(120) if int(v[i]) % s.p})
    def v6(s, f):
        v = np.zeros(len(s.m6), dtype=np.int64)
        for mon, c in zip(f.monoms(), f.coeffs()): v[s.i6[tuple(mon)]] = int(c)
        return v
    def cprime(s, n, T, P):
        """c'_n given vectors T[2..n-1] (dict) and polys P[j]"""
        p = s.p; c = s.fper[n].copy()
        for j in range(2, n): c = c + s.M3[n - j] @ T[j]
        h = pow(2, p-2, p)
        if n >= 4:
            q22 = s.v6(P[2] * P[2]) * h % p
            c = c + s.M6[n - 4] @ q22
        if n >= 5: c = c + s.M6[n - 5] @ s.v6(P[2] * P[3])
        if n >= 6:
            c = c + s.M6[0] @ ((s.v6(P[2] * P[4]) + s.v6(P[3] * P[3]) * h) % p)
            c = c + s.S.periods(P[2] * P[2] * P[2] * pow(6, p-2, p), s.tab)
        return c % p
    def evaluate(s, k):
        """k: dict n -> vector in K-coordinates (len dimK) for n = 2..5.  Returns ob[2..6], T vectors"""
        p = s.p; T = {}; P = {}; ob = {}
        for n in range(2, 7):
            c = s.cprime(n, T, P)
            ob[n] = s.Kl @ c % p
            if n <= 5:
                T[n] = (s.K @ k[n] - s.X @ c) % p; P[n] = s.poly3(T[n])
        return ob, T
    def rk(s):
        return {n: s.rng.integers(0, s.p, size=s.K.shape[1]) for n in range(2, 6)}
    def direct(s, T, T6, N=6):
        """direct check from the definition: all 45 c_n, n=1..N, for T_1, T_2..T_5 (vectors), T6 vector"""
        Ts = [s.T1] + [s.poly3(T[n]) for n in range(2, 6)] + [s.poly3(T6)]
        E = s.S.expseries(Ts, N)
        return [int(np.count_nonzero(s.S.periods(E[n], s.tab))) for n in range(1, N+1)]
