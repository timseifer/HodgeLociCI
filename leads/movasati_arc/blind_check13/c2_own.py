#!/usr/bin/env python3
"""C2 (and the first-order statements of C1): own linear algebra mod p.  usage: c2_own.py file p lam"""
import sys, itertools
sys.path.insert(0, "/home/claude/blind_check13")
from lib13 import *
fn = sys.argv[1]; p = int(sys.argv[2]); lam = int(sys.argv[3])
hdr, idx, D, tl = read_arc(fn)
S = Setup(p); z = S.z; x = S.gens; ctx = S.ctx
Ts = [S.parse(l) for l in tl]
T1 = Ts[0]
print("==", fn, " p", p, " z", z, " lambda", lam)
L1s = [(2 * i, 2 * i + 1, 1) for i in range(5)]
L2s = [(2 * i, 2 * i + 1, 3 if i < 3 else 1) for i in range(5)]
tab = S.table([L1s, L2s], [1, lam % p]); tab1 = S.table([L1s], [1]); tab2 = S.table([L2s], [1])
Q = sqfree_monos(10, 2); mons = sqfree_monos(10, 3); index = {m: i for i, m in enumerate(mons)}
one = ctx.from_dict({(0,) * 10: 1})
def first_order(t):
    R = S.response(one, t, 5)
    return np.array([[R.get(tuple(a + b for a, b in zip(q, m)), 0) for m in mons] for q in Q], dtype=np.int64)
L = first_order(tab); La = first_order(tab1); Lb = first_order(tab2)
print("first-order matrix of [P1]+lam[P2]: 45 x 120, rank", rank(L, p), "; [P1] alone rank", rank(La, p),
      "; [P2] alone rank", rank(Lb, p), "; stacked [P1],[P2] rank", rank(np.vstack([La, Lb]), p))
t1 = vec_of(S, T1, index)
print("L T_1 = 0:", not (L @ t1 % p).any(), " ; L_[P1] T_1 = 0:", not (La @ t1 % p).any(), " ; L_[P2] T_1 = 0:", not (Lb @ t1 % p).any())
# ideals: f_i = x_2i - z x_(2i+1), h_i = x_2i - z^3 x_(2i+1)
f = [x[2 * i] - z * x[2 * i + 1] for i in range(5)]
h = [x[2 * i] - pow(z, 3, p) * x[2 * i + 1] for i in range(3)]
def sqpart(g):
    """coefficient vector of the squarefree part of a cubic (= the cubic modulo the squares x_i^2)"""
    v = np.zeros(120, dtype=np.int64)
    for mon, c in zip(g.monoms(), g.coeffs()):
        mon = tuple(mon)
        if max(mon) == 1: v[index[mon]] = int(c)
    return v
quads = [x[a] * x[b] for a in range(10) for b in range(a, 10)]
def ideal3(gens):
    rows = [sqpart(g * q) for g in gens for q in quads]
    R, piv = rref(np.array(rows), p)
    return R
I1 = ideal3(f); I2 = ideal3(h + f[3:])
print("dim (I(P1)+J)_3/J_3 =", len(I1), " dim (I(P2)+J)_3/J_3 =", len(I2), " dim of the sum =", rank(np.vstack([I1, I2]), p))
# intersection of the two row spaces
N = nullspace(np.vstack([I1, I2]).T, p)          # (a, b) with a I1 + b I2 = 0
TV = (N[:len(I1)].T @ I1) % p
TV, _ = rref(TV, p)
print("T_V = tangent space of the locus where both planes persist: dim", len(TV), " codim", 120 - len(TV))
print("   L vanishes on T_V:", not (L @ TV.T % p).any(), " ; ker of stacked [P1],[P2] first-order maps equals T_V:",
      rank(np.vstack([La, Lb]), p) == 120 - len(TV) and not (np.vstack([La, Lb]) @ TV.T % p).any())
print("   T_1 in (I(P1)+J)_3:", rank(np.vstack([I1, t1]), p) == len(I1), " ; T_1 in (I(P2)+J)_3:", rank(np.vstack([I2, t1]), p) == len(I2),
      " ; T_1 in T_V:", rank(np.vstack([TV, t1]), p) == len(TV))
K = nullspace(L, p).T
print("ker L: dim", len(K), " ; ker L = T_V + <T_1>:", rank(np.vstack([TV, t1]), p) == len(K))
# excess direction inside the cubics in x_0..x_5
m05 = [i for i, m in enumerate(mons) if sum(m[6:]) == 0]
Lsub = L[:, m05]
K05 = nullspace(Lsub, p).T
full = np.zeros((len(K05), 120), dtype=np.int64); full[:, m05] = K05
print("ker L inside the 20 squarefree cubics in x_0..x_5: dim", len(K05), " ; of which in T_V:",
      len(K05) + len(TV) - rank(np.vstack([TV, full]), p), " => an excess direction y_0 in x_0..x_5 exists:",
      rank(np.vstack([TV, full]), p) == len(TV) + 1)
# nets: restrict to f_3 = f_4 = 0 (x_6 -> z x_7, x_8 -> z x_9), reduce mod squares, take the parts x_7 * q7, x_9 * q9
def restrict(g):
    d = {}
    for mon, c in zip(g.monoms(), g.coeffs()):
        mon = list(mon); c = int(c)
        c = c * pow(z, mon[6] + mon[8], p) % p
        mon[7] += mon[6]; mon[9] += mon[8]; mon[6] = 0; mon[8] = 0
        if max(mon) > 1: continue
        d[tuple(mon)] = (d.get(tuple(mon), 0) + c) % p
    return d
