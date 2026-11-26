# Link the special points (12 on L, 8 on pi, pi_2, pi_3) with the 1-parameter family found in gen_check.py:
# show that the plane through each of them is a specialisation of the generic member (so they lie on the 5-dimensional
# part of Z_a), by checking that (tau(y), Pi_y cap M) satisfies the equations of the generic degree-2 component.
import json, re, sys
from common import *
from fields import *
from ztest import *
from flint import fmpq_poly, fmpq, fmpz
txt = open("/home/claude/blind_check11/gen_comp.txt").read().split("COMPONENT")[1:]
comps = [[l for l in c.strip().split("\n") if l.strip()] for c in txt]
comp = [c for c in comps if "t" in c[0]][0]          # the t-dependent component
other = [c for c in comps if "t" not in c[0]][0]     # the t-independent one (points of V)
M_COLS = [[Fr(c) for c in v] for v in json.load(open("/home/claude/blind_check11/gen_M.json"))["M_COLS"]]
out = open("/home/claude/blind_check11/gen_link.out", "w")
def P(*a):
    s = " ".join(str(x) for x in a)
    print(s); out.write(s + "\n"); out.flush()

def ev(line, K, t, s0, s1, s2, s4):
    return K.zero + eval(line.replace("^", "**"), {"t": t, "s0": s0, "s1": s1, "s2": s2, "s4": s4})

def link(yk, K, label):
    iz = lambda a_: (a_ == 0)
    r = za_test(yk, K.zero, K.one, iz)
    assert r["status"] == "ok" and r["on Z_a"]
    t1, t2 = r["tau"]
    t0 = t2 / t1
    Kt = r["tangent"]
    # Pi_y cap M: sum x_i Kt_i - sum s_j M_j = 0
    Mat = [[Kt[i][row] for i in range(5)] + [K.zero - M_COLS[j][row] for j in range(5)] for row in range(N)]
    ns = nullspace(Mat, K.zero, K.one, iz)
    P(label, ": dim(Pi_y cap M) (affine) =", len(ns))
    assert len(ns) == 1
    s = ns[0][5:]
    assert not (s[3] == 0)
    s = [c / s[3] for c in s]
    yM = [K.zero] * N
    for j in range(5):
        for i in range(N):
            yM[i] = yM[i] + s[j] * M_COLS[j][i]
    rM = za_test(yM, K.zero, K.one, iz)
    P("    at y_M = Pi_y cap M: l1=0:", rM["l1=0"], " l2=0:", rM["l2=0"], " rankJ:", rM["rankJ"], " on Z_a:", rM.get("on Z_a"))
    tM1, tM2 = rM["tau"]
    P("    tau(y_M) == tau(y):", (tM1 * t2 - tM2 * t1) == 0)
    vals = [ev(line, K, t0, s[0], s[1], s[2], s[4]) for line in comp]
    P("    generators of the generic degree-2 component vanish at (tau(y), y_M):", [v == 0 for v in vals])
    # leading coefficients at t0 (non-vanishing => the fibre of the closure over t0 is cut out by these equations)
    Z_, O_ = K.zero, K.one
    lead = []
    f0 = lambda v: ev(comp[0], K, t0, Z_, Z_, v, Z_)
    A_ = (f0(O_) + f0(Z_ - O_)) / 2 - f0(Z_)
    lead.append(A_)
    for line in comp[1:]:
        var = [v for v in ("s0", "s1", "s4") if v in line][0]
        args = dict(s0=Z_, s1=Z_, s2=Z_, s4=Z_)
        e = ev(line, K, t0, **args)
        args[var] = O_
        lead.append(ev(line, K, t0, **args) - e)
    P("    leading coefficients at tau(y) nonzero:", [not (c == 0) for c in lead])
    return all(v == 0 for v in vals) and all(not (c == 0) for c in lead) and rM["rankJ"] == 4 and not (rM["l1=0"] and rM["l2=0"])

results = {}
# ---- the degree-12 and degree-18 points on L (from c4_lex.txt) ----
from c4 import r0, r1, facs
for g, e in sorted(facs, key=lambda ge: ge[0].degree()):
    g = g * (1 / g.leading_coefficient())
    K = NumberField(g)
    svals = [K.elem(r0), K.elem(r1), K.gen, K.one]
    yk = [K.zero] * N
    for j in range(4):
        for i in range(N):
            yk[i] = yk[i] + svals[j] * L_COLS[j][i]
    if K.deg == 12:
        results["L deg 12"] = link(yk, K, "degree-12 point on L")
P("RESULTS:", results)
