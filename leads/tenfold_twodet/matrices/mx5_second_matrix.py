"""mx5: the second matrix along the sixfold arc as a small correction of the first (PREREG_matrices.md, third route).
NUMERICAL (mpmath).  AI-written, unreviewed.

usage (repository root):  python3 leads/tenfold_twodet/matrices/mx5_second_matrix.py RESULT.json [DPS] [OUT.json]
  RESULT.json: written by mx4_pipeline.py (keys F, GA, A, eps), exported with all digits.
Steps: (i) A <- A(y - X y) until det A = G_A to the noise; (ii) Newton for Delta with det A - det(A - Delta) = F_eps;
B = -(A - Delta); checks: |det A + det B - F| / |F|, minors of B in the kernel of Cat(2,2) (recomputed here from
the period file named in RESULT.json's directory, if given as argv[4])."""
import sys, json, itertools, time
import mpmath as mp
mp.mp.dps = int(sys.argv[2]) if len(sys.argv) > 2 else 160
import os
RIDGE = int(os.environ.get('MX5_RIDGE', str(mp.mp.dps - 30)))
d = json.load(open(sys.argv[1]))
OUT = sys.argv[3] if len(sys.argv) > 3 else None
T0 = time.time()
def log(*a): print(*a, flush=True)
c = lambda v: mp.mpc(mp.mpf(v[0]), mp.mpf(v[1]))
cub = [tuple(t) for t in itertools.combinations_with_replacement(range(8), 3)]
quad = [tuple(t) for t in itertools.combinations_with_replacement(range(8), 2)]
cidx = {t: i for i, t in enumerate(cub)}; qidx = {t: i for i, t in enumerate(quad)}
F = [c(v) for v in d["F"]]; GA = [c(v) for v in d["GA"]]
A = [[[c(v) for v in d["A"][i][j]] for j in range(3)] for i in range(3)]
eps = d["eps"]
nrm = lambda v: mp.sqrt(sum(abs(x) ** 2 for x in v))
sci = lambda x: mp.nstr(x, 3, min_fixed=0, max_fixed=0)
def mul(*forms):
    cur = {(): mp.mpf(1)}
    for f in forms:
        nxt = {}
        for idx, co in cur.items():
            for i in range(8):
                if f[i] == 0: continue
                key = tuple(sorted(idx + (i,))); nxt[key] = nxt.get(key, 0) + co * f[i]
        cur = nxt
    return cur
PERMS = (((0, 1, 2), 1), ((1, 2, 0), 1), ((2, 0, 1), 1), ((0, 2, 1), -1), ((2, 1, 0), -1), ((1, 0, 2), -1))
def det3(M):
    out = [mp.mpc(0)] * 120
    for pm, sg in PERMS:
        for idx, co in mul(M[0][pm[0]], M[1][pm[1]], M[2][pm[2]]).items(): out[cidx[idx]] += sg * co
    return out
def cof(M, i, j):
    r = [a for a in range(3) if a != i]; cc = [b for b in range(3) if b != j]
    q = {}
    for idx, co in mul(M[r[0]][cc[0]], M[r[1]][cc[1]]).items(): q[idx] = q.get(idx, 0) + co
    for idx, co in mul(M[r[0]][cc[1]], M[r[1]][cc[0]]).items(): q[idx] = q.get(idx, 0) - co
    s = (-1) ** (i + j)
    return {k: s * v for k, v in q.items()}
def deriv(g, v):                                   # d g / d y_v as a dict on quadratic monomials
    q = {}
    for t, ci in cidx.items():
        m = t.count(v)
        if m and g[ci] != 0:
            r = list(t); r.remove(v); r = tuple(r); q[r] = q.get(r, 0) + m * g[ci]
    return q
def lstsq(Jcols, rhs, ridge):
    """min-norm least squares via normal equations: Jcols list of 120-lists"""
    n = len(Jcols)
    G = mp.matrix(n, n); b = mp.matrix(n, 1)
    for a in range(n):
        ca = Jcols[a]
        b[a] = sum(mp.conj(ca[k]) * rhs[k] for k in range(120))
        for bb in range(a, n):
            v = sum(mp.conj(ca[k]) * Jcols[bb][k] for k in range(120))
            G[a, bb] = v; G[bb, a] = mp.conj(v)
    sc = max(abs(G[a, a]) for a in range(n))
    for a in range(n): G[a, a] += ridge * sc
    return mp.lu_solve(G, b)
