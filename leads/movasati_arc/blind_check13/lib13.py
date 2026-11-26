#!/usr/bin/env python3
"""Blind check 13 -- own library (python-flint nmod_mpoly + numpy), no package code.
Period functional of a linear space L = {x_a = z^e x_b} in the Fermat cubic 8-fold (or 10-fold), up to ONE
overall constant (same derivation as blind_check12/c1_own.py, adapted from sixfold to m = 10 or 12 variables
and from QQ(z) to ZZ/p):
   lam_L(x^r), r in {0,1}^m, is non-zero iff r contains exactly one index of each pair {a,b}, and then equals
   prod_{pairs with a in r} z^e  (times a constant c_L).
   Relative constant c_P2/c_P1: P2 = g(P1) with g: x_(2i+1) -> w^-1 x_(2i+1) (i<3), w = z^2; so
   lam_P2(x^r) = w^(-(r_1+r_3+r_5)) lam_P1(x^r)   (g^* acts on the residue forms, g^*Omega = Omega).
   Pole-order (Griffiths-Dwork) reduction at Fermat: x_j^(3q+r) -> prod_{s=1..q} (3s+r-2)/3 * x_j^r, zero if r = 2.
   Periods along F0 - S(eps), S = sum eps^n T_n:   c_n[Q] = Lam(Q * E_n),  E_n = [eps^n] exp(S)
   (constant factors depending only on the pole order are dropped: all Q here have the same degree).
"""
import sys, re, time, itertools
import numpy as np
from flint import nmod_mpoly_ctx, nmod, nmod_mat, Ordering

REPO = "/home/claude/hodgelocici"
ARCDIR = REPO + "/leads/movasati_arc/arcs/"

