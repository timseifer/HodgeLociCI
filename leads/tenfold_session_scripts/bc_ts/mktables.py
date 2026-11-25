# [BC-TS] own Psi_B tables at the split point (gseed), degrees 0..Dmax, saved with own monomial order.
import sys, json, time, numpy as np
from bcpsi import *
p = int(sys.argv[1]); gseed = int(sys.argv[2]); Dmax = int(sys.argv[3])
PR = json.load(open('/home/claude/hodge/discovery/checks/ts_t6/primes.json'))['roots_of_z2_minus_z_plus_1']
z = PR[str(p)][0]
t0 = time.time()
KAPPA = (-729) % p      # found at the Fermat point (test_fermat.py), re-checked below
G0, A1, A2 = build(p, z, 0); Y0 = PsiB(p, G0, 3, log=lambda *a: None)
k0 = Y0.psi3_cg(*A1) * KAPPA % p
print("kappa = -3^6 reproduces Fermat closed form at degree 3 (Q1):", np.array_equal(k0, np.array([fermat_closed_B(p, z, e) for e in Y0.M[3]], np.int64)))
G, P1, P2 = build(p, z, gseed)
# compare with the TS-T6 geometry construction (geometry reuse is allowed)
sys.path.insert(0, '/home/claude/hodge/discovery/checks/ts_t6')
from split import build_G
Gt, Pt1, Pt2, _ = build_G(p, z, gseed)
print("G equals split.build_G:", {e: v for e, v in Gt.items() if v % p} == G, "; f, g1, h, g2 equal:",
      all({e: v % p for e, v in a.items() if v % p} == b for a, b in zip(Pt1[0] + Pt1[1] + Pt2[0] + Pt2[1], P1[0] + P1[1] + P2[0] + P2[1])))
print("G nterms", len(G))
Y = PsiB(p, G, Dmax)
out = {}
psis = []
for name, (f, g) in (("Q1", P1), ("Q2", P2)):
    psi = Y.table(f, g, KAPPA)
    psis.append(psi)
    print(name, "IBP bad (20 random):", {d: int(Y.check_ibp(psi, d)) for d in range(6, Dmax + 1, 3)},
          "; I_Q on deg3 bad:", Y.vanish_Ipower(psi, 3, f, 1), "; I_Q^2 deg6 bad:", Y.vanish_Ipower(psi, 6, f, 2),
          "; I_Q^3 deg 9 bad:", Y.vanish_Ipower(psi, 9, f, 3), "; I_Q^4 deg 12 bad:", Y.vanish_Ipower(psi, 12, f, 4),
          "; I_Q^2 deg 9 bad (expect >0):", Y.vanish_Ipower(psi, 9, f, 2))
    for d in range(0, Dmax + 1, 3): out["%s_%d" % (name, d)] = psi[d]
# intersection numbers on H^{2,2}: periods of the 20 squarefree cubics (basis of R_3?) and the pairing tau(PQ)
sq = [i for i, e in enumerate(Y.M[3]) if max(e) <= 1]
B = np.zeros((20, 20), np.int64)
for a, ia in enumerate(sq):
    for b, ib in enumerate(sq):
        e = tuple(x + y for x, y in zip(Y.M[3][ia], Y.M[3][ib])); B[a, b] = Y.tau[rk_scalar(e)]
from bcla import rref as _r
R, piv = _r(np.concatenate([B, np.eye(20, dtype=np.int64)], 1), p); assert len(piv) >= 20 and piv[19] == 19
Bi = R[:, 20:]
u = [ps[3][sq] for ps in psis]
q = [[int(u[i] @ Bi % p @ u[j] % p) for j in range(2)] for i in range(2)]
print("pairing ratios: q12/q11 =", q[0][1] * pow(q[0][0], p - 2, p) % p, " (-1/8 =", (-pow(8, p - 2, p)) % p, "); q22 == q11:", q[1][1] == q[0][0])
np.savez('psiB_bc_g%d_%d_D%d.npz' % (gseed, p, Dmax), **out)
print("saved; time %.0fs" % (time.time() - t0))
