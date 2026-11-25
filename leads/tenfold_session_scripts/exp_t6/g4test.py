# EXP-T6 (v): order-4 form G4 on special normal types (MOD p). K.c_4 with particular T2, T3 (G2 = G3 = 0 on ker L).
import sys, numpy as np
sys.path.insert(0, '/home/claude/hodge/discovery/checks/exp_t6')
sys.path.insert(0, '/home/claude/hodge/discovery/t6_unsolved/e')
from run2x import build
from ana import setup, bOf, directions
p = int(sys.argv[1]); lam = int(sys.argv[2])
E, X = setup(p, lam)
rng = np.random.default_rng(7)
v0, _ = directions(E, X, rng, 'cone')
Kc_ = E.kernel(X['Mc'] % p)
def g4(v):
    Ts, Kc, MHs = build(E, v % p, {}, 4)
    return np.count_nonzero(Kc[4])
def Mof(T):  # T[i][j][k] coefficient of u_k (k=0,1,2 -> vars 1,3,5)
    return [[{u: int(T[i, j, k]) for k, u in enumerate((1, 3, 5)) if T[i, j, k]} for j in range(3)] for i in range(3)]
R = lambda *s: rng.integers(1, 40, size=s)
for trial in range(2):
    vc = Kc_ @ rng.integers(0, p, Kc_.shape[1]) % p   # generic element of T Cone_T
    l = R(3); N3 = R(3, 3); a = R(3); c = R(3); N2 = np.outer(R(3), R(3)) + np.outer(R(3), R(3))
    cases = {
      'x1*N3': np.einsum('ij,k->ijk', N3, np.array([1, 0, 0])),
      'l*N3': np.einsum('ij,k->ijk', N3, l),
      'l*N2': np.einsum('ij,k->ijk', N2, l),
      'a x l (control)': np.einsum('i,jk->ijk', a, R(3, 3)),
      'l x a (control)': np.einsum('j,ik->ijk', a, R(3, 3)),
      'generic (control)': R(3, 3, 3),
    }
    for name, T in cases.items():
        b = bOf(E, Mof(T))
        print(trial, name, ' pure-y v0: nnz K.c4 =', g4(v0 + b), '  generic TCone v: nnz K.c4 =', g4(vc + b), flush=True)
