#!/usr/bin/env python3
"""Blind check 12, claims C2, C3 (and numerical side of C5): own multiprecision code (python-flint acb, 900 bits).
usage: c2_num.py DEN [NTR,NTR,...]     eps = 1/DEN, period series truncated after order NTR (default 19)
Singular values are obtained as square roots of the eigenvalues of the Gram matrix (flint approximate QR at 900 bits);
"relative" = divided by the largest singular value of the same matrix.
"""
import sys, json, itertools, time, random, os
from flint import acb, arb, acb_mat, fmpq, ctx
import sympy
ctx.prec = 900
REPO = "/home/claude/hodgelocici/leads/tenfold_twodet/matrices"
den = int(sys.argv[1])
NTRS = [int(a) for a in sys.argv[2].split(",")] if len(sys.argv) > 2 else [19]
eps = fmpq(1, den)
feps = 1.0 / den
zc = acb(arb(1) / 2, arb(3).sqrt() / 2)
t0 = time.time()
def fl(x): return float(x)
def fa(x): return float(abs(x))

mons2 = list(itertools.combinations_with_replacement(range(8), 2)); i2 = {m: k for k, m in enumerate(mons2)}
mons3 = list(itertools.combinations_with_replacement(range(8), 3)); i3 = {m: k for k, m in enumerate(mons3)}
def expo(m):
    e = [0] * 8
    for i in m: e[i] += 1
    return tuple(e)

# ---------------------------------------------------------------- data
def pq(s):
    s = s.strip()
    if "/" in s:
        a, b = s.split("/"); return fmpq(int(a), int(b))
    return fmpq(int(s))
series = {}
for l in open(REPO + "/periods_deg4_order19.txt"):
    if l.startswith("#") or not l.strip(): continue
    parts = [p.strip() for p in l.split(";")]
    beta = tuple(int(a) for a in parts[0].strip("{}").split(","))
    series[beta] = [(pq(p.split()[0]), pq(p.split()[1])) for p in parts[1:] if p]

def tocomplex(a, b): return acb(arb(a)) + acb(arb(b)) * zc
def lam_at(ntr):
    out = {}
    for beta, vals in series.items():
        a = fmpq(0); b = fmpq(0); p = fmpq(1)
        for n in range(ntr + 1):
            a += vals[n][0] * p; b += vals[n][1] * p; p *= eps
        out[beta] = tocomplex(a, b)
    return out

# F_eps from the arc file (exact, then complex)
xs = sympy.symbols("x_0:8"); zs = sympy.Symbol("z")
Fq = {}
for i in range(8): Fq[(i, i, i)] = (fmpq(1), fmpq(0))
lines = [l.strip() for l in open(REPO + "/arc_true_order19.txt") if l.strip() and not l.startswith("#")]
pw = fmpq(1)
for n, l in enumerate(lines, 1):
    pw *= eps
    p = sympy.Poly(sympy.expand(sympy.sympify(l, locals={**{"x_%d" % i: xs[i] for i in range(8)}, "z": zs})), *xs, zs)
    for mon, c in p.terms():
        ex, zd = mon[:8], mon[8]
        m = tuple(i for i in range(8) for _ in range(ex[i]))
        u, v = fmpq(1), fmpq(0)
        for _ in range(zd): u, v = -v, u + v
        c = fmpq(int(c.p), int(c.q)) * pw
        A, B = Fq.get(m, (fmpq(0), fmpq(0)))
        Fq[m] = (A - c * u, B - c * v)
Fv = [acb(0)] * 120
for m, (a, b) in Fq.items(): Fv[i3[m]] = tocomplex(a, b)

# ---------------------------------------------------------------- linear algebra helpers
def norm(v): return sum((abs(x) ** 2 for x in v), arb(0)).sqrt()
def colmat(v): return acb_mat(len(v), 1, list(v))
def matvec(M, v):
    r = M * colmat(v)
    return [r[i, 0] for i in range(M.nrows())]
def gram_eig(M, vectors=False):
    """singular values (ascending, as arb) of M with ncols <= nrows preferred; right singular vectors as columns."""
    H = M.conjugate().transpose() * M
    n = H.nrows()
    if vectors:
        ev, R = H.eig(right=True, algorithm="approx")
    else:
        ev = H.eig(algorithm="approx"); R = None
    order = sorted(range(n), key=lambda i: fl(ev[i].real))
    sv = [abs(ev[i].real).sqrt() for i in order]
    if vectors:
        cols = [[R[r, i] for r in range(n)] for i in order]
        return sv, cols
    return sv
def hdot(u, v): return sum((a.conjugate() * b for a, b in zip(u, v)), acb(0))
def proj(Wcols, g):
    out = [acb(0)] * len(g)
    for w in Wcols:
        c = hdot(w, g)
        out = [o + c * x for o, x in zip(out, w)]
    return out
