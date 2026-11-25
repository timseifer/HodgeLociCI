# [TS-T6] (AI-generated, unreviewed). Exponential period functionals Psi_B^Q of planes Q in a smooth cubic fourfold
# Y = V(G) in P^5 (variables y0..y5 = x6..x11 of the tenfold), MOD p, on all monomials of degree 0, 3, ..., Dmax.
#   normalisation: exponential periods, Psi(g * dG/dy_i) = Psi(dg/dy_i)  (integration by parts; this is exactly what
#   the Fermat closed form of fe_ref.py satisfies, pair by pair).
#   degree 0: Psi(1) = 0 (Q algebraic).
#   degree 3: Carlson-Griffiths: Psi(P) = kappa * phi(P * det Jac(f, g)), G = sum f_i g_i, phi = socle functional on
#             S_6 (vanishes on J_6) normalised by phi(Hess G) = 1; kappa universal (calibrated at Fermat).
#   degree 6: IBP on J_6 (from degree 3) + Psi = 0 on (I_Q^2)_6 (characterisation as SO-T6's I_V^2 rule; validated
#             against the Fermat closed form and by the I_Q^3 test at degree 9).
#   degree >= 9: IBP: every degree-7 monomial mu = sum_i c^mu_i dG/dy_i; y^beta = y^gamma mu gives
#             Psi(y^beta) = sum_i Psi(d/dy_i (y^gamma c^mu_i)).
# Monomial order inside a degree: ascending packed key sum e_j << (5 j) (e5 most significant); global index = OFF[D] + rank.
import numpy as np, itertools
from math import comb

NB = 6

def mons(d):
    out = []
    def rec(j, r, cur):
        if j == 0:
            out.append(tuple([r] + cur[::-1][::-1]) if False else None)
    # simple generation then sort by key
    res = []
    for e in itertools.product(range(d + 1), repeat=NB - 1):
        s = sum(e)
        if s <= d: res.append((d - s,) + e)
    res.sort(key=lambda e: sum(x << (5 * j) for j, x in enumerate(e)))
    return res

CB = np.array([[comb(n, k) for k in range(8)] for n in range(80)], dtype=np.int64)

def rank_within(E):
    """E: (n, 6) int array of exponents, all of the same or different degrees; rank inside its degree (key order)."""
    E = np.asarray(E, np.int64)
    R = E.sum(1)
    r = np.zeros(len(E), np.int64)
    for j in range(NB - 1, 0, -1):
        e = E[:, j]
        r += CB[R + j, j] - CB[R - e + j, j]
        R = R - e
    return r

class Tables:
    def __init__(self, Dmax):
        self.Dmax = Dmax
        self.M = {d: mons(d) for d in range(Dmax + 1)}
        self.OFF = np.zeros(Dmax + 2, np.int64)
        for d in range(Dmax + 1): self.OFF[d + 1] = self.OFF[d] + len(self.M[d])
        self.A = {d: np.array(self.M[d], np.int64).reshape(-1, NB) for d in range(Dmax + 1)}
        for d in (0, 1, 2, 3, 5, 6, 7):
            if d <= Dmax: assert (rank_within(self.A[d]) == np.arange(len(self.M[d]))).all()
        self.idx = {d: {e: i for i, e in enumerate(self.M[d])} for d in range(min(Dmax, 9) + 1)}

# ---------------- small polynomials as dicts {exp tuple: coef mod p}
def padd(a, b, p, cb=1):
    r = dict(a)
    for e, c in b.items():
        r[e] = (r.get(e, 0) + cb * c) % p
    return {e: c for e, c in r.items() if c}
def pmul(a, b, p):
    r = {}
    for e1, c1 in a.items():
        for e2, c2 in b.items():
            e = tuple(x + y for x, y in zip(e1, e2)); r[e] = (r.get(e, 0) + c1 * c2) % p
    return {e: c for e, c in r.items() if c}
