#!/usr/bin/env python3
"""BC-SO3 numpy order-3 engine (own code). Reads the GB data exported by exp3.m2 and evaluates, for a single cycle
with ideal I and G in T NL:  Gamma (psi(G .) on S_sig), psi on I_(sig+3) (via kappa), psi3(G G (K G)), order 2, c3.
All arithmetic mod p in float64 (exact: every accumulated sum stays < 2^53) or int64.
Same formulas as o3bc.m2 (validated against the package and direct GB routes); see the [BC-SO3] ledger lines."""
import sys, os, ast, json
import numpy as np
import scipy.sparse as sp

D = sys.argv[1]
def rl(fn): return ast.literal_eval(open(os.path.join(D, fn)).read().strip().replace('{', '[').replace('}', ']'))
def rm(fn):
    lines = open(os.path.join(D, fn)).read().split('\n')
    r, c = map(int, lines[0].split())
    body = lines[1].strip().strip('{}')
    v = np.array([int(x) for x in body.split(',')], dtype=np.int64) if r * c > 0 else np.zeros(0, dtype=np.int64)
    return (v % p).reshape(r, c) if 'p' in globals() else v.reshape(r, c)
hdr = rl('header.txt')
p, nv, k, sig, dQ, r, degs, nW = hdr
assert dQ == sig - 3
md = lambda x: np.mod(x, p)
def inv(a): return pow(int(a) % p, p - 2, p)
B = 16
pw = (B ** np.arange(nv)).astype(np.int64)
# ---------------------------------------------------------------- monomial bases (M2 order for d <= sig)
mons = {}
for d in range(sig + 1):
    mons[d] = np.array(rl('basis%d.txt' % d), dtype=np.int64).reshape(-1, nv)
def gen(d, n):
    if n == 1: return [[d]]
    return [[a] + rest for a in range(d, -1, -1) for rest in gen(d - a, n - 1)]
for d in range(sig + 1, sig + 4):
    mons[d] = np.array(gen(d, nv), dtype=np.int64)
code = {d: mons[d] @ pw for d in mons}
srt = {d: np.argsort(code[d]) for d in mons}
scode = {d: code[d][srt[d]] for d in mons}
def lookup(d, c):
    pos = np.searchsorted(scode[d], c)
    pos = np.minimum(pos, len(scode[d]) - 1)
    ok = scode[d][pos] == c
    assert ok.all(), "lookup failed"
    return srt[d][pos]
N = {d: len(mons[d]) for d in mons}
_mm = {}
def mulmap(d1, d2):
    if (d1, d2) not in _mm: _mm[(d1, d2)] = lookup(d1 + d2, code[d1][:, None] + code[d2][None, :])
    return _mm[(d1, d2)]
def mul(a, d1, b, d2):
    M = mulmap(d1, d2)
    ia = np.nonzero(a)[0]; ib = np.nonzero(b)[0]
    if len(ia) == 0 or len(ib) == 0: return np.zeros(N[d1 + d2])
    w = np.outer(a[ia].astype(np.float64), b[ib].astype(np.float64)).ravel()
    return md(np.bincount(M[np.ix_(ia, ib)].ravel(), weights=w, minlength=N[d1 + d2]))
def multmat(g, dg, d1):
    """sparse matrix (N[d1+dg] x N[d1]) of multiplication by the fixed poly g of degree dg"""
    M = mulmap(d1, dg); ig = np.nonzero(g)[0]
    rows = M[:, ig].ravel(); cols = np.repeat(np.arange(N[d1]), len(ig)); vals = np.tile(g[ig].astype(np.float64), N[d1])
    return sp.csr_matrix((vals, (rows, cols)), shape=(N[d1 + dg], N[d1]))
_dm = {}
def dermat(d, i):
    """sparse (N[d-1] x N[d]) matrix of d/dx_i"""
    if (d, i) not in _dm:
        e = mons[d]; sel = np.nonzero(e[:, i] > 0)[0]
        tgt = lookup(d - 1, code[d][sel] - pw[i])
        _dm[(d, i)] = sp.csr_matrix((e[sel, i].astype(np.float64), (tgt, sel)), shape=(N[d - 1], N[d]))
    return _dm[(d, i)]
