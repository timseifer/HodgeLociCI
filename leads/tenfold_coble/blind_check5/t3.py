"""T3: the group Gamma'.  EXACT (monomial matrices with entries in mu_3; scalars kept as (sign, exponent of w))."""
import itertools, sys
import sympy as sp

# variables: index 2k = r_k, 2k+1 = y_k, 6+2i = p_i, 7+2i = q_i
R = lambda k: 2*(k % 3)
Y = lambda k: 2*(k % 3)+1
P = lambda i: 6+2*(i % 3)
Q = lambda i: 7+2*(i % 3)
names = {}
for k in range(3):
    names[R(k)] = f"r{k}"; names[Y(k)] = f"y{k}"; names[P(k)] = f"p{k}"; names[Q(k)] = f"q{k}"

# a generator is a substitution  x_v -> w^e[v] * x_(s[v])
def gen_sh():
    s = [0]*12; e = [0]*12
    for k in range(3):
        s[R(k)] = R(k+2); s[Y(k)] = Y(k+2); s[P(k)] = P(k+1); s[Q(k)] = Q(k+1)
    return (tuple(s), tuple(e))
def gen_c():
    s = list(range(12)); e = [0]*12
    for k in range(3):
        e[R(k)] = k % 3; e[Y(k)] = k % 3; e[P(k)] = (-k) % 3; e[Q(k)] = (-k) % 3
    return (tuple(s), tuple(e))
def gen_b():
    s = list(range(12)); e = [0]*12
    for k in range(3):
        e[P(k)] = 1; e[Q(k)] = 2
    return (tuple(s), tuple(e))
def gen_iota():
    s = [0]*12; e = [0]*12
    for k in range(3):
        s[R(k)] = R(-k); s[Y(k)] = Y(-k); s[P(k)] = Q(-k); s[Q(k)] = P(-k)
    return (tuple(s), tuple(e))
gens = {"sh": gen_sh(), "c": gen_c(), "b": gen_b(), "iota": gen_iota()}

def compose(g, h):
    """substitution g followed by substitution h:  x_v -> w^e_g[v] x_(s_g[v]) -> w^(e_g[v]+e_h[s_g[v]]) x_(s_h[s_g[v]])"""
    sg, eg = g; sh_, eh = h
    return (tuple(sh_[sg[v]] for v in range(12)), tuple((eg[v] + eh[sg[v]]) % 3 for v in range(12)))

# ---- (a) invariance of F_x for every x, symbolic ----
xs = sp.symbols("x0:12"); a = sp.symbols("a0:3"); w = sp.symbols("w")
def Fx():
    F = sum(v**3 for v in xs)
    for i in range(3):
        for j in range(3):
            F += a[(i-j) % 3]*xs[Y(i+j)]*xs[P(i)]*xs[Q(j)]
    return F
F = Fx()
def apply_sub(expr, g):
    s, e = g
    return expr.subs({xs[v]: w**e[v]*xs[s[v]] for v in range(12)}, simultaneous=True)
print("(a) F_x o g == F_x identically in x (w^2+w+1=0):")
for nm, g in gens.items():
    d = sp.expand(apply_sub(F, g) - F)
    d = sp.Poly(d, *xs, *a)
    ok = all(sp.rem(c, w**2 + w + 1, w) == 0 for c in d.coeffs()) if d.as_expr() != 0 else True
    print("   ", nm, ok)

# ---- (b) action on the three planes ----
# plane P_zeta: ideal (r_k + y_k, p_i - zeta q_i).  zeta in {-1, -w, -w^2} (the roots of z^3 = -1).
# pull back the equations by the substitution and identify the plane.
def plane_eqs(t):   # zeta = -w^t
    return [xs[R(k)] + xs[Y(k)] for k in range(3)] + [xs[P(i)] + w**t*xs[Q(i)] for i in range(3)]
def redw(e):
    return sp.rem(sp.expand(e), w**2 + w + 1, w)
def same_space(E1, E2):
    M1 = sp.Matrix([[redw(sp.Poly(e, *xs).coeff_monomial(v)) for v in xs] for e in E1])
    M2 = sp.Matrix([[redw(sp.Poly(e, *xs).coeff_monomial(v)) for v in xs] for e in E2])
    ww = sp.Rational(-1, 2) + sp.sqrt(3)*sp.I/2
    M1 = M1.subs(w, ww); M2 = M2.subs(w, ww)
    return M1.rank() == 6 and M1.col_join(M2).rank() == 6
