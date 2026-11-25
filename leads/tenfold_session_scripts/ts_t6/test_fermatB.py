import sys, time, numpy as np
from psib import *
p = int(sys.argv[1]); z = int(sys.argv[2]); Dmax = int(sys.argv[3])
t0 = time.time()
T = Tables(Dmax)
zb = (1 - z) % p
G = {}; planes = []
f1 = []; g1 = []; f2 = []; g2 = []
for k in range(3):
    a, b = 2 * k, 2 * k + 1
    ya = [0]*6; ya[a] = 1; yb = [0]*6; yb[b] = 1
    G = padd(G, {tuple(3 if j == a else 0 for j in range(6)): 1, tuple(3 if j == b else 0 for j in range(6)): 1}, p)
    fk = lin([1 if j == a else ((-z) % p if j == b else 0) for j in range(6)])
    hk = lin([1 if j in (a, b) else 0 for j in range(6)])
    lk = lin([1 if j == a else ((-zb) % p if j == b else 0) for j in range(6)])
    f1.append(fk); g1.append(pmul(hk, lk, p)); f2.append(hk); g2.append(pmul(fk, lk, p))
Y = Fourfold(p, G, [(f1, g1), (f2, g2)], T)
print(Y.check_smooth_and_slice())
Y.socle()
res = {}
for name, (f, g), c in (("Q1", (f1, g1), z), ("Q2", (f2, g2), (-1) % p)):
    cg = Y.psi3_cg(f, g); cl = fermat_closed(p, z, c, T, 3)
    nz = np.nonzero(cl)[0]
    ratios = set(int(cl[i] * pow(int(cg[i]), p - 2, p) % p) for i in nz if cg[i])
    print(name, "deg3: closed nnz", len(nz), "cg nnz", int(np.count_nonzero(cg)), "supports equal", set(nz) == set(np.nonzero(cg)[0]), "ratios", ratios)
    res[name] = (f, g, c, cg, ratios)
kap = list(res["Q1"][4])[0]
print("kappa", kap, "same for Q2:", res["Q2"][4] == {kap})
for name in ("Q1", "Q2"):
    f, g, c, cg, _ = res[name]
    psi = {0: np.zeros(1, np.int64), 3: cg * kap % p}
    x, rep = Y.psi6(psi[3], f); print(name, "deg6", rep, "equals closed:", np.array_equal(x, fermat_closed(p, z, c, T, 6)))
    psi[6] = x
    if name == "Q1": Y.cofactors7(); print("cofactors (%.0fs)" % (time.time() - t0))
    for d in range(9, Dmax + 1, 3):
        psi[d] = Y.extend(psi, d)
        print(name, "deg", d, "equals closed:", np.array_equal(psi[d], fermat_closed(p, z, c, T, d)), "(%.0fs)" % (time.time() - t0), flush=True)
    print(name, "I^3 test at deg 9 (bad of 20):", Y.check_Ipower(psi[9], 9, f, 3), " I^2 at deg 9:", Y.check_Ipower(psi[9], 9, f, 2), " I^4 at 12:", Y.check_Ipower(psi[12], 12, f, 4) if Dmax >= 12 else '')
