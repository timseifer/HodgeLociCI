"""Common code for the numerical matrix recovery along T2's sixfold arc.  AI-written, unreviewed.
Sixfold variables y0..y7 = x0..x5, x8, x9 of the exported eightfold file (it does not involve x6, x7)."""
import re, itertools, numpy as np
ARC = "M2/HodgeLociCI/data/six_lam-1_arc.txt"          # relative to the repository root
ZETA = np.exp(1j * np.pi / 3)                           # z = zeta_6, z^2 = z - 1
VMAP = {0: 0, 1: 1, 2: 2, 3: 3, 4: 4, 5: 5, 8: 6, 9: 7}

def parse_arc(path=ARC):
    """returns a list over n = 1..9 of dicts {(i,j,k) sorted sixfold indices: complex coefficient}"""
    out = []
    for line in open(path):
        m = re.match(r"T_(\d+) = (.*)$", line.strip())
        if not m: continue
        terms = {}
        body = m.group(2).strip()
        if body != "0":
            for t in body.split(" + "):
                mm = re.match(r"\[(.*)\]\*(.*)$", t)
                c = mm.group(1); mons = mm.group(2)
                m2 = re.match(r"\((-?[\d/]+)\)\+\((-?[\d/]+)\)\*z$", c)
                fr = lambda s: (lambda a: float(a[0]) / float(a[1]) if len(a) == 2 else float(a[0]))(s.split("/"))
                val = fr(m2.group(1)) + fr(m2.group(2)) * ZETA if m2 else fr(c)
                idx = tuple(sorted(VMAP[int(v[1:])] for v in mons.split("*")))
                terms[idx] = terms.get(idx, 0) + val
        out.append(terms)
    return out

def cubic_terms(eps, arc):
    """F_eps = sum y_i^3 - sum_n eps^n T_n  as a dict {sorted index triple: coefficient}"""
    F = {(i, i, i): 1.0 + 0j for i in range(8)}
    for n, T in enumerate(arc, start=1):
        for idx, c in T.items():
            F[idx] = F.get(idx, 0) - (eps ** n) * c
    return F

def eval_cubic(F, Y):
    r = np.zeros(Y.shape[0], dtype=complex)
    for (i, j, k), c in F.items():
        r += c * Y[:, i] * Y[:, j] * Y[:, k]
    return r

def adj3(M):
    """adjugate (transpose of the cofactor matrix) of an array of 3 x 3 matrices, shape (n,3,3)"""
    a = np.empty_like(M)
    for i in range(3):
        for j in range(3):
            r = [x for x in range(3) if x != j]; c = [x for x in range(3) if x != i]
            a[:, i, j] = (-1) ** (i + j) * (M[:, r[0], c[0]] * M[:, r[1], c[1]] - M[:, r[0], c[1]] * M[:, r[1], c[0]])
    return a

def det3(M):
    return (M[:, 0, 0] * (M[:, 1, 1] * M[:, 2, 2] - M[:, 1, 2] * M[:, 2, 1])
            - M[:, 0, 1] * (M[:, 1, 0] * M[:, 2, 2] - M[:, 1, 2] * M[:, 2, 0])
            + M[:, 0, 2] * (M[:, 1, 0] * M[:, 2, 1] - M[:, 1, 1] * M[:, 2, 0]))

def residual_jac(X, Y, target):
    """X: complex array (2,3,3,8); Y: (m,8) points; target: (m,) values.  r = det A(y) + det B(y) - target."""
    m = Y.shape[0]
    r = -target.copy(); J = np.empty((m, 2, 3, 3, 8), dtype=complex)
    for s in range(2):
        M = np.einsum("ijv,kv->kij", X[s], Y)
        r += det3(M)
        cof = np.transpose(adj3(M), (0, 2, 1))                    # cofactor matrix: d det / d M_ij
        J[:, s] = cof[:, :, :, None] * Y[:, None, None, :]
    return r, J.reshape(m, 144)

def solve(target_fn, rng, X0=None, m=260, iters=400, tol=1e-13, scale=0.6, verbose=False):
    """Levenberg-Marquardt for det A + det B = target on m random points.  Returns (X, residual norm, iterations)."""
    Y = (rng.standard_normal((m, 8)) + 1j * rng.standard_normal((m, 8))) / np.sqrt(2)
    t = target_fn(Y)
    X = X0.copy() if X0 is not None else scale * (rng.standard_normal((2, 3, 3, 8)) + 1j * rng.standard_normal((2, 3, 3, 8)))
    mu = 1e-2
    r, J = residual_jac(X, Y, t); f = np.linalg.norm(r)
    for it in range(iters):
        JH = J.conj().T
        H = JH @ J; g = JH @ r
        while True:
            try:
                d = -np.linalg.solve(H + mu * np.eye(144), g)
            except np.linalg.LinAlgError:
                mu *= 10; continue
            Xn = X + d.reshape(2, 3, 3, 8)
            rn, Jn = residual_jac(Xn, Y, t); fn = np.linalg.norm(rn)
            if fn < f or mu > 1e12: break
            mu *= 4
        if fn < f:
            X, r, J, f = Xn, rn, Jn, fn; mu = max(mu / 3, 1e-14)
        if verbose and it % 20 == 0: print(it, f, mu)
        if f < tol * np.sqrt(m) or mu > 1e12: break
    return X, f / np.sqrt(m), it + 1

def cubic_from_matrices(X, Y):
    r = np.zeros(Y.shape[0], dtype=complex)
    for s in range(2):
        r += det3(np.einsum("ijv,kv->kij", X[s], Y))
    return r
