#!/usr/bin/env python3
"""C3 reduced system, order 6:  ob6(k2,k3) = e6 + level4 k2 + level3 k3 + (non-linear part).  Is the non-linear part
zero modulo im(level3) on k2 in ker(level3)?  usage: c3_red2.py file p lam [ntrials]"""
import sys, time
exec(open("/home/claude/blind_check13/c3_red.py").read().split("# identity tests of the polynomial structure")[0])
nt = int(sys.argv[4]) if len(sys.argv) > 4 else 12
i2 = pow(2, p - 2, p); i6 = pow(6, p - 2, p)
I3 = rref(lev3.T, p)[0]                                # basis of im(level3), 7 x 26
def mod3(v):                                           # is v in im(level3)?
    return rank(np.vstack([I3, v % p]), p) == len(I3)
t1 = time.time()
quad_in = []; cub_zero = []; cross_in = []; lin_ok = []; qrows = []; crows = []
for trial in range(nt):
    a = rng.integers(0, p, size=N3.shape[1]); k2 = K3 @ a % p          # k2 in ker(level3)
    g = [ob(t * k2 % p, Z, Z, Z)[78:] for t in (1, 2, 3)]
    d1 = (g[0] - e6) % p; d2_ = (g[1] - e6) % p; d3_ = (g[2] - e6) % p
    # d(t) = t*l + t^2*q + t^3*c
    c = (d3_ - 3 * d2_ + 3 * d1) * i6 % p
    q = (d2_ - 2 * d1 - 6 * c) * i2 % p
    l = (d1 - q - c) % p
    lin_ok.append(not ((l - lev4 @ (N3 @ a % p)) % p).any())
    cub_zero.append(not c.any()); quad_in.append(mod3(q)); qrows.append(q)
    k3 = rk()
    cr = (ob(k2, k3, Z, Z)[78:] - g[0] - lev3 @ (np.linalg.lstsq(Kb.astype(float), k3.astype(float), rcond=None)[0] * 0).astype(np.int64)) % p
    # cross term: ob6(k2,k3) - ob6(k2,0) - ob6(0,k3) + ob6(0,0)
    cr = (ob(k2, k3, Z, Z)[78:] - g[0] - ob(Z, k3, Z, Z)[78:] + e6) % p
    cross_in.append((not cr.any(), mod3(cr))); crows.append(cr)
print("order 6, k2 random in ker(level3) (94-dim), %d trials:" % nt)
print("   linear part equals level4 k2:", all(lin_ok), " ; cubic part zero:", all(cub_zero))
print("   quadratic part zero:", [not q.any() for q in qrows].count(True), "of", nt, " ; quadratic part in im(level3):", quad_in.count(True), "of", nt)
print("   cross term k2 x k3 zero / in im(level3):", [c[0] for c in cross_in].count(True), [c[1] for c in cross_in].count(True), "of", nt)
Q = np.array(qrows); C = np.array(crows)
UQ = rref(np.vstack([I3, Q]), p)[0]
print("   dim of im(level3) + span(quadratic values) =", len(UQ), " ; + span(level4 on ker level3) =",
      rank(np.vstack([UQ, (lev4 @ N3 % p).T]), p), " ; + e6 =", rank(np.vstack([UQ, (lev4 @ N3 % p).T, e6]), p),
      " ; + cross terms =", rank(np.vstack([UQ, (lev4 @ N3 % p).T, e6, C]), p))
print("time %.1fs" % (time.time() - t1))