def der(a, d, i): return md(dermat(d, i) @ a)
def first_factor(e, deg):
    out = np.zeros(nv, dtype=np.int64); rest = deg
    for i in range(nv):
        m = min(e[i], rest); out[i] = m; rest -= m
    return out
def splitmaps(d, deg):
    """for every monomial t of degree d: (code of first factor of degree deg, index of cofactor in degree d-deg)"""
    e = mons[d]
    ff = np.zeros_like(e); rest = np.full(len(e), deg)
    for i in range(nv):
        m = np.minimum(e[:, i], rest); ff[:, i] = m; rest = rest - m
    return ff @ pw, lookup(d - deg, code[d] - ff @ pw)
# ---------------------------------------------------------------- data
nu = rm('nu.txt').ravel().astype(np.float64)               # on S_sig
F = rm('F.txt').ravel(); G = rm('G.txt').ravel().astype(np.float64)
fI = [rm('f%d.txt' % j).ravel().astype(np.float64) for j in range(r)]
wg = rl('wgens.txt')
widx = {}
for w, (j, ue) in enumerate(wg): widx[(j, int(np.array(ue) @ pw))] = w
Wpoly = np.zeros((N[3], nW))
for w, (j, ue) in enumerate(wg):
    u = np.zeros(N[3 - degs[j]]); u[lookup(3 - degs[j], np.array([np.array(ue) @ pw]))[0]] = 1
    Wpoly[:, w] = mul(fI[j], degs[j], u, 3 - degs[j])
if os.path.exists(os.path.join(D, 'Dfull.txt')) and os.path.getsize(os.path.join(D, 'Dfull.txt')) > 10:
    Dfull = rm('Dfull.txt').astype(np.float64)                 # N_sig x nW : nu(b_y . grad W)
else:
    nch = rl('nchunks.txt')
    DR = np.vstack([rm('DR_%d.txt' % c) for c in range(nch)]).astype(np.float64)
    tr = np.array(rl('NF.txt'), dtype=np.int64).reshape(-1, 3)
    NFs = sp.csr_matrix(((tr[:, 2] % p).astype(np.float64), (tr[:, 0], tr[:, 1])), shape=(N[sig], DR.shape[0]))
    Dfull = md(NFs @ DR)
ga = [rm('ga%d.txt' % i).astype(np.float64) for i in range(nv)]     # N_(sig-2) x N_dQ
gc = [rm('gc%d.txt' % j).astype(np.float64) for j in range(r)]      # N_(sig-e_j) x N_dQ
ik1 = inv(k + 1); ik2 = inv(k + 2)
log = lambda *a: (print(*a), sys.stdout.flush())
log("loaded", D, "p", p, "nv", nv, "k", k, "sig", sig, "nW", nW, "gens degs", degs)
# ---------------------------------------------------------------- psi on I_(sig+3): omega tables
om = []
for j in range(r):
    d = sig + 3 - degs[j]
    ucode, yidx = splitmaps(d, 3 - degs[j])
    wid = np.array([widx[(j, int(c))] for c in ucode])
    om.append((ik1 * Dfull[yidx, wid] % p, nu[yidx], wid))
def psiIrep(R):
    """R: list over generators of coefficient vectors (deg sig+3-e_j). returns (const, kappa-coef vector)"""
    c = 0.0; kv = np.zeros(nW)
    for j in range(r):
        if R[j] is None: continue
        oc, lam, wid = om[j]
        c = (c + float(md(R[j] @ oc))) % p
        kv = kv + np.bincount(wid, weights=md(R[j] * lam), minlength=nW)
    return c, md(kv)
# ---------------------------------------------------------------- kappa relations
rng = np.random.default_rng(int(sys.argv[2]) if len(sys.argv) > 2 else 1)
NTERM = int(os.environ.get('NTERM', '1'))
def monvec(d, idx):
    ids = [int(idx)] + [int(x) for x in rng.integers(0, N[d], NTERM - 1)]
    return (d, ids, [1] + [int(x) for x in rng.integers(1, p, NTERM - 1)])
