# EX-T6: EXACT engine over Q(z), z^2 - z + 1 = 0 (z primitive 6th root of unity), for the Fermat cubic tenfold with
# Movasati's pair (fe.py conventions: P1 = z on all pairs, P2 = z on pairs 0-2 and z^3 = -1 on pairs 3-5).
# Same formulas as fe.py (T6e), but exact: coefficients are pairs (A, B) of flint.fmpq meaning A + B z.
# Linear algebra: Q(z)^n realified as Q^(2n) = [A; B]; a Q(z)-matrix M0 + M1 z acts as [[M0, -M1], [M1, M0 + M1]].
import numpy as np, itertools, sys
from flint import fmpq, fmpq_mat, fmpz

NV = 12
PAIRS = [(0, 1), (2, 3), (4, 5), (6, 7), (8, 9), (10, 11)]
SH = 5
Q0 = fmpq(0)
# z^k = ZP[k % 6] = (a, b) meaning a + b z
ZP = [(1, 0), (0, 1), (-1, 1), (-1, 0), (0, -1), (1, -1)]

def zmul(a, b):
    """(a0 + a1 z)(b0 + b1 z) for scalars or numpy object arrays"""
    return (a[0] * b[0] - a[1] * b[1], a[0] * b[1] + a[1] * b[0] + a[1] * b[1])

def bounded_exps(m, deg, maxE):
    if deg < 0 or deg > m * maxE: return []
    if m == 0: return [()]
    out = []
    for a in reversed(range(0, min(deg, maxE) + 1)):
        for e in bounded_exps(m - 1, deg - a, maxE):
            out.append((a,) + e)
    return out

def pack(e):
    return sum(int(x) << (SH * i) for i, x in enumerate(e))

def unpack(keys):
    return np.stack([(keys >> (SH * i)) & 31 for i in range(NV)], axis=1)

def objzeros(n):
    a = np.empty(n, dtype=object); a[:] = [Q0] * n; return a

def toobj(intarr):
    return np.array([fmpq(int(x)) for x in np.asarray(intarr).ravel()], dtype=object).reshape(np.shape(intarr))

# ---------------- realified matrices
def real_mat(M0, M1):
    """M0, M1: lists of lists (or object arrays) of fmpq, shape r x c -> fmpq_mat 2r x 2c"""
    M0 = np.asarray(M0, dtype=object); M1 = np.asarray(M1, dtype=object)
    r, c = M0.shape
    top = np.concatenate([M0, -M1], 1); bot = np.concatenate([M1, M0 + M1], 1)
    full = np.concatenate([top, bot], 0)
    return fmpq_mat(2 * r, 2 * c, [fmpq(x) for x in full.ravel()])

def mat_to_np(M):
    return np.array(M.entries(), dtype=object).reshape(M.nrows(), M.ncols())

def np_to_mat(a):
    a = np.asarray(a, dtype=object)
    if a.ndim == 1: a = a[:, None]
    return fmpq_mat(a.shape[0], a.shape[1], [fmpq(x) for x in a.ravel()])

def rref_piv(M):
    R, r = M.rref()
    Rn = mat_to_np(R)
    piv = []
    for i in range(r):
        nz = np.flatnonzero([x != 0 for x in Rn[i]])
        piv.append(int(nz[0]))
    return Rn[:r], piv

def kernel(M):
    """basis of {x : M x = 0} as columns (fmpq_mat)"""
    nc = M.ncols()
    R, piv = rref_piv(M)
    ps = set(piv)
    free = [c for c in range(nc) if c not in ps]
    K = objzeros(nc * len(free)).reshape(nc, len(free))
    for j, f in enumerate(free):
        K[f, j] = fmpq(1)
        for i, c in enumerate(piv):
            K[c, j] = -R[i, f]
    return np_to_mat(K) if len(free) else fmpq_mat(nc, 0)

