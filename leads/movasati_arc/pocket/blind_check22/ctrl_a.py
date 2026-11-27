import sys, numpy as np
sys.path.insert(0, "/home/claude/hodgelocici/leads/movasati_arc/blind_check14/own")
from own import Ctx, L1, L2, M
p, z = 31981, 12637
C = Ctx(p, z)
T = [C.parse(l.strip()) for l in open("/home/claude/work/o10c/jet9_31981.txt") if l.strip()]
tab = (C.ptable(C.Pspace(L1)) + 2*C.ptable(C.Pspace(L2))) % p
cand = [(m, c) for m, c in zip(T[4].monoms(), T[4].coeffs()) if np.count_nonzero(C.periods(C.ctx.from_dict({m: 1}), tab))]
print("T_5 monomials:", len(T[4]), "with nonzero period image:", len(cand))
m0, c0 = cand[0]
T5 = T[4] + C.ctx.from_dict({m0: 1})
print("perturb T_5 coeff of", m0, "from", int(c0), "to", (int(c0)+1) % p)
Ts = T[:4] + [T5]
E = [C.ctx.from_dict({(0,)*M: 1})]
for n in range(1, 7):
    acc = C.ctx.from_dict({})
    for j in range(1, min(n, len(Ts)) + 1): acc = acc + Ts[j-1] * E[n-j] * j
    E.append(acc * pow(n, p-2, p))
    print("pert n=%d nonzero c_n[Q] (lam=2): %d" % (n, np.count_nonzero(C.periods(E[n], tab))))
