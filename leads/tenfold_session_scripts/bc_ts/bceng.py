# [BC-TS] (AI-generated, unreviewed) blind checker engine at the split point: own polynomials (bck.cpp), own H, own MH,
# own linear algebra. Functional Psi(x^a y^b) = PsiA_Fermat(a) * (PsiB^Q1(b) + lam PsiB^Q2(b)) (Thom-Sebastiani product),
# c[Q] = const_Q Psi(Q E), forms Q = 1 (const 20) and the 220 squarefree cubics (const 5); MH_E[q, a] = const_q H_E(q + a).
import ctypes, os, subprocess, itertools, numpy as np
from math import comb
from bcla import rref, rank, kernel, solve, mm
HERE = os.path.dirname(os.path.abspath(__file__))
SO = os.path.join(HERE, 'libbck.so')
if not os.path.exists(SO) or os.path.getmtime(SO) < os.path.getmtime(os.path.join(HERE, 'bck.cpp')):
    subprocess.check_call(['g++', '-O3', '-march=native', '-shared', '-fPIC', '-o', SO, os.path.join(HERE, 'bck.cpp')])
lib = ctypes.CDLL(SO)
P64 = ctypes.POINTER(ctypes.c_int64)
lib.ht_new.restype = ctypes.c_void_p; lib.ht_new.argtypes = [ctypes.c_uint64]
lib.ht_free.argtypes = [ctypes.c_void_p]
lib.ht_count.restype = ctypes.c_int64; lib.ht_count.argtypes = [ctypes.c_void_p]
lib.ht_mul_acc.restype = ctypes.c_int; lib.ht_mul_acc.argtypes = [ctypes.c_void_p, P64, P64, ctypes.c_int64, P64, P64, ctypes.c_int64, ctypes.c_int64, ctypes.c_int64]
lib.ht_extract.restype = ctypes.c_int64; lib.ht_extract.argtypes = [ctypes.c_void_p, P64, P64]
lib.Hsplit.restype = ctypes.c_int; lib.Hsplit.argtypes = [P64, P64, ctypes.c_int64, P64, P64, ctypes.c_int, P64, ctypes.c_int64, ctypes.c_int64, ctypes.c_int64, P64]
def ptr(a): return a.ctypes.data_as(P64)

NV = 12
def key(e): return sum(int(x) << (5 * (11 - i)) for i, x in enumerate(e))
def code(e): return sum(int(x) * 3 ** i for i, x in enumerate(e))

def slice_mons():
    # the 220 squarefree cubics, decreasing lexicographic order (same order as the project's slice, needed for the geometry)
    out = [e for e in itertools.product([1, 0], repeat=NV) if sum(e) == 3]
    return out

class BCEngine:
    def __init__(self, p, lam, z, tabs1, tabs2, Dmax, weights=None):
        self.p = p; self.lam = lam % p; self.z = z; self.Dmax = Dmax
        w1, w2 = (1, self.lam) if weights is None else weights
        self.OFF = np.array([comb(d + 5, 6) for d in range(Dmax + 2)], np.int64)
        PB = np.zeros(self.OFF[-1], np.int64)
        for d in range(Dmax + 1):
            t1 = tabs1.get(d); t2 = tabs2.get(d)
            if t1 is None: continue
            PB[self.OFF[d]:self.OFF[d + 1]] = (w1 * t1 + w2 * t2) % p
        self.PB = PB
        inv3 = pow(3, p - 2, p); PT = np.ones((2, 40), np.int64)
        for r in range(2):
            for m in range(1, 40): PT[r, m] = PT[r, m - 1] * ((1 + r + 3 * (m - 1)) * inv3 % p) % p
        self.PT = PT.ravel().copy()
        self.cA0 = 3 * z % p; self.cA1 = 3 * z * z % p
        self.mons = slice_mons()
        self.mon_keys = np.array([key(e) for e in self.mons], np.int64)
        self.fexps = [tuple([0] * NV)] + self.mons
        self.consts = np.array([20] + [5] * 220, np.int64)
        fc = np.array([code(e) for e in self.fexps], np.int64); mc = np.array([code(e) for e in self.mons], np.int64)
        self.qa = fc[:, None] + mc[None, :]
        self.L = self.MH(self.one())
        self.kerL = kernel(self.L, p)
        self.Kl = kernel(self.L.T, p).T              # rows: functionals killing Im L
        self.Lrank = rank(self.L, p)
        # SL: L (SL c) = -c for c in Im L
        m, nc = self.L.shape
        R, piv = rref(np.concatenate([self.L, np.eye(m, dtype=np.int64)], 1), p)
        X = np.zeros((nc, m), np.int64)
        for i, c in enumerate(piv):
            if c < nc: X[c] = R[i, nc:]
        self.SL = (-X) % p

    def one(self): return (np.array([0], np.int64), np.array([1], np.int64))
    def vec_to_poly(self, v):
        v = np.asarray(v, np.int64) % self.p; nz = np.flatnonzero(v)
        k = self.mon_keys[nz]; o = np.argsort(k); return (k[o], v[nz][o])

    def H(self, E):
        k, v = E
        k = np.ascontiguousarray(k, np.int64); v = np.ascontiguousarray(v, np.int64)
        out = np.zeros(3 ** NV, np.int64)
        r = lib.Hsplit(ptr(k), ptr(v), len(k), ptr(self.PB), ptr(self.OFF), self.Dmax, ptr(self.PT), self.cA0, self.cA1, self.p, ptr(out))
        assert r == 0, r
        return out

    def MH(self, E):
        h = self.H(E); return self.consts[:, None] * h[self.qa] % self.p

    def lincomb_products(self, terms, deg):
        """sum c * T * E for terms (c, Tpoly, Epoly); deg = degree of the result"""
        cap = 2 * comb(deg + 11, 11) + 16
        ht = lib.ht_new(cap)
        try:
            for c, T, E in terms:
                tk = np.ascontiguousarray(T[0]); tv = np.ascontiguousarray(T[1]); ek = np.ascontiguousarray(E[0]); ev = np.ascontiguousarray(E[1])
                r = lib.ht_mul_acc(ht, ptr(tk), ptr(tv), len(tk), ptr(ek), ptr(ev), len(ek), c % self.p, self.p); assert r == 0
            n = lib.ht_count(ht); K = np.zeros(n, np.int64); V = np.zeros(n, np.int64)
            m = lib.ht_extract(ht, ptr(K), ptr(V))
        finally:
            lib.ht_free(ht)
        K = K[:m]; V = V[:m]; o = np.argsort(K); return (K[o], V[o])

    def Eprime(self, m, Tp, Es):
        """E'_m = (1/m) sum_{j=1}^m j T_j E'_{m-j}"""
        p = self.p; inv = pow(m, p - 2, p)
        terms = [(j * inv % p, Tp[j - 1], Es[m - j]) for j in range(1, m + 1) if j - 1 < len(Tp)]
        return self.lincomb_products(terms, 3 * m)
