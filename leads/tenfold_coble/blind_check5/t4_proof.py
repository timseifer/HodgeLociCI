"""
T4 for GENERIC x: an exact, deterministic proof over the function field Q(a0,a1,a2) (a = the parameters x).

Idea (all objects explicit; symmetry is only used to choose which elements of the Jacobian ideal to try):
  * V  = monomials of degree 6 in y,p,q of weight 0 for the 27 diagonal symmetries of G_x.
  * columns: L(w') = sum_v c_v dG/dv for explicit vector fields w' = 9*pi(m4 * d/dv), where pi is the projector
    (1/3)(1+sh+sh^2) * (1/3)(2 - t - t^2) * (1/2)(1 - iota) built from three variable permutations sh, t, iota that
    fix G_x for all a (checked below; t is the block rotation y -> p -> q -> y, iota swaps p and q).  Every column is by construction in the Jacobian ideal, with coefficients affine in a.
  * f_d = (P-Q)*m_d (resp. (P+Q)*m_d).
  * choose r columns C and r rows Rw with det B(a*) != 0 at one integer point a* (B = L[Rw,C]).
  * f_d is a Q(a)-combination of the columns C  <=>  for every other row rho the bordered determinant
    det [B, f[Rw]; L[rho,C], f[rho]] vanishes identically.  It is a polynomial of degree <= r in a, so it is zero
    iff it vanishes on the grid {0..r}^3: checked with exact integer determinants (flint fmpz_mat).
  To keep the number of rows small, rows are restricted to a set R0 on which the (constant) subspace
  V_std = pi(V) injects (rank check, exact); all columns and f_d lie in V_std.
"""
import itertools, sys, time, random
import flint

NV = 9
Yv = lambda k: k % 3
Pv = lambda i: 3 + i % 3
Qv = lambda j: 6 + j % 3
# weights for the diagonal symmetries
WT = {}
for k in range(3):
    WT[Yv(k)] = (1, 0, k % 3)
    WT[Pv(k)] = (2, 1, (-k) % 3)
    WT[Qv(k)] = (0, 2, (-k) % 3)


def wt(m):
    return tuple(sum(m[v] * WT[v][t] for v in range(NV)) % 3 for t in range(3))


def monos(deg):
    out = []
    for c in itertools.combinations_with_replacement(range(NV), deg):
        e = [0] * NV
        for v in c:
            e[v] += 1
        out.append(tuple(e))
    return out


# G as dict mono -> (c0, c_a0, c_a1, c_a2)
def addto(d, m, c):
    old = d.get(m, (0, 0, 0, 0))
    new = tuple(old[t] + c[t] for t in range(4))
    if any(new):
        d[m] = new
    else:
        d.pop(m, None)


def unit(v, n=1):
    e = [0] * NV
    e[v] = n
    return tuple(e)


def mmul(m1, m2):
    return tuple(a + b for a, b in zip(m1, m2))


G = {}
for v in range(NV):
    addto(G, unit(v, 3), (1, 0, 0, 0))
mds = [dict(), dict(), dict()]
for i in range(3):
    for j in range(3):
        d = (i - j) % 3
        m = mmul(mmul(unit(Yv(i + j)), unit(Pv(i))), unit(Qv(j)))
        c = [0, 0, 0, 0]
        c[1 + d] = 1
        addto(G, m, tuple(c))
        addto(mds[d], m, (1, 0, 0, 0))
assert all(wt(m) == (0, 0, 0) for m in G)


def deriv(F, v):
    out = {}
    for m, c in F.items():
        if m[v]:
            e = list(m)
            e[v] -= 1
            addto(out, tuple(e), tuple(m[v] * t for t in c))
    return out


dG = [deriv(G, v) for v in range(NV)]

# the two permutations (as substitutions x_v -> x_(s[v]))
sh = [0] * NV
tau = [0] * NV
for k in range(3):
    sh[Yv(k)] = Yv(k + 2); sh[Pv(k)] = Pv(k + 1); sh[Qv(k)] = Qv(k + 1)
    tau[Yv(k)] = Pv(-k); tau[Pv(k)] = Qv(k); tau[Qv(k)] = Yv(-k)


def perm_mono(s, m):
    e = [0] * NV
    for v in range(NV):
        e[s[v]] += m[v]
    return tuple(e)


def perm_poly(s, F):
    out = {}
    for m, c in F.items():
        addto(out, perm_mono(s, m), c)
    return out


assert perm_poly(sh, G) == G and perm_poly(tau, G) == G, "sh / tau do not fix G_x"
compose = lambda s, t: [t[s[v]] for v in range(NV)]
assert compose(sh, tau) == compose(tau, sh)
ident = list(range(NV))
sh2 = compose(sh, sh)
tau2 = compose(tau, tau)
iota = [0] * NV
for k in range(3):
    iota[Yv(k)] = Yv(-k); iota[Pv(k)] = Qv(-k); iota[Qv(k)] = Pv(-k)
