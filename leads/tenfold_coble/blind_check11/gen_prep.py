# Generic member of the family: S_t = {F = Q_a = l1 + t*l2 = B11 + 2t*B12 + t^2*B22 = 0}, cut with a rational P^4 M.
# Step 1: restrict the forms to M and write Singular input (ground field QQ(t)).
from common import *
from fields import *
from ztest import *
import json
E = vadd(unit(8), unit(3))
M_COLS = L_COLS + [E]
assert rank(M_COLS, Fr(0), Fr(1)) == 5
ctx, gens, zero, one = mp_ring(["s0", "s1", "s2", "s3", "s4"])
y = [zero] * N
for j in range(5):
    for i in range(N):
        y[i] = y[i] + gens[j] * M_COLS[j][i]
f = forms(y, zero)
def clear(p):
    from math import lcm
    d = 1
    for c in p.coeffs():
        d = lcm(d, int(c.q))
    return str(p * d)
keys = ["F", "Qa", "l1", "l2", "B11", "B12", "B22"]
polys = {k: clear(f[k].p) for k in keys}
json.dump({"M_COLS": [[str(c) for c in v] for v in M_COLS]}, open("gen_M.json", "w"))
sing = "ring r=(0,t),(s0,s1,s2,s3,s4),dp;\noption(redSB);\n"
for k in keys:
    sing += "poly %s=%s;\n" % (k, polys[k])
sing += """poly lt=l1+t*l2;
poly bt=B11+2*t*B12+t^2*B22;
ideal I=F,Qa,lt,bt;
ideal S=std(I);
print("M cap S_t over QQ(t): dim of cone, mult:"); dim(S); mult(S);
ring ra=(0,t),(s0,s1,s2,s4),dp;
option(redSB);
map phi=r,s0,s1,s2,1,s4;
ideal Ia=phi(I);
ideal Sa=std(Ia);
print("affine chart s3=1: dim, vdim:"); dim(Sa); vdim(Sa);
ring rl=(0,t),(s0,s1,s4,s2),lp;
option(redSB);
ideal Sl=fglm(ra,Sa);
print("size of lex GB:"); size(Sl);
int i;
for(i=1;i<=size(Sl);i++){ print("LEADMON"); print(leadmonom(Sl[i])); }
list fa=factorize(Sl[1]);
print("factor degrees of the univariate generator (in s2):");
for(i=1;i<=size(fa[1]);i++){ print(deg(fa[1][i])); print(fa[2][i]); }
// the low-degree factor(s): compute the components
for(i=2;i<=size(fa[1]);i++){
  if (deg(fa[1][i]) <= 4) {
    ideal C = Sl, fa[1][i];
    C = std(C);
    write(":w gen_comp.txt", "COMPONENT");
    int j;
    for(j=1;j<=size(C);j++){ write(":a gen_comp.txt", string(C[j])); }
  }
}
quit;
"""
open("gen.sing", "w").write(sing)
print("written")
