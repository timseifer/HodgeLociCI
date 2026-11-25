# SP-T6 [TOOLING]: ctypes wrapper for fsc.cpp; FastEngine = W3Engine with Eprime replaced by the compiled kernel.
# Same inputs/outputs as w3eng.W3Engine.Eprime (E'_n sorted unique keys, int32 values; H accumulator mod p).
import os, ctypes, subprocess, itertools, numpy as np
from w3eng import W3Engine
from fe_big_copy import NV, PAIRS
HERE = os.path.dirname(os.path.abspath(__file__))
SO = os.path.join(HERE, 'libfsc.so')
def build(force=False):
    src = os.path.join(HERE, 'fsc.cpp')
    if force or not os.path.exists(SO) or os.path.getmtime(SO) < os.path.getmtime(src):
        subprocess.check_call(['g++', '-O3', '-march=native', '-fopenmp', '-shared', '-fPIC', '-o', SO, src])
    lib = ctypes.CDLL(SO)
    P = ctypes.c_void_p
    lib.fsc_level.restype = ctypes.c_int64
    lib.fsc_level.argtypes = [ctypes.c_int, P, P, P, P, P, P, P, P, ctypes.c_int64, P, P, P, ctypes.c_int, P,
                              ctypes.c_int, ctypes.c_int, P, P, P]
    lib.fsc_H.argtypes = [ctypes.c_int64, P, P, ctypes.c_int64, P, P, P, ctypes.c_int, P, P]
    lib.fsc_free.argtypes = [P]
    lib.fsc_fetch.argtypes = [P, P]
    return lib
def ptr(a): return a.ctypes.data_as(ctypes.c_void_p)

class FastEngine(W3Engine):
    def __init__(self, p, lam, z=None, nthreads=1, visfilter=False):
        super().__init__(p, lam, z=z)
        self.lib = build(); self.nthreads = nthreads; self.visfilter = visfilter
        self._poch()
        self.pb_flat = np.ascontiguousarray(self.poch_big.reshape(-1).astype(np.int64))
        tab = np.zeros(64, np.int64)
        for ch, v in self.tabv.items():
            tab[sum(b << k for k, b in enumerate(ch))] = v % p
        self.tab = tab
        self.cmap64 = np.ascontiguousarray(self.cmap.astype(np.int64))
        self.nk = len(self.keep_codes)
        self.vis = self.visible_table()

    def visible_table(self):
        """vis[residue code of e] = 1 iff x^e can contribute to some entry of MH (= some code s = q + a, q in
        {1} u squarefree cubics, a squarefree cubic, with (e + s) of a residue pattern r whose table value t_r != 0)."""
        qa = np.zeros(3 ** NV, bool); qa[self.qa_codes.ravel()] = True
        rc = np.arange(3 ** NV); rho = np.stack([(rc // 3 ** i) % 3 for i in range(NV)], 1)
        vis = np.zeros(3 ** NV, bool)
        for ch in itertools.product([0, 1], repeat=6):
            if self.tabv[ch] == 0: continue
            code = np.zeros(3 ** NV, np.int64)
            for k, (a, b) in enumerate(PAIRS):
                ra, rb = (1, 0) if ch[k] else (0, 1)
                code += ((ra - rho[:, a]) % 3) * 3 ** a + ((rb - rho[:, b]) % 3) * 3 ** b
            vis |= qa[code]
        return np.ascontiguousarray(vis.astype(np.uint8))

    def Eprime(self, n, Tp, Es, store=True):
        p = self.p; inv = pow(n, p - 2, p)
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
        vis = ptr(self.vis) if (self.visfilter and not store) else None
        ntot = self.lib.fsc_level(nt, ptr(coef), ptr(tk), ptr(tv), ptr(toff), ctypes.cast(ekp, ctypes.c_void_p),
                                  ctypes.cast(evp, ctypes.c_void_p), ptr(is64), ptr(elen), p, ptr(self.pb_flat),
                                  ptr(self.tab), ptr(self.cmap64), self.nk, vis, 1 if store else 0, self.nthreads,
                                  ctypes.byref(okeys), ctypes.byref(ovals), ptr(acc))
        if ntot < 0: raise ValueError('fsc_level: p must be < 2^26')
        E = None
        if store:
            K = np.empty(ntot, np.int64); V = np.empty(ntot, np.int32)
            self.lib.fsc_fetch(ptr(K), ptr(V))
            if ntot == 0: V = np.zeros(0, np.int64)
            E = (K, V)
        return E, acc, int(ntot)
