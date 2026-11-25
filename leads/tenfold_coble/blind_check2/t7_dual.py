# T7 (second-order test E2): independent "dual" implementation in Python (numpy / scipy.sparse / python-flint).
# No engine file is used.  Reads an instance exported by t7.m2 (so that a few values can be cross-checked
# against the M2 primal division), or generates its own instance with --own P SEED.
#
# Mathematics.  S = k[z,p,q,w], T = k[z,p,q], F = F8 + sum_k w_k G_k.
#   D0_j = (dF/dx_j)|_{w=0}  (j = 0..11),   D1_{l,j} = coefficient of w_l in dF/dx_j   (linear forms in T)
#   JT = (D0_0..D0_11) in T.   (T/JT)_6 is one-dimensional, (T/JT)_d = 0 for d >= 7.
#   pi  : functional on T_6 with kernel (JT)_6  (pi kills (w)).
#   psi : functional on S_9 with psi((w)^2 S_7) = 0 and psi(sum_j B_j dF/dx_j) = (1/6) pi(sum_j dB_j/dx_j).
# Write psi(P0 + sum_l w_l P_l) = Psi0(P0) + sum_l Psi_l(P_l).  Taking B = w_l v e_j and B = v e_j gives
#   Psi_l(v D0_j) = (1/6) pi(v) [j == 9+l]                                   (v in T_6)
#   Psi0(v D0_j)  = (1/6) pi(dv/dx_j) [j <= 8]  -  sum_l Psi_l(v D1_{l,j})   (v in T_7)
# Since T_7 = sum_j D0_j T_5, these determine Psi_l on T_8 = T_1*T_7 and Psi0 on T_9 = T_2*T_7:
# for a fixed multiplier mu the vector y[m7] = Psi(mu*m7) solves  M^T y = theta,  M = degree-7 Macaulay matrix.
# The system is overdetermined (15444 equations, 6435 unknowns); it is solved through (M D M^T) y = M D theta
# with a random diagonal D and then ALL 15444 equations are verified, and different factorisations
# mu*m7 = mu'*m7' of the same monomial are checked to give the same value (well-definedness).
import sys, ast, itertools, time, random
import numpy as np
import scipy.sparse as sp
from flint import nmod_mat

t_start = time.time()
NV = 9
BASE = 16
POW = np.array([BASE**i for i in range(NV)], dtype=np.int64)

def parse_instance(fn):
    d = {}
    for line in open(fn):
        if ' = ' not in line: continue
        k, v = line.split(' = ', 1)
        d[k.strip()] = ast.literal_eval(v.strip().replace('{', '[').replace('}', ']'))
    return d