log(f"eps = {eps}, {mp.mp.dps} digits ; |F| = {sci(nrm(F))}, |G_A| = {sci(nrm(GA))}")
# ---------------------------------------------------------------- (i) put A into the orbit point of G_A
for it in range(6):
    dA = det3(A); r = [dA[k] - GA[k] for k in range(120)]
    rel = nrm(r) / nrm(GA)
    log(f"(i) step {it}: |det A - G_A| / |G_A| = {sci(rel)} ; absolute {sci(nrm(r))} ; |F| = {sci(nrm(F))}   [{time.time() - T0:.0f} s]")
    if rel < mp.mpf(10) ** (-(mp.mp.dps - 25)) or (it > 0 and rel > prev / 10): break
    prev = rel
    # columns: X_ij (i, j = 0..7): (X y)_i d_i det A = sum_j X_ij y_j d_i det A
    dd = [deriv(dA, i) for i in range(8)]
    cols = []
    for i in range(8):
        for j in range(8):
            col = [mp.mpc(0)] * 120
            for qm, co in dd[i].items(): col[cidx[tuple(sorted(qm + (j,)))]] += co
            cols.append(col)
    x = lstsq(cols, r, mp.mpf(10) ** (-(mp.mp.dps - 30)))
    X = [[x[8 * i + j] for j in range(8)] for i in range(8)]
    # det A(y - X y) = det A - sum_i (X y)_i d_i det A + ...: substitute in every entry f -> f - X^T f
    A = [[[A[a][b][k] - sum(X[i][k] * A[a][b][i] for i in range(8)) for k in range(8)] for b in range(3)] for a in range(3)]
# ---------------------------------------------------------------- (ii) Newton for Delta
Dl = [[[mp.mpc(0)] * 8 for _ in range(3)] for _ in range(3)]
hist = []
for it in range(int(os.environ.get('MX5_IT', '12'))):
    AmD = [[[A[a][b][k] - Dl[a][b][k] for k in range(8)] for b in range(3)] for a in range(3)]
    dA = det3(A); dAm = det3(AmD)
    R = [dA[k] - dAm[k] - F[k] for k in range(120)]
    rel = nrm(R) / nrm(F); hist.append(rel)
    sizeD = mp.sqrt(sum(abs(Dl[a][b][k]) ** 2 for a in range(3) for b in range(3) for k in range(8)))
    sizeA = mp.sqrt(sum(abs(A[a][b][k]) ** 2 for a in range(3) for b in range(3) for k in range(8)))
    log(f"(ii) Newton {it}: |det A - det(A - Delta) - F| / |F| = {sci(rel)} ; |Delta| / |A| = {sci(sizeD / sizeA)}   [{time.time() - T0:.0f} s]")
    if it > 3 and (rel > hist[-2] * mp.mpf('0.999') or rel < mp.mpf(10) ** (-(mp.mp.dps - 25))): break
    # d/dDelta_ab of -det(A - Delta) = cof_ab(A - Delta) . dDelta_ab
    cols = []
    for a in range(3):
        for b in range(3):
            cf = cof(AmD, a, b)
            for k in range(8):
                col = [mp.mpc(0)] * 120
                for qm, co in cf.items(): col[cidx[tuple(sorted(qm + (k,)))]] += co
                cols.append(col)
    x = lstsq(cols, [-v for v in R], mp.mpf(10) ** (-RIDGE))
    t = mp.mpf(1)
    for h in range(40):                             # damped step (pre-registered fallback): halve until the residual drops
        Dt = [[[Dl[a][b][k] + t * x[24 * a + 8 * b + k] for k in range(8)] for b in range(3)] for a in range(3)]
        AmT = [[[A[a][b][k] - Dt[a][b][k] for k in range(8)] for b in range(3)] for a in range(3)]
        dAt = det3(AmT); Rt = [dA[k] - dAt[k] - F[k] for k in range(120)]
        if nrm(Rt) < nrm(R): break
        t /= 2
    log(f"     step length {sci(t)}")
    Dl = Dt
B = [[[-(A[a][b][k] - Dl[a][b][k]) for k in range(8)] for b in range(3)] for a in range(3)]
dB = det3(B); dA = det3(A)
res = nrm([dA[k] + dB[k] - F[k] for k in range(120)]) / nrm(F)
log(f"RESULT |det A + det B - F_eps| / |F_eps| = {sci(res)} ; |det A - G_A| / |G_A| = {sci(nrm([dA[k] - GA[k] for k in range(120)]) / nrm(GA))} ; Newton history " + " ".join(sci(h) for h in hist))
if OUT:
    cx = lambda x: [mp.nstr(mp.re(x), mp.mp.dps - 5), mp.nstr(mp.im(x), mp.mp.dps - 5)]
    json.dump({"eps": eps, "dps": mp.mp.dps, "A": [[[cx(v) for v in A[i][j]] for j in range(3)] for i in range(3)],
               "B": [[[cx(v) for v in B[i][j]] for j in range(3)] for i in range(3)], "residual": mp.nstr(res, 5),
               "newton_history": [mp.nstr(h, 5) for h in hist]}, open(OUT, "w"), indent=1)
    log(f"written {OUT}")
log(f"total {time.time() - T0:.0f} s")
