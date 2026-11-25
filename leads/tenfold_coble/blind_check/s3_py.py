#!/usr/bin/env python3
# Independent (non-M2) re-derivation of S3/S4/S5 by plain linear algebra mod p (Macaulay matrices, python-flint).
# usage: s3_py.py prime seed mode      mode = generic | special
import sys, random, itertools
from math import comb
import flint

def monos(nv, d):
    out = []
    def rec(i, left, cur):
        if i == nv - 1:
            out.append(tuple(cur + [left])); return
        for e in range(left, -1, -1):
            rec(i + 1, left - e, cur + [e])
    rec(0, d, [])
    return out

def padd(f, g, p, c=1):
    r = dict(f)
    for e, v in g.items():
        r[e] = (r.get(e, 0) + c * v) % p
    return {e: v for e, v in r.items() if v}

def pmul(f, g, p):
    r = {}
    for e1, c1 in f.items():
        for e2, c2 in g.items():
            e = tuple(a + b for a, b in zip(e1, e2))
            r[e] = (r.get(e, 0) + c1 * c2) % p
    return {e: c for e, c in r.items() if c}

def pscale(f, c, p):
    return {e: (v * c) % p for e, v in f.items() if (v * c) % p}

def pdiff(f, i, p):
    r = {}
    for e, c in f.items():
        if e[i]:
            t = list(e); t[i] -= 1
            r[tuple(t)] = (r.get(tuple(t), 0) + c * e[i]) % p
    return {e: v for e, v in r.items() if v}

def var(i):
    e = [0] * 9; e[i] = 1
    return {tuple(e): 1}