def dist(Wcols, g):
    p = proj(Wcols, g)
    return fl(norm([a - b for a, b in zip(g, p)]) / norm(g))

# derivative matrices D_i : cubics (120) -> quadrics (36)
Dm = []
for i in range(8):
    rows = [[0] * 120 for _ in range(36)]
    for k, m in enumerate(mons3):
        c = m.count(i)
        if c:
            q = list(m); q.remove(i)
            rows[i2[tuple(q)]][k] = c
    Dm.append(acb_mat(rows))

def liemat(G):
    """120 x 64 matrix of L -> sum L_ij y_i dG/dy_j"""
    cols = []
    for i in range(8):
        for j in range(8):
            col = [acb(0)] * 120
            for k, m in enumerate(mons3):
                c = m.count(j)
                if c:
                    q = list(m); q.remove(j); q.append(i)
                    kk = i3[tuple(sorted(q))]
                    col[kk] = col[kk] + c * G[k]
            cols.append(col)
    return acb_mat([[cols[c][r] for c in range(64)] for r in range(120)])
def lie_sv(G, vectors=False):
    M = liemat(G)
    if vectors:
        sv, cols = gram_eig(M, True)
        return [fl(s / sv[-1]) for s in sv], cols
    sv = gram_eig(M)
    return [fl(s / sv[-1]) for s in sv]
def fmt(lst): return " ".join("%.3e" % x for x in lst)

# ---------------------------------------------------------------- json
jpath = REPO + "/results/mx4_eps%d.json" % den
J = json.load(open(jpath)) if os.path.exists(jpath) else None
def jvec(key):
    return [acb(arb(a), arb(b)) for a, b in J[key]]
if J:
    GA, GB, FJ = jvec("GA"), jvec("GB"), jvec("F")
    print("json eps:", J["eps"], " keys:", sorted(J.keys()))
    print("json F vs own F_eps (arc file):  |F_json - F_own| / |F_own| = %.3e" % fl(norm([a - b for a, b in zip(FJ, Fv)]) / norm(Fv)))
    print("|GA + GB - F_eps| / |F_eps| = %.3e      |GA + GB - F_eps| / |GA| = %.3e" % (
        fl(norm([a + b - c for a, b, c in zip(GA, GB, Fv)]) / norm(Fv)), fl(norm([a + b - c for a, b, c in zip(GA, GB, Fv)]) / norm(GA))))
    print("|GA| eps^6 = %.6f   |GB| eps^6 = %.6f   |F_eps| = %.6f" % (fl(norm(GA)) * feps ** 6, fl(norm(GB)) * feps ** 6, fl(norm(Fv))))

y5cube = [acb(0)] * 120; y5cube[i3[(5, 5, 5)]] = acb(1)
random.seed(12)

