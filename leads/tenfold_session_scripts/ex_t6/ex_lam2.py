# EX-T6 goal 1: EXACT order-6 obstruction certificate at lambda = 2 for the explicit direction of dirs_exact.py.
import sys, time, json, pickle, numpy as np
sys.path.insert(0, '/home/claude/hodge/discovery/checks/ex_t6')
from fex import *
from exarc import *
from dirs_exact import *
from mc_exact import mc_exact
import dirs_exact
SUF = '' if dirs_exact.KIND == 'al' else '_' + dirs_exact.KIND
lam = 2
t00 = time.time()
def say(*a): print(*a, "(%.0fs)" % (time.time() - t00), flush=True)
X = ExactEngine(lam); X.setup_L()
n = 221
say("rank_Q(z) L =", X.Lrank // 2, " dim ker L =", X.kerL.ncols() // 2)
v = v_exact(X, lam)
# hypotheses on v
Mc, nrows = mc_exact(X, lam)
TC = kernel(Mc)
say("Mc rows", nrows, "rank_Q(z) Mc =", rank(Mc) // 2, " dim T Cone_T =", TC.ncols() // 2, " T Cone_T in ker L:", iszero(X.L * TC))
v0 = v0_exact(X, lam)
say("Mc v0 = 0:", iszero(Mc * v0), " Mc v != 0 (v not in T Cone_T):", not iszero(Mc * v), " L v = 0:", iszero(X.L * v))
XP1 = ExactEngine(0); LP1 = XP1.MH(XP1.poly_one())
say("L_P1 v != 0 (v not in T V_Z, since T V_Z is in ker L_P1):", not iszero(LP1 * v), " L_P1 v0 != 0:", not iszero(LP1 * v0))
# base arc
arc = Arc(X, v).extend(5, verbose=True)
say("base K.c_n zero for n = 2,3,4:", [iszero(arc.Kc[k]) for k in (2, 3, 4)], " K.c5 nnz", nnz(arc.Kc[5]))
dc = lin(X, arc.MHs, 2, X.kerL, 5)
say("x2 effect on K.c3, K.c4 zero:", iszero(X.K * dc[3]), iszero(X.K * dc[4]))
D = X.K * dc[5]
rD = rank(D)
say("rank_Q(z) DG4(v) =", rD // 2)
# tangent space of Sigma1 at v: T Cone_T + T_b Segre
seg = segre_tangent(X)
W = hcat(TC, *seg, *[zmul_vec(s, X.nm) for s in seg])
say("dim_Q(z) T_v Sigma1 =", rank(W) // 2, " in ker L:", iszero(X.L * W))
dcW = lin(X, arc.MHs, 2, W, 5)
say("DG4(v) kills T_v Sigma1 (K.dc5 = 0, and K.dc3 = K.dc4 = 0):", iszero(X.K * dcW[5]), iszero(X.K * dcW[3]), iszero(X.K * dcW[4]))
# order 5 solution
x2 = solve_part(D, -arc.Kc[5])
say("order 5 solvable via x2:", x2 is not None)
arc.set_x(2, x2); arc.extend(6, verbose=True)
low = [iszero(arc.Kc[k]) for k in (2, 3, 4, 5)]
say("arc with x2*: K.c_2..K.c_5 zero exactly:", low, " K.c6 nnz", nnz(arc.Kc[6]))
for k in range(1, 6): assert iszero(X.L * arc.Ts[k - 1] + (arc.cs[k] if arc.cs[k] is not None else X.L * fmpq_mat(440, 1))) or k == 1
ob6 = arc.Kc[6]; c6 = arc.cs[6]
dc2 = lin(X, arc.MHs, 2, X.kerL, 6)
D2 = X.K * dc2[5]
say("DG4 at the corrected arc equals DG4 at the base arc (K.c5 affine in x2):", D2 == D)
dc3 = lin(X, arc.MHs, 3, X.kerL, 6)
D3 = X.K * dc3[6]
say("x3 effect at order 6: rank", rank(D3) // 2, " same image as DG4:", rank(hcat(D, D3)) == rD, " x3 effect at orders 4, 5 zero:", iszero(X.K * dc3[4]), iszero(X.K * dc3[5]))
J6 = X.K * dc2[6]
kD = kernel(D)
say("dim ker DG4(v) =", kD.ncols() // 2, " = T_v Sigma1:", rank(hcat(X.kerL * kD, W)) == kD.ncols() == rank(W))
Lam = J6 * kD
S = hcat(D, Lam)
rS = rank(S); rSo = rank(hcat(S, ob6))
say("rank_Q(z) [Im DG4 | Lambda(ker DG4)] =", rS // 2, " Lambda(ker) in Im DG4:", rS == rD, " with K.c6:", rSo // 2,
    " => K.c6 NOT in Im DG4 + Lambda(ker):", rSo > rS)
say("K.c6 in Im DG4 alone?", rank(hcat(D, ob6)) == rD)
# certificate y in Q(z)^221: y.L = 0, y.dc5(ker L) = 0, y.dc6(ker DG4) = 0, y.c6 != 0
Lcols = fmpq_mat(442, 220, [x for row in mat_to_np(X.L)[:, :220] for x in row])
C = y_constraints([Lcols, dc2[5], dc2[6] * kD], n)
Yk = kernel(C)
say("dim_Q(z) of the annihilator =", Yk.ncols() // 2, "(expected 221 - 38 - 16 =", 221 - 38 - 16, ")")
Ya = mat_to_np(Yk); best = None
c6l = c6.entries()
for k in range(Ya.shape[1]):
    y = list(Ya[:, k]); d = qz_dot(y, c6l, n)
    if d != (0, 0):
        sz = sum(1 for t in y if t != 0)
        if best is None or sz < best[0]: best = (sz, y, d)
sz, y, d = best
# clear denominators -> Z[z]
den = fmpz(1)
for t in y: den = den.lcm(fmpq(t).q) if hasattr(den, 'lcm') else den
from math import lcm, gcd
den = 1
for t in y: den = lcm(den, int(fmpq(t).q))
yi = [int(fmpq(t) * den) for t in y]
g = 0
for t in yi: g = gcd(g, t)
yi = [t // g for t in yi]
yq = [fmpq(t) for t in yi]
d = qz_dot(yq, c6l, n)
say("certificate y: nonzero entries", sz, " max |coeff|", max(abs(t) for t in yi), " y.c6 =", d)
# re-verify the certificate directly
chk_L = all(qz_dot(yq, list(mat_to_np(Lcols)[:, k]), n) == (0, 0) for k in range(220))
A5 = mat_to_np(dc2[5]); chk_D = all(qz_dot(yq, list(A5[:, k]), n) == (0, 0) for k in range(A5.shape[1]))
A6 = mat_to_np(dc2[6] * kD); chk_Lam = all(qz_dot(yq, list(A6[:, k]), n) == (0, 0) for k in range(A6.shape[1]))
say("direct check: y.L = 0:", chk_L, " y.DG4 = 0:", chk_D, " y.Lambda(ker) = 0:", chk_Lam, " y.c6 != 0:", d != (0, 0))
out = {"lambda": lam, "z": "z^2 - z + 1 = 0", "v0": V0[lam], "a": A, "l": [{str(k): c for k, c in d_.items()} for d_ in Lf],
       "y_Zz": [[yi[i], yi[n + i]] for i in range(n)], "y_dot_c6": [str(d[0]), str(d[1])],
       "forms": ["1"] + [str(m) for m in X.mons]}
json.dump(out, open('/home/claude/hodge/discovery/checks/ex_t6/cert_lam2' + SUF + '.json', 'w'))
pickle.dump({"Ts": [[str(t) for t in T.entries()] for T in arc.Ts], "x2": [str(t) for t in x2.entries()],
             "c6": [str(t) for t in c6.entries()], "y": yi}, open('/home/claude/hodge/discovery/checks/ex_t6/arc_lam2_exact' + SUF + '.pkl', 'wb'))
say("saved cert_lam2.json, arc_lam2_exact.pkl")
