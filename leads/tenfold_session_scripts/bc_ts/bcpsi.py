# [BC-TS] (AI-generated, unreviewed) blind checker: own Psi_B tables for the cubic fourfold G = f^T M0 h in y = x6..x11.
#   degree 3 : Carlson-Griffiths  Psi_3(P) = kappa * tau(P * det Jac(f1,f2,f3,g1,g2,g3)),  tau = socle functional of
#              R(G) normalised by tau(Hess G) = 64; kappa fixed once at the Fermat point by the closed form (Q1).
#   degree 6 : Psi_6(u G_i) = Psi_3(d_i u) (u in S_4) and Psi_6 = 0 on I_Q^2 (linear system, consistency checked)
#   degree >=9: IBP via a fixed right inverse of (h_i) -> sum h_i G_i at degree 7:
#              m = u * m7, m7 = sum h_i G_i  =>  Psi_d(m) = sum_i Psi_{d-3}(d_i(u h_i)).
# Monomial order: graded, inside a degree the combinatorial-number-system rank `rk` below (own convention).
import numpy as np, itertools
from math import comb
from bcla import rref, rank, kernel, solve

NB = 6

def mons(d, n=NB):
    out = []
    for c in itertools.combinations(range(d + n - 1), n - 1):
        e = []; prev = -1
        for x in c: e.append(x - prev - 1); prev = x
        e.append(d + n - 2 - prev)
        out.append(tuple(e))
    out.sort(key=rk_scalar)
    return out

def rk_scalar(e):
    s = 0; r = 0
    for k in range(len(e) - 1):
        s += e[k]; r += comb(s + k, k + 1)
    return r

def rk(E):
    """vectorised rank of rows of E (n columns) among monomials of the same degree"""
    E = np.asarray(E, np.int64); n = E.shape[1]
    s = np.zeros(E.shape[0], np.int64); r = np.zeros(E.shape[0], np.int64)
    for k in range(n - 1):
        s = s + E[:, k]; r = r + binom_vec(s + k, k + 1)
    return r

_BT = np.array([[comb(a, b) for b in range(8)] for a in range(80)], np.int64)
def binom_vec(a, b):
    return _BT[np.clip(a, 0, 79), b]

# ---------- polynomials in 6 vars: dict exps -> coeff mod p
def padd(A, B, p, c=1):
    C = dict(A)
    for e, v in B.items():
        C[e] = (C.get(e, 0) + c * v) % p
        if C[e] == 0: del C[e]
    return C
def pmul(A, B, p):
    C = {}
    for e1, v1 in A.items():
        for e2, v2 in B.items():
            e = tuple(a + b for a, b in zip(e1, e2)); C[e] = (C.get(e, 0) + v1 * v2) % p
    return {e: v for e, v in C.items() if v}
def pdiff(A, i, p):
    C = {}
    for e, v in A.items():
        if e[i]:
            e2 = list(e); e2[i] -= 1; C[tuple(e2)] = (C.get(tuple(e2), 0) + v * e[i]) % p
    return {e: v for e, v in C.items() if v}
def lin(c, p):
    return {tuple(1 if j == i else 0 for j in range(NB)): x % p for i, x in enumerate(c) if x % p}
def pdeg(A): return sum(next(iter(A))) if A else -1

def det_poly(Mx, p):
    """Leibniz determinant of a square matrix of polynomials"""
    n = len(Mx); D = {}
    for perm in itertools.permutations(range(n)):
        sgn = 1
        for i in range(n):
            for j in range(i + 1, n):
                if perm[i] > perm[j]: sgn = -sgn
        t = {tuple([0] * NB): 1}
        for i in range(n):
            t = pmul(t, Mx[i][perm[i]], p)
            if not t: break
        if t: D = padd(D, t, p, sgn)
    return D

# ---------- geometry (own rebuild of the documented construction; compared with split.build_G by the driver)
def pair_forms(p, z):
    zb = (1 - z) % p; f = []; h = []; l = []
    for k in range(3):
        a, b = 2 * k, 2 * k + 1
        cf = [0] * 6; cf[a] = 1; cf[b] = -z; f.append(lin(cf, p))
        ch = [0] * 6; ch[a] = 1; ch[b] = 1; h.append(lin(ch, p))
        cl = [0] * 6; cl[a] = 1; cl[b] = -zb; l.append(lin(cl, p))
    return f, h, l

