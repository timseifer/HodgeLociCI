"""mx4: from the exact period series of the transported class [P1] - [P2] along the extended sixfold arc to two
3 x 3 matrices of linear forms A, B with det A + det B = F_eps, at one fixed rational eps.   NUMERICAL (mpmath).
AI-written, unreviewed.  Evidence of the weakest kind: floating point at one value of eps; never a proof.

usage (repository root):
    python3 leads/tenfold_twodet/matrices/mx4_pipeline.py EPS PERIODS ARC [N] [OUT.json] [DPS]
      EPS      a rational number, e.g. 1/16
      PERIODS  file written by mx0_export_periods.m2 (orders 0..N0)
      ARC      file written by mx3_extend_arc.m2 (terms T_1..T_N0)
      N        cut the series at this order (default: all orders in PERIODS)
      DPS      decimal digits (default 60)

Steps (see PREREG_matrices.md, second route and its implementation note):
  1. Cat(2,2) of the class at eps; singular values; Qperp = span of the 18 singular vectors with large values.
  2. cubics with all partial derivatives in the kernel of Cat(2,2): 144 x 120 system; expected nullity 2.
  3. pencil F, G'; generalized eigenvalues t with (G' - t F) killed by a linear vector field; clusters.
  4. G_A, G_B; Lie algebra of each (120 x 64 system; expected nullity 8).
  5. matrices by the method of leads/tenfold_coble/pairing/detrep_lib.m2 (eigenforms of a regular element).
  6. checks: det A = G_A, det B = G_B, det A + det B = F_eps, minors in the kernel of Cat(2,2) and spanning it.
As actually run (see PREREG_matrices.md for the history): step 2 has nullity 3 (y5^3, G_A, G_B), step 3 works on
the reduced pair modulo y5^2 y_i, clean for eps <= 1/40; step 5 gives a matrix for the first summand only; the
Gauss-Newton polish (environment variable MX4_POLISH=1) was never successful and is off by default.
Environment: MX4_CACHE=dir (cache of the two slow steps), MX4_VERBOSE=1 (list all finite eigenvalues).
"""
import sys, itertools, json, re, time
from fractions import Fraction
import mpmath as mp
import sympy

EPS = Fraction(sys.argv[1]); PERIODS = sys.argv[2]; ARCF = sys.argv[3]
NCUT = int(sys.argv[4]) if len(sys.argv) > 4 else None
OUT = sys.argv[5] if len(sys.argv) > 5 else None
mp.mp.dps = int(sys.argv[6]) if len(sys.argv) > 6 else 60
T0 = time.time()
def log(*a):
    print(*a, flush=True)
ZETA = mp.exp(mp.j * mp.pi / 3)                     # z = zeta_6
def q2c(a, b):                                      # a + b z, a and b Fractions
    return mp.mpf(a.numerator) / a.denominator + (mp.mpf(b.numerator) / b.denominator) * ZETA
def nrm(v):
    return mp.sqrt(sum(abs(x) ** 2 for x in v))
def sci(x, d=2):
    return mp.nstr(x, d + 1, min_fixed=0, max_fixed=0)

# ---------------------------------------------------------------- data
per = {}
for line in open(PERIODS):
    if line.startswith("#"): continue
    parts = line.strip().rstrip(";").split(";")
    ex = tuple(int(t) for t in parts[0].strip().strip("{}").split(","))
    per[ex] = [tuple(Fraction(t) for t in p.split()) for p in parts[1:]]
N0 = len(next(iter(per.values()))) - 1
N = N0 if NCUT is None else NCUT
assert N <= N0
lam = {}
for ex, v in per.items():
    a = sum(v[n][0] * EPS ** n for n in range(N + 1)); b = sum(v[n][1] * EPS ** n for n in range(N + 1))
    lam[ex] = q2c(a, b)
# the arc: T_1..T_N as polynomials in x_0..x_7 and z
xs = sympy.symbols("x_0:8"); zs = sympy.Symbol("z")
arc_lines = [l.strip() for l in open(ARCF) if l.strip() and not l.startswith("#")]
assert len(arc_lines) >= N
Fq = {(i, i, i): (Fraction(1), Fraction(0)) for i in range(8)}        # F_eps = sum y_i^3 - sum eps^n T_n, exact
def zred(e):                                                           # polynomial in z -> (a, b) with z^2 = z - 1
    p = sympy.Poly(e, zs); a = Fraction(0); b = Fraction(0)
    pw = [(Fraction(1), Fraction(0))]
    for k in range(1, p.degree() + 1):
        a0, b0 = pw[-1]; pw.append((-b0, a0 + b0))                     # (a + b z) z = -b + (a + b) z
    for (k,), c in p.terms():
        c = Fraction(int(c.p), int(c.q)); a += c * pw[k][0]; b += c * pw[k][1]
    return a, b
for n in range(1, N + 1):
    P = sympy.Poly(sympy.sympify(arc_lines[n - 1].replace("^", "**")), *xs)
    for mon, c in P.terms():
        idx = tuple(i for i in range(8) for _ in range(mon[i]))
        a, b = zred(c); a0, b0 = Fq.get(idx, (Fraction(0), Fraction(0)))
        Fq[idx] = (a0 - a * EPS ** n, b0 - b * EPS ** n)
