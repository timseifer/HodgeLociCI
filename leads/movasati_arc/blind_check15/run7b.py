"""Order 7, nonlinear part: on V6, q(u) = ell . ob_7(u) (ell annihilating im J3 = im J4) varies in a 2-dim space.
Restrict to a random 2-plane in the k2-directions of A2 (k3 corrected by a FIXED linear right inverse of J3, so the
restriction is polynomial), interpolate, intersect by a resultant, look for F_p points, then solve k4 and check directly."""
import sys; sys.path.insert(0, "/home/claude/blind_check15")
exec(open("/home/claude/blind_check15/run7.py").read().split("# 1. identity check")[0])
import sympy as sp
seed = int(sys.argv[5]) if len(sys.argv) > 5 else 3
fs.rng = np.random.default_rng(seed)
ev = lambda k, top=7: fs.evaluate(k, top)[0]
Z = lambda: {n: np.zeros(dimK, dtype=np.int64) for n in range(2, 7)}
def jac(base, n, blk, top, dirs=None):
    ob_b = ev(base, top)[n]; cols = []
    D = np.eye(dimK, dtype=np.int64) if dirs is None else dirs
    for i in range(D.shape[1]):
        e = {m: base[m].copy() for m in base}; e[blk] = (e[blk] + D[:, i]) % p
        cols.append((ev(e, top)[n] - ob_b) % p)
    return np.array(cols).T % p, ob_b
o0 = ev(Z(), 5)
L5, _ = jac(Z(), 5, 2, 5)
Ab = np.hstack([L5, o0[5].reshape(-1, 1)]); N5 = nullspace(Ab, p); j = int(np.flatnonzero(N5[-1])[0])
part2 = N5[:-1, j] * pow(int(N5[-1, j]), p-2, p) % p; N2 = nullspace(L5, p)
base = fs.rk(); base[2] = (part2 + N2 @ fs.rng.integers(0, p, size=N2.shape[1])) % p
J3, _ = jac(base, 6, 3, 6)
R, pc = rref(J3, p); Rt, pr = rref(J3.T, p)
Y = np.zeros((dimK, 26), dtype=np.int64); Y[np.ix_(pc, pr)] = to_np(mat_mod(J3[np.ix_(pr, pc)] % p, p).inv())
assert not ((J3 @ Y @ J3 - J3) % p).any()
ell = nullspace(J3.T, p).T          # 19 x 26
print("rank J3", rank(J3, p), "#annihilators", ell.shape[0], "%.0fs" % (time.time()-t0), flush=True)
v2 = N2 @ fs.rng.integers(0, p, size=N2.shape[1]) % p; w2 = N2 @ fs.rng.integers(0, p, size=N2.shape[1]) % p
def point(s_, t_):
    k = {n: base[n].copy() for n in base}
    k[2] = (base[2] + s_ * v2 + t_ * w2) % p
    o6 = ev(k, 6)[6]; k[3] = (k[3] - Y @ o6) % p
    return k
def q(k):
    o = ev(k, 7); return o, ell @ o[7] % p
# degree probe along s-line, and dependence checks
vals = []
for s_ in range(9):
    o, qq = q(point(s_, 0)); assert max(int(np.count_nonzero(o[n])) for n in range(2, 7)) == 0; vals.append(qq)
V = np.array(vals) % p
dg = None
for d in range(9):
    D = V.copy()
    for _ in range(d + 1): D = (D[1:] - D[:-1]) % p
    if not D.any(): dg = d; break
