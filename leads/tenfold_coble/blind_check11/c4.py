# C4 step 2: parse the lex Groebner basis (shape position) computed by Singular for L cap W on the chart s3=1,
# verify it independently, and run the Z_a tests at the closed points.
import re, sys, time
from common import *
from fields import *
from ztest import *
from flint import fmpq_poly, fmpq, fmpz

def parse(s):
    """parse a Singular polynomial string in s0,s1,s2 into dict {(e0,e1,e2): fmpq}"""
    s = s.strip().replace(" ", "")
    terms = re.findall(r"[+-]?[^+-]+", s)
    d = {}
    for t in terms:
        sign = 1
        if t[0] == '+':
            t = t[1:]
        elif t[0] == '-':
            sign = -1; t = t[1:]
        parts = t.split('*')
        coef = fmpq(1)
        e = [0, 0, 0]
        for p in parts:
            mm = re.fullmatch(r"s([012])(?:\^(\d+))?", p)
            if mm:
                e[int(mm.group(1))] += int(mm.group(2) or 1)
            else:
                if '/' in p:
                    a_, b_ = p.split('/')
                    coef *= fmpq(fmpz(int(a_)), fmpz(int(b_)))
                else:
                    coef *= fmpq(fmpz(int(p)))
        key = tuple(e)
        d[key] = d.get(key, fmpq(0)) + sign * coef
    return d

out = open("/home/claude/blind_check11/c4.out", "w") if __name__ == "__main__" else open("/dev/null", "w")
def P(*a):
    s = " ".join(str(x) for x in a)
    print(s); out.write(s + "\n"); out.flush()

lines = open("/home/claude/blind_check11/c4_lex.txt").read().strip().split("\n")
assert len(lines) == 3
gb = [parse(l) for l in lines]
# generator 0: univariate in s2
assert all(k[0] == 0 and k[1] == 0 for k in gb[0])
m = fmpq_poly([gb[0].get((0, 0, i), fmpq(0)) for i in range(31)])
P("univariate generator: degree", m.degree())
P("squarefree:", m.gcd(m.derivative()).degree() == 0)
c, facs = m.factor()
P("factor degrees over QQ:", [(g.degree(), e) for g, e in facs])
def solve_for(d, var):
    # d: c*var + r(s2)  ->  return -r/c as fmpq_poly in s2
    lead = None; r = [fmpq(0)] * 31
    for k, cf in d.items():
        if k[var] == 1:
            assert sum(k) == 1
            lead = cf
        else:
            assert k[0] == 0 and k[1] == 0
            r[k[2]] = cf
    return fmpq_poly(r) * (-1 / lead)
# identify which generator carries s1 and which s0
g_s1 = [d for d in gb[1:] if any(k[1] == 1 for k in d)][0]
g_s0 = [d for d in gb[1:] if any(k[0] == 1 for k in d)][0]
r1 = solve_for(g_s1, 1)
r0 = solve_for(g_s0, 0)
summary = []
for g, e in sorted(facs, key=lambda ge: ge[0].degree()):
    g = g * (1 / g.leading_coefficient())
    K = NumberField(g)
    iz = lambda a_: (a_ == 0)
    P("--- closed point of degree", K.deg)
    svals = [K.elem(r0), K.elem(r1), K.gen, K.one]
    yk = [K.zero] * N
    for j in range(4):
        for i in range(N):
            yk[i] = yk[i] + svals[j] * L_COLS[j][i]
    t0 = time.time()
    r = za_test(yk, K.zero, K.one, iz)
    for key in ["F=0", "Qa=0", "G=0", "l1=0", "l2=0", "l_tau(y)=0", "b_tau(y)=0", "rankJ", "a in tangent",
                "a+vtau in tangent", "y in tangent", "nonvanishing cubic coefficients of F on tangent",
                "tangent in Y", "on Z_a", "status"]:
        if key in r:
            P("   ", key, ":", r[key])
    P("    time: %.1fs" % (time.time() - t0))
    t0 = time.time()
    rk, dimint = w_smooth_test(yk, K.zero, K.one, iz, L_COLS)
    P("    rank Jac(F,Q_a,G) at y:", rk, "; affine dim of (T_y W cap L):", dimint, " (1 = transversal, reduced point)")
    P("    time: %.1fs" % (time.time() - t0))
    summary.append((K.deg, r.get("on Z_a"), rk, dimint))
P("SUMMARY:", summary)
