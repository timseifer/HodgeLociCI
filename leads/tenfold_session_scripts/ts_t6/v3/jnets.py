# [TS-T6] (v3) swap check via nets of conics (AI-generated). G = sum_{ijk} M0[i,j,k] f_i h_j w_k (w = (f,h)).
# sigma swapping Q1 = V(f), Q2 = V(h) => sigma^*f = B h, sigma^*h = C f => net <q_j(f)> (bidegree (2,1) part) is projectively
# equivalent to net <r_i(h)> (bidegree (1,2) part) => discriminant cubics have equal j-invariant, i.e. S1^3 T2^2 = S2^3 T1^2
# (Aronhold S (deg 4), T (deg 6), computed here mod q as the 1-dim spaces of weight-0 polynomials invariant under random SL3 elements).
import sys, itertools, random, json
sys.path.insert(0, '/home/claude/hodge/discovery/checks/ts_t6')
q = int(sys.argv[1]); gseed = int(sys.argv[2])
random.seed(7)
inv = lambda a: pow(a % q, q - 2, q)
M3 = [e for e in itertools.product(range(4), repeat=3) if sum(e) == 3]   # 10 cubic monomials
def pmul(a, b):
    o = {}
    for e1, c1 in a.items():
        for e2, c2 in b.items():
            e = tuple(x + y for x, y in zip(e1, e2)); o[e] = (o.get(e, 0) + c1 * c2) % q
    return {e: c for e, c in o.items() if c}
def subst(f, g):   # f(g x), g 3x3
    lins = [{(1,0,0): g[i][0] % q, (0,1,0): g[i][1] % q, (0,0,1): g[i][2] % q} for i in range(3)]
    o = {}
    for e, c in f.items():
        t = {(0,0,0): c}
        for i in range(3):
            for _ in range(e[i]): t = pmul(t, lins[i])
        for e2, c2 in t.items(): o[e2] = (o.get(e2, 0) + c2) % q
    return [o.get(e, 0) for e in M3]
def wz(d):
    res = []
    for comb in itertools.combinations_with_replacement(range(10), d):
        s = [sum(M3[i][k] for i in comb) for k in range(3)]
        if s == [d, d, d]: res.append(comb)
    return res
def ev(mon, a):
    r = 1
    for i in mon: r = r * a[i] % q
    return r
def kernel_mod(rows, n):
    A = [r[:] for r in rows]; piv = []; r = 0
    for c in range(n):
        p_ = next((i for i in range(r, len(A)) if A[i][c]), None)
        if p_ is None: continue
        A[r], A[p_] = A[p_], A[r]; iv = inv(A[r][c]); A[r] = [x * iv % q for x in A[r]]
        for i in range(len(A)):
            if i != r and A[i][c]:
                fct = A[i][c]; A[i] = [(x - fct * y) % q for x, y in zip(A[i], A[r])]
        piv.append(c); r += 1
    free = [c for c in range(n) if c not in piv]
    ks = []
    for fc in free:
        v = [0] * n; v[fc] = 1
        for i, pc in enumerate(piv): v[pc] = (-A[i][fc]) % q
        ks.append(v)
    return ks
def randSL3():
    while True:
        g = [[random.randrange(q) for _ in range(3)] for _ in range(3)]
        d = (g[0][0]*(g[1][1]*g[2][2]-g[1][2]*g[2][1]) - g[0][1]*(g[1][0]*g[2][2]-g[1][2]*g[2][0]) + g[0][2]*(g[1][0]*g[2][1]-g[1][1]*g[2][0])) % q
        if d:
            # scale first row by 1/d -> det 1
            g[0] = [x * inv(d) % q for x in g[0]]; return g
INV = {}
for d in (4, 6):
    mons = wz(d); rows = []
    while len(rows) < len(mons) + 20:
        a = [random.randrange(q) for _ in range(10)]; f = {M3[i]: a[i] for i in range(10)}
        b = subst(f, randSL3())
        rows.append([(ev(m, b) - ev(m, a)) % q for m in mons])
    ks = kernel_mod(rows, len(mons))
    print("degree", d, "weight-0 monomials", len(mons), "invariant space dim", len(ks))
    assert len(ks) == 1
    INV[d] = (mons, ks[0])
