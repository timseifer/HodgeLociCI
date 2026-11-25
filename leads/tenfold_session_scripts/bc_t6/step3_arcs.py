# Arc extension test in an equivariant slice.
# usage: python3 step3_arcs.py p lam N slice btype seed
#   slice "8": variables of pairs 0,3,4,5 (arc invariant under scaling of pairs 1,2)
#   slice "10": pairs 0,1,3,4,5 ; slice "12": everything
#   btype: r1diag  b = y0*u3*v4 ; r1  b = y0*(a.u)(c.v) random ; r2  b = y0*u^T A v, A random rank 2 ;
#          r1y  b = (a.u)(l(y).v) with l_f random in span(y0,y1)  (needs slice 10/12);  r1yT transpose type
import sys, time, json
sys.path.insert(0, '/home/claude/hodge/discovery/checks/bc_t6')
from arc import *

p = int(sys.argv[1]); lam = int(sys.argv[2]); N = int(sys.argv[3]); sl = sys.argv[4]; btype = sys.argv[5]
seed = int(sys.argv[6]) if len(sys.argv) > 6 else 1
v0mode = sys.argv[7] if len(sys.argv) > 7 else "TY"
S = {"8": [0, 1, 6, 7, 8, 9, 10, 11], "10": [0, 1, 2, 3, 6, 7, 8, 9, 10, 11], "12": list(range(12))}[sl]
St = Setup(p, lam, S)
rng = np.random.default_rng(seed)
R = lambda: int(rng.integers(1, p))
x, u, v = St.x, St.u, St.v
y = [x(1), x(3), x(5)]
t0 = time.time()
# ---- v0 : projection (along J) of a random element of T_Y (cubics in x6..x11 killed by the fourfold functional)
cub6 = list(itertools.combinations_with_replacement(range(6, 12), 3))
vals = []
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
coef = mm(rng.integers(1, p, size=len(Nul))[None,:], Nul, p)[0]
v0 = Poly(p, [enc(np.bincount(c, minlength=12)) for c in cub6], coef).norm()
v0 = St.proj_W(v0)
if v0mode == "zero": v0 = Poly(p)
if v0mode == "uv":
    LW_ = St.Mmat(Poly.mono(p, [0] * NV))
    pu = St.proj_W(u(3) * u(4) * u(5)); pv = St.proj_W(v(3) * v(4) * v(5))
    ru = mm(LW_, St.Wvec(pu), p); rv = mm(LW_, St.Wvec(pv), p)
    i0 = int(np.flatnonzero(ru)[0])
    A_ = int(rv[i0]); B_ = (-int(ru[i0])) % p
    v0 = pu.scale(A_) + pv.scale(B_)
    print("v0 = A u3u4u5 + B v3v4v5 (pure fourfold direction); ratio B/A =", B_ * pow(A_, p - 2, p) % p, flush=True)
if btype == "r1diag":
    b = y[0] * u(3) * v(4)
elif btype == "r1":
    a = [R() for _ in range(3)]; c = [R() for _ in range(3)]
    b = y[0] * (u(3).scale(a[0]) + u(4).scale(a[1]) + u(5).scale(a[2])) * (v(3).scale(c[0]) + v(4).scale(c[1]) + v(5).scale(c[2]))
elif btype == "r2":
    A1 = [R() for _ in range(3)]; C1 = [R() for _ in range(3)]; A2 = [R() for _ in range(3)]; C2 = [R() for _ in range(3)]
    lu = lambda a: u(3).scale(a[0]) + u(4).scale(a[1]) + u(5).scale(a[2])
    lv = lambda a: v(3).scale(a[0]) + v(4).scale(a[1]) + v(5).scale(a[2])
    b = y[0] * (lu(A1) * lv(C1) + lu(A2) * lv(C2))
elif btype in ("r1y", "r1yT", "r2y"):
    ys = [yy for i, yy in enumerate(y) if 2 * i + 1 in S]
    lf = lambda: sum((yy.scale(R()) for yy in ys[1:]), ys[0].scale(R()))
    a = [R() for _ in range(3)]
    if btype == "r1y":
        b = (u(3).scale(a[0]) + u(4).scale(a[1]) + u(5).scale(a[2])) * (lf() * v(3) + lf() * v(4) + lf() * v(5))
    elif btype == "r1yT":
        b = (lf() * u(3) + lf() * u(4) + lf() * u(5)) * (v(3).scale(a[0]) + v(4).scale(a[1]) + v(5).scale(a[2]))
    else:
        b = (u(3).scale(a[0]) + u(4).scale(a[1]) + u(5).scale(a[2])) * (lf() * v(3) + lf() * v(4) + lf() * v(5)) + \
            (u(3).scale(R()) + u(4).scale(R()) + u(5).scale(R())) * (lf() * v(3) + lf() * v(4) + lf() * v(5))