quad = [tuple(c) for c in itertools.combinations_with_replacement(range(8), 2)]       # 36
cub = [tuple(c) for c in itertools.combinations_with_replacement(range(8), 3)]        # 120
qidx = {c: i for i, c in enumerate(quad)}; cidx = {c: i for i, c in enumerate(cub)}
def expo(idx):
    e = [0] * 8
    for i in idx: e[i] += 1
    return tuple(e)
Fv = mp.matrix(120, 1)
for idx, (a, b) in Fq.items(): Fv[cidx[idx]] = q2c(a, b)
log(f"eps = {EPS}, series cut at order {N} (file: {N0}), {mp.mp.dps} digits")

# ---------------------------------------------------------------- 1. the catalecticant
Cat = mp.matrix(36, 36)
for i, a in enumerate(quad):
    for j, b in enumerate(quad):
        Cat[i, j] = lam[expo(tuple(sorted(a + b)))]
U, S, V = mp.svd_c(Cat)
sv = [S[i] for i in range(36)]
log(f"1. Cat(2,2): singular values 1..12: {sci(sv[0])} .. {sci(sv[11])} | 13..18: {sci(sv[12])} .. {sci(sv[17])} | 19..36: {sci(sv[18])} .. {sci(sv[35])}")
log(f"   ratios: s13/eps^2 = {sci(sv[12] / mp.mpf(EPS.numerator) * EPS.denominator / mp.mpf(EPS.numerator) * EPS.denominator)}, s18/eps^2 = {sci(sv[17] * (mp.mpf(EPS.denominator) / EPS.numerator) ** 2)} ; gap s18/s19 = {sci(sv[17] / sv[18])}")
Vp = V[0:18, :]                                     # rows: w in kernel  <=>  Vp w = 0
Qk = V[18:36, :].H                                  # columns: orthonormal basis of the kernel (18 quadrics)
def dcub(g, v):                                     # derivative of a cubic (120-vector) by y_v, as a 36-vector
    q = mp.matrix(36, 1)
    for c, ci in cidx.items():
        m = c.count(v)
        if m and g[ci] != 0:
            r = list(c); r.remove(v); q[qidx[tuple(r)]] += m * g[ci]
    return q
pd = [dcub(Fv, v) for v in range(8)]
log(f"   partial derivatives of F_eps: distance from the kernel, relative: {sci(max(nrm(Vp * q) / nrm(q) for q in pd))}")

# ---------------------------------------------------------------- 2. cubics with all partials in the kernel
R = mp.matrix(144, 120)
for v in range(8):
    for c, ci in cidx.items():
        m = c.count(v)
        if m:
            r = list(c); r.remove(v); qi = qidx[tuple(r)]
            for k in range(18): R[v * 18 + k, ci] = m * Vp[k, qi]
import os, pickle
CACHE = os.environ.get("MX4_CACHE")
ckey = f"{CACHE}/svd2_{EPS.numerator}_{EPS.denominator}_{N}_{mp.mp.dps}.pkl" if CACHE else None
if ckey and os.path.exists(ckey):
    S2l, V2l = pickle.load(open(ckey, "rb")); S2 = mp.matrix(S2l); V2 = mp.matrix(V2l)
else:
    U2, S2, V2 = mp.svd_c(R)
    if ckey: pickle.dump(([S2[i] for i in range(120)], V2.tolist()), open(ckey, "wb"))
s2 = [S2[i] for i in range(120)]
log(f"2. cubics with partials in the kernel: singular values 114 .. 120: " + " ".join(sci(s2[i]) for i in range(113, 120)) + f"   [{time.time() - T0:.0f} s]")
gaps = [s2[i] / s2[i + 1] for i in range(113, 119)]
y5c = mp.matrix(120, 1); y5c[cidx[(5, 5, 5)]] = 1
nullity = None
for nu in (2, 3, 4, 5):
    if s2[119 - nu] > mp.mpf(10) ** 4 * s2[120 - nu] and nrm(R * Fv) / nrm(Fv) < s2[119 - nu] / 100:
        nullity = nu; break
log(f"   |R F|/|F| = {sci(nrm(R * Fv) / nrm(Fv))} ; |R y5^3| = {sci(nrm(R * y5c))} ; nullity read off (first gap of 1e4 above the level of F): {nullity}   (3 expected: y5^3, G_A, G_B)")
if nullity != 3:
    log("   NOT the expected nullity 3: stop."); sys.exit(1)
null = [V2[120 - 3 + k, :].H for k in range(3)]
def proj_out(v, others):                            # Gram-Schmidt
    for o in others: v = v - o * ((o.H * v)[0] / (o.H * o)[0])
    return v
Fn = proj_out(Fv, [y5c])                            # F without its y5^3 term direction (still in the space up to truncation)
inpl = sum((n * (n.H * Fv)[0] for n in null), mp.matrix(120, 1))
log(f"   F_eps: distance from the 3-dimensional null space, relative: {sci(nrm(Fv - inpl) / nrm(Fv))}")
# H: in the null space, orthogonal to y5^3 and to F
cands = [proj_out(n, [y5c, Fn]) for n in null]
Hc = max(cands, key=nrm); Hc = Hc * (nrm(Fv) / nrm(Hc))
log(f"   H: |R H|/|H| = {sci(nrm(R * Hc) / nrm(Hc))}")

