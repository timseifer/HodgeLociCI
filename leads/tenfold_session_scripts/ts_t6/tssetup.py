# [TS-T6] (AI-generated, unreviewed): geometry at the split point F = Fermat4(x0..x5) + G(x6..x11):
# reduction S_3 -> slice (220 squarefree cubics) mod J(F)_3, T Cone (cone locus, P^8 and vertex moving; NF-T6 nfb.m2
# definition), T V_Z, T Cone_T, T Z_0, the 27 b-forms f_a h_b u_k (u in x1, x3, x5), Segre directions bOf(M).
import numpy as np, itertools
from psib import rref, rank, kernel, solve, padd, pmul, pdiff, lin
from split import build_G, pair_forms

def mons12(d):
    res = []
    for e in itertools.product(range(d + 1), repeat=12):
        if sum(e) == d: res.append(e)
    return res

class Geometry:
    def __init__(self, p, z, Gseed, W, WP1, WP2, log=print):
        self.p = p; self.z = z; self.W = W
        G, P1, P2, M = build_G(p, z, Gseed)
        self.G = G; self.f = P1[0]; self.h = P2[0]
        self.slice = W.mons; self.sidx = {e: i for i, e in enumerate(self.slice)}
        self.S3 = [e for e in itertools.product(range(4), repeat=12) if sum(e) == 3]
        self.S3i = {e: i for i, e in enumerate(self.S3)}
        # y-reduction tables mod J(G) for degrees 2, 3 onto squarefree y-monomials
        dG = [pdiff(G, i, p) for i in range(6)]
        self.yred = {}
        for b in (2, 3):
            mb = [e for e in itertools.product(range(4), repeat=6) if sum(e) == b]; mi = {e: i for i, e in enumerate(mb)}
            sq = [e for e in mb if max(e) <= 1]
            gens = dG if b == 2 else [pmul(q, lin([1 if j == k else 0 for j in range(6)]), p) for q in dG for k in range(6)]
            Jm = np.zeros((len(mb), len(gens)), np.int64)
            for c, q in enumerate(gens):
                for e, v in q.items(): Jm[mi[e], c] = (Jm[mi[e], c] + v) % p
            Es = np.zeros((len(mb), len(sq)), np.int64)
            for c, e in enumerate(sq): Es[mi[e], c] = 1
            A = np.concatenate([Es, Jm], 1)
            tab = {}
            for e in mb:
                rhs = np.zeros(len(mb), np.int64); rhs[mi[e]] = 1
                x = solve(A, rhs, p); assert x is not None
                tab[e] = {sq[c]: int(x[c]) for c in range(len(sq)) if x[c]}
            self.yred[b] = tab
        # reduction matrix S_3 -> slice
        Rm = np.zeros((220, len(self.S3)), np.int64)
        for c, e in enumerate(self.S3):
            for e2, v in self.red_mono(e).items(): Rm[self.sidx[e2], c] = (Rm[self.sidx[e2], c] + v) % p
        self.Rm = Rm
        # F and J(F)_3 check
        self.F12 = self.full_F()
        L = W.L; self.kerL = W.kerL
        C1 = WP1.L; C2 = WP2.L
        self.TVZ = kernel(np.concatenate([C1, C2], 0), p)
        self.TCone = self.tcone()
        lam = W.lam
        self.TCT = self.intersect(self.TCone, self.kerL)
        self.TZ0 = self.intersect(self.TCT, self.TVZ)
        self.report = {
            'rank L': rank(L, p), 'rank C1': rank(C1, p), 'rank C2': rank(C2, p),
            'codim T V_Z': 220 - self.TVZ.shape[1], 'excess (codim T V_Z - rank L)': 220 - self.TVZ.shape[1] - rank(L, p),
            'codim T Cone': 220 - self.TCone.shape[1], 'rank of L on T Cone': rank(L @ self.TCone % p, p),
            'codim T Cone_T': 220 - self.TCT.shape[1], 'codim T Z_0': 220 - self.TZ0.shape[1],
            'T V_Z + T Cone_T = ker L': rank(np.concatenate([self.TVZ, self.TCT], 1), p) == self.kerL.shape[1],
            'dim ker L': self.kerL.shape[1]}
        bb = []
        for a in range(3):
            for b in range(3):
                for u in (1, 3, 5): bb.append(self.bform(a, b, {u: 1}))
        self.Bb = np.array(bb, np.int64).T % p
        r0 = rank(self.TZ0, p)
        self.report['27 b-forms independent mod T Z_0'] = rank(np.concatenate([self.TZ0, self.Bb], 1), p) - r0
        self.report['T Z_0 + b-forms = T V_Z'] = rank(np.concatenate([self.TZ0, self.Bb], 1), p) == rank(self.TVZ, p) and rank(np.concatenate([self.TVZ, self.Bb], 1), p) == rank(self.TVZ, p)
        log("GEOMETRY " + str(self.report))

    def red_mono(self, e):
        p = self.p; ex = e[:6]; ey = e[6:]
        if max(ex) > 1: return {}
        b = sum(ey)
        if b <= 1 or max(ey) <= 1:
            return {e: 1}
        out = {}
        for e2, v in self.yred[b][ey].items(): out[tuple(ex) + e2] = v
        return out

    def red(self, P):
        v = np.zeros(220, np.int64)
        for e, c in P.items():
            for e2, w in self.red_mono(e).items(): v[self.sidx[e2]] = (v[self.sidx[e2]] + c * w) % self.p
        return v

    def lift12(self, P6):
        return {tuple([0] * 6) + e: c for e, c in P6.items()}

    def full_F(self):
        p = self.p; F = {}
        for i in range(6): F[tuple(3 if j == i else 0 for j in range(12))] = 1
        for e, c in self.G.items(): F[tuple([0] * 6) + e] = c
        return F

    def bform(self, a, b, Mab):
        """f_a h_b (sum_u Mab[u] x_u), reduced into the slice"""
        p = self.p
        fh = pmul(self.f[a], self.h[b], p)
        P = {}
        for u, cu in Mab.items():
            xu = tuple([1 if j == u else 0 for j in range(6)]) + tuple([0] * 6)
            for e, c in fh.items():
                P[tuple(x + y for x, y in zip(xu, (0,) * 6 + e))] = (P.get(tuple(x + y for x, y in zip(xu, (0,) * 6 + e)), 0) + c * cu) % p
        return self.red(P)

    def bOf(self, M):
        v = np.zeros(220, np.int64)
        for i in range(3):
            for j in range(3):
                v = (v + self.bform(i, j, M[i][j])) % self.p
        return v

    def intersect(self, A, B):
        p = self.p
        N = kernel(np.concatenate([A, B], 1), p)
        X = A @ N[:A.shape[1]] % p
        R, piv = rref(X.T, p)
        return R.T % p

    def tcone(self):
        """T Cone in slice coordinates: red({G' in S_3 : G'|P^8 in k[f,h]_3|P^8 + (J_F S_1)|P^8})"""
        p = self.p; z = self.z
        # P^8 = V(x0 - z x1, x2 - z x3, x4 - z x5); coordinates t = (x1, x3, x5, x6..x11) (9 vars)
        def res(e):   # monomial in 12 vars -> dict in 9 vars
            c = 1; t = [0] * 9
            for k in range(3):
                c = c * pow(z, e[2 * k], p) % p; t[k] = e[2 * k] + e[2 * k + 1]
            for j in range(6): t[3 + j] = e[6 + j]
            return tuple(t), c
        S8 = [e for e in itertools.product(range(4), repeat=9) if sum(e) == 3]; S8i = {e: i for i, e in enumerate(S8)}
        R8 = np.zeros((len(S8), len(self.S3)), np.int64)
        for c, e in enumerate(self.S3):
            t, v = res(e); R8[S8i[t], c] = (R8[S8i[t], c] + v) % p
        ug = []
        # all cubics in y (= k[f,h]_3)
        for e in S8:
            if sum(e[:3]) == 0:
                u = np.zeros(len(S8), np.int64); u[S8i[e]] = 1; ug.append(u)
        # (J_F S_1)|P^8
        for i in range(12):
            dF = pdiff(self.F12, i, p)
            for k in range(9):
                u = np.zeros(len(S8), np.int64)
                for e, c in dF.items():
                    t, v = res(e); t = list(t); t[k] += 1; u[S8i[tuple(t)]] = (u[S8i[tuple(t)]] + c * v) % p
                ug.append(u)
        U = np.array(ug, np.int64).T
        Nn = kernel(U.T % p, p)                      # 165 x (165 - rank U): functionals killing U
        TC = kernel(Nn.T @ R8 % p, p)                # in S_3 coordinates
        # J(F)_3 inside T Cone?
        J3 = []
        for i in range(12):
            dF = pdiff(self.F12, i, p)
            for k in range(12):
                v = np.zeros(len(self.S3), np.int64)
                for e, c in dF.items():
                    e2 = list(e); e2[k] += 1; v[self.S3i[tuple(e2)]] = (v[self.S3i[tuple(e2)]] + c) % p
                J3.append(v)
        J3 = np.array(J3).T
        self.J3_in_TCone = rank(np.concatenate([TC, J3], 1), p) == rank(TC, p)
        self.codimTCone_S3 = len(self.S3) - TC.shape[1]
        X = self.Rm @ TC % p
        R, piv = rref(X.T, p)
        return R.T % p