def root6(p):
    """first g^((p-1)/6), g = 2,3,.., that is a primitive 6th root of unity (how one would naturally pick it)."""
    for g in range(2, p):
        a = pow(g, (p - 1) // 6, p)
        if pow(a, 3, p) != 1 and pow(a, 2, p) != 1:
            return a
    raise ValueError

def read_arc(fn):
    lines = [l.strip() for l in open(ARCDIR + fn) if l.strip()]
    assert lines[0].startswith("#")
    idx = eval(lines[1].replace("{", "[").replace("}", "]"))
    D = eval(lines[2].replace("{", "[").replace("}", "]"))
    return lines[0], idx, D, lines[3:]

class Setup:
    def __init__(self, p, m=10, z=None):
        self.p = p; self.m = m
        self.z = root6(p) if z is None else z
        assert (self.z * self.z - self.z + 1) % p == 0
        self.ctx = nmod_mpoly_ctx.get(["x_%d" % i for i in range(m)], p, Ordering.degrevlex) \
            if hasattr(nmod_mpoly_ctx, "get") else None
        self.gens = self.ctx.gens()
        # Pochhammer-type weights c(g) = prod_{s=1..q} (3s + r - 2)/3,  g = 3q + r ; zero if r = 2
        inv3 = pow(3, p - 2, p)
        self.cw = np.zeros(64, dtype=np.int64)
        for g in range(64):
            q, r = divmod(g, 3)
            if r == 2: continue
            v = 1
            for s in range(1, q + 1):
                v = v * (3 * s + r - 2) % p * inv3 % p
            self.cw[g] = v
    def parse(self, s):
        """polynomial string with integer coefficients -> nmod_mpoly"""
        ctx = self.ctx; p = self.p
        d = {}
        s = s.replace(" ", "").replace("-", "+-")
        for t in s.split("+"):
            if not t: continue
            fs = t.split("*")
            c = 1; e = [0] * self.m
            for f in fs:
                if f.startswith("-x_"):
                    c = -c; f = f[1:]
                if f.startswith("x_"):
                    if "^" in f:
                        a, b = f.split("^"); e[int(a[2:])] += int(b)
                    else:
                        e[int(f[2:])] += 1
                else:
                    c *= int(f)
            k = tuple(e)
            d[k] = (d.get(k, 0) + c) % p
        return ctx.from_dict({k: v for k, v in d.items() if v})
    def table(self, pairs, lam_list):
        """pairs: list over spaces of lists (a, b, e); returns dict r(tuple) -> value, for sum_i lam_i * lam_{L_i}.
        Normalisation: lam_L(x^r) = prod_{pairs with a in r} z^e  and the relative constants from automorphisms
        are supplied by the caller through lam_list (they multiply)."""
        p = self.p; z = self.z; tab = {}
        for L, lam in zip(pairs, lam_list):
            for choice in itertools.product((0, 1), repeat=len(L)):
                r = [0] * self.m; e = 0
                for (a, b, ex), ch in zip(L, choice):
                    if ch == 0:
                        r[a] = 1; e += ex
                    else:
                        r[b] = 1
                k = tuple(r)
                tab[k] = (tab.get(k, 0) + lam * pow(z, e, p)) % p
        return {k: v for k, v in tab.items() if v}
    def expseries(self, Ts, N):
        """E_0..E_N with E_n = [eps^n] exp(sum eps^j T_j):  n E_n = sum_j j T_j E_(n-j)"""
        p = self.p
        E = [self.ctx.from_dict({(0,) * self.m: 1})]
        for n in range(1, N + 1):
            acc = self.ctx.from_dict({})
            for j in range(1, min(n, len(Ts)) + 1):
                if Ts[j - 1] != 0:
                    acc = acc + (Ts[j - 1] * E[n - j]) * j
            E.append(acc * pow(n, p - 2, p))
        return E
    def arrays(self, f):
        """exponent array (n x m, int64) and coefficient array of an nmod_mpoly"""
        mon = f.monoms(); co = f.coeffs()
        if len(mon) == 0:
            return np.zeros((0, self.m), dtype=np.int64), np.zeros(0, dtype=np.int64)
        return np.array(mon, dtype=np.int64), np.array([int(c) for c in co], dtype=np.int64)
    def response(self, f, tab, deg, arrs=None):
        """R[beta] = Lam(x^beta * f) for all exponent vectors beta of degree `deg` with entries in {0,1,2}.
        Own logic: for every pattern r of the table and every term x^g of f the only beta with (g+beta) = r mod 3
        is beta = (r - g) mod 3; keep it if it has the right degree; weight prod_j c(g_j + beta_j)."""
        p = self.p; m = self.m; cw = self.cw
        ex, co = self.arrays(f) if arrs is None else arrs
        out = {}
        if len(co) == 0: return out
        pw = 3 ** np.arange(m, dtype=np.int64)
        for r, tv in tab.items():
            rv = np.array(r, dtype=np.int64)
            beta = (rv[None, :] - ex) % 3
            sel = beta.sum(axis=1) == deg
            if not sel.any(): continue
            b = beta[sel]; g = ex[sel] + b; w = co[sel].copy()
            for j in range(m):
                w = w * cw[g[:, j]] % p
            w = w * tv % p
            code = b @ pw
            u, inv = np.unique(code, return_inverse=True)
            acc = np.zeros(len(u), dtype=np.int64)
            np.add.at(acc, inv, w)
            acc %= p
            for cu, v in zip(u.tolist(), acc.tolist()):
                if v:
                    bt = tuple((cu // 3 ** j) % 3 for j in range(m))
                    out[bt] = (out.get(bt, 0) + v) % p
        return {k: v for k, v in out.items() if v}
    def periods(self, f, tab, forms, arrs=None):
        """vector Lam(Q f) over the forms Q (exponent tuples, all of the same degree)"""
        R = self.response(f, tab, sum(forms[0]), arrs)
        return [R.get(q, 0) for q in forms]

def sqfree_monos(m, deg):
    return [tuple(1 if i in c else 0 for i in range(m)) for c in itertools.combinations(range(m), deg)]

def rank_mod(M, p):
    """rank of a list-of-lists / numpy integer matrix mod p (flint nmod_mat)"""
    M = [[int(v) % p for v in row] for row in M]
    if len(M) == 0 or len(M[0]) == 0: return 0
    return nmod_mat(len(M), len(M[0]), [v for row in M for v in row], p).rank()

# ------------------------------------------------------------------ linear algebra mod p (numpy, own code)
def rref(M, p):
    """reduced row echelon form mod p; returns (R, pivots)"""
    M = np.array(M, dtype=np.int64) % p
    if M.ndim != 2: raise ValueError
    nr, nc = M.shape
    piv = []; r = 0
    for c in range(nc):
        if r == nr: break
        nz = np.flatnonzero(M[r:, c])
        if len(nz) == 0: continue
        pr = r + int(nz[0])
        if pr != r: M[[r, pr]] = M[[pr, r]]
        M[r] = M[r] * pow(int(M[r, c]), p - 2, p) % p
        col = M[:, c].copy(); col[r] = 0
        idx = np.flatnonzero(col)
        if len(idx):
            M[idx] = (M[idx] - np.outer(col[idx], M[r])) % p
        piv.append(c); r += 1
    return M[:r], piv

def rank(M, p):
    M = np.array(M, dtype=np.int64)
    if M.size == 0: return 0
    return len(rref(M, p)[1])

def nullspace(M, p):
    """basis of {x : M x = 0} as the columns of a matrix (nc x nullity)"""
    M = np.array(M, dtype=np.int64) % p
    nr, nc = M.shape
    R, piv = rref(M, p)
    free = [c for c in range(nc) if c not in set(piv)]
    N = np.zeros((nc, len(free)), dtype=np.int64)
    for a, c in enumerate(free):
        N[c, a] = 1
        for i, pc in enumerate(piv):
            N[pc, a] = (-R[i, c]) % p
    return N

def solve(M, b, p):
    """one solution x of M x = b, or None"""
    M = np.array(M, dtype=np.int64) % p; b = np.array(b, dtype=np.int64).reshape(-1, 1) % p
    nr, nc = M.shape
    R, piv = rref(np.hstack([M, b]), p)
    if len(piv) and piv[-1] == nc: return None
    x = np.zeros(nc, dtype=np.int64)
    for i, pc in enumerate(piv): x[pc] = R[i, nc]
    return x

def mmul(A, B, p):
    """matrix product mod p without overflow (entries < 2^15, so chunks of columns are safe)"""
    A = np.array(A, dtype=np.int64) % p; B = np.array(B, dtype=np.int64) % p
    return (A @ B) % p if A.shape[-1] < 2 ** 30 else None

def vec_of(S, f, index):
    """coefficient vector of an nmod_mpoly on a list of monomials given by index: tuple -> position"""
    v = np.zeros(len(index), dtype=np.int64)
    for mon, c in zip(f.monoms(), f.coeffs()):
        v[index[tuple(mon)]] = int(c)
    return v

def poly_of(S, v, mons):
    return S.ctx.from_dict({mons[i]: int(v[i]) % S.p for i in range(len(mons)) if int(v[i]) % S.p})

# ------------------------------------------------------------------ faster batched functional (own code)
def _digits(m):
    codes = np.arange(3 ** m, dtype=np.int64)
    return np.stack([(codes // 3 ** j) % 3 for j in range(m)], axis=1)

def grouped_periods(S, ex, co, grp, ngroups, tab, forms, cache={}):
    """out[g, i] = sum over the rows t with grp[t] = g of co[t] * Lam(forms[i] * x^ex[t]);  forms: exponent tuples
    with entries in {0,1,2}, all of the same degree."""
    p = S.p; m = S.m; cw = S.cw; deg = sum(forms[0]); nf = len(forms)
    pw = 3 ** np.arange(m, dtype=np.int64)
    key = (id(tab), deg, tuple(forms[0]), nf, m)
    if key not in cache:
        dig = _digits(m)
        valid = np.zeros(3 ** m, dtype=bool)
        for r in tab:
            valid |= (((np.array(r, dtype=np.int64)[None, :] - dig) % 3).sum(axis=1) == deg)
        fidx = np.full(3 ** m, -1, dtype=np.int64)
        for i, q in enumerate(forms):
            fidx[int(np.array(q, dtype=np.int64) @ pw)] = i
        cache[key] = (valid, fidx)
    valid, fidx = cache[key]
    out = np.zeros(ngroups * nf, dtype=np.int64)
    if len(co) == 0: return out.reshape(ngroups, nf)
    code = (ex % 3) @ pw
    keep = valid[code]
    ex = ex[keep]; co = co[keep]; grp = grp[keep]
    if len(co) == 0: return out.reshape(ngroups, nf)
    for r, tv in tab.items():
        beta = (np.array(r, dtype=np.int64)[None, :] - ex) % 3
        sel = beta.sum(axis=1) == deg
        if not sel.any(): continue
        b = beta[sel]
        fi = fidx[b @ pw]
        ok = fi >= 0
        if not ok.any(): continue
        b = b[ok]; fi = fi[ok]
        g = ex[sel][ok] + b; w = co[sel][ok].copy()
        for j in range(m):
            w = w * cw[g[:, j]] % p
        w = w * tv % p
        np.add.at(out, grp[sel][ok] * nf + fi, w)
        out %= p
    return out.reshape(ngroups, nf)

def fast_arrays(S, f):
    n = len(f)
    if n == 0:
        return np.zeros((0, S.m), dtype=np.int64), np.zeros(0, dtype=np.int64)
    ex = np.fromiter(itertools.chain.from_iterable(f.monoms()), dtype=np.int64, count=n * S.m).reshape(n, S.m)
    co = np.fromiter((int(c) for c in f.coeffs()), dtype=np.int64, count=n)
    return ex, co

def fast_periods(S, f, tab, forms):
    ex, co = fast_arrays(S, f)
    return grouped_periods(S, ex, co, np.zeros(len(co), dtype=np.int64), 1, tab, forms)[0]

def bounded_monos(m, deg, maxe):
    if m == 0: return [()] if deg == 0 else []
    out = []
    for a in range(min(deg, maxe), -1, -1):
        for e in bounded_monos(m - 1, deg - a, maxe): out.append((a,) + e)
    return out

def mult_matrix(S, E, gammas, tab, forms, chunk=400):
    """M[i, g] = Lam(forms[i] * x^gammas[g] * E)   (len(forms) x len(gammas))"""
    ex, co = fast_arrays(S, E)
    G = np.array(gammas, dtype=np.int64)
    out = np.zeros((len(gammas), len(forms)), dtype=np.int64)
    n = len(co)
    for s in range(0, len(gammas), chunk):
        gg = G[s:s + chunk]; k = len(gg)
        exx = (gg[:, None, :] + ex[None, :, :]).reshape(k * n, S.m)
        coo = np.tile(co, k); grp = np.repeat(np.arange(k, dtype=np.int64), n)
        out[s:s + k] = grouped_periods(S, exx, coo, grp, k, tab, forms)
    return out.T.copy()