qm = [m for m in sqfree_monos(6, 2)]; qidx = {m: i for i, m in enumerate(qm)}
def netparts(g):
    d = restrict(g)
    q7 = np.zeros(15, dtype=np.int64); q9 = np.zeros(15, dtype=np.int64); rest79 = {}; pure = 0
    for mon, c in d.items():
        if not c: continue
        a, b = mon[7], mon[9]
        if (a, b) == (1, 0): q7[qidx[mon[:6]]] = c
        elif (a, b) == (0, 1): q9[qidx[mon[:6]]] = c
        elif (a, b) == (1, 1): rest79[mon[:6]] = c
        else: pure += 1
    return q7, q9, rest79, pure
fh = []
for i in range(3):
    for j in range(3):
        g = f[i] * h[j]
        v = np.zeros(15, dtype=np.int64)
        for mon, c in zip(g.monoms(), g.coeffs()):
            mon = tuple(mon)
            if max(mon) == 1: v[qidx[mon[:6]]] = int(c)
        fh.append(v)
FH = np.array(fh).T                       # 15 x 9
# dimension count that makes the nets well defined
def ideal2(gens):
    rows = []
    for g in gens:
        for a in range(6):
            gg = g * x[a]; v = np.zeros(15, dtype=np.int64)
            for mon, c in zip(gg.monoms(), gg.coeffs()):
                mon = tuple(mon)
                if max(mon) == 1: v[qidx[mon[:6]]] = int(c)
            rows.append(v)
    return rref(np.array(rows), p)[0]
F2 = ideal2(f[:3]); H2 = ideal2(h)
print("quadrics in x_0..x_5 mod squares: dim (f)_2 =", len(F2), " dim (h)_2 =", len(H2), " dim sum =", rank(np.vstack([F2, H2]), p),
      " => intersection dim", len(F2) + len(H2) - rank(np.vstack([F2, H2]), p), " ; rank of the nine f_i h_j:", rank(FH, p))
q7, q9, rest79, pure = netparts(T1)
A = solve(FH, q7, p); B = solve(FH, q9, p)
print("x_7-part and x_9-part of T_1 restricted to {f_3 = f_4 = 0} lie in span(f_i h_j):", A is not None, B is not None,
      " ; monomials x_i x_7 x_9 in the restriction:", len(rest79), " ; cubic monomials in x_0..x_5:", pure)
if A is not None and B is not None:
    A = A.reshape(3, 3); B = B.reshape(3, 3)
    print("A =", A.tolist()); print("B =", B.tolist())
    kA = nullspace(A, p); kB = nullspace(B, p); cA = nullspace(A.T, p); cB = nullspace(B.T, p)
    print("rank A =", rank(A, p), " rank B =", rank(B, p), " rank [A;B] =", rank(np.vstack([A, B]), p), " rank [A|B] =", rank(np.hstack([A, B]), p))
    print("   common kernel (ker A = ker B):", rank(np.hstack([kA, kB]), p) == 1 and kA.shape[1] == 1 and kB.shape[1] == 1,
          " ; common cokernel:", rank(np.hstack([cA, cB]), p) == 1 and cA.shape[1] == 1 and cB.shape[1] == 1)
    print("   A, B proportional:", rank(np.vstack([A.reshape(-1), B.reshape(-1)]), p) == 1)
    mixed = []; aa = []; bb = []
    for (i, j) in itertools.combinations(range(3), 2):
        for (k, l) in itertools.combinations(range(3), 2):
            mixed.append(int(A[i, k] * B[j, l] + B[i, k] * A[j, l] - A[i, l] * B[j, k] - B[i, l] * A[j, k]) % p)
            aa.append(int(A[i, k] * A[j, l] - A[i, l] * A[j, k]) % p); bb.append(int(B[i, k] * B[j, l] - B[i, l] * B[j, k]) % p)
    print("   y1*y2-coefficients of the nine 2x2 minors of A y1 + B y2:", mixed)
    print("   y1^2-coefficients (minors of A):", aa); print("   y2^2-coefficients (minors of B):", bb)
    def det3(M): 
        return int(M[0,0]*(M[1,1]*M[2,2]-M[1,2]*M[2,1]) - M[0,1]*(M[1,0]*M[2,2]-M[1,2]*M[2,0]) + M[0,2]*(M[1,0]*M[2,1]-M[1,1]*M[2,0])) % p
    print("   det A, det B, det(A+B), det(A+2B):", det3(A), det3(B), det3((A + B) % p), det3((A + 2 * B) % p),
          " ; rank(A + t B) for t = 1, 2, 3:", [rank((A + t * B) % p, p) for t in (1, 2, 3)])
# does any monomial of T_1 involve x_8 or x_9 / x_6 or x_7
print("T_1: monomials", len(T1), " ; involving x_8 or x_9:", sum(1 for m in T1.monoms() if m[8] or m[9]),
      " ; involving x_6 or x_7:", sum(1 for m in T1.monoms() if m[6] or m[7]), " ; involving x_6 or x_8:", sum(1 for m in T1.monoms() if m[6] or m[8]))