assert perm_poly(iota, G) == G, "iota does not fix G_x"
# 18*pi = (1 - iota)(1 + sh + sh^2)(2 - tau - tau^2) as a list of (permutation, integer coefficient)
proj = []
for u, cu in ((ident, 1), (iota, -1)):
    for s in (ident, sh, sh2):
        for t, c in ((ident, 2), (tau, -1), (tau2, -1)):
            proj.append((compose(compose(t, s), u), c * cu))
PROJ_SCALE = 18

V = [m for m in monos(6) if wt(m) == (0, 0, 0)]
Vidx = {m: i for i, m in enumerate(V)}
print("weight-0 sextics:", len(V))

# vector fields m4 * d/dv of weight 0:  wt(m4) = wt(x_v)
W = [(m4, v) for v in range(NV) for m4 in monos(4) if wt(m4) == wt(unit(v))]
print("weight-0 vector fields of degree 4:", len(W))


def L_of_field(field):
    """field: dict (m4, v) -> integer ; returns sum coeff * m4 * dG/dv as dict mono -> 4-vector"""
    out = {}
    for (m4, v), c in field.items():
        for m, cc in dG[v].items():
            addto(out, mmul(m4, m), tuple(c * t for t in cc))
    return out


def project_field(m4, v):
    out = {}
    for s, c in proj:
        key = (perm_mono(s, m4), s[v])     # g.(m4 d/dv) = (g m4) d/d(g v)
        out[key] = out.get(key, 0) + c
    return {k: c for k, c in out.items() if c}


cols = []
seen = set()
for (m4, v) in W:
    fld = project_field(m4, v)
    if not fld:
        continue
    key = tuple(sorted(fld.items()))
    neg = tuple(sorted((k, -c) for k, c in fld.items()))
    if key in seen or neg in seen:
        continue
    seen.add(key)
    col = L_of_field(fld)
    assert all(m in Vidx for m in col)
    cols.append(col)
print("distinct symmetrised vector fields:", len(cols))


def poly_mul(F, H):
    out = {}
    for m1, c1 in F.items():
        for m2, c2 in H.items():
            assert c1[1:] == (0, 0, 0) or c2[1:] == (0, 0, 0)
            if c2[1:] == (0, 0, 0):
                addto(out, mmul(m1, m2), tuple(c2[0] * t for t in c1))
            else:
                addto(out, mmul(m1, m2), tuple(c1[0] * t for t in c2))
    return out


Pm = {mmul(mmul(unit(3), unit(4)), unit(5)): (1, 0, 0, 0)}
Qm = {mmul(mmul(unit(6), unit(7)), unit(8)): (1, 0, 0, 0)}
PmQ = dict(Pm); addto(PmQ, list(Qm)[0], (-1, 0, 0, 0))
PpQ = dict(Pm); addto(PpQ, list(Qm)[0], (1, 0, 0, 0))
targets = {}
for d in range(3):
    targets[f"(P-Q)*m_{d}"] = poly_mul(PmQ, mds[d])
PpQm = {f"(P+Q)*m_{d}": poly_mul(PpQ, mds[d]) for d in range(3)}
import os
if os.environ.get("CONTROL") == "1":
    # negative control: an element of the same isotypic piece that should NOT be in the Jacobian ideal
    YPQ = {mmul(mmul(unit(0), unit(1)), unit(2)): (1, 0, 0, 0)}
    YPQ.update(Pm); YPQ.update(Qm)
    targets = {"CONTROL (P-Q)*(Y+P+Q)": poly_mul(PmQ, YPQ)}
    PpQm = {}

# ---- the constant subspace V_std = image of 9*pi on V; rows R0 on which it injects ----
def project_mono(m):
    out = {}
    for s, c in proj:
        mm = perm_mono(s, m)
        out[mm] = out.get(mm, 0) + c
    return out


PIrows = []
for m in V:
    img = project_mono(m)
    row = [0] * len(V)
    for mm, c in img.items():
        row[Vidx[mm]] = c
    PIrows.append(row)          # row i = pi(V_i) written in the basis V
PI = flint.fmpq_mat(len(V), len(V), [flint.fmpq(t) for r in PIrows for t in r])
rk = PI.rank()
print("dim V_std =", rk)
# pivot coordinates: rref of PI (rows span V_std); pivot columns = coordinates R0 on which V_std injects
PIr, _ = PI.rref()
R0 = []
for i in range(rk):
    for j in range(len(V)):
        if PIr[i, j] != 0:
            R0.append(j)
            break
assert len(R0) == rk
sub = flint.fmpq_mat(rk, rk, [PIr[i, j] for i in range(rk) for j in R0])
assert sub.rank() == rk
# check the targets with P-Q are in V_std (pi f = f, i.e. 9 pi f = 9 f); the P+Q targets are NOT in V_std
for name, f in list(targets.items()) + list(PpQm.items()):
    pf = {}
    for m, c in f.items():
        for mm, cc in project_mono(m).items():
            addto(pf, mm, tuple(cc * t for t in c))
    nine_f = {m: tuple(PROJ_SCALE * t for t in c) for m, c in f.items()}
    print(f"   {name} in V_std: {pf == nine_f}")


