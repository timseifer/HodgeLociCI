# C1: basic facts, all exact over QQ.
from common import *
import json

Z, O = Fr(0), Fr(1)
print("a0 =", A0, " h(x) =", hval(XX), " 27(1+lam^3) =", 27 * (1 + LAM ** 3))
print("number of monomials of F:", len(FMON))
a = A_PT
print("F(a) =", Fval(a, Z), "  grad F(a) =", grad(a, Z))
# consistency of T3 with direct evaluation at a few points
import random
random.seed(1)
for _ in range(5):
    y = [Fr(random.randint(-5, 5)) for _ in range(N)]
    assert tri(y, y, y, Z) == 6 * Fval(y, Z)
Ha = hess(a, Z)
print("H_a =")
for r in Ha:
    print("  ", [str(c) for c in r])
print("rank H_a =", rank(Ha, Z, O))
T = nullspace(Ha, Z, O)
print("dim T =", len(T))
print("a in T:", rank(T + [a], Z, O) == len(T))
# F restricted to T identically zero?  (all trilinear values on a basis)
okT = all(tri(T[i], T[j], T[k], Z) == 0 for i in range(3) for j in range(3) for k in range(3))
print("F|_T identically 0 (trilinear form vanishes on T):", okT)


# iota preserves F
def perm_poly(mon, perm):
    out = {}
    for idx, c in mon.items():
        key = tuple(sorted(perm[i] for i in idx))
        out[key] = out.get(key, Fr(0)) + c
    return out


print("iota preserves F:", perm_poly(FMON, IOTA) == FMON)
# odd / even eigenspaces
def apply_perm_point(perm, y):
    # point map: (phi y)_i = y_{perm[i]}
    return [y[perm[i]] for i in range(N)]


for o in ODD:
    assert apply_perm_point(IOTA, o) == [-c for c in o]
for e in EVEN:
    assert apply_perm_point(IOTA, e) == e
print("a in odd eigenspace:", rank(ODD + [a], Z, O) == 4)
print("F vanishes on odd eigenspace:", all(tri(ODD[i], ODD[j], ODD[k], Z) == 0 for i in range(4) for j in range(4) for k in range(4)))

# P_B = span(ODD, v), v = sum e_k EVEN[k].  F(o + s v) = F(o) + s*(1/2)tri(o,o,v) + s^2*(1/2) tri(o,v,v) + s^3 F(v)
# conditions: tri(o_m,o_n,v)=0 (10 linear conditions), tri(o_m,v,v)=0 (4 quadratic), F(v)=0.
rows = []
for m in range(4):
    for n in range(m, 4):
        rows.append([tri(ODD[m], ODD[n], EVEN[k], Z) for k in range(5)])
print("rank of the 10x5 linear system for v:", rank(rows, Z, O))
sol = nullspace(rows, Z, O)
print("solution space dimension:", len(sol))
for s in sol:
    print("  e =", [str(c) for c in s])
assert len(sol) == 1
e = sol[0]
v = [sum(e[k] * EVEN[k][i] for k in range(5)) for i in range(N)]
# scale to integers
from math import lcm
den = 1
for c in v:
    den = lcm(den, c.denominator)
v = [c * den for c in v]
print("v (even point) =", [str(c) for c in v], " F(v) =", Fval(v, Z))
print("tri(o_m, v, v) all zero:", all(tri(ODD[m], v, v, Z) == 0 for m in range(4)))
PB = ODD + [v]
okPB = all(tri(PB[i], PB[j], PB[k], Z) == 0 for i in range(5) for j in range(i, 5) for k in range(j, 5))
print("dim P_B (affine) =", rank(PB, Z, O), "  P_B in Y:", okPB)
print("a in P_B:", rank(PB + [a], Z, O) == 5)
dPT = 5 + 3 - rank(PB + T, Z, O)
print("dim (P_B cap T) (affine) =", dPT, " -> P_B contains a line of P(T) through a:", dPT >= 2, "; contains all of P(T):", dPT == 3)

# g: substitution on coordinate functions z_k->z_{k+2}, p_i->p_{i+1}, q_j->q_{j+1}
SUB = {}
for k in range(3):
    SUB[k] = (k + 2) % 3
    SUB[3 + k] = 3 + (k + 1) % 3
    SUB[6 + k] = 6 + (k + 1) % 3
print("substitution preserves F:", perm_poly(FMON, SUB) == FMON)
SUBINV = {v_: k_ for k_, v_ in SUB.items()}
# two point maps: phi(y)_i = y_{SUB[i]}  (pull-back of coordinates) and its inverse
def img(perm, vecs):
    return [apply_perm_point(perm, w) for w in vecs]


cands = {"phi: (gy)_i = y_SUB(i)": img(SUB, PB), "phi^-1: (gy)_SUB(i) = y_i": img(SUBINV, PB)}
res = {}
for name, P in cands.items():
    inY = all(tri(P[i], P[j], P[k], Z) == 0 for i in range(5) for j in range(i, 5) for k in range(j, 5))
    a_in = rank(P + [a], Z, O) == 5
    dint = 10 - rank(PB + P, Z, O)
    pi_in = rank(P + PI_COLS, Z, O) == 5
    print(name, ": in Y", inY, "; contains a:", a_in, "; dim(P_B cap P') affine =", dint, "; contains pi:", pi_in)
    res[name] = (P, pi_in)
print("rank of pi columns:", rank(PI_COLS, Z, O), "; a in pi:", rank(PI_COLS + [a], Z, O) == 3)
print("pi in Y:", all(tri(PI_COLS[i], PI_COLS[j], PI_COLS[k], Z) == 0 for i in range(3) for j in range(i, 3) for k in range(j, 3)))
print("rank of L columns:", rank(L_COLS, Z, O))
# save data for later scripts
Pp = [P for (P, ok) in res.values() if ok]
assert len(Pp) == 1
Pp = Pp[0]
# canonical choice of v1,v2: complete a to a basis of T using rref-nullspace vectors
basisT = [a]
for t in T:
    if rank(basisT + [t], Z, O) > len(basisT) and len(basisT) < 3:
        basisT.append(t)
v1, v2 = basisT[1], basisT[2]
print("v1 =", [str(c) for c in v1])
print("v2 =", [str(c) for c in v2])
json.dump({"PB": [[str(c) for c in w] for w in PB], "Pprime": [[str(c) for c in w] for w in Pp],
           "v1": [str(c) for c in v1], "v2": [str(c) for c in v2], "veven": [str(c) for c in v]},
          open("/home/claude/blind_check11/c1_data.json", "w"))
# which line of P(T) does P_B contain?  P_B cap T
M = [[PB[j][i] for j in range(5)] + [-T[j][i] for j in range(3)] for i in range(N)]
ns = nullspace(M, Z, O)
print("P_B cap T spanned by:")
for n_ in ns:
    w = [sum(n_[j] * PB[j][i] for j in range(5)) for i in range(N)]
    print("   ", [str(c) for c in w])
