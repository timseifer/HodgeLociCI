#!/usr/bin/env python3
"""C6 side check (own code): which classes of the 252-dimensional space spanned by the monomials x^r (r squarefree of
degree 5; via x^r -> the functional with table {r: 1}) stay of type (4,4) along the arc to order N?
The 45 periods are linear in the table, so this is the kernel of a (45 N) x 252 matrix.   usage: c6_classes.py file p N"""
import sys, time
sys.path.insert(0, "/home/claude/blind_check13")
from lib13 import *
fn = sys.argv[1]; p = int(sys.argv[2]); N = int(sys.argv[3])
hdr, idx, D, tl = read_arc(fn)
S = Setup(p); cw = S.cw; m = 10
Ts = [S.parse(l) for l in tl]
Q = sqfree_monos(10, 2); pats = sqfree_monos(10, 5)
pw = 3 ** np.arange(m, dtype=np.int64)
fidx = np.full(3 ** m, -1, dtype=np.int64)
for i, q in enumerate(Q): fidx[int(np.array(q) @ pw)] = i
t0 = time.time()
E = S.expseries(Ts, N)
L1 = [(2 * i, 2 * i + 1, 1) for i in range(5)]; L2 = [(2 * i, 2 * i + 1, 3 if i < 3 else 1) for i in range(5)]
t1 = S.table([L1], [1]); t2 = S.table([L2], [1])
v1 = np.array([t1.get(r, 0) for r in pats], dtype=np.int64); v2 = np.array([t2.get(r, 0) for r in pats], dtype=np.int64)
rows = np.zeros((0, 252), dtype=np.int64)
print("==", fn, "p", p)
for n in range(1, N + 1):
    ex, co = fast_arrays(S, E[n])
    W = np.zeros((45, 252), dtype=np.int64)
    for j, r in enumerate(pats):
        beta = (np.array(r, dtype=np.int64)[None, :] - ex) % 3
        sel = beta.sum(axis=1) == 2
        if not sel.any(): continue
        b = beta[sel]; fi = fidx[b @ pw]; ok = fi >= 0
        if not ok.any(): continue
        g = ex[sel][ok] + b[ok]; w = co[sel][ok].copy()
        for k in range(m): w = w * cw[g[:, k]] % p
        acc = np.zeros(45, dtype=np.int64); np.add.at(acc, fi[ok], w); W[:, j] = acc % p
    rows = rref(np.vstack([rows, W]), p)[0]
    Kc = nullspace(rows, p)
    in1 = rank(np.hstack([Kc, ((v1 - v2) % p).reshape(-1, 1)]), p) == Kc.shape[1]
    inP1 = rank(np.hstack([Kc, v1.reshape(-1, 1)]), p) == Kc.shape[1]
    print("orders 1..%d: rank %d ; classes staying of type (4,4): dim %d ; contains [P1]-[P2]: %s ; contains [P1]: %s   time %.1fs"
          % (n, len(rows), Kc.shape[1], in1, inP1, time.time() - t0)); sys.stdout.flush()
