# RC-T6: BC-type y0 directions (b = y0 (a.u)(c.v), y0 = x1) in step (e)'s coordinates, run with (e)'s run2 logic (copy).
import sys, numpy as np
sys.path.insert(0, '/home/claude/hodge/discovery/checks/rc_t6')
sys.path.insert(0, '/home/claude/hodge/discovery/t6_unsolved/e')
import run2c
from ana import setup, bOf, directions
p = int(sys.argv[1]); lam = int(sys.argv[2]); seed = int(sys.argv[3]); kind = sys.argv[4]; N = int(sys.argv[5])
E, X = setup(p, lam)
rng = np.random.default_rng(seed)
v0, _ = directions(E, X, rng, 'cone')   # pure-y v0 in T Cone_T \ T V_Z, as step (e)
R = lambda: [int(c) for c in rng.integers(1, 50, size=3)]
if kind == 'y0r1':
    a, c = R(), R(); M = [[{1: a[i] * c[j]} for j in range(3)] for i in range(3)]
elif kind == 'y0r2':
    a, c, a2, c2 = R(), R(), R(), R(); M = [[{1: a[i] * c[j] + a2[i] * c2[j]} for j in range(3)] for i in range(3)]
elif kind == 'y0diag':
    M = [[{} for j in range(3)] for i in range(3)]; M[0][1] = {1: 1}
elif kind == 'y01r1':   # l_f in span(y0, y1) (BC's 10-variable slice type), a x l
    a = R(); l = [{1: int(rng.integers(1, 50)), 3: int(rng.integers(1, 50))} for _ in range(3)]
    M = [[{u: a[i] * cc for u, cc in l[j].items()} for j in range(3)] for i in range(3)]
b = bOf(E, M)
v = (v0 + b) % p
run2c.run(p, lam, seed, kind, N, v=v)
