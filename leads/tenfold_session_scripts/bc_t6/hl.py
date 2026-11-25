# BC-T6 independent implementation (blind check). Fermat cubic tenfold, periods of linear 5-planes mod p.
# Period functional (unnormalised), for plane  x_{2e} = w_e x_{2e+1}  (e=0..5):
#   phi(x^beta) = prod_e [ (b_{2e}%3, b_{2e+1}%3) in {(1,0),(0,1)} ] A(b_{2e}) A(b_{2e+1}) w_e^{(b_{2e+1}%3)+1}
#   A(a) = prod_{s=1}^{a//3} (a%3 + 1 + 3(s-1))       (Griffiths-Dwork reduction x_i^2 -> d/dx_i)
# Hodge-locus equations for F = F0 + G:  Phi(P * exp(-G/3)) = 0 for all cubic P (up to a nonzero constant
# 15*c_{n,d}; derived from Res(P Omega/F^5) expanded in G, pole-order factors folded into exp(-G/3)).
import numpy as np, itertools, sys

NV = 12
SH = 5
MASK = 31

class Field:
    def __init__(self, p):
        self.p = p
        # primitive 6th root
        for g in range(2, p):
            z = pow(g, (p - 1) // 6, p)
            if pow(z, 3, p) == p - 1 and pow(z, 2, p) != 1:
                break
        self.z = z
        self.zb = pow(z, 5, p)
        assert pow(z, 3, p) == p - 1
        self.inv3 = pow(3, p - 2, p)
    def inv(self, a):
        return pow(int(a) % self.p, self.p - 2, self.p)

def enc(beta):
    k = 0
    for i, b in enumerate(beta):
        k |= int(b) << (SH * i)
    return k

def dec_arr(keys):
    keys = np.asarray(keys, dtype=np.int64)
    out = np.empty((len(keys), NV), dtype=np.int64)
    for i in range(NV):
        out[:, i] = (keys >> (SH * i)) & MASK
    return out

class Poly:
    __slots__ = ("k", "c", "p")
    def __init__(self, p, k=None, c=None):
        self.p = p
        self.k = np.zeros(0, np.int64) if k is None else np.asarray(k, np.int64)
        self.c = np.zeros(0, np.int64) if c is None else np.asarray(c, np.int64) % p
    @staticmethod
    def mono(p, beta, c=1):
        return Poly(p, [enc(beta)], [c])
    @staticmethod
    def var(p, i, c=1):
        b = [0] * NV; b[i] = 1
        return Poly.mono(p, b, c)
    def copy(self):
        return Poly(self.p, self.k.copy(), self.c.copy())
    def norm(self):
        if len(self.k) == 0:
            return self
        o = np.argsort(self.k, kind="stable")
        k = self.k[o]; c = self.c[o]
        st = np.flatnonzero(np.r_[True, k[1:] != k[:-1]])
        cs = np.add.reduceat(c, st) % self.p
        k = k[st]
        nz = cs != 0
        self.k = k[nz]; self.c = cs[nz]
        return self
    def __add__(self, o):
        return Poly(self.p, np.r_[self.k, o.k], np.r_[self.c, o.c]).norm()
    def __sub__(self, o):
        return Poly(self.p, np.r_[self.k, o.k], np.r_[self.c, (-o.c) % self.p]).norm()
    def scale(self, s):
        return Poly(self.p, self.k.copy(), (self.c * (int(s) % self.p)) % self.p).norm()
    def __mul__(self, o):
        p = self.p
        if len(self.k) == 0 or len(o.k) == 0:
            return Poly(p)
        A, B = (self, o) if len(self.k) <= len(o.k) else (o, self)
        parts_k = []; parts_c = []
        chunk = max(1, 4_000_000 // len(B.k))
        acc = Poly(p)
        for s in range(0, len(A.k), chunk):
            kk = (A.k[s:s + chunk, None] + B.k[None, :]).ravel()
            cc = ((A.c[s:s + chunk, None] * B.c[None, :]) % p).ravel()
            parts_k.append(kk); parts_c.append(cc)
            if sum(len(x) for x in parts_k) > 20_000_000:
                acc = Poly(p, np.concatenate([acc.k] + parts_k), np.concatenate([acc.c] + parts_c)).norm()
                parts_k = []; parts_c = []
        return Poly(p, np.concatenate([acc.k] + parts_k), np.concatenate([acc.c] + parts_c)).norm()
    def __len__(self):
        return len(self.k)

def lin(p, coeffs):
    """linear form sum coeffs[i] x_i (dict i->c)"""
    ks = []; cs = []
    for i, c in coeffs.items():
        b = [0] * NV; b[i] = 1
        ks.append(enc(b)); cs.append(c)
    return Poly(p, ks, cs).norm()

def Atab(p, amax=40):
    A = np.zeros(amax + 1, np.int64)
    for a in range(amax + 1):
        r, q = a % 3, a // 3
        v = 1
        for s in range(1, q + 1):
            v = v * (r + 1 + 3 * (s - 1)) % p
        A[a] = v
    return A

def pair_tables(F, ws, amax=40, variant="X"):
    """ws: list of 6 roots w_e. returns list of 6 tables T[a,b] (a,b<=amax)."""
    p = F.p
    A = Atab(p, amax)
    T = []
    for w in ws:
        t = np.zeros((amax + 1, amax + 1), np.int64)
        for a in range(amax + 1):
            for b in range(amax + 1):
                ra, rb = a % 3, b % 3
                if (ra, rb) in ((1, 0), (0, 1)):
                    e = (rb + 1) if variant == "Y" else (ra + 1)
                    t[a, b] = A[a] * A[b] % p * pow(w, e, p) % p
        T.append(t)
    return T

def functional(E, tables_list, Plist, p):
    """returns array (len(Plist), len(tables_list)) : Phi_plane(P * E)."""
    out = np.zeros((len(Plist), len(tables_list)), np.int64)
    if len(E) == 0:
        return out
    ex = dec_arr(E.k)
    c = E.c
    for ip, P in enumerate(Plist):
        for it, T in enumerate(tables_list):
            v = c.copy()
            for e in range(6):
                a = ex[:, 2 * e] + P[2 * e]; b = ex[:, 2 * e + 1] + P[2 * e + 1]
                v = (v * T[e][a, b]) % p
                if not v.any():
                    break
            out[ip, it] = int(v.sum() % p)
    return out

def cubic_monos():
    return [b for b in itertools.product(range(4), repeat=NV) if sum(b) == 3] if False else \
        [tuple(np.bincount(c, minlength=NV)) for c in itertools.combinations_with_replacement(range(NV), 3)]

# ---------- linear algebra mod p ----------
def rref(M, p):
    M = np.array(M, dtype=np.int64) % p
    r = 0; piv = []
    rows, cols = M.shape
    for j in range(cols):
        if r >= rows: break
        nz = np.flatnonzero(M[r:, j])
        if len(nz) == 0: continue
        i = r + nz[0]
        if i != r: M[[r, i]] = M[[i, r]]
        inv = pow(int(M[r, j]), p - 2, p)
        M[r] = (M[r] * inv) % p
        f = M[:, j].copy(); f[r] = 0
        nzr = np.flatnonzero(f)
        if len(nzr):
            M[nzr] = (M[nzr] - (f[nzr, None] * M[r][None, :]) % p) % p
        piv.append(j); r += 1
    return M[:r], piv

def rank(M, p):
    return len(rref(M, p)[1])

def nullspace(M, p):
    """basis of {x : M x = 0} as rows"""
    R, piv = rref(M, p)
    cols = M.shape[1]
    free = [j for j in range(cols) if j not in set(piv)]
    N = np.zeros((len(free), cols), np.int64)
    for t, f in enumerate(free):
        N[t, f] = 1
        for i, pj in enumerate(piv):
            N[t, pj] = (-R[i, f]) % p
    return N

def solve(M, rhs, p):
    """one solution x of M x = rhs or None"""
    rows, cols = M.shape
    Aug = np.concatenate([np.array(M, np.int64) % p, (np.array(rhs, np.int64) % p)[:, None]], axis=1)
    R, piv = rref(Aug, p)
    if cols in piv:
        return None
    x = np.zeros(cols, np.int64)
    for i, pj in enumerate(piv):
        x[pj] = R[i, cols]
    return x

def mm(A, B, p):
    """overflow-safe (A @ B) mod p for int64 arrays with entries in [0,p), p < 2^31, inner dim < 2^15"""
    A = np.asarray(A, np.int64) % p; B = np.asarray(B, np.int64) % p
    lo = B & 65535; hi = B >> 16
    return ((A @ lo) % p + ((A @ hi) % p) * 65536) % p