F1 = St.proj_W(v0 + b)
# ---- checks of the direction against the full (12-variable) first-order data
M1 = np.load('/home/claude/hodge/discovery/checks/bc_t6/M1_%d.npy' % p) if False else None
LW = St.Mmat(Poly.mono(p, [0] * NV))
print("slice", sl, "|W| =", len(St.Wmon), "#eqs =", len(St.P), "rank L_W =", rank(LW, p), "lam", lam, "btype", btype, "seed", seed, flush=True)
print("L_W F1 == 0:", not mm(LW, St.Wvec(F1), p).any(), " L_W v0 == 0:", not mm(LW, St.Wvec(St.proj_W(v0)), p).any(), flush=True)
# membership tests in the full 364-dim space of cubics
CUB = cubic_monos(); cidx = {enc(bb): i for i, bb in enumerate(CUB)}
def cvec(poly):
    w = np.zeros(len(CUB), np.int64)
    for k, c in zip(poly.k, poly.c): w[cidx[int(k)]] = c
    return w
allv = [x(i) for i in range(12)]; quads = [allv[i] * allv[j] for i in range(12) for j in range(i, 12)]
Jl = [cvec(x(j) * x(i) * x(i)) for i in range(12) for j in range(12)]
vv = lambda e: v(e)
TV = np.array(Jl + [cvec(u(i) * q) for i in range(3) for q in quads] + [cvec(u(e) * vv(f) * xx) for e in range(3, 6) for f in range(3, 6) for xx in allv]) % p
rTV = rank(TV, p)
print("dim TVZ", rTV, "; v0 in TVZ:", rank(np.r_[TV, [cvec(v0)]], p) == rTV, "; b in TVZ:", rank(np.r_[TV, [cvec(b)]], p) == rTV,
      "; F1 in TVZ:", rank(np.r_[TV, [cvec(F1)]], p) == rTV, flush=True)
Fs = [F1]
inv3 = pow(3, p - 2, p)

def residuals(Fs, n):
    E = expE(Fs, p, n)
    return E, [St.phi(E[k]) for k in range(n + 1)]

def full_linear_test(Fs, n, E):
    """unknowns kappa_2..kappa_n in W; block (k,j) = M_{k-j} = -(1/3) Phi(P w E_{k-j}).
       returns solution or None. rhs: -r_n at order n, 0 below (Fs must satisfy orders < n)."""
    nW = len(St.Wmon); ne = len(St.P)
    Ms = {s: (St.Mmat(E[s]) * (p - inv3)) % p for s in range(0, n - 1)}
    orders = list(range(2, n + 1))
    BigM = np.zeros((ne * len(orders), nW * len(orders)), np.int64)
    for a, k in enumerate(orders):
        for bb, j in enumerate(orders):
            if j <= k:
                BigM[a * ne:(a + 1) * ne, bb * nW:(bb + 1) * nW] = Ms[k - j]
    rhs = np.zeros(ne * len(orders), np.int64)
    return BigM, rhs

