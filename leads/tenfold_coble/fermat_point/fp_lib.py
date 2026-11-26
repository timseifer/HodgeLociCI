# Direct evaluation of the Fermat period functional on Q * M^n for a 9-term trilinear M (AI-written, unreviewed).
# Coordinates x_0..x_11 of the Fermat cubic tenfold, grouped as
#   r_k = x_(2k), y_k = x_(2k+1) (k = 0,1,2);   p_i = x_(6+2i), q_i = x_(7+2i) (i = 0,1,2),
# so the pairing of tooling/fermat_series, (0,1)(2,3)...(10,11), is (r_k, y_k) and (p_i, q_i).
#   M = sum_{i,j} c_ij y_((i+j) mod 3) p_i q_j;   the Heisenberg tensor M_x has c_ij = x_((i-j) mod 3).
# Period functional of a torus eigenclass with residue pattern rho in {0,1}^12, |rho| = 6 (closed form, same
# convention as tooling/fermat_series/fe_ref.py):
#   Psi_rho(x^g) = prod_j ((1+rho_j)/3)_(m_j)  if g = 3m + rho,  else 0.
# All sums below drop the common factor 3^(-sum m_j) (it depends only on n and deg Q).
import numpy as np, itertools, math
from functools import lru_cache

NV = 12
R_IDX = [0, 2, 4]; Y_IDX = [1, 3, 5]; P_IDX = [6, 8, 10]; Q_IDX = [7, 9, 11]
IJ = [(i, j) for i in range(3) for j in range(3)]            # the 9 monomials y_(i+j) p_i q_j

def forms():
    """the form 1 and the 220 squarefree cubics, as 0/1 exponent vectors"""
    out = [np.zeros(NV, dtype=np.int64)]
    for c in itertools.combinations(range(NV), 3):
        e = np.zeros(NV, dtype=np.int64); e[list(c)] = 1; out.append(e)
    return out

@lru_cache(maxsize=None)
def _comp(n, k):
    if k == 1: return np.full((1, 1), n, dtype=np.int16)
    parts = []
    for a in range(n + 1):
        sub = _comp(n - a, k - 1)
        parts.append(np.concatenate([np.full((len(sub), 1), a, dtype=np.int16), sub], axis=1))
    return np.concatenate(parts)

def compositions(n):
    """all (n_ij) >= 0 with sum n: array (binomial(n+8,8), 9)"""
    return _comp(n, 9)

# incidence matrices: exponents of M^n-monomials from the composition
INC = np.zeros((9, NV), dtype=np.int64)       # exponent vector in x_0..x_11
INC_D = np.zeros((9, 3), dtype=np.int64)      # exponents of x_0, x_1, x_2 (the parameters) for the Heisenberg tensor
for t, (i, j) in enumerate(IJ):
    INC[t, Y_IDX[(i + j) % 3]] += 1; INC[t, P_IDX[i]] += 1; INC[t, Q_IDX[j]] += 1
    INC_D[t, (i - j) % 3] += 1

def patterns55():
    """all residue patterns rho in {0,1}^12 with six ones; returns list and dict rho-code -> index"""
    pats = [c for c in itertools.combinations(range(NV), 6)]
    idx = {}
    for t, c in enumerate(pats):
        idx[sum(1 << a for a in c)] = t
    return pats, idx

def poch_table(p, mmax=64):
    """T[rho, m] = prod_{l<m} (1 + rho + 3 l) mod p"""
    T = np.ones((2, mmax), dtype=np.int64)
    for r in range(2):
        for m in range(1, mmax):
            T[r, m] = T[r, m - 1] * ((1 + r + 3 * (m - 1)) % p) % p
    return T

def poch_int(r, m):
    v = 1
    for l in range(m): v *= (1 + r + 3 * l)
    return v

def multinomial_int(row):
    n = int(sum(int(a) for a in row)); v = math.factorial(n)
    for a in row: v //= math.factorial(int(a))
    return v

def fact_tables(p, nmax=200):
    f = [1] * (nmax + 1)
    for i in range(1, nmax + 1): f[i] = f[i - 1] * i % p
    fi = [pow(v, p - 2, p) for v in f]
    return np.array(f, dtype=np.int64), np.array(fi, dtype=np.int64)

def kappa_sign(rho):
    """the three-plane class h^5 - P1 - P2 - P3, up to a factor that depends only on rho restricted to r:
    +1 / -1 on its two (p,q)-patterns, 0 elsewhere.  rho: array (..., 12).  Needs pair structure on (r_k, y_k)."""
    rho = np.asarray(rho)
    ok = np.ones(rho.shape[:-1], dtype=bool)
    for k in range(3): ok &= (rho[..., R_IDX[k]] + rho[..., Y_IDX[k]] == 1)
    A = ok & np.all(rho[..., P_IDX] == 0, axis=-1) & np.all(rho[..., Q_IDX] == 1, axis=-1)
    B = ok & np.all(rho[..., P_IDX] == 1, axis=-1) & np.all(rho[..., Q_IDX] == 0, axis=-1)
    return B.astype(np.int64) - A.astype(np.int64)

def plane_class_vector(p, z, planes, pats):
    """vector over the 924 patterns of sum_coef coef * prod_pairs (3c or 3c^2), as in fe_ref.Engine:
    planes = list of (coef, exps) with c_k = z^exps[k] on pair k; pattern with rho_a = 0, rho_b = 1 on a pair
    takes 3c, with rho_a = 1, rho_b = 0 takes 3c^2; patterns without pair structure get 0."""
    v = np.zeros(len(pats), dtype=np.int64)
    for t, c in enumerate(pats):
        rho = [0] * NV
        for a in c: rho[a] = 1
        if any(rho[2 * k] + rho[2 * k + 1] != 1 for k in range(6)): continue
        tot = 0
        for coef, exps in planes:
            val = coef % p
            for k in range(6):
                ck = pow(z, exps[k], p)
                val = val * 3 * (ck if rho[2 * k] == 0 else ck * ck % p) % p
            tot = (tot + val) % p
        v[t] = tot
    return v

def root6(p):
    for g in range(2, p):
        a = pow(g, (p - 1) // 6, p)
        if pow(a, 3, p) != 1 and pow(a, 2, p) != 1: return a
    raise ValueError
