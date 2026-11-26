#!/usr/bin/env python3
"""R2, R3 of PREREG_twodet.md: exact intersection numbers of the linear spaces of half dimension on a Fermat cubic,
and the class of the two-determinant family there.  AI-written, unreviewed.
usage:  python3 fermat_planes.py validate | python3 fermat_planes.py scan NPTS      (NPTS = 8, 10, 12: sixfold, eightfold, tenfold)
A plane is (pairing M of the NPTS coordinates, exponents e): x_i + w^e x_j = 0 for each pair i < j, w a cube root of 1.
Two planes meet in a P^(c-1), c = number of cycles of the union of the two pairings around which the equations are
consistent (sum of +-e = 0 mod 3); their intersection number is f(m) = (1 - (-2)^(m+1))/3."""
import sys, itertools, math
from collections import Counter
import numpy as np

def f(m): return (1 - (-2) ** (m + 1)) // 3
def pairings(s):
    if not s:
        yield (); return
    a = s[0]
    for b in s[1:]:
        rest = [x for x in s if x != a and x != b]
        for p in pairings(rest): yield ((a, b),) + p

class Fermat:
    def __init__(self, npts):
        self.n, self.k = npts, npts // 2
        self.M = list(pairings(list(range(npts))))
        self.mi = {m: i for i, m in enumerate(self.M)}
        self.E = np.array(list(itertools.product(range(3), repeat=self.k)), dtype=np.int64)     # all exponent vectors
        self.lut = np.array([f(m) for m in range(-1, self.k)], dtype=np.int64)                  # index = number of consistent cycles
        self.part = []
        for m in self.M:
            p = {}
            for idx, (a, b) in enumerate(m): p[a] = (b, idx); p[b] = (a, idx)
            self.part.append(p)
    def eidx(self, e): return int(sum(v * 3 ** (self.k - 1 - i) for i, v in enumerate(e)))
    def cycles(self, i0, i1):
        p0, p1 = self.part[i0], self.part[i1]; seen = set(); out = []
        for v in range(self.n):
            if v in seen: continue
            c0 = np.zeros(self.k, dtype=np.int64); c1 = np.zeros(self.k, dtype=np.int64); u = v
            while True:
                seen.add(u); w, a = p0[u]; c0[a] += -1 if u < w else 1
                seen.add(w); u2, b = p1[w]; c1[b] += -1 if w < u2 else 1
                u = u2
                if u == v: break
            out.append((c0, c1))
        return out
    def pair_all(self, i0, e0):
        """intersection numbers of the plane (M[i0], e0) with all planes: array (number of pairings, 3^k)"""
        e0 = np.array(e0, dtype=np.int64); res = np.empty((len(self.M), len(self.E)), dtype=np.int64)
        for i1 in range(len(self.M)):
            cnt = np.zeros(len(self.E), dtype=np.int64)
            for c0, c1 in self.cycles(i0, i1): cnt += ((self.E @ c1 + int(e0 @ c0)) % 3 == 0)
            res[i1] = self.lut[cnt]
        return res
    def dim_meet(self, P, Q):
        return sum(1 for c0, c1 in self.cycles(P[0], Q[0]) if (int(np.array(P[1]) @ c0) + int(np.array(Q[1]) @ c1)) % 3 == 0) - 1

def validate():
    # (1) the 405 planes of the Fermat fourfold: cycle method against ranks of the linear systems
    X = Fermat(6); w = np.exp(2j * np.pi / 3); bad = 0; tot = 0
    def mat(i, e):
        A = np.zeros((3, 6), complex)
        for r, ((a, b), ee) in enumerate(zip(X.M[i], e)): A[r, a] = 1; A[r, b] = w ** int(ee)
        return A
    rng = np.random.default_rng(1)
    for _ in range(4000):
        i, j = rng.integers(0, len(X.M), 2); e, g = X.E[rng.integers(0, 27)], X.E[rng.integers(0, 27)]
        m_rank = 5 - np.linalg.matrix_rank(np.vstack([mat(i, e), mat(j, g)]), tol=1e-9)
        tot += 1; bad += (m_rank != X.dim_meet((i, e), (j, g)))
    print("validate (1): fourfold, 4000 random pairs of planes, cycle method against ranks: mismatches", bad, "of", tot)
    G = X.pair_all(0, (0, 0, 0)); print("            values of P.P' on the fourfold:", dict(Counter(G.flatten().tolist())), "(3 = self, -1 line, 1 point, 0 disjoint)")