# ---------------------------------------------------------------- 3. the special members H - t F - u y5^3
def vf_matrix(g):                                   # 120 x 64: column 8 i + j = coefficients of y_i d_j g
    M = mp.matrix(120, 64)
    for j in range(8):
        q = dcub(g, j)
        for qm, qi in qidx.items():
            if q[qi] == 0: continue
            for i in range(8):
                M[cidx[tuple(sorted(qm + (i,)))], 8 * i + j] += q[qi]
    return M
ckey3 = f"{CACHE}/step3_{EPS.numerator}_{EPS.denominator}_{N}_{mp.mp.dps}.pkl" if CACHE else None
MF = vf_matrix(Fv); MH = vf_matrix(Hc); M5 = vf_matrix(y5c)
keep = [ci for c, ci in sorted(cidx.items(), key=lambda t: t[1]) if c.count(5) < 2]           # drop y5^2 y_i: 112 rows
def rows(M, rr):
    out = mp.matrix(len(rr), M.cols)
    for a, r in enumerate(rr):
        for j in range(M.cols): out[a, j] = M[r, j]
    return out
PF = rows(MF, keep); PH = rows(MH, keep)
PHH = PH.H
if ckey3 and os.path.exists(ckey3):
    evl, ERl = pickle.load(open(ckey3, "rb")); ev = evl; ER = mp.matrix(ERl)
else:
    Tm = mp.inverse(PHH * PH) * (PHH * PF)          # eigenvalues mu = 1/t of the reduced pair (least squares)
    ev, ER = mp.eig(Tm, left=False, right=True)
    if ckey3: pickle.dump((list(ev), ER.tolist()), open(ckey3, "wb"))
cand = []
for k in range(64):
    v = ER[:, k]; r = nrm(PF * v - ev[k] * (PH * v)) / nrm(PH * v)
    cand.append((r, ev[k], k))
cand.sort(key=lambda t: abs(t[1]))
log(f"3. reduced pair: |mu| of the 8 smallest: {sci(abs(cand[0][1]))} .. {sci(abs(cand[7][1]))} (zero expected: the fields y_i d/dy5) ; 9th: {sci(abs(cand[8][1]))}   [{time.time() - T0:.0f} s]")
fin = sorted(cand[8:], key=lambda t: t[0])
if os.environ.get("MX4_VERBOSE"):
    for r, m, k in fin: log(f"      t = {mp.nstr(1 / m, 20)}   residual {sci(r)}")
log(f"   finite eigenvalues: residuals sorted: 1st {sci(fin[0][0])}, 8th {sci(fin[7][0])}, 16th {sci(fin[15][0])} | 17th {sci(fin[16][0])}, 18th {sci(fin[17][0])}")
# All 56 finite eigenvalues lie close together (the special members are close to a cube l^3, which has a
# 56-dimensional Lie algebra), so the genuine ones are picked by residual, then split into two groups.
good = fin[:16]
ts = [1 / m for _, m, _ in good]
c_all = sum(ts) / 16
d = [t - c_all for t in ts]
ref = max(d, key=abs)
side = [1 if mp.re(x / ref) > 0 else 0 for x in d]
clA = [g for g, sd in zip(good, side) if sd == 1]; clB = [g for g, sd in zip(good, side) if sd == 0]
cA = sum(1 / m for _, m, _ in clA) / max(1, len(clA)); cB = sum(1 / m for _, m, _ in clB) / max(1, len(clB))
sep = abs(cA - cB)
# genuine eigenvalues: those before the largest jump of the residual among positions 15 .. 21 (16 or 17 expected);
# they are then assigned to the nearer of the two centres.  (Membership by distance fails for small eps, because
# the other 39 eigenvalues approach the two centres like a power of eps.)
jumps = [(fin[i + 1][0] / fin[i][0], i + 1) for i in range(14, 21)]
ngen = max(jumps)[1]
gen = fin[:ngen]
nearA = [g for g in gen if abs(1 / g[1] - cA) <= abs(1 / g[1] - cB)]; nearB = [g for g in gen if abs(1 / g[1] - cA) > abs(1 / g[1] - cB)]
log(f"   the 16 smallest residuals split into groups of {len(clA)} and {len(clB)} ; separation of the two centres {sci(sep, 4)} ; residuals 15th .. 19th: " + " ".join(sci(fin[i][0], 1) for i in range(14, 19)) + f" ; largest jump after the {ngen}th: {ngen} genuine eigenvalues, {len(nearA)} and {len(nearB)} at the two centres")
if not (8 <= len(nearA) <= 9 and 8 <= len(nearB) <= 9):
    log("   NOT two groups of 8 (or 9) at this eps (the list with MX4_VERBOSE=1 shows why): stop."); sys.exit(1)
def cluster(cl, name):
    cl = sorted(cl, key=lambda g: g[0])
    tt = [1 / m for _, m, _ in cl[:8]]; t = sum(tt) / 8
    num = 0; den = 0
    for _, m, k in cl[:8]:
        v = ER[:, k]; lhs = (MH - t * MF) * v; rhs = M5 * v
        num += (rhs.H * lhs)[0]; den += (rhs.H * rhs)[0]
    u = num / den
    full = [nrm((MH - t * MF - u * M5) * ER[:, k]) / nrm(MH * ER[:, k]) for _, m, k in cl]
    spread = max(abs(x - t) for x in tt)
    log(f"   {name}: {len(cl)} eigenvalues ; t = {mp.nstr(t, 22)}, u = {mp.nstr(u, 22)} ; spread of the 8 best {sci(spread)} ; full residuals of the fields: " + " ".join(sci(x, 1) for x in full))
    return t, u, spread
