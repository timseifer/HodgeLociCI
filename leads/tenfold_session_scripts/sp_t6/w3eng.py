# W3: memory-light MOD p engine for the Fermat cubic tenfold period expansion (fe.py / fe_big.py formulas, copied).
# Differences from fe_big.py: (1) H uses |s| <= 6 pruning (only codes needed by MH / cvec) and float-exact bincount,
#   valid for p < 2^26; (2) products T_j * E'_(m-j) are formed bucket by bucket (bucket = exponents of x9, x10, x11 =
#   top bits of the packed key), fully deduplicated inside each bucket, so E'_m never needs to be held unsorted/raw;
#   H(E'_m) can be accumulated bucket by bucket without storing E'_m.
import numpy as np, itertools, sys, time
sys.path.insert(0, '/home/claude/hodge/discovery/checks/w3')
from fe_big_copy import Engine as _Base, NV, PAIRS, SH, pack, unpack, bounded_exps

NTOP = 3                    # bucket variables: x9, x10, x11
BSHIFT = SH * (NV - NTOP)

class W3Engine(_Base):
    def __init__(self, p, lam, z=None):
        assert p < (1 << 26)
        # compact index of codes s in {0,1,2}^12 with |s| <= 6
        c = np.arange(3 ** NV)
        deg = np.zeros(3 ** NV, dtype=np.int64)
        for i in range(NV): deg += (c // 3 ** i) % 3
        self.keep_codes = np.nonzero(deg <= 6)[0]
        self.cmap = -np.ones(3 ** NV, dtype=np.int64); self.cmap[self.keep_codes] = np.arange(len(self.keep_codes))
        self.poch_big = None
        super().__init__(p, lam, z=z)

    def _poch(self):
        if self.poch_big is None:
            p = self.p; inv3 = pow(3, p - 2, p)
            pb = np.ones((2, 40), dtype=np.int64)
            for r in range(2):
                for m in range(1, 40):
                    pb[r, m] = pb[r, m - 1] * ((1 + r + 3 * (m - 1)) * inv3 % p) % p
            self.poch_big = pb
            tabv = {}
            for (r, val) in self.patterns:
                ch = tuple(1 if r[a] == 1 else 0 for (a, b) in PAIRS)
                tabv[ch] = val
            self.tabv = tabv
        return self.poch_big

    def H_acc(self, E, acc=None, chunk=1 << 20):
        """accumulate H_E on the compact codes (|s| <= 6) into acc (int64 mod p); returns acc"""
        p = self.p; pb = self._poch(); nk = len(self.keep_codes)
        if acc is None: acc = np.zeros(nk, dtype=np.int64)
        keys, vals = E
        for i0 in range(0, len(keys), chunk):
            e = unpack(keys[i0:i0 + chunk]); c = vals[i0:i0 + chunk] % p
            rho = e % 3
            opts = []
            for k, (a, b) in enumerate(PAIRS):
                o = []
                for (ra, rb) in ((0, 1), (1, 0)):
                    sa = (ra - rho[:, a]) % 3; sb = (rb - rho[:, b]) % 3
                    ma = (sa + e[:, a]) // 3; mb = (sb + e[:, b]) // 3
                    o.append((sa * 3 ** a + sb * 3 ** b, pb[ra, ma] * pb[rb, mb] % p, sa + sb))
                opts.append(o)
            def comb(op):
                res = []
                for ch in itertools.product([0, 1], repeat=3):
                    code = op[0][ch[0]][0] + op[1][ch[1]][0] + op[2][ch[2]][0]
                    w = op[0][ch[0]][1] * op[1][ch[1]][1] % p * op[2][ch[2]][1] % p
                    d = op[0][ch[0]][2] + op[1][ch[1]][2] + op[2][ch[2]][2]
                    res.append((ch, code, w, d))
                return res
            left = comb(opts[:3]); right = comb(opts[3:])
            for chL, codeL, wL, dL in left:
                mL = dL <= 6
                if not mL.any(): continue
                wLc = wL * c % p
                accf = np.zeros(nk)
                for chR, codeR, wR, dR in right:
                    t = self.tabv[chL + chR]
                    if t == 0: continue
                    m = mL & (dL + dR <= 6)
                    if not m.any(): continue
                    w = wLc[m] * wR[m] % p * t % p
                    accf += np.bincount(self.cmap[codeL[m] + codeR[m]], weights=w.astype(np.float64), minlength=nk)
                acc = (acc + np.fmod(accf, p).astype(np.int64)) % p
        return acc

    def H(self, E, chunk=1 << 20):
        acc = self.H_acc(E, None, chunk)
        out = np.zeros(3 ** NV, dtype=np.int64); out[self.keep_codes] = acc
        return out

    def MH_from_acc(self, acc):
        out = np.zeros(3 ** NV, dtype=np.int64); out[self.keep_codes] = acc
        return (self.consts[:, None] * out[self.qa_codes]) % self.p

    # ---------------- bucketed products
    @staticmethod
    def bucket_of(keys):
        return keys >> BSHIFT

    def split_small(self, T):
        """T small poly -> dict delta_bucket -> (keys_low, vals) with the delta bucket id (top-var exps of a)"""
        b = self.bucket_of(T[0]); out = {}
        for bb in np.unique(b):
            m = b == bb
            out[int(bb)] = (T[0][m], T[1][m])
        return out

    def bucket_index(self, E):
        # keys sorted: bucket boundaries by searchsorted over all candidate bucket ids (no large temporaries)
        cand = np.array(sorted(e9 | (e10 << SH) | (e11 << (2 * SH)) for e9 in range(14) for e10 in range(14) for e11 in range(14)), dtype=np.int64)
        st = np.searchsorted(E[0], cand << BSHIFT); en = np.searchsorted(E[0], (cand + 1) << BSHIFT)
        return {int(u): (int(s), int(e)) for u, s, e in zip(cand, st, en) if e > s}

    def product_buckets(self, terms, maxraw=8_000_000):
        """terms: list of (coef, T small poly, E big poly sorted).  Yields (bucket, poly) for sum coef*T*E, buckets in
        increasing order (so concatenation is sorted), each fully deduplicated."""
        p = self.p
        prep = []
        for coef, T, E in terms:
            if len(T[0]) == 0 or len(E[0]) == 0 or coef % p == 0: continue
            prep.append((coef % p, self.split_small(T), E, self.bucket_index(E)))
        targets = set()
        for coef, Ts, E, bi in prep:
            for d in Ts:
                for b in bi: targets.add(b + d)     # top-var exponents add (no carry: exps < 32)
        for B in sorted(targets):
            acc = None; parts_k = []; parts_v = []; nraw = 0
            for coef, Ts, E, bi in prep:
                for d, (tk, tv) in Ts.items():
                    src = B - d
                    if src not in bi: continue
                    s, e = bi[src]
                    ek = E[0][s:e]; ev = E[1][s:e]
                    tvc = tv * coef % p
                    step = max(1, maxraw // max(1, len(ek)))
                    for i in range(0, len(tk), step):
                        k = (ek[None, :] + tk[i:i + step, None]).ravel()
                        v = (ev[None, :] * tvc[i:i + step, None] % p).ravel()
                        parts_k.append(k); parts_v.append(v); nraw += len(k)
                        if nraw > maxraw:
                            if acc is not None: parts_k.append(acc[0]); parts_v.append(acc[1])
                            acc = self.normalize(np.concatenate(parts_k), np.concatenate(parts_v))
                            parts_k = []; parts_v = []; nraw = 0
            if parts_k:
                if acc is not None: parts_k.append(acc[0]); parts_v.append(acc[1])
                acc = self.normalize(np.concatenate(parts_k), np.concatenate(parts_v))
            if acc is not None and len(acc[0]): yield B, acc

    def Eprime(self, n, Tp, Es, store=True):
        """E'_n = (1/n) sum_{j=1}^n j T_j E'_(n-j) (T_n included if len(Tp) >= n).  Returns (poly or None, H-acc)."""
        p = self.p; inv = pow(n, p - 2, p)
        terms = [(j * inv % p, Tp[j - 1], Es[n - j]) for j in range(1, n + 1) if j - 1 < len(Tp)]
        acc = np.zeros(len(self.keep_codes), dtype=np.int64)
        ks = []; vs = []; nt = 0
        for B, P in self.product_buckets(terms):
            acc = self.H_acc(P, acc)
            nt += len(P[0])
            if store: ks.append(P[0]); vs.append(P[1].astype(np.int32))
        E = (np.concatenate(ks), np.concatenate(vs)) if store and ks else ((np.zeros(0, np.int64), np.zeros(0, np.int64)) if store else None)
        return E, acc, nt
