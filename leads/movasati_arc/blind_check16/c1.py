#!/usr/bin/env python3
# C1: full-space order-6 test at the eightfold Movasati point, net g, lambda = a/b, MOD p.
# y_0 construction: base cubic c in x_0..x_5 (squarefree, 20 monomials); the first-order map of [P1]+lam[P2]
# on this space has rank 1 (checked), so adjust coefficient of monomial `adj` to put c in its kernel; check
# that the result is not in ker of [P1].  base = "auth" (the small-integer cubic the arc files use) or "rnd<seed>".
import sys; sys.path.insert(0, "/home/claude/hodgelocici/leads/movasati_arc/blind_check14/own")
from fs import *
p = int(sys.argv[1]); num, den = map(int, sys.argv[2].split("/")); base = sys.argv[3]
lam = num * pow(den, p-2, p) % p
z = {32029: 31556, 31981: 12637}[p]
S = Ctx(p, z); x = S.x
P1 = S.Pspace(L1); P2 = S.Pspace(L2); P = P1 + P2 * lam
m20 = [tuple(1 if i in c else 0 for i in range(M)) for c in itertools.combinations(range(6), 3)]
tabP = S.ptable(P); tab1 = S.ptable(P1)
def mono(m): return S.ctx.from_dict({m: 1})
if base == "auth":
    f = S.parse(read_lines("exact_g_lam2_order5.txt")[0])
    cf = {m: int(c) for m, c in zip(f.monoms(), f.coeffs()) if sum(m[6:]) == 0}
    coef = [cf.get(m, 0) for m in m20]
else:
    r = np.random.default_rng(int(base[3:])); coef = [int(v) for v in r.integers(1, 10, size=20)]
adj = (1,0,1,0,1,0,0,0,0,0) if len(sys.argv) < 5 else (1,0,1,0,0,1,0,0,0,0)   # x0x2x4, or x0x2x5
ia = m20.index(adj)
c0 = S.ctx.from_dict({m: coef[i] % p for i, m in enumerate(m20) if i != ia})
v0 = S.periods(c0, tabP); va = S.periods(mono(adj), tabP)
j = int(np.flatnonzero(va)[0]); t = int((-int(v0[j])) * pow(int(va[j]), p-2, p) % p)
y0 = c0 + mono(adj) * t
assert not S.periods(y0, tabP).any(), "y0 not in kernel"
assert S.periods(y0, tab1).any(), "y0 in ker [P1]"
print("y0: coefficient of adjusted monomial", adj, "=", t, "(others from base", base, ")", flush=True)
def net(A):
    fl = [x[2*i] - x[2*i+1] * z for i in range(3)]; h = [x[2*j] + x[2*j+1] for j in range(3)]
    e = S.ctx.from_dict({})
    for i in range(3):
        for jj in range(3):
            if A[i][jj] % p: e = e + fl[i] * h[jj] * (A[i][jj] % p)
    return S.ctx.from_dict({m: c for m, c in zip(e.monoms(), e.coeffs()) if max(m) <= 1})
mm = lambda A, B: [[sum(A[i][k]*B[k][j] for k in range(3)) for j in range(3)] for i in range(3)]
G = [[1,1,0],[0,1,1],[1,0,2]]; H = [[2,0,1],[1,1,0],[0,1,1]]
F1 = [[1,2,0],[0,1,0],[0,0,0]]; F2 = [[1,0,0],[1,1,0],[0,0,0]]
A, B = mm(mm(G, F1), H), mm(mm(G, F2), H)
T1 = y0 + x[7] * net(A) + x[9] * net(B)
if base == "auth" and (num, den) in [(2, 1), (-1, 1)]:
    fn = {2: "exact_g_lam2_order5.txt", -1: "exact_g_lam-1_order7.txt"}[num]
    print("T1 equals file T_1:", T1 == S.parse(read_lines(fn)[0]), flush=True)
t0 = time.time()
fs = FS(S, P, T1)
print("p", p, "lambda", sys.argv[2], "=", lam, "rank L", fs.rkL, "dim ker L", fs.K.shape[1],
      "L T1 nonzero:", int(np.count_nonzero(S.periods(T1, fs.tab))), flush=True)
exec(open("/home/claude/blind_check16/tail.py").read())