def ev(c, a):
    return c[0] + c[1] * a[0] + c[2] * a[1] + c[3] * a[2]


def col_at(col, a, rows):
    return [ev(col.get(V[i], (0, 0, 0, 0)), a) for i in rows]


# ---- pivots at a random integer point ----
rng = random.Random(4)
astar = (rng.randrange(5, 60), rng.randrange(-60, -5), rng.randrange(61, 120))
Mstar = flint.fmpq_mat(rk, len(cols), [flint.fmpq(t) for i in R0 for t in [ev(c.get(V[i], (0, 0, 0, 0)), astar) for c in cols]])
r = Mstar.rank()
Mr, _ = Mstar.rref()
C = []
for i in range(r):
    for j in range(len(cols)):
        if Mr[i, j] != 0:
            C.append(j)
            break
MT = flint.fmpq_mat(r, rk, [flint.fmpq(ev(cols[j].get(V[i], (0, 0, 0, 0)), astar)) for j in C for i in R0])
MTr, _ = MT.rref()
Rw = []
for i in range(r):
    for j in range(rk):
        if MTr[i, j] != 0:
            Rw.append(R0[j])
            break
rest = [i for i in R0 if i not in Rw]
Bstar = flint.fmpz_mat(r, r, [ev(cols[j].get(V[i], (0, 0, 0, 0)), astar) for i in Rw for j in C])
print(f"a* = {astar}: rank of the symmetrised block = {r}; det B(a*) != 0: {Bstar.det() != 0}; rows left to test: {len(rest)}")
assert Bstar.det() != 0

# ---- grid test ----
import numpy as np
rows_all = Rw + rest
A = [np.array([[cols[j].get(V[i], (0, 0, 0, 0))[t] for j in C] for i in rows_all], dtype=object) for t in range(4)]
Fv = {name: np.array([f.get(V[i], (0, 0, 0, 0))[0] for i in rows_all], dtype=object) for name, f in targets.items()}
for name, f in targets.items():
    assert all(c[1:] == (0, 0, 0) for c in f.values())
A64 = [a_.astype(np.int64) for a_ in A]
F64 = {k_: v_.astype(np.int64) for k_, v_ in Fv.items()}
grid = range(0, r + 1)
t0 = time.time()
status = {name: True for name in targets}
fail_example = {}
npts = 0
nd = 0
for a in itertools.product(grid, repeat=3):
    npts += 1
    Mx = A64[0] + a[0] * A64[1] + a[1] * A64[2] + a[2] * A64[3]
    for t in range(len(rest)):
        sel = list(range(r)) + [r + t]
        base = Mx[sel, :]
        for name in targets:
            if not status[name]:
                continue
            mat = np.hstack([base, F64[name][sel].reshape(-1, 1)])
            dt = flint.fmpz_mat(mat.tolist()).det()
            nd += 1
            if dt != 0:
                status[name] = False
                fail_example[name] = a
print(f"grid {{0..{r}}}^3 = {npts} points, {nd} exact integer determinants of size {r+1}, {time.time()-t0:.0f} s")
for name in targets:
    if status[name]:
        print(f"   {name}: ALL bordered determinants vanish on the grid  ==> in Jac(G_x) over Q(a0,a1,a2) (EXACT, generic x)")
    else:
        print(f"   {name}: a bordered determinant is nonzero at a = {fail_example[name]}")
# sanity: at two random rational points, solve B c = f[Rw] and check f = sum c_j col_j on ALL rows of V
for trial in range(2):
    a = (flint.fmpq(rng.randrange(-50, 50), rng.randrange(1, 20)), flint.fmpq(rng.randrange(-50, 50), rng.randrange(1, 20)),
         flint.fmpq(rng.randrange(-50, 50), rng.randrange(1, 20)))
    evq = lambda c: c[0] + c[1] * a[0] + c[2] * a[1] + c[3] * a[2]
    B = flint.fmpq_mat(r, r, [evq(cols[j].get(V[i], (0, 0, 0, 0))) for i in Rw for j in C])
    full = flint.fmpq_mat(len(V), r, [evq(cols[j].get(V[i], (0, 0, 0, 0))) for i in range(len(V)) for j in C])
    oks = []
    for name, f in targets.items():
        rhs = flint.fmpq_mat(r, 1, [flint.fmpq(f.get(V[i], (0, 0, 0, 0))[0]) for i in Rw])
        c = B.solve(rhs)
        fv = flint.fmpq_mat(len(V), 1, [flint.fmpq(f.get(V[i], (0, 0, 0, 0))[0]) for i in range(len(V))])
        oks.append(full * c == fv)
    print(f"   sanity at a = {a}: f = L[:,C] B^-1 f[Rw] on all {len(V)} rows: {oks}")
