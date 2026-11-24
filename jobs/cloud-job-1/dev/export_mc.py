# [TOOLING] (PK): export the T Cone_T condition matrix Mc (mod p) used by W3's gen_dirs.py, for lambda in {-1, 2}
# and both primes, so that the cloud job can generate W3-style generic directions for ANY seed without the exact
# (flint/sympy) code.  Not run on the cloud machine.  Needs the discovery checkout:
#   EXT6=<discovery>/checks/ex_t6 W3=<discovery>/checks/w3 python3 dev/export_mc.py
import os, sys, json
sys.path.insert(0, os.environ['W3']); sys.path.insert(0, os.environ['EXT6'])
from w3eng import W3Engine
from fex import ExactEngine, red_real_mat
from mc_exact import mc_exact
HERE = os.path.dirname(os.path.abspath(__file__))
roots = json.load(open(os.path.join(HERE, '..', 'inputs', 'primes.json')))['roots_of_z2_minus_z_plus_1']
for lam in (-1, 2):
    XX = ExactEngine(lam); Mc_ex, _ = mc_exact(XX, lam)
    for p in (67108837, 67108819):
        zp = roots[str(p)][0]
        Mc = red_real_mat(Mc_ex, p, zp)
        out = os.path.join(HERE, '..', 'inputs', 'mc_%d_lam%d.json' % (p, lam))
        json.dump({'p': p, 'zidx': 0, 'z': int(zp), 'lam': lam, 'Mc': [[int(x) for x in r] for r in Mc],
                   'note': 'T Cone_T conditions (mc_exact of checks/ex_t6 reduced mod p), as in w3/gen_dirs.py'}, open(out, 'w'))
        print('wrote', out, len(Mc), 'x', len(Mc[0]))
