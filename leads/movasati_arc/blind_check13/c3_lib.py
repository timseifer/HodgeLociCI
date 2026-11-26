#!/usr/bin/env python3
"""C3, own test.  Unknown jet T_1 (fixed), T_2..T_6.  Around a base jet T^0 write T_n = T^0_n + d_n (n = 2..6).
Exact identity (weights: d_n ~ eps^n, everything mod eps^7), with E_k = [eps^k] exp(sum eps^j T^0_j), Phi(G) = (Lam(Q G))_Q:
   c_n(T^0 + d) = c_n(T^0) + sum_{m=2..n} Phi(E_(n-m) d_m) + NL_n(d),
   NL_4 = Phi(d_2^2/2),  NL_5 = Phi(d_2 d_3 + E_1 d_2^2/2),
   NL_6 = Phi(d_2 d_4 + d_3^2/2 + E_1 d_2 d_3 + E_2 d_2^2/2 + d_2^3/6),   NL_2 = NL_3 = 0.
d_6 enters only through L d_6 (L = Phi(E_0 .)), so order 6 is projected to coker L (26 functionals) and d_6 dropped.
System:  v(Y) = Lin Y + NL(Y) - b = 0,  Y = (d_2,..,d_5) in K^480,  v in K^(4*45+26) = K^206,  b = -c(T^0).

"Linear closure" (rigorous up to random identity tests): X = a linear space known to contain all solutions Y
(relative to the base jet).  Any row vector l with l.NL identically zero on X gives a linear equation
(l Lin) Y = l.b valid on all solutions.  Add all of them; if they are inconsistent on X there is NO solution;
if they are consistent and inhomogeneous, move the base jet to a point of the new X and go on."""
import sys, time
sys.path.insert(0, "/home/claude/blind_check13")
from lib13 import *