print("q along a k2-line: degree", dg, "; rank of span of q-differences:", rank((V[1:] - V[0]).T % p, p), flush=True)
k = point(0, 0); _, qb = q(k)
k5 = {n: (k[n] + (fs.rng.integers(0, p, size=dimK) if n in (5, 6) else 0)) % p for n in k}
kk3 = {n: (k[n] + (nullspace(J3, p)[:, 0] * 5 if n == 3 else 0)) % p for n in k}
print("q changes with k5,k6:", bool(((q(k5)[1] - qb) % p).any()), "; with k3 in ker J3:", bool(((q(kk3)[1] - qb) % p).any()), flush=True)
d = dg
S_, T_ = sp.symbols("s t")
grid = [(a, b) for a in range(d + 1) for b in range(d + 1 - a)]
Qv = {}
for (a, b) in grid: Qv[(a, b)] = q(point(a, b))[1]
print("grid evaluated: %d points %.0fs" % (len(grid), time.time()-t0), flush=True)
# interpolation on the triangular grid via a linear solve for monomials s^i t^j, i+j <= d
mons = [(i, j) for i in range(d + 1) for j in range(d + 1 - i)]
Mv = np.array([[pow(a, i, p) * pow(b, j, p) % p for (i, j) in mons] for (a, b) in grid], dtype=np.int64)
Minv = to_np(mat_mod(Mv, p).inv())
Qmat = np.array([Qv[g] for g in grid]) % p       # npts x 19
C = Minv @ Qmat % p                               # nmons x 19
nonconst = C[1:].copy()
print("rank of nonconstant coefficient block:", rank(nonconst, p), "; constant part nonzero comps:", int(np.count_nonzero(C[0])), flush=True)
# check interpolation at an off-grid point
o, qx = q(point(d + 3, 2)); pred = np.array([pow(d+3, i, p) * pow(2, j, p) for (i, j) in mons]) @ C % p
print("interpolant predicts off-grid point:", not ((pred - qx) % p).any(), flush=True)
# basis of the component span
Rr, piv = rref(C.T, p)       # rows: independent combos of the 19 components
polys = []
for r in Rr:
    polys.append(sp.Poly(sum(int(r[m]) * S_**i * T_**j for m, (i, j) in enumerate(mons)), S_, T_, modulus=p))
print("#independent component polys:", len(polys), "; total degrees:", [P_.total_degree() for P_ in polys], flush=True)
if len(polys) >= 2:
    res = sp.resultant(polys[0].as_expr(), polys[1].as_expr(), T_)
    rp = sp.Poly(res, S_, modulus=p)
    print("resultant in s: degree", rp.degree(), flush=True)
    roots = [] if rp.is_zero else [int(r_) % p for r_ in sp.ground_roots(rp).keys()] if False else None
    fl = sp.polys.galoistools
    from sympy.polys.domains import ZZ
    co = [int(c) % p for c in rp.all_coeffs()]
    # roots in F_p: gcd with s^p - s
    from flint import nmod_poly
    fp = nmod_poly(co[::-1], p); xs = nmod_poly([0, 1], p)
    g = fp.gcd(pow(xs, p, fp) - xs) if fp.degree() > 0 else fp
    print("number of F_p roots of resultant:", g.degree(), flush=True)
    sols = []
    if g.degree() > 0:
        for s0 in range(p):
            if g(s0) == 0: sols.append(s0)
            if len(sols) == g.degree(): break
    found = None
    for s0 in sols:
        cs = [sp.Poly(P_.as_expr().subs(S_, s0), T_, modulus=p) for P_ in polys]
        gg = cs[0]
        for c_ in cs[1:]: gg = sp.gcd(gg, c_)
        if gg.degree() > 0:
            co2 = [int(c) % p for c in gg.all_coeffs()]; f2 = nmod_poly(co2[::-1], p)
            g2 = f2.gcd(pow(xs, p, f2) - xs)
            if g2.degree() > 0:
                for t0_ in range(p):
                    if g2(t0_) == 0: found = (s0, t0_); break
        if found: break
    print("F_p point with all component polys zero:", found, flush=True)
    if found:
        k = point(*found); o, qq = q(k)
        print("check at point: ob_2..ob_6 nonzero", [int(np.count_nonzero(o[n])) for n in range(2, 7)], "; q nonzero:", int(np.count_nonzero(qq)), flush=True)
        dirs = fs.rng.integers(0, p, size=(dimK, 16))
        J4, o7 = jac(k, 7, 4, 7, dirs)
        Jh = np.hstack([J4, o7.reshape(-1, 1)])
        if rank(Jh, p) == rank(J4, p):
            Nn = nullspace(Jh, p); jj = int(np.flatnonzero(Nn[-1])[0]); a = Nn[:-1, jj] * pow(int(Nn[-1, jj]), p-2, p) % p
            k[4] = (k[4] + dirs @ a) % p
            o, T = fs.evaluate(k, 7)
            print("after k4-solve (rank", rank(J4, p), "): ob_2..ob_7 nonzero", [int(np.count_nonzero(o[n])) for n in range(2, 8)], flush=True)
            c7 = fs.cprime(7, T, {n: fs.poly3(T[n]) for n in range(2, 7)})
            T7 = (-fs.X @ c7) % p
            print("DIRECT verification of jet T_1..T_7: nonzero c_n among 45, n=1..7:", fs.direct(T, T7), flush=True)
        else:
            print("k4-solve not solvable in the sampled directions")
print("total %.0fs" % (time.time()-t0))
