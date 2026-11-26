# C5: a cubic tenfold X = F + sum_k w_k Phi_k containing Lambda = {lambda_1=...=lambda_6=0}; smoothness mod p.
from common import *
from math import lcm, gcd
import random, sys
Z, O = Fr(0), Fr(1)
# linear forms vanishing on pi: nullspace of the 3x9 matrix whose rows are the columns of pi
lams = nullspace(PI_COLS, Z, O)
assert len(lams) == 6
def intify(v):
    d = 1
    for c in v:
        d = lcm(d, c.denominator)
    w = [int(c * d) for c in v]
    g = 0
    for c in w:
        g = gcd(g, c)
    return [c // g for c in w]
lams = [intify(v) for v in lams]
for v in lams:
    assert all(sum(v[i] * col[i] for i in range(N)) == 0 for col in PI_COLS)
names = NAMES + ["w0", "w1", "w2"]
def lin(v, nm):
    return "(" + "+".join("(%d)*%s" % (c, n) for c, n in zip(v, nm) if c != 0) + ")"
lam_str = [lin(v, NAMES) for v in lams]
seed = int(sys.argv[1]) if len(sys.argv) > 1 else 1
random.seed(seed)
# Phi_k = sum_i lambda_i * mu_ki, mu_ki linear forms in the 12 variables with coefficients in {-1,0,1} (3 nonzero each)
phis = []
mus = []
for k in range(3):
    terms = []
    for i in range(6):
        mu = [0] * 12
        for j in random.sample(range(12), 3):
            mu[j] = random.choice([-1, 1])
        if i == k:          # make sure w_k^2*lambda_{k+1} is present (non-singularity along y=0)
            mu[9 + k] = 1
        mus.append((k, i, mu))
        terms.append("lam%d*%s" % (i, lin(mu, names)))
    phis.append(" + ".join(terms))
F = open("F_string.txt").read()
p = 32003
body = ""
for i in range(6):
    body += "poly lam%d=%s;\n" % (i, lam_str[i])
for k in range(3):
    body += "poly Phi%d=%s;\n" % (k, phis[k])
body += "poly F=%s;\npoly X=F+w0*Phi0+w1*Phi1+w2*Phi2;\n" % F
sing0 = "ring r0=0,(%s),dp;\n" % ",".join(names) + body + """ideal Lam=lam0,lam1,lam2,lam3,lam4,lam5;
print("X in ideal of Lambda (remainder):"); reduce(X,std(Lam));
print("F in ideal of pi-forms (remainder):"); reduce(F,std(Lam));
print("X restricted to w=0 equals F:"); subst(subst(subst(X,w0,0),w1,0),w2,0)-F;
print("content/denominators: coefficients of X are integers:"); cleardenom(X)==X;
write(":w c5_X.txt", string(X));
quit;
"""
open("c5_lambda.sing", "w").write(sing0)
singp = "ring r=%d,(%s),dp;\n" % (p, ",".join(names)) + body + """ideal J=jacob(X);
option(redSB);
int tt=timer;
ideal S=std(J);
print("mod %d: dim of the affine cone of Sing(X) (0 = smooth):"); dim(S);
print("vdim:"); vdim(S);
quit;
""" % p
open("c5_smooth.sing", "w").write(singp)
m2 = "R = ZZ/%d[%s];\n" % (p, ",".join(names))
m2 += body.replace("poly ", "").replace(";\n", ";\n")
m2 += """J = ideal jacobian ideal X;
G = groebnerBasis(J, Strategy=>"F4");
I = ideal leadTerm G;
print("M2 (F4) mod %d: dim of cone of Sing(X):"); print(dim I);
quit;
""" % p
open("c5_smooth.m2", "w").write(m2)
import json
json.dump({"lams": lams, "mus": mus, "seed": seed}, open("c5_choice.json", "w"))
print("lambda forms:")
for s in lam_str: print("  ", s)
for k in range(3): print("Phi%d = %s" % (k, phis[k]))
