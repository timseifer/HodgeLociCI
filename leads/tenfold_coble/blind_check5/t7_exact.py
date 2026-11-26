"""
T7 cross-check, EXACT over QQ (python-flint engine exact_eval.py, independent of the numpy engine):
the same arc with small-integer random data; (a) algebraic restriction identity (sympy, symbolic),
(b) period equations of kappa for n <= N exactly, (c) the variants, and a comparison of the exact nonzero values of
the variants with the numpy/mod-p engine (must agree mod p up to the constant -2187).
usage: python3 t7_exact.py SEED N [sizes]
"""
import sys, time
from fractions import Fraction
import flint
import exact_eval as ee
import t7, pcore

seed = int(sys.argv[1]); N = int(sys.argv[2])
sizes = tuple(int(t) for t in sys.argv[3].split(",")) if len(sys.argv) > 3 else (3, 3, 3)
p = 2147483629
xi_p, lam1_p, phis_p = t7.random_data(seed, p, sizes, small=True)
cen = lambda c: c if c <= p // 2 else c - p
xi = [Fraction(cen(c)) for c in xi_p]; lam1 = Fraction(cen(lam1_p))
phis = [[(Fraction(cen(c)), m) for c, m in ph] for ph in phis_p]
print("EXACT run. seed", seed, " xi =", [int(t) for t in xi], " lam1 =", int(lam1))
print("  phi =", t7.describe(phis_p, p))

# ---------- (a) algebra, fully symbolic ----------
import sympy as sp
th, lam = sp.symbols("theta lam")
xs = sp.symbols("x0:3")
r = sp.symbols("r0:3"); y = sp.symbols("y0:3"); pq = sp.symbols("p0:3"); qq = sp.symbols("q0:3")
ph = sp.symbols("phi0:3")       # arbitrary quadrics: kept as free symbols
h = lambda v, l: v[0]**3 + v[1]**3 + v[2]**3 + 3*l*v[0]*v[1]*v[2]
a = 1 - th**3
M = sum(xs[(i-j) % 3]*y[(i+j) % 3]*pq[i]*qq[j] for i in range(3) for j in range(3))
F = h(r, 0) + h(y, 0) + h(pq, 0) + h(qq, 0) + 3*lam*(pq[0]*pq[1]*pq[2] + qq[0]*qq[1]*qq[2]) + 3*a*lam*y[0]*y[1]*y[2] + M \
    + sum((r[k] + th*y[k])*ph[k] for k in range(3))
restr = F.subs({r[k]: -th*y[k] for k in range(3)})
print("(a) F_tau restricted to r_k = -theta y_k  equals  a*h_lam(y) + h_lam(p) + h_lam(q) + M_x  (a = 1 - theta^3, "
      "arbitrary phi_k, lam, x):", sp.expand(restr - (a*h(y, lam) + h(pq, lam) + h(qq, lam) + M)) == 0)

# ---------- exact power series ----------
def smul(A, B, n):
    C = [Fraction(0)] * (n + 1)
    for i, u in enumerate(A):
        if u:
            for j, v in enumerate(B):
                if i + j > n: break
                C[i + j] += u * v
    return C

