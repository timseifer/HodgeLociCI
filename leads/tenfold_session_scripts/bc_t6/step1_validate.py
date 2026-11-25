# Validation of the period functional + rank L, T Cone_T, T V_Z (point 1). Usage: python3 step1_validate.py p
import sys, numpy as np, itertools, time
sys.path.insert(0, '/home/claude/hodge/discovery/checks/bc_t6')
from hl import *

p = int(sys.argv[1]) if len(sys.argv) > 1 else 2000000011
F = Field(p); z, zb = F.z, F.zb
W1 = [z] * 6
W2 = [z, z, z, zb, zb, zb]
CUB = cubic_monos()
idx = {enc(b): i for i, b in enumerate(CUB)}

def vec(poly):
    v = np.zeros(len(CUB), np.int64)
    for k, c in zip(poly.k, poly.c):
        v[idx[int(k)]] = c
    return v

def Lmat(tables):
    # L[P,Q] = Phi(P*Q) for both planes ; returns list of matrices
    deg6 = {}
    Ms = [np.zeros((len(CUB), len(CUB)), np.int64) for _ in tables]
    ex = np.array(CUB)
    for j, Q in enumerate(CUB):
        S = ex + np.array(Q)[None, :]
        for t, T in enumerate(tables):
            v = np.ones(len(CUB), np.int64)
            for e in range(6):
                v = v * T[e][S[:, 2 * e], S[:, 2 * e + 1]] % p
            Ms[t][:, j] = v
    return Ms

def x(i): return Poly.var(p, i)
u = [lin(p, {2 * e: 1, 2 * e + 1: -z}) for e in range(6)]
vv = [None] * 6
for e in range(3, 6): vv[e] = lin(p, {2 * e: 1, 2 * e + 1: -zb})
y = [x(2 * e + 1) for e in range(3)]

for variant in ["X", "Y"]:
    T1 = pair_tables(F, W1, variant=variant); T2 = pair_tables(F, W2, variant=variant)
    M1, M2 = Lmat([T1, T2])
    # test: G in I(P1)_3 must be in ker L_{P1}
    rng = np.random.default_rng(1)
    bad = 0
    for trial in range(5):
        e = rng.integers(6); a, b = rng.integers(12, size=2)
        G = u[e] * x(a) * x(b)
        bad += int(mm(M1, vec(G), p).any())
    print(variant, "I(P1) in ker L_P1 failures:", bad, " rank L_P1 =", rank(M1, p), " rank L_P2 =", rank(M2, p))
variant = "X"
T1 = pair_tables(F, W1, variant=variant); T2 = pair_tables(F, W2, variant=variant)
M1, M2 = Lmat([T1, T2])
for lam in [-1, 2, 1]:
    print("lambda", lam, "rank L_delta =", rank((M1 + lam * M2) % p, p))
np.save('/home/claude/hodge/discovery/checks/bc_t6/M1_%d.npy' % p, M1); np.save('/home/claude/hodge/discovery/checks/bc_t6/M2_%d.npy' % p, M2)

# ---- tangent spaces ----
allvars = [x(i) for i in range(12)]
quads = [allvars[i] * allvars[j] for i in range(12) for j in range(i, 12)]
J = [vec(x(j) * x(i) * x(i)) for i in range(12) for j in range(12)]
# T V_Z = J + (u0,u1,u2)*S2 + (u_e v_f)*S1
TVZ = list(J) + [vec(u[i] * q) for i in range(3) for q in quads] + \
      [vec(u[e] * vv[f] * xx) for e in range(3, 6) for f in range(3, 6) for xx in allvars]
# Cone_T: J + (u0,u1,u2)*S2 + T_Y-lifts.  P^8 = V(u0,u1,u2); coordinates on P^8: y0,y1,y2,x6..x11.
# T_Y = cubics G in x6..x11 with Phi_Y(G)=0, Phi_Y = fourfold functional of Pi1 + lam Pi2 (pairs 3,4,5)
def TCone(lam):
    pairs = [(6, 7), (8, 9), (10, 11)]
    cub6 = [c for c in itertools.combinations_with_replacement(range(6, 12), 3)]
    rows = []
    vals = []
    for c in cub6:
        beta = [0] * 12
        for i in c: beta[i] += 1
        s = 0
        for T in (T1, T2):
            v = 1
            for e in range(3, 6):
                v = v * int(T[e][beta[2 * e], beta[2 * e + 1]]) % p
            s = s
            vals.append(v)
        rows.append(beta)
    ph = np.array([(vals[2 * i] + lam * vals[2 * i + 1]) % p for i in range(len(cub6))], np.int64)
    # kernel of ph on cub6
    N = nullspace(ph[None, :], p)
    TY = []
    for nrow in N:
        poly = Poly(p, [enc(rows[i]) for i in np.flatnonzero(nrow)], nrow[np.flatnonzero(nrow)])
        TY.append(vec(poly))
    return list(J) + [vec(u[i] * q) for i in range(3) for q in quads] + TY

for lam in [-1, 2]:
    L = (M1 + lam * M2) % p
    TC = np.array(TCone(lam)) % p
    TV = np.array(TVZ) % p
    rk = rank(L, p)
    dimTC = rank(TC, p); dimTV = rank(TV, p)
    print("lam", lam, "rank L", rk, "dim ker L", 364 - rk, "dim TCone", dimTC, "dim TVZ", dimTV,
          "dim TC+TV", rank(np.r_[TC, TV], p))
    print("   L*TCone==0:", not mm(L, TC.T, p).any(), "  L*TVZ==0:", not mm(L, TV.T, p).any())
    B27 = np.array([vec(y[i] * u[e] * vv[f]) for i in range(3) for e in range(3, 6) for f in range(3, 6)]) % p
    print("   27 y_i u_e v_f in ker L:", not mm(L, B27.T, p).any(),
          " dim(TC + B27) =", rank(np.r_[TC, B27], p))
