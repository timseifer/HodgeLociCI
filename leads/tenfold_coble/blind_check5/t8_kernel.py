"""
T8 probe: which (5,5)-classes of the Fermat tenfold survive along the T7 arc?
A class is given by its period polynomial (a squarefree sextic, 924 coefficients).  For every order n and form Q the
tau^n period equation is a LINEAR form in these 924 coefficients.  We stack them for n = 1..N' and compute the
kernel (MOD p): the space of period polynomials all of whose period equations vanish to order N'.
Also the same for the symmetric arc F_0 + tau*M_xi.
usage: python3 t8_kernel.py SEED NPRIME PRIME
"""
import sys, itertools, time
import numpy as np
import flint
import pcore, t7
from pcore import digits, code_of_res, NV, SH, MASK

seed = int(sys.argv[1]); N = int(sys.argv[2]); p = int(sys.argv[3]); MODE = sys.argv[4] if len(sys.argv) > 4 else "both"
Ql = pcore.standard_forms()
mus = []
for c in itertools.combinations(range(12), 6):
    e = [0] * 12
    for i in c:
        e[i] = 1
    mus.append(tuple(e))
fun = pcore.Functional(p)
allP = {mu: 1 for mu in mus}
useful = fun.useful_table([allP], Ql)

def rows_for(poly):
    """matrix (221 x 924) of Psi_{x^mu}(Q * poly)"""
    codes = digits(poly.k)
    sel = useful[codes]
    keys, vals, codes = poly.k[sel], poly.v[sel], codes[sel]
    order = np.argsort(codes, kind="stable")
    cs = codes[order]; ks = keys[order]; vs = vals[order]
    cols = [((ks >> (SH * i)) & MASK).astype(np.int64) for i in range(NV)]
    T = fun.T
    out = np.zeros((len(Ql), len(mus)), dtype=np.int64)
    for qi, q in enumerate(Ql):
        for mi, mu in enumerate(mus):
            code = code_of_res([(1 - mu[i] - q[i]) % 3 for i in range(NV)])
            lo = np.searchsorted(cs, code, side="left"); hi = np.searchsorted(cs, code, side="right")
            if hi <= lo:
                continue
            w = vs[lo:hi].copy()
            for i in range(NV):
                m = (cols[i][lo:hi] + q[i]) // 3
                w = (w * T[1 - mu[i]][m]) % p
            out[qi, mi] = int(w.sum() % p)
    return out

def kernel_dims(G, label):
    E = {0: pcore.Poly(np.array([0], dtype=np.int64), np.array([1], dtype=np.int64))}
    stack = []
    kap = pcore.kappa_poly(p)
    kvec = [kap.get(mu, 0) for mu in mus]
    for n in range(1, N + 1):
        t0 = time.time()
        invn = pow(n, p - 2, p)
        parts = [pcore.mul_small(E[n - j], G[j], p, c=(-(j * invn)) % p) for j in range(1, n + 1) if j in G]
        E[n] = pcore.add_list(parts, p)
        Mn = rows_for(E[n])
        stack.append(Mn)
        A = np.vstack(stack)
        A = A[np.any(A != 0, axis=1)]
        mat = flint.nmod_mat(A.shape[0], A.shape[1], [int(t) for t in A.flatten()], p)
        rk = mat.rank()
        # is kappa in the kernel?
        kap_ok = all(int(sum(int(a) * b for a, b in zip(row, kvec)) % p) == 0 for row in A)
        print(f"  {label}: orders 1..{n}: nonzero equations {A.shape[0]}, rank {rk}, "
              f"dim of surviving period polynomials = {924 - rk}, kappa among them: {kap_ok}  [{time.time()-t0:.0f}s]", flush=True)

xi, lam1, phis = t7.random_data(seed, p)
if MODE in ("both", "arc"):
    print(f"seed {seed}, p = {p}: T7 true arc (phi = {t7.describe(phis, p)})")
    G, a, th = t7.build_arc(p, xi, lam1, phis, N, "true")
    kernel_dims(G, "T7 arc")
if MODE in ("both", "sym"):
    print(f"seed {seed}, p = {p}: symmetric arc F_0 + tau*M_xi with the same xi")
    d = {}
    for i in range(3):
        for j in range(3):
            k = pcore.mono(pcore.Y(i + j), pcore.Pv(i), pcore.Qv(j))
            d[k] = (d.get(k, 0) + xi[(i - j) % 3]) % p
    kernel_dims({1: pcore.from_dict(d, p)}, "symmetric arc")