def a_theta(variant, n):
    h0 = xi[0]**3 + xi[1]**3 + xi[2]**3
    num = [Fraction(0)] * (n + 1)
    if n >= 3: num[3] = h0
    if n >= 4 and variant != "ii": num[4] = 3 * lam1 * xi[0] * xi[1] * xi[2]
    den = [Fraction(0)] * (n + 1)
    if variant == "iii":
        den[0] = Fraction(1)
    else:
        c = Fraction(1)
        for k in range(0, n + 1, 3):
            den[k] = c; c = -c * lam1**3
    av = [-t / 27 for t in smul(num, den, n)]
    theta = [Fraction(1)] + [Fraction(0)] * n
    powk = [Fraction(1)] + [Fraction(0)] * n
    binom = Fraction(1)
    ma = [-t for t in av]
    for k in range(1, n // 3 + 2):
        powk = smul(powk, ma, n)
        binom = binom * (Fraction(1, 3) - (k - 1)) / k
        theta = [theta[i] + binom * powk[i] for i in range(n + 1)]
    t3 = smul(smul(theta, theta, n), theta, n)
    assert t3[0] + av[0] == 1 and all(t3[i] + av[i] == 0 for i in range(1, n + 1))
    if variant == "iv":
        theta = [Fraction(1)] + [Fraction(0)] * n
    return av, theta

ctx = flint.fmpq_mpoly_ctx.get([f"x{i}" for i in range(12)], "degrevlex")
X = ctx.gens()
fq = lambda t: flint.fmpq(t.numerator, t.denominator)

def build(variant):
    av, theta = a_theta(variant, N + 1)
    G = {}
    def add(j, poly):
        if j <= N:
            G[j] = G.get(j, ctx.from_dict({})) + poly
    Pm = X[ee.Pv(0)]*X[ee.Pv(1)]*X[ee.Pv(2)]; Qm = X[ee.Qv(0)]*X[ee.Qv(1)]*X[ee.Qv(2)]; Ym = X[ee.Y(0)]*X[ee.Y(1)]*X[ee.Y(2)]
    add(1, fq(3*lam1)*(Pm + Qm))
    for i in range(3):
        for j in range(3):
            add(1, fq(xi[(i-j) % 3])*X[ee.Y(i+j)]*X[ee.Pv(i)]*X[ee.Qv(j)])
    if variant != "i":
        for m in range(N + 1):
            if av[m]: add(m + 1, fq(3*av[m]*lam1)*Ym)
    for k in range(3):
        phk = sum(fq(c)*X[u]*X[v] for c, (u, v) in phis[k])
        add(1, X[ee.R(k)]*phk)
        for m in range(N + 1):
            if theta[m]: add(m + 1, fq(theta[m])*X[ee.Y(k)]*phk)
    return G

kap = ee.kappa_poly()
Ql = ee.standard_forms()
t0 = time.time()
print(f"(b) TRUE ARC, exact, kappa, orders 1..{N}:")
res = ee.expansion(build("true"), N, ctx, kap, Ql)
print("    all period equations of kappa vanish EXACTLY for n = 1..%d: %s   [%.0f s]" % (N, all(not any(res[n]) for n in res), time.time()-t0))

# (c) variants, exact, and comparison with the numpy engine mod p
kap_p = pcore.kappa_poly(p)
Qlp = pcore.standard_forms()
assert Qlp == Ql
for var in ("i", "ii", "iii", "iv"):
    r_ex = ee.expansion(build(var), N, ctx, kap, Ql, verbose=False, stop_at_first=True)
    first = [n for n in sorted(r_ex) if any(r_ex[n])]
    if not first:
        print(f"(c) variant ({var}): exact: none up to {N}")
        continue
    n0 = first[0]
    vec_ex = [(d.get((), 0)) for d in r_ex[n0]]
    Gp, _, _ = t7.build_arc(p, xi_p, lam1_p, phis_p, n0, var)
    r_np, f_np = pcore.expansion(Gp, n0, p, [kap_p], Qlp, stop_at_first=False)
    vec_np = r_np[0][n0]
    ok = all(((-2187) * (v.numerator % p) * pow(v.denominator % p, p - 2, p) - w) % p == 0 for v, w in zip(vec_ex, vec_np))
    lower_ok = all(not any(r_np[0][n]) for n in range(1, n0))
    print(f"(c) variant ({var}): exact first nonzero order {n0} ({sum(1 for v in vec_ex if v)} of 221 forms); "
          f"numpy engine mod {p}: lower orders zero: {lower_ok}; all 221 values agree with -2187 * exact: {ok}")
