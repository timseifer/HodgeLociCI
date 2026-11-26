#!/usr/bin/env python3
"""C5, own implementation: the eightfold arc read as an arc of the Fermat cubic tenfold (12 variables, 221 forms).
usage: c5_own.py file p N"""
import sys, time
sys.path.insert(0, "/home/claude/blind_check13")
from lib13 import *
fn = sys.argv[1]; p = int(sys.argv[2]); N = int(sys.argv[3])
hdr, idx, D, tl = read_arc(fn)
S = Setup(p, m=12); z = S.z
Ts = [S.parse(l) for l in tl]
L1 = [(2 * i, 2 * i + 1, 1) for i in range(6)]
L2 = [(2 * i, 2 * i + 1, 3 if i < 3 else 1) for i in range(6)]
tabm = S.table([L1, L2], [1, p - 1]); tab1 = S.table([L1], [1])
F3 = sqfree_monos(12, 3); F0 = [(0,) * 12]
print("==", fn, "p", p, "z", z, " tenfold: forms", len(F3) + 1, " patterns in the table of [P1]-[P2]:", len(tabm))
t0 = time.time()
E = S.expseries(Ts, N)
print("E_n sizes:", [len(e) for e in E], " time %.1fs" % (time.time() - t0)); sys.stdout.flush()
# factorisation check on [P1] alone at orders 1..3: tenfold period of x_10 q = z * (eightfold period of q), of x_11 q = eightfold period of q
S8 = Setup(p, m=10); T8 = [S8.parse(l) for l in tl]; E8 = S8.expseries(T8, 3)
tab1_8 = S8.table([[(2 * i, 2 * i + 1, 1) for i in range(5)]], [1]); Q8 = sqfree_monos(10, 2)
for n in (1, 2, 3):
    v10 = fast_periods(S, E[n], tab1, F3); v8 = fast_periods(S8, E8[n], tab1_8, Q8)
    d8 = {q: int(v) for q, v in zip(Q8, v8)}
    okf = True; nzo = 0
    for f_, v in zip(F3, v10):
        a, b = f_[10], f_[11]
        if a + b == 1 and sum(f_[:10]) == 2:
            exp = d8[f_[:10]] * (z if a == 1 else 1) % p
            okf = okf and (int(v) == exp)
        else:
            nzo += int(v != 0)
    print("   [P1] alone, order %d: tenfold periods of x_10 q, x_11 q equal z * (eightfold), 1 * (eightfold): %s ; non-zero among the other 130 cubic forms: %d ; non-zero eightfold periods: %d"
          % (n, okf, nzo, int(np.count_nonzero(v8))))
first = None
for n in range(1, N + 1):
    ex, co = fast_arrays(S, E[n]); g = np.zeros(len(co), dtype=np.int64)
    v3 = grouped_periods(S, ex, co, g, 1, tabm, F3)[0]; v0 = grouped_periods(S, ex, co, g, 1, tabm, F0)[0]
    nz = int(np.count_nonzero(v3)) + int(np.count_nonzero(v0))
    if nz and first is None: first = n
    print("order %d: [P1]-[P2] tenfold: non-zero entries among 221: %d   time %.1fs" % (n, nz, time.time() - t0)); sys.stdout.flush()
    del ex, co, g
print("RESULT own tenfold", fn, " first failing order up to", N, ":", first)
Tb = list(Ts); Tb[2] = Ts[2] + S.parse("x_0*x_3*x_10"); Eb = S.expseries(Tb, 4)
fb = None
for n in range(1, 5):
    if fast_periods(S, Eb[n], tabm, F3).any() or fast_periods(S, Eb[n], tabm, F0).any(): fb = n; break
print("control: T_3 + x_0 x_3 x_10 -> first failing order (checked to 4):", fb)
print("total time %.1fs" % (time.time() - t0))