def solve_part(M, b):
    """particular solution of M x = b (free variables 0) or None"""
    nc = M.ncols()
    A = np_to_mat(np.concatenate([mat_to_np(M), mat_to_np(b)], 1))
    R, piv = rref_piv(A)
    if piv and piv[-1] == nc: return None
    x = objzeros(nc)
    for i, c in enumerate(piv): x[c] = R[i, nc]
    return np_to_mat(x)

def hcat(*Ms):
    return np_to_mat(np.concatenate([mat_to_np(M) for M in Ms], 1))

def rank(M):
    return M.rank()

def iszero(M):
    return all(x == 0 for x in M.entries())

def nnz(M):
    return sum(1 for x in M.entries() if x != 0)

class ExactEngine:
    def __init__(self, lam, L2exps=(1, 1, 1, 3, 3, 3)):
        self.lam = fmpq(lam)
        self.mons = bounded_exps(NV, 3, 1)
        self.nm = len(self.mons)
        self.fexps = [tuple([0] * NV)] + self.mons
        self.consts = [20] + [5] * self.nm
        self.poch = [[1] * 12 for _ in range(2)]   # integer numerators: prod_{k<m} (1 + r + 3k); value = that / 3^m
        for r in range(2):
            for m in range(1, 12):
                self.poch[r][m] = self.poch[r][m - 1] * (1 + r + 3 * (m - 1))
        self.poch_np = np.array(self.poch, dtype=np.int64)
        # pattern values (Z[z]): choice per pair 0 (e_a = 1: coeff 3c) / 1 (e_b = 1: coeff 3c^2), c1 = z, c2 = z^L2exps
        self.tab = {}
        for ch in itertools.product([0, 1], repeat=6):
            e1 = 0; e2 = 0
            for k in range(6):
                e1 += 1 if ch[k] == 0 else 2
                e2 += L2exps[k] if ch[k] == 0 else 2 * L2exps[k]
            a1, b1 = ZP[e1 % 6]; a2, b2 = ZP[e2 % 6]
            self.tab[ch] = (729 * (fmpq(a1) + self.lam * a2), 729 * (fmpq(b1) + self.lam * b2))
        self.mon_keys = np.array([pack(e) for e in self.mons], dtype=np.int64)
        self.mon_codes = np.array([sum(e[i] * 3 ** i for i in range(NV)) for e in self.mons], dtype=np.int64)
        self.form_codes = np.array([sum(e[i] * 3 ** i for i in range(NV)) for e in self.fexps], dtype=np.int64)
        self.qa_codes = self.form_codes[:, None] + self.mon_codes[None, :]
        self.mon_index = {pack(e): i for i, e in enumerate(self.mons)}
        self.code_deg = np.zeros(3 ** NV, dtype=np.int64)
        c = np.arange(3 ** NV)
        for i in range(NV):
            self.code_deg += (c // 3 ** i) % 3

    # ---------------- polynomials: (keys int64 sorted unique, A obj, B obj)
    def poly_one(self):
        return (np.array([0], dtype=np.int64), np.array([fmpq(1)], dtype=object), np.array([Q0], dtype=object))

    def vec_to_poly(self, vR):
        """vR: realified fmpq_mat (2*nm x 1) -> poly"""
        e = vR.entries(); A = e[:self.nm]; B = e[self.nm:]
        idx = [i for i in range(self.nm) if A[i] != 0 or B[i] != 0]
        k = self.mon_keys[idx]; o = np.argsort(k)
        Aa = np.array([A[i] for i in idx], dtype=object)[o]; Bb = np.array([B[i] for i in idx], dtype=object)[o]
        return (k[o], Aa, Bb)

    def normalize(self, keys, A, B):
        if len(keys) == 0: return (keys, A, B)
        o = np.argsort(keys, kind='stable')
        keys = keys[o]; A = A[o]; B = B[o]
        idx = np.concatenate(([0], np.nonzero(np.diff(keys))[0] + 1))
        sA = np.add.reduceat(A, idx); sB = np.add.reduceat(B, idx)
        k = keys[idx]
        nz = np.array([(a != 0) or (b != 0) for a, b in zip(sA, sB)], dtype=bool)
        return (k[nz], sA[nz], sB[nz])

    def add(self, *terms):
        ks = []; As = []; Bs = []
        for c, P in terms:
            if len(P[0]) == 0: continue
            c = fmpq(c)
            ks.append(P[0]); As.append(P[1] * c); Bs.append(P[2] * c)
        if not ks: return (np.zeros(0, np.int64), np.zeros(0, object), np.zeros(0, object))
        return self.normalize(np.concatenate(ks), np.concatenate(As), np.concatenate(Bs))

    def mul(self, P, Q, chunk=600_000):
        if len(P[0]) < len(Q[0]): P, Q = Q, P
        if len(Q[0]) == 0: return Q
        acc = None
        step = max(1, chunk // len(P[0]))
        for i in range(0, len(Q[0]), step):
            qk = Q[0][i:i + step]; qa = Q[1][i:i + step]; qb = Q[2][i:i + step]
            k = (P[0][None, :] + qk[:, None]).ravel()
            Aa = (P[1][None, :] * qa[:, None]).ravel(); Ab = (P[1][None, :] * qb[:, None]).ravel()
            Ba = (P[2][None, :] * qa[:, None]).ravel(); Bb = (P[2][None, :] * qb[:, None]).ravel()
            A = Aa - Bb; B = Ab + Ba + Bb
            part = self.normalize(k, A, B)
            if acc is None: acc = part
            else: acc = self.normalize(np.concatenate([acc[0], part[0]]), np.concatenate([acc[1], part[1]]), np.concatenate([acc[2], part[2]]))
        return acc

    # ---------------- the functional: H_E(s) = Psi(x^s E) for codes s with |s| <= maxdeg, as (A, B) object arrays
    def H(self, E, maxdeg=6, chunk=20000):
        keys, CA, CB = E
        outA = objzeros(3 ** NV); outB = objzeros(3 ** NV)
        if len(keys) == 0: return outA, outB, None
        degE = 0   # per-term degrees differ (E'_n is not homogeneous): coefficients are pre-scaled by 3^(-|e|/3)
        for i0 in range(0, len(keys), chunk):
            e = unpack(keys[i0:i0 + chunk]); ca = CA[i0:i0 + chunk]; cb = CB[i0:i0 + chunk]
            de = e.sum(1)
            assert (de % 3 == 0).all()
            sc = np.array([fmpq(1, 3 ** int(d // 3)) for d in de], dtype=object)
            ca = ca * sc; cb = cb * sc
            rho = e % 3
            S = [[None, None] for _ in range(NV)]; Fp = [[None, None] for _ in range(NV)]; D = [[None, None] for _ in range(NV)]
            for i in range(NV):
                for r in range(2):
                    s = (r - rho[:, i]) % 3
                    m = (s + e[:, i]) // 3
                    S[i][r] = s * (3 ** i); D[i][r] = s
                    Fp[i][r] = self.poch_np[r, m]
            allk = []; allA = []; allB = []
            for ch in itertools.product([0, 1], repeat=6):
                code = np.zeros(len(ca), dtype=np.int64); w = np.ones(len(ca), dtype=np.int64); dg = np.zeros(len(ca), dtype=np.int64)
                for k, (a, b) in enumerate(PAIRS):
                    if ch[k] == 0: ra, rb = 0, 1
                    else: ra, rb = 1, 0
                    code += S[a][ra] + S[b][rb]; dg += D[a][ra] + D[b][rb]
                    w = w * Fp[a][ra] * Fp[b][rb]
                mask = dg <= maxdeg
                if not mask.any(): continue
                ta, tb = self.tab[ch]
                wo = w[mask].astype(object)
                A0 = ca[mask] * wo; B0 = cb[mask] * wo
                A, B = zmul((A0, B0), (ta, tb))
                allk.append(code[mask]); allA.append(A); allB.append(B)
            if not allk: continue
            k, A, B = self.normalize(np.concatenate(allk), np.concatenate(allA), np.concatenate(allB))
            outA[k] = outA[k] + A; outB[k] = outB[k] + B
        return outA, outB, degE

    def Hval(self, Hres, codes):
        """values at codes (array), divided by 3^((|s| + degE - 6)/3)"""
        outA, outB, degE = Hres
        codes = np.asarray(codes)
        A = outA[codes.ravel()].copy(); B = outB[codes.ravel()].copy()
        if degE is None: return A.reshape(codes.shape), B.reshape(codes.shape)
        dg = self.code_deg[codes.ravel()]
        for i in range(len(A)):
            t = int(dg[i]) + degE - 6
            if A[i] == 0 and B[i] == 0: continue
            assert t % 3 == 0
            d = fmpq(3) ** (t // 3) if t >= 0 else fmpq(1, 3 ** (-t // 3))
            A[i] = A[i] / d; B[i] = B[i] / d
        return A.reshape(codes.shape), B.reshape(codes.shape)

    def MH(self, E):
        """realified fmpq_mat (2*221 x 2*220): c[T * E] = MH @ T"""
        Hres = self.H(E)
        A, B = self.Hval(Hres, self.qa_codes)
        cst = np.array([fmpq(c) for c in self.consts], dtype=object)[:, None]
        return real_mat(A * cst, B * cst)

    def cvec(self, E):
        Hres = self.H(E)
        A, B = self.Hval(Hres, self.form_codes)
        cst = np.array([fmpq(c) for c in self.consts], dtype=object)
        return np_to_mat(np.concatenate([A * cst, B * cst]))

    def setup_L(self):
        self.L = self.MH(self.poly_one())
        n2 = self.L.ncols(); m2 = self.L.nrows()
        self.kerL = kernel(self.L)                       # 440 x 364 expected
        self.K = kernel(self.L.transpose()).transpose()   # rows: Q-functionals on realified c killing Im L
        # SL: L (SL c) = -c for c in Im L, via rref of [L | I]
        aug = hcat(self.L, fmpq_mat(m2, m2, [fmpq(1) if i == j else Q0 for i in range(m2) for j in range(m2)]))
        R, piv = rref_piv(aug)
        X = objzeros(n2 * m2).reshape(n2, m2)
        for i, c in enumerate(piv):
            if c < n2: X[c] = -R[i, n2:]
        self.SL = np_to_mat(X)
        self.Lrank = len([c for c in piv if c < n2])

# ---------------- reduction mod p
def red(x, p):
    x = fmpq(x)
    assert int(x.q) % p != 0, "denominator divisible by p"
    return int(x.p % p) * pow(int(x.q % p), p - 2, p) % p

def red_real_vec(vR, p, zp):
    """realified Q(z) vector (fmpq_mat 2n x 1 or list) -> numpy int vector mod p at z = zp"""
    e = vR.entries() if hasattr(vR, 'entries') else list(vR)
    n = len(e) // 2
    return np.array([(red(e[i], p) + red(e[n + i], p) * zp) % p for i in range(n)], dtype=np.int64)

def red_real_mat(MR, p, zp):
    """realified matrix [[M0, -M1], [M1, M0 + M1]] -> M0 + M1 z mod p (uses left half columns)"""
    a = mat_to_np(MR); r = a.shape[0] // 2; c = a.shape[1] // 2
    out = np.zeros((r, c), dtype=np.int64)
    for i in range(r):
        for j in range(c):
            out[i, j] = (red(a[i, j], p) + red(a[r + i, j], p) * zp) % p
    return out