tA, uA, spA = cluster(nearA, "group 1"); tB, uB, spB = cluster(nearB, "group 2")
log(f"   |t_B - t_A| / |t_A| = {sci(abs(tB - tA) / abs(tA), 5)} ; |u_B - u_A| / |u_A| = {sci(abs(uB - uA) / abs(uA))}   (u_A = u_B is the check that F, G_A, G_B are on a line; it is not imposed above)")
t1, t2 = tA, tB
dt = tB - tA
uu = (uA + uB) / 2                                  # from here on one common u, so that G_A + G_B = F exactly
GA = (Hc - tA * Fv - uu * y5c) / dt; GB = (tB * Fv + uu * y5c - Hc) / dt
e6 = (mp.mpf(EPS.numerator) / EPS.denominator) ** 6
log(f"   |G_A| = {sci(nrm(GA), 5)}, |G_B| = {sci(nrm(GB), 5)} ; |G_A| eps^6 = {sci(nrm(GA) * e6, 5)}, |G_B| eps^6 = {sci(nrm(GB) * e6, 5)} ; |G_A + G_B| eps^6 / |G_A| eps^6 = {sci(nrm(Fv) / nrm(GA))}")
if os.environ.get("MX4_STOP3"): sys.exit(0)

# ---------------------------------------------------------------- 4, 5. Lie algebra and matrix of each summand
def sym_tensor(g):
    T = {}
    for c, ci in cidx.items():
        if g[ci] == 0: continue
        perms = set(itertools.permutations(c))
        for p in perms: T[p] = g[ci] / len(perms)
    return T
def change_vars(g, Sm):
    """g(y) with y_i = sum_k Sm[k, i] n_k  ->  coefficient vector in the new variables n"""
    T = sym_tensor(g)
    cur = {idx: c for idx, c in T.items()}
    for pos in range(3):
        nxt = {}
        for idx, c in cur.items():
            i = idx[pos]
            for k in range(8):
                s = Sm[k, i]
                if s == 0: continue
                key = idx[:pos] + (k,) + idx[pos + 1:]
                nxt[key] = nxt.get(key, 0) + c * s
        cur = nxt
    out = mp.matrix(120, 1)
    for idx, c in cur.items(): out[cidx[tuple(sorted(idx))]] += c
    return out
def lin_mul(*forms):
    """product of up to three linear forms (8-vectors) as a 120- or 36-vector dict on sorted index tuples"""
    cur = {(): mp.mpf(1)}
    for f in forms:
        nxt = {}
        for idx, c in cur.items():
            for i in range(8):
                if f[i] == 0: continue
                key = tuple(sorted(idx + (i,))); nxt[key] = nxt.get(key, 0) + c * f[i]
        cur = nxt
    return cur
def det3(M):                                        # M: 3 x 3 list of 8-vectors (linear forms) -> 120-vector
    out = mp.matrix(120, 1)
    for perm, sg in (((0, 1, 2), 1), ((1, 2, 0), 1), ((2, 0, 1), 1), ((0, 2, 1), -1), ((2, 1, 0), -1), ((1, 0, 2), -1)):
        for idx, c in lin_mul(M[0][perm[0]], M[1][perm[1]], M[2][perm[2]]).items(): out[cidx[idx]] += sg * c
    return out
def minors(M):                                      # the nine 2 x 2 minors as 36-vectors
    res = []
    for r in itertools.combinations(range(3), 2):
        for c in itertools.combinations(range(3), 2):
            q = mp.matrix(36, 1)
            for idx, co in lin_mul(M[r[0]][c[0]], M[r[1]][c[1]]).items(): q[qidx[idx]] += co
            for idx, co in lin_mul(M[r[0]][c[1]], M[r[1]][c[0]]).items(): q[qidx[idx]] -= co
            res.append(q)
    return res
def lie_algebra(g, name, thr):
    Ug, Sg, Vg = mp.svd_c(vf_matrix(g))
    sg = [Sg[i] / Sg[0] for i in range(64)]
    dim = sum(1 for x in sg if x < thr)
    log(f"4. {name}: vector fields killing it: singular values 50 .. 64 relative to the first: " + " ".join(sci(x, 1) for x in sg[49:]) + f" ; below the noise threshold {sci(thr, 1)}: {dim}   [{time.time() - T0:.0f} s]")
    return Vg, sg, dim
def random_element(basis, rng):
    x = mp.matrix(64, 1)
    for b in basis: x += b * mp.mpc(rng.gauss(0, 1), rng.gauss(0, 1))
    X = mp.matrix(8, 8)
    for i in range(8):
        for j in range(8): X[i, j] = x[8 * i + j]                     # the derivation acts on coefficient vectors by w -> X w
    return X
def nform(Cm, coeffs):                                                 # coeffs: dict new-variable index -> scalar
    f = mp.matrix(8, 1)
    for k, c in coeffs.items(): f += Cm[:, k] * c
    return f
