# Hidden planes, step 2: at every point of D cap M (D = Y cap {Q_a=l1=l2=0}, pure of dimension 4, degree 24)
# test whether the component of D through it can be a 4-plane contained in Y.
import re, json, time
from common import *
from fields import *
from ztest import *
from flint import fmpq_poly, fmpq, fmpz
M_COLS = [[Fr(c) for c in v] for v in json.load(open("/home/claude/blind_check11/gen_M.json"))["M_COLS"]]
out = open("/home/claude/blind_check11/hidden_check.out", "w")
def P(*a):
    s = " ".join(str(x) for x in a)
    print(s); out.write(s + "\n"); out.flush()
VARS = {"s0": 0, "s1": 1, "s2": 2, "s4": 3}
def parse(s):
    s = s.strip().replace(" ", "")
    d = {}
    for t in re.findall(r"[+-]?[^+-]+", s):
        sign = 1
        if t[0] == '+': t = t[1:]
        elif t[0] == '-': sign = -1; t = t[1:]
        coef = fmpq(1); e = [0, 0, 0, 0]
        for p in t.split('*'):
            mm = re.fullmatch(r"(s[0124])(?:\^(\d+))?", p)
            if mm:
                e[VARS[mm.group(1)]] += int(mm.group(2) or 1)
            elif '/' in p:
                a_, b_ = p.split('/'); coef *= fmpq(fmpz(int(a_)), fmpz(int(b_)))
            else:
                coef *= fmpq(fmpz(int(p)))
        d[tuple(e)] = d.get(tuple(e), fmpq(0)) + sign * coef
    return d
lines = open("/home/claude/blind_check11/hidden_lex.txt").read().strip().split("\n")
gb = [parse(l) for l in lines]
uni = [d for d in gb if all(k[0] == 0 and k[1] == 0 and k[3] == 0 for k in d)][0]
deg = max(k[2] for k in uni)
m = fmpq_poly([uni.get((0, 0, i, 0), fmpq(0)) for i in range(deg + 1)])
P("univariate generator degree:", m.degree(), "; squarefree:", m.gcd(m.derivative()).degree() == 0)
def solve_for(var):
    d = [dd for dd in gb if any(k[var] == 1 for k in dd)][0]
    lead = None; r = [fmpq(0)] * (deg + 1)
    for k, cf in d.items():
        if k[var] == 1:
            assert sum(k) == 1; lead = cf
        else:
            assert k[0] == 0 and k[1] == 0 and k[3] == 0
            r[k[2]] = cf
    return fmpq_poly(r) * (-1 / lead)
r0, r1, r4 = solve_for(0), solve_for(1), solve_for(3)
for g, e in sorted(m.factor()[1], key=lambda ge: ge[0].degree()):
    g = g * (1 / g.leading_coefficient())
    K = NumberField(g)
    iz = lambda a_: (a_ == 0)
    svals = [K.elem(r0), K.elem(r1), K.gen, K.one, K.elem(r4)]
    yk = [K.zero] * N
    for j in range(5):
        for i in range(N):
            yk[i] = yk[i] + svals[j] * M_COLS[j][i]
    t0 = time.time()
    f = forms(yk, K.zero)
    P("--- closed point of degree", K.deg, ": F,Qa,l1,l2 vanish:", [f[k] == 0 for k in ["F", "Qa", "l1", "l2"]],
      "; B11,B12,B22 vanish:", [f[k] == 0 for k in ["B11", "B12", "B22"]])
    H = hess(yk, K.zero)
    J = [f["grad"], f["Hay"], matvec(H, [K.zero + c for c in V1], K.zero), matvec(H, [K.zero + c for c in V2], K.zero)]
    rk = rank(J, K.zero, K.one, iz)
    P("    rank Jac(F,Q_a,l1,l2) at the point:", rk)
    if rk == 4:
        Kt = nullspace(J, K.zero, K.one, iz)
        nonvan = sum(1 for i in range(5) for j in range(i, 5) for k in range(j, 5) if not (tri(Kt[i], Kt[j], Kt[k], K.zero) == 0))
        P("    D smooth of dim 4 there; nonvanishing cubic coefficients of F on T_y D:", nonvan, "of 35",
          " -> component of D through the point is a 4-plane in Y:", nonvan == 0)
    P("    time %.1fs" % (time.time() - t0))
