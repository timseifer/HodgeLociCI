"""
T6: symmetric family F_0 + tau*M_x.  EXACT, with x = (a0,a1,a2) kept SYMBOLIC:
the tau^n coefficient of every period equation of kappa is a polynomial in a0,a1,a2 (degree n); it is tested to be
the zero polynomial.  Also: the same for delta at a random rational x (expected nonzero at n=1), and a control arc
F_0 + tau*(M_x + c*P)   (P = p0p1p2 is not invariant; expected nonzero).
usage: python3 t6.py N
"""
import sys, time, random
from fractions import Fraction
import flint
import exact_eval as ee

N = int(sys.argv[1]) if len(sys.argv) > 1 else 8
names = [f"x{i}" for i in range(12)] + ["a0", "a1", "a2"]
ctx = flint.fmpq_mpoly_ctx.get(names, "degrevlex")
g = ctx.gens()
X = g[:12]; A = g[12:]
M = 0
for i in range(3):
    for j in range(3):
        M = M + A[(i - j) % 3] * X[ee.Y(i + j)] * X[ee.Pv(i)] * X[ee.Qv(j)]
kap = ee.kappa_poly()
Ql = ee.standard_forms()
print(f"T6 symbolic x: period equations of kappa along F_0 + tau*M_x, orders 1..{N}")
t0 = time.time()
res = ee.expansion({1: M}, N, ctx, kap, Ql)
allzero = all(not any(res[n]) for n in res)
print("ALL period equations of kappa vanish identically in x for n = 1..%d: %s   [%.0f s]" % (N, allzero, time.time() - t0))

# control 1: perturb the direction by c*(P+Q) (still Gamma'-odd?  P+Q is not twisted-invariant) -- must fail
ctx2 = flint.fmpq_mpoly_ctx.get([f"x{i}" for i in range(12)], "degrevlex")
X2 = ctx2.gens()
rng = random.Random(5)
xr = [Fraction(rng.randrange(-9, 10), rng.randrange(1, 5)) for _ in range(3)]
while 0 in xr:
    xr = [Fraction(rng.randrange(-9, 10), rng.randrange(1, 5)) for _ in range(3)]
def Mnum(xv):
    s = 0
    for i in range(3):
        for j in range(3):
            s = s + flint.fmpq(xv[(i - j) % 3].numerator, xv[(i - j) % 3].denominator) * X2[ee.Y(i + j)] * X2[ee.Pv(i)] * X2[ee.Qv(j)]
    return s
P2 = X2[ee.Pv(0)] * X2[ee.Pv(1)] * X2[ee.Pv(2)]
Q2 = X2[ee.Qv(0)] * X2[ee.Qv(1)] * X2[ee.Qv(2)]
Y2 = X2[ee.Y(0)] * X2[ee.Y(1)] * X2[ee.Y(2)]
print("control arcs at the rational point x =", xr)
for label, extra in (("F_0 + tau*(M_x + 2*(P+Q))  [= the lam-direction without the Y, theta corrections]", 2 * (P2 + Q2)),
                     ("F_0 + tau*(M_x + 2*P)", 2 * P2),
                     ("F_0 + tau*(M_x + 2*Y)", 2 * Y2),
                     ("F_0 + tau*(M_x + 2*(P-Q))", 2 * (P2 - Q2))):
    r = ee.expansion({1: Mnum(xr) + extra}, 6, ctx2, kap, Ql, verbose=False, stop_at_first=True)
    first = [n for n in sorted(r) if any(r[n])]
    print(f"   {label}: first nonzero order for kappa: {first[0] if first else 'none up to 6'}")
