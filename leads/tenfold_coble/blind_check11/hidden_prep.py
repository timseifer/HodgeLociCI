# "Hidden" planes: planes of the family on which l1 = l2 = 0 identically (not seen by the tau-test).
# They lie in D = Y cap {Q_a = l1 = l2 = 0}.  Step 1: structure of N cap Y, and Singular input for D cap M.
from common import *
from fields import *
from ztest import *
import json
Z, O = Fr(0), Fr(1)
a = A_PT
T = [a, V1, V2]
B = [hess_vec(V1, V1, Z), hess_vec(V1, V2, Z), hess_vec(V2, V2, Z)]
Nb = nullspace(B, Z, O)
comp = []
for w in Nb:
    if rank(T + comp + [w], Z, O) > 3 + len(comp):
        comp.append(w)
ctx, gens, zero, one = mp_ring(["c0", "c1", "c2", "d0", "d1", "d2"])
y = [zero] * N
for j in range(3):
    for i in range(N):
        y[i] = y[i] + gens[j] * comp[j][i] + gens[3 + j] * T[j][i]
f = forms(y, zero)
kap = f["l1"].p
dd = kap.to_dict()
# Gram matrix of the conic kappa in c0,c1,c2
from flint import fmpq_mat, fmpq
Gm = [[fmpq(0)] * 3 for _ in range(3)]
for mon, c in dd.items():
    idx = [i for i in range(3) for _ in range(mon[i])]
    assert len(idx) == 2 and all(mon[i] == 0 for i in range(3, 6))
    i, j = idx
    if i == j:
        Gm[i][i] += c
    else:
        Gm[i][j] += c / 2; Gm[j][i] += c / 2
det = fmpq_mat(Gm).det()
print("conic kappa on N/T: determinant of Gram matrix =", det, " (nonzero => smooth conic => V_4 = cone over a smooth conic,")
print("   an irreducible rank-3 quadric of dimension 4, containing no 4-plane)")
print("l1|_N proportional to l2|_N:", (f["l1"].p * f["l2"].p.leading_coefficient() - f["l2"].p * f["l1"].p.leading_coefficient()).is_zero())
print("ratio l1:l2 on N =", f["l1"].p.leading_coefficient(), ":", f["l2"].p.leading_coefficient())
# the rational plane Pi_N = N cap {linear factor of F|_N = 0}
lin = [g for g, e in f["F"].p.factor()[1] if g.total_degree() == 1][0]
ld = lin.to_dict()
coef = [ld.get(tuple(1 if k == i else 0 for k in range(6)), 0) for i in range(6)]
print("linear factor of F|_N in (c0,c1,c2,d0,d1,d2):", coef)
basisN = comp + T
rows = [[(Fr(int(c.p), int(c.q)) if hasattr(c, "p") else Fr(c)) for c in coef]]
ker = nullspace(rows, Z, O)
PiN = [[sum(k[j] * basisN[j][i] for j in range(6)) for i in range(N)] for k in ker]
print("dim Pi_N =", rank(PiN, Z, O), "; Pi_N in Y:", all(tri(PiN[i], PiN[j], PiN[k], Z) == 0 for i in range(5) for j in range(i, 5) for k in range(j, 5)))
d = json.load(open("c1_data.json"))
PB = [[Fr(c) for c in w] for w in d["PB"]]
print("Pi_N == P_B:", rank(PiN + PB, Z, O) == 5)
print("a in Pi_N:", rank(PiN + [a], Z, O) == 5, "; dim(Pi_N cap T) =", 5 + 3 - rank(PiN + T, Z, O))
# D cap M
M_COLS = [[Fr(c) for c in v] for v in json.load(open("gen_M.json"))["M_COLS"]]
ctx, gens, zero, one = mp_ring(["s0", "s1", "s2", "s3", "s4"])
y = [zero] * N
for j in range(5):
    for i in range(N):
        y[i] = y[i] + gens[j] * M_COLS[j][i]
f = forms(y, zero)
def clear(p):
    from math import lcm
    dn = 1
    for c in p.coeffs():
        dn = lcm(dn, int(c.q))
    return str(p * dn)
sing = "ring r=0,(s0,s1,s2,s3,s4),dp;\noption(redSB);\n"
for k in ["F", "Qa", "l1", "l2"]:
    sing += "poly %s=%s;\n" % (k, clear(f[k].p))
sing += """ideal I=F,Qa,l1,l2;
ideal S=std(I);
print("D cap M: dim of cone, mult:"); dim(S); mult(S);
ring ra=0,(s0,s1,s2,s4),dp;
option(redSB);
map phi=r,s0,s1,s2,1,s4;
ideal Sa=std(phi(I));
print("affine chart s3=1: dim, vdim:"); dim(Sa); vdim(Sa);
ring rl=0,(s0,s1,s4,s2),lp;
option(redSB);
ideal Sl=fglm(ra,Sa);
print("size of lex GB:"); size(Sl);
int i;
for(i=1;i<=size(Sl);i++){ print("LEADMON"); print(leadmonom(Sl[i])); }
write(":w hidden_lex.txt", string(Sl[1]));
for(i=2;i<=size(Sl);i++){ write(":a hidden_lex.txt", string(Sl[i])); }
list fa=factorize(Sl[1]);
print("factor degrees of the univariate generator (degree, multiplicity):");
for(i=1;i<=size(fa[1]);i++){ print(deg(fa[1][i])); print(fa[2][i]); }
quit;
"""
open("hidden.sing", "w").write(sing)