def own_instance(P, seed):
    rnd = random.Random(seed * 7919 + P)
    inv = lambda a: pow(a % P, P - 2, P)
    def padd(f, g, c=1):
        h = dict(f)
        for m, v in g.items():
            h[m] = (h.get(m, 0) + c * v) % P
        return {m: v for m, v in h.items() if v}
    def pmul(f, g):
        h = {}
        for m1, v1 in f.items():
            for m2, v2 in g.items():
                m = tuple(a + b for a, b in zip(m1, m2))
                h[m] = (h.get(m, 0) + v1 * v2) % P
        return {m: v for m, v in h.items() if v}
    def var(i):
        e = [0] * NV; e[i] = 1; return {tuple(e): 1}
    def scal(c, f): return {m: (c * v) % P for m, v in f.items() if (c * v) % P}
    def diff(f, i):
        h = {}
        for m, v in f.items():
            if m[i]:
                e = list(m); e[i] -= 1
                h[tuple(e)] = (h.get(tuple(e), 0) + v * m[i]) % P
        return {m: v for m, v in h.items() if v}
    def hc(lam, vs):
        f = {}
        for v in vs: f = padd(f, pmul(v, pmul(v, v)))
        return padd(f, scal(3 * lam % P, pmul(vs[0], pmul(vs[1], vs[2]))))
    def Mx(x, z, p, q):
        f = {}
        for i in range(3):
            for j in range(3):
                f = padd(f, scal(x[(i - j) % 3], pmul(z[(i + j) % 3], pmul(p[i], q[j]))))
        return f
    z = [var(i) for i in range(3)]; p = [var(3 + i) for i in range(3)]; q = [var(6 + i) for i in range(3)]
    while True:
        x = [rnd.randrange(1, P) for _ in range(3)]
        lam = (-(x[0]**3 + x[1]**3 + x[2]**3) * inv(3 * x[0] * x[1] * x[2])) % P
        if (1 + lam**3) % P: break
    assert (x[0]**3 + x[1]**3 + x[2]**3 + 3 * lam * x[0] * x[1] * x[2]) % P == 0
    F8 = padd(padd(hc(lam, p), hc(lam, q)), Mx(x, z, p, q))
    dx = [rnd.randrange(1, P) for _ in range(3)]
    den = 27 * (1 + lam**3) % P
    c1 = (3 * x[0]**2 * dx[0] + 3 * x[1]**2 * dx[1] + 3 * x[2]**2 * dx[2]
          + 3 * lam * (dx[0] * x[1] * x[2] + x[0] * dx[1] * x[2] + x[0] * x[1] * dx[2])) % P
    c2 = (3 * x[0] * dx[0]**2 + 3 * x[1] * dx[1]**2 + 3 * x[2] * dx[2]**2
          + 3 * lam * (x[0] * dx[1] * dx[2] + dx[0] * x[1] * dx[2] + dx[0] * dx[1] * x[2])) % P
    a1 = (-c1 * inv(den)) % P; a2 = (-c2 * inv(den)) % P
    hz = hc(lam, z)
    A = padd(Mx(dx, z, p, q), scal(a1, hz))
    quad = [m for m in itertools.product(range(3), repeat=NV) if sum(m) == 2]
    lin = [m for m in itertools.product(range(2), repeat=NV) if sum(m) == 1]
    G0 = [{m: rnd.randrange(P) for m in quad} for _ in range(3)]            # G_k at w = 0
    L = [[{m: rnd.randrange(P) for m in lin} for _ in range(3)] for _ in range(3)]  # L[k][l] = coeff of w_l in G_k
    d = {'p': P, 'seed': seed, 'lam': lam, 'x': x, 'dx': dx, 'a1': a1, 'a2': a2}
    tolist = lambda f: [(list(m), v) for m, v in f.items()]
    d['F8'] = tolist(F8); d['A'] = tolist(A); d['hz'] = tolist(hz); d['mstd'] = None
    for j in range(9): d['D0_%d' % j] = tolist(diff(F8, j))
    for k in range(3): d['D0_%d' % (9 + k)] = tolist(G0[k])
    for l in range(3):
        for j in range(9): d['D1_%d_%d' % (l, j)] = tolist(diff(G0[l], j))
        for k in range(3): d['D1_%d_%d' % (l, 9 + k)] = tolist(padd(L[k][l], L[l][k]))
    I0 = [diff(F8, 0), diff(F8, 1), diff(F8, 2), hc(lam, p), hc(lam, q)]
    for i in range(5): d['I0_%d' % i] = tolist(I0[i])
    return d

if sys.argv[1] == '--own':
    inst = own_instance(int(sys.argv[2]), int(sys.argv[3]))
    tag = 'own_%s_%s' % (sys.argv[2], sys.argv[3])
else:
    inst = parse_instance(sys.argv[1]); tag = sys.argv[1]
P = inst['p']
inv6 = pow(6, P - 2, P)
print('T7-dual instance', tag, 'p =', P, 'lam =', inst['lam'] % P, 'x =', [v % P for v in inst['x']],
      'dx =', [v % P for v in inst['dx']], 'a1 =', inst['a1'] % P, 'a2 =', inst['a2'] % P, flush=True)

# ---------- monomials ----------
def monos(d):
    out = []
    def rec(i, left, cur):
        if i == NV - 1:
            out.append(cur + [left]); return
        for e in range(left, -1, -1):
            rec(i + 1, left - e, cur + [e])
    rec(0, d, [])
    return np.array(out, dtype=np.int64)
EXPS, CODES = {}, {}
for d in range(0, 10):
    E = monos(d); c = E @ POW
    o = np.argsort(c)
    EXPS[d] = E[o]; CODES[d] = c[o]
def lookup(d, codes):
    i = np.searchsorted(CODES[d], codes)
    assert np.all(CODES[d][i] == codes)
    return i
