#!/usr/bin/env python3
"""Independent linear-algebra check of Q2/Q3 over F_p and its extensions.
Reads data_<tag>.txt (parameters, the point a, the planes pi, conic parametrisation) written by inst.m2.
Everything about the cubic is recomputed here from (p, lam, x)."""
import sys, ast, random, itertools
import flint

tag = sys.argv[1]
D = {}
for line in open(f"data_{tag}.txt"):
    k, v = line.split(" = ", 1)
    D[k.strip()] = ast.literal_eval(v.strip())
p = D["p"]; lam = D["lam"] % p; xx = [c % p for c in D["x"][0]]
random.seed(12345)

# ---------- the cubic as a symmetric tensor over F_p ----------
def hval(v):
    return (v[0]**3 + v[1]**3 + v[2]**3 + 3*lam*v[0]*v[1]*v[2]) % p
acoef = (-hval(xx)) * pow(27*(1+lam**3) % p, -1, p) % p
assert acoef == D["acoef"] % p
# monomial dictionary: sorted index triple -> coefficient ; variables 0..2 z, 3..5 p, 6..8 q
mono = {}
def addm(idx, c):
    idx = tuple(sorted(idx)); mono[idx] = (mono.get(idx, 0) + c) % p
for blk, cf in ((0, acoef), (3, 1), (6, 1)):
    for i in range(3): addm((blk+i,)*3, cf)
    addm((blk, blk+1, blk+2), 3*lam*cf)
for i in range(3):
    for j in range(3):
        addm(((i+j) % 3, 3+i, 6+j), xx[(i-j) % 3])
# symmetric tensor T with F(v) = sum T_ijk v_i v_j v_k
inv6 = pow(6, -1, p)
T = {}
for idx, c in mono.items():
    perms = set(itertools.permutations(idx))
    for pm in perms:
        T[pm] = c * pow(len(perms), -1, p) % p
Tlist = list(T.items())

class Fld:
    """arithmetic helper for F_{p^k}"""
    def __init__(self, k):
        self.k = k
        self.ctx = flint.fq_default_ctx(p, k, var='t')
        self.zero = self.ctx(0); self.one = self.ctx(1)
    def __call__(self, c): return self.ctx(c)
    def rand(self): return self.ctx.random_element()

def B3(K, u, v, w):
    """symmetric trilinear form B(u,v,w), F(v)=B(v,v,v)"""
    s = K.zero
    for (i, j, k), c in Tlist:
        s += c * u[i] * v[j] * w[k]
    return s
def Bvec(K, u, v):
    """vector B(u,v,.)"""
    out = [K.zero]*9
    for (i, j, k), c in Tlist:
        out[k] = out[k] + c * u[i] * v[j]
    return out
def Bmat(K, u):
    """matrix B(u,.,.) (= Hessian of F at u divided by 6)"""
    M = [[K.zero]*9 for _ in range(9)]
    for (i, j, k), c in Tlist:
        M[j][k] = M[j][k] + c * u[i]
    return M
def dot(u, v):
    s = u[0]*v[0]
    for i in range(1, len(u)): s += u[i]*v[i]
    return s
def matvec(M, v): return [dot(r, v) for r in M]

def rref(K, M):
    """row reduce (copy). returns (R, pivots)"""
    M = [list(r) for r in M]
    piv = []; r = 0
    ncol = len(M[0]) if M else 0
    for c in range(ncol):
        pr = None
        for i in range(r, len(M)):
            if M[i][c] != K.zero: pr = i; break
        if pr is None: continue
        M[r], M[pr] = M[pr], M[r]
        inv = K.one / M[r][c]
        M[r] = [e*inv for e in M[r]]
        for i in range(len(M)):
            if i != r and M[i][c] != K.zero:
                f = M[i][c]
                M[i] = [ei - f*er for ei, er in zip(M[i], M[r])]
        piv.append(c); r += 1
        if r == len(M): break
    return M[:r], piv
def rank(K, M): return len(rref(K, M)[1]) if M else 0
def nullspace(K, M, ncol):
    """basis of {v : M v = 0}"""
    if not M: 
        return [[K.one if i == j else K.zero for i in range(ncol)] for j in range(ncol)]
    R, piv = rref(K, M)
    free = [c for c in range(ncol) if c not in piv]
    out = []
    for f in free:
        v = [K.zero]*ncol; v[f] = K.one
        for r, c in zip(R, piv): v[c] = -r[f]
        out.append(v)
    return out
