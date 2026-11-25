import sys, time, numpy as np
sys.path.insert(0, '/home/claude/hodge/discovery/checks/ex_t6'); sys.path.insert(0, '/home/claude/hodge/discovery/t6_unsolved/e')
from fex import *
from dirs_exact import *
from ana import setup
from choose import make, V0_DEFAULT
import choose
p = 32029
for lam in (2, -1):
    E, Xp = setup(p, lam); zp = E.z
    X = ExactEngine(lam); t0 = time.time()
    X.setup_L(); print("lam", lam, "exact L built", time.time() - t0, "rank L_R", X.Lrank, "kerL cols", X.kerL.ncols(), "K rows", X.K.nrows(), flush=True)
    Lp = red_real_mat(X.L, p, zp); print("  L mod p == fe L:", np.array_equal(Lp, E.L % p))
    v = v_exact(X, lam)
    vp = red_real_vec(v, p, zp)
    choose.V0_DEFAULT = None
    from ana import bOf
    vfe = (choose.v0_of(E, V0[lam]) + bOf(E, choose.M_al(A, Lf))) % p
    print("  v mod p == fe v:", np.array_equal(vp, vfe), "supp", np.count_nonzero(vp))
    T1 = X.vec_to_poly(v); t0 = time.time()
    M1 = X.MH(T1); print("  MH(T1) exact", time.time() - t0)
    print("  MH(T1) mod p == fe:", np.array_equal(red_real_mat(M1, p, zp), E.MH(E.vec_to_poly(vfe))))
    E2 = X.add((fmpq(1, 2), X.mul(T1, T1)))
    E2p = E.add((pow(2, p - 2, p), E.mul(E.vec_to_poly(vfe), E.vec_to_poly(vfe))))
    t0 = time.time(); c = X.cvec(E2); print("  cvec(E2) exact", time.time() - t0, "len E2", len(E2[0]))
    print("  cvec(T1^2/2) mod p == fe:", np.array_equal(red_real_vec(c, p, zp), E.cvec(E2p)))
    print("  L v = 0 exactly:", iszero(X.L * v))
