"""consistency of the 'last order filtered' path with the full path, on a case with a NONZERO answer"""
import pcore, t7
p = 2147483629
xi, lam1, phis = t7.random_data(11, p)
kap = pcore.kappa_poly(p)
z = pcore.cube_roots_of_minus_one(p)
dl = pcore.comb([(pcore.plane(z[0], p), 1), (pcore.plane(z[1], p), -1)], p)
Ql = pcore.standard_forms()
G, a, th = t7.build_arc(p, xi, lam1, phis, 8, "iii")
G7 = {j: g for j, g in G.items() if j <= 7}
resA, firstA = pcore.expansion(G7, 7, p, [kap, dl], Ql, last_filtered=True)
resB, firstB = pcore.expansion(G7, 7, p, [kap, dl], Ql, last_filtered=False)
print("variant (iii), order 7 computed by the filtered path and by the full path agree (kappa, delta):",
      resA[0][7] == resB[0][7], resA[1][7] == resB[1][7], " nonzero entries:", sum(1 for t in resA[0][7] if t), sum(1 for t in resA[1][7] if t))
