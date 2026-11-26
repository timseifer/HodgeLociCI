# local multiplicity of the 0-dimensional scheme M cap S_{t_B} (t_B = 11/5) at y_B = P_B cap M  (Singular, local ordering)
from common import *
from fields import *
from ztest import *
import json
M_COLS = [[Fr(c) for c in v] for v in json.load(open("gen_M.json"))["M_COLS"]]
ctx, gens, zero, one = mp_ring(["x0", "x1", "x2", "x4"])
# chart s3 = 1, shifted so that y_B is the origin: s = sB + x
sB = {0: Fr(-163, 17), 1: Fr(-208, 17), 2: Fr(149, 17), 4: Fr(395, 17)}
svars = [gens[0] + sB[0], gens[1] + sB[1], gens[2] + sB[2], one, gens[3] + sB[4]]
y = [zero] * N
for j in range(5):
    for i in range(N):
        y[i] = y[i] + svars[j] * M_COLS[j][i]
f = forms(y, zero)
tB = Fr(11, 5)
lt = f["l1"] + f["l2"] * tB
bt = f["B11"] + f["B12"] * (2 * tB) + f["B22"] * (tB * tB)
def clear(p):
    from math import lcm
    dn = 1
    for c in p.coeffs():
        dn = lcm(dn, int(c.q))
    return str(p * dn)
print("constant terms at y_B (all must vanish):", [str(p.p.to_dict().get((0, 0, 0, 0), 0)) for p in (f["F"], f["Qa"], lt, bt)])
sing = "ring r=0,(x0,x1,x2,x4),ds;\n"
sing += "ideal I=%s,%s,%s,%s;\n" % (clear(f["F"].p), clear(f["Qa"].p), clear(lt.p), clear(bt.p))
sing += """ideal S=std(I);
print("local dimension at y_B and local multiplicity (vdim in the local ring):"); dim(S); vdim(S);
ring rg=0,(x0,x1,x2,x4),dp;
ideal I=imap(r,I);
ideal S=std(I);
print("global (chart s3=1): dim, vdim:"); dim(S); vdim(S);
quit;
"""
open("pb_mult.sing", "w").write(sing)
