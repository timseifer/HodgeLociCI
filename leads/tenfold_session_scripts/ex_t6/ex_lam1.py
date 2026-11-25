# EX-T6 goal 2: EXACT arc at lambda = -1 to order 8 for the explicit direction of dirs_exact.py (top-term corrections,
# as in step (e)); final order-8 correction applied by the exact affine formula (c_8 is affine in x5 with T_6, T_7 re-solved).
import sys, time, pickle, numpy as np
sys.path.insert(0, '/home/claude/hodge/discovery/checks/ex_t6')
from fex import *
from exarc import *
from dirs_exact import *
from mc_exact import mc_exact
import dirs_exact
SUF = '' if dirs_exact.KIND == 'al' else '_' + dirs_exact.KIND
lam = -1
t00 = time.time()
def say(*a): print(*a, "(%.0fs)" % (time.time() - t00), flush=True)
X = ExactEngine(lam); X.setup_L()
v = v_exact(X, lam); v0 = v0_exact(X, lam)
Mc, _ = mc_exact(X, lam); TC = kernel(Mc)
XP1 = ExactEngine(0); LP1 = XP1.MH(XP1.poly_one())
say("lambda -1: rank L =", X.Lrank // 2, " L v = 0:", iszero(X.L * v), " Mc v0 = 0:", iszero(Mc * v0), " Mc v != 0:", not iszero(Mc * v),
    " L_P1 v != 0:", not iszero(LP1 * v), " dim T Cone_T =", TC.ncols() // 2, " in ker L:", iszero(X.L * TC))
arc = Arc(X, v)
seg = segre_tangent(X)
W = hcat(TC, *seg, *[zmul_vec(s, X.nm) for s in seg])
hist = []
for n in range(5, 9):
    arc.extend(n, verbose=True)
    low = [k for k in range(2, n) if not iszero(arc.Kc[k])]
    assert not low, ("lower orders nonzero", low)
    j = n - 3
    if n < 8 or True:
        dc = lin(X, arc.MHs, j, X.kerL, n)
        Dn = X.K * dc[n]
        lowd = [m for m in range(j + 1, n) if not iszero(X.K * dc[m])]
        rD = rank(Dn)
        if n == 5:
            D5 = Dn
            dcW = lin(X, arc.MHs, 2, W, 5)
            say("rank DG4(v) =", rD // 2, " dim T_v Sigma1 =", rank(W) // 2, " DG4 kills T_v Sigma1:", iszero(X.K * dcW[5]))
        say("order", n, ": K.c_n nnz", nnz(arc.Kc[n]), " x_%d effect: rank" % j, rD // 2, " equals DG4(v) of order 5:", Dn == D5,
            " no effect on orders", j + 1, "..", n - 1, ":", not lowd, " K.c_n in Im:", rank(hcat(Dn, arc.Kc[n])) == rD)
    if iszero(arc.Kc[n]):
        hist.append((n, 'zero')); continue
    x = solve_part(Dn, -arc.Kc[n])
    assert x is not None
    if n < 8:
        arc.set_x(j, x)
        hist.append((n, 'corrected x%d' % j))
        pickle.dump({"xs": {k: [str(t) for t in xx.entries()] for k, xx in arc.xs.items()}}, open('lam1_xs_%d%s.pkl' % (n, SUF), 'wb'))
    else:
        # exact affine update for x5 (no recomputation of E'_5..E'_7 needed)
        dT5 = X.kerL * x
        d = lin(X, arc.MHs, 5, dT5, 8)
        ok_low = iszero(X.K * d[6]) and iszero(X.K * d[7])
        c8 = arc.cs[8] + d[8]
        Ts = list(arc.Ts)
        Ts[4] = Ts[4] + dT5; Ts[5] = Ts[5] + X.SL * d[6]; Ts[6] = Ts[6] + X.SL * d[7]
        cs = list(arc.cs); cs[6] = cs[6] + d[6]; cs[7] = cs[7] + d[7]; cs[8] = c8
        sol = [iszero(X.L * Ts[k - 1] + cs[k]) for k in range(2, 8)]
        Kz = [iszero(X.K * cs[k]) for k in range(2, 9)]
        say("final x5 by the exact affine formula: K.dc6 = K.dc7 = 0:", ok_low, " L T_n + c_n = 0 (n=2..7):", sol, " K.c_n = 0 (n=2..8):", Kz)
        hist.append((8, 'corrected x5 (affine)'))
        pickle.dump({"Ts": [[str(t) for t in T.entries()] for T in Ts], "c8": [str(t) for t in c8.entries()],
                     "xs": {k: [str(t) for t in xx.entries()] for k, xx in list(arc.xs.items()) + [(5, x)]}},
                    open('/home/claude/hodge/discovery/checks/ex_t6/arc_lam1_exact' + SUF + '.pkl', 'wb'))
        hs = [max(max(abs(int(fmpq(t).p)).bit_length(), int(fmpq(t).q).bit_length()) for t in T.entries()) for T in Ts]
        say("saved arc_lam1_exact.pkl; max bit sizes of T_1..T_7 entries:", hs)
say("history", hist)
