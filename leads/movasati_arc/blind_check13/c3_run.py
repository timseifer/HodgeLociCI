#!/usr/bin/env python3
"""C3 driver.  usage: c3_run.py file p lam mode   (mode: slice | full | nets18 | control)"""
import sys, time
sys.path.insert(0, "/home/claude/blind_check13")
from c3_lib import *
fn = sys.argv[1]; p = int(sys.argv[2]); lam = int(sys.argv[3]); mode = sys.argv[4]
hdr, idx, D, tl = read_arc(fn)
S = Setup(p); z = S.z; x = S.gens
Ts = [S.parse(l) for l in tl][:5]
L1s = [(2 * i, 2 * i + 1, 1) for i in range(5)]; L2s = [(2 * i, 2 * i + 1, 3 if i < 3 else 1) for i in range(5)]
tab = S.table([L1s, L2s], [1, lam % p])
t0 = time.time()
mons = sqfree_monos(10, 3); index = {m: i for i, m in enumerate(mons)}
# the slice read off the data: 19 monomials of T_5 (lambda = 2 files) / T_6 (lambda = -1 files), 18 net cubics
allT = [S.parse(l) for l in tl]
piv = sorted(set(tuple(m) for m in allT[-1].monoms()), reverse=True)
f = [x[2 * i] - z * x[2 * i + 1] for i in range(3)]; h = [x[2 * i] - pow(z, 3, p) * x[2 * i + 1] for i in range(3)]
def sqvec(g):
    v = np.zeros(120, dtype=np.int64)
    for mon, c in zip(g.monoms(), g.coeffs()):
        if max(mon) == 1: v[index[tuple(mon)]] = int(c)
    return v
nets = [sqvec(f[i] * h[j] * x[7 + 2 * k]) for k in range(2) for i in range(3) for j in range(3)]     # index 9k + 3i + j
P19 = np.zeros((120, len(piv)), dtype=np.int64)
for a, m_ in enumerate(piv): P19[index[m_], a] = 1
N18 = np.array(nets).T
print("==", fn, "p", p, "lambda", lam, "mode", mode)
print("pivot monomials read from the last term:", len(piv), " ; rank of [19 monomials | 18 nets]:", rank(np.hstack([P19, N18]), p))
t2 = sqvec(Ts[1])
sol = solve(np.hstack([P19, N18]), t2, p)
if sol is not None:
    nz = [int(i) for i in np.flatnonzero(sol[len(piv):])]
    print("T_2 = (19 monomials) + nets with non-zero coefficient at net indices (9k+3i+j):", nz, " ; file line 2:", idx)
else:
    print("T_2 is not in the span of the 19 monomials and the 18 nets")
if mode == "control":
    # positive control: spoil the jet (drop the net part of T_3, set T_4 = T_5 = 0); a solution exists, so the verdict must not be EMPTY
    t3 = sqvec(Ts[2]); s3 = solve(np.hstack([P19, N18]), t3, p)
    t3p = P19 @ s3[:len(piv)] % p
    Ts = [Ts[0], Ts[1], poly_of(S, t3p, mons), S.ctx.from_dict({}), S.ctx.from_dict({})]
X = C3(S, tab, Ts)
L = X.J[0]
print("orders 1..6 of the base jet: non-zero entries among 45:", [int(np.count_nonzero(c)) for c in X.c],
      " ; order-6 projection to coker L non-zero:", int(np.count_nonzero(X.b[180:])), "of 26   time %.1fs" % (time.time() - t0))
print("rank of L on the 19 monomials:", rank(L @ P19 % p, p), " ; L kills the 18 nets:", not (L @ N18 % p).any())
free = N18[:, idx]
if mode == "slice":
    B = np.hstack([P19, free])
elif mode == "nets18":
    B = np.hstack([P19, N18])
else:
    B = np.eye(120, dtype=np.int64)
k = B.shape[1]
W = np.zeros((480, 4 * k), dtype=np.int64)
for j in range(4): W[120 * j:120 * (j + 1), k * j:k * (j + 1)] = B
print("initial X: T_n - T_n^0 in a space of dimension", k, "for n = 2..5 (and any T_6)  ; linearised test on X: rank", rank(X.Lin @ W % p, p),
      " rank with b:", rank(np.hstack([X.Lin @ W % p, X.b.reshape(-1, 1)]), p))
if mode == "slice":
    # total linear response of the order-5 (and order-6) obstruction to the 7 free nets of T_2 (resp. T_3), pivot parts re-solved
    LP = L @ P19 % p
    def lift(rhs):      # delta in the 19 monomials with L delta = rhs  (rhs must be in im L)
        s_ = solve(LP, rhs, p); return None if s_ is None else P19 @ s_ % p
    Dm = np.zeros((26, 7), dtype=np.int64); okk = True; lower = 0
    for a in range(7):
        nu = free[:, a]
        d3 = lift((-X.J[1] @ nu) % p)
        if d3 is None: okk = False; break
        r4 = (X.J[1] @ d3 + X.J[2] @ nu) % p
        d4 = lift((-r4) % p)
        if d4 is None: okk = False; break
        Dm[:, a] = X.Kl @ ((X.J[1] @ d4 + X.J[2] @ d3 + X.J[3] @ nu) % p) % p
    if okk:
        Da = np.array(D, dtype=np.int64) % p
        print("linear response (order-5 obstruction to the 7 free nets of T_2), own: 26 x 7, rank", rank(Dm, p),
              " ; file matrix D: rank", rank(Da, p), " ; zero rows own/file:", int((~Dm.any(axis=1)).sum()), int((~Da.any(axis=1)).sum()))
        ratios = set()
        for a in range(7):
            nzr = np.flatnonzero(Da[:, a])
            if len(nzr) and Dm[nzr[0], a]:
                c = int(Da[nzr[0], a]) * pow(int(Dm[nzr[0], a]), p - 2, p) % p
                ratios.add(c if ((Dm[:, a] * c - Da[:, a]) % p == 0).all() else None)
            else: ratios.add(None)
        print("   file D = (one scalar) * own response, column by column: scalars", ratios)
        print("   order-6 defect in the column space of the response matrix (own):", rank(np.hstack([Dm, X.b[180:].reshape(-1, 1)]), p) == rank(Dm, p),
              " ; in that of the file's D:", rank(np.hstack([Da, X.b[180:].reshape(-1, 1)]), p) == rank(Da, p))
    else:
        print("orders 3/4 are not automatically solvable along the free nets (level-1/2 response non-zero)")
verdict, log, cert, ell = X.closure(W, tlimit=380)
print("VERDICT", mode, fn, ":", verdict)
if cert: print("   certificate:", cert)
print("   final base jet residual non-zero entries by block (orders 2,3,4,5,6proj):",
      [int(np.count_nonzero(X.b[45 * j:45 * (j + 1)])) for j in range(4)] + [int(np.count_nonzero(X.b[180:]))])
print("total time %.1fs" % (time.time() - t0))
