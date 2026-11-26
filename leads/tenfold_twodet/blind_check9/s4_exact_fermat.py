# Exact (Z[w]) check at the Fermat point: I_Fermat * a_delta2 = 0 in R = Q(w)[x]/(x_i^2); rank of a_delta2 on R_3 (mod p lower bound)
import itertools
from fermat import *
W = {0: (1, 0), 1: (0, 1), 2: (-1, -1)}
def cmul(u, v):
    a, b = u; c, d = v
    return (a*c - b*d, a*d + b*c - b*d)
def padd(p, q, s=1):
    r = dict(p)
    for m, c in q.items():
        o = r.get(m, (0, 0)); n = (o[0] + s*c[0], o[1] + s*c[1])
        if n == (0, 0): r.pop(m, None)
        else: r[m] = n
    return r
def pmul(p, q):
    r = {}
    for m1, c1 in p.items():
        for m2, c2 in q.items():
            if m1 & m2: continue          # x_i^2 = 0 in R
            c = cmul(c1, c2); o = r.get(m1 | m2, (0, 0)); n = (o[0] + c[0], o[1] + c[1])
            if n == (0, 0): r.pop(m1 | m2, None)
            else: r[m1 | m2] = n
    return r
def lin(i, j, e): return {1 << i: (1, 0), 1 << j: W[e % 3]}
def aexact(pi, e):
    return {m: (s*W[ex][0], s*W[ex][1]) for m, (s, ex) in a_plane(pi, e).items()}
ZERO = {}
ad = {}
for ks, s in (((1,1,1,1,0,0), 1), ((1,1,0,2,0,0), -1), ((0,2,1,1,0,0), -1), ((0,2,0,2,0,0), 1)):
    ad = padd(ad, aexact(PI0, ks), s)
aT = {}
Lsh = [(0,0),(0,1),(1,1)]
for u in Lsh:
    for v in Lsh:
        aT = padd(aT, aexact(PI0, u + v + (0, 0)))
print("a_T5 == a_delta2 in R (exact; primitive parts of [T5] and delta_2 agree):", padd(aT, ad, -1) == ZERO, " #terms a_delta2:", len(ad))
a, c, f = lin(0,1,0), lin(0,1,1), lin(0,1,2); b, d, e = lin(2,3,0), lin(2,3,1), lin(2,3,2)
a2, c2, f2 = lin(4,5,0), lin(4,5,1), lin(4,5,2); b2, d2, e2 = lin(6,7,0), lin(6,7,1), lin(6,7,2)
A0 = [[a, b, ZERO], [ZERO, c, d], [e, ZERO, f]]; B0 = [[a2, b2, ZERO], [ZERO, c2, d2], [e2, ZERO, f2]]
def minors2(M):
    out = []
    for r1, r2 in itertools.combinations(range(3), 2):
        for c1, c2_ in itertools.combinations(range(3), 2):
            out.append(padd(pmul(M[r1][c1], M[r2][c2_]), pmul(M[r1][c2_], M[r2][c1]), -1))
    return out
l1 = {1 << 8: (1, 0), 1 << 9: (1, 0)}; l2 = {1 << 10: (1, 0), 1 << 11: (1, 0)}
Q1 = {(1 << 8) | (1 << 9): (-1, 0)}; Q2 = {(1 << 10) | (1 << 11): (-1, 0)}     # mod x_i^2
gens = [l1, l2, Q1, Q2] + minors2(A0) + minors2(B0)
print("number of generators:", len(gens), " all g * a_delta2 == 0 in R (exact):", all(pmul(g, ad) == ZERO for g in gens))
print("a_delta2 != 0 in R:", ad != ZERO)
# rank of the pairing R_3 x R_3 -> R_12, (G,G') -> [G G' a], reduced mod primes p = 1 mod 3
import numpy as np
mons3 = [sum(1 << i for i in cmb) for cmb in itertools.combinations(range(12), 3)]
def rank_modp(M, p):
    M = M.copy() % p; rk = 0; n, m = M.shape
    for col in range(m):
        piv = np.nonzero(M[rk:, col])[0]
        if len(piv) == 0: continue
        pr = rk + piv[0]; M[[rk, pr]] = M[[pr, rk]]
        M[rk] = (M[rk] * pow(int(M[rk, col]), p - 2, p)) % p
        rows = np.nonzero(M[:, col])[0]; rows = rows[rows != rk]
        M[rows] = (M[rows] - np.outer(M[rows, col], M[rk])) % p
        rk += 1
        if rk == n: break
    return rk
def pairing_rank(apoly, p, w):
    B = np.zeros((220, 220), dtype=np.int64)
    for i, g in enumerate(mons3):
        for j, h in enumerate(mons3):
            if g & h: continue
            cf = apoly.get(FULL ^ (g | h))
            if cf: B[i, j] = (cf[0] + cf[1]*w) % p
    return rank_modp(B, p)
for p in (30013, 20011, 1000003):
    w = next(t for t in range(2, p) if pow(t, 3, p) == 1)
    print("p =", p, " rank of mult. by a_delta2 on R_3:", pairing_rank(ad, p, w),
          "; single plane:", pairing_rank(aexact(PI0, (0,)*6), p, w),
          "; P1-P2 (same pairing, 3 exps differ):", pairing_rank(padd(aexact(PI0, (0,)*6), aexact(PI0, (1,1,1,0,0,0)), -1), p, w))
