# C4 step 1: restrict F, Q_a, G (and l1,l2) to L, write Singular and M2 input.
from common import *
from fields import *
from ztest import *
ctx, gens, zero, one = mp_ring(["s0", "s1", "s2", "s3"])
y = [zero] * N
for j in range(4):
    for i in range(N):
        y[i] = y[i] + gens[j] * L_COLS[j][i]
f = forms(y, zero)
def clear(p):
    # multiply by lcm of denominators -> integer coefficients string
    from math import lcm
    d = 1
    for c in p.coeffs():
        d = lcm(d, int(c.q))
    return str(p * d).replace("^", "^")
polys = {k: clear(f[k].p) for k in ["F", "Qa", "G", "l1", "l2"]}
for k, v in polys.items():
    print(k, "degree", f[k].p.total_degree(), "terms", len(f[k].p.to_dict()))
import json
json.dump(polys, open("c4_polys.json", "w"))
sing = """ring r=0,(s0,s1,s2,s3),dp;
option(redSB);
poly F=%s;
poly Q=%s;
poly G=%s;
poly l1=%s;
poly l2=%s;
ideal I=F,Q,G;
ideal S=std(I);
print("projective: dim(affine cone), mult:"); dim(S); mult(S);
ideal Il = F,Q,G,l1,l2;
ideal Sl = std(Il);
print("dim of cone of L cap W cap {l1=l2=0} (0 means empty):"); dim(Sl);
// affine chart s3=1
ring ra=0,(s0,s1,s2),dp;
option(redSB);
map phi=r,s0,s1,s2,1;
ideal Ia=phi(I);
ideal Sa=std(Ia);
print("affine chart s3=1: dim, vdim:"); dim(Sa); vdim(Sa);
ring rl=0,(s0,s1,s2),lp;
option(redSB);
ideal Sl=fglm(ra,Sa);
print("size of lex GB:"); size(Sl);
int i;
for(i=1;i<=size(Sl);i++){ print("LEAD"); print(lead(Sl[i])); }
write(":w c4_lex.txt", string(Sl[1]));
for(i=2;i<=size(Sl);i++){ write(":a c4_lex.txt", string(Sl[i])); }
list fa=factorize(Sl[1]);
print("factor degrees of the univariate generator:");
for(i=1;i<=size(fa[1]);i++){ print(deg(fa[1][i])); print(fa[2][i]); }
quit;
""" % (polys["F"], polys["Qa"], polys["G"], polys["l1"], polys["l2"])
open("c4.sing", "w").write(sing)
m2 = """R = QQ[s0,s1,s2,s3];
F = %s;
Q = %s;
G = %s;
I = ideal(F,Q,G);
print("M2: dim (projective), degree of L cap W:");
print(dim I - 1);
print(degree I);
quit;
""" % (polys["F"], polys["Qa"], polys["G"])
open("c4_dim.m2", "w").write(m2)