log = {"p": p, "lam": lam, "slice": sl, "btype": btype, "seed": seed, "orders": []}
for n in range(2, N + 1):
    Fs_try = Fs + [Poly(p)]
    E = expE(Fs_try, p, n)
    r = St.phi(E[n])
    sol = solve(LW, (3 * r) % p, p)
    if sol is not None:
        Fs = Fs + [St.Wpoly(sol)]
        print(f"order {n}: residual in Im L (no lower corrections needed); |E_n|={len(E[n])}; t={time.time()-t0:.0f}s", flush=True)
        log["orders"].append([n, "ok-direct"])
        continue
    cvec_ = nullspace(LW.T % p, p)  # cokernel functionals
    print(f"order {n}: coker dim {len(cvec_)}, coker components of residual:", [int(mm(cc[None,:], r, p)[0]) for cc in cvec_], flush=True)
    # exact corrections: kappa_j for j >= j0 > n/2 (no nonlinear feedback up to order n)
    done = False
    for j0 in range(n, n // 2, -1):
        BigM, rhs = full_linear_test(Fs_try, n, E)
        ne = len(St.P); nW = len(St.Wmon)
        a0 = j0 - 2
        sub = BigM[a0 * ne:, a0 * nW:]
        rr = np.zeros(sub.shape[0], np.int64); rr[-ne:] = (-r) % p
        s1 = solve(sub, rr, p)
        if s1 is not None:
            newFs = list(Fs_try)
            for bb, j in enumerate(range(j0, n + 1)):
                newFs[j - 1] = newFs[j - 1] + St.Wpoly(s1[bb * nW:(bb + 1) * nW])
            E2, rs2 = residuals(newFs, n)
            assert not any(rs2[k].any() for k in range(1, n + 1)), "exact correction failed?"
            Fs = newFs; done = True
            print(f"   fixed EXACTLY using corrections kappa_{j0}..kappa_{n} (j0 > n/2, so no nonlinear feedback); t={time.time()-t0:.0f}s", flush=True)
            log["orders"].append([n, f"ok-corrections-from-{j0}"])
            break
    if done:
        continue
    print("   not fixable with kappa_j, j > n/2", flush=True)
    if __import__("os").environ.get("NOLIN"):
        log["orders"].append([n, "stop"]); break
    # linearised test with all lower-order corrections kappa_2..kappa_n
    BigM, rhs = full_linear_test(Fs_try, n, E)
    ne = len(St.P)
    rhs[-ne:] = (-r) % p
    rkM = rank(BigM, p)
    solk = solve(BigM, rhs, p)
    print(f"order {n}: residual NOT in Im L. linearised system with corrections kappa_2..kappa_{n}: rank {rkM}, solvable: {solk is not None}; t={time.time()-t0:.0f}s", flush=True)
    # also restricted corrections j > n/2 (exact, no nonlinear feedback)
    if solk is None:
        log["orders"].append([n, "obstructed-linearised"])
        # dimension of obstruction: rank jump
        print("   rank [BigM | rhs] =", rank(np.c_[BigM, rhs], p), flush=True)
        break
    # apply corrections, then Newton-iterate on the full residual vector up to order n
    nW = len(St.Wmon)
    newFs = list(Fs_try)
    for bb, j in enumerate(range(2, n + 1)):
        kap = St.Wpoly(solk[bb * nW:(bb + 1) * nW])
        newFs[j - 1] = newFs[j - 1] + kap
    ok = False
    for it in range(int(__import__("os").environ.get("NEWTON", "0"))):
        E, rs = residuals(newFs, n)
        bad = [k for k in range(1, n + 1) if rs[k].any()]
        if not bad:
            ok = True; break
        BigM, rhs = full_linear_test(newFs, n, E)
        for a, k in enumerate(range(2, n + 1)):
            rhs[a * ne:(a + 1) * ne] = (-rs[k]) % p
        s2 = solve(BigM, rhs, p)
        if s2 is None:
            print("   Newton step unsolvable at iteration", it, "bad orders", bad); break
        for bb, j in enumerate(range(2, n + 1)):
            newFs[j - 1] = newFs[j - 1] + St.Wpoly(s2[bb * nW:(bb + 1) * nW])
        print("   Newton it", it, "bad orders", bad, flush=True)
    if ok:
        Fs = newFs
        log["orders"].append([n, "ok-after-corrections"])
        print(f"   order {n} reached after corrections; t={time.time()-t0:.0f}s", flush=True)
    else:
        log["orders"].append([n, "newton-failed"])
        break
# final verification of the arc
E, rs = residuals(Fs, len(Fs)); print("final residual nonzero orders:", [k for k in range(1, len(Fs) + 1) if rs[k].any()])
vanish = max([k for k in range(len(Fs) + 1) if all(not rs[j].any() for j in range(1, k + 1))])
print("FINAL: arc with", len(Fs), "terms; all equations vanish through order", vanish, "; supports", [len(f) for f in Fs])
log["vanish_through"] = vanish
with open(f'/home/claude/hodge/discovery/checks/bc_t6/arc_{p}_{lam}_{sl}_{btype}_{seed}_{v0mode}.txt', 'w') as fh:
    fh.write(json.dumps(log) + "\n")
    for j, f in enumerate(Fs):
        fh.write(f"F{j+1}: " + json.dumps([[list(map(int, dec_arr([k])[0])), int(c)] for k, c in zip(f.k, f.c)]) + "\n")
