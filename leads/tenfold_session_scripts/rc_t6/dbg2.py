import sys, numpy as np
sys.path.insert(0, '/home/claude/hodge/discovery/t6_unsolved/e'); sys.path.insert(0, '/home/claude/hodge/discovery/checks/bc_t6')
import fe, hl
p = 32029; z = 31556; lam = -1
E = fe.Engine(p, lam, z=z)
Ts = np.load('/home/claude/hodge/discovery/t6_unsolved/e/arc2_32029_-1_1_al_8.npy') % p
cs, Es, MHs = E.series(list(Ts), 4)
for n in range(1, 4):
    full = (cs[n-1] + E.L @ Ts[n-1]) % p
    print("fe order", n, "nonzero full coeffs", np.count_nonzero(full))
# fe full E_2 and functional; BC functional on same E (as poly)
E2 = Es[2]
print("len E2", len(E2[0]))
F = hl.Field(p); F.z = z; F.zb = pow(z, 5, p)
T1 = hl.pair_tables(F, [z]*6); T2 = hl.pair_tables(F, [z, z, z, p-1, p-1, p-1])
P = hl.Poly(p, E2[0], E2[1])
f = hl.functional(P, [T1, T2], hl.cubic_monos(), p)
r = (f[:, 0] + lam * f[:, 1]) % p
print("BC on fe's E_2: nonzero", np.count_nonzero(r))
fv = E.cvec(E2); print("fe cvec(E_2) nonzero", np.count_nonzero(fv))
# monomial-level check over all monomials appearing: compare H values
