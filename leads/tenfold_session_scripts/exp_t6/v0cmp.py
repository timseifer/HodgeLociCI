# EXP-T6 (v-c): compare T_V0 (from v0hom.m2) with ker L(lambda), T Cone_T, Segre cones (MOD 32029)
import sys, numpy as np
sys.path.insert(0, '/home/claude/hodge/discovery/checks/da_t6'); sys.path.insert(0, '/home/claude/hodge/discovery/t6_unsolved/e')
from common import Ctx
p = 32029; fn = sys.argv[1]
rows = [list(map(int, l.split())) for l in open(fn) if l.strip()]
T = (np.array(rows, dtype=np.int64).T) % p   # 220 x n
for lam in (-1, 2):
    C = Ctx(p, lam); E = C.E
    rT = C.rank(T)
    LT = E.L @ T % p
    Tk = C.intersect(T, C.kerL)
    print('lam', lam, ': dim T_V0 =', rT, '(codim', 220 - rT, ')  rank L.T_V0 =', C.rank(LT), ' dim T_V0 n kerL =', Tk.shape[1], flush=True)
    if lam == -1:
        TkC = C.intersect(Tk, C.TC)
        img = C.rank(np.concatenate([Tk, C.TC], 1)) - C.TC.shape[1]
        print('   dim T_V0 n kerL n TCone =', TkC.shape[1], '; image in kerL/TCone (M-space) dim =', img, flush=True)
        # basis of image M's: project
        if img > 0:
            Ms = []
            for k in range(Tk.shape[1]):
                m = C.M_coords(Tk[:, k])
                if m is not None and m.any(): Ms.append(m)
            A = np.stack([m.reshape(27) for m in Ms], 1) % p
            R_, piv = E.rref(A.T); Mb = R_[:len(piv)] % p
            print('   M-image basis size', Mb.shape[0])
            rng = np.random.default_rng(0)
            for t in range(3):
                m = (rng.integers(0, p, Mb.shape[0]) @ Mb % p).reshape(3, 3, 3)
                u = rng.integers(0, p, 3)
                print('   random image element: rank M(u) =', C.rank(np.einsum('iju,u->ij', m, u) % p),
                      ' flattenings (i|ju, j|iu, u|ij) =', C.rank(m.reshape(3, 9)), C.rank(m.transpose(1, 0, 2).reshape(3, 9)), C.rank(m.transpose(2, 0, 1).reshape(3, 9)))
            for i in range(Mb.shape[0]):
                m = Mb[i].reshape(3, 3, 3)
                print('   basis M', i, ': flattenings', C.rank(m.reshape(3, 9)), C.rank(m.transpose(1, 0, 2).reshape(3, 9)), C.rank(m.transpose(2, 0, 1).reshape(3, 9)), ' nonzero (i,j,u):', [tuple(x) for x in np.argwhere(m)][:9])
