#!/usr/bin/env python3
"""extras: (a) own order-6 defect vs the package's obstruction vector; (b) level3 on the parts of T_V; (c) rank-one
members of the pencil A y1 + B y2.   usage: extras.py file p lam"""
import sys, time, itertools
exec(open("/home/claude/blind_check13/c3_red.py").read().split("# identity tests of the polynomial structure")[0])
print("own order-6 defect e6 (basis of coker L from the reduced row echelon form):", [int(v) if v <= p // 2 else int(v) - p for v in e6])
if len(sys.argv) > 4:
    pk = np.array(eval(sys.argv[4]), dtype=np.int64) % p
    nzr = np.flatnonzero(pk)
    c = int(pk[nzr[0]]) * pow(int(e6[nzr[0]]), p - 2, p) % p
    print("package obstruction = (scalar %d) * own e6:" % c, not ((e6 * c - pk) % p).any())
# (b) T_V and its parts
f = [x[2 * i] - z * x[2 * i + 1] for i in range(5)]; h = [x[2 * i] - pow(z, 3, p) * x[2 * i + 1] for i in range(3)]
def sqv(g):
    v = np.zeros(120, dtype=np.int64)
    for mon, c in zip(g.monoms(), g.coeffs()):
        if max(mon) == 1: v[index[tuple(mon)]] = int(c)
    return v
quads = [x[a] * x[b] for a in range(10) for b in range(a, 10)]
rest = [sqv(f[i] * q) for i in (3, 4) for q in quads] + [sqv(f[i] * h[j] * x[m_]) for i in range(3) for j in range(3) for m_ in range(6)]
nets = [sqv(f[i] * h[j] * x[7 + 2 * k]) for k in range(2) for i in range(3) for j in range(3)]
Rst = rref(np.array(rest), p)[0]; Nts = np.array(nets)
print("'the rest' = (f_3,f_4)*quadrics + f_i h_j x_m (m<=5), mod squares: dim", len(Rst), " ; with the 18 nets: dim", rank(np.vstack([Rst, Nts]), p),
      " ; L kills it:", not (L @ Rst.T % p).any())
def coords(V):          # coordinates in the basis Kb of ker L (rows of V must lie in ker L)
    out = []
    for v in V:
        s_ = solve(Kb, v, p); assert s_ is not None; out.append(s_)
    return np.array(out).T
cR = coords(Rst); cN = coords(Nts)
print("level3 on 'the rest': rank", rank(lev3 @ cR % p, p), " ; on the 18 nets: rank", rank(lev3 @ cN % p, p), " ; on the 7 free nets: rank",
      rank(lev3 @ cN[:, idx] % p, p), " ; level4 on 'the rest': rank", rank(lev4 @ cR % p, p))
m05 = [i for i, m_ in enumerate(mons) if sum(m_[6:]) == 0]
K05 = nullspace(L[:, m05], p).T; full = np.zeros((len(K05), 120), dtype=np.int64); full[:, m05] = K05
print("level3 on the 19-dim kernel inside the cubics in x_0..x_5: rank", rank(lev3 @ coords(full) % p, p))