class C3:
    def __init__(self, S, tab, Ts, verbose=True):
        self.S = S; self.p = S.p; self.tab = tab; self.verbose = verbose
        self.Q = sqfree_monos(10, 2); self.mons = sqfree_monos(10, 3)
        self.index = {m: i for i, m in enumerate(self.mons)}
        self.qm = [[tuple(a + b for a, b in zip(q, m)) for m in self.mons] for q in self.Q]
        self.T = list(Ts) + [S.ctx.from_dict({})] * (6 - len(Ts))
        self.rng = np.random.default_rng(12345)
        self.set_base(self.T, full=True)
    def Jmat(self, Ek):
        R = self.S.response(Ek, self.tab, 5)
        return np.array([[R.get(b, 0) for b in row] for row in self.qm], dtype=np.int64)
    def set_base(self, T, full=False, b=None):
        S = self.S; p = self.p
        self.T = list(T)
        N = 6 if full else 4
        self.E = S.expseries(self.T, N)
        self.J = [self.Jmat(self.E[k]) for k in range(5)]
        if not hasattr(self, "g6"):
            self.g6 = bounded_monos(10, 6, 2); self.g6i = {g: i for i, g in enumerate(self.g6)}
        self.M = [mult_matrix(S, self.E[k], self.g6, self.tab, self.Q) for k in range(3)]    # 45 x 2850 each
        L = self.J[0]
        if full:
            self.Kl = nullspace(L.T, p).T                      # 26 x 45, rows: basis of the left kernel of L
            c = [np.array(S.periods(self.E[n], self.tab, self.Q), dtype=np.int64) for n in range(1, 7)]
            self.c = c
            self.b = np.concatenate([(-c[1]) % p, (-c[2]) % p, (-c[3]) % p, (-c[4]) % p, (-(self.Kl @ c[5])) % p])
        else:
            self.b = b
        Lin = np.zeros((206, 480), dtype=np.int64)
        for n in range(2, 7):
            for m in range(2, min(n, 5) + 1):
                blk = self.J[n - m]
                if n == 6: blk = self.Kl @ blk % p
                r0 = 45 * (n - 2); r1 = r0 + (45 if n < 6 else 26)
                Lin[r0:r1, 120 * (m - 2):120 * (m - 1)] = blk
        self.Lin = Lin
    def polys(self, y):
        return [poly_of(self.S, y[120 * k:120 * (k + 1)], self.mons) for k in range(4)]
    def vec6(self, f):
        v = np.zeros(len(self.g6), dtype=np.int64)
        for mon, c in zip(f.monoms(), f.coeffs()):
            v[self.g6i[tuple(mon)]] = int(c)
        return v
    def NL(self, y):
        """non-linear part, as a vector in K^206 (zero in the first 90 coordinates)"""
        S = self.S; p = self.p
        d2, d3, d4, d5 = self.polys(y)
        i2 = pow(2, p - 2, p); i6 = pow(6, p - 2, p)
        d22 = d2 * d2
        v22 = self.vec6(d22) * i2 % p; v23 = self.vec6(d2 * d3); v24 = self.vec6(d2 * d4); v33 = self.vec6(d3 * d3) * i2 % p
        M0, M1, M2 = self.M
        out = np.zeros(206, dtype=np.int64)
        out[90:135] = M0 @ v22 % p
        out[135:180] = (M0 @ v23 + M1 @ v22) % p
        cub = fast_periods(S, d22 * d2 * i6, self.tab, self.Q)
        o6 = (M0 @ ((v24 + v33) % p) + M1 @ v23 + M2 @ v22 + cub) % p
        out[180:206] = self.Kl @ o6 % p
        return out
    def v(self, y):
        return (self.Lin @ y + self.NL(y) - self.b) % self.p
    def direct(self, y):
        """c_n(T^0 + y), n = 2..6, computed directly from the definition (for validating the identity)"""
        S = self.S; p = self.p
        d = self.polys(y)
        T = [self.T[0]] + [self.T[k + 1] + d[k] for k in range(4)] + [self.T[5]]
        E = S.expseries(T, 6)
        c = [np.array(S.periods(E[n], self.tab, self.Q), dtype=np.int64) for n in range(2, 7)]
        return np.concatenate([c[0], c[1], c[2], c[3], self.Kl @ c[4] % p]) % p
    def rand_in(self, W, sparse=0):
        k = W.shape[1]
        if k == 0: return np.zeros(480, dtype=np.int64)
        a = self.rng.integers(0, self.p, size=k)
        if sparse and k > sparse:
            mask = np.zeros(k, dtype=np.int64); mask[self.rng.choice(k, size=sparse, replace=False)] = 1
            a = a * mask
        return W @ a % self.p
    def closure(self, W, maxrounds=30, stall=6, maxsamples=260, tlimit=400, sparse=0):
        """W: 480 x k matrix whose columns span the initial X (relative to the base jet).  Returns (verdict, log)."""
        p = self.p; t0 = time.time(); log = []
        for rnd in range(1, maxrounds + 1):
            k = W.shape[1]
            # --- sample the non-linear part on X until the span stops growing (last `stall` samples dense)
            rows = np.zeros((0, 116), dtype=np.int64); r = 0; still = 0; ns = 0
            while still < stall and ns < maxsamples:
                use_sparse = sparse if (sparse and still == 0 and ns < maxsamples - 3 * stall and ns % 2 == 0) else 0
                q = self.NL(self.rand_in(W, use_sparse))[90:]
                ns += 1
                if not q.any():
                    if not use_sparse: still += 1
                    continue
                new = np.vstack([rows, q]); R, piv = rref(new, p)
                if len(piv) > r:
                    rows = R; r = len(piv); still = 0
                elif not use_sparse:
                    still += 1
            Aq = nullspace(rows, p) if r else np.eye(116, dtype=np.int64)       # 116 x a
            A = np.zeros((206, 90 + Aq.shape[1]), dtype=np.int64)
            A[:90, :90] = np.eye(90, dtype=np.int64); A[90:, 90:] = Aq
            C = A.T @ self.Lin % p
            M = C @ W % p; d = A.T @ self.b % p
            rM = rank(M, p)
            sol = solve(M, d, p) if k else (np.zeros(0, dtype=np.int64) if not d.any() else None)
            dims = [rank(W[120 * j:120 * (j + 1)], p) if k else 0 for j in range(4)]
            entry = dict(round=rnd, dimX=k, proj=dims, samples=ns, rankNL=r, usable=A.shape[1], rankConstraints=rM,
                         inhom=bool(d.any()), consistent=sol is not None, time=round(time.time() - t0, 1))
            log.append(entry)
            if self.verbose: print("   ", entry); sys.stdout.flush()
            if sol is None:
                # certificate: gamma with gamma M = 0 and gamma.d != 0
                G = nullspace(M.T, p)
                gd = G.T @ d % p
                j = int(np.flatnonzero(gd)[0])
                ell = A @ G[:, j] % p
                chk = [int(ell @ self.NL(self.rand_in(W)) % p) for _ in range(6)]
                cert = dict(l_dot_b=int(ell @ self.b % p), l_Lin_W_zero=not (ell @ self.Lin % p @ W % p).any(),
                            l_NL_at_6_fresh_dense_points=chk,
                            support_by_order=[int(np.count_nonzero(ell[45 * j:45 * (j + 1)])) for j in range(4)] + [int(np.count_nonzero(ell[180:]))])
                return "EMPTY", log, cert, ell
            N = nullspace(M, p)
            if N.shape[1] == k and not sol.any():
                return "STABLE (no linear consequence left; inconclusive)", log, None, None
            y1 = W @ sol % p
            Wn = W @ N % p
            if y1.any():
                bn = (self.b - self.Lin @ y1 - self.NL(y1)) % p
                d = self.polys(y1)
                T = [self.T[0]] + [self.T[j + 1] + d[j] for j in range(4)] + [self.T[5]]
                self.set_base(T, full=False, b=bn)
            W = Wn
            if time.time() - t0 > tlimit:
                return "TIME LIMIT (inconclusive)", log, None, None
        return "ROUND LIMIT (inconclusive)", log, None, None