def extend_basis(K, rows, n=9):
    """unit vectors completing rows to a basis of K^n"""
    cur = [list(r) for r in rows]; add = []
    rk = rank(K, cur)
    for i in range(n):
        e = [K.one if j == i else K.zero for j in range(n)]
        if rank(K, cur + [e]) > rk:
            cur.append(e); add.append(e); rk += 1
    return add
def det(K, M):
    M = [list(r) for r in M]; n = len(M); d = K.one
    for c in range(n):
        pr = None
        for i in range(c, n):
            if M[i][c] != K.zero: pr = i; break
        if pr is None: return K.zero
        if pr != c: M[c], M[pr] = M[pr], M[c]; d = -d
        d = d * M[c][c]; inv = K.one / M[c][c]
        for i in range(c+1, n):
            if M[i][c] != K.zero:
                f = M[i][c]*inv
                M[i] = [ei - f*ec for ei, ec in zip(M[i], M[c])]
    return d
def span_in_Y(K, rows):
    n = len(rows)
    for i in range(n):
        for j in range(i, n):
            bv = Bvec(K, rows[i], rows[j])
            for k in range(j, n):
                if dot(bv, rows[k]) != K.zero: return False
    return True

def membership(K, a, y):
    """Is there a 4-plane P of Y with a, y in P?  Pure linear algebra:
    P must lie in M_y = {B(a,y,.)=0, B(y,y,.)=0}; modulo <a,y> it is a common 3-dim isotropic subspace of the
    pencil of quadrics B(a,.,.), B(y,.,.) on the 5-dim space U=M_y/<a,y>; then every member has rank<=4 and
    (rank-4 members) P contains the kernel of each member.  Returns (status, P or None, info)."""
    l1 = Bvec(K, a, y); l2 = Bvec(K, y, y)
    if rank(K, [l1, l2]) < 2: return ("degenerate-constraints", None, {})
    My = nullspace(K, [l1, l2], 9)                        # 7 vectors
    assert rank(K, My + [a, y]) == 7
    # complement of <a,y> in My
    comp = []; cur = [a, y]; rk = 2
    for v in My:
        if rank(K, cur + [v]) > rk: cur.append(v); comp.append(v); rk += 1
    assert len(comp) == 5
    Ba = Bmat(K, a); By = Bmat(K, y)
    Ga = [[dot(u, matvec(Ba, w)) for w in comp] for u in comp]
    Gy = [[dot(u, matvec(By, w)) for w in comp] for u in comp]
    kers = []; ranks = []
    cs = [K(c) for c in (0, 1, 2, 3, 5, 7)]
    for c in cs:
        G = [[Ga[i][j] + c*Gy[i][j] for j in range(5)] for i in range(5)]
        r = rank(K, G); ranks.append(r)
        if r == 5: return ("no", None, {"ranks": ranks})
        ns = nullspace(K, G, 5)
        if r == 4: kers.append(ns[0])
    ranksGy = rank(K, Gy)
    if ranksGy == 5: return ("no", None, {"ranks": ranks})
    if len(kers) < 3: return ("degenerate-rank", None, {"ranks": ranks})
    dW = rank(K, kers)
    if dW != 3: return ("degenerate-kernels", None, {"ranks": ranks, "dimW": dW})
    Wb, _ = rref(K, kers)
    W = [[sum((cf*comp[i][j] for i, cf in enumerate(w)), K.zero) for j in range(9)] for w in Wb]
    P = [list(a), list(y)] + W
    if rank(K, P) != 5: return ("degenerate", None, {})
    if span_in_Y(K, P): return ("yes", P, {"ranks": ranks})
    return ("no", None, {"ranks": ranks, "note": "kernel span not in Y"})

