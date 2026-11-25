# SP-T6 helpers: build the W3 engine + EX-T6 lambda = -1 arc reduced mod p (same code path as w3/hi_order.py).
import sys, os, pickle, numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
from w3eng import W3Engine
from fe_big_copy import NV, PAIRS, unpack
from flint import fmpq
from sympy import sqrt_mod
def setup(p, zidx=0, kind='al', lam=-1):
    def red(s):
        x = fmpq(s); return int(x.p % p) * pow(int(x.q % p), p - 2, p) % p
    r = sqrt_mod(-3, p, all_roots=True); inv2 = pow(2, p - 2, p)
    zp = sorted(set((1 + x) * inv2 % p for x in r))[zidx]
    W = W3Engine(p, lam, z=zp)
    pk = os.path.join(HERE, '..', 'ex_t6', 'arc_lam1_exact%s.pkl' % ('' if kind == 'al' else '_la'))
    d = pickle.load(open(pk, 'rb'))
    Ts = [np.array([(red(T[i]) + red(T[220 + i]) * zp) % p for i in range(220)], np.int64) for T in d['Ts']]
    return W, Ts, zp
def visible_mask(W, keys):
    """True iff the monomial x^e can contribute to some MH entry: exists a residue pattern r (one exponent = 1 mod 3
    per pair, the other = 0 mod 3) with table value t_r != 0 such that s = (r - e) mod 3 is a code q + a used by MH."""
    qa = np.zeros(3 ** NV, bool); qa[W.qa_codes.ravel()] = True
    W._poch(); e = unpack(keys); rho = e % 3
    opts = []
    for (a, b) in PAIRS:
        o = []
        for (ra, rb) in ((0, 1), (1, 0)):
            o.append(((ra - rho[:, a]) % 3) * 3 ** a + ((rb - rho[:, b]) % 3) * 3 ** b)
        opts.append(o)
    import itertools
    vis = np.zeros(len(keys), bool)
    for ch in itertools.product([0, 1], repeat=6):
        if W.tabv[ch] == 0: continue
        code = sum(opts[k][ch[k]] for k in range(6))
        vis |= qa[code]
    return vis
