# verify: sum_k y_k^3 (k=0..5) in coordinates f_i = y_(2i) - z y_(2i+1), h_i = y_(2i) + y_(2i+1), z^2 - z + 1 = 0
import sympy as sp
z = sp.symbols('z'); f = sp.symbols('f1:4'); h = sp.symbols('h1:4')
tot = 0
for i in range(3):
    # solve y0 - z y1 = f, y0 + y1 = h
    y1 = (h[i] - f[i]) / (1 + z); y0 = h[i] - y1
    tot += y0**3 + y1**3
tot = sp.together(sp.expand(tot))
num, den = sp.fraction(tot)
num = sp.rem(sp.Poly(sp.expand(num), z), sp.Poly(z**2 - z + 1, z)).as_expr()
cand = sum(f[i]*h[i]*(f[i] + (z - 1)*h[i]) for i in range(3))
# ratio check: num - c*cand*den reduce mod z^2-z+1
c = sp.symbols('c')
print('num =', sp.factor(sp.expand(num)))
print('den =', sp.factor(den))