def fano_tangent(K, P):
    """Zariski tangent space at P of the scheme of 4-planes of Y through a=P[0].
    Returns (dimension, phi) with phi = list of 4 vectors phi(P[i]) (i=1..4) for a basis element (if dim==1)."""
    N = extend_basis(K, P)                               # 4 vectors
    monos = list(itertools.combinations_with_replacement(range(5), 3))
    mi = {m: i for i, m in enumerate(monos)}
    Mx = [[K.zero]*16 for _ in monos]
    Bkl = {}
    for k in range(5):
        for l in range(5):
            bv = Bvec(K, P[k], P[l])
            for j in range(4): Bkl[(k, l, j)] = dot(bv, N[j])
    for i in range(1, 5):
        for k in range(5):
            for l in range(5):
                row = mi[tuple(sorted((i, k, l)))]
                for j in range(4):
                    Mx[row][(i-1)*4 + j] = Mx[row][(i-1)*4 + j] + Bkl[(k, l, j)]
    ns = nullspace(K, Mx, 16)
    if len(ns) != 1: return (len(ns), None)
    v = ns[0]
    phi = [[sum((v[(i)*4 + j]*N[j][c] for j in range(4)), K.zero) for c in range(9)] for i in range(4)]
    return (1, phi)

# ---------- main ----------
K1 = Fld(1)
a_int = [c % p for c in D["a"][0]]
print(f"== q23.py instance {tag}: p={p} lam={lam} x={xx}")
a1 = [K1(c) for c in a_int]
assert all(e == K1.zero for e in Bvec(K1, a1, a1)), "a is not a singular point of Y"
print("a is a singular point of Y (gradient vanishes): True")

# sanity of the membership test: points on sampled planes through a must test 'yes' and return the same plane; random points of Y cap Q_a 'no'
planes = D["planes"]
ok = 0
for P in planes[:20]:
    Pk = [[K1(c % p) for c in r] for r in P]
    cf = [K1(random.randrange(p)) for _ in range(5)]
    y = [sum((cf[i]*Pk[i][j] for i in range(5)), K1.zero) for j in range(9)]
    st, Pf, info = membership(K1, a1, y)
    if st == "yes" and rank(K1, Pk + Pf) == 5: ok += 1
print(f"sanity: random points of 20 sampled 4-planes through a: membership test returns the same plane in {ok}/20 cases")

