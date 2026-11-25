# RC-T6: independent order-6 test for a generic rank-1 direction (finite differences on EXACT rebuilds, fe engine
# validated against hl.py; does not use step (e)'s jac/lin_maps). MOD p.
# Unknowns: x2, x3 (ker L coordinates of T_2, T_3), x4 (checked to have no K-effect at order 6).
# usage: python3 ord6.py p lam seed kind
import sys, numpy as np, time
sys.path.insert(0, '/home/claude/hodge/discovery/checks/rc_t6'); sys.path.insert(0, '/home/claude/hodge/discovery/t6_unsolved/e')
from ana import setup, directions
from run2c import build
p, lam, seed, kind = int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3]), sys.argv[4]
E, X = setup(p, lam); rng = np.random.default_rng(seed)
v, info = directions(E, X, rng, kind)
nk = E.kerL.shape[1]; t0 = time.time()
def K(xs, n):
    Ts, Kc, _ = build(E, v, xs, n); return Kc
base = K({}, 6)
print(kind, "lam", lam, "seed", seed, "base K.c_n nnz n=2..6:", [int(np.count_nonzero(base[n])) for n in range(2, 7)], flush=True)
# order-5 effect of x2 (exact finite differences, check linearity with 2e_i)
A5 = np.zeros((E.Kl.shape[0], nk), np.int64); A6x3 = np.zeros_like(A5); lin_ok = True; x4_eff = 0
for i in range(nk):
    e = np.zeros(nk, np.int64); e[i] = 1
    k1 = K({2: e}, 5); k2 = K({2: 2 * e}, 5)
    d1 = (k1[5] - base[5]) % p; d2 = (k2[5] - base[5]) % p
    if ((d2 - 2 * d1) % p).any() or any(k1[m].any() for m in range(2, 5)): lin_ok = False
    A5[:, i] = d1
    k3 = K({3: e}, 6); A6x3[:, i] = (k3[6] - base[6]) % p
    if any(k3[m].any() for m in range(2, 6)): lin_ok = False
    if i < 20:
        k4 = K({4: e}, 6); x4_eff += int(((k4[6] - base[6]) % p).any())
print("x2 -> K.c5 exactly linear & lower orders untouched:", lin_ok, " rank A5 =", E.rank(A5), " rank A6(x3) =", E.rank(A6x3),
      " same image:", E.rank(np.concatenate([A5, A6x3], 1)) == E.rank(A5), " x4 effect at order 6 (20 dirs):", x4_eff, " (%.0fs)" % (time.time() - t0), flush=True)
# solve order 5
s = E.solve(A5, (-base[5]) % p)
print("order 5 solvable via x2:", s is not None, flush=True)
if s is None: sys.exit()
x2s = s % p
b6 = K({2: x2s}, 6)
assert not any(b6[m].any() for m in range(2, 6))
Im = A6x3
print("order 6 at x2*: K.c6 nnz", int(np.count_nonzero(b6[6])), " in Im(x3-effect)?", E.in_span(Im, b6[6]), flush=True)
# directions k in ker A5 (preserve order 5 exactly, since linear); K.c6 along x2* + s k for s = 1,2,3: mod Im
Kk = E.kernel(A5)
Lam = []; quad_in_im = True
for t in range(Kk.shape[1]):
    k = Kk[:, t]
    vals = []
    for s_ in (1, 2):
        kk = K({2: (x2s + s_ * k) % p}, 6)
        assert not any(kk[m].any() for m in range(2, 6))
        vals.append((kk[6] - b6[6]) % p)
    lin = (2 * vals[0] - vals[1] * pow(2, p - 2, p) * 1) % p  # f(s)=a s + q s^2: a = 2f1 - f2/2
    quad = (vals[1] * pow(2, p - 2, p) - vals[0]) % p      # q = f2/2 - f1
    if not E.in_span(Im, quad): quad_in_im = False
    Lam.append(lin)
Lam = np.array(Lam, np.int64).T
Big = np.concatenate([Im, Lam], 1)
print("dim ker A5 =", Kk.shape[1], " rank [Im | Lambda(ker)] =", E.rank(Big), " quadratic parts in Im:", quad_in_im,
      " K.c6(x2*) in Im + Lambda(ker):", E.in_span(Big, b6[6]), " (%.0fs)" % (time.time() - t0), flush=True)
