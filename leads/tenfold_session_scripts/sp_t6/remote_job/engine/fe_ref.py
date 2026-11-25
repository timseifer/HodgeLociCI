# RC-T6 copy of step (e)'s fe.py with exact accumulation in H (11-bit limbs) so that it is valid for p ~ 2^31.
# [TOOLING] T6e: fast numpy re-implementation of the Fermat period expansion of HodgeLociCI (Fermat.m2) for the
# cubic tenfold (d = 3, n = 10), MOD p.  Same conventions:
#   Psi_P(x^g) = prod_j ((1+r_j)/3)_(m_j) * coeff of x^((1,..,1) - r) in P,  g_j = 3 m_j + r_j, r_j <= 1
#   c_n[Q] = const_Q * Psi_P(Q * E_n),  E_n = [t^n] exp(sum t^j T_j) computed WITHOUT T_n (T_n enters through L).
# Forms Q: 1 (k = 4, const 120/3! = 20) and the 220 squarefree cubics (k = 5, const 120/4! = 5).
# Key device: H_E(s) = Psi_P(x^s E) for all s in {0,1,2}^12 at once (dense array over base-3 codes), so that
# c[T * E] = MH_E @ T with MH_E[q, a] = const_q H_E(q + a): all linearisations become matrix products.
import numpy as np, itertools, sys

NV = 12
PAIRS = [(0, 1), (2, 3), (4, 5), (6, 7), (8, 9), (10, 11)]
SH = 5  # bits per exponent in packed keys

def bounded_exps(m, deg, maxE):
    # decreasing lexicographic order, as fmBoundedExps
    if deg < 0 or deg > m * maxE: return []
    if m == 0: return [()]
    out = []
    for a in reversed(range(0, min(deg, maxE) + 1)):
        for e in bounded_exps(m - 1, deg - a, maxE):
            out.append((a,) + e)
    return out