def poly(lst):   # -> (codes, coefs, degree)
    ex = np.array([t[0] for t in lst], dtype=np.int64).reshape(-1, NV)
    cf = np.array([t[1] % P for t in lst], dtype=np.int64)
    return ex @ POW, cf, int(ex[0].sum())
def pmulP(f, g):
    cf = {}
    for c1, v1 in zip(*f[:2]):
        for c2, v2 in zip(*g[:2]):
            cf[c1 + c2] = (cf.get(c1 + c2, 0) + int(v1) * int(v2)) % P
    ks = [k for k, v in cf.items() if v]
    return np.array(ks, dtype=np.int64), np.array([cf[k] for k in ks], dtype=np.int64), f[2] + g[2]
def apply_fun(vec, d, f, mult_codes):
    """values of the functional vec (on monomials of degree d) on mult*f for every monomial code in mult_codes"""
    fc, fv, _ = f
    out = np.zeros(len(mult_codes), dtype=np.int64)
    for c, v in zip(fc, fv):
        out = (out + int(v) * vec[lookup(d, mult_codes + c)]) % P
    return out

D0 = [poly(inst['D0_%d' % j]) for j in range(12)]
D1 = [[poly(inst['D1_%d_%d' % (l, j)]) if inst['D1_%d_%d' % (l, j)] else (np.zeros(0, np.int64), np.zeros(0, np.int64), 1)
       for j in range(12)] for l in range(3)]
Apoly = poly(inst['A']); hz = poly(inst['hz'])
I0 = [poly(inst['I0_%d' % i]) for i in range(5)]
XC = [int(POW[i]) for i in range(NV)]     # codes of the variables

def macaulay(d):
    """sparse matrix, rows = monomials of degree d, columns = (j, m) with m of degree d-2; entry = coeff of row monomial in m*D0_j"""
    n_in = len(CODES[d - 2]); rows, cols, vals = [], [], []
    for j in range(12):
        fc, fv, _ = D0[j]
        for c, v in zip(fc, fv):
            rows.append(lookup(d, CODES[d - 2] + c)); cols.append(j * n_in + np.arange(n_in)); vals.append(np.full(n_in, v))
    M = sp.coo_matrix((np.concatenate(vals), (np.concatenate(rows), np.concatenate(cols))),
                      shape=(len(CODES[d]), 12 * n_in), dtype=np.int64).tocsr()
    M.sum_duplicates(); M.data %= P
    return M

# ---------- pi on T_6 ----------
M6 = macaulay(6)
A6 = nmod_mat(M6.shape[1], M6.shape[0], P)
M6c = M6.tocoo()
for r, c, v in zip(M6c.row.tolist(), M6c.col.tolist(), M6c.data.tolist()):
    A6[c, r] = v
X, nullity = A6.nullspace()
print('pi: rank of (JT)_6 =', len(CODES[6]) - nullity, 'of', len(CODES[6]), '-> dim (T/JT)_6 =', nullity, flush=True)
assert nullity == 1
pi = np.array([int(X[i, 0]) for i in range(len(CODES[6]))], dtype=np.int64)
if inst.get('mstd'):
    ms = poly(inst['mstd']); k = lookup(6, ms[0])[0]
    assert pi[k] != 0
    pi = (pi * pow(int(pi[k]), P - 2, P)) % P        # same normalisation as the M2 script: pi(mstd) = 1
assert not np.any((M6.T @ pi) % P)
# pi kills I0 (ideal of V in T)
bad = 0
for g in I0:
    bad += int(np.count_nonzero(apply_fun(pi, 6, g, CODES[6 - g[2]])))
print('pi vanishes on (I_V)_6 (all generator*monomial products)?', bad == 0, flush=True)
# first-order condition
fo = apply_fun(pi, 6, Apoly, CODES[3])
print('first-order condition pi(Q*A) = 0 for all 165 cubic monomials Q in z,p,q?', not np.any(fo), flush=True)

