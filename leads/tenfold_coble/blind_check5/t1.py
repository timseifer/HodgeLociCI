"""T1: first order, EXACT over Q(z)[a0,a1,a2] (z^2 - z + 1 = 0; a = the parameters x of M_x)."""
import itertools
import sympy as sp

z = sp.symbols("z")
a = sp.symbols("a0:3")
xs = sp.symbols("x0:12")
R = lambda k: xs[2*(k % 3)]
Y = lambda k: xs[2*(k % 3)+1]
Pp = lambda i: xs[6+2*(i % 3)]
Qq = lambda i: xs[7+2*(i % 3)]
red = lambda e: sp.rem(sp.expand(e), z**2 - z + 1, z)

def PL(c):
    out = 1
    for k in range(3):
        out *= 3*(-1)*(R(k) - Y(k))
    for i in range(3):
        out *= 3*c*(Pp(i) + c*Qq(i))
    return sp.Poly(sp.expand(out), *xs)

roots = [z, sp.Integer(-1), red(z**5)]
planes = [PL(c) for c in roots]
def coeffdict(P):
    return {m: red(c) for m, c in P.terms()}
pl = [coeffdict(P) for P in planes]
def comb(cs):
    out = {}
    for d, c in zip(pl, cs):
        for m, v in d.items():
            out[m] = red(out.get(m, 0) + c*v)
    return {m: v for m, v in out.items() if v != 0}
kappa = comb([-1, -1, -1])
deltas = {"delta(z1,z2)": comb([1, -1, 0]), "delta(z2,z3)": comb([0, 1, -1]), "delta(z1,z3)": comb([1, 0, -1])}
print("kappa period polynomial monomials:", len(kappa), " coefficients:", set(kappa.values()))

M = sum(a[(i-j) % 3]*Y(i+j)*Pp(i)*Qq(j) for i in range(3) for j in range(3))
Mp = sp.Poly(M, *xs)
def first_order(cls):
    """vector over the 220 squarefree cubics Q of Psi(Q*M): pairing of squarefree part with complement"""
    out = {}
    for c in itertools.combinations(range(12), 3):
        val = 0
        for mon, cf in Mp.terms():
            e = list(mon)
            for i in c:
                e[i] += 1
            if max(e) > 1:
                continue      # exponent 2: Psi = 0 ; (degree 6, so no exponent >= 3 with the rest in range matters)
            comp = tuple(1 - t for t in e)
            if comp in cls:
                val += cf*cls[comp]
        val = red(val)
        if val != 0:
            out[c] = sp.factor(val)
    return out
fk = first_order(kappa)
print("kappa: number of Q with nonzero first-order equation (as polynomials in a0,a1,a2):", len(fk))
for name, d in deltas.items():
    fd = first_order(d)
    print(name, ": number of Q with nonzero first-order equation:", len(fd))
    vals = set(fd.values())
    lin = sp.Matrix([[sp.Poly(sp.expand(v), *a).coeff_monomial(t) for t in a] for v in fd.values()])
    # rank over Q(z): substitute z numeric root exactly via minimal polynomial -> compute rank with extension
    lin2 = lin.applyfunc(lambda e: e.subs(z, sp.Rational(1, 2) + sp.sqrt(3)*sp.I/2))
    print("   rank of the linear map (a0,a1,a2) -> first-order equations:", lin2.rank(),
          " sample:", list(fd.items())[:3])
