#!/usr/bin/env python3
"""Blind check 14: own period-functional code, MOD p (python-flint nmod_mpoly + numpy).
Psi_P(x^h) = prod_j ((1+r_j)/3)_(m_j) * coeff of x^(1-r) in P,  h_j = 3 m_j + r_j, zero if some r_j = 2.
P_L = prod_j 3 c_j (x_a + c_j x_b), c_j = z^e_j   (identity matching -> sign +1).
c_n[Q] = Psi_P(Q E_n),  E_n = [eps^n] exp(sum eps^j T_j)."""
import re, sys, time, itertools
import numpy as np
from flint import nmod_mpoly_ctx, nmod, Ordering
ARC = "/home/claude/hodgelocici/leads/movasati_arc/arcs/"
M = 10
class Ctx:
    def __init__(s, p, z):
        s.p, s.z = p, z
        assert (z*z - z + 1) % p == 0
        s.ctx = nmod_mpoly_ctx.get(["x_%d" % i for i in range(M)], p, Ordering.degrevlex)
        s.x = s.ctx.gens()
        W = np.zeros(80, dtype=np.int64)
        for g in range(80):
            q, r = divmod(g, 3)
            if r == 2: continue
            v = 1; a = (1 + r) * pow(3, p-2, p) % p
            for t in range(q): v = v * (a + t) % p
            W[g] = v
        s.W = W
        s.Q = [tuple(1 if i in c else 0 for i in range(M)) for c in itertools.combinations(range(M), 2)]
    def parse(s, line):
        p = s.p
        t = re.sub(r"(?<![_\d])(\d+)", r"N(\1)", line).replace("^", "**")
        env = {"N": lambda n: nmod(n, p), "z": nmod(s.z, p)}
        for i in range(M): env["x_%d" % i] = s.x[i]
        return s.ctx.from_dict({}) + eval(t, env)
    def Pspace(s, L):
        f = s.ctx.from_dict({(0,)*M: 1})
        for a, b, e in L:
            c = pow(s.z, e, s.p)
            f = f * (s.x[a] + s.x[b] * c) * (3 * c % s.p)
        return f
    def ptable(s, P):
        """table over codes of subsets: coefficient of x^S in P (S squarefree)"""
        tab = np.zeros(2**M, dtype=np.int64)
        for mon, c in zip(P.monoms(), P.coeffs()):
            assert max(mon) <= 1
            tab[sum(1 << j for j in range(M) if mon[j])] = int(c)
        return tab
    def expseries(s, Ts, N):
        p = s.p; E = [s.ctx.from_dict({(0,)*M: 1})]
        for n in range(1, N+1):
            acc = s.ctx.from_dict({})
            for j in range(1, min(n, len(Ts)) + 1):
                if Ts[j-1] != 0: acc = acc + Ts[j-1] * E[n-j] * j
            E.append(acc * pow(n, p-2, p))
        return E
    def periods(s, f, tab, forms=None):
        forms = s.Q if forms is None else forms
        p = s.p; n = len(f)
        if n == 0: return np.zeros(len(forms), dtype=np.int64)
        ex = np.fromiter(itertools.chain.from_iterable(f.monoms()), dtype=np.int64, count=n*M).reshape(n, M)
        co = np.fromiter((int(c) for c in f.coeffs()), dtype=np.int64, count=n)
        out = np.zeros(len(forms), dtype=np.int64)
        pw2 = 1 << np.arange(M, dtype=np.int64)
        for i, q in enumerate(forms):
            h = ex + np.array(q, dtype=np.int64)[None, :]
            r = h % 3
            ok = (r != 2).all(axis=1)
            if not ok.any(): continue
            hh = h[ok]; w = co[ok].copy()
            for j in range(M): w = w * s.W[hh[:, j]] % p
            code = ((1 - r[ok]) * pw2).sum(axis=1)
            w = w * tab[code] % p
            out[i] = int(w.sum() % p)
        return out
def read_lines(fn):
    ls = [l.strip() for l in open(ARC + fn) if l.strip()]
    return ls[3:]
L1 = [(2*i, 2*i+1, 1) for i in range(5)]
L2 = [(2*i, 2*i+1, 3 if i < 3 else 1) for i in range(5)]
