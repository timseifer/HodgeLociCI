import sys, numpy as np
sys.path.insert(0, '/home/claude/hodge/discovery/checks/rc_t6'); sys.path.insert(0, '/home/claude/hodge/discovery/t6_unsolved/e')
from ana import setup, directions
from run2c import build
p, lam = 32029, 2
E, X = setup(p, lam); rng = np.random.default_rng(1)
v, info = directions(E, X, rng, 'al')
nk = E.kerL.shape[1]
K = lambda xs, n: build(E, v, xs, n)[1]
base = K({}, 6)
cnt = 0
for i in range(nk):
    e = np.zeros(nk, np.int64); e[i] = 1
    k3 = K({3: e}, 6)
    low = [m for m in range(2, 6) if ((k3[m] - base[m]) % p).any()]
    if low: cnt += 1; print("x3 dir", i, "changes orders", low)
    if i > 60: break
print("x3 dirs (first 62) changing lower orders:", cnt)