def pdiff(a, i, p):
    r = {}
    for e, c in a.items():
        if e[i]:
            f = list(e); f[i] -= 1; f = tuple(f); r[f] = (r.get(f, 0) + c * e[i]) % p
    return {e: c for e, c in r.items() if c}
def lin(coefs):
    return {tuple(1 if k == j else 0 for k in range(NB)): int(c) for j, c in enumerate(coefs) if int(c)}
def pdet(Mx, p):
    """determinant of a square matrix of dict polys (permutation expansion)"""
    n = len(Mx); tot = {}
    for perm in itertools.permutations(range(n)):
        inv = sum(1 for a in range(n) for b in range(a + 1, n) if perm[a] > perm[b])
        term = {tuple([0] * NB): 1}
        for r in range(n):
            if not Mx[r][perm[r]]: term = {}; break
            term = pmul(term, Mx[r][perm[r]], p)
            if not term: break
        if term: tot = padd(tot, term, p, -1 if inv % 2 else 1)
    return tot
def tovec(P, T, d, p):
    v = np.zeros(len(T.M[d]), np.int64)
    for e, c in P.items():
        assert sum(e) == d
        v[T.idx[d][e]] = (v[T.idx[d][e]] + c) % p
    return v

# ---------------- modular linear algebra (dense, numpy)
def rref(A, p):
    A = np.array(A, dtype=np.int64) % p
    nr, nc = A.shape; piv = []; r = 0
    for c in range(nc):
        if r == nr: break
        nz = np.nonzero(A[r:, c])[0]
        if len(nz) == 0: continue
        pr = r + nz[0]
        if pr != r: A[[r, pr]] = A[[pr, r]]
        A[r] = A[r] * pow(int(A[r, c]), p - 2, p) % p
        col = A[:, c].copy(); col[r] = 0; nzc = np.nonzero(col)[0]
        if len(nzc): A[nzc] = (A[nzc] - col[nzc, None] * A[r][None, :]) % p
        piv.append(c); r += 1
    return A[:r], piv
def rank(A, p): return len(rref(A, p)[1]) if A.size else 0
def kernel(A, p):
    nc = A.shape[1]; R, piv = rref(A, p); sp = set(piv)
    free = [c for c in range(nc) if c not in sp]
    K = np.zeros((nc, len(free)), np.int64)
    for j, f in enumerate(free):
        K[f, j] = 1
        for i, c in enumerate(piv): K[c, j] = (-R[i, f]) % p
    return K
def solve(A, b, p):
    nc = A.shape[1]; R, piv = rref(np.concatenate([A, (np.asarray(b) % p)[:, None]], 1), p)
    if piv and piv[-1] == nc: return None
    x = np.zeros(nc, np.int64)
    for i, c in enumerate(piv): x[c] = R[i, nc]
    return x

