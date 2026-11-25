# EX-T6: exact arcs and exact linearisations (same formulas as step (e)'s run2.build / run2.jac, over Q(z)).
from fex import *

class Arc:
    """T_1 = v, T_n = SL c_n + kerL x_n (x_n realified Q-coordinates in ker L), exact. Incremental."""
    def __init__(self, X, v):
        self.X = X; self.v = v
        self.xs = {}
        self.reset(1)

    def reset(self, j):
        """forget everything from T_j on (j >= 1)"""
        X = self.X
        if j <= 1:
            self.Ts = [self.v]; self.Tp = [X.vec_to_poly(self.v)]
            self.Es = [X.poly_one(), self.Tp[0]]; self.MHs = [X.L, X.MH(self.Tp[0])]
            self.cs = [None, None]; self.Kc = [None, None]
        else:
            self.Ts = self.Ts[:j - 1]; self.Tp = self.Tp[:j - 1]
            self.Es = self.Es[:j]; self.MHs = self.MHs[:j]
            self.cs = self.cs[:j]; self.Kc = self.Kc[:j]

    def set_x(self, j, x):
        self.xs[j] = x
        if len(self.Ts) >= j: self.reset(j)

    def extend(self, N, verbose=False):
        """compute c_n, K.c_n up to n = N (T_n for n < N)"""
        X = self.X
        import time
        while len(self.cs) <= N:
            n = len(self.cs)
            t0 = time.time()
            c = None
            for j in range(1, n):
                term = self.MHs[n - j] * self.Ts[j - 1] * fmpq(j, n)
                c = term if c is None else c + term
            self.cs.append(c); self.Kc.append(X.K * c)
            if n == N: break
            T = X.SL * c
            if n in self.xs: T = T + X.kerL * self.xs[n]
            self.Ts.append(T); self.Tp.append(X.vec_to_poly(T))
            terms = [(fmpq(j, n), X.mul(self.Tp[j - 1], self.Es[n - j])) for j in range(1, n + 1)]
            En = X.add(*terms)
            self.Es.append(En); self.MHs.append(X.MH(En))
            if verbose: print("   order", n, "|E'_n| =", len(En[0]), "K.c_n nnz", nnz(self.Kc[n]), "(%.0fs)" % (time.time() - t0), flush=True)
        return self

def lin(X, MHs, j, dT0, N):
    """perturb T_j by dT0 (realified 440 x k matrix); T_i (i > j) re-solved linearly dT_i = SL dc_i.
    returns dict m -> dc_m (realified 442 x k), m = j+1..N"""
    dT = {j: dT0}; dc = {}
    for m in range(j + 1, N + 1):
        acc = None
        for i in range(j, m):
            t = MHs[m - i] * dT[i]
            acc = t if acc is None else acc + t
        dc[m] = acc
        dT[m] = X.SL * acc
    return dc

def y_constraints(cols_list, n):
    """rows of the Q-linear constraints y.w = 0 (in Q(z)) on y = (y0, y1) in Q^(2n), for realified vectors w = columns"""
    rows = []
    for M in cols_list:
        a = mat_to_np(M)
        for k in range(a.shape[1]):
            w0 = a[:n, k]; w1 = a[n:, k]
            rows.append(np.concatenate([w0, -w1])); rows.append(np.concatenate([w1, w0 + w1]))
    return np_to_mat(np.array(rows, dtype=object))

def qz_dot(y, w, n):
    """y = (y0, y1), w = (w0, w1) realified (lists) -> (a, b) = y.w in Q(z)"""
    y0, y1 = y[:n], y[n:]; w0, w1 = w[:n], w[n:]
    s00 = sum((a * b for a, b in zip(y0, w0)), Q0); s11 = sum((a * b for a, b in zip(y1, w1)), Q0)
    s01 = sum((a * b for a, b in zip(y0, w1)), Q0); s10 = sum((a * b for a, b in zip(y1, w0)), Q0)
    return (s00 - s11, s01 + s10 + s11)
