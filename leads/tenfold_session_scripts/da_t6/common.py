# DA-T6 common helpers (MOD p). Uses the T6e engine read-only.
import sys, numpy as np, itertools
sys.path.insert(0, '/home/claude/hodge/discovery/t6_unsolved/e')
from ana import setup, bOf, mono
NV = 12

class Ctx:
    def __init__(self, p=32029, lam=-1):
        E, X = setup(p, lam)
        self.E, self.X, self.p, self.z = E, X, p, E.z % p
        self.mons = E.mons
        self.idx = {m: i for i, m in enumerate(self.mons)}
        self.kerL = E.kerL % p
        self.Mc = X['Mc'] % p
        self.TC = E.kernel(self.Mc)              # T Cone_T (in slice)
        self.TV = X['TV'] % p
        # 27 normal vectors b_ijk
        self.B = np.stack([bOf(E, [[({u: 1} if (i, j) == (i0, j0) else {}) for j in range(3)] for i in range(3)])
                           for i0 in range(3) for j0 in range(3) for u in (1, 3, 5)], 1) % p
        self.TCB = np.concatenate([self.TC, self.B], 1)

    # polynomials as dicts exponent-tuple -> coeff
    def var(self, i, c=1):
        e = [0] * NV; e[i] = 1; return {tuple(e): c % self.p}
    def lin(self, coeffs):  # dict var -> coeff
        out = {}
        for i, c in coeffs.items():
            e = [0] * NV; e[i] = 1; out[tuple(e)] = (out.get(tuple(e), 0) + c) % self.p
        return {k: v for k, v in out.items() if v}
    def add(self, *ps):
        out = {}
        for P in ps:
            for k, v in P.items(): out[k] = (out.get(k, 0) + v) % self.p
        return {k: v for k, v in out.items() if v}
    def scal(self, c, P): return {k: v * c % self.p for k, v in P.items() if v * c % self.p}
    def mul(self, A, B):
        out = {}
        for ka, va in A.items():
            for kb, vb in B.items():
                k = tuple(x + y for x, y in zip(ka, kb)); out[k] = (out.get(k, 0) + va * vb) % self.p
        return {k: v for k, v in out.items() if v}
    def det3(self, M):
        t = {}
        for perm in itertools.permutations(range(3)):
            s = 1
            for i in range(3):
                for j in range(i + 1, 3):
                    if perm[i] > perm[j]: s = -s
            t = self.add(t, self.scal(s, self.mul(self.mul(M[0][perm[0]], M[1][perm[1]]), M[2][perm[2]])))
        return t
    def minor2(self, M, r, c):
        return self.add(self.mul(M[r[0]][c[0]], M[r[1]][c[1]]), self.scal(-1, self.mul(M[r[0]][c[1]], M[r[1]][c[0]])))
    def monomials(self, deg):
        out = []
        for e in itertools.product(range(deg + 1), repeat=NV):
            if sum(e) == deg: out.append({tuple(e): 1})
        return out
    def slice_vec(self, P):
        v = np.zeros(len(self.mons), dtype=np.int64)
        for k, c in P.items():
            if sum(k) != 3: raise ValueError('not cubic')
            if max(k) <= 1: v[self.idx[k]] = (v[self.idx[k]] + c) % self.p
        return v
    def span(self, polys):
        A = np.stack([self.slice_vec(P) for P in polys], 1)
        R, piv = self.E.rref(A.T)
        return R.T % self.p  # columns: basis
    def rank(self, A): return self.E.rank(A % self.p)
    def intersect(self, A, B):
        # basis of span(A) n span(B) (columns)
        K = self.E.kernel(np.concatenate([A, (-B) % self.p], 1))
        if K.shape[1] == 0: return np.zeros((A.shape[0], 0), dtype=np.int64)
        V = A @ K[:A.shape[1]] % self.p
        R, piv = self.E.rref(V.T)
        return R.T % self.p
    def M_coords(self, w):
        """w in ker L: w = c + B m, c in T Cone_T; return m (27) as 3x3x3 tensor [i][j][u]"""
        s = self.E.solve(self.TCB, w)
        if s is None: return None
        return s[self.TC.shape[1]:].reshape(3, 3, 3)
