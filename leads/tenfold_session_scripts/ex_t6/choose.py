# EX-T6: explicit small-data directions v = v0 + bOf(a x l), screened MOD p with step (e)'s run2 logic (copy run2x.py).
import sys, numpy as np
sys.path.insert(0, '/home/claude/hodge/discovery/checks/ex_t6'); sys.path.insert(0, '/home/claude/hodge/discovery/t6_unsolved/e')
from ana import setup, bOf, mono, poly_dict_to_vec
import run2x

def v0_of(E, terms):
    # terms: list of (coef, [indices]) pure-y squarefree monomials, integer coefficients
    d = {}
    for c, idx in terms: d[mono(idx)] = d.get(mono(idx), 0) + c
    return poly_dict_to_vec(E, d)

def M_al(a, l):
    # l: list of 3 dicts u->c (u in 1,3,5); M_ij = a_i l_j
    return [[{u: a[i] * c for u, c in l[j].items()} for j in range(3)] for i in range(3)]

def make(E, X, V0, a, l):
    p = E.p
    v0 = v0_of(E, V0) % p
    b = bOf(E, M_al(a, l)) % p
    v = (v0 + b) % p
    info = dict(Lv=int(np.count_nonzero(E.L @ v % p)), Mc_v0=int(np.count_nonzero(X['Mc'] % p @ v0 % p)),
                Mc_v=int(np.count_nonzero(X['Mc'] % p @ v % p)),
                v0_notTV=E.rank(np.concatenate([X['TV'] % p, v0[:, None]], 1)) > E.rank(X['TV'] % p),
                v_notTV=E.rank(np.concatenate([X['TV'] % p, v[:, None]], 1)) > E.rank(X['TV'] % p),
                supp=int(np.count_nonzero(v)))
    return v, info

V0_DEFAULT = {2: [(1, [7, 9, 11]), (1, [6, 8, 10]), (1, [6, 7, 9]), (1, [8, 9, 10]), (1, [10, 11, 7])],
              -1: [(1, [7, 9, 11]), (1, [6, 8, 10]), (1, [6, 7, 9]), (1, [8, 9, 10]), (1, [10, 11, 7])]}
A_DEFAULT = [1, 1, 2]
L_DEFAULT = [{1: 1}, {3: 1}, {5: 1, 1: 1}]

if __name__ == '__main__':
    p, lam, N = int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3])
    E, X = setup(p, lam)
    # check l_lambda against Mc's hodge row
    v, info = make(E, X, V0_DEFAULT[lam], A_DEFAULT, L_DEFAULT)
    print("p", p, "lam", lam, info, flush=True)
    run2x.run(p, lam, 0, 'ex', N, v=v)
