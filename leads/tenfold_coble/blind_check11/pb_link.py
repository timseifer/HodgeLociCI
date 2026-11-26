# P_B versus the generic family: P_B has direction tau_B = (5:11) (t = 11/5); the tau-test is NOT applicable on P_B
# (Jacobian rank 3).  Show that t = 11/5 is a branch value of the double cover and that P_B is the limit plane.
import json
from common import *
from fields import *
from ztest import *
import gen_link as GL          # (re-runs the degree-12 link; harmless)
from flint import fmpq_poly, fmpq
Z, O = Fr(0), Fr(1)
out = open("/home/claude/blind_check11/pb_link.out", "w")
def P(*a):
    s = " ".join(str(x) for x in a)
    print(s); out.write(s + "\n"); out.flush()
d = json.load(open("/home/claude/blind_check11/c1_data.json"))
PB = [[Fr(c) for c in w] for w in d["PB"]]
M_COLS = GL.M_COLS
# direction of P_B
T = [A_PT, V1, V2]
Mat = [[PB[j][i] for j in range(5)] + [-T[j][i] for j in range(3)] for i in range(N)]
ns = nullspace(Mat, Z, O)
dirs = [(n_[6], n_[7]) for n_ in ns]
P("P_B cap T in the basis (a,v1,v2): (v1,v2)-components", [(str(a_), str(b_)) for a_, b_ in dirs])
tB = [b_ / a_ for a_, b_ in dirs if a_ != 0][0]
P("t_B =", tB)
# y_B = P_B cap M
Mat = [[PB[j][i] for j in range(5)] + [-M_COLS[j][i] for j in range(5)] for i in range(N)]
ns = nullspace(Mat, Z, O)
P("dim(P_B cap M) =", len(ns))
s = ns[0][5:]
s = [c / s[3] for c in s]
yB = [sum(s[j] * M_COLS[j][i] for j in range(5)) for i in range(N)]
P("y_B in chart s3=1: (s0,s1,s2,s4) =", [str(s[0]), str(s[1]), str(s[2]), str(s[4])])
r = za_test(yB, Z, O, lambda a_: a_ == 0)
P("tau-test at y_B: status =", r["status"], "; rank J =", r["rankJ"], "; tau(y_B) = t_B:", r["tau"][1] / r["tau"][0] == tB)
# generic component at t = t_B
class QQf:      # trivial 'field' wrapper so that GL.ev works with Fractions
    zero = Fr(0); one = Fr(1)
vals = [GL.ev(line, QQf, tB, s[0], s[1], s[2], s[4]) for line in GL.comp]
P("generators of the generic degree-2 component vanish at (t_B, y_B):", [v == 0 for v in vals])
f0 = lambda v: GL.ev(GL.comp[0], QQf, tB, Z, Z, v, Z)
c0 = f0(Z); c2 = (f0(O) + f0(-O)) / 2 - c0; c1 = (f0(O) - f0(-O)) / 2
P("at t_B the quadratic in s2 is c2*s2^2+c1*s2+c0 with c2 != 0:", c2 != 0, "; discriminant c1^2-4c0c2 =", c1 * c1 - 4 * c0 * c2,
  " (0 => t_B is a branch value: the two planes coincide)")
lead = []
for line in GL.comp[1:]:
    var = [v for v in ("s0", "s1", "s4") if v in line][0]
    args = dict(s0=Z, s1=Z, s2=Z, s4=Z)
    e = GL.ev(line, QQf, tB, **args); args[var] = O
    lead.append(GL.ev(line, QQf, tB, **args) - e)
P("other leading coefficients nonzero at t_B:", [c != 0 for c in lead])
# Uniqueness of the plane through y_B inside the Zariski tangent space K6 = ker J(y_B) of S_{tau_B}:
H = hess(yB, Z)
vt = r["vtau"]
f = forms(yB, Z)
J = [f["grad"], f["Hay"], matvec(H, vt, Z), hess_vec(vt, vt, Z)]
K6 = nullspace(J, Z, O)
P("dim ker J(y_B) =", len(K6), "; P_B inside it:", rank(K6 + PB, Z, O) == len(K6))
ctx, gens, zero, one = mp_ring(["k%d" % i for i in range(len(K6))])
yy = [zero] * N
for j in range(len(K6)):
    for i in range(N):
        yy[i] = yy[i] + gens[j] * K6[j][i]
FK = Fval(yy, zero).p
fac = FK.factor()[1]
P("F restricted to P(ker J(y_B)) factors with degrees:", [(g.total_degree(), e) for g, e in fac])
# coordinates of y_B in K6
Mat = [[K6[j][i] for j in range(len(K6))] + [yB[i]] for i in range(N)]
nsy = nullspace(Mat, Z, O)[0]
cy = [-c / nsy[-1] for c in nsy[:-1]]
for g, e in fac:
    val = g.subs({"k%d" % i: fmpq(cy[i].numerator, cy[i].denominator) for i in range(len(K6))})
    P("   factor of degree", g.total_degree(), "at y_B:", val)
