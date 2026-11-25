# Independent (non-M2) check of T4: Hilbert function of k[z,p,q]/(9 partials of F, 3 random quadrics)
# by plain linear algebra over GF(p) with python-flint.  Own parameter generation.
import sys, random, itertools
from flint import nmod_mat
P = int(sys.argv[1]); seed = int(sys.argv[2]); mode = sys.argv[3]
random.seed(seed*1000 + P)
N = 9  # variables: z0,z1,z2,p0,p1,p2,q0,q1,q2  -> indices 0..8
def inv(a): return pow(a % P, P-2, P)
def padd(f, g, c=1):
    h = dict(f)
    for m, v in g.items():
        h[m] = (h.get(m, 0) + c*v) % P
        if h[m] == 0: del h[m]
    return h
def pmul(f, g):
    h = {}
    for m1, v1 in f.items():
        for m2, v2 in g.items():
            m = tuple(a+b for a, b in zip(m1, m2))
            h[m] = (h.get(m, 0) + v1*v2) % P
    return {m: v for m, v in h.items() if v}
def var(i):
    e = [0]*N; e[i] = 1; return {tuple(e): 1}
def scal(c, f): return {m: (c*v) % P for m, v in f.items() if (c*v) % P}
def diff(f, i):
    h = {}
    for m, v in f.items():
        if m[i]:
            e = list(m); e[i] -= 1
            h[tuple(e)] = (v*m[i]) % P
    return {m: v for m, v in h.items() if v}
def hc(lam, vs):
    f = {}
    for v in vs: f = padd(f, pmul(v, pmul(v, v)))
    return padd(f, scal(3*lam % P, pmul(vs[0], pmul(vs[1], vs[2]))))
z = [var(i) for i in range(3)]; p = [var(3+i) for i in range(3)]; q = [var(6+i) for i in range(3)]
def hval(lam, x): return (x[0]**3 + x[1]**3 + x[2]**3 + 3*lam*x[0]*x[1]*x[2]) % P
while True:
    x = [random.randrange(1, P) for _ in range(3)]
    if mode == 'coble':
        lam = random.randrange(1, P)
        if (1 + lam**3) % P == 0: continue
        a = (-hval(lam, x) * inv(27*(1+lam**3))) % P
    else:
        lam = (-(x[0]**3+x[1]**3+x[2]**3) * inv(3*x[0]*x[1]*x[2])) % P
        if (1 + lam**3) % P == 0: continue
        a = 0
        assert hval(lam, x) == 0
    break
F = padd(padd(scal(a, hc(lam, z)), hc(lam, p)), hc(lam, q))
for i in range(3):
    for j in range(3):
        F = padd(F, scal(x[(i-j) % 3], pmul(z[(i+j) % 3], pmul(p[i], q[j]))))
def monos(d):
    out = []
    for c in itertools.combinations_with_replacement(range(N), d):
        e = [0]*N
        for i in c: e[i] += 1
        out.append(tuple(e))
    return out
gens = [diff(F, i) for i in range(N)]
quad = monos(2)
for _ in range(3):
    gens.append({m: random.randrange(P) for m in quad})
print("mode", mode, "p", P, "seed", seed, "lam", lam, "x", x, "a", a)
hf = []
for d in range(0, 9):
    md = monos(d); idx = {m: k for k, m in enumerate(md)}
    if d < 2: hf.append(len(md)); continue
    rows = []
    for g in gens:
        for m in monos(d-2):
            pr = pmul(g, {m: 1})
            r = [0]*len(md)
            for mm, v in pr.items(): r[idx[mm]] = v
            rows.append(r)
    rk = nmod_mat(rows, P).rank()
    hf.append(len(md) - rk)
    print(" degree", d, "monomials", len(md), "rank", rk, "HF", len(md)-rk, flush=True)
    if len(md) - rk == 0: break
print("HF:", hf, "total", sum(hf))
