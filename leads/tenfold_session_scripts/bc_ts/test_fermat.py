# [BC-TS] validation of own Psi_B at G = Fermat (gseed 0) against the closed form.
import sys, json, time, numpy as np
from bcpsi import *
p = int(sys.argv[1]); Dmax = int(sys.argv[2]) if len(sys.argv) > 2 else 15
PR = json.load(open('/home/claude/hodge/discovery/checks/ts_t6/primes.json'))['roots_of_z2_minus_z_plus_1']
z = PR[str(p)][0]
t0 = time.time()
G, P1, P2 = build(p, z, 0)
print("G == sum y^3:", G == {tuple(3 if j == i else 0 for j in range(6)): 1 for i in range(6)})
Y = PsiB(p, G, Dmax)
cl = {c: {d: np.array([fermat_closed_B(p, c, e) for e in Y.M[d]], np.int64) for d in range(0, Dmax + 1, 3)} for c in (z, p - 1)}
kap = {}
for name, (f, g), c in (("Q1", P1, z), ("Q2", P2, p - 1)):
    cg = Y.psi3_cg(f, g); i = np.flatnonzero(cl[c][3])[0]
    k = int(cl[c][3][i] * pow(int(cg[i]), p - 2, p) % p)
    kap[name] = k
    print(name, "kappa", k, "proportional on degree 3:", np.array_equal(cg * k % p, cl[c][3]))
kappa = kap["Q1"]
print("kappa(Q1) == kappa(Q2):", kap["Q1"] == kap["Q2"])
for name, (f, g), c in (("Q1", P1, z), ("Q2", P2, p - 1)):
    psi = Y.table(f, g, kappa)
    print(name, "equal closed form per degree:", {d: bool(np.array_equal(psi[d], cl[c][d])) for d in range(3, Dmax + 1, 3)},
          "IBP bad:", {d: Y.check_ibp(psi, d) for d in range(6, Dmax + 1, 3)})
print("time %.0fs" % (time.time() - t0))
