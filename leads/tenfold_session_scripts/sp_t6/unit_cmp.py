# compare FastEngine.Eprime (compiled) with W3Engine.Eprime (reference) on E'_1..E'_M of the EX-T6 arc
import sys, time, numpy as np
from common import setup
from fsc import FastEngine
p = int(sys.argv[1]) if len(sys.argv) > 1 else 67108837; M = int(sys.argv[2]) if len(sys.argv) > 2 else 7
nth = int(sys.argv[3]) if len(sys.argv) > 3 else 1
W, Ts, zp = setup(p); F = FastEngine(p, -1, z=zp, nthreads=nth)
Tp = [W.vec_to_poly(T) for T in Ts]; Er = [W.poly_one()]; Ef = [F.poly_one()]; allok = True
for m in range(1, M + 1):
    t = time.time(); E1, a1, n1 = W.Eprime(m, Tp, Er); t1 = time.time() - t
    t = time.time(); E2, a2, n2 = F.Eprime(m, Tp, Ef); t2 = time.time() - t
    ok = n1 == n2 and np.array_equal(E1[0], E2[0]) and np.array_equal(E1[1].astype(np.int64), E2[1].astype(np.int64)) and np.array_equal(a1, a2)
    F.visfilter = True; _, a3, n3 = F.Eprime(m, Tp, Ef, store=False); F.visfilter = False
    ok3 = np.array_equal(a1, a3) and n3 == n1
    allok &= ok and ok3
    print("E'_%d terms %d: identical poly+H %s, streamed+visfilter H identical %s; python %.2fs compiled %.2fs" % (m, n1, ok, ok3, t1, t2), flush=True)
    Er.append(E1); Ef.append(E2)
print("ALL IDENTICAL", allok)
