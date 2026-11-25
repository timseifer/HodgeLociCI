# W2: does a random cubic fourfold Y containing P1' u P2' (V_Z type, in the kappa branch) contain AHTV scrolls? (float LM, random starts)
import sys, time, numpy as np
from polyt import *
from lm import lm
seedY = int(sys.argv[1]); rng = np.random.default_rng(seedY)
Y = np.zeros(56, complex)
for i in range(3):
    for j in range(3):
        fh = np.zeros(21); e = [0]*6; e[i] += 1; e[3+j] += 1; fh[IDX[2][tuple(e)]] = 1
        Y += np.tensordot(np.tensordot(fh, T21, (0, 0)), rng.normal(size=6), (0, 0))
for st in range(int(sys.argv[2])):
    x0 = rng.normal(size=72) * 0.8
    t = time.time(); x, d = lm(Y, x0, iters=int(sys.argv[3]))
    print('Y seed', seedY, 'start', st, 'final d', d, 'time %.0f' % (time.time() - t), flush=True)
    np.save('vz_%d_%d.npy' % (seedY, st), x)
