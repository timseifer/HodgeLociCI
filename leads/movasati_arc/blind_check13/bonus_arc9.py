#!/usr/bin/env python3
"""Bonus (outside the brief): the file arcs/arc9_32029_seed1_lam-1_d.txt that appeared during this check; own code."""
import sys, time
sys.path.insert(0, "/home/claude/blind_check13")
from lib13 import *
fn = sys.argv[1]; p = int(sys.argv[2]); N = int(sys.argv[3])
hdr, idx, D, tl = read_arc(fn)
S = Setup(p)
Ts = [S.parse(l) for l in tl]
print(hdr); print("terms:", len(Ts), [len(t) for t in Ts])
h8, i8, D8, tl8 = read_arc("arc8_32029_seed1_lam-1_d.txt"); T8 = [S.parse(l) for l in tl8]
print("T_n equal to the arc8 file, n = 1..8:", [bool(Ts[n] == T8[n]) for n in range(8)])
L1 = [(2 * i, 2 * i + 1, 1) for i in range(5)]; L2 = [(2 * i, 2 * i + 1, 3 if i < 3 else 1) for i in range(5)]
tabm = S.table([L1, L2], [1, p - 1]); Q = sqfree_monos(10, 2)
t0 = time.time(); E = S.expseries(Ts, N)
print("E_n sizes:", [len(e) for e in E], " time %.1fs" % (time.time() - t0)); sys.stdout.flush()
first = None
for n in range(1, N + 1):
    v = fast_periods(S, E[n], tabm, Q); nz = int(np.count_nonzero(v))
    if nz and first is None: first = n
    print("order %d: non-zero entries among 45: %d   time %.1fs" % (n, nz, time.time() - t0)); sys.stdout.flush()
    E[n] = None if n < N - 0 and False else E[n]
print("RESULT own", fn, "first failing order up to", N, ":", first)