def mulm(a, da, mu):
    """multiply coefficient vector a (degree da) by the monomial mu = (dm, index)"""
    dm, ids, cs = mu
    out = np.zeros(N[da + dm])
    if da < 0 or len(a) == 0: return out
    for ii, c in zip(ids, cs):
        out[lookup(da + dm, code[da] + code[dm][ii])] += c * a
    return md(out)
nup = [np.zeros(N[sig + 1]) for i in range(nv)]
for i in range(nv):     # nu'_i(mu) = nu(d_i mu) on S_(sig+1)
    nup[i] = md(dermat(sig + 1, i).T @ nu)
rows = []; rhs = []
sdeg = rl('syzdeg.txt'); s0deg = rl('syz0deg.txt')
syz = [[np.array(x, dtype=np.int64) % p for x in rl('syz%d.txt' % i)] for i in range(len(sdeg))]
syz0 = [[np.array(x, dtype=np.int64) % p for x in rl('syz0_%d.txt' % i)] for i in range(len(s0deg))]
nrel = int(sys.argv[3]) if len(sys.argv) > 3 else 3 * nW
gd_ok = [i for i in range(len(sdeg)) if sdeg[i] <= sig + 3]
s0_ok = [i for i in range(len(s0deg)) if s0deg[i] <= sig + 3]
cnt = 0
while cnt < nrel:
    t = cnt % 3
    if t == 0 and gd_ok:
        i = gd_ok[rng.integers(len(gd_ok))]; dd = sdeg[i]; dm = sig + 3 - dd
        mu = monvec(dm, rng.integers(N[dm]))
        R = [md(-mulm(np.array(syz[i][j], dtype=np.float64), dd - degs[j], mu)) for j in range(r)]
        known = 0.0
        for m in range(nv):
            A = mulm(np.array(syz[i][r + m], dtype=np.float64), dd - 2, mu)    # deg sig+1
            known += float(md(A @ nup[m]))
        known = known * ik1 % p
        c, kv = psiIrep(R); rows.append(kv); rhs.append((known - c) % p)
    elif t == 1:
        i1, i2 = rng.integers(r), rng.integers(r); dm = sig + 3 - degs[i1] - degs[i2]
        mu = monvec(dm, rng.integers(N[dm]))
        R = [None] * r; R[i1] = mulm(fI[i2], degs[i2], mu)
        c, kv = psiIrep(R); rows.append(kv); rhs.append((-c) % p)
    elif s0_ok:
        i = s0_ok[rng.integers(len(s0_ok))]; dd = s0deg[i]; dm = sig + 3 - dd
        mu = monvec(dm, rng.integers(N[dm]))
        R = [mulm(np.array(syz0[i][j], dtype=np.float64), dd - degs[j], mu) for j in range(r)]
        c, kv = psiIrep(R); rows.append(kv); rhs.append((-c) % p)
    cnt += 1
Rel = np.array(rows, dtype=np.int64) % p; rh = np.array(rhs, dtype=np.int64) % p
def rref(M):
    M = M.copy() % p; piv = []; row = 0
    for col in range(M.shape[1]):
        if row >= M.shape[0]: break
        nz = np.nonzero(M[row:, col])[0]
        if len(nz) == 0: continue
        q = row + nz[0]; M[[row, q]] = M[[q, row]]
        M[row] = M[row] * inv(M[row, col]) % p
        f = M[:, col].copy(); f[row] = 0
        nzr = np.nonzero(f)[0]
        if len(nzr): M[nzr] = (M[nzr] - np.outer(f[nzr], M[row])) % p
        piv.append(col); row += 1
    return M, piv
def solve(A, b):
    Ab = np.concatenate([A % p, (b % p).reshape(-1, 1)], axis=1)
    R_, piv = rref(Ab)
    if A.shape[1] in piv: return None, len(piv)
    x = np.zeros(A.shape[1], dtype=np.int64)
    for i, c in enumerate(piv): x[c] = R_[i, -1]
    return x, len(piv)
