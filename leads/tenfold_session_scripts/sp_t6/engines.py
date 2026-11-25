# SP-T6 engine variants (all must give identical results):
#   py       : w3eng.W3Engine (reference, W3's code)
#   pyfilter : W3Engine + exact visibility filter on streamed (not stored) levels before H   [step 1]
#   fast     : compiled kernel fsc.cpp (OpenMP threads), optional visibility filter            [steps 2-3]
import numpy as np
from w3eng import W3Engine
from fe_big_copy import NV, SH
class FilterEngine(W3Engine):
    def __init__(self, p, lam, z=None):
        super().__init__(p, lam, z=z)
        from fsc import FastEngine
        self.vis = FastEngine.visible_table(self).astype(bool)
        self.nfilt = [0, 0]
    def rescode(self, keys):
        rc = np.zeros(len(keys), np.int64)
        for i in range(NV): rc += ((keys >> (SH * i)) & 31) % 3 * 3 ** i
        return rc
    def Eprime(self, n, Tp, Es, store=True):
        if store: return super().Eprime(n, Tp, Es, store)
        p = self.p; inv = pow(n, p - 2, p)
        terms = [(j * inv % p, Tp[j - 1], Es[n - j]) for j in range(1, n + 1) if j - 1 < len(Tp)]
        acc = np.zeros(len(self.keep_codes), dtype=np.int64); nt = 0
        for B, P in self.product_buckets(terms):
            m = self.vis[self.rescode(P[0])]
            nt += len(P[0]); self.nfilt[0] += len(P[0]); self.nfilt[1] += int(m.sum())
            acc = self.H_acc((P[0][m], P[1][m]), acc)
        return None, acc, nt
def make(kind, p, lam, z, threads=1, visfilter=False):
    if kind == 'py': return W3Engine(p, lam, z=z)
    if kind == 'pyfilter': return FilterEngine(p, lam, z=z)
    if kind == 'fast':
        from fsc import FastEngine
        return FastEngine(p, lam, z=z, nthreads=threads, visfilter=visfilter)
    raise ValueError(kind)
