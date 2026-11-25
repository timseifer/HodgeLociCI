# [TS-T6] (AI-generated, unreviewed): Thom-Sebastiani engine = W3Engine/FastEngine interface with the period functional
# Psi(x^g) = Psi_A(g_x) * (w1 Psi_B^Q1 + w2 Psi_B^Q2)(g_y), compiled kernel tsk.cpp (product code = fsc.cpp).
import os, sys, ctypes, subprocess, itertools, numpy as np
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE); from enginedir import ENGINE_DIR; sys.path.insert(0, ENGINE_DIR)
from w3eng import W3Engine
from fe_ref import NV, PAIRS, unpack
SO = os.path.join(os.environ.get('TSK_SO_DIR', HERE), 'libtsk.so')

def build(force=False):
    src = os.path.join(HERE, 'tsk.cpp')
    if force or not os.path.exists(SO) or os.path.getmtime(SO) < os.path.getmtime(src):
        subprocess.check_call([os.environ.get('CXX', 'g++'), '-O3', '-march=native', '-fopenmp', '-shared', '-fPIC', '-o', SO, src])
    lib = ctypes.CDLL(SO)
    P = ctypes.c_void_p
    lib.tsk_level.restype = ctypes.c_int64
    lib.tsk_level.argtypes = [P, P, P, ctypes.c_int, ctypes.c_int, P, P, P, P, P, P, P, P, ctypes.c_int64, P, P, P, ctypes.c_int, P,
                              ctypes.c_int, ctypes.c_int, P, P, P]
    lib.tsk_H.argtypes = [P, P, P, ctypes.c_int, ctypes.c_int64, P, P, ctypes.c_int64, P, P, P, ctypes.c_int, P, P]
    lib.tsk_fetch.argtypes = [P, P]
    lib.tsk_err.restype = ctypes.c_int
    return lib
def ptr(a): return a.ctypes.data_as(ctypes.c_void_p)

