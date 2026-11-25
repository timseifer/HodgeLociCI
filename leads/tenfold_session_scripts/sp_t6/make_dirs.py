# SP-T6: export the generic direction of W3's gen_dirs.py (same code, same seeds) for the remote job.
# W3 task 2: FULLY generic directions v = (random element of T Cone_T, mod p) + bOf(a x l or l x a) (a, l uniform mod p).
# lambda = 2: order-6 test incl. the quadratic-freedom criterion (Lambda via the exact first-order formula);
# lambda = -1: arc to order N with top-term corrections and exact recomputation (run2 logic, own engine).
# python3 gen_dirs.py p zidx lam seed kind N
import sys, time, pickle, numpy as np
import os; H = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, H); sys.path.insert(0, os.path.join(H, '..', 'ex_t6'))
from w3eng import W3Engine
from sympy import sqrt_mod
p = int(sys.argv[1]); zidx = int(sys.argv[2]); lam = int(sys.argv[3]); seed = int(sys.argv[4]); kind = sys.argv[5]; outf = sys.argv[6]
t00 = time.time()
def say(*a): print(*a, "(%.0fs)" % (time.time() - t00), flush=True)
r = sqrt_mod(-3, p, all_roots=True); inv2 = pow(2, p - 2, p)
zp = sorted(set((1 + x) * inv2 % p for x in r))[zidx]
W = W3Engine(p, lam, z=zp); SL = W.solveL_matrix(); kerL = W.kerL; Kl = W.Kl; nk = kerL.shape[1]
WP1 = W3Engine(p, 0, z=zp)       # P1 alone
# T Cone_T conditions mod p (mc_exact reduced: entries are small integers / Z[z])
from fex import ExactEngine, red_real_mat
from mc_exact import mc_exact
XX = ExactEngine(lam); Mc_ex, _ = mc_exact(XX, lam); Mc = red_real_mat(Mc_ex, p, zp)
TCb = W.kernel(Mc)
say("p", p, "z", zp, "lam", lam, "seed", seed, "kind", kind, "rank L", W.Lrank, "dim T Cone_T", TCb.shape[1], "T Cone_T in ker L:", not (W.L @ TCb % p).any())
rng = np.random.default_rng(seed)
def mono(idx):
    e = [0] * 12
    for i in idx: e[i] += 1
    return tuple(e)
def bOf(M):
    z = W.z; d = {}
    for i in range(3):
        for j in range(3):
            fi = {mono([6 + 2 * i]): 1, mono([7 + 2 * i]): (-z) % p}
            hj = {mono([6 + 2 * j]): 1, mono([7 + 2 * j]): 1}
            for uk, cu in M[i][j].items():
                for e1, c1 in fi.items():
                    for e2, c2 in hj.items():
                        e = tuple(a + b for a, b in zip(e1, e2)); e = tuple(a + (1 if k == uk else 0) for k, a in enumerate(e))
                        d[e] = (d.get(e, 0) + c1 * c2 % p * cu) % p
    v = np.zeros(len(W.mons), np.int64)
    for e, c in d.items():
        if max(e) <= 1: v[W.mons.index(e)] = (v[W.mons.index(e)] + c) % p
    return v
a = rng.integers(1, p, 3); l = rng.integers(0, p, (3, 3))
if kind == 'al': M = [[{u: int(a[i] * l[j, k] % p) for k, u in enumerate((1, 3, 5))} for j in range(3)] for i in range(3)]
else: M = [[{u: int(a[j] * l[i, k] % p) for k, u in enumerate((1, 3, 5))} for j in range(3)] for i in range(3)]
c0 = TCb @ rng.integers(0, p, TCb.shape[1]) % p
v = (c0 + bOf(M)) % p
import json
json.dump({'p': p, 'zidx': zidx, 'z': int(zp), 'lam': lam, 'seed': seed, 'kind': kind, 'v': [int(x) for x in v], 'c0': [int(x) for x in c0],
           'Mc': [[int(x) for x in row] for row in Mc], 'note': 'direction of w3/gen_dirs.py (seed %d, kind %s), mod p' % (seed, kind)}, open(outf, 'w'))
say("wrote", outf)