def scan(npts):
    X = Fermat(npts); k = X.k; i0 = X.mi[tuple((2 * i, 2 * i + 1) for i in range(k))]
    print("Fermat cubic of dimension %d: %d pairings x %d exponent vectors = %d planes of dimension %d; f = %s"
          % (npts - 2, len(X.M), len(X.E), len(X.M) * len(X.E), k - 1, [f(m) for m in range(-1, k)]))
    fixed = (0,) * (k - 4); S = [(0, 0), (0, 1), (1, 1)]
    Tpl = [a + b + fixed for a in S for b in S]                               # the 9 planes of T
    ap, am = (1, 1), (0, 2)
    D2 = [(ap + ap + fixed, 1), (ap + am + fixed, -1), (am + ap + fixed, -1), (am + am + fixed, 1)]
    Tvec = sum(X.pair_all(i0, e) for e in Tpl)
    dvec = sum(s * X.pair_all(i0, e) for e, s in D2)
    TT = sum(int(Tvec[i0, X.eidx(e)]) for e in Tpl); dd = sum(s * int(dvec[i0, X.eidx(e)]) for e, s in D2)
    print("R2: T.T = %d ; T.h = %d ; [T] - 3h and the second difference of four planes have the same pairing with every plane: %s ; delta_2^2 = %d"
          % (TT, len(Tpl), bool(np.array_equal(Tvec - 3, dvec)), dd))
    vals = Counter(dvec.flatten().tolist())
    print("    values of delta_2 . P over all planes:", dict(sorted(vals.items())))
    g = 0
    for v in vals: g = math.gcd(g, abs(v))
    print("    gcd of these values: %d ; an odd value occurs: %s ; all values are 0 mod 3: %s" % (g, any(v % 2 for v in vals), all(v % 3 == 0 for v in vals)))
    # R3: is delta_2 = [P1] - [P2] ?
    half = dd // 2; selfint = f(k - 1)
    cand = np.argwhere(dvec == half)
    print("R3: planes with delta_2 . P = delta_2^2 / 2 = %d: %d" % (half, len(cand)))
    found = []; tested = 0
    for i1, j1 in cand[:400]:
        tested += 1; e1 = tuple(int(v) for v in X.E[j1]); target = X.pair_all(int(i1), e1) - dvec
        pos = np.argwhere(target == selfint)
        for i2, j2 in pos:
            e2 = tuple(int(v) for v in X.E[j2])
            if np.array_equal(X.pair_all(int(i2), e2), target):
                found.append(((int(i1), e1), (int(i2), e2)))
    print("    candidates tested: %d ; pairs (P1, P2) with [P1] - [P2] = delta_2 (equal pairings with all planes): %d" % (tested, len(found)))
    types = Counter()
    for P1, P2 in found:
        cyc = sorted(int(abs(c0).sum()) * 2 for c0, c1 in X.cycles(P1[0], P2[0]))
        types[(tuple(cyc), X.dim_meet(P1, P2), X.M[P1[0]] == X.M[i0], X.M[P2[0]] == X.M[i0])] += 1
    for t, c in sorted(types.items(), key=lambda x: -x[1])[:8]:
        print("    type: cycle lengths of the two pairings %s, P1 n P2 = P^%d, P1 / P2 in the pairing of the family: %s / %s : %d pairs" % (t[0], t[1], t[2], t[3], c))
    if found:
        P1, P2 = found[0]; print("    example: P1 =", X.M[P1[0]], P1[1], "; P2 =", X.M[P2[0]], P2[1])
    return X

def kappa():
    # R4: the three-plane class kappa = h^5 - P_1 - P_2 - P_3 of C-TENFOLD-FERMAT-POINT-CLASS on the Fermat tenfold
    X = Fermat(12); i0 = X.mi[tuple((2 * i, 2 * i + 1) for i in range(6))]
    pl = [(0, 0, 0, e, e, e) for e in range(3)]
    kv = 1 - sum(X.pair_all(i0, e) for e in pl)
    kk = 3 - 2 * 3 + sum(int((X.pair_all(i0, e))[i0, X.eidx(g)]) for e in pl for g in pl)       # h.h - 2 sum h.P + sum P.P'
    print("R4: pairwise intersections of the three planes: P^%d ; kappa^2 = %d ; kappa . h^5 = 0" % (X.dim_meet((i0, pl[0]), (i0, pl[1])), kk))
    vals = Counter(kv.flatten().tolist()); g = 0
    for v in vals: g = math.gcd(g, abs(v))
    print("    values of kappa . P over all planes:", dict(sorted(vals.items())))
    print("    gcd %d ; a value +-1 occurs: %s ; planes with kappa . P = -24 (needed for a two-plane class): %d" % (g, (1 in vals) or (-1 in vals), vals.get(-24, 0)))

if __name__ == "__main__":
    if sys.argv[1] == "validate": validate()
    elif sys.argv[1] == "kappa": kappa()
    else: scan(int(sys.argv[2]))
