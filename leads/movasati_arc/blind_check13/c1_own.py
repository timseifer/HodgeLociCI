#!/usr/bin/env python3
"""C1, own implementation (python-flint nmod_mpoly + numpy; no package code).  usage: c1_own.py file p N"""
import sys, time
sys.path.insert(0, "/home/claude/blind_check13")
from lib13 import *
fn = sys.argv[1]; p = int(sys.argv[2]); N = int(sys.argv[3])
hdr, idx, D, tl = read_arc(fn)
S = Setup(p)
Ts = [S.parse(l) for l in tl]
print(hdr); print("p =", p, " z =", S.z, " T_1..T_%d read; monomials per T_n:" % len(Ts), [len(t) for t in Ts])
allm = set(mm for t in Ts for mm in t.monoms())
print("all terms squarefree cubics:", all(sum(mm) == 3 and max(mm) == 1 for mm in allm))
L1 = [(2 * i, 2 * i + 1, 1) for i in range(5)]
L2 = [(2 * i, 2 * i + 1, 3 if i < 3 else 1) for i in range(5)]
tabm = S.table([L1, L2], [1, p - 1])      # [P1] - [P2]
tabp = S.table([L1, L2], [1, 1])          # [P1] + [P2]
tab1 = S.table([L1], [1]); tab2 = S.table([L2], [1])
Q = sqfree_monos(10, 2)
print("patterns in the table of [P1]-[P2]:", len(tabm), " forms:", len(Q))
t0 = time.time()
E = S.expseries(Ts, N)
print("E_n sizes:", [len(e) for e in E], " time %.1fs" % (time.time() - t0)); sys.stdout.flush()
firstm = firstp = None
for n in range(1, N + 1):
    arrs = S.arrays(E[n])
    cm = S.periods(E[n], tabm, Q, arrs)
    nzm = sum(1 for v in cm if v)
    extra = ""
    if n <= 3:
        cp = S.periods(E[n], tabp, Q, arrs); c1 = S.periods(E[n], tab1, Q, arrs); c2 = S.periods(E[n], tab2, Q, arrs)
        extra = "   [P1]+[P2]: %d non-zero;  [P1] alone: %d;  [P2] alone: %d" % (
            sum(1 for v in cp if v), sum(1 for v in c1 if v), sum(1 for v in c2 if v))
        if firstp is None and any(cp): firstp = n
    if firstm is None and nzm: firstm = n
    print("order %d: [P1]-[P2]: non-zero entries among 45: %d%s   time %.1fs" % (n, nzm, extra, time.time() - t0))
    sys.stdout.flush()
    del arrs
print("RESULT own  %s  [P1]-[P2] first failing order up to %d: %s ;  [P1]+[P2] first failing order: %s" % (fn, N, firstm, firstp))
# negative controls: change one coefficient of T_k and look for the first failing order (orders up to min(N,6))
Nc = min(N, 6)
for kbad in (2, 4, Nc):
    Tb = list(Ts)
    Tb[kbad - 1] = Ts[kbad - 1] + S.parse("x_0*x_3*x_9")
    Eb = S.expseries(Tb, Nc)
    first = None
    for n in range(1, Nc + 1):
        if any(S.periods(Eb[n], tabm, Q)):
            first = n; break
    print("control: T_%d + x_0 x_3 x_9 -> first failing order (checked to %d): %s" % (kbad, Nc, first))
print("total time %.1fs" % (time.time() - t0))