def nullspace(A):
    R_, piv = rref(A); n = A.shape[1]; free = [c for c in range(n) if c not in piv]
    Z = np.zeros((n, len(free)), dtype=np.int64)
    for t, f in enumerate(free):
        Z[f, t] = 1
        for i, c in enumerate(piv): Z[c, t] = (-R_[i, f]) % p
    return Z
kap, rk = solve(Rel, rh)
assert kap is not None, "kappa relations inconsistent"
RelR, relpiv = rref(Rel)
relrank = len(relpiv)
def determined(kv):
    return rref(np.vstack([Rel, np.array(kv, dtype=np.int64).reshape(1, -1) % p]))[1].__len__() == relrank
log("kappa: relations", len(rows), "rank", relrank, "of nW", nW, "consistent True")
if os.environ.get('KAPPERT'):
    Zk = nullspace(Rel)
    kap = (kap + Zk @ rng.integers(0, p, Zk.shape[1])) % p
    log("KAPPERT: added a random element of the", Zk.shape[1], "-dim null space of the kappa relations")
kap = kap.astype(np.float64)
def val(c, kv): return (c + float(md(np.asarray(kv) @ kap))) % p
# numeric omega
omn = [md(oc + lam * kap[wid]) for (oc, lam, wid) in om]
def psiI(R): return float(md(sum(R[j] @ omn[j] for j in range(r) if R[j] is not None)))
# ---------------------------------------------------------------- Gamma = psi(G .) on S_sig, all splits Y = u y (u in S_dQ, y in S_3)
d3 = sig - dQ   # = 3
ys = np.arange(N[d3])
V = np.zeros((N[d3], N[dQ]))
for i in range(nv):
    Hk = nup[i][mulmap(d3, sig - 2)]          # N_3 x N_(sig-2): nu'_i(y mu)
    V += Hk @ ga[i]
V = md(V) * ik1 % p
for j in range(r):
    Ho = omn[j][mulmap(d3, sig - degs[j])]    # N_3 x N_(sig-e_j)
    V = md(V + md(Ho @ gc[j]))
# V[y, u] = psi(G u y); consistency over all factorizations of each monomial
M3 = mulmap(d3, dQ)
Gam = np.full(N[sig], -1.0); bad = 0
flatM = M3.ravel(); flatV = V.ravel()
order = np.argsort(flatM, kind='stable'); fm = flatM[order]; fv = flatV[order]
first = np.r_[True, fm[1:] != fm[:-1]]
Gam[fm[first]] = fv[first]
bad = int(np.sum(fv != Gam[fm]))
assert (Gam >= 0).all()
log("Gamma = psi(G .) on S_sig: factorisations compared", len(fv), "disagreements", bad)
GAMMA_CONSISTENT = (bad == 0)
# ---------------------------------------------------------------- order 2
Pm = nu[mulmap(dQ, 3)]                       # pi(Q g), Q in S_dQ, g in S_3
Kl = nullspace(Pm.T.astype(np.int64))        # Q with pi(Q S_3) = 0  (columns)
TNL = nullspace(Pm.astype(np.int64))         # g with pi(S_dQ g) = 0
log("dim T NL", TNL.shape[1], "dim K_l", Kl.shape[1])
assert not md(Pm @ G).any(), "G not in T NL"
MG = multmat(G, 3, dQ)                         # N_sig x N_dQ : Q -> Q G
psiQG2 = md(MG.T @ Gam)                        # psi(Q G^2) for Q in basis S_dQ
if os.path.exists(os.path.join(D, 'qv.txt')):
    qv = rm('qv.txt').ravel()
    log("CHECK order-2 vector psi(Q G^2): numpy Gamma route == BC-SO qVector (kappa-free):", bool((qv % p == psiQG2).all()))