class Fourfold:
    """G: dict cubic in y0..y5; planes: list of (f, g) with f = 3 linear dicts, g = 3 quadric dicts, G = sum f_i g_i."""
    def __init__(self, p, G, planes, T):
        self.p = p; self.G = G; self.T = T; self.planes = planes
        for f, g in planes:
            s = {}
            for fi, gi in zip(f, g): s = padd(s, pmul(fi, gi, p), p)
            assert padd(s, G, p, -1) == {}, "G != sum f_i g_i"
        self.dG = [pdiff(G, i, p) for i in range(NB)]
        self.dGv = [tovec(q, T, 2, p) for q in self.dG]
        self.mult = {}

    def multmat(self, d):
        """S_d x (6 * |S_{d-2}|): columns (i, m) -> m * dG_i, column index i * |S_{d-2}| + idx(m)"""
        if d in self.mult: return self.mult[d]
        p = self.p; T = self.T; n2 = len(T.M[d - 2])
        A = np.zeros((len(T.M[d]), NB * n2), np.int64)
        q2 = T.A[2]
        for i in range(NB):
            nzq = np.nonzero(self.dGv[i])[0]
            for k in nzq:
                rows = rank_within(T.A[d - 2] + q2[k][None, :])
                A[rows, i * n2 + np.arange(n2)] = (A[rows, i * n2 + np.arange(n2)] + self.dGv[i][k]) % p
        self.mult[d] = A
        return A

    def check_smooth_and_slice(self):
        p = self.p; T = self.T; out = {}
        for d in (2, 3, 6, 7):
            out['rank J_%d' % d] = rank(self.multmat(d), p)
        out['dims R_2,R_3,R_6,R_7'] = (21 - out['rank J_2'], 56 - out['rank J_3'], 462 - out['rank J_6'], 792 - out['rank J_7'])
        sq2 = [i for i, e in enumerate(T.M[2]) if max(e) <= 1]; sq3 = [i for i, e in enumerate(T.M[3]) if max(e) <= 1]
        E2 = np.zeros((21, 15), np.int64); E2[sq2, np.arange(15)] = 1
        E3 = np.zeros((56, 20), np.int64); E3[sq3, np.arange(20)] = 1
        out['squarefree complement deg2'] = rank(np.concatenate([self.multmat(2), E2], 1), p) == 21
        out['squarefree complement deg3'] = rank(np.concatenate([self.multmat(3), E3], 1), p) == 56
        out['smooth (R_7 = 0)'] = out['dims R_2,R_3,R_6,R_7'][3] == 0
        return out

    def socle(self):
        p = self.p; T = self.T
        A6 = self.multmat(6)
        K = kernel(A6.T % p, p)              # left kernel: phi with phi^T A6 = 0
        assert K.shape[1] == 1, K.shape
        phi = K[:, 0]
        H = pdet([[pdiff(self.dG[i], j, p) for j in range(NB)] for i in range(NB)], p)
        hv = tovec(H, T, 6, p); s = int(phi @ hv % p); assert s
        self.phi = phi * pow(s, p - 2, p) % p
        return self.phi

    def psi3_cg(self, f, g):
        p = self.p; T = self.T
        Jm = [[pdiff(q, j, p) for j in range(NB)] for q in list(f) + list(g)]
        D = pdet(Jm, p)
        out = np.zeros(56, np.int64)
        for i, e in enumerate(T.M[3]):
            out[i] = self.phi @ tovec(pmul({e: 1}, D, p), T, 6, p) % p
        return out

    def psi6(self, psi3, f):
        """degree 6 from IBP (J_6) + vanishing on (I_Q^2)_6; returns psi6 and a consistency report"""
        p = self.p; T = self.T
        A6 = self.multmat(6); n4 = len(T.M[4])
        # rhs: Psi_3(d/dy_i m), m in S_4
        rhs = np.zeros(NB * n4, np.int64)
        for i in range(NB):
            for k, e in enumerate(T.M[4]):
                if e[i]:
                    f_ = list(e); f_[i] -= 1
                    rhs[i * n4 + k] = e[i] * psi3[T.idx[3][tuple(f_)]] % p
        # I_Q^2 generators f_a f_b m
        gens = []
        for a in range(3):
            for b in range(a, 3):
                ff = pmul(f[a], f[b], p)
                for e in T.M[4]:
                    gens.append(tovec(pmul(ff, {e: 1}, p), T, 6, p))
        I2 = np.array(gens, np.int64).T
        Aall = np.concatenate([A6, I2], 1)            # psi6^T Aall = [rhs, 0]
        ball = np.concatenate([rhs, np.zeros(I2.shape[1], np.int64)])
        x = solve(Aall.T % p, ball, p)
        rep = {'rank [J_6 | I^2_6]': rank(Aall, p), 'consistent': x is not None}
        return x, rep

    def cofactors7(self):
        """C (792 x 6*|S_5|) with mu = sum_(i,m) C[mu,(i,m)] m dG_i, supported on a pivot set"""
        p = self.p
        A7 = self.multmat(7)
        R, piv = rref(A7, p)
        assert len(piv) == 792
        B = A7[:, piv]
        # invert B (792 x 792)
        Rb, pb = rref(np.concatenate([B, np.eye(792, dtype=np.int64)], 1), p)
        Binv = Rb[:, 792:]
        # mu = e_mu = B Binv e_mu -> cofactor on pivot columns = Binv[:, mu]
        self.piv7 = np.array(piv, np.int64); self.C7 = Binv.T.copy() % p   # C7[mu, k] coefficient of pivot column k
        n5 = len(self.T.M[5])
        self.piv_i = self.piv7 // n5; self.piv_m = self.T.A[5][self.piv7 % n5]
        return self.C7

    def extend(self, psi, d, chunk=4000):
        """psi: dict degree -> vector; computes degree d >= 9 from degree d - 3 by IBP"""
        p = self.p; T = self.T
        A = T.A[d]; n = len(A)
        prev = psi[d - 3]
        # mu(beta): last 7 units, filling from variable 5 down
        mu = np.zeros_like(A); rem = np.full(n, 7, np.int64)
        for j in range(NB - 1, -1, -1):
            t = np.minimum(A[:, j], rem); mu[:, j] = t; rem -= t
        gam = A - mu
        mui = rank_within(mu)
        out = np.zeros(n, np.int64)
        K = len(self.piv7)
        Ei = np.eye(NB, dtype=np.int64)[self.piv_i]          # K x 6
        Mk = self.piv_m                                        # K x 6
        for s in range(0, n, chunk):
            g = gam[s:s + chunk]
            tgt = g[:, None, :] + Mk[None, :, :] - Ei[None, :, :]       # c x K x 6
            cf = g[:, self.piv_i] + Mk[np.arange(K), self.piv_i][None, :]   # gamma_i + m_i
            ok = cf > 0
            tgt = np.where(ok[:, :, None], tgt, 0)
            tgt[~ok] = 0; tgt[~ok, 0] = d - 3      # dummy valid monomial
            r = rank_within(tgt.reshape(-1, NB)).reshape(cf.shape)
            vals = prev[r]
            w = self.C7[mui[s:s + chunk]] * cf % p
            w[~ok] = 0
            out[s:s + chunk] = (w * vals % p).sum(1) % p
        return out

    def check_Ipower(self, psi_d, d, f, power):
        """max over random samples: is psi_d zero on (I_Q^power)_d ? (random elements)"""
        p = self.p; T = self.T; rng = np.random.default_rng(1)
        bad = 0
        for t in range(20):
            P = {tuple([0] * NB): 1}
            for k in range(power):
                P = pmul(P, f[rng.integers(0, 3)], p)
            mexp = T.M[d - power][rng.integers(0, len(T.M[d - power]))]
            P = pmul(P, {mexp: int(rng.integers(1, p))}, p)
            val = 0
            for e, c in P.items():
                val = (val + c * psi_d[rank_within(np.array([e]))[0]]) % p
            bad += int(val != 0)
        return bad

def fermat_closed(p, z, c, T, d):
    """closed-form Fermat Psi_B on degree d for the plane with pair roots (c, c, c): pairs (0,1),(2,3),(4,5);
    pattern (r_a, r_b) = (0,1) -> 3c, (1,0) -> 3c^2 (fe_ref.py convention)"""
    inv3 = pow(3, p - 2, p)
    poch = np.ones((2, 60), np.int64)
    for r in range(2):
        for m in range(1, 60): poch[r, m] = poch[r, m - 1] * ((1 + r + 3 * (m - 1)) * inv3 % p) % p
    A = T.A[d]; out = np.ones(len(A), np.int64)
    rr = A % 3; mm = A // 3
    for j in range(NB):
        valid = rr[:, j] <= 1
        out = np.where(valid, out * poch[np.minimum(rr[:, j], 1), mm[:, j]] % p, 0)
    for k in range(3):
        a, b = 2 * k, 2 * k + 1
        pat01 = (rr[:, a] == 0) & (rr[:, b] == 1); pat10 = (rr[:, a] == 1) & (rr[:, b] == 0)
        fac = np.where(pat01, 3 * c % p, np.where(pat10, 3 * c * c % p, 0))
        out = out * fac % p
    return out
