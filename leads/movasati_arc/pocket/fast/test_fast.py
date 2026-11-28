import sys, time; sys.path.insert(0, "/home/claude/hodgelocici/leads/movasati_arc/blind_check14/own"); sys.path.insert(0, "/home/claude/work/fast")
from own import Ctx, L1, L2
import fastper, numpy as np
p = 31981; S = Ctx(p, 12637)
tab = S.ptable(S.Pspace(L1) + S.Pspace(L2) * (-1))
Ts = [S.parse(l) for l in open("/home/claude/hodgelocici/leads/movasati_arc/arcs/jet8_31981_s_lam2.txt") if l.strip()]
Ts[7] = Ts[7] + S.parse("x_0*x_1*x_4")   # break it so the values are non-zero
E = S.expseries(Ts, 8)
fastper.install(S, "/home/claude/work/fast/phi_31981")
for n in (3, 6, 8):
    t = time.time(); a = S.periods_py(E[n], tab) % p; t1 = time.time() - t
    t = time.time(); b = S.periods(E[n], tab); t2 = time.time() - t
    print(n, len(E[n]), "equal:", bool((a == b).all()), "nonzero", int(np.count_nonzero(a)), "py %.1fs  C %.1fs" % (t1, t2))