for ntr in NTRS:
    print("\n================ eps = 1/%d, period series truncated after order %d ================" % (den, ntr))
    lam = lam_at(ntr)
    C = acb_mat([[lam[tuple(a + b for a, b in zip(expo(ma), expo(mb)))] for mb in mons2] for ma in mons2])
    svC, VC = gram_eig(C, True)
    s = [fl(x) for x in svC][::-1]
    print("C2(a) catalecticant singular values (descending):")
    print("   12 largest :", fmt(s[:12]))
    print("   next 6     :", fmt(s[12:18]), "   divided by eps^2:", " ".join("%.3f" % (x / feps ** 2) for x in s[12:18]))
    print("   last 18    :", fmt(s[18:]))
    print("   last 18 divided by eps^%d: %s" % (ntr + 1, " ".join("%.3g" % (x / feps ** (ntr + 1)) for x in s[18:])))
    k55 = i2[(5, 5)]
    print("C2(b) column of y5^2 in the catalecticant: max |entry| = %.3e (exact zeros in the file)" % max(fa(C[r, k55]) for r in range(36)))
    Vlarge = VC[18:]          # 18 right singular vectors with the large singular values
    Vsmall = VC[:18]
    VlH = acb_mat([[x.conjugate() for x in v] for v in Vlarge])     # 18 x 36
    e55 = [acb(0)] * 36; e55[k55] = acb(1)
    print("      distance of y5^2 from the span of the 18 small singular vectors: %.3e" % fl(norm(matvec(VlH, e55))))
    rows = []
    for i in range(8):
        rows += (VlH * Dm[i]).tolist()
    M = acb_mat(rows)                                               # 144 x 120
    svM, WM = gram_eig(M, True)
    sm = [fl(x) for x in svM]
    print("      144 x 120 system: smallest singular values:", fmt(sm[:8]), "  largest: %.3e" % sm[-1], "  time %.0fs" % (time.time() - t0))
    W = WM[:3]
    print("      distance from the 3-dim space W:  y5^3: %.3e   F_eps: %.3e" % (dist(W, y5cube), dist(W, Fv)))
    print("      |M y5^3| = %.3e   |M F_eps|/|F_eps| = %.3e" % (fl(norm(matvec(M, y5cube))), fl(norm(matvec(M, Fv)) / norm(Fv))))
    # a general member of W
    g = [acb(0)] * 120
    for w in W:
        c = acb(random.gauss(0, 1), random.gauss(0, 1))
        g = [a + c * x for a, x in zip(g, w)]
    lg = lie_sv(g)
    print("C2(c) random member of W: smallest relative singular values of the Lie map:", fmt(lg[:4]))
    lf = lie_sv(Fv)
    print("      F_eps itself: smallest:", fmt(lf[:3]), "   y5^3: number of exactly-zero directions is 56 (trivially)")
    if J:
        print("      distance from W:  GA: %.3e   GB: %.3e" % (dist(W, GA), dist(W, GB)))
        print("      |M GA|/|GA| = %.3e   |M GB|/|GB| = %.3e" % (fl(norm(matvec(M, GA)) / norm(GA)), fl(norm(matvec(M, GB)) / norm(GB))))
        for name, G in (("GA", GA), ("GB", GB)):
            Gp = G if ntr == 19 else proj(W, G)
            tag = "json" if ntr == 19 else "json projected to W(ntr=%d)" % ntr
            sv = lie_sv(Gp)
            print("C2(c,d) %s (%s): 20 smallest relative singular values of the Lie map (ascending):" % (name, tag))
            print("      ", fmt(sv[:8])); print("      ", fmt(sv[8:20]))
            print("       9th = %.4e = eps^%.2f   8th = %.3e = eps^%.2f   ratio 9th/8th = %.3g" % (
                sv[8], __import__("math").log(sv[8]) / __import__("math").log(feps), sv[7],
                __import__("math").log(sv[7]) / __import__("math").log(feps), sv[8] / sv[7]))
            if ntr == 19:
                Gq = proj(W, G)
                sv2 = lie_sv(Gq)
                print("       (same after projecting to own W: 8th %.3e, 9th %.4e)" % (sv2[7], sv2[8]))
        if ntr == 19:
            print("      json lie_singular_values_A (as stored):", J["lie_singular_values_A"])
            print("      json lie_singular_values_B (as stored):", J["lie_singular_values_B"])
    sys.stdout.flush()

    # ------------------------------------------------------------ C3
    dv = None
    if J and ntr == 19 and J.get("A"):
        A = [[[acb(arb(a), arb(b)) for a, b in J["A"][i][j]] for j in range(3)] for i in range(3)]
        def mul_lin(p, l, deg):
            # p: dict sorted-tuple -> acb ; multiply by linear form l
            out = {}
            for m, c in p.items():
                for k in range(8):
                    mm = tuple(sorted(m + (k,)))
                    out[mm] = out.get(mm, acb(0)) + c * l[k]
            return out
        def lin(l): return {(k,): l[k] for k in range(8)}
        det = {}
        for perm, sgn in (((0, 1, 2), 1), ((1, 2, 0), 1), ((2, 0, 1), 1), ((0, 2, 1), -1), ((2, 1, 0), -1), ((1, 0, 2), -1)):
            p = mul_lin(mul_lin(lin(A[0][perm[0]]), A[1][perm[1]], 2), A[2][perm[2]], 3)
            for m, c in p.items(): det[m] = det.get(m, acb(0)) + sgn * c
        dv = [det.get(m, acb(0)) for m in mons3]
        print("C3  |det A - GA| / |GA| = %.3e      (|det A| eps^6 = %.4f)" % (fl(norm([a - b for a, b in zip(dv, GA)]) / norm(GA)), fl(norm(dv)) * feps ** 6))
        print("    distance of det A from W: %.3e" % dist(W, dv))
        minors = []
        for i in range(3):
            for j in range(3):
                r = [a for a in range(3) if a != i]; c = [a for a in range(3) if a != j]
                p1 = mul_lin(lin(A[r[0]][c[0]]), A[r[1]][c[1]], 2); p2 = mul_lin(lin(A[r[0]][c[1]]), A[r[1]][c[0]], 2)
                minors.append([p1.get(m, acb(0)) - p2.get(m, acb(0)) for m in mons2])
        dd = [fl(norm(matvec(VlH, q)) / norm(q)) for q in minors]
        print("    2x2 minors: relative distance from the kernel (span of 18 small singular vectors): max %.3e  min %.3e" % (max(dd), min(dd)))
        Mm = acb_mat([[q[k] / norm(q) for q in minors] for k in range(36)])     # 36 x 9, unit columns
        svm = [fl(x) for x in gram_eig(Mm)]
        print("    nine minors (normalised): singular values ascending:", fmt(svm))
        N = acb_mat([[A[i][j][k] for (i, j) in itertools.product(range(3), repeat=2)] for k in range(8)])   # 8 x 9
        NH = N.conjugate().transpose()                                             # 9 x 8
        sv8 = [fl(x) for x in gram_eig(NH)]
        print("    nine entries of A: singular values of the 9 x 8 coefficient matrix (ascending):", fmt(sv8), "  ratio min/max %.3e" % (sv8[0] / sv8[-1]))
        # the relation: vector c with sum_ij c_ij A_ij = 0  <=>  N c = 0
        svN, cols = gram_eig(N, True)                                              # Gram is 9 x 9
        cvec = cols[0]
        Cm = acb_mat([[cvec[3 * i + j] for j in range(3)] for i in range(3)])
        svc = [fl(x) for x in gram_eig(Cm)]
        print("    relation sum c_ij A_ij = 0: residual %.3e ; singular values of the 3x3 matrix (c_ij), |c| = 1: %s" % (fl(svN[0] / svN[-1]), fmt(svc)))
        print("       ratio smallest/largest = %.3e = eps^%.2f ;  det(c)/|c|^3 = %.3e" % (svc[0] / svc[-1],
              __import__("math").log(svc[0] / svc[-1]) / __import__("math").log(feps), fa(Cm.det())))
        sva = lie_sv(dv)
        print("    Lie map of det A itself: 12 smallest relative singular values:", fmt(sva[:12]))
        print("    json keys of interest: B is", "null" if J.get("B") is None else "present", "; lie_dims", J.get("lie_dims"), "; spreads", J.get("spreads"))

    # ------------------------------------------------------------ C5 (numerical side): structure of the 8 fields
    if J and ntr == 19:
        import numpy as np
        for name, G in (("GA", GA), ("GB", GB), ("detA (exact determinant of the json A)", dv)):
            if G is None: continue
            sv, cols = lie_sv(G, True)
            # orthonormalise the 8 null vectors (twice modified Gram-Schmidt): needed when the 8 eigenvalues coincide
            basis8 = []
            for v in cols[:8]:
                v = list(v)
                for _ in range(2):
                    for w in basis8:
                        c = hdot(w, v)
                        v = [x - c * y for x, y in zip(v, w)]
                nv = norm(v)
                basis8.append([x / nv for x in v])
            cols = basis8 + cols[8:]
            Ls = [acb_mat([[c[8 * i + j] for j in range(8)] for i in range(8)]) for c in cols[:8]]
            # structure constants: [L_a, L_b] = sum_c f_abc L_c  (least squares on the orthonormal basis)
            f = [[[acb(0)] * 8 for _ in range(8)] for _ in range(8)]
            worst = 0.0
            for a in range(8):
                for b in range(8):
                    Cab = Ls[a] * Ls[b] - Ls[b] * Ls[a]
                    v = [Cab[i, j] for i in range(8) for j in range(8)]
                    co = [hdot(cols[c], v) for c in range(8)]
                    rem = list(v)
                    for c in range(8):
                        rem = [x - co[c] * y for x, y in zip(rem, cols[c])]
                    nv = fl(norm(v))
                    if nv > 0: worst = max(worst, fl(norm(rem)) / max(nv, 1e-300))
                    f[a][b] = co
            K = acb_mat(8, 8)
            for a in range(8):
                for b in range(8):
                    K[a, b] = sum((f[a][c][d] * f[b][d][c] for c in range(8) for d in range(8)), acb(0))
            svk = [fl(x) for x in gram_eig(K)]
            # commutant of the 8 matrices acting on C^8
            rowsX = []
            for a in range(8):
                La = Ls[a]
                for i in range(8):
                    for j in range(8):
                        row = [acb(0)] * 64
                        for k in range(8):
                            row[8 * k + j] = row[8 * k + j] + La[i, k]      # (L X)_ij
                            row[8 * i + k] = row[8 * i + k] - La[k, j]      # (X L)_ij
                        rowsX.append(row)
            svx = [fl(x) for x in gram_eig(acb_mat(rowsX))]
            tr = max(fa(L.trace()) for L in Ls)
            print("C5 %s: closure defect of brackets (relative) %.2e ; max |trace L| %.2e" % (name, worst, tr))
            print("      Killing form singular values (ascending, orthonormal basis of fields):", fmt(svk), "  ratio %.2e" % (svk[0] / svk[-1]))
            print("      commutant of the 8 fields on C^8: smallest singular values:", fmt([x / svx[-1] for x in svx[:4]]))
    print("time %.0fs" % (time.time() - t0))
    sys.stdout.flush()