print("(b) image of the planes (zeta = -w^t, t=0,1,2) under each generator (as a permutation of t):")
for nm, g in gens.items():
    perm = []
    for t in range(3):
        img = [sp.expand(apply_sub(e, g)) for e in plane_eqs(t)]
        hit = [u for u in range(3) if same_space(img, plane_eqs(u))]
        perm.append(hit[0] if len(hit) == 1 else None)
    print("   ", nm, perm)

# ---- (c) order ----
ident = (tuple(range(12)), tuple([0]*12))
elems = {ident}
frontier = [ident]
while frontier:
    new = []
    for g in frontier:
        for h in gens.values():
            gh = compose(g, h)
            if gh not in elems:
                elems.add(gh); new.append(gh)
    frontier = new
print("(c) order of Gamma' as a group of linear maps:", len(elems))
scal = [g for g in elems if g[0] == tuple(range(12)) and len(set(g[1])) == 1]
print("    scalar matrices in it:", len(scal), " -> order of the image in PGL_12:", len(elems)//len(scal))
diag = [g for g in elems if g[0] == tuple(range(12))]
print("    diagonal elements:", len(diag))
# abelian? centre? derived subgroup size
def inv(g):
    s, e = g
    si = [0]*12; ei = [0]*12
    for v in range(12):
        si[s[v]] = v
    for v in range(12):
        ei[s[v]] = (-e[v]) % 3
    return (tuple(si), tuple(ei))
el = list(elems)
centre = [g for g in el if all(compose(g, h) == compose(h, g) for h in gens.values())]
print("    centre has order", len(centre))
orders = {}
def order(g):
    n = 1; h = g
    while h != ident:
        h = compose(h, g); n += 1
    return n
for g in el:
    o = order(g); orders[o] = orders.get(o, 0) + 1
print("    element orders:", dict(sorted(orders.items())))

# determinant of the substitution: sign(perm) * w^(sum e)
def perm_sign(s):
    seen = [False]*12; sg = 1
    for v in range(12):
        if not seen[v]:
            L = 0; u = v
            while not seen[u]:
                seen[u] = True; u = s[u]; L += 1
            if L % 2 == 0:
                sg = -sg
    return sg
def det(g):
    return (perm_sign(g[0]), sum(g[1]) % 3)
print("    determinants of the generators (sign, exponent of w):", {nm: det(g) for nm, g in gens.items()})

# ---- (d) invariants of Q*Omega, Q squarefree of degree d:  g.(Q Omega) = det(g) * (Q o g) * Omega ----
# elements of Z[w] as pairs (a,b) = a + b w
def wpow(e):
    return [(1, 0), (0, 1), (-1, -1)][e % 3]
def act(g, mon):
    """mon: frozenset of variables. returns (image monomial, sign, exponent)"""
    s, e = g
    sg, ed = det(g)
    return (frozenset(s[v] for v in mon), sg, (ed + sum(e[v] for v in mon)) % 3)
print("(d) dimension of the Gamma'-invariant part of {Q*Omega : Q squarefree of degree deg}:")
for deg in (0, 3, 6, 9, 12):
    mons = [frozenset(c) for c in itertools.combinations(range(12), deg)]
    seen = set(); invs = []
    for m in mons:
        if m in seen:
            continue
        vec = {}
        for g in el:
            m2, sg, ex = act(g, m)
            a0, b0 = wpow(ex)
            pa, pb = vec.get(m2, (0, 0))
            vec[m2] = (pa + sg*a0, pb + sg*b0)
        seen.update(vec.keys())
        vec = {k: v for k, v in vec.items() if v != (0, 0)}
        if vec:
            invs.append(vec)
    # character formula as a cross-check: dim = (1/|G|) sum_g trace
    tr = [0, 0]
    for g in el:
        for m in mons:
            m2, sg, ex = act(g, m)
            if m2 == m:
                a0, b0 = wpow(ex); tr[0] += sg*a0; tr[1] += sg*b0
    assert tr[1] == 0 and tr[0] % len(el) == 0
    print(f"    degree {deg}: dim = {len(invs)}  (character formula: {tr[0]//len(el)}), total dim {len(mons)}")
    if deg == 3:
        for vec in invs:
            # normalise
            items = sorted(vec.items(), key=lambda t: sorted(t[0]))
            n0 = items[0][1]
            print("       spanning element (up to scalar):",
                  " + ".join(f"({v[0]}+{v[1]}w)*" + "*".join(names[u] for u in sorted(k)) for k, v in items))
    if deg in (0, 12):
        for vec in invs:
            print("       invariant:", vec)