def build(p, z, gseed):
    f, h, l = pair_forms(p, z); w = f + h
    if gseed == 0:
        M = [[l[i] if i == j else {} for j in range(3)] for i in range(3)]
    else:
        M0 = np.random.default_rng(1000 + gseed).integers(-9, 10, (3, 3, 6))
        M = [[{} for j in range(3)] for i in range(3)]
        for i in range(3):
            for j in range(3):
                for k in range(6):
                    if M0[i, j, k]: M[i][j] = padd(M[i][j], w[k], p, int(M0[i, j, k]))
    g1 = [{} for _ in range(3)]; g2 = [{} for _ in range(3)]
    for i in range(3):
        for j in range(3):
            g1[i] = padd(g1[i], pmul(M[i][j], h[j], p), p)
            g2[j] = padd(g2[j], pmul(f[i], M[i][j], p), p)
    G = {}
    for i in range(3): G = padd(G, pmul(f[i], g1[i], p), p)
    G2 = {}
    for j in range(3): G2 = padd(G2, pmul(h[j], g2[j], p), p)
    assert G == G2
    return G, (f, g1), (h, g2)

class PsiB:
    def __init__(self, p, G, Dmax, log=print):
        self.p = p; self.G = G; self.Dmax = Dmax; self.log = log
        self.M = {d: mons(d) for d in range(0, max(Dmax, 8) + 1)}
        self.idx = {d: {e: i for i, e in enumerate(self.M[d])} for d in range(0, 9)}
        for d in range(max(Dmax, 8) + 1):
            assert np.array_equal(rk(np.array(self.M[d]).reshape(-1, NB)), np.arange(len(self.M[d])))
        self.dG = [pdiff(G, i, p) for i in range(NB)]
        self.tau = self.socle()
        self.rep7()

    def vec(self, P, d):
        v = np.zeros(len(self.M[d]), np.int64)
        for e, c in P.items(): v[self.idx[d][e]] = (v[self.idx[d][e]] + c) % self.p
        return v

    def jac_matrix(self, d):
        """columns: y^u G_i (u in S_{d-2}), rows: S_d"""
        p = self.p; cols = []
        for i in range(NB):
            for u in self.M[d - 2]:
                cols.append(self.vec(pmul({u: 1}, self.dG[i], p), d))
        return np.array(cols, np.int64).T

    def socle(self):
        p = self.p
        J6 = self.jac_matrix(6)
        K = kernel(J6.T, p)                       # functionals on S_6 killing J_6
        self.log("BC socle: dim S_6/J_6 = %d (must be 1)" % K.shape[1]); assert K.shape[1] == 1
        t = K[:, 0]
        H = [[pdiff(self.dG[i], j, p) for j in range(NB)] for i in range(NB)]
        hess = det_poly(H, p)
        th = int(t @ self.vec(hess, 6) % p); assert th
        self.R7zero = rank(self.jac_matrix(7), p) == len(self.M[7])
        self.log("BC G smooth (J_7 = S_7): %s" % self.R7zero); assert self.R7zero
        return t * (64 * pow(th, p - 2, p) % p) % p

    def psi3_cg(self, f, g):
        p = self.p
        Jm = [[pdiff(f[i], j, p) for j in range(NB)] for i in range(3)] + [[pdiff(g[i], j, p) for j in range(NB)] for i in range(3)]
        D = det_poly(Jm, p)
        out = np.zeros(len(self.M[3]), np.int64)
        for k, e in enumerate(self.M[3]):
            out[k] = self.tau @ self.vec(pmul({e: 1}, D, p), 6) % p
        return out

    def psi6(self, psi3, f):
        p = self.p; n6 = len(self.M[6])
        rows = []; rhs = []
        for i in range(NB):
            for u in self.M[4]:
                rows.append(self.vec(pmul({u: 1}, self.dG[i], p), 6))
                du = pdiff({u: 1}, i, p)
                rhs.append(int(sum(c * psi3[self.idx[3][e]] for e, c in du.items()) % p))
        for a in range(3):
            for b in range(a, 3):
                ff = pmul(f[a], f[b], p)
                for u in self.M[4]:
                    rows.append(self.vec(pmul({u: 1}, ff, p), 6)); rhs.append(0)
        A = np.array(rows, np.int64); b = np.array(rhs, np.int64)
        x = solve(A, b, p)
        rA = rank(A, p)
        self.log("BC degree-6 system: %d equations, rank %d of %d unknowns, consistent: %s" % (len(rows), rA, n6, x is not None))
        assert x is not None and rA == n6
        return x

    def rep7(self):
        """right inverse at degree 7: for each m in S_7, h^m in S_5^6 with sum h_i G_i = m"""
        p = self.p; Phi = self.jac_matrix(7); n7 = Phi.shape[0]; nc = Phi.shape[1]
        R, piv = rref(np.concatenate([Phi, np.eye(n7, dtype=np.int64)], 1), p)
        assert len([c for c in piv if c < nc]) == n7
        X = np.zeros((nc, n7), np.int64)
        for i, c in enumerate(piv):
            if c < nc: X[c] = R[i, nc:]
        assert not ((Phi @ X - np.eye(n7, dtype=np.int64)) % p).any()
        n5 = len(self.M[5])
        self.H7 = X.reshape(NB, n5, n7)          # H7[i, w, m] = coeff of y^w in h_i^m
        # delta^m = sum_i d_i h_i^m in S_4
        n4 = len(self.M[4]); D = np.zeros((n4, n7), np.int64)
        M5 = np.array(self.M[5])
        for i in range(NB):
            for wi, w in enumerate(self.M[5]):
                if w[i]:
                    w2 = list(w); w2[i] -= 1
                    D[self.idx[4][tuple(w2)]] = (D[self.idx[4][tuple(w2)]] + w[i] * self.H7[i, wi]) % p
        self.D7 = D

    def extend(self, prev, d):
        """Psi_d from Psi_{d-3} (d >= 9) by IBP"""
        p = self.p
        Md = np.array(self.M[d], np.int64)
        # canonical m7: greedy from y0
        m7 = np.zeros_like(Md); rem = np.full(len(Md), 7, np.int64)
        for k in range(NB):
            t = np.minimum(Md[:, k], rem); m7[:, k] = t; rem -= t
        U = Md - m7
        k7 = rk(m7)
        out = np.zeros(len(Md), np.int64)
        M5 = np.array(self.M[5], np.int64); M4 = np.array(self.M[4], np.int64)
        # sum_i Psi((d_i u) h_i) = sum_i sum_w H7[i,w,k] u_i Psi(u - e_i + w)
        for i in range(NB):
            ui = U[:, i]; ok = ui > 0
            Ui = U.copy(); Ui[:, i] -= 1
            for wi in range(len(M5)):
                coef = self.H7[i, wi, k7]
                sel = ok & (coef != 0)
                if not sel.any(): continue
                r = rk(Ui[sel] + M5[wi])
                out[sel] = (out[sel] + coef[sel] * (ui[sel] % p) % p * prev[r]) % p
        for wi in range(len(M4)):
            coef = self.D7[wi, k7]; sel = coef != 0
            if not sel.any(): continue
            r = rk(U[sel] + M4[wi])
            out[sel] = (out[sel] + coef[sel] * prev[r]) % p
        return out

    def table(self, f, g, kappa):
        psi = {d: np.zeros(len(self.M[d]), np.int64) for d in range(self.Dmax + 1)}
        psi[3] = self.psi3_cg(f, g) * kappa % self.p
        psi[6] = self.psi6(psi[3], f)
        for d in range(9, self.Dmax + 1, 3):
            psi[d] = self.extend(psi[d - 3], d)
        return psi

    def check_ibp(self, psi, d, ntest=20, seed=0):
        """random h in S_{d-2}, i: Psi_d(h G_i) == Psi_{d-3}(d_i h)"""
        p = self.p; rng = np.random.default_rng(seed); bad = 0
        for t in range(ntest):
            i = int(rng.integers(0, NB)); e = self.M[d - 2][int(rng.integers(0, len(self.M[d - 2])))]
            lhs = sum(c * psi[d][rk_scalar(tuple(a + b for a, b in zip(e, e2)))] for e2, c in self.dG[i].items()) % p
            rhs = (e[i] * psi[d - 3][rk_scalar(tuple(x - (1 if j == i else 0) for j, x in enumerate(e)))] % p) if e[i] else 0
            bad += (lhs - rhs) % p != 0
        return bad

    def vanish_Ipower(self, psi, d, f, k, ntest=30, seed=1):
        """Psi_d on random elements f^a * y^u of I_Q^k (|a| = k)"""
        p = self.p; rng = np.random.default_rng(seed); bad = 0
        for t in range(ntest):
            P = {tuple([0] * NB): 1}
            for j in range(k): P = pmul(P, f[int(rng.integers(0, 3))], p)
            u = self.M[d - k][int(rng.integers(0, len(self.M[d - k])))]
            P = pmul(P, {u: 1}, p)
            val = sum(c * psi[d][rk_scalar(e)] for e, c in P.items()) % p
            bad += val != 0
        return bad

def poch_table(p, nmax=40):
    inv3 = pow(3, p - 2, p); T = np.ones((2, nmax), np.int64)
    for r in range(2):
        for m in range(1, nmax):
            T[r, m] = T[r, m - 1] * ((1 + r + 3 * (m - 1)) * inv3 % p) % p
    return T

def fermat_closed_B(p, c, e):
    """Fermat functional on 3 pairs of variables: prod poch * prod_pair (3c if residue pattern hits first var, 3c^2 if second)"""
    PT = poch_table(p); val = 1
    for k in range(3):
        a, b = e[2 * k], e[2 * k + 1]
        # Psi(x^g) = prod ((1+r)/3)_m * coeff of x^(1-r) in P, g = 3m + r; pair factor 3c(x_a + c x_b)
        if a % 3 == 0 and b % 3 == 1: val = int(val) * 3 % p * c % p * int(PT[0, a // 3]) % p * int(PT[1, b // 3]) % p
        elif a % 3 == 1 and b % 3 == 0: val = int(val) * 3 % p * c % p * c % p * int(PT[1, a // 3]) % p * int(PT[0, b // 3]) % p
        else: return 0
    return val
