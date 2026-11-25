import sys, time, numpy as np, itertools
from common import *
p = 67108837; W, Ts, zp = setup(p)
print("patterns with t = 0:", sum(1 for v in W.tabv.values() if v == 0), "of 64")
Tp = [W.vec_to_poly(T) for T in Ts]; Es = [W.poly_one()]
for m in range(1, 8):
    t = time.time(); E, acc, nt = W.Eprime(m, Tp, Es); dt = time.time() - t
    vis = visible_mask(W, E[0]); Es.append(E)
    e = unpack(E[0]); rho = e % 3
    n2 = (rho == 2).any(1).mean()
    print("E'_%d terms %d time %.1fs visible %d (%.4f); frac with some exponent = 2 mod 3: %.3f" % (m, nt, dt, vis.sum(), vis.mean(), n2), flush=True)
# check: H on visible-only part equals H on full (E'_7)
t = time.time(); a1 = W.H_acc(Es[7]); t1 = time.time() - t
v = visible_mask(W, Es[7][0]); t = time.time(); a2 = W.H_acc((Es[7][0][v], Es[7][1][v])); t2 = time.time() - t
M1 = W.MH_from_acc(a1); M2 = W.MH_from_acc(a2)
print("MH(E'_7) full == visible-only:", np.array_equal(M1, M2), "H times %.1f / %.1f" % (t1, t2))
# time breakdown of E'_8: product generation vs H
import cProfile, pstats
terms = [(j * pow(8, p - 2, p) % p, Tp[j - 1], Es[8 - j]) for j in range(1, 9) if j - 1 < len(Tp)]
t = time.time(); tp = 0; th = 0; acc = np.zeros(len(W.keep_codes), np.int64); nt = 0
gen = W.product_buckets(terms)
while True:
    t0 = time.time()
    try: B, P = next(gen)
    except StopIteration: break
    t1 = time.time(); acc = W.H_acc(P, acc); t2 = time.time(); tp += t1 - t0; th += t2 - t1; nt += len(P[0])
print("E'_8: %d terms, product+dedup %.1fs, H %.1fs" % (nt, tp, th))
