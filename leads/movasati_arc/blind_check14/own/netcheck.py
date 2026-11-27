import sympy as sp
x = sp.symbols('x_0:10'); z = sp.Symbol('z')
f = [x[2*i] - z*x[2*i+1] for i in range(3)]; h = [x[2*i] + x[2*i+1] for i in range(3)]
def net(A):
    e = sp.expand(sum(A[i, j]*f[i]*h[j] for i in range(3) for j in range(3)))
    P = sp.Poly(e, *x)
    return sp.Poly({m: c for m, c in P.terms() if max(m) <= 1}, *x)
G = sp.Matrix([[1,1,0],[0,1,1],[1,0,2]]); H = sp.Matrix([[2,0,1],[1,1,0],[0,1,1]])
F1 = sp.zeros(3); F1[0,0]=1; F1[0,1]=2; F1[1,1]=1
F2 = sp.zeros(3); F2[0,0]=1; F2[1,0]=1; F2[1,1]=1
E01 = sp.zeros(3); E01[0,1]=1; E10 = sp.zeros(3); E10[1,0]=1
line = lambda fn: [l.strip() for l in open("/home/claude/hodgelocici/leads/movasati_arc/arcs/"+fn) if l.strip()][3]
for fn, A, B in [("exact_s_lam-1_order9.txt", E01+E10, E01-E10), ("exact_g_lam-1_order7.txt", G*F1*H, G*F2*H)]:
    T = sp.Poly(sp.sympify(line(fn).replace("^","**"), locals={**{"x_%d"%i: x[i] for i in range(10)}, "z": z}), *x)
    T7 = sp.Poly({m: c for m, c in T.terms() if m[7] == 1}, *x); T9 = sp.Poly({m: c for m, c in T.terms() if m[9] == 1}, *x)
    d7 = sp.Poly(T7.as_expr() - x[7]*net(A).as_expr(), *x); d9 = sp.Poly(T9.as_expr() - x[9]*net(B).as_expr(), *x)
    red = lambda q: sp.rem(sp.expand(q.as_expr()), z**2 - z + 1, z)
    print(fn, "x7 diff:", red(d7), " x9 diff:", red(d9), " rest monomials:", len(T.terms()) - len(T7.terms()) - len(T9.terms()))
