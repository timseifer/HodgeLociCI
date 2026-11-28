# Main session, 28 Nov 2026: run14b, part (b) of run14 after an environment restart (loads the 9-jet saved by run13).
"""[main session, run8] Order 8 on top of the checker's order-7 search (run7b.py, copied verbatim up to the
k4-solve).  Order 7, nonlinear part: on V6, q(u) = ell . ob_7(u) (ell annihilating im J3 = im J4) varies in a 2-dim space.
Restrict to a random 2-plane in the k2-directions of A2 (k3 corrected by a FIXED linear right inverse of J3, so the
restriction is polynomial), interpolate, intersect by a resultant, look for F_p points, then solve k4 and check directly."""
import sys; sys.path.insert(0, "/home/claude/blind_check15")
exec(open("/home/claude/blind_check15/run7.py").read().split("# 1. identity check")[0])
sys.path.insert(0, "/home/claude/work/fast"); import fastper as _fp; _fp.install(S, "/home/claude/work/fast/phi_%d" % p)
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

            # ------------------------------------------------------------ order 8 (main session, 27 Nov)
            print("ORDER 8 begins %.0fs" % (time.time()-t0), flush=True)
            Ydirs = dirs; J4s = J4
            R4, pc4 = rref(J4s, p); Rt4, pr4 = rref(J4s.T, p)
            Y4 = np.zeros((J4s.shape[1], 26), dtype=np.int64); Y4[np.ix_(pc4, pr4)] = to_np(mat_mod(J4s[np.ix_(pr4, pc4)] % p, p).inv())
            def jet7(kk):
                """kk on V6 (orders 2..6 hold); correct k3 (order 6) then k4 (order 7) by fixed linear right inverses"""
                kk = {n: kk[n].copy() for n in kk}
                o6 = ev(kk, 6)[6]; kk[3] = (kk[3] - Y @ o6) % p
                o7 = ev(kk, 7)[7]; kk[4] = (kk[4] - Ydirs @ (Y4 @ o7)) % p
                return kk
            def ob8(kk):
                o, T = fs.evaluate(kk, 7)
                P_ = {n: fs.poly3(T[n]) for n in range(2, 7)}
                c7 = fs.cprime(7, T, P_); T7 = (-fs.X @ c7) % p
                Ts = [fs.T1] + [P_[n] for n in range(2, 7)] + [fs.poly3(T7)]
                E = fs.S.expseries(Ts, 8)
                c8 = fs.S.periods(E[8], fs.tab) % p
                return o, fs.Kl @ c8 % p, T, T7
            k7 = k
            o, b8, T, T7 = ob8(k7)
            print("base jet: ob_2..ob_7 nonzero", [int(np.count_nonzero(o[n])) for n in range(2, 8)], "; ob_8 nonzero", int(np.count_nonzero(b8)), "of 26 ; %.0fs" % (time.time()-t0), flush=True)
            # J3 at order 8 = response of ob_8 to k5
            cols = []
            for i in range(10):
                e = {m: k7[m].copy() for m in k7}; e[5] = (e[5] + fs.rng.integers(0, p, size=dimK)) % p
                cols.append((ob8(e)[1] - b8) % p)
            W5 = np.array(cols).T % p
            print("response of ob_8 to k5 (10 random): rank", rank(W5, p), "; same image as J3:", rank(np.hstack([W5, J3]), p) == rank(J3, p), "; %.0fs" % (time.time()-t0), flush=True)
            q8b = ell @ b8 % p
            print("q8 = ell . ob_8 at the base jet: nonzero", int(np.count_nonzero(q8b)), "of 19", flush=True)
            # variations that keep orders 2..7: k2 inside A2 n {q7 = 0} (directions in N2 killed by the linear part of q7),
            # k3 in ker J3, k4 in ker J4 (sampled dirs), k5 and k6 free
            Nq = []
            # linear part of q7 on N2 directions (q7 affine in k2, by the checker): sample
            base_q7 = q(point(0, 0))[1]
            Lq = []
            NB = N2.shape[1]
            sub = fs.rng.integers(0, p, size=(NB, 24))
            for i in range(24):
                kk = {n: base[n].copy() for n in base}; kk[2] = (base[2] + N2 @ sub[:, i]) % p
                o6 = ev(kk, 6)[6]; kk[3] = (kk[3] - Y @ o6) % p
                Lq.append((ell @ ev(kk, 7)[7] - base_q7) % p)
            Lq = np.array(Lq).T % p
            nq = nullspace(Lq, p)                       # combinations of the 24 sampled directions killing q7's linear part
            D2 = N2 @ sub @ nq % p                      # k2 directions inside A2 n {q7 = 0}
            print("q7 linear part on 24 sampled A2 directions: rank", rank(Lq, p), "; directions kept:", D2.shape[1], "; %.0fs" % (time.time()-t0), flush=True)
            var = []
            for i in range(min(D2.shape[1], 10)):
                kk = {n: k7[n].copy() for n in k7}; kk[2] = (kk[2] + D2[:, i]) % p
                kk = jet7(kk); o, b, _, _ = ob8(kk)
                ok = max(int(np.count_nonzero(o[n])) for n in range(2, 8)) == 0
                var.append(((ell @ b - q8b) % p, ok))
            print("k2 variations: all stay on V7:", all(v[1] for v in var), "; %.0fs" % (time.time()-t0), flush=True)
            Kj3 = nullspace(J3, p); Kj4 = Ydirs @ nullspace(J4s, p) % p
            for nm, blk, Dm in (("k3 in ker J3", 3, Kj3), ("k4 in ker J4", 4, Kj4)):
                for i in range(min(Dm.shape[1], 3)):
                    kk = {n: k7[n].copy() for n in k7}; kk[blk] = (kk[blk] + Dm[:, i]) % p
                    kk = jet7(kk); o, b, _, _ = ob8(kk)
                    ok = max(int(np.count_nonzero(o[n])) for n in range(2, 8)) == 0
                    var.append(((ell @ b - q8b) % p, ok))
                print(nm, ": variations added; on V7:", all(v[1] for v in var), "; %.0fs" % (time.time()-t0), flush=True)
            Wv = np.array([v[0] for v in var]).T % p
            r = rank(Wv, p)
            inside = in_span(Wv, q8b, p)
            print("RESULT order 8: span of q8 variations (k2 in A2', k3 in ker J3, k4 in ker J4): rank", r, "; q8 at the base in that span:", inside, flush=True)
            # ---- q8 on a 2-plane of k2-directions inside A2' (nonlinear): degree probe, interpolation, resultant
            contrib = [i for i in range(min(D2.shape[1], 10)) if var[i][0].any()]
            print("k2 directions with a non-zero q8 change:", len(contrib), "of", min(D2.shape[1], 10), "; k3/k4 changes non-zero:", [bool(v[0].any()) for v in var[min(D2.shape[1], 10):]], flush=True)
            v2b = D2[:, contrib[0]]; w2b = D2 @ fs.rng.integers(0, p, size=D2.shape[1]) % p
            def pt8(s_, t_):
                kk = {n: k7[n].copy() for n in k7}; kk[2] = (kk[2] + s_ * v2b + t_ * w2b) % p
                kk = jet7(kk); o, b, T, T7 = ob8(kk)
                assert max(int(np.count_nonzero(o[n])) for n in range(2, 8)) == 0
                return kk, ell @ b % p
            vals = [q8b] + [pt8(s_, 0)[1] for s_ in range(1, 7)]
            V = np.array(vals) % p; dg = None
            for d_ in range(6):
                Dd = V.copy()
                for _ in range(d_ + 1): Dd = (Dd[1:] - Dd[:-1]) % p
                if not Dd.any(): dg = d_; break
            print("q8 along a k2-line: degree", dg, "; %.0fs" % (time.time()-t0), flush=True)
            if dg is not None:
                d = dg
                grid = [(a_, b_) for a_ in range(d + 1) for b_ in range(d + 1 - a_)]
                Qv = {(a_, 0): vals[a_] for a_ in range(d + 1)}
                for g_ in grid:
                    if g_ not in Qv: Qv[g_] = pt8(*g_)[1]
                mons = [(i, j) for i in range(d + 1) for j in range(d + 1 - i)]
                Mv = np.array([[pow(a_, i, p) * pow(b_, j, p) % p for (i, j) in mons] for (a_, b_) in grid], dtype=np.int64)
                C = to_np(mat_mod(Mv, p).inv()) @ np.array([Qv[g_] for g_ in grid]) % p
                _, qx = pt8(d + 2, 3); pred = np.array([pow(d+2, i, p) * pow(3, j, p) for (i, j) in mons]) @ C % p
                print("interpolant predicts an off-grid point:", not ((pred - qx) % p).any(), "; %.0fs" % (time.time()-t0), flush=True)
                Rr, piv = rref(C.T, p)
                polys = [sp.Poly(sum(int(r[m]) * S_**i * T_**j for m, (i, j) in enumerate(mons)), S_, T_, modulus=p) for r in Rr]
                print("independent component polys:", len(polys), "; degrees", [P_.total_degree() for P_ in polys], flush=True)
                from flint import nmod_poly
                xs = nmod_poly([0, 1], p); found = None
                def fp_roots(P1):
                    co = [int(c) % p for c in P1.all_coeffs()]; f_ = nmod_poly(co[::-1], p)
                    if f_.degree() <= 0: return []
                    g_ = f_.gcd(pow(xs, p, f_) - xs); out = []
                    if g_.degree() > 0:
                        for r0 in range(p):
                            if g_(r0) == 0: out.append(r0)
                            if len(out) == g_.degree(): break
                    return out
                if len(polys) == 1:
                    P0 = polys[0]
                    for s0 in range(1, 60):
                        rts = fp_roots(sp.Poly(P0.as_expr().subs(S_, s0), T_, modulus=p))
                        if rts: found = (s0, rts[0]); break
                elif len(polys) >= 2:
                    rp = sp.Poly(sp.resultant(polys[0].as_expr(), polys[1].as_expr(), T_), S_, modulus=p)
                    print("resultant degree", rp.degree(), flush=True)
                    for s0 in fp_roots(rp):
                        cs = [sp.Poly(P_.as_expr().subs(S_, s0), T_, modulus=p) for P_ in polys]
                        gg = cs[0]
                        for c_ in cs[1:]: gg = sp.gcd(gg, c_)
                        rts = fp_roots(gg) if gg.degree() > 0 else []
                        if rts: found = (s0, rts[0]); break
                print("F_p point with q8 = 0 on the plane:", found, flush=True)
                if found:
                    kk, qq = pt8(*found)
                    o, b, T, T7 = ob8(kk)
                    print("at the point: q8 nonzero", int(np.count_nonzero(qq)), "; ob_8 nonzero", int(np.count_nonzero(b)), flush=True)
                    dirs5 = fs.rng.integers(0, p, size=(dimK, 12)); cols = []
                    for i in range(12):
                        e = {m: kk[m].copy() for m in kk}; e[5] = (e[5] + dirs5[:, i]) % p
                        cols.append((ob8(e)[1] - b) % p)
                    W5b = np.array(cols).T % p; Ah5 = np.hstack([W5b, (b % p).reshape(-1, 1)])   # W5b a = -b (sign fixed 27 Nov)
                    if rank(Ah5, p) == rank(W5b, p):
                        Nn = nullspace(Ah5, p); jj = int(np.flatnonzero(Nn[-1])[0]); a5 = Nn[:-1, jj] * pow(int(Nn[-1, jj]), p-2, p) % p
                        kk[5] = (kk[5] + dirs5 @ a5) % p
                        o, b, T, T7 = ob8(kk)
                        print("after the k5 step: ob_8 nonzero", int(np.count_nonzero(b)), flush=True)
                        P_ = {n: fs.poly3(T[n]) for n in range(2, 7)}
                        Ts = [fs.T1] + [P_[n] for n in range(2, 7)] + [fs.poly3(T7)]
                        E = fs.S.expseries(Ts, 8); c8 = fs.S.periods(E[8], fs.tab) % p
                        Ts = Ts + [fs.poly3((-fs.X @ c8) % p)]
                        E = fs.S.expseries(Ts, 8)
                        cnt = [int(np.count_nonzero(fs.S.periods(E[n], fs.tab))) for n in range(1, 9)]
                        print("RESULT DIRECT verification of jet T_1..T_8: nonzero c_n among 45, n = 1..8:", cnt, flush=True)
                        with open(sys.argv[6] if len(sys.argv) > 6 else "/tmp/jet8.txt", "w") as fo:
                            for t_ in Ts: fo.write(str(t_) + "\n")
                        # ------------------------------------------------------------ order 9 (27 Nov, step 3c)
                        print("ORDER 9 begins %.0fs" % (time.time()-t0), flush=True)
                        D5 = dirs5; W5s = W5b
                        R5, pc5 = rref(W5s, p); Rt5, pr5 = rref(W5s.T, p)
                        Y5 = np.zeros((W5s.shape[1], 26), dtype=np.int64); Y5[np.ix_(pc5, pr5)] = to_np(mat_mod(W5s[np.ix_(pr5, pc5)] % p, p).inv())
                        def jet8(kk):
                            kk = jet7(kk); o, b, T_, T7_ = ob8(kk)
                            kk = {n: kk[n].copy() for n in kk}; kk[5] = (kk[5] - D5 @ (Y5 @ b)) % p
                            return kk
                        def ob9(kk):
                            o, b, T_, T7_ = ob8(kk)
                            P_ = {n: fs.poly3(T_[n]) for n in range(2, 7)}
                            Ts_ = [fs.T1] + [P_[n] for n in range(2, 7)] + [fs.poly3(T7_)]
                            E_ = fs.S.expseries(Ts_, 8); c8_ = fs.S.periods(E_[8], fs.tab) % p
                            Ts_ = Ts_ + [fs.poly3((-fs.X @ c8_) % p)]
                            E_ = fs.S.expseries(Ts_, 9); c9_ = fs.S.periods(E_[9], fs.tab) % p
                            return o, b, fs.Kl @ c9_ % p
                        k8 = jet8(kk)
                        o, b, b9 = ob9(k8)
                        print("base V8 jet: ob_2..ob_7 nonzero", [int(np.count_nonzero(o[n])) for n in range(2, 8)], "; ob_8 nonzero", int(np.count_nonzero(b)), "; ob_9 nonzero", int(np.count_nonzero(b9)), "; %.0fs" % (time.time()-t0), flush=True)
                        q9b = ell @ b9 % p
                        print("q9 at the base: nonzero", int(np.count_nonzero(q9b)), "of 19", flush=True)
                        # ------------------------------------------------------------ run14: which moves act linearly on order 10 at the 9-jet (PREREG_order9_nonlinear.md)
                        import json
                        print("RUN14 begins %.0fs" % (time.time()-t0), flush=True)
                        Kj4 = Ydirs @ nullspace(J4s, p) % p
                        v2 = D2 @ fs.rng.integers(0, p, size=D2.shape[1]) % p; w2 = D2 @ fs.rng.integers(0, p, size=D2.shape[1]) % p
                        v3 = Kj3 @ fs.rng.integers(0, p, size=Kj3.shape[1]) % p; w3 = Kj3 @ fs.rng.integers(0, p, size=Kj3.shape[1]) % p
                        k4a = Kj4 @ fs.rng.integers(0, p, size=Kj4.shape[1]) % p; k4b = Kj4 @ fs.rng.integers(0, p, size=Kj4.shape[1]) % p
                        def q8of(kk):
                            kk7 = jet7(kk); o_, b_, _, _ = ob8(kk7); return ell @ b_ % p, o_
                        def solve2(Mc, rhs):
                            Ah = np.hstack([Mc, rhs.reshape(-1, 1)])
                            if rank(Ah, p) != rank(Mc, p): return None
                            Nn = nullspace(Ah, p); jj = int(np.flatnonzero(Nn[-1])[0]); return Nn[:-1, jj] * pow(int(Nn[-1, jj]), p-2, p) % p
                        def vpoint(s_, t_, k4dirs=()):
                            k = {m: k8[m].copy() for m in k8}; k[2] = (k[2] + s_ * v2 + t_ * w2) % p
                            vals = []
                            for (a_, b_) in ((0, 0), (1, 0), (0, 1)):
                                kk = {m: k[m].copy() for m in k}; kk[3] = (kk[3] + a_ * v3 + b_ * w3) % p
                                qq, o_ = q8of(kk); vals.append(qq)
                            Mc = np.array([(vals[1] - vals[0]) % p, (vals[2] - vals[0]) % p]).T
                            ab = solve2(Mc, vals[0])          # Mc ab = -q8(0,0)
                            if ab is None: return None, "q8 not solvable by k3 at this point (rank %d)" % rank(Mc, p)
                            k[3] = (k[3] + int(ab[0]) * v3 + int(ab[1]) * w3) % p
                            out = []
                            for d4 in ((None,) + tuple(k4dirs)):
                                kk = {m: k[m].copy() for m in k}
                                if d4 is not None: kk[4] = (kk[4] + d4) % p
                                kk = jet8(kk); o_, b_, b9_ = ob9(kk)
                                ok = max(int(np.count_nonzero(o_[n])) for n in range(2, 8)) == 0 and not b_.any()
                                out.append((ell @ b9_ % p, ok))
                            return out, "ok"

                        Z = np.load("/home/claude/work/fast/k9_%d.npz" % p)
                        k9 = {int(m): Z[m].copy() for m in Z.files if m.isdigit()}
                        W4, D4, W6, dirs6, v2, w2, v3, w3 = [Z[n] for n in ("W4", "D4", "W6", "dirs6", "v2", "w2", "v3", "w3")]
                        W5q = np.load("/home/claude/work/fast/W5q_%d.npy" % p)
                        def jet_terms(kk, N):
                            o, b, T_, T7_ = ob8(kk)
                            P_ = {n: fs.poly3(T_[n]) for n in range(2, 7)}
                            Ts_ = [fs.T1] + [P_[n] for n in range(2, 7)] + [fs.poly3(T7_)]
                            for n in range(8, N + 1):
                                E_ = fs.S.expseries(Ts_, n); c_ = fs.S.periods(E_[n], fs.tab) % p
                                Ts_ = Ts_ + [fs.poly3((-fs.X @ c_) % p)]
                            return o, Ts_
                        sys.path.insert(0, "/home/claude/work/fast"); import fastper
                        Afun, tvec = fastper.install_A(fs.S, "/home/claude/work/fast/phi_%d" % p, fs.tab)
                        def ob10(kk):
                            o, Ts_ = jet_terms(kk, 9)
                            E_ = fs.S.expseries(Ts_, 9)
                            cnt = [int(np.count_nonzero(fs.S.periods(E_[n], fs.tab) % p)) for n in range(1, 10)]
                            c10 = np.zeros(45, dtype=np.int64)
                            for j in range(1, 10): c10 = (c10 + j * (Afun(E_[10 - j]) @ tvec(Ts_[j - 1]))) % p
                            c10 = c10 * pow(10, p - 2, p) % p
                            return cnt, fs.Kl @ c10 % p, Ts_
                        def rekill9(kk):
                            """restore q8 = 0 (k3 along v3, w3), q9 = 0 (k4 along D4) and the J3 part of ob9 (k6 along dirs6), linearly"""
                            vals = []
                            for (a_, b_) in ((0, 0), (1, 0), (0, 1)):
                                e = {m: kk[m].copy() for m in kk}; e[3] = (e[3] + a_ * v3 + b_ * w3) % p
                                vals.append(q8of(e)[0])
                            Mc = np.array([(vals[1] - vals[0]) % p, (vals[2] - vals[0]) % p]).T
                            ab = solve2(Mc, vals[0])
                            if ab is None: return None
                            kk = {m: kk[m].copy() for m in kk}; kk[3] = (kk[3] + int(ab[0]) * v3 + int(ab[1]) * w3) % p
                            kk = jet8(kk); o, b, bb = ob9(kk); q = ell @ bb % p
                            if q.any():
                                a_ = solve2(W4, q)
                                if a_ is None: return ("q9-not-in-L4", q)
                                kk[4] = (kk[4] + D4 @ a_) % p; kk = jet8(kk); o, b, bb = ob9(kk)
                            a_ = solve2(W6, bb)
                            if a_ is None: return None
                            kk[6] = (kk[6] + dirs6 @ a_) % p
                            return kk

                        cnt, b10, Ts9 = ob10(k9)
                        q10b = ell @ b10 % p
                        Pi5 = nullspace(W5q.T, p).T
                        print("9-jet reloaded: nonzero c_n, n = 1..9:", cnt, "; q10 nonzero", int(np.count_nonzero(q10b)), "; %.0fs" % (time.time()-t0), flush=True)
                        base10 = Pi5 @ q10b % p
                        def d10(kk):
                            cnt_, bb, _ = ob10(kk); return max(cnt_) == 0, (Pi5 @ (ell @ bb % p) - base10) % p
                        chA = []; WAq = np.zeros((Pi5.shape[0], 0), dtype=np.int64); WA = DA = DA0 = np.zeros((1, 1), dtype=np.int64)
                        print("(a) skipped in run14b: done in run14 (rank 0)", flush=True)
                        # (b) k3 in ker J3 keeping q8 to first order (q8 is linear in k3), then q9 restored by rekill9 where possible
                        R3 = fs.rng.integers(0, p, size=(Kj3.shape[1], 6)); DB = Kj3 @ R3 % p; cols = []
                        q8base = q8of(k9)[0]
                        for i in range(6):
                            e = {m: k9[m].copy() for m in k9}; e[3] = (e[3] + DB[:, i]) % p
                            cols.append((q8of(e)[0] - q8base) % p)
                        WB = np.array(cols).T % p; NB = nullspace(WB, p); DB0 = DB @ NB % p
                        print("(b) q8 response to 6 k3 directions: rank", rank(WB, p), "; kernel combinations:", DB0.shape[1], flush=True)
                        chB = []
                        for i in range(min(4, DB0.shape[1])):
                            e = {m: k9[m].copy() for m in k9}; e[3] = (e[3] + DB0[:, i]) % p; e = rekill9(e)
                            if e is None: print("   (b) combo", i, ": rekill failed", flush=True); continue
                            if isinstance(e, tuple): print("   (b) combo", i, ": q9 leaves the k4 image (nonzero", int(np.count_nonzero(Pi4q := (nullspace(W4.T, p).T @ e[1] % p))), ")", flush=True); continue
                            ok, d = d10(e); chB.append(d)
                            print("   (b) combo", i, ": on V9", ok, "; change of q10 mod k5-image nonzero", int(np.count_nonzero(d)), "; %.0fs" % (time.time()-t0), flush=True)
                        if chB:
                            WBq = np.array(chB).T % p
                            print("RESULT (b) rank of q10 changes from k3 moves keeping V9:", rank(WBq, p), "; together with (a):", rank(np.hstack([WAq, WBq]), p) if chA else rank(WBq, p), flush=True)
                        allq = np.hstack([x for x in (WAq, np.array(chB).T % p if chB else None) if x is not None and x.size]) if (chA or chB) else None
                        if allq is not None:
                            print("RESULT q10 mod k5-image at base in the span of these linear moves:", in_span(allq, base10, p), "; rank with base:", rank(np.hstack([allq, base10.reshape(-1, 1)]), p), flush=True)
                        np.savez("/home/claude/work/fast/run14b_%d.npz" % p, WA=WA, DA=DA, DA0=DA0, WAq=WAq, WB=WB, DB=DB, DB0=DB0, base10=base10, Pi5=Pi5)
                        print("RESULT run14 done ; %.0fs" % (time.time()-t0), flush=True)
                    else:
                        print("RESULT k5 step not solvable", flush=True)
                else:
                    print("RESULT no F_p point found on this plane (inconclusive for the full space)", flush=True)
            else:
                print("RESULT degree of q8 along a line > 5: not handled", flush=True)
            print("RESULT (interpretation is tentative: the variations are first differences, not a linear model)", flush=True)

print("total %.0fs" % (time.time()-t0))
