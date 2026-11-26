# Sanity checks of my own test code.
from common import *
from fields import *
from ztest import *
import json, random
Z, O = Fr(0), Fr(1)
random.seed(7)
# (1) gradG against the derivative of G along a random line (exact, via polynomial in one variable)
ctx, (s,), zero, one = mp_ring(["s"])
y0 = [Fr(random.randint(-4, 4)) for _ in range(N)]
d0 = [Fr(random.randint(-4, 4)) for _ in range(N)]
yl = [zero + y0[i] + s * d0[i] for i in range(N)]
Gs = forms(yl, zero)["G"].p
coef1 = Gs.to_dict().get((1,), 0)
gg = gradG(y0, Z)
print("gradG.d equals d/ds G(y+s d)|_0:", dot(gg, d0, Z) == Fr(int(coef1.p), int(coef1.q)), "; Euler: gradG.y = 5G:", dot(gg, y0, Z) == 5 * forms(y0, Z)["G"])
# (2) expansion identities of C2 (exact polynomial identity in y, s, u)
ctx, gens, zero, one = mp_ring(NAMES + ["s", "u", "t1", "t2"])
yv = gens[:9]; s_, u_, t1, t2 = gens[9:]
vt = [t1 * a_ + t2 * b_ for a_, b_ in zip(V1, V2)]
pt = [yv[i] + s_ * vt[i] + u_ * A_PT[i] for i in range(N)]
lhs = Fval(pt, zero)
f = forms(yv, zero)
ltau = f["l1"] * t1 + f["l2"] * t2
btau = f["B11"] * t1 * t1 + f["B12"] * t1 * t2 * 2 + f["B22"] * t2 * t2
rhs = f["F"] + s_ * ltau + u_ * f["Qa"] / 2 + s_ * s_ * btau / 2
print("identity F(y + s*v_tau + u*a) = F(y) + s*l_tau(y) + (u/2)*Q_a(y) + (s^2/2)*b_tau(y):", (lhs - rhs).is_zero())
# (3) the test recognises the known plane P_B at a random rational point of it
d = json.load(open("/home/claude/blind_check11/c1_data.json"))
PB = [[Fr(c) for c in w] for w in d["PB"]]
co = [Fr(random.randint(-5, 5)) for _ in range(5)]
y = [sum(co[j] * PB[j][i] for j in range(5)) for i in range(N)]
r = za_test(y, Z, O, lambda a_: a_ == 0)
print("random rational point of P_B: status", r["status"], "; rankJ", r.get("rankJ"), "; on Z_a:", r.get("on Z_a"),
      "; tangent == P_B:", rank(r["tangent"] + PB, Z, O) == 5 if "tangent" in r else None, "; tau =", r.get("tau"))
# (4) a random rational point of Y cap {Q_a=0}?  not available; instead a random point of P' (in Y, generically not in W)
Pp = [[Fr(c) for c in w] for w in d["Pprime"]]
y = [sum(co[j] * Pp[j][i] for j in range(5)) for i in range(N)]
f = forms(y, Z)
print("random point of P': F =", f["F"], " Q_a =", f["Qa"], " (not on the cone Q_a=0, as expected)")
