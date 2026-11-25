# BC-T6 arc engine: Hodge locus equations along F0 + sum t^j F_j, mod p.
import sys, numpy as np, itertools, time
sys.path.insert(0, '/home/claude/hodge/discovery/checks/bc_t6')
from hl import *

class Setup:
    def __init__(self, p, lam, S, zprime="zb"):
        self.p = p; self.F = Field(p); self.lam = lam % p
        z, zb = self.F.z, self.F.zb
        z2 = zb if zprime == "zb" else (p - 1)
        self.W1 = [z] * 6; self.W2 = [z, z, z, z2, z2, z2]
        self.T1 = pair_tables(self.F, self.W1); self.T2 = pair_tables(self.F, self.W2)
        self.S = sorted(S)
        # slice W : squarefree cubic monomials in the variables S
        self.Wmon = []
        for c in itertools.combinations(self.S, 3):
            b = [0] * NV
            for i in c: b[i] = 1
            self.Wmon.append(tuple(b))
        # equation monomials P
        absent = [e for e in range(6) if 2 * e not in S and 2 * e + 1 not in S]
        rest = 3 - len(absent)
        choices = []
        for e in absent:
            choices.append([2 * e] if e < 3 else [2 * e, 2 * e + 1])
        qs = list(itertools.combinations_with_replacement(self.S, rest))
        self.P = []
        for ch in itertools.product(*choices):
            for q in qs:
                b = [0] * NV
                for i in list(ch) + list(q): b[i] += 1
                self.P.append(tuple(b))
        self.absent = absent
    def x(self, i): return Poly.var(self.p, i)
    def u(self, e): return lin(self.p, {2 * e: 1, 2 * e + 1: -self.F.z})
    def v(self, e): return lin(self.p, {2 * e: 1, 2 * e + 1: -(self.W2[e])})
    def phi(self, E):
        """vector over self.P of Phi_delta(P*E)"""
        f = functional(E, [self.T1, self.T2], self.P, self.p)
        return (f[:, 0] + self.lam * f[:, 1]) % self.p
    def phi2(self, E):
        return functional(E, [self.T1, self.T2], self.P, self.p)
    def proj_W(self, poly):
        """drop non-squarefree monomials (component along J) and check support in S"""
        ex = dec_arr(poly.k)
        keep = (ex.max(axis=1) <= 1)
        return Poly(self.p, poly.k[keep], poly.c[keep])
    def Wvec(self, poly):
        idx = {enc(b): i for i, b in enumerate(self.Wmon)}
        v = np.zeros(len(self.Wmon), np.int64)
        for k, c in zip(poly.k, poly.c):
            v[idx[int(k)]] = c
        return v
    def Wpoly(self, vec):
        nz = np.flatnonzero(vec % self.p)
        return Poly(self.p, [enc(self.Wmon[i]) for i in nz], vec[nz])
    def Mmat(self, Es):
        """matrix [P, w] of Phi_delta(P * w * Es)  (Es a poly)"""
        cols = []
        for b in self.Wmon:
            cols.append(self.phi(Poly.mono(self.p, b) * Es))
        return np.array(cols, np.int64).T % self.p

def expE(Fs, p, nmax):
    """E_n = [t^n] exp(-G/3), G = sum_{j>=1} t^j Fs[j-1]; returns list E_0..E_nmax"""
    inv3 = pow(3, p - 2, p)
    E = [Poly.mono(p, [0] * NV)]
    for n in range(1, nmax + 1):
        acc = Poly(p)
        for i in range(1, n + 1):
            if i - 1 < len(Fs) and len(Fs[i - 1]) and len(E[n - i]):
                acc = acc + (Fs[i - 1] * E[n - i]).scale(i)
        E.append(acc.scale((-inv3 * pow(n, p - 2, p)) % p))
    return E