# ---------- degree-7 solver ----------
M7 = macaulay(7)
n7, n5 = len(CODES[7]), len(CODES[5])
rng = np.random.default_rng(12345)
while True:
    dd = rng.integers(1, P, size=M7.shape[1])
    MD = M7.multiply(dd.reshape(1, -1)).tocsr(); MD.data %= P
    Nm = (MD @ M7.T).tocoo(); Nm.data %= P
    Nf = nmod_mat(n7, n7, P)
    for r, c, v in zip(Nm.row.tolist(), Nm.col.tolist(), Nm.data.tolist()):
        if v: Nf[r, c] = v
    print('normal matrix M D M^T: size', n7, 'nnz', Nm.nnz, ' built at t=%.1fs' % (time.time() - t_start), flush=True)
    del Nm
    try:
        Ninv = Nf.inv()
        break
    except ZeroDivisionError:
        print('normal matrix singular, re-randomising D', flush=True)
print('inverse computed at t=%.1fs' % (time.time() - t_start), flush=True)
del Nf
def solve(Theta):
    """Theta: (12*n5) x r integer array.  Returns Y (n7 x r) with M7^T Y = Theta, verifying all equations."""
    B = (MD @ Theta) % P
    Bf = nmod_mat(B.shape[0], B.shape[1], [int(v) for v in B.ravel()], P)
    Yf = Ninv * Bf
    Y = np.array([int(v) for v in Yf.entries()], dtype=np.int64).reshape(B.shape)
    resid = (M7.T @ Y - Theta) % P
    nbad = int(np.count_nonzero(resid))
    return Y, nbad

# ---------- phase 1: Psi_l on T_8 ----------
Theta1 = np.zeros((12 * n5, 27), dtype=np.int64)
for l in range(3):
    for i in range(NV):
        Theta1[(9 + l) * n5:(10 + l) * n5, l * NV + i] = (inv6 * pi[lookup(6, CODES[5] + XC[i])]) % P
Y1, nbad1 = solve(Theta1)
print('phase 1 (Psi_l on T_8): equations violated: %d of %d' % (nbad1, Theta1.size), flush=True)
Psi = np.full((3, len(CODES[8])), -1, dtype=np.int64)
incons1 = 0
for l in range(3):
    for i in range(NV):
        tgt = lookup(8, CODES[7] + XC[i]); val = Y1[:, l * NV + i]
        seen = Psi[l, tgt] >= 0
        incons1 += int(np.count_nonzero(Psi[l, tgt][seen] != val[seen]))
        Psi[l, tgt] = val
assert np.all(Psi >= 0)
print('phase 1: inconsistencies between different factorisations x_i*m7 of the same degree-8 monomial:', incons1, flush=True)

# ---------- phase 2: Psi0 on T_9 ----------
ThetaJ = np.zeros((12, n7), dtype=np.int64)
E7 = EXPS[7]
for j in range(12):
    acc = np.zeros(n7, dtype=np.int64)
    if j < 9:
        has = E7[:, j] > 0
        acc[has] = (inv6 * E7[has, j] % P) * pi[lookup(6, CODES[7][has] - XC[j])] % P
    for l in range(3):
        fc, fv, _ = D1[l][j]
        for c, v in zip(fc, fv):
            acc = (acc - int(v) * Psi[l, lookup(8, CODES[7] + c)]) % P
    ThetaJ[j] = acc
mu = CODES[2]
Theta2 = np.zeros((12 * n5, len(mu)), dtype=np.int64)
for a, m in enumerate(mu):
    ii = lookup(7, CODES[5] + m)
    for j in range(12):
        Theta2[j * n5:(j + 1) * n5, a] = ThetaJ[j, ii]
Y2, nbad2 = solve(Theta2)
print('phase 2 (Psi0 on T_9): equations violated: %d of %d' % (nbad2, Theta2.size), flush=True)
Psi0 = np.full(len(CODES[9]), -1, dtype=np.int64)
incons2 = 0
for a, m in enumerate(mu):
    tgt = lookup(9, CODES[7] + m); val = Y2[:, a]
    seen = Psi0[tgt] >= 0
    incons2 += int(np.count_nonzero(Psi0[tgt][seen] != val[seen]))
    Psi0[tgt] = val
assert np.all(Psi0 >= 0)
print('phase 2: inconsistencies between different factorisations mu*m7 of the same degree-9 monomial:', incons2, flush=True)
print('functionals built at t=%.1fs' % (time.time() - t_start), flush=True)

