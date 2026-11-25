# [BC-TS] (AI-generated, unreviewed) blind checker: own modular linear algebra (numpy int64, p < 2^26).
import numpy as np

def rref(A, p):
    A = np.array(A, dtype=np.int64) % p
    nr, nc = A.shape
    piv = []; r = 0
    for c in range(nc):
        if r == nr: break
        col = A[r:, c]
        nz = np.flatnonzero(col)
        if len(nz) == 0: continue
        k = r + nz[0]
        if k != r: A[[r, k]] = A[[k, r]]
        A[r] = A[r] * pow(int(A[r, c]), p - 2, p) % p
        others = np.flatnonzero(A[:, c]); others = others[others != r]
        if len(others):
            A[others] = (A[others] - A[others, c][:, None] * A[r][None, :]) % p
        piv.append(c); r += 1
    return A[:r], piv

def rank(A, p):
    A = np.asarray(A)
    if A.size == 0: return 0
    return len(rref(A, p)[1])

def kernel(A, p):
    """columns spanning {x : A x = 0}"""
    A = np.asarray(A, dtype=np.int64)
    nc = A.shape[1]
    R, piv = rref(A, p)
    ps = set(piv); free = [c for c in range(nc) if c not in ps]
    K = np.zeros((nc, len(free)), np.int64)
    for j, fc in enumerate(free):
        K[fc, j] = 1
        for i, c in enumerate(piv): K[c, j] = (-R[i, fc]) % p
    return K

def solve(A, b, p):
    A = np.asarray(A, dtype=np.int64); nc = A.shape[1]
    R, piv = rref(np.concatenate([A % p, (np.asarray(b, np.int64) % p)[:, None]], 1), p)
    if piv and piv[-1] == nc: return None
    x = np.zeros(nc, np.int64)
    for i, c in enumerate(piv): x[c] = R[i, nc]
    return x

def in_span(A, b, p):
    return rank(np.concatenate([np.asarray(A) % p, (np.asarray(b) % p)[:, None]], 1), p) == rank(A, p)

def mm(A, B, p, ch=256):
    A = np.asarray(A, np.int64) % p; B = np.asarray(B, np.int64) % p
    out = np.zeros((A.shape[0],) + B.shape[1:], np.int64)
    for i in range(0, A.shape[1], ch):
        out = (out + A[:, i:i + ch] @ B[i:i + ch] % p) % p
    return out
