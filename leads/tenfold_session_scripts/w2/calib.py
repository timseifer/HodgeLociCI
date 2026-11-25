import sys, numpy as np, time
from fiber2 import *
rng = np.random.default_rng(int(sys.argv[1]))
xs = rng.normal(size=72) * 0.7
al, be, C = unpack(xs); K = ITb_full(al, be, C)
Ycal = K @ (rng.normal(size=20) + 1j * rng.normal(size=20))
for trial in range(2):
    x0 = xs + rng.normal(size=72) * (0.3 if trial == 0 else 1.0)
    t = time.time(); sol = solve(Ycal, x0, 25)
    print('trial', trial, 'start d', np.linalg.norm(make_resid(Ycal)(x0)), 'final d', np.linalg.norm(sol.fun), 'nfev', sol.nfev, 'time %.0f' % (time.time() - t), flush=True)