def detrep3(g, basis, name, seed, TOLR=mp.mpf("1e-8")):
    """relation of rank 3: the method of detrep_lib.m2 (root pattern of sl_3: +-al, +-be, +-(al + be), 0, 0)"""
    rng = __import__("random").Random(seed)
    for attempt in range(20):
        X = random_element(basis, rng)
        e, W = mp.eig(X, left=False, right=True)
        order = sorted(range(8), key=lambda k: abs(e[k]))
        z0, z1 = order[0], order[1]; rts = order[2:]
        scale = max(abs(e[k]) for k in range(8))
        if abs(e[z1]) > TOLR * scale or abs(e[rts[0]]) < 10 * TOLR * scale: continue
        def find(val, pool):
            best = min(pool, key=lambda k: abs(e[k] - val)); return best, abs(e[best] - val) / scale
        al = rts[0]
        nal, err1 = find(-e[al], [k for k in rts if k != al])
        be = None
        for k in rts:
            if k in (al, nal): continue
            ga, err = find(e[al] + e[k], [m for m in rts if m not in (al, nal, k)])
            if err < TOLR: be = k; break
        if be is None: continue
        nbe, err2 = find(-e[be], [k for k in rts if k not in (al, nal, be, ga)])
        nga, err3 = find(-e[ga], [k for k in rts if k not in (al, nal, be, ga, nbe)])
        log(f"5. {name}: regular element: |two smallest eigenvalues|/scale = {sci(abs(e[z0]) / scale)}, {sci(abs(e[z1]) / scale)} ; root relations (errors) {sci(err1)}, {sci(err2)}, {sci(err3)}")
        Ux, Sx, Vx = mp.svd_c(X)
        Z = [Vx[6, :].H, Vx[7, :].H]
        cols = [W[:, al], W[:, be], W[:, ga], W[:, nal], W[:, nbe], W[:, nga], Z[0], Z[1]]   # F12 F23 F13 F21 F32 F31 Z1 Z2
        Cm = mp.matrix(8, 8)
        for k in range(8):
            c = cols[k] / nrm(cols[k])
            for i in range(8): Cm[i, k] = c[i]
        gn = change_vars(g, Cm ** -1)
        svc = mp.svd_c(Cm, compute_uv=False); log(f"   {name}: condition number of the eigenvector matrix: {sci(svc[0] / svc[7])}")
        co = lambda *idx: gn[cidx[tuple(sorted(idx))]]
        F12, F23, F13, F21, F32, F31, Z1, Z2 = range(8)
        Ac = co(F12, F23, F31); Bc = co(F13, F21, F32)
        l1 = [-co(F23, F32, Z1), -co(F23, F32, Z2)]; l2 = [-co(F13, F31, Z1), -co(F13, F31, Z2)]; l3 = [-co(F12, F21, Z1), -co(F12, F21, Z2)]
        Pz = [co(Z1, Z1, Z1), co(Z1, Z1, Z2), co(Z1, Z2, Z2), co(Z2, Z2, Z2)]
        pr = [l1[0] * l2[0] * l3[0],
              l1[0] * l2[0] * l3[1] + l1[0] * l2[1] * l3[0] + l1[1] * l2[0] * l3[0],
              l1[0] * l2[1] * l3[1] + l1[1] * l2[0] * l3[1] + l1[1] * l2[1] * l3[0],
              l1[1] * l2[1] * l3[1]]
        kbest = max(range(4), key=lambda k: abs(pr[k])); rho = Pz[kbest] / pr[kbest]
        rho_err = max(abs(Pz[k] - rho * pr[k]) for k in range(4)) / max(abs(x) for x in Pz)
        allowed = {tuple(sorted(t)) for t in [(F12, F23, F31), (F13, F21, F32)]
                   + [(F23, F32, z) for z in (Z1, Z2)] + [(F13, F31, z) for z in (Z1, Z2)] + [(F12, F21, z) for z in (Z1, Z2)]
                   + [tuple(c) for c in itertools.combinations_with_replacement((Z1, Z2), 3)]}
        other = max(abs(gn[ci]) for c, ci in cidx.items() if c not in allowed) / max(abs(gn[i]) for i in range(120))
        log(f"   weight structure: largest forbidden coefficient, relative: {sci(other)} ; diagonal part = rho l1 l2 l3 with error {sci(rho_err)} ; |A B rho - 1| = {sci(abs(Ac * Bc * rho - 1))}")
        M = [[nform(Cm, {Z1: l1[0], Z2: l1[1]}), nform(Cm, {F12: 1}), nform(Cm, {F13: 1 / Ac})],
             [nform(Cm, {F21: 1 / rho}), nform(Cm, {Z1: l2[0], Z2: l2[1]}), nform(Cm, {F23: 1})],
             [nform(Cm, {F31: Ac}), nform(Cm, {F32: 1}), nform(Cm, {Z1: rho * l3[0], Z2: rho * l3[1]})]]
        log(f"   det(matrix) - {name}: relative {sci(nrm(det3(M) - g) / nrm(g))}")
        return M
    log(f"   {name}: no element with the root pattern of sl_3 found in 20 attempts"); return None
