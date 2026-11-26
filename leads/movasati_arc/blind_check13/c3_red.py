#!/usr/bin/env python3
"""C3, reduced (Kuranishi-type) system: T_n = T_n^0 + k_n + pi_n, k_n in ker L (101-dim), pi_n in the span of 19 monomials,
pi_n fixed by 19 'pivot' rows of the order-n equations.  ob_n = Kl * (order-n residual) in K^26 are polynomial maps of
(k_2..k_(n-1)); an order-6 jet with the given T_1 exists iff ob_3 = ob_4 = ob_5 = ob_6 = 0 has a solution.
usage: c3_red.py file p lam"""
import sys, time
sys.path.insert(0, "/home/claude/blind_check13")
from c3_lib import *
fn = sys.argv[1]; p = int(sys.argv[2]); lam = int(sys.argv[3])
hdr, idx, D, tl = read_arc(fn)
S = Setup(p); z = S.z; x = S.gens
allT = [S.parse(l) for l in tl]; Ts = allT[:5]
L1s = [(2 * i, 2 * i + 1, 1) for i in range(5)]; L2s = [(2 * i, 2 * i + 1, 3 if i < 3 else 1) for i in range(5)]
tab = S.table([L1s, L2s], [1, lam % p])
t0 = time.time()
X = C3(S, tab, Ts, verbose=False)
mons = X.mons; index = X.index
L = X.J[0]; Kl = X.Kl; J = X.J
piv = sorted(set(tuple(m) for m in allT[-1].monoms()), reverse=True)
pc = [index[m_] for m_ in piv]
_, prow = rref(L[:, pc].T, p)                      # 19 independent rows of L on the pivot columns
Linv = None
from flint import nmod_mat
Ms = nmod_mat(19, 19, [int(v) for v in L[np.ix_(prow, pc)].reshape(-1)], p).inv()
Linv = np.array([[int(Ms[i, j]) for j in range(19)] for i in range(19)], dtype=np.int64)
def lift(r):
    """pi in the span of the 19 monomials with (L pi + r) = 0 on the 19 pivot rows"""
    out = np.zeros(120, dtype=np.int64)
    out[pc] = (-(Linv @ (r[prow] % p))) % p
    return out
Kb = nullspace(L, p)                                # 120 x 101
b = X.b
def NLs(d2, d3, d4):
    y = np.concatenate([d2, d3, d4, np.zeros(120, dtype=np.int64)])
    return X.NL(y)
def ob(k2, k3, k4, k5, full=False):
    d2 = k2 % p
    r3 = (J[1] @ d2 - b[45:90]) % p; pi3 = lift(r3); d3 = (k3 + pi3) % p
    z120 = np.zeros(120, dtype=np.int64)
    nl = NLs(d2, z120, z120)
    r4 = (J[2] @ d2 + J[1] @ d3 + nl[90:135] - b[90:135]) % p; pi4 = lift(r4); d4 = (k4 + pi4) % p
    nl = NLs(d2, d3, z120)
    r5 = (J[3] @ d2 + J[2] @ d3 + J[1] @ d4 + nl[135:180] - b[135:180]) % p; pi5 = lift(r5); d5 = (k5 + pi5) % p
    nl = NLs(d2, d3, d4)
    o6 = (Kl @ ((J[4] @ d2 + J[3] @ d3 + J[2] @ d4 + J[1] @ d5) % p) + nl[180:206] - b[180:206]) % p
    o = np.concatenate([Kl @ r3 % p, Kl @ r4 % p, Kl @ r5 % p, o6])
    return (o, (d2, d3, d4, d5)) if full else o
rng = np.random.default_rng(777)
def rk(sub=None):
    B = Kb if sub is None else sub
    return B @ rng.integers(0, p, size=B.shape[1]) % p
Z = np.zeros(120, dtype=np.int64)
o0 = ob(Z, Z, Z, Z)
print("==", fn, "p", p, "lambda", lam)
print("ob at the base jet: non-zero entries by order 3,4,5,6:", [int(np.count_nonzero(o0[26 * j:26 * (j + 1)])) for j in range(4)])
# exact linear parts by matrix algebra (Schur complements)
def liftM(R):
    out = np.zeros((120, R.shape[1]), dtype=np.int64); out[pc] = (-(Linv @ (R[prow] % p))) % p; return out
