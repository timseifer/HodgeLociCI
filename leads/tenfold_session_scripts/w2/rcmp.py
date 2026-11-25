# W2: compare T_VR (rhom.m2) with ker L(lambda), T Cone_T, Segre cones, and the lead directions (MOD 32029); adapted from exp_t6/v0cmp.py
import sys, numpy as np
sys.path.insert(0, '/home/claude/hodge/discovery/checks/da_t6'); sys.path.insert(0, '/home/claude/hodge/discovery/t6_unsolved/e')
from common import Ctx
from ana import bOf
p = 32029; fn = sys.argv[1]
rows = [list(map(int, l.split())) for l in open(fn) if l.strip()]
T = (np.array(rows, dtype=np.int64).T) % p
def mono(idx):
    e = [0] * 12
    for i in idx: e[i] += 1
    return tuple(e)
V0 = {-1: [(1, [7, 9, 11]), (2, [6, 8, 10]), (1, [6, 9, 11]), (-1, [7, 8, 11]), (1, [8, 9, 10])],
      2: [(1, [7, 9, 11]), (1, [6, 9, 11]), (-1, [6, 8, 11]), (1, [8, 9, 10])]}
A = [1, -1, 2]; Lf = [{1: 1}, {3: 1, 1: 1}, {5: 1}]
for lam in (-1, 2):
    C = Ctx(p, lam); E = C.E
    print('lam', lam, 'z =', C.z, flush=True)
    rT = C.rank(T)
    Tk = C.intersect(T, C.kerL)
    print('  dim T_VR =', rT, '(codim', 220 - rT, ')  rank L.T_VR =', C.rank(E.L @ T % p), ' dim T_VR n kerL =', Tk.shape[1],
          ' dim T_VR n TCone =', C.intersect(T, C.TC).shape[1], ' dim T_VR n TV_Z =', C.intersect(T, C.TV).shape[1], flush=True)
    img = C.rank(np.concatenate([Tk, C.TC], 1)) - C.TC.shape[1] if Tk.shape[1] else 0
    print('  image of T_VR n kerL in kerL/TCone (M-space): dim', img, flush=True)
    if img:
        Ms = [C.M_coords(Tk[:, k]) for k in range(Tk.shape[1])]
        Ms = [m for m in Ms if m is not None and m.any()]
        Amat = np.stack([m.reshape(27) for m in Ms], 1) % p
        R_, piv = E.rref(Amat.T); Mb = R_[:len(piv)] % p
        rng = np.random.default_rng(0)
        for t in range(3):
            m = (rng.integers(0, p, Mb.shape[0]) @ Mb % p).reshape(3, 3, 3); u = rng.integers(0, p, 3)
            mu = np.einsum('iju,u->ij', m, u) % p
            print('   random image element: rank M(u) =', C.rank(mu), ' M(u)+M(u)^T rank =', C.rank((mu + mu.T) % p),
                  ' flattenings (i|ju, j|iu, u|ij) =', C.rank(m.reshape(3, 9)), C.rank(m.transpose(1, 0, 2).reshape(3, 9)), C.rank(m.transpose(2, 0, 1).reshape(3, 9)), flush=True)
    # lead direction(s): v = v0 + bOf(a x l) and l x a
    for kind in ('al', 'la'):
        M = [[{u: (A[i] if kind == 'al' else A[j]) * c for u, c in Lf[(j if kind == 'al' else i)].items()} for j in range(3)] for i in range(3)]
        v0 = np.zeros(220, dtype=np.int64)
        for c, idx in V0[lam]: v0[C.idx[mono(idx)]] = (v0[C.idx[mono(idx)]] + c) % p
        v = (v0 + bOf(E, M)) % p
        print('  lead', kind, ': L v = 0:', not (E.L @ v % p).any(), '; v in T_VR:', C.rank(np.concatenate([T, v[:, None]], 1)) == rT,
              '; M-part of v in M-image of T_VR + TCone:', C.rank(np.concatenate([T, C.TC, v[:, None]], 1)) == C.rank(np.concatenate([T, C.TC], 1)), flush=True)