def ST(a): return tuple(sum(c * ev(m, a) for m, c in zip(*INV[d])) % q for d in (4, 6))
# sanity: j of the Hesse family x^3+y^3+z^3+t xyz depends on t; and S,T invariant under a random GL3 up to det^d
a = [random.randrange(q) for _ in range(10)]; f = {M3[i]: a[i] for i in range(10)}
S0, T0 = ST(a); S1, T1 = ST(subst(f, randSL3()))
print("sanity invariance:", S0 == S1 and T0 == T1)
# nets
from split import M0_of, pair_forms
def nets_from_M0(M0w):
    # M0w[i][j] = dict k -> coeff (k over w = 0..5); q_j(f) coeffs in f-vars, r_i(h) coeffs in h-vars, as symmetric matrices
    Qj = []; Ri = []
    for j in range(3):
        Mx = [[0]*3 for _ in range(3)]
        for i in range(3):
            for k in range(3):
                c = M0w[i][j].get(k, 0) % q; Mx[i][k] = (Mx[i][k] + c * inv(2)) % q; Mx[k][i] = (Mx[k][i] + c * inv(2)) % q
        Qj.append(Mx)
    for i in range(3):
        Mx = [[0]*3 for _ in range(3)]
        for j in range(3):
            for k in range(3):
                c = M0w[i][j].get(3 + k, 0) % q; Mx[j][k] = (Mx[j][k] + c * inv(2)) % q; Mx[k][j] = (Mx[k][j] + c * inv(2)) % q
        Ri.append(Mx)
    return Qj, Ri
def disc_cubic(mats):
    # det(sum_j y_j A_j) as cubic in y
    ent = [[{tuple(1 if t == jj else 0 for t in range(3)): mats[jj][r][c] for jj in range(3) if mats[jj][r][c]} for c in range(3)] for r in range(3)]
    det = {}
    for perm, sg in (((0,1,2),1),((1,2,0),1),((2,0,1),1),((0,2,1),-1),((2,1,0),-1),((1,0,2),-1)):
        t = {(0,0,0): sg % q}
        for r in range(3): t = pmul(t, ent[r][perm[r]])
        for e, c in t.items(): det[e] = (det.get(e, 0) + c) % q
    return [det.get(e, 0) for e in M3]
if gseed == 0:
    # Fermat B: M = diag(l_k), l_k = x_a - (1-z) x_b, with f_k = x_a - z x_b, h_k = x_a + x_b  =>  x_b = (h-f)/(1+z), x_a = h - x_b
    PR = json.load(open('/home/claude/hodge/discovery/checks/ts_t6/primes.json'))['roots_of_z2_minus_z_plus_1']
    z = PR[str(q)][0]; zb = (1 - z) % q; i1z = inv(1 + z)
    M0w = [[{} for _ in range(3)] for _ in range(3)]
    for k in range(3):
        # l_k = x_a - zb x_b = h_k - (1 + zb) x_b = h_k - (1+zb)/(1+z) (h_k - f_k)
        cc = (1 + zb) * i1z % q
        M0w[k][k] = {k: cc, 3 + k: (1 - cc) % q}
elif gseed < 0:
    # positive control: symmetrised G(f,h) + G(h,f) from seed |gseed| (swap automorphism w_i <-> w_{3+i} by construction)
    M0 = M0_of(-gseed); sw = lambda k: (k + 3) % 6
    M0w = [[{} for _ in range(3)] for _ in range(3)]
    for i in range(3):
        for j in range(3):
            for k in range(6):
                c = int(M0[i, j, k])
                if not c: continue
                M0w[i][j][k] = M0w[i][j].get(k, 0) + c
                M0w[j][i][sw(k)] = M0w[j][i].get(sw(k), 0) + c
else:
    M0 = M0_of(gseed)
    M0w = [[{k: int(M0[i, j, k]) for k in range(6) if M0[i, j, k]} for j in range(3)] for i in range(3)]
Qj, Ri = nets_from_M0(M0w)
D1 = disc_cubic(Qj); D2 = disc_cubic(Ri)
(S1, T1), (S2, T2) = ST(D1), ST(D2)
print("gseed", gseed, "q", q, "D1 nonzero:", any(D1), "D2 nonzero:", any(D2))
print("S1 T1 S2 T2:", S1, T1, S2, T2)
lhs = pow(S1, 3, q) * pow(T2, 2, q) % q; rhs = pow(S2, 3, q) * pow(T1, 2, q) % q
print("j(D1) == j(D2) (S1^3 T2^2 == S2^3 T1^2):", lhs == rhs)
print("D1 int coeffs (x2^3 normalization irrelevant):", D1 if gseed else '-')
print("D2:", D2 if gseed else '-')
