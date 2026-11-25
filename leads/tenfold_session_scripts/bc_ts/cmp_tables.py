# [BC-TS] compare own Psi_B tables with TS-T6 tables2/ (run only after own tables were computed).
import sys, itertools, numpy as np
from bcpsi import mons, rk_scalar
p = int(sys.argv[1]); z = int(sys.argv[2]); gseed = int(sys.argv[3]); fn = sys.argv[4]
Z = np.load(fn); PB1, PB2, OFF = Z['PB1'], Z['PB2'], Z['OFF']
mine = np.load('psiB_bc_g%d_%d_D21.npz' % (gseed, p))
def their_mons(d):
    res = [(d - sum(e),) + e for e in itertools.product(range(d + 1), repeat=5) if sum(e) <= d]
    res.sort(key=lambda e: sum(x << (5 * j) for j, x in enumerate(e))); return res
rng = np.random.default_rng(2026)
for d in range(0, 22, 3):
    tm = their_mons(d); assert len(tm) == OFF[d + 1] - OFF[d]
    for name, T in (("Q1", PB1), ("Q2", PB2)):
        mv = mine['%s_%d' % (name, d)]
        theirs = T[OFF[d]:OFF[d + 1]] % p
        mine_in_their_order = np.array([mv[rk_scalar(e)] for e in tm], np.int64)
        full = np.array_equal(mine_in_their_order, theirs)
        samp = rng.choice(len(tm), min(200, len(tm)), replace=False)
        sam = int(sum(mine_in_their_order[i] == theirs[i] for i in samp))
        print("deg %2d %s: random sample %d/%d equal; full table equal: %s; nonzero entries %d" % (d, name, sam, len(samp), full, np.count_nonzero(mv)))
