import sys, numpy as np
sys.path.insert(0, '/home/claude/hodge/discovery/checks/rc_t6'); sys.path.insert(0, '/home/claude/hodge/discovery/t6_unsolved/e')
from ana import setup, directions
from run2c import build
p, lam = 32029, 2
E, X = setup(p, lam); rng = np.random.default_rng(1)
v, info = directions(E, X, rng, 'al')
nk = E.kerL.shape[1]
K = lambda xs, n: build(E, v, xs, n)[1]
base = K({}, 5)
for i in [0, 5, 50, 100, 181]:
    e = np.zeros(nk, np.int64); e[i] = 1
    k1 = K({2: e}, 5); k2 = K({2: 2 * e}, 5); k3 = K({2: 3 * e}, 5)
    low = [m for m in range(2, 5) if k1[m].any()]
    d1 = (k1[5] - base[5]) % p; d2 = (k2[5] - base[5]) % p; d3 = (k3[5]-base[5]) % p
    q = (d2 - 2 * d1) % p; cub = (d3 - 3*d2 + 3*d1) % p
    print(i, "lower orders changed:", low, " nonlinear part nnz:", int(np.count_nonzero(q)), "3rd diff nnz", int(np.count_nonzero(cub)))
