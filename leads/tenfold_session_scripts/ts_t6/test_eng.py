# kernel vs numpy reference vs Fermat FastEngine (G = Fermat): H bit for bit, and Eprime levels
import sys, time, numpy as np
sys.path.insert(0, '/home/claude/hodge/discovery/checks/ts_t6')
from split import psi_tables
from tseng import TSEngine
from fsc import FastEngine
p = 67108837; z = 9827985
T, tabs, Y, data = psi_tables(p, z, 0, 15, checks=False)
for lam in (-1, 2):
    W = TSEngine(p, lam, z, tabs[0], tabs[1], T.OFF, 15, nthreads=2)
    F = FastEngine(p, lam, z=z, nthreads=2)
    print("lam", lam, "L identical to Fermat engine:", np.array_equal(W.L, F.L), "rank", W.Lrank)
    rng = np.random.default_rng(5)
    v = rng.integers(0, p, 220); v[rng.random(220) < 0.8] = 0
    Tp = [W.vec_to_poly(v)]
    Es = [W.poly_one()]; Esf = [F.poly_one()]
    for m in (1, 2, 3):
        E, acc, nt = W.Eprime(m, Tp, Es, store=True); Ef, accf, ntf = F.Eprime(m, Tp, Esf, store=True)
        same = np.array_equal(E[0], Ef[0]) and np.array_equal(E[1], Ef[1]) and np.array_equal(acc, accf)
        ref = W.H_ref(E) if nt < 3000 else None
        print("  m", m, "terms", nt, "E and H identical to Fermat kernel:", same, " kernel = numpy ref:", None if ref is None else np.array_equal(ref, acc))
        Es.append(E); Esf.append(Ef)