def root6(p):
    for g in range(2, p):
        a = pow(g, (p - 1) // 6, p)
        if pow(a, 3, p) != 1 and pow(a, 2, p) != 1: return a
    raise ValueError

def pack(e):
    return sum(int(x) << (SH * i) for i, x in enumerate(e))

def unpack(keys):
    return np.stack([(keys >> (SH * i)) & 31 for i in range(NV)], axis=1)

POW3 = np.array([3 ** i for i in range(NV)], dtype=np.int64)

class Engine:
    def __init__(self, p, lam, z=None, L2exps=(1, 1, 1, 3, 3, 3)):
        self.p = p
        self.z = root6(p) if z is None else z
        self.lam = lam % p
        self.mons = bounded_exps(NV, 3, 1)
        self.fexps = [tuple([0] * NV)] + self.mons
        self.consts = np.array([20] + [5] * len(self.mons), dtype=np.int64)
        # pochhammer table
        self.poch = np.ones((2, 12), dtype=np.int64)
        inv3 = pow(3, p - 2, p)
        for r in range(2):
            for m in range(1, 12):
                self.poch[r, m] = self.poch[r, m - 1] * ((1 + r + 3 * (m - 1)) * inv3 % p) % p
        # table over the 64 residue patterns: per pair, which index carries residue 1
        z = self.z
        self.patterns = []
        for choice in itertools.product([0, 1], repeat=6):
            r = [0] * NV
            val1 = 1; val2 = 1
            for k, (a, b) in enumerate(PAIRS):
                # residue r = 1 - e; P pair factor 3c(x_a + c x_b): e_a = 1 -> coeff 3c, e_b = 1 -> 3c^2
                if choice[k] == 0:
                    r[a] = 0; r[b] = 1  # e_a = 1
                    c1 = z; c2 = pow(z, L2exps[k], p)
                    val1 = val1 * 3 * c1 % p; val2 = val2 * 3 * c2 % p
                else:
                    r[a] = 1; r[b] = 0  # e_b = 1
                    c1 = z; c2 = pow(z, L2exps[k], p)
                    val1 = val1 * 3 * c1 * c1 % p; val2 = val2 * 3 * c2 * c2 % p
            self.patterns.append((tuple(r), (val1 + self.lam * val2) % p))
        self.mon_keys = np.array([pack(e) for e in self.mons], dtype=np.int64)
        self.mon_codes = np.array([sum(e[i] * 3 ** i for i in range(NV)) for e in self.mons], dtype=np.int64)
        self.form_codes = np.array([sum(e[i] * 3 ** i for i in range(NV)) for e in self.fexps], dtype=np.int64)
        self.qa_codes = self.form_codes[:, None] + self.mon_codes[None, :]
        self.mon_index = {pack(e): i for i, e in enumerate(self.mons)}
        self.L = self.MH(self.poly_one())
        self.prepare_L()

    # ---------------- polynomials: (keys sorted unique int64, vals int64 mod p)
    def poly_one(self):
        return (np.array([0], dtype=np.int64), np.array([1], dtype=np.int64))

    def vec_to_poly(self, v):
        v = np.asarray(v, dtype=np.int64) % self.p
        nz = np.nonzero(v)[0]
        k = self.mon_keys[nz]; o = np.argsort(k)
        return (k[o], v[nz][o])

    def poly_to_vec(self, P):
        out = np.zeros(len(self.mons), dtype=np.int64)
        for k, c in zip(P[0], P[1]):
            out[self.mon_index[int(k)]] = c
        return out

    def normalize(self, keys, vals):
        if len(keys) == 0: return (keys, vals)
        o = np.argsort(keys, kind='stable')
        keys = keys[o]; vals = vals[o]
        idx = np.concatenate(([0], np.nonzero(np.diff(keys))[0] + 1))
        s = np.add.reduceat(vals, idx) % self.p
        k = keys[idx]
        nz = s != 0
        return (k[nz], s[nz])

    def add(self, *terms):
        # terms: (coef, poly)
        ks = []; vs = []
        for c, P in terms:
            if len(P[0]) == 0 or c % self.p == 0: continue
            ks.append(P[0]); vs.append(P[1] * (c % self.p) % self.p)
        if not ks: return (np.zeros(0, np.int64), np.zeros(0, np.int64))
        return self.normalize(np.concatenate(ks), np.concatenate(vs))

    def mul(self, A, B, chunk=20_000_000):
        if len(A[0]) < len(B[0]): A, B = B, A
        if len(B[0]) == 0: return B
        parts_k = []; parts_v = []
        step = max(1, chunk // len(A[0]))
        for i in range(0, len(B[0]), step):
            bk = B[0][i:i + step]; bv = B[1][i:i + step]
            k = (A[0][None, :] + bk[:, None]).ravel()
            v = (A[1][None, :] * bv[:, None] % self.p).ravel()
            parts_k.append(k); parts_v.append(v)
            if sum(len(x) for x in parts_k) > chunk:
                kk, vv = self.normalize(np.concatenate(parts_k), np.concatenate(parts_v))
                parts_k = [kk]; parts_v = [vv]
        return self.normalize(np.concatenate(parts_k), np.concatenate(parts_v))

    # ---------------- the functional
    def H(self, E, chunk=2_000_000):
        p = self.p
        out = np.zeros(3 ** NV, dtype=np.float64)
        out_i = np.zeros(3 ** NV, dtype=np.int64); acc = {sh: np.zeros(3 ** NV) for sh in (0, 11, 22)}
        keys, vals = E
        for i0 in range(0, len(keys), chunk):
            e = unpack(keys[i0:i0 + chunk]); c = vals[i0:i0 + chunk]
            rho = e % 3
            # per variable and residue choice r in {0,1}: s, poch factor
            S = [[None, None] for _ in range(NV)]
            Fp = [[None, None] for _ in range(NV)]
            for i in range(NV):
                for r in range(2):
                    s = (r - rho[:, i]) % 3
                    m = (s + e[:, i]) // 3
                    S[i][r] = s * (3 ** i)
                    Fp[i][r] = self.poch[r, m]
            # combine pairs: for each pair two options
            pair_opts = []
            for k, (a, b) in enumerate(PAIRS):
                o0 = (S[a][0] + S[b][1], Fp[a][0] * Fp[b][1] % p)  # choice 0: r_a = 0, r_b = 1
                o1 = (S[a][1] + S[b][0], Fp[a][1] * Fp[b][0] % p)
                pair_opts.append((o0, o1))
            # three pairs at a time to limit memory
            def combine(opts):
                res = []
                for ch in itertools.product([0, 1], repeat=len(opts)):
                    code = 0; w = 1
                    for k, cidx in enumerate(ch):
                        code = code + opts[k][cidx][0]
                        w = w * opts[k][cidx][1] % p
                    res.append((ch, code, w))
                return res
            left = combine(pair_opts[:3]); right = combine(pair_opts[3:])
            tabv = {}
            for (r, val) in self.patterns:
                ch = tuple(1 if r[a] == 1 else 0 for (a, b) in PAIRS)
                tabv[ch] = val
            for chL, codeL, wL in left:
                wLc = wL * c % p
                for chR, codeR, wR in right:
                    t = tabv[chL + chR]
                    if t == 0: continue
                    w = wLc * wR % p * t % p
                    for sh in (0, 11, 22):
                        limb = ((w >> sh) & 2047).astype(np.float64)
                        acc[sh] += np.bincount(codeL + codeR, weights=limb, minlength=3 ** NV)
                for sh in (0, 11, 22):
                    out_i[:] = (out_i + (np.mod(acc[sh], p).astype(np.int64) * pow(2, sh, p)) % p) % p
                    acc[sh][:] = 0
        return out_i

    def MH(self, E):
        h = self.H(E)
        return (self.consts[:, None] * h[self.qa_codes]) % self.p

    def cvec(self, E):
        h = self.H(E)
        return (self.consts * h[self.form_codes]) % self.p

    # ---------------- linear algebra mod p
    def rref(self, A):
        p = self.p
        A = np.array(A, dtype=np.int64) % p
        nr, nc = A.shape
        piv = []; r = 0
        for c in range(nc):
            if r == nr: break
            nzr = np.nonzero(A[r:, c])[0]
            if len(nzr) == 0: continue
            pr = r + nzr[0]
            if pr != r: A[[r, pr]] = A[[pr, r]]
            inv = pow(int(A[r, c]), p - 2, p)
            A[r] = A[r] * inv % p
            col = A[:, c].copy(); col[r] = 0
            nzc = np.nonzero(col)[0]
            if len(nzc):
                A[nzc] = (A[nzc] - col[nzc, None] * A[r][None, :]) % p
            piv.append(c); r += 1
        return A[:r], piv

    def rank(self, A):
        if A.shape[0] == 0 or A.shape[1] == 0: return 0
        return len(self.rref(A)[1])

    def kernel(self, A):
        p = self.p
        nc = A.shape[1]
        R, piv = self.rref(A)
        free = [c for c in range(nc) if c not in set(piv)]
        Kb = np.zeros((nc, len(free)), dtype=np.int64)
        for j, f in enumerate(free):
            Kb[f, j] = 1
            for i, c in enumerate(piv):
                Kb[c, j] = (-R[i, f]) % p
        return Kb

    def left_kernel(self, A):
        return self.kernel(A.T).T

    def prepare_L(self):
        self.Kl = self.left_kernel(self.L)          # rows: functionals on the 221 forms killing Im L
        R, piv = self.rref(np.concatenate([self.L, np.eye(self.L.shape[0], dtype=np.int64)], axis=1))
        self.Lpiv = piv
        self.Lrank = self.rank(self.L)
        self.kerL = self.kernel(self.L)

    def solveL(self, c):
        # particular solution x of L x = -c (c must lie in Im L)
        p = self.p
        A = np.concatenate([self.L, ((-np.asarray(c)) % p)[:, None]], axis=1)
        R, piv = self.rref(A)
        nc = self.L.shape[1]
        if piv and piv[-1] == nc: raise ValueError("not in image of L")
        x = np.zeros(nc, dtype=np.int64)
        for i, c_ in enumerate(piv): x[c_] = R[i, nc]
        return x

    def solveL_matrix(self):
        # matrix A with L (A c) = -c for all c in Im L: via a fixed pivot choice
        p = self.p
        if hasattr(self, '_SL'): return self._SL
        m, nc = self.L.shape
        A = np.concatenate([self.L, np.eye(m, dtype=np.int64)], axis=1)
        R, piv = self.rref(A)
        pv = [c for c in piv if c < nc]
        # rows i < len(pv): x_{pv[i]} = (R[i, nc:] @ b) for L x = b with b in Im L
        X = np.zeros((nc, m), dtype=np.int64)
        for i, c in enumerate(pv): X[c] = R[i, nc:]
        self._SL = (-X) % p
        return self._SL

    def in_span(self, A, b):
        return self.rank(np.concatenate([A, b[:, None]], axis=1)) == self.rank(A)

    def solve(self, A, b):
        p = self.p
        nc = A.shape[1]
        R, piv = self.rref(np.concatenate([A, (np.asarray(b) % p)[:, None]], axis=1))
        if piv and piv[-1] == nc: return None
        x = np.zeros(nc, dtype=np.int64)
        for i, c in enumerate(piv): x[c] = R[i, nc]
        return x

    # ---------------- arcs
    def series(self, Ts, N, keepE=True):
        """Ts: list of slice vectors T_1..; returns list of c_n (n = 1..N) computed without T_n, and E'_m polys
        (full, including T_m) for m = 0..N-1 and their MH matrices."""
        p = self.p
        Tp = [self.vec_to_poly(T) for T in Ts]
        E = [self.poly_one()]
        MHs = [self.L]
        cs = []
        for n in range(1, N + 1):
            # c_n = (1/n) sum_{j=1}^{n-1} j MH_{n-j} T_j
            inv = pow(n, p - 2, p)
            c = np.zeros(self.L.shape[0], dtype=np.int64)
            for j in range(1, n):
                if j - 1 < len(Ts):
                    c = (c + j * (MHs[n - j] @ (np.asarray(Ts[j - 1]) % p) % p)) % p
            c = c * inv % p
            cs.append(c)
            if n == N: break
            # E'_n full = (1/n) sum_{j=1}^{n} j T_j E'_{n-j}
            terms = []
            for j in range(1, n + 1):
                if j - 1 < len(Tp):
                    terms.append((j * inv, self.mul(Tp[j - 1], E[n - j])))
            En = self.add(*terms)
            E.append(En)
            MHs.append(self.MH(En))
        return cs, E, MHs

    def Kpart(self, c):
        return self.Kl @ (np.asarray(c) % self.p) % self.p
