# EXP-T6: rank DG4(v) at v = (generic T Cone_T) + a x l with a, l uniformly random mod p; and the l-matrix rank
import sys, numpy as np
sys.path.insert(0, '/home/claude/hodge/discovery/checks/exp_t6'); sys.path.insert(0, '/home/claude/hodge/discovery/t6_unsolved/e')
from run2x import build, jac
from ana import setup, directions, bOf
p = 32029
for lam in (-1, 2):
    E, X = setup(p, lam)
    Kc_ = E.kernel(X['Mc'] % p)
    for seed in range(21, 25):
        rng = np.random.default_rng(seed)
        v0, _ = directions(E, X, rng, 'cone')
        a = rng.integers(1, p, 3); l = rng.integers(0, p, (3, 3))
        for kind in ('al', 'la'):
            if kind == 'al': M = [[{u: int(a[i] * l[j, k] % p) for k, u in enumerate((1, 3, 5))} for j in range(3)] for i in range(3)]
            else: M = [[{u: int(a[j] * l[i, k] % p) for k, u in enumerate((1, 3, 5))} for j in range(3)] for i in range(3)]
            v = (v0 + bOf(E, M) + Kc_ @ rng.integers(0, p, Kc_.shape[1])) % p
            Ts, Kc, MHs = build(E, v, {}, 5)
            J, ok = jac(E, MHs, 5)
            print('lam', lam, kind, 'seed', seed, 'K.c4 nnz', np.count_nonzero(Kc[4]), 'rank DG4 =', E.rank(J), flush=True)
