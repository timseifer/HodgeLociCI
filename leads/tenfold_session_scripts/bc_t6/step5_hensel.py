# Lyapunov-Schmidt / Hensel arc construction with ALL lower-order corrections, exact mod p.
# Arc: F_1 = v fixed; for k>=2, F_k = sigma(Im-part of 3 r_k) + K_k, K_k in ker L_W (free kernel coordinates).
# c_k = cokernel coordinates of r_k (must vanish).  At an order n with c_n != 0 we search kernel corrections
# K_j (j = n-1, n-2, ..., 2), computing the EXACT effect by rebuilding the arc (finite differences), then
# verify the corrected arc by full recomputation.  Usage: python3 step5_hensel.py p lam N slice btype seed
import sys, time, json, os
sys.path.insert(0, '/home/claude/hodge/discovery/checks/bc_t6')
from arc import *
p = int(sys.argv[1]); lam = int(sys.argv[2]); N = int(sys.argv[3]); sl = sys.argv[4]; btype = sys.argv[5]
seed = int(sys.argv[6]) if len(sys.argv) > 6 else 1
S = {"8": [0, 1, 6, 7, 8, 9, 10, 11], "10": [0, 1, 2, 3, 6, 7, 8, 9, 10, 11], "12": list(range(12))}[sl]
St = Setup(p, lam, S)
rng = np.random.default_rng(seed); R = lambda: int(rng.integers(1, p))
x, u, v = St.x, St.u, St.v; y = [x(1), x(3), x(5)]
t0 = time.time()
# v0 = projection of a random T_Y element (same construction as step3)
cub6 = list(itertools.combinations_with_replacement(range(6, 12), 3)); vals = []
for c in cub6:
    b = [0] * 12
    for i in c: b[i] += 1
    s = 0
    for T, l in ((St.T1, 1), (St.T2, St.lam)):
        w = 1
        for e in range(3, 6): w = w * int(T[e][b[2 * e], b[2 * e + 1]]) % p
        s = (s + l * w) % p
    vals.append(s)
Nul = nullspace(np.array([vals]), p)
v0 = St.proj_W(Poly(p, [enc(np.bincount(c, minlength=12)) for c in cub6], mm(rng.integers(1, p, size=len(Nul))[None, :], Nul, p)[0]).norm())
lu = lambda a: u(3).scale(a[0]) + u(4).scale(a[1]) + u(5).scale(a[2])
lv = lambda a: v(3).scale(a[0]) + v(4).scale(a[1]) + v(5).scale(a[2])
ys = [yy for i, yy in enumerate(y) if 2 * i + 1 in S]
lf = lambda: sum((yy.scale(R()) for yy in ys[1:]), ys[0].scale(R()))
if btype == "r1diag": b = y[0] * u(3) * v(4)
elif btype == "r1": b = y[0] * lu([R(), R(), R()]) * lv([R(), R(), R()])
elif btype == "r2": b = y[0] * (lu([R(), R(), R()]) * lv([R(), R(), R()]) + lu([R(), R(), R()]) * lv([R(), R(), R()]))
elif btype == "r1y": b = lu([R(), R(), R()]) * (lf() * v(3) + lf() * v(4) + lf() * v(5))
elif btype == "r1yT": b = (lf() * u(3) + lf() * u(4) + lf() * u(5)) * lv([R(), R(), R()])
elif btype == "r2y": b = lu([R(), R(), R()]) * (lf() * v(3) + lf() * v(4) + lf() * v(5)) + lu([R(), R(), R()]) * (lf() * v(3) + lf() * v(4) + lf() * v(5))
elif btype == "r3y": b = sum((lu([R(), R(), R()]) * (lf() * v(3) + lf() * v(4) + lf() * v(5)) for _ in range(2)), lu([R(), R(), R()]) * (lf() * v(3) + lf() * v(4) + lf() * v(5)))
F1 = St.proj_W(v0 + b)
LW = St.Mmat(Poly.mono(p, [0] * NV))
nW, ne = len(St.Wmon), len(St.P)
Rr, piv = rref(LW, p); rk = len(piv)
Ker = nullspace(LW, p)
# complement of Im L: greedy unit vectors
ImB = LW[:, piv]
_, piv2 = rref(np.c_[ImB, np.eye(ne, dtype=np.int64)], p)
comp = [c - rk for c in piv2 if c >= rk]
Aug = np.c_[ImB, np.eye(ne, dtype=np.int64)[:, comp]] % p
AugInv = None
# Aug is square invertible (ne x ne): precompute inverse via rref of [Aug | I]
Rinv, pv = rref(np.c_[Aug, np.eye(ne, dtype=np.int64)], p)
AugInv = Rinv[:, ne:]
print(f"slice {sl} lam {lam} btype {btype} seed {seed}: |W|={nW} #eq={ne} rank L_W={rk} dim ker={len(Ker)} coker={len(comp)}", flush=True)
assert not mm(LW, St.Wvec(F1), p).any()

