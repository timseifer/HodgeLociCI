# [TOOLING] (PK2): export the T Cone_T condition matrix Mc (mod p) for FRACTIONAL lambda = r/s, exactly as NF-T6's
# gen_lam.py builds it (mc_exact(ExactEngine(fmpq(r,s)), fmpq(r,s)) reduced with z index 0), for both primes.
# Not run on the cloud machine (needs the discovery checkout and python-flint):
#   EXT6=<discovery>/checks/ex_t6 python3 dev/export_mc_lam.py -4 -1/4 5 ...
# Output: inputs/mc_<p>_lam<r>[o<s>].json  (same format as ../cloud-job-1/inputs/mc_*.json, plus 'lam_str').
import os, sys, json, time
sys.path.insert(0, os.environ['EXT6'])
from flint import fmpq
from fex import ExactEngine, red_real_mat
from mc_exact import mc_exact
HERE = os.path.dirname(os.path.abspath(__file__))
roots = json.load(open(os.path.join(HERE, '..', '..', 'cloud-job-1', 'inputs', 'primes.json')))['roots_of_z2_minus_z_plus_1']
for lamstr in sys.argv[1:]:
    t = time.time()
    r, s = (lamstr.split('/') + ['1'])[:2]; r = int(r); s = int(s)
    lamq = fmpq(r, s)
    XX = ExactEngine(lamq); Mc_ex, _ = mc_exact(XX, lamq)
    for p in (67108837, 67108819):
        zp = roots[str(p)][0]
        Mc = red_real_mat(Mc_ex, p, zp)
        out = os.path.join(HERE, '..', 'inputs', 'mc_%d_lam%s.json' % (p, lamstr.replace('/', 'o')))
        json.dump({'p': p, 'zidx': 0, 'z': int(zp), 'lam': r * pow(s, p - 2, p) % p, 'lam_str': lamstr, 'r': r, 's': s,
                   'Mc': [[int(x) for x in row] for row in Mc],
                   'note': 'T Cone_T conditions (mc_exact of checks/ex_t6 at lambda = r/s, reduced mod p), as in nf_t6/gen_lam.py'}, open(out, 'w'))
        print('wrote', out, len(Mc), 'x', len(Mc[0]), '%.0fs' % (time.time() - t), flush=True)