def main():
    pr = int(sys.argv[1]); seed = int(sys.argv[2]); mode = sys.argv[3]
    rng = random.Random(seed)
    inv = lambda v: pow(v % pr, pr - 2, pr)
    Z = [var(i) for i in range(3)]; P = [var(3 + i) for i in range(3)]; Q = [var(6 + i) for i in range(3)]
    def hcub(v, lam):
        r = {}
        for i in range(3):
            r = padd(r, pmul(pmul(v[i], v[i], pr), v[i], pr), pr)
        return padd(r, pscale(pmul(pmul(v[0], v[1], pr), v[2], pr), 3 * lam, pr), pr)
    def hnum(x, lam):
        return (x[0] ** 3 + x[1] ** 3 + x[2] ** 3 + 3 * lam * x[0] * x[1] * x[2]) % pr
    while True:
        x = [rng.randrange(1, pr) for _ in range(3)]
        if mode == "generic":
            lam = rng.randrange(1, pr)
        else:
            lam = (-(x[0] ** 3 + x[1] ** 3 + x[2] ** 3) * inv(3 * x[0] * x[1] * x[2])) % pr
        if (1 + lam ** 3) % pr:
            break
    c27 = 27 * (1 + lam ** 3) % pr
    ash = (-hnum(x, lam) * inv(c27)) % pr
    print("prime %d seed %d mode %s lam %d x %s  h(x)=%d a#=%d" % (pr, seed, mode, lam, x, hnum(x, lam), ash))
    def Mx(xv):
        r = {}
        for i in range(3):
            for j in range(3):
                t = pscale(pmul(pmul(Z[(i + j) % 3], P[i], pr), Q[j], pr), xv[(i - j) % 3], pr)
                r = padd(r, t, pr)
        return r
    hz = hcub(Z, lam)
    F = padd(padd(padd(pscale(hz, ash, pr), hcub(P, lam), pr), hcub(Q, lam), pr), Mx(x), pr)
    partials = [pdiff(F, i, pr) for i in range(9)]
    m2 = monos(9, 2)
    Phi = [{m: rng.randrange(pr) for m in m2} for _ in range(3)]
    gens = partials + Phi
    if mode == "special":
        # I' as literally stated: I_V + all dF/dp_i, dF/dq_j + Phi   (h(p), h(q) are cubics)
        gens3 = [hcub(P, lam), hcub(Q, lam)]
    else:
        gens3 = []

    def macaulay(d):
        mons = monos(9, d)
        idx = {m: i for i, m in enumerate(mons)}
        rows = []
        for g, dg in [(g, 2) for g in gens] + [(g, 3) for g in gens3]:
            if d < dg:
                continue
            for m in monos(9, d - dg):
                rows.append({tuple(a + b for a, b in zip(e, m)): c for e, c in g.items()})
        M = flint.nmod_mat(len(rows), len(mons), pr)
        for r, row in enumerate(rows):
            for e, c in row.items():
                M[r, idx[e]] = c
        return M, mons, idx

    HF = [1, 9]
    delta = None
    for d in range(2, 7):
        M, mons, idx = macaulay(d)
        rk = M.rank()
        HF.append(len(mons) - rk)
        if d == 3:
            I3 = M; idx3 = idx; mons3 = mons; rk3 = rk
        if d == 6:
            X, nul = M.nullspace()
            assert nul == len(mons) - rk
            if nul == 1:
                delta = [int(X[i, 0]) for i in range(len(mons))]
            idx6 = idx
    print("Hilbert function degrees 0..6 (Macaulay-matrix ranks):", HF)
    if delta is None:
        print("A_6 not one-dimensional; stop"); return
    n = len(mons3)
    G = flint.nmod_mat(n, n, pr)
    for i, a in enumerate(mons3):
        for j, b in enumerate(mons3):
            G[i, j] = delta[idx6[tuple(u + v for u, v in zip(a, b))]]
    rkG = G.rank()
    print("rank of bilinear form on %d cubic monomials: %d ; dim I_3 = %d" % (n, rkG, rk3))
    # the cubics D
    def dMx(k):
        xv = [0, 0, 0]; xv[k] = 1
        return Mx(xv)
    def Dk(k, mult):
        coef = (3 * x[k] ** 2 + 3 * lam * x[(k + 1) % 3] * x[(k + 2) % 3]) * inv(c27) % pr
        return padd(dMx(k), pscale(hz, (-mult * coef) % pr, pr), pr)
    dadlam = (-3 * x[0] * x[1] * x[2] * inv(c27) + hnum(x, lam) * 81 * lam ** 2 * inv(c27 * c27)) % pr
    zzz = pmul(pmul(Z[0], Z[1], pr), Z[2], pr); ppp = pmul(pmul(P[0], P[1], pr), P[2], pr); qqq = pmul(pmul(Q[0], Q[1], pr), Q[2], pr)
    Dlam = padd(padd(padd(pscale(zzz, 3 * ash, pr), pscale(hz, dadlam, pr), pr), pscale(ppp, 3, pr), pr), pscale(qqq, 3, pr), pr)
    def vec(D):
        v = [0] * n
        for e, c in D.items():
            v[idx3[e]] = c
        return v
    def in_kernel(D):
        v = flint.nmod_mat(n, 1, vec(D), pr)
        w = G * v
        return all(int(w[i, 0]) == 0 for i in range(n))
    def rank_with(Dlist):
        rows = [[int(I3[r, c]) for c in range(n)] for r in range(I3.nrows())] + [vec(D) for D in Dlist]
        M = flint.nmod_mat(len(rows), n, [v for row in rows for v in row], pr)
        return M.rank()
    print("D_0,D_1,D_2 in kernel:", [in_kernel(Dk(k, 1)) for k in range(3)], " D_lam in kernel:", in_kernel(Dlam))
    print("controls: doubled h(z) coefficient in kernel:", [in_kernel(Dk(k, 2)) for k in range(3)],
          " zero h(z) coefficient:", [in_kernel(Dk(k, 0)) for k in range(3)])
    print("dim(I_3 + span D_0..D_2) = %d ; dim(I_3 + span D_0..D_2,D_lam) = %d ; kernel dim = %d"
          % (rank_with([Dk(k, 1) for k in range(3)]), rank_with([Dk(k, 1) for k in range(3)] + [Dlam]), n - rkG))

main()
