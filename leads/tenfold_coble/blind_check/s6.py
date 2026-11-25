#!/usr/bin/env python3
# S6: exact symbolic check of the Burkhardt substitution.
import itertools
import sympy as sp

a, lam, x0, x1, x2, t = sp.symbols('a lam x0 x1 x2 t')
y0, y1, y2, y3, y4 = sp.symbols('y0:5')

def h(v, l):
    return v[0]**3 + v[1]**3 + v[2]**3 + 3*l*v[0]*v[1]*v[2]

rel = 27*(1 + lam**3)*a**3 + h((x0, x1, x2), lam)
burk = y0**4 - y0*(y1**3 + y2**3 + y3**3 + y4**3) + 3*y1*y2*y3*y4

# stated substitution: a = t*y0, 3*lam*a = -3*t*y1 (lam = -y1/y0), x_i = -3*t*y_{i+2}
sub = {a: t*y0, lam: -y1/y0, x0: -3*t*y2, x1: -3*t*y3, x2: -3*t*y4}
lhs = sp.simplify(sp.expand(sp.together(rel.subs(sub, simultaneous=True) * (t*y0))))
diff = sp.expand(lhs - 27*t**4*burk)
print("stated substitution: a*rel - 27 t^4 Burkhardt =", diff)
print("a*rel after substitution, expanded:", sp.expand(lhs))
# consistency of "3*lam*a = -3*t*y1"
print("3*lam*a + 3*t*y1 after substitution:", sp.simplify((3*lam*a + 3*t*y1).subs(sub, simultaneous=True)))
# also check without multiplying by a: rel = 27 t^3/y0 * Burkhardt
print("rel - 27 t^3 Burk / y0 =", sp.simplify(rel.subs(sub, simultaneous=True) - 27*t**3*burk/y0))

# polynomial form: with b := lam*a the relation times a is  27 a^4 + 27 a b^3 + a (x0^3+x1^3+x2^3) + 3 b x0 x1 x2
b = sp.symbols('b')
relpoly = 27*a**4 + 27*a*b**3 + a*(x0**3 + x1**3 + x2**3) + 3*b*x0*x1*x2
chk = sp.simplify((a*rel).subs(lam, b/a) - relpoly)
print("a*rel == 27a^4+27ab^3+a(sum x^3)+3b x0x1x2 (b=lam*a):", chk == 0)

# search over scalings a = c0 t y0, lam*a = c1 t y1, x_i = c2 t y_{2+i}, with c in a small set (signs and factors 1,3),
# plus permutations are irrelevant (Burkhardt symmetric in y1..y4 ... y2,y3,y4 symmetric here)
cands = [1, -1, 3, -3, sp.Rational(1, 3), -sp.Rational(1, 3)]
good = []
for c0, c1, c2 in itertools.product(cands, repeat=3):
    e = sp.expand(relpoly.subs({a: c0*t*y0, b: c1*t*y1, x0: c2*t*y2, x1: c2*t*y3, x2: c2*t*y4}, simultaneous=True))
    # proportional to t^4 * burk ?
    q = sp.simplify(e / (t**4*burk))
    if q.is_number:
        good.append((c0, c1, c2, q))
print("scalings (c0,c1,c2,constant) with a=c0 t y0, lam a=c1 t y1, x_i=c2 t y_{i+2} giving constant*t^4*Burkhardt:")
for g in good:
    print("   ", g)
# independent-sign search (signs of the three x's separately)
good2 = []
for c0 in (1, -1):
    for c1 in (1, -1):
        for s in itertools.product((3, -3), repeat=3):
            e = sp.expand(relpoly.subs({a: c0*t*y0, b: c1*t*y1, x0: s[0]*t*y2, x1: s[1]*t*y3, x2: s[2]*t*y4}, simultaneous=True))
            q = sp.simplify(e / (t**4*burk))
            if q.is_number:
                good2.append((c0, c1, s, q))
print("sign patterns with |c0|=|c1|=1, |x-scale|=3 that work:")
for g in good2:
    print("   ", g)
