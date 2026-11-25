# EX-T6: the explicit directions, EXACT (realified Q(z) vectors over the 220 squarefree cubics)
from fex import *
V0 = {2: [(1, [7, 9, 11]), (1, [6, 9, 11]), (-1, [6, 8, 11]), (1, [8, 9, 10])],
      -1: [(1, [7, 9, 11]), (2, [6, 8, 10]), (1, [6, 9, 11]), (-1, [7, 8, 11]), (1, [8, 9, 10])]}
A = [1, -1, 2]
Lf = [{1: 1}, {3: 1, 1: 1}, {5: 1}]

def mono(idx):
    e = [0] * 12
    for i in idx: e[i] += 1
    return tuple(e)

def dict_to_real(X, d):
    """d: monomial -> (a, b) meaning a + b z; drops non-squarefree monomials (in J_3), as ana.poly_dict_to_vec"""
    A_ = [Q0] * X.nm; B_ = [Q0] * X.nm
    for e, (a, b) in d.items():
        if max(e) <= 1:
            i = X.mons.index(e); A_[i] += fmpq(a); B_[i] += fmpq(b)
    return np_to_mat(np.array(A_ + B_, dtype=object))

def v0_exact(X, lam):
    d = {}
    for c, idx in V0[lam]:
        a, b = d.get(mono(idx), (0, 0)); d[mono(idx)] = (a + c, b)
    return dict_to_real(X, d)

def bOf_exact(X, M):
    """M[i][j] = dict u -> integer coeff; b = sum f_i h_j M_ij, f_i = x_(6+2i) - z x_(7+2i), h_j = x_(6+2j) + x_(7+2j)"""
    d = {}
    for i in range(3):
        for j in range(3):
            fi = {mono([6 + 2 * i]): (1, 0), mono([7 + 2 * i]): (0, -1)}
            hj = {mono([6 + 2 * j]): (1, 0), mono([7 + 2 * j]): (1, 0)}
            for uk, cu in M[i][j].items():
                for e1, c1 in fi.items():
                    for e2, c2 in hj.items():
                        e = tuple(a + b for a, b in zip(e1, e2))
                        e = tuple(a + (1 if k == uk else 0) for k, a in enumerate(e))
                        c = zmul(c1, c2); c = (c[0] * cu, c[1] * cu)
                        a0, b0 = d.get(e, (0, 0)); d[e] = (a0 + c[0], b0 + c[1])
    return dict_to_real(X, d)

def M_al(a, l):
    return [[{u: a[i] * c for u, c in l[j].items()} for j in range(3)] for i in range(3)]

import os
KIND = os.environ.get('EXT6_KIND', 'al')   # 'al': M_ij = a_i l_j (default); 'la': M_ij = a_j l_i (other Segre cone)

def M_la(a, l):
    return [[{u: a[j] * c for u, c in l[i].items()} for j in range(3)] for i in range(3)]

def M_of(a, l):
    return M_al(a, l) if KIND == 'al' else M_la(a, l)

def v_exact(X, lam):
    return v0_exact(X, lam) + bOf_exact(X, M_of(A, Lf))

def segre_tangent(X):
    """T_b Segre(a x l) at b = bOf(a x l): bOf(e_i x l) and bOf(a x e_(j,u)); 12 realified vectors (span 11 over Q(z))"""
    out = []
    for i in range(3):
        ai = [1 if k == i else 0 for k in range(3)]
        out.append(bOf_exact(X, M_of(ai, Lf)))
    for j in range(3):
        for u in (1, 3, 5):
            lj = [({u: 1} if k == j else {}) for k in range(3)]
            out.append(bOf_exact(X, M_of(A, lj)))
    return out

def zmul_vec(vR, n):
    """multiply a realified Q(z) vector by z: (A, B) -> (-B, A + B)"""
    e = vR.entries(); A_ = e[:n]; B_ = e[n:]
    return np_to_mat(np.array([-b for b in B_] + [a + b for a, b in zip(A_, B_)], dtype=object))