def detrep2(g, basis, name, seed):
    """relation of rank 2: B = [[a, b, c], [d, -a, e], [f, g, h]]; a general element of the 9-dimensional algebra has
    8 distinct eigenvalues, eigenforms a..h, and det B = -aah - aeg - bdh + bef + cdg + acf (step 5' of PREREG)"""
    rng = __import__("random").Random(seed)
    for attempt in range(5):
        X = random_element(basis, rng)
        e, W = mp.eig(X, left=False, right=True)
        scale = max(abs(e[k]) for k in range(8))
        gap = min(abs(e[i] - e[j]) for i in range(8) for j in range(i)) / scale
        if gap < mp.mpf("1e-4"):
            log(f"5'. {name}: attempt {attempt}: eigenvalues not distinct (smallest gap {sci(gap)})"); continue
        Cm = mp.matrix(8, 8)
        for k in range(8):
            c = W[:, k] / nrm(W[:, k])
            for i in range(8): Cm[i, k] = c[i]
        gn = change_vars(g, Cm ** -1)
        svc = mp.svd_c(Cm, compute_uv=False); log(f"5'. {name}: condition number of the eigenvector matrix: {sci(svc[0] / svc[7])}")
        mags = sorted(((abs(gn[ci]), c) for c, ci in cidx.items()), reverse=True)
        top = mags[0][0]
        log(f"5'. {name}: 8 distinct eigenvalues (smallest gap {sci(gap)}) ; monomials in the eigenforms, by size relative to the largest: " + " ".join(f"{''.join(map(str, c))}:{sci(m / top, 1)}" for m, c in mags[:9]))
        mons = [c for m, c in mags[:6]]
        sq = [c for c in mons if len(set(c)) < 3]
        if len(sq) != 1 or len(set(sq[0])) != 2:
            log("   NOT the pattern of a determinant with a relation of rank 2 (one monomial x^2 y expected)."); return None
        va = [v for v in set(sq[0]) if sq[0].count(v) == 2][0]; vh = [v for v in set(sq[0]) if v != va][0]
        free = [c for c in mons if c != sq[0]]
        hm = [c for c in free if vh in c]; am = [c for c in free if va in c]; rest = [c for c in free if vh not in c and va not in c]
        ok = len(hm) == 1 and len(am) == 2 and len(rest) == 2 and va not in hm[0]
        if ok:
            vb, vd = [v for v in hm[0] if v != vh]
            mb = [c for c in rest if vb in c]; md = [c for c in rest if vd in c]
            ok = len(mb) == 1 and len(md) == 1 and mb[0] != md[0]
        if ok:
            ef = [v for v in mb[0] if v != vb]; cg = [v for v in md[0] if v != vd]
            a1 = [v for v in am[0] if v != va]
            ve = [v for v in a1 if v in ef]; vg = [v for v in a1 if v in cg]
            ok = len(ve) == 1 and len(vg) == 1
        if ok:
            ve, vg = ve[0], vg[0]; vf = [v for v in ef if v != ve][0]; vc = [v for v in cg if v != vg][0]
            ok = tuple(sorted((va, vc, vf))) == am[1] and len({va, vb, vc, vd, ve, vf, vg, vh}) == 8
        if not ok:
            log("   NOT the pattern of a determinant with a relation of rank 2: the six monomials are " + " ".join("".join(map(str, c)) for c in mons)); return None
        co = lambda *idx: gn[cidx[tuple(sorted(idx))]]
        c1 = co(va, va, vh); c2 = co(va, ve, vg); c3 = co(vb, vd, vh); c4 = co(vb, ve, vf); c5 = co(vc, vd, vg); c6 = co(va, vc, vf)
        inv = c1 * c4 * c5 / (c2 * c3 * c6)
        log(f"   the six monomials are those of the determinant ; the 7th is {sci(mags[6][0] / top)} of the largest ; invariant c(aah) c(bef) c(cdg) / (c(aeg) c(bdh) c(acf)) + 1 = {sci(abs(inv + 1))}")
        sa = mp.mpf(1); sb = mp.mpf(1); se = mp.mpf(1); sh = -c1; sd = c3 / c1; sg_ = -c2; sf = c4; sc = c5 / (sd * sg_)
        fa, fb, fc, fd, fe, ff, fg, fh = (nform(Cm, {v: 1 / sv_}) for v, sv_ in ((va, sa), (vb, sb), (vc, sc), (vd, sd), (ve, se), (vf, sf), (vg, sg_), (vh, sh)))
        # G = sum c_m m(n);  with x' = sigma_x n_x one has c_m m(n) = (c_m / prod sigma) m(x'), and the matrix is written in x'
        fa, fb, fc, fd, fe, ff, fg, fh = (nform(Cm, {v: sv_}) for v, sv_ in ((va, sa), (vb, sb), (vc, sc), (vd, sd), (ve, se), (vf, sf), (vg, sg_), (vh, sh)))
        M = [[fa, fb, fc], [fd, -fa, fe], [ff, fg, fh]]
        log(f"   det(matrix) - {name}: relative {sci(nrm(det3(M) - g) / nrm(g))}")
        return M
    return None
def relation(M):
    """the linear relation(s) among the nine entries: singular values of the 9 x 8 coefficient matrix, and the 3 x 3
    matrix C with sum C[i][j] M[i][j] = 0 (singular values, normalised)"""
    Co = mp.matrix(9, 8)
    for i in range(3):
        for j in range(3):
            for k in range(8): Co[3 * i + j, k] = M[i][j][k]
    U_, S_, V_ = mp.svd_c(Co.T)                      # 8 x 9: null vector = relation
    Uc, Sc, Vc = mp.svd_c(Co.T, full_matrices=True)
    c = Vc[8, :]                                      # c . Co = 0   (row of V: Co^T c^T = 0)
    C = mp.matrix(3, 3)
    for i in range(3):
        for j in range(3): C[i, j] = c[3 * i + j]
    sc = mp.svd_c(C, compute_uv=False)
    return [S_[k] / S_[0] for k in range(8)], [sc[k] / sc[0] for k in range(3)]
