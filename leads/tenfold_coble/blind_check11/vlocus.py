# The locus V = {F = Q_a = l1 = l2 = B11 = B12 = B22 = 0}: points lying on S_tau for EVERY tau.
# N := {B11=B12=B22=0} (a P^5 containing P(T)); the quadrics Q_a, l1, l2 restricted to N descend to N/T = P^2.
from common import *
from fields import *
from ztest import *
Z, O = Fr(0), Fr(1)
a = A_PT
T = [a, V1, V2]
B = [hess_vec(V1, V1, Z), hess_vec(V1, V2, Z), hess_vec(V2, V2, Z)]   # the three linear forms B_ij as vectors
print("rank of (B11,B12,B22):", rank(B, Z, O))
Nb = nullspace(B, Z, O)
print("dim N =", len(Nb), "; T in N:", rank(Nb + T, Z, O) == len(Nb))
# complement of T in N
comp = []
for w in Nb:
    if rank(T + comp + [w], Z, O) > 3 + len(comp):
        comp.append(w)
print("dim N/T =", len(comp))
ctx, gens, zero, one = mp_ring(["c0", "c1", "c2", "d0", "d1", "d2"])
y = [zero] * N
for j in range(3):
    for i in range(N):
        y[i] = y[i] + gens[j] * comp[j][i] + gens[3 + j] * T[j][i]
f = forms(y, zero)
for k in ["Qa", "l1", "l2", "F", "B11", "B12", "B22"]:
    p = f[k].p
    print(k, "on N: uses variables", sorted(set(i for mon in p.to_dict() for i, e in enumerate(mon) if e)), " factorisation:",
          [(str(g), e) for g, e in p.factor()[1]] if not p.is_zero() else "ZERO")
