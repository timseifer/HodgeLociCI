# EXACT (over Z[z], z^2 = z - 1, z a primitive 6th root of unity) verification that
#   L . TVZ = 0  and  L . TCone = 0  (L = first-order map of [P1] + lam [P2]),
# so that dim ker L >= rank_{mod p}[TVZ | TCone] = 326 over Q(z), i.e. rank L <= 38; together with
# rank (L mod p) = 38 (reduction can only drop rank) this gives rank_{Q(z)} L = 38 exactly.
import sys, itertools, numpy as np
sys.path.insert(0, '/home/claude/hodge/discovery/checks/bc_t6')
from hl import cubic_monos, rank
# Z[z] elements as (a, b) meaning a + b z
def zmul(x, y):
    a, b = x; c, d = y
    return (a * c - b * d, a * d + b * c + b * d)
def zpow(x, n):
    r = (1, 0)
    for _ in range(n): r = zmul(r, x)
    return r
Z = (0, 1); ZB = (1, -1)  # z^5 = conj(z) = 1 - z
def A(a):
    r, q = a % 3, a // 3; v = 1
    for s in range(1, q + 1): v *= (r + 1 + 3 * (s - 1))
    return v
def phi(beta, ws):
    val = (1, 0)
    for e in range(6):
        a, b = beta[2 * e], beta[2 * e + 1]
        if (a % 3, b % 3) not in ((1, 0), (0, 1)): return (0, 0)
        val = zmul(val, zmul((A(a) * A(b), 0), zpow(ws[e], (a % 3) + 1)))
    return val
W1 = [Z] * 6; W2 = [Z, Z, Z, ZB, ZB, ZB]
CUB = cubic_monos(); idx = {c: i for i, c in enumerate(CUB)}
n = len(CUB)
# polynomials: dict monomial-tuple -> Z[z]
def padd(f, g):
    h = dict(f)
    for k, v in g.items():
        a = h.get(k, (0, 0)); h[k] = (a[0] + v[0], a[1] + v[1])
    return {k: v for k, v in h.items() if v != (0, 0)}
def pmul(f, g):
    h = {}
    for k1, v1 in f.items():
        for k2, v2 in g.items():
            k = tuple(a + b for a, b in zip(k1, k2)); m = zmul(v1, v2)
            a = h.get(k, (0, 0)); h[k] = (a[0] + m[0], a[1] + m[1])
    return {k: v for k, v in h.items() if v != (0, 0)}
def var(i, c=(1, 0)):
    b = [0] * 12; b[i] = 1; return {tuple(b): c}
def lin(d):
    f = {}
    for i, c in d.items(): f = padd(f, var(i, c))
    return f
u = [lin({2 * e: (1, 0), 2 * e + 1: (0, -1)}) for e in range(6)]          # x - z y
vv = {e: lin({2 * e: (1, 0), 2 * e + 1: (-1, 1)}) for e in range(3, 6)}   # x - zb y = x - (1-z) y
X = [var(i) for i in range(12)]
quads = [pmul(X[i], X[j]) for i in range(12) for j in range(i, 12)]
def vec(f):
    va = np.zeros(n, dtype=object); vb = np.zeros(n, dtype=object)
    va[:] = 0; vb[:] = 0
    for k, (a, b) in f.items(): va[idx[k]] = a; vb[idx[k]] = b
    return va, vb
for lam in (-1, 2):
    La = np.zeros((n, n), dtype=object); Lb = np.zeros((n, n), dtype=object)
    for i, P in enumerate(CUB):
        for j, Q in enumerate(CUB):
            beta = tuple(a + b for a, b in zip(P, Q))
            v1 = phi(beta, W1); v2 = phi(beta, W2)
            La[i, j] = v1[0] + lam * v2[0]; Lb[i, j] = v1[1] + lam * v2[1]
    gens = []
    gens += [pmul(X[j], pmul(X[i], X[i])) for i in range(12) for j in range(12)]   # J_3
    gens += [pmul(u[i], q) for i in range(3) for q in quads]                       # (u0,u1,u2)_3
    gensV = gens + [pmul(pmul(u[e], vv[f]), xx) for e in range(3, 6) for f in range(3, 6) for xx in X]
    # T_Y: kernel of the fourfold functional on cubics in x6..x11 (exact basis)
    cub6 = []
    for c in itertools.combinations_with_replacement(range(6, 12), 3):
        b = [0] * 12
        for i in c: b[i] += 1
        cub6.append(tuple(b))
    def phiY(b):
        r = (0, 0)
        for ws, l in ((W1, 1), (W2, lam)):
            val = (1, 0); ok = True
            for e in range(3, 6):
                a_, b_ = b[2 * e], b[2 * e + 1]
                if (a_ % 3, b_ % 3) not in ((1, 0), (0, 1)): ok = False; break
                val = zmul(val, zmul((A(a_) * A(b_), 0), zpow(ws[e], (a_ % 3) + 1)))
            if ok: r = (r[0] + l * val[0], r[1] + l * val[1])
        return r
    ph = [phiY(b) for b in cub6]
    i0 = next(i for i, v in enumerate(ph) if v != (0, 0))
    TY = []
    for i, b in enumerate(cub6):
        if i == i0: continue
        if ph[i] == (0, 0): TY.append({b: (1, 0)})
        else:
            TY.append(padd({b: ph[i0]}, {cub6[i0]: zmul((-1, 0), ph[i])}))
    gensC = gens + TY
    ok = True
    for name, G in (("TVZ", gensV), ("TCone", gensC)):
        Ga = np.array([vec(g)[0] for g in G]).T; Gb = np.array([vec(g)[1] for g in G]).T
        Pa = La.dot(Ga) - Lb.dot(Gb); Pb = La.dot(Gb) + Lb.dot(Ga) + Lb.dot(Gb)
        z0 = not np.any(Pa != 0) and not np.any(Pb != 0)
        ok &= z0
        print(f"lam {lam}: L . {name} == 0 exactly over Z[z]: {z0}  ({len(G)} generators)", flush=True)
    # mod p rank of [TVZ | TCone] (lower bound for the Q(z)-dimension)
    p = 2000000011
    from hl import Field
    zp = Field(p).z
    allG = gensV + gensC
    M = np.array([[(int(a) + int(b) * zp) % p for a, b in zip(*vec(g))] for g in allG], dtype=np.int64)
    print(f"lam {lam}: rank mod p of TVZ+TCone = {rank(M, p)} ; rank mod p of L = {rank(np.array([[(int(a)+int(b)*zp)%p for a,b in zip(ra,rb)] for ra,rb in zip(La,Lb)],dtype=np.int64), p)}", flush=True)