def build(g, name, seed, Vg, sg, dim):
    """dim = number of vector fields at the noise level.  9: relation of rank 2 (detrep2).  8: relation of rank 3
    (detrep3); if the 9th smallest singular value is itself isolated, the cubic is close to one with 9 fields, and
    detrep2 on those 9 is tried as well; the matrix with the smaller mismatch is kept (it is only a starting point)."""
    cands = []
    if dim == 9:
        M = detrep2(g, [Vg[55 + k, :].H for k in range(9)], name, seed)
        if M is not None: cands.append((nrm(det3(M) - g) / nrm(g), "relation of rank 2", M))
    elif dim == 8:
        M = detrep3(g, [Vg[56 + k, :].H for k in range(8)], name, seed)
        if M is None:
            log(f"   {name}: retrying with the root pattern accepted at tolerance 1e-2 (rough matrix, to be polished)")
            M = detrep3(g, [Vg[56 + k, :].H for k in range(8)], name, seed, TOLR=mp.mpf("1e-2"))
        if M is not None: cands.append((nrm(det3(M) - g) / nrm(g), "relation of rank 3 (sl_3)", M))
        if sg[54] > 100 * sg[55]:
            log(f"   {name}: the 9th smallest singular value {sci(sg[55], 1)} is isolated (next {sci(sg[54], 1)}): trying the 9 fields as well")
            M = detrep2(g, [Vg[55 + k, :].H for k in range(9)], name + " (9 near-fields)", seed)
            if M is not None: cands.append((nrm(det3(M) - g) / nrm(g), "relation of rank 2, approximately", M))
    else:
        log(f"   {name}: {dim} vector fields: neither 8 nor 9; no matrix attempted."); return None
    if not cands: return None
    cands = [c for c in cands if c[0] < mp.mpf("1e-3")]
    if not cands:
        log(f"   {name}: no candidate matrix with |det - {name}| / |{name}| below 1e-3: no matrix for {name}"); return None
    # with 8 vector fields the matrix of the sl_3 method is the one of the right type and is kept when it exists;
    # the matrix with a relation of rank 2 is then only a nearby comparison
    keep = [c for c in cands if c[1].startswith("relation of rank 3")] or cands
    other = [c for c in cands if c is not keep[0]]
    log(f"   {name}: kept: {keep[0][1]} ; |det(matrix) - {name}| / |{name}| = {sci(keep[0][0])}" + (f" (comparison: {other[0][1]}: {sci(other[0][0])})" if other else ""))
    return keep[0][2]
thrA = 10 * spA; thrB = 10 * spB
VgA, sgA, dimA = lie_algebra(GA, "G_A", thrA); VgB, sgB, dimB = lie_algebra(GB, "G_B", thrB)
MA = build(GA, "G_A", 11, VgA, sgA, dimA); MB = build(GB, "G_B", 12, VgB, sgB, dimB)
def dump(MA, MB, note):
    if not OUT: return
    cx = lambda x: [mp.nstr(mp.re(x), mp.mp.dps - 5), mp.nstr(mp.im(x), mp.mp.dps - 5)]
    mat = lambda M: None if M is None else [[[cx(M[i][j][k]) for k in range(8)] for j in range(3)] for i in range(3)]
    json.dump({"eps": str(EPS), "order": N, "dps": mp.mp.dps, "note": note, "A": mat(MA), "B": mat(MB),
               "GA": [cx(GA[i]) for i in range(120)], "GB": [cx(GB[i]) for i in range(120)], "F": [cx(Fv[i]) for i in range(120)],
               "tA": cx(tA), "tB": cx(tB), "u": cx(uu), "spreads": [mp.nstr(spA, 5), mp.nstr(spB, 5)], "lie_dims": [dimA, dimB],
               "lie_singular_values_A": [mp.nstr(x, 5) for x in sgA[44:]], "lie_singular_values_B": [mp.nstr(x, 5) for x in sgB[44:]],
               "cat_singular_values": [mp.nstr(x, 8) for x in sv]}, open(OUT, "w"), indent=1)
    log(f"   written {OUT}")
# ---------------------------------------------------------------- 6'. Gauss-Newton (guarded), single and joint
import flint
flint.ctx.dps = 2 * mp.mp.dps + 60
def to_acb(x):
    return flint.acb(flint.arb(mp.nstr(mp.re(x), mp.mp.dps + 5)).mid(), flint.arb(mp.nstr(mp.im(x), mp.mp.dps + 5)).mid())
def from_acb(x): return mp.mpc(mp.mpf(x.real.mid().str(mp.mp.dps + 5, radius=False)), mp.mpf(x.imag.mid().str(mp.mp.dps + 5, radius=False)))
def cof(M, i, j):                                   # cofactor (36-vector): d det / d M[i][j]
    r = [a for a in range(3) if a != i]; c = [b for b in range(3) if b != j]
    q = mp.matrix(36, 1)
    for idx, co in lin_mul(M[r[0]][c[0]], M[r[1]][c[1]]).items(): q[qidx[idx]] += co
    for idx, co in lin_mul(M[r[0]][c[1]], M[r[1]][c[0]]).items(): q[qidx[idx]] -= co
    return q * (-1) ** (i + j)