class TSEngine(W3Engine):
    """PB1, PB2: Psi_B tables (index OFF[D] + rank) for Q1, Q2; weights (w1, w2) (default (1, lam))."""
    def __init__(self, p, lam, z, PB1, PB2, OFF, Dmax, weights=None, nthreads=1):
        self.lib = build(); self.nthreads = nthreads
        w1, w2 = weights if weights is not None else (1, lam)
        self.PB = np.ascontiguousarray((w1 * PB1 + w2 * PB2) % p, dtype=np.int64)
        self.OFFa = np.ascontiguousarray(OFF, dtype=np.int64); self.Dmax = int(Dmax)
        self.aval = np.zeros(8, np.int64)
        for h in range(8):
            v = 1
            for k in range(3): v = v * (3 * z * z if (h >> k) & 1 else 3 * z) % p
            self.aval[h] = v
        self.p = p
        self._tables_ready = False
        super().__init__(p, lam, z=z)

    def _prep(self):
        if not self._tables_ready:
            self._poch(); self.pb_flat = np.ascontiguousarray(self.poch_big.reshape(-1).astype(np.int64))
            self.tab = np.zeros(64, np.int64); self.cmap64 = np.ascontiguousarray(self.cmap.astype(np.int64))
            self.nk = len(self.keep_codes); self._tables_ready = True

    def H_acc(self, E, acc=None, chunk=None):
        self._prep(); p = self.p
        keys = np.ascontiguousarray(E[0], dtype=np.int64); vals = np.ascontiguousarray(E[1], dtype=np.int64) % p
        out = np.zeros(self.nk, np.int64)
        self.lib.tsk_H(ptr(self.aval), ptr(self.PB), ptr(self.OFFa), self.Dmax, len(keys), ptr(keys), ptr(vals), p,
                       ptr(self.pb_flat), ptr(self.tab), ptr(self.cmap64), self.nk, None, ptr(out))
        if self.lib.tsk_err(): raise ValueError('B-degree beyond Dmax')
        if acc is not None: out = (out + acc) % p
        return out

    def Eprime(self, n, Tp, Es, store=True):
        self._prep(); p = self.p; inv = pow(n, p - 2, p)
        terms = [(j * inv % p, Tp[j - 1], Es[n - j]) for j in range(1, n + 1) if j - 1 < len(Tp)]
        terms = [t for t in terms if len(t[1][0]) and len(t[2][0]) and t[0] % p]
        nt = len(terms)
        coef = np.array([t[0] for t in terms], np.int64)
        tk = np.ascontiguousarray(np.concatenate([t[1][0] for t in terms]).astype(np.int64)) if nt else np.zeros(1, np.int64)
        tv = np.ascontiguousarray(np.concatenate([t[1][1] for t in terms]).astype(np.int64) % p) if nt else np.zeros(1, np.int64)
        toff = np.cumsum([0] + [len(t[1][0]) for t in terms]).astype(np.int64)
        eks = []; evs = []; is64 = []; elen = []
        for t in terms:
            k = np.ascontiguousarray(t[2][0], dtype=np.int64); v = t[2][1]
            if v.dtype == np.int32: v = np.ascontiguousarray(v); is64.append(0)
            else: v = np.ascontiguousarray(v, dtype=np.int64); is64.append(1)
            eks.append(k); evs.append(v); elen.append(len(k))
        ekp = (ctypes.c_void_p * max(1, nt))(*[k.ctypes.data for k in eks])
        evp = (ctypes.c_void_p * max(1, nt))(*[v.ctypes.data for v in evs])
        is64 = np.array(is64 + [0], np.int32); elen = np.array(elen + [0], np.int64)
        okeys = ctypes.c_void_p(); ovals = ctypes.c_void_p()
        acc = np.zeros(self.nk, np.int64)
        ntot = self.lib.tsk_level(ptr(self.aval), ptr(self.PB), ptr(self.OFFa), self.Dmax,
                                  nt, ptr(coef), ptr(tk), ptr(tv), ptr(toff), ctypes.cast(ekp, ctypes.c_void_p),
                                  ctypes.cast(evp, ctypes.c_void_p), ptr(is64), ptr(elen), p, ptr(self.pb_flat),
                                  ptr(self.tab), ptr(self.cmap64), self.nk, None, 1 if store else 0, self.nthreads,
                                  ctypes.byref(okeys), ctypes.byref(ovals), ptr(acc))
        if ntot < 0: raise ValueError('p must be < 2^26')
        if self.lib.tsk_err(): raise ValueError('B-degree beyond Dmax')
        E = None
        if store:
            K = np.empty(ntot, np.int64); V = np.empty(ntot, np.int32)
            self.lib.tsk_fetch(ptr(K), ptr(V))
            if ntot == 0: V = np.zeros(0, np.int64)
            E = (K, V)
        return E, acc, int(ntot)

    # numpy reference of H (small polys only), independent of the kernel
    def H_ref(self, E):
        p = self.p; self._poch(); pb = self.poch_big
        from psib import rank_within
        keys, vals = E; e = unpack(np.asarray(keys, np.int64)); c = np.asarray(vals, np.int64) % p
        codes = self.keep_codes; S = np.stack([(codes // 3 ** i) % 3 for i in range(NV)], 1)
        out = np.zeros(len(codes), np.int64)
        for t in range(len(keys)):
            g = S + e[t][None, :]
            gx = g[:, :6]; gy = g[:, 6:]
            r = gx % 3; m = gx // 3
            ok = (r <= 1).all(1)
            wa = np.ones(len(codes), np.int64)
            for j in range(6): wa = wa * pb[np.minimum(r[:, j], 1), m[:, j]] % p
            hbits = np.zeros(len(codes), np.int64)
            for k in range(3):
                ra, rb = r[:, 2 * k], r[:, 2 * k + 1]
                ok &= (ra + rb == 1)
                hbits += (ra == 1).astype(np.int64) << k
            Dy = gy.sum(1); ok &= (Dy % 3 == 0)
            idx = np.where(ok, self.OFFa[np.minimum(Dy, self.Dmax)] + rank_within(np.where(ok[:, None], gy, 0)), 0)
            val = np.where(ok, wa * self.aval[hbits] % p * self.PB[idx] % p, 0)
            out = (out + val * c[t]) % p
        return out
