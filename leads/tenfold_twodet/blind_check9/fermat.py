# Fermat planes on the cubic tenfold: own implementation
import numpy as np, itertools, random
from math import gcd

F_TAB = {m: (1 - (-2)**(m+1))//3 for m in range(-1, 6)}   # f(m)

def all_pairings(n=12):
    res = []
    def rec(rem, cur):
        if not rem:
            res.append(tuple(cur)); return
        i = rem[0]
        for t in range(1, len(rem)):
            j = rem[t]
            rec(rem[1:t] + rem[t+1:], cur + [(i, j)])
    rec(list(range(n)), [])
    return res

PI0 = ((0,1),(2,3),(4,5),(6,7),(8,9),(10,11))
EXPS = np.array(list(itertools.product(range(3), repeat=6)), dtype=np.int64)  # 729 x 6

def plane_matrix(pi, e, w):
    M = np.zeros((6, 12), dtype=complex)
    for k, (i, j) in enumerate(pi):
        M[k, i] = 1; M[k, j] = w**int(e[k])
    return M

def dim_by_rank(pi1, e1, pi2, e2):
    w = np.exp(2j*np.pi/3)
    M = np.vstack([plane_matrix(pi1, e1, w), plane_matrix(pi2, e2, w)])
    return 11 - np.linalg.matrix_rank(M, tol=1e-9)

def rank_mod_p(rows, p):
    A = [r[:] for r in rows]; rk = 0; ncol = len(A[0])
    for c in range(ncol):
        piv = None
        for r in range(rk, len(A)):
            if A[r][c] % p: piv = r; break
        if piv is None: continue
        A[rk], A[piv] = A[piv], A[rk]
        inv = pow(A[rk][c], p-2, p)
        A[rk] = [(x*inv) % p for x in A[rk]]
        for r in range(len(A)):
            if r != rk and A[r][c] % p:
                f = A[r][c]
                A[r] = [(x - f*y) % p for x, y in zip(A[r], A[rk])]
        rk += 1
    return rk

def dim_by_rank_modp(pi1, e1, pi2, e2, p=7, w=2):
    rows = []
    for pi, e in ((pi1, e1), (pi2, e2)):
        for k, (i, j) in enumerate(pi):
            r = [0]*12; r[i] = 1; r[j] = pow(w, int(e[k]), p); rows.append(r)
    return 11 - rank_mod_p(rows, p)

def cycles(pi1, pi2):
    """cycles of the union of two perfect matchings.  Returns list of (s, t):
    s[k] = signed coefficient of exponent of k-th pair of pi1, t likewise for pi2;
    the cycle carries a nonzero solution iff s.e1 + t.e2 == 0 mod 3."""
    p1 = {}; p2 = {}
    for k, (i, j) in enumerate(pi1): p1[i] = (j, k, -1); p1[j] = (i, k, +1)
    for k, (i, j) in enumerate(pi2): p2[i] = (j, k, -1); p2[j] = (i, k, +1)
    seen = set(); out = []
    for v0 in range(12):
        if v0 in seen: continue
        s = [0]*6; t = [0]*6; v = v0
        while True:
            seen.add(v)
            u, k, sg = p1[v]; s[k] += sg; seen.add(u)
            v, k, sg = p2[u]; t[k] += sg
            if v == v0: break
        out.append((s, t))
    return out

def dim_by_cycles(pi1, e1, pi2, e2):
    c = 0
    for s, t in cycles(pi1, pi2):
        if (sum(a*int(b) for a, b in zip(s, e1)) + sum(a*int(b) for a, b in zip(t, e2))) % 3 == 0:
            c += 1
    return c - 1

def inter(pi1, e1, pi2, e2):
    return F_TAB[dim_by_cycles(pi1, e1, pi2, e2)]

FV = np.array([F_TAB[m] for m in range(-1, 6)], dtype=np.int64)   # index = number of good cycles

def inter_with_all(pi0, E0, PAIRINGS):
    """E0: (r x 6) exponent vectors on the fixed pairing pi0.
    returns int array (len(PAIRINGS), 729, r) of intersection numbers with every Fermat plane."""
    E0 = np.asarray(E0, dtype=np.int64)
    out = np.empty((len(PAIRINGS), 729, E0.shape[0]), dtype=np.int16)
    for a, pi in enumerate(PAIRINGS):
        cnt = np.zeros((729, E0.shape[0]), dtype=np.int64)
        for s, t in cycles(pi, pi0):
            A = EXPS @ np.array(s)          # 729
            B = E0 @ np.array(t)            # r
            cnt += ((A[:, None] + B[None, :]) % 3 == 0)
        out[a] = FV[cnt]
    return out

# ---- Jacobian ring representatives (R = C[x]/(x_i^2) for the Fermat cubic) ----
def perm_sign(seq):
    seq = list(seq); s = 1
    for i in range(len(seq)):
        while seq[i] != i:
            j = seq[i]; seq[i], seq[j] = seq[j], seq[i]; s = -s
    return s

def a_plane(pi, e):
    """a_P = sgn(pi) * prod_k c_k (x_i - c_k x_j), c_k = w^{e_k}; returned as dict mask -> (sign, exponent of w)"""
    sg = perm_sign([v for pr in pi for v in pr])
    terms = {0: (sg, 0)}
    for k, (i, j) in enumerate(pi):
        new = {}
        for m, (s, ex) in terms.items():
            new[m | (1 << i)] = (s, (ex + int(e[k])) % 3)
            new[m | (1 << j)] = (-s, (ex + 2*int(e[k])) % 3)
        terms = new
    return terms

FULL = (1 << 12) - 1
def K_pair(aP, aQ):
    n = [0, 0, 0]
    for m, (s, ex) in aP.items():
        q = aQ.get(FULL ^ m)
        if q is not None:
            n[(ex + q[1]) % 3] += s*q[0]
    # n0 + n1 w + n2 w^2 = (n0-n2) + (n1-n2) w
    return (n[0] - n[2], n[1] - n[2])