o2 = md(psiQG2 @ Kl)
log("order 2: psi(Q G^2) on K_l zero:", not o2.any(), " nonzero on S_dQ:", bool(psiQG2.any()))
r2 = md(psiQG2 * ((k + 1) * inv(2) % p))
g2, _ = solve(Pm.astype(np.int64), r2.astype(np.int64))
assert g2 is not None
g2 = g2.astype(np.float64)
log("g2_0 nonzero:", bool(g2.any()), " g2_0 in T NL:", not md(Pm @ g2).any())
# ---------------------------------------------------------------- level-2 tools
Delta = md(Dfull * ik1 + np.outer(nu, kap))     # psiW(w, Y) = Delta[:, w] . Y
dG = [der(G, 3, i) for i in range(nv)]
dW = [md(dermat(3, i) @ Wpoly) for i in range(nv)]     # N_2 x nW
# Y_v = G div a_v + a_v . grad G   (N_sig x N_dQ)
divA = sum(dermat(sig - 2, i) @ ga[i] for i in range(nv))       # N_(sig-3) = N_dQ x N_dQ(v)
Ymat = md(multmat(G, 3, dQ) @ md(divA))
for i in range(nv): Ymat = md(Ymat + multmat(dG[i], 2, sig - 2) @ ga[i])
P1 = md(Delta.T @ Ymat)                         # nW x N_dQ : psiW(w, Y_v)
# Gamma-a: Gam . (a_v,i * q) for q in S_2  -> Ga[w, v] = Gam . (a_v . grad W_w)
HG = Gam[mulmap(2, sig - 2)]                    # N_2 x N_(sig-2)
Ga = np.zeros((nW, N[dQ]))
for i in range(nv): Ga = md(Ga + dW[i].T @ md(HG @ ga[i]))
# split maps for I-parts: e_j terms s (deg sig-e_j) -> (w, v)
spl = []
for j in range(r):
    uc, vi = splitmaps(sig - degs[j], 3 - degs[j])
    spl.append((np.array([widx[(j, int(c))] for c in uc]), vi))
def splitE(e):
    """e: list of coefficient vectors (deg sig-e_j); returns Cw (nW x N_dQ) with e.f = sum_v (sum_w Cw[w,v] W_w) v"""
    Cw = np.zeros((nW, N[dQ]))
    for j in range(r):
        wid, vi = spl[j]; nz = np.nonzero(e[j])[0]
        np.add.at(Cw, (wid[nz], vi[nz]), e[j][nz])
    return md(Cw)
# C3: split of c_v (I-part of G v) for every v: nonzeros (w', v, v')
C3w, C3v, C3vp, C3val = [], [], [], []
for j in range(r):
    wid, vi = spl[j]
    nzs, nzv = np.nonzero(gc[j])
    C3w.append(wid[nzs]); C3v.append(nzv); C3vp.append(vi[nzs]); C3val.append(gc[j][nzs, nzv])
C3w = np.concatenate(C3w); C3v = np.concatenate(C3v); C3vp = np.concatenate(C3vp); C3val = np.concatenate(C3val)
log("C3 nonzeros", len(C3val))
# Q[w1, v', w2] = psiW(w1, a_v' . grad W_w2)
Qt = np.zeros((nW * N[dQ], nW))
MS = mulmap(sig - 2, 2)                          # N_(sig-2) x N_2
for q in range(N[2]):
    Dq = Delta[MS[:, q], :]                      # N_(sig-2) x nW : Delta[mu+q, w1]
    Rq = np.stack([md(Dq.T @ ga[i]) for i in range(nv)], axis=0)    # nv x nW x N_dQ
    dWq = np.stack([dW[i][q, :] for i in range(nv)], axis=0)         # nv x nW(w2)
    if not dWq.any(): continue
    Qt = md(Qt + np.einsum('iab,ic->abc', Rq, dWq).reshape(nW * N[dQ], nW))
