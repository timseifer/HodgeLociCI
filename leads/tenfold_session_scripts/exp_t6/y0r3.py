# EXP-T6 (iv): y0 directions v0 + x1*N (Thom-Sebastiani slice), N of rank 3 vs controls. run2 logic (copy run2x).
import sys, numpy as np
sys.path.insert(0, '/home/claude/hodge/discovery/checks/exp_t6')
sys.path.insert(0, '/home/claude/hodge/discovery/t6_unsolved/e')
import run2x
from ana import setup, bOf, directions
p = int(sys.argv[1]); lam = int(sys.argv[2]); seed = int(sys.argv[3]); kind = sys.argv[4]; N = int(sys.argv[5])
E, X = setup(p, lam)
rng = np.random.default_rng(seed)
v0, _ = directions(E, X, rng, 'cone')
if kind == 'y0id': Nm = np.eye(3, dtype=int)
elif kind == 'y0r3': Nm = rng.integers(1, 50, size=(3, 3))
elif kind == 'y0r2': a, c, a2, c2 = [rng.integers(1, 50, size=3) for _ in range(4)]; Nm = np.outer(a, c) + np.outer(a2, c2)
elif kind == 'y0nov0': Nm = np.eye(3, dtype=int)
print('N =', Nm.tolist(), 'det', int(round(np.linalg.det(Nm))), flush=True)
M = [[({1: int(Nm[i, j])} if Nm[i, j] else {}) for j in range(3)] for i in range(3)]
b = bOf(E, M)
v = (b if kind == 'y0nov0' else (v0 + b)) % p
run2x.run(p, lam, seed, kind, N, v=v)