S3 = liftM(J[1] @ Kb % p)                                           # pi_3 as a function of k_2
S4 = liftM((J[2] @ Kb + J[1] @ S3) % p)                             # pi_4 of k_2
S4b = liftM(J[1] @ Kb % p)                                          # pi_4 of k_3  (= S3)
S5 = liftM((J[3] @ Kb + J[2] @ S3 + J[1] @ S4) % p)                 # pi_5 of k_2
lev1 = Kl @ (J[1] @ Kb % p) % p                                     # order n, k_(n-1)
lev2 = Kl @ ((J[2] @ Kb + J[1] @ S3) % p) % p                       # order n, k_(n-2)
lev3 = Kl @ ((J[3] @ Kb + J[2] @ S3 + J[1] @ S4) % p) % p           # order n, k_(n-3)
lev4 = Kl @ ((J[4] @ Kb + J[3] @ S3 + J[2] @ S4 + J[1] @ S5) % p) % p   # order 6, k_2
print("linear response maps coker L <- ker L (26 x 101):  rank level1 (T_(n-1)) =", rank(lev1, p), " level2 (T_(n-2)) =", rank(lev2, p),
      " level3 (T_(n-3)) =", rank(lev3, p), " level4 (order 6 <- T_2) =", rank(lev4, p),
      " ; rank [level3 | level4] =", rank(np.hstack([lev3, lev4]), p))
e6 = o0[78:104]
print("order-6 defect e6 in im(level3):", rank(np.hstack([lev3, e6.reshape(-1, 1)]), p) == rank(lev3, p),
      " ; in im(level3) + im(level4):", rank(np.hstack([lev3, lev4, e6.reshape(-1, 1)]), p) == rank(np.hstack([lev3, lev4]), p))
N3 = nullspace(lev3, p)                             # coordinates in the basis Kb
K3 = Kb @ N3 % p                                    # ker of level 3 inside ker L (120 x 94)
print("ker(level3) in ker L: dim", K3.shape[1], " ; T_1 in it:", rank(np.hstack([K3, vec_of(S, Ts[0], index).reshape(-1, 1)]), p) == K3.shape[1],
      " ; level4 restricted to ker(level3): rank", rank(lev4 @ N3 % p, p),
      " ; rank of [level3 | level4 on ker level3 | e6] - rank without e6:",
      rank(np.hstack([lev3, lev4 @ N3 % p, e6.reshape(-1, 1)]), p) - rank(np.hstack([lev3, lev4 @ N3 % p]), p))
# identity tests of the polynomial structure
print("-- random tests (dense random points)")
for trial in range(3):
    k2, k3, k4, k5 = rk(), rk(), rk(), rk()
    o = ob(k2, k3, k4, k5)
    oa = ob(k2, Z, Z, Z); ob_ = ob(k2, k3, Z, Z)
    print("   ob3 == 0:", not o[:26].any(), " ob4 == 0:", not o[26:52].any(),
          " ; ob5 depends on k3,k4:", bool((o[52:78] != oa[52:78]).any()),
          " ; ob6 depends on k4,k5:", bool((o[78:] != ob_[78:]).any()), " ; ob6 depends on k3:", bool((ob_[78:] != oa[78:]).any()))
# ob5 as a function of k2: D k2 + q(k2)
i2 = pow(2, p - 2, p)
def q5(k2):
    g1 = ob(k2, Z, Z, Z)[52:78]; g2 = ob(2 * k2 % p, Z, Z, Z)[52:78]; g3 = ob(3 * k2 % p, Z, Z, Z)[52:78]
    quad = (g2 - 2 * g1) * i2 % p
    lin = (g1 - quad) % p
    cubic_ok = not ((g3 - 3 * lin - 9 * quad) % p).any()
    return lin, quad, cubic_ok
rowsq = []; okl = True; okc = True
for trial in range(40):
    a = rng.integers(0, p, size=101); k2 = Kb @ a % p
    lin, quad, c_ok = q5(k2)
    okl = okl and not ((lin - lev3 @ a) % p).any(); okc = okc and c_ok
    rowsq.append(quad)
Uq = rref(np.array(rowsq), p)[0]
print("ob5(k2) = level3 k2 + q(k2), q quadratic: linear part agrees with level3:", okl, " ; no cubic part:", okc,
      " ; dim span of q-values on ker L (40 samples):", len(Uq), " ; im(level3) meets that span in dim",
      rank(lev3, p) + len(Uq) - rank(np.vstack([lev3.T, Uq]), p))
rowsq3 = []
for trial in range(40):
    k2 = rk(K3); lin, quad, c_ok = q5(k2); rowsq3.append(quad)
Uq3 = rref(np.array(rowsq3), p)[0] if np.array(rowsq3).any() else np.zeros((0, 26), dtype=np.int64)
print("q restricted to ker(level3) (94-dim): dim span of values (40 samples):", len(Uq3))
np.save("/home/claude/blind_check13/red_%d.npy" % p, np.array([0]))
print("time %.1fs" % (time.time() - t0))
