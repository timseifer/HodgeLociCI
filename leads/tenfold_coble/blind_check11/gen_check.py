# Generic member of the family: verify over the field QQ(t)[alpha]/(m2) that the t-dependent degree-2 point of
# M cap S_t (found by Singular, NOT trusted) lies on a 4-plane Pi contained in Y through a and a+v_t.
import re, time, json, sys
from common import *
from fields import *
from ztest import *
txt = open("/home/claude/blind_check11/gen_comp.txt").read().split("COMPONENT")[1:]
comps = [[l for l in c.strip().split("\n") if l.strip()] for c in txt]
M_COLS = [[Fr(c) for c in v] for v in json.load(open("/home/claude/blind_check11/gen_M.json"))["M_COLS"]]
out = open("/home/claude/blind_check11/gen_check.out", "w")
def P(*a):
    s = " ".join(str(x) for x in a)
    print(s); out.write(s + "\n"); out.flush()

def ev(line, s0, s1, s2, s4):
    return RF_ZERO + eval(line.replace("^", "**"), {"t": RF_T, "s0": s0, "s1": s1, "s2": s2, "s4": s4})

for ci, comp in enumerate(comps):
    P("=== component", ci, " (", len(comp), "generators )")
    Zr, Or = RF_ZERO, RF_ONE
    # generator 0: quadratic in s2
    f = lambda v: ev(comp[0], Zr, Zr, v, Zr)
    c0 = f(Zr); fp = f(Or); fm = f(Zr - Or)
    c2 = (fp + fm) / 2 - c0
    c1 = (fp - fm) / 2
    assert f(Or * 2) == c2 * 4 + c1 * 2 + c0
    dep_t = any(c.n.degree() > 0 or c.d.degree() > 0 for c in (c0 / c2, c1 / c2))
    P("minimal polynomial of s2 depends on t:", dep_t)
    K = ExtField([c0 / c2, c1 / c2, Or], Zr, Or)
    al = K.gen
    sol = {}
    for line in comp[1:]:
        var = [v for v in ("s0", "s1", "s4") if v in line]
        assert len(var) == 1
        var = var[0]
        args = dict(s0=Zr, s1=Zr, s2=Zr, s4=Zr)
        e = ev(line, **args)
        args2 = dict(args); args2[var] = Or
        c = ev(line, **args2) - e
        args3 = dict(args); args3["s2"] = Or
        d = ev(line, **args3) - e
        args4 = dict(args); args4["s2"] = Or * 3; args4[var] = Or * 5
        assert ev(line, **args4) == c * 5 + d * 3 + e      # generator is affine-linear in (var, s2)
        sol[var] = (al * d + e) * (Zr - Or / c)
    svals = [sol["s0"], sol["s1"], al, K.one, sol["s4"]]
    yk = [K.zero] * N
    for j in range(5):
        for i in range(N):
            yk[i] = yk[i] + svals[j] * M_COLS[j][i]
    iz = lambda a_: a_.is_zero()
    t0 = time.time()
    fm_ = forms(yk, K.zero)
    for k in ["F", "Qa", "l1", "l2", "B11", "B12", "B22", "G"]:
        P("   ", k, "(y) == 0:", fm_[k].is_zero())
    P("    l1 + t*l2 == 0:", (fm_["l1"] + fm_["l2"] * RF_T).is_zero(),
      "; B11+2t*B12+t^2*B22 == 0:", (fm_["B11"] + fm_["B12"] * (RF_T * 2) + fm_["B22"] * (RF_T * RF_T)).is_zero())
    if fm_["l1"].is_zero() and fm_["l2"].is_zero():
        P("    -> point of V (lies on S_tau for every tau); skipping plane test")
        continue
    r = za_test(yk, K.zero, K.one, iz)
    for key in ["l_tau(y)=0", "b_tau(y)=0", "rankJ", "a in tangent", "a+vtau in tangent", "y in tangent",
                "nonvanishing cubic coefficients of F on tangent", "tangent in Y", "on Z_a", "status"]:
        if key in r:
            P("   ", key, ":", r[key])
    # the plane is a K-point of the family; record discriminant of the quadratic (the double cover of the t-line)
    disc = (c1 / c2) * (c1 / c2) - (c0 / c2) * 4
    num = disc.n; den = disc.d
    P("    discriminant of the quadratic: numerator degree", num.degree(), ", denominator degree", den.degree())
    sf = num.factor()
    P("    numerator factorisation (degree, mult):", [(g.degree(), e) for g, e in sf[1]])
    sfd = den.factor()
    P("    denominator factorisation (degree, mult):", [(g.degree(), e) for g, e in sfd[1]])
    P("    time: %.1fs" % (time.time() - t0))