Qt = Qt.reshape(nW, N[dQ], nW)
log("Q tensor done")
def psi3(K):
    """psi3(G G (K G)) for K in S_dQ (coefficient vector); requires nu(K G) = 0 (true since G in T NL)"""
    b = [md(ga[i] @ K) for i in range(nv)]
    e = [md(gc[j] @ K) for j in range(r)]
    divb = md(sum(dermat(sig - 2, i) @ b[i] for i in range(nv)))
    Y1 = mul(G, 3, divb, sig - 3)
    for i in range(nv): Y1 = md(Y1 + 2 * mul(b[i], sig - 2, dG[i], 2))
    T1 = float(md(Gam @ Y1))
    Cw = splitE(e)
    T2a = float(md(np.sum(md(Cw * P1)))) + float(md(np.sum(md(Cw * Ga))))
    # B1 = sum C3[w',v,v'] Cw[w,v] Q[w',v',w] ; B2 = sum C3[w',v,v'] Cw[w,v] Q[w,v',w']
    Pa = md(Qt.reshape(nW * N[dQ], nW) @ Cw).reshape(nW, N[dQ], N[dQ])          # [w', v', v]
    B1 = float(md(np.sum(md(C3val * Pa[C3w, C3vp, C3v]))))
    Qs = np.transpose(Qt, (2, 1, 0)).reshape(nW * N[dQ], nW)                   # [w', v'] x w
    Pb = md(Qs @ Cw).reshape(nW, N[dQ], N[dQ])                                  # [w', v', v]
    B2 = float(md(np.sum(md(C3val * Pb[C3w, C3vp, C3v]))))
    return (T1 + T2a + B1 + B2) * ik2 % p, (T1, T2a, B1, B2)
def psiKGg2(K): return float(md(Gam @ mul(K, dQ, g2, 3)))
cA = (k + 1) % p; cB = (k + 1) * (k + 2) * inv(6) % p        # c3 = (k+1) psi(KGg2) - (C(k+2,3)/k) psi3(KG^3)
def c3(K):
    a = psiKGg2(K); b3, parts = psi3(K)
    return (cA * a - cB * b3) % p, a, b3
out = {}
# reference comparisons (validation mode)
if os.path.exists(os.path.join(D, 'refs.txt')):
    refs = rl('refs.txt')
    for (Kc, v3) in refs:
        K = np.array(Kc, dtype=np.float64)
        log("REF psi3(K G^3): numpy", psi3(K)[0], "M2 engine", v3 % p, "equal", psi3(K)[0] == v3 % p)
# main tests
def randTNL(): return md(TNL @ rng.integers(0, p, TNL.shape[1])).astype(np.float64)
if dQ == 3:
    a, b3 = psiKGg2(G), psi3(G)[0]
    log("CHECK psi(G^2 g2_0): Gamma route", a, "== (2/(k+1)) pi(g2_0^2):", a == float(md(nu @ mul(g2, 3, g2, 3))) * 2 * ik1 % p)
    cG = (cA * a - cB * b3) % p
    log("RESULT c3(G) = (k+1) psi(G^2 g2_0) - C(k+2,3)/k psi3(G^4):", cG, " parts: psi(G^2 g2_0) =", a, ", psi3(G^4) =", b3)
# freedom matrix on K_l x T NL: (k+1) psi(K G w)
HGam = Gam[mulmap(dQ, 3)]
Fr = md(md(Kl.T.astype(np.float64) @ HGam) @ TNL.astype(np.float64))
log("freedom (k+1) psi(K G w) on K_l x T NL: rank", len(rref(Fr.astype(np.int64))[1]))
res = []
for t in range(int(sys.argv[4]) if len(sys.argv) > 4 else 4):
    K = md(Kl @ rng.integers(0, p, Kl.shape[1])).astype(np.float64)
    res.append(c3(K))
log("RESULT c3(K) for random K in K_l:", [x[0] for x in res], " (psi parts", [x[1] for x in res], "psi3 parts", [x[2] for x in res], ")")
# nontriviality: random Q in S_dQ (outside K_l)
Qr = rng.integers(0, p, N[dQ]).astype(np.float64)
log("NONTRIVIAL c3(Q), Q random in S_dQ:", c3(Qr)[0], " Q in K_l:", not md(Pm.T @ Qr).any() if False else not md(Qr @ Pm).any())
if dQ == 3:
    I3 = os.path.exists(os.path.join(D, 'I3.txt'))
    Wr = md(Wpoly @ rng.integers(0, p, nW)).astype(np.float64)
    log("ARG check c3(W), W random in I_3 (must be 0):", c3(Wr)[0], " W in K_l:", not md(Wr @ Pm).any())
log("O3NP DONE")
