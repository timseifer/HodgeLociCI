# Invariants of the group Gamma' (the automorphisms sh, c, b, iota of every X_x that fix the three-plane class)
# on the Jacobian ring of the Fermat cubic, with the twist by the determinant (action on Q * Omega).
# EXACT (combinatorial: the group is monomial).  AI-written, unreviewed.
#   r_k = x_(2k), y_k = x_(2k+1), p_i = x_(6+2i), q_i = x_(7+2i)
#   sh   : (r_k, y_k) -> (r_(k+2), y_(k+2)), (p_i, q_i) -> (p_(i+1), q_(i+1))
#   c    : r_k, y_k -> w^k r_k, w^k y_k;  p_i, q_i -> w^(-i) p_i, w^(-i) q_i        (w = exp(2 pi i / 3))
#   b    : p -> w p, q -> w^2 q
#   iota : r_k -> r_(-k), y_k -> y_(-k), p_i -> q_(-i), q_i -> p_(-i)
# A group element is (perm, ph): x_i -> w^ph[i] x_perm[i].
import itertools
NV = 12
R = lambda k: 2 * (k % 3); Y = lambda k: 2 * (k % 3) + 1; P = lambda i: 6 + 2 * (i % 3); Q = lambda i: 7 + 2 * (i % 3)
def mk(f, ph=None):
    perm = [None] * NV
    for k in range(3):
        perm[R(k)], perm[Y(k)], perm[P(k)], perm[Q(k)] = f(k)
    return (tuple(perm), tuple(ph if ph else [0] * NV))
sh = mk(lambda k: (R(k + 2), Y(k + 2), P(k + 1), Q(k + 1)))
iota = mk(lambda k: (R(-k), Y(-k), Q(-k), P(-k)))
idp = tuple(range(NV))
phc = [0] * NV; phb = [0] * NV
for k in range(3):
    phc[R(k)] = k; phc[Y(k)] = k; phc[P(k)] = (-k) % 3; phc[Q(k)] = (-k) % 3
    phb[P(k)] = 1; phb[Q(k)] = 2
c = (idp, tuple(phc)); b = (idp, tuple(phb))
def mul(g, h):
    # (g o h): x_i -> h -> w^h.ph[i] x_h.perm[i] -> w^(h.ph[i] + g.ph[h.perm[i]]) x_g.perm[h.perm[i]]
    return (tuple(g[0][h[0][i]] for i in range(NV)), tuple((h[1][i] + g[1][h[0][i]]) % 3 for i in range(NV)))
def sign(perm):
    s = 1; seen = [False] * NV
    for i in range(NV):
        if not seen[i]:
            j = i; L = 0
            while not seen[j]: seen[j] = True; j = perm[j]; L += 1
            if L % 2 == 0: s = -s
    return s
# the generators preserve M_x: monomial y_(i+j) p_i q_j with label (i-j)
def act_mon(g, e):
    out = [0] * NV; ph = 0
    for i in range(NV):
        if e[i]: out[g[0][i]] += e[i]; ph += e[i] * g[1][i]
    return tuple(out), ph % 3
mons = {}
for i in range(3):
    for j in range(3):
        e = [0] * NV; e[Y(i + j)] += 1; e[P(i)] += 1; e[Q(j)] += 1; mons[tuple(e)] = (i - j) % 3
for nm, g in (("sh", sh), ("c", c), ("b", b), ("iota", iota)):
    ok = all(act_mon(g, e)[1] == 0 and mons.get(act_mon(g, e)[0]) == d for e, d in mons.items())
    print("generator %-4s preserves M_x for every x: %s;  sign of its permutation %+d, sum of phases %d mod 3"
          % (nm, ok, sign(g[0]), sum(g[1]) % 3))
# close the group
gens = [sh, c, b, iota]; G = {(idp, tuple([0] * NV))}; frontier = list(G)
while frontier:
    new = []
    for g in frontier:
        for h in gens:
            k = mul(h, g)
            if k not in G: G.add(k); new.append(k)
    frontier = new
print("order of the group generated (as matrices):", len(G))
def twisted_invariants(deg):
    """number of independent Gamma'-invariant classes Q*Omega, Q squarefree of degree deg (basis of the Jacobian ring
    of the Fermat cubic in that degree); returns (dimension, list of orbit representatives)"""
    todo = set(tuple(1 if i in cmb else 0 for i in range(NV)) for cmb in itertools.combinations(range(NV), deg))
    dim = 0; reps = []
    while todo:
        e = next(iter(todo)); orbit = set(); good = True
        for g in G:
            e2, ph = act_mon(g, e)
            orbit.add(e2)
            if e2 == e:
                # character of g on (x^e Omega): sign(perm) * w^(ph + sum of all phases)
                if sign(g[0]) != 1 or (ph + sum(g[1])) % 3 != 0: good = False
        todo -= orbit
        if good: dim += 1; reps.append((e, len(orbit)))
    return dim, reps
names = [("r%d" % k) for k in range(3)]
nm = {R(k): "r%d" % k for k in range(3)}; nm.update({Y(k): "y%d" % k for k in range(3)})
nm.update({P(k): "p%d" % k for k in range(3)}); nm.update({Q(k): "q%d" % k for k in range(3)})
for deg, typ in ((0, "(7,3)"), (3, "(6,4)"), (6, "(5,5)"), (9, "(4,6)"), (12, "(3,7)")):
    d, reps = twisted_invariants(deg)
    line = "invariant part, Hodge type %s (Q of degree %2d): dimension %d" % (typ, deg, d)
    if deg == 3:
        line += ";  orbits: " + "; ".join("{" + " ".join(nm[i] for i in range(NV) if e[i]) + "} (orbit of %d)" % n for e, n in reps)
    print(line)