# ---------- E2 ----------
a2 = inst['a2'] % P
A2 = pmulP(Apoly, Apoly)
Q3 = CODES[3]; Q2 = CODES[2]
psiA = apply_fun(Psi0, 9, A2, Q3)             # psi(Q A^2), Q in T_3
piQh = apply_fun(pi, 6, hz, Q3)               # pi(Q h_lam(z))
lhs = (a2 * piQh) % P; rhs = (3 * psiA) % P
print('#Q (w-degree 0, of 165) with pi(Q h(z)) != 0:', int(np.count_nonzero(piQh)), '; with psi(Q A^2) != 0:', int(np.count_nonzero(psiA)))
print('E2, w-degree 0: pi(Q*a2*h(z)) == 3 psi(Q A^2):  agree on %d of 165 cubic monomials Q' % int(np.count_nonzero(lhs == rhs)))
print('   with 2*a2 in place of a2: agree on %d of 165;  with 0 in place of a2: agree on %d of 165'
      % (int(np.count_nonzero((2 * lhs) % P == rhs)), int(np.count_nonzero(rhs == 0))))
nz = piQh != 0
rat = set(int(r) * pow(int(q), P - 2, P) % P for r, q in zip(rhs[nz], piQh[nz]))
print('   distinct values of 3 psi(Q A^2)/pi(Q h(z)) where the denominator is nonzero:', sorted(rat), ' (a2 = %d, 2*a2 = %d)' % (a2, 2 * a2 % P))
tot1 = 0
for m in range(3):
    v = apply_fun(Psi[m], 8, A2, Q2)          # psi(w_m Q' A^2)
    tot1 += int(np.count_nonzero(v == 0))
print('E2, w-degree 1: psi(w_m Q\' A^2) == 0 (= pi(w_m Q\' g2)/3):  agree on %d of 135 monomials Q = w_m Q\'' % tot1)
print('E2, w-degree >= 2: 64 monomials, both sides are 0 by construction (Q A^2 in (w)^2, Q g2 in (w))')

# ---------- consistency with "psi vanishes on I^2" beyond (w)^2 ----------
cnt = 0; tot = 0
for a in range(5):
    for b in range(a, 5):
        g = pmulP(I0[a], I0[b])
        v = apply_fun(Psi0, 9, g, CODES[9 - g[2]]); cnt += int(np.count_nonzero(v)); tot += len(v)
print('psi on (I_V^2)_9, w-degree 0 part: nonzero on %d of %d generator*monomial products' % (cnt, tot))
cnt = 0; tot = 0
for l in range(3):
    for g in I0:
        v = apply_fun(Psi[l], 8, g, CODES[8 - g[2]]); cnt += int(np.count_nonzero(v)); tot += len(v)
print('psi on w_l*(I_V)_8 (w-degree 1 part of I^2): nonzero on %d of %d products' % (cnt, tot))
# controls
cnt = 0; tot = 0
for g in I0:
    v = apply_fun(Psi0, 9, g, CODES[9 - g[2]]); cnt += int(np.count_nonzero(v)); tot += len(v)
print('control: psi on (I_V)_9 (first power only): nonzero on %d of %d products' % (cnt, tot))
print('control: Psi0 nonzero on %d of %d degree-9 monomials; Psi_l nonzero on %s of %d degree-8 monomials'
      % (int(np.count_nonzero(Psi0)), len(Psi0), [int(np.count_nonzero(Psi[l])) for l in range(3)], Psi.shape[1]))

# ---------- values for cross-check against the M2 primal division ----------
if len(sys.argv) > 2 and sys.argv[1] != '--own':
    out = open(sys.argv[2], 'w')
    for c, e in zip(CODES[3], EXPS[3]):
        k = lookup(3, np.array([c]))[0]
        out.write('W0 %s %d %d\n' % (' '.join(map(str, e)), psiA[k], piQh[k]))
    for m in range(3):
        v = apply_fun(Psi[m], 8, A2, Q2)
        for c, e, val in zip(CODES[2], EXPS[2], v):
            out.write('W1 %d %s %d\n' % (m, ' '.join(map(str, e)), val))
    out.close()
print('total time %.1fs' % (time.time() - t_start))
