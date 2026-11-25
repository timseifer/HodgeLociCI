# W4: exact (Q(z)) Schwartz-Zippel test of G4 = 0 on Sigma1 = T Cone_T + bOf(Segre cone), generic points; also rank DG4 there.
import sys, random, time, os
sys.path.insert(0, '/home/claude/hodge/discovery/checks/ex_t6')
from fex import *
from exarc import *
import dirs_exact
from dirs_exact import bOf_exact, M_al, M_la
from mc_exact import mc_exact
lam = int(sys.argv[1]); seed = int(sys.argv[2]); kind = sys.argv[3]; R = 10**4
t0 = time.time(); random.seed(seed)
X = ExactEngine(lam); X.setup_L()
Mc, _ = mc_exact(X, lam); TC = kernel(Mc)
c = TC * fmpq_mat(TC.ncols(), 1, [random.randint(-R, R) for _ in range(TC.ncols())])
a = [random.randint(-R, R) for _ in range(3)]
l = [{u: random.randint(-R, R) for u in (1, 3, 5)} for _ in range(3)]
M = M_al(a, l) if kind == 'al' else M_la(a, l)
v = c + bOf_exact(X, M)
arc = Arc(X, v).extend(5)
D = X.K * lin(X, arc.MHs, 2, X.kerL, 5)[5]
print("lam", lam, kind, "seed", seed, "L v = 0:", iszero(X.L * v), " K.c2..4 zero:", [iszero(arc.Kc[n]) for n in (2, 3, 4)],
      " rank_Q(z) DG4(v) =", rank(D) // 2, "(%.0fs)" % (time.time() - t0), flush=True)