ncases = D["ncases"]
for case in range(1, ncases+1):
    piM = [[c % p for c in r] for r in D[f"pi_{case}"]]
    ysc = [[c % p for c in r[0]] for r in D[f"ys_{case}"]]     # coefficients of s^0, s^1, s^2
    yinf = [c % p for c in D[f"yinf_{case}"][0]]
    spol_m2 = [c % p for c in D[f"spol_{case}"]]
    which = "explicit (iota) plane" if D[f"which_{case}"] == 0 else "plane P1 through a second point of A"
    print(f"-- case {case}: pi in the {which}")
    def ypt(K, s):
        return [K(ysc[0][j]) + K(ysc[1][j])*s + K(ysc[2][j])*s*s for j in range(9)]
    # pi in Y, a not on pi, conic
    pik = [[K1(c) for c in r] for r in piM]
    print("   pi contained in Y:", span_in_Y(K1, pik), "; conic Q_a=0 on pi parametrised by s (checked B(a,y,y)=0 at 5 values):",
          all(B3(K1, a1, ypt(K1, K1(s0)), ypt(K1, K1(s0))) == K1.zero for s0 in range(5)))
    # candidates: 9x9 minors of the bordered 11x11 matrix [[lam*B_a+mu*B_y, l1, l2],[l1,0,0],[l2,0,0]] must vanish on Z_a
    npts = 70
    svals = random.sample(range(p), npts)
    Ba1 = Bmat(K1, a1)
    combos = []
    for _ in range(4):
        G1 = [[K1(random.randrange(p)) for _ in range(11)] for _ in range(9)]
        G2 = [[K1(random.randrange(p)) for _ in range(11)] for _ in range(9)]
        cmu = K1(random.randrange(p))
        combos.append((G1, G2, cmu))
    vals = [[] for _ in combos]
    for s0 in svals:
        y = ypt(K1, K1(s0))
        By = Bmat(K1, y); l1 = matvec(Ba1, y); l2 = matvec(By, y)
        for ci, (G1, G2, cmu) in enumerate(combos):
            Bd = [[Ba1[i][j] + cmu*By[i][j] for j in range(9)] + [l1[i], l2[i]] for i in range(9)]
            Bd.append(l1 + [K1.zero, K1.zero]); Bd.append(l2 + [K1.zero, K1.zero])
            M1 = [[dot(G1[i], [Bd[k][j] for k in range(11)]) for j in range(11)] for i in range(9)]
            M2 = [[dot(M1[i], G2[j]) for j in range(9)] for i in range(9)]
            vals[ci].append(int(str(det(K1, M2))))
    polys = []
    for ci in range(len(combos)):
        # Lagrange interpolation over F_p
        pts = [flint.nmod(s0, p) for s0 in svals]
        poly = flint.nmod_poly([0], p)
        X = flint.nmod_poly([0, 1], p)
        basis = flint.nmod_poly([1], p)
        # Newton interpolation
        coeffs = []
        cur = [flint.nmod(v, p) for v in vals[ci]]
        tab = cur[:]
        for j in range(npts):
            coeffs.append(tab[j])
            for i in range(npts-1, j, -1):
                tab[i] = (tab[i] - tab[i-1]) / (pts[i] - pts[i-j-1])
        for j in range(npts):
            poly = poly + basis * int(coeffs[j])
            basis = basis * (X - int(svals[j]))
        polys.append(poly)
    degs = [q.degree() for q in polys]
    g = polys[0]
    for q in polys[1:]: g = g.gcd(q)
    fac = g.factor()[1]
    print(f"   random combinations of 9x9 minors along the conic: degrees {degs} (interpolated from {npts} values); gcd has degree {g.degree()}, factor degrees {sorted((f.degree(), m) for f, m in fac)}")
    # test every root of the gcd (all Galois conjugates) by the membership test, then Q3
    tot_yes = 0; tot_no = 0; other = 0
    yes_factors = flint.nmod_poly([1], p)
    smooth_all = True; transv_all = True; n_checked = 0
    for f, m in fac:
        k = f.degree()
        K = Fld(k)
        fK = flint.fq_default_poly_ctx(K.ctx)([int(c) for c in f.coeffs()])
        rts = [r for r, _ in fK.roots()]
        assert len(rts) == k
        res = []
        for s0 in rts:
            y = ypt(K, s0); a = [K(c) for c in a_int]
            st, P, info = membership(K, a, y)
            if st == "yes":
                tot_yes += 1
                # y is a smooth point of Y ?
                ysm = any(e != K.zero for e in Bvec(K, y, y))
                dimT, phi = fano_tangent(K, P)
                imm = None; tr = None
                if dimT == 1:
                    imm = rank(K, P + [phi[0]])            # 6 <=> scroll map immersive at y
                    pk = [[K(c) for c in r] for r in piM]
                    tr = rank(K, P + [phi[0]] + pk)        # 8 <=> T_yZ_a meets pi only in y
                smooth = (dimT == 1 and imm == 6)
                smooth_all &= smooth; transv_all &= (tr == 8); n_checked += 1
                res.append(("yes", ysm, dimT, imm, tr))
            elif st == "no":
                tot_no += 1; res.append(("no",))
            else:
                other += 1; res.append((st, info))
        if all(r[0] == "yes" for r in res): yes_factors = yes_factors * f
        print(f"     factor of degree {k} (mult {m}): {len(rts)} conjugate roots in F_p^{k}: "
              + "; ".join(sorted(set(
                  (f"ON Z_a (unique 4-plane through a,y found, in Y; y smooth on Y: {r[1]}; dim T(Fano_a)={r[2]}; rank(P+phi(y))={r[3]}; rank(P+phi(y)+pi)={r[4]})" if r[0] == "yes" else f"NOT on Z_a" if r[0] == "no" else f"UNDECIDED {r}")
                  for r in res))))
    # point at s = infinity
    yi = [K1(c) for c in yinf]
    st_inf = membership(K1, a1, yi)[0]
    print(f"   point of the conic at s=infinity on Z_a: {st_inf}")
    # compare with the M2 eliminant
    m2poly = flint.nmod_poly(spol_m2, p)
    same = (m2poly * int(yes_factors.leading_coefficient()) == yes_factors * int(m2poly.leading_coefficient()))
    print(f"   ==> N = #(pi cap Z_a) = {tot_yes + (1 if st_inf == 'yes' else 0)}  (candidates rejected: {tot_no}, undecided: {other});"
          f" Z_a smooth at all of them: {smooth_all}; T_yZ_a cap pi = y at all of them: {transv_all}; points checked: {n_checked}")
    print(f"   product of the verified factors equals the M2 incidence eliminant (degree {m2poly.degree()}): {same}")
    # negative control: random points of the conic
    neg = sum(1 for _ in range(10) if membership(K1, a1, ypt(K1, K1(random.randrange(p))))[0] == "no")
    print(f"   control: 10 random points of the conic: {neg} are not on Z_a")