def jacobian(Ms):
    J = mp.matrix(120, 72 * len(Ms))
    for m, M in enumerate(Ms):
        for i in range(3):
            for j in range(3):
                q = cof(M, i, j)
                for qm, qi in qidx.items():
                    if q[qi] == 0: continue
                    for k in range(8): J[cidx[tuple(sorted(qm + (k,)))], 72 * m + 24 * i + 8 * j + k] += q[qi]
    return J
def newton(Ms, target, name, iters=12):
    """guarded Gauss-Newton with minimal-norm steps on sum det M = target; changes Ms in place; returns the history"""
    val = lambda: sum((det3(M) for M in Ms), mp.matrix(120, 1)) - target
    res = nrm(val()) / nrm(target); hist = [res]
    for it in range(iters):
        J = jacobian(Ms); r = val(); nc = 72 * len(Ms)
        Jf = flint.acb_mat(120, nc, [to_acb(J[i, j]) for i in range(120) for j in range(nc)])
        JH = Jf.conjugate().transpose()
        G = Jf * JH
        mu = flint.arb(max(abs(complex(G[i, i].real.mid())) for i in range(120))) * flint.arb(10) ** (-int(1.2 * mp.mp.dps))
        for i in range(120): G[i, i] += flint.acb(mu)
        rf = flint.acb_mat(120, 1, [to_acb(r[i]) for i in range(120)])
        try:
            w = G.solve(rf)
        except Exception as ex:
            log(f"   {name}: linear solve failed at iteration {it + 1} ({type(ex).__name__}); stopped"); break
        dl = JH * w
        step = [from_acb(dl[k, 0]) for k in range(nc)]
        old = [[[M[i][j].copy() for j in range(3)] for i in range(3)] for M in Ms]
        size = mp.sqrt(sum(abs(x) ** 2 for x in step)) / mp.sqrt(sum(abs(M[i][j][k]) ** 2 for M in Ms for i in range(3) for j in range(3) for k in range(8)))
        lam_ = mp.mpf(1); ok = False
        for back in range(12):                      # step halving
            for m, M in enumerate(Ms):
                for i in range(3):
                    for j in range(3):
                        for k in range(8): M[i][j][k] = old[m][i][j][k] - lam_ * step[72 * m + 24 * i + 8 * j + k]
            new = nrm(val()) / nrm(target)
            if new < res: ok = True; break
            lam_ /= 2
        if not ok:
            for m, M in enumerate(Ms):
                for i in range(3):
                    for j in range(3): M[i][j] = old[m][i][j]
            log(f"   {name}: step {it + 1} (relative size {sci(size, 1)}) does not lower the residual {sci(res)} even after 12 halvings: stopped"); break
        hist.append(new)
        if new > res / 2 and lam_ == 1 and len(hist) > 3: res = new; break
        res = new
    log(f"   {name}: Gauss-Newton, relative residual by accepted step: " + " ".join(sci(x, 1) for x in hist) + f"   [{time.time() - T0:.0f} s]")
    return hist
def report(MA, MB, tag):
    out = None
    for nm, M, g in (("A", MA, GA), ("B", MB, GB)):
        if M is None:
            log(f"6. [{tag}] {nm}: no matrix"); continue
        mins = minors(M)
        dist = max(nrm(Vp * q) / nrm(q) for q in mins)
        Mm = mp.matrix(36, 9)
        for k, q in enumerate(mins):
            qn = q / nrm(q)
            for i in range(36): Mm[i, k] = qn[i]
        sm = mp.svd_c(Mm, compute_uv=False)
        eM, cM = relation(M)
        log(f"6. [{tag}] {nm}: |det {nm} - G_{nm}| / |G_{nm}| = {sci(nrm(det3(M) - g) / nrm(g))} ; its nine 2 x 2 minors: largest relative distance from the kernel of Cat(2,2) {sci(dist)}, they span 9 dimensions (normalised singular values {sci(sm[0])} .. {sci(sm[8])}) ; the entries span 8 forms ; relation matrix C_{nm}: singular values 1, {sci(cM[1])}, {sci(cM[2])} (not gauge invariant; the rank is)")
    if MA is not None and MB is not None:
        out = nrm(det3(MA) + det3(MB) - Fv) / nrm(Fv)
        log(f"   [{tag}] |det A + det B - F_eps| / |F_eps| = {sci(out)}")
    return out
res0 = report(MA, MB, "as built")
dump(MA, MB, "matrices as built from the symmetry algebras, no polish")
if os.environ.get("MX4_POLISH") and MA is not None and MB is not None:
    hA = newton([MA], GA, "6'. det A = G_A"); hB = newton([MB], GB, "6'. det B = G_B")
    report(MA, MB, "after the separate polish")
    hJ = newton([MA, MB], Fv, "6'. det A + det B = F_eps")
    report(MA, MB, "after the joint polish")
    dump(MA, MB, "matrices after the polish; histories " + " ".join(mp.nstr(x, 3) for x in hA) + " | " + " ".join(mp.nstr(x, 3) for x in hB) + " | " + " ".join(mp.nstr(x, 3) for x in hJ))
log(f"   total time {time.time() - T0:.0f} s")
