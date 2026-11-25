# EXP-T6: rank of DG4(v) on ker L at generic v in S_al / S_la (own seeds), lambda = -1 and 2 (MOD p)
import sys, numpy as np
sys.path.insert(0, '/home/claude/hodge/discovery/checks/exp_t6'); sys.path.insert(0, '/home/claude/hodge/discovery/t6_unsolved/e')
from run2x import build, jac
from ana import setup, directions
p = 32029
for lam in (-1, 2):
    E, X = setup(p, lam)
    for kind in ('al', 'la'):
        for seed in (11, 12):
            rng = np.random.default_rng(seed)
            v, _ = directions(E, X, rng, kind)
            Kc_ = E.kernel(X['Mc'] % p); v = (v + Kc_ @ rng.integers(0, p, Kc_.shape[1])) % p   # generic T Cone_T part
            Ts, Kc, MHs = build(E, v, {}, 5)
            J, ok = jac(E, MHs, 5)
            print('lam', lam, kind, 'seed', seed, 'K.c4 nnz', np.count_nonzero(Kc[4]), 'rank DG4(v) on ker L =', E.rank(J), 'of', J.shape, flush=True)