def split(r):
    """3r = L F + C c  -> (F as W-vector supported on pivots, c coker coords)"""
    sol = mm(AugInv, (3 * r) % p, p)
    F = np.zeros(nW, np.int64); F[piv] = sol[:rk]
    return F, sol[rk:]

def build(K, n_to, cache=None):
    """K: dict j -> kernel W-vector. returns Fs (list of Poly), cs (dict k -> coker coords)"""
    Fs = [F1]; cs = {}
    for k in range(2, n_to + 1):
        E = expE(Fs + [Poly(p)], p, k)
        r = St.phi(E[k])
        Fv, c = split(r)
        cs[k] = c
        if k in K: Fv = (Fv + K[k]) % p
        Fs.append(St.Wpoly(Fv))
    return Fs, cs

K = {}
log = []
for n in range(2, N + 1):
    Fs, cs = build(K, n)
    bad = [k for k in range(2, n + 1) if cs[k].any()]
    if not bad:
        print(f"order {n}: OK ({time.time()-t0:.0f}s)", flush=True); log.append([n, "ok"]); continue
    assert bad == [n], bad
    c0 = cs[n]
    print(f"order {n}: coker residual nonzero in {int((c0 != 0).sum())} of {len(c0)} coords; searching kernel corrections", flush=True)
    fixed = False
    order_js = sorted(range(2, n), key=lambda j: (abs(j - (n - 3)), j))
    nnz = int((c0 != 0).sum())
    tries = [(j, min(len(Ker), nnz + 8)) for j in order_js] + [(j, min(len(Ker), len(comp) + 2)) for j in order_js if len(comp) + 2 > nnz + 8]
    for j, m in tries:
        Dirs = mm(rng.integers(0, p, size=(m, len(Ker))), Ker, p)
        cols = []; lowbreak = False
        for i in range(m):
            K2 = dict(K); K2[j] = (K2.get(j, np.zeros(nW, np.int64)) + Dirs[i]) % p
            _, cs2 = build(K2, n)
            if any(cs2[k].any() for k in range(2, n)): lowbreak = True
            cols.append((cs2[n] - c0) % p)
        A = np.array(cols, np.int64).T % p
        coef = rng.integers(0, p, size=m)
        K2 = dict(K); K2[j] = (K2.get(j, np.zeros(nW, np.int64)) + mm(coef[None, :], Dirs, p)[0]) % p
        _, cs2 = build(K2, n)
        lin_ok = not ((cs2[n] - c0 - mm(A, coef, p)) % p).any() and not any(cs2[k].any() for k in range(2, n))
        s = solve(A, (-c0) % p, p)
        print(f"   K_{j}: rank of effect (on {m} random kernel dirs) {rank(A, p)}, lower orders preserved: {not lowbreak}, exactly linear: {lin_ok}, solvable: {s is not None}", flush=True)
        if s is not None and lin_ok and not lowbreak:
            K2 = dict(K); K2[j] = (K2.get(j, np.zeros(nW, np.int64)) + mm(s[None, :], Dirs, p)[0]) % p
            _, cs2 = build(K2, n)
            if not any(cs2[k].any() for k in range(2, n + 1)):
                K = K2; fixed = True
                print(f"   order {n} FIXED with kernel correction at order {j} ({time.time()-t0:.0f}s)", flush=True)
                log.append([n, f"fixed-K{j}"]); break
        if fixed: break
    if not fixed:
        # nonlinear one-parameter search: K_j += s*d, coker coords polynomial in s; find roots in F_p
        import sympy
        D = 7
        for j in [2] + list(range(3, n)):
            for trial in range(int(os.environ.get("TRIALS", "3"))):
                d = mm(rng.integers(0, p, size=(1, len(Ker))), Ker, p)[0]
                pts = list(range(D + 1)); vals_ = []
                for s_ in pts:
                    K2 = dict(K); K2[j] = (K2.get(j, np.zeros(nW, np.int64)) + s_ * d) % p
                    _, cs2 = build(K2, n)
                    vals_.append(np.concatenate([cs2[k] for k in range(2, n + 1)]))
                vals_ = np.array(vals_, np.int64)
                # interpolate each coordinate (degree <= D) ; Vandermonde
                V = np.array([[pow(s_, e, p) for e in range(D + 1)] for s_ in pts], np.int64)
                Vinv = rref(np.c_[V, np.eye(D + 1, dtype=np.int64)], p)[0][:, D + 1:]
                C = mm(Vinv, vals_, p)  # (D+1) x ncoords : coefficients
                lowc = C[:, :-len(comp)]
                if lowc.any():
                    # need a common root of lower-order coords too: skip unless identically zero
                    continue
                cn = C[:, -len(comp):]
                sx = sympy.symbols('s')
                roots = None
                for col in range(cn.shape[1]):
                    poly = [int(a) for a in cn[::-1, col]]
                    if not any(poly): continue
                    fl = sympy.Poly(poly, sx, modulus=p).factor_list()[1]
                    rts = set(int((-f.all_coeffs()[1] * pow(int(f.all_coeffs()[0]), p - 2, p)) % p) for f, m_ in fl if f.degree() == 1)
                    roots = rts if roots is None else roots & rts
                degs = [max([e for e in range(D + 1) if cn[e, col]] or [-1]) for col in range(cn.shape[1])]
                print(f"   K_{j} along random line (trial {trial}): degrees in s of order-{n} coker coords {degs[:6]}..., F_p-roots common: {sorted(roots)[:3] if roots else roots}", flush=True)
                for rt in (roots or []):
                    K2 = dict(K); K2[j] = (K2.get(j, np.zeros(nW, np.int64)) + rt * d) % p
                    _, cs2 = build(K2, n)
                    if not any(cs2[k].any() for k in range(2, n + 1)):
                        K = K2; fixed = True
                        print(f"   order {n} FIXED (nonlinear) with K_{j} += s*d, s = {rt} ({time.time()-t0:.0f}s)", flush=True)
                        log.append([n, f"fixed-nonlinear-K{j}"]); break
                if fixed: break
            if fixed: break
    if not fixed:
        print(f"   order {n}: NOT fixed by single-order kernel corrections (linear or one-parameter nonlinear)", flush=True)
        log.append([n, "not-fixed"]); break
Fs, cs = build(K, len(log) and max(l[0] for l in log if l[1] != "not-fixed") or 1)
E = expE(Fs, p, len(Fs)); rs = [St.phi(E[k]) for k in range(len(Fs) + 1)]
van = max(k for k in range(len(Fs) + 1) if all(not rs[i].any() for i in range(1, k + 1)))
print(f"FINAL VERIFIED: all {ne} equations vanish through order {van} (arc of length {len(Fs)}), supports {[len(f) for f in Fs]}")
fn = f'/home/claude/hodge/discovery/checks/bc_t6/hensel_{p}_{lam}_{sl}_{btype}_{seed}.txt'
with open(fn, 'w') as fh:
    fh.write(json.dumps({"p": p, "lam": lam, "slice": sl, "btype": btype, "seed": seed, "log": log, "vanish_through": van,
                         "z": St.F.z, "convention": "F = F0 + sum t^j F_j ; planes x_{2e} = z x_{2e+1} (P1), z' = z^5 on pairs 3,4,5 (P2)"}) + "\n")
    for j, f in enumerate(Fs):
        fh.write(f"F{j+1}: " + json.dumps([[list(map(int, dec_arr([k])[0])), int(c)] for k, c in zip(f.k, f.c)]) + "\n")
