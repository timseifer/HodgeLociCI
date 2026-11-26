#!/usr/bin/env python3
# Claim A, independent point counts of V4 over small prime fields.
# V4 = {(A,B,C) in (F_q^{3x3})^3 : mix(A,B)=mix(A,C)=mix(B,C)=0}, where mix(X,Y) is the 9-vector of
# coefficients of s*t in the 2x2 minors of sX+tY.
import itertools, sys

def mixvec(X, Y, q):
    out = []
    for (i, k) in ((0,1),(0,2),(1,2)):
        for (j, l) in ((0,1),(0,2),(1,2)):
            out.append((X[i][j]*Y[k][l] + Y[i][j]*X[k][l] - X[i][l]*Y[k][j] - Y[i][l]*X[k][j]) % q)
    return out

def mats(q):
    for t in itertools.product(range(q), repeat=9):
        yield (t[0:3], t[3:6], t[6:9])

def linmap(X, q):
    # 9x9 matrix of Y -> mix(X,Y) (rows = 9 minors, cols = entries of Y)
    cols = []
    for e in range(9):
        Y = [[0]*3 for _ in range(3)]
        Y[e//3][e%3] = 1
        cols.append(mixvec(X, Y, q))
    return [[cols[c][r] for c in range(9)] for r in range(9)]

def rref_kernel(M, ncols, q):
    # returns (rank, basis of kernel) of matrix M (list of rows) over F_q
    M = [row[:] for row in M]
    piv = []
    r = 0
    for c in range(ncols):
        p = None
        for i in range(r, len(M)):
            if M[i][c] % q:
                p = i; break
        if p is None: continue
        M[r], M[p] = M[p], M[r]
        inv = pow(M[r][c], q-2, q)
        M[r] = [(x*inv) % q for x in M[r]]
        for i in range(len(M)):
            if i != r and M[i][c] % q:
                f = M[i][c]
                M[i] = [(x - f*y) % q for x, y in zip(M[i], M[r])]
        piv.append(c); r += 1
        if r == len(M): break
    free = [c for c in range(ncols) if c not in piv]
    ker = []
    for f in free:
        v = [0]*ncols
        v[f] = 1
        for i, c in enumerate(piv):
            v[c] = (-M[i][f]) % q
        ker.append(v)
    return r, ker

def vec2mat(v):
    return (tuple(v[0:3]), tuple(v[3:6]), tuple(v[6:9]))

def count_BC_given_A(A, q):
    """number of (B,C) with mix(A,B)=mix(A,C)=mix(B,C)=0, by enumerating B in U_A and solving for C."""
    LA = linmap(A, q)
    rA, kerA = rref_kernel(LA, 9, q)
    total = 0
    for coeffs in itertools.product(range(q), repeat=len(kerA)):
        v = [0]*9
        for cf, kv in zip(coeffs, kerA):
            if cf:
                v = [(x + cf*y) % q for x, y in zip(v, kv)]
        B = vec2mat(v)
        LB = linmap(B, q)
        r, _ = rref_kernel(LA + LB, 9, q)
        total += q**(9 - r)
    return total

def full_bruteforce(q):
    # no group theory at all: enumerate every A
    tot = 0
    for A in mats(q):
        tot += count_BC_given_A(A, q)
    return tot

def gl_order(n, q):
    r = 1
    for i in range(n): r *= (q**n - q**i)
    return r

def num_rank(m, n, r, q):
    # number of m x n matrices of rank r over F_q
    num = 1; den = 1
    for i in range(r):
        num *= (q**m - q**i)*(q**n - q**i)
        den *= (q**r - q**i)
    return num // den

def orbit_count(q):
    # A up to GL3 x GL3 (the conditions are invariant): normal forms of rank 0..3
    tot = 0
    for r in range(4):
        A = tuple(tuple(1 if (i == j and i < r) else 0 for j in range(3)) for i in range(3))
        tot += num_rank(3, 3, r, q) * count_BC_given_A(A, q)
    return tot

def predicted(q):
    # count predicted by the hand classification:
    # S1: one invertible, others zero; S2: max rank exactly 2 (13-dim piece); S3: all rank<=1 (two Segre cones)
    S1 = 3*gl_order(3, q)
    S3 = 2*(1 + (q**3-1)*(q**9-1)//(q-1)) - (1 + (q**3-1)**3//(q-1)**2)
    # 2x2 blocks: pairwise orthogonal triples for the polar form of det, brute force
    def pol(a, b):  # polarisation of det on 2x2: a = (a11,a12,a21,a22)
        return (a[0]*b[3] + b[0]*a[3] - a[1]*b[2] - b[1]*a[2]) % q
    vecs = list(itertools.product(range(q), repeat=4))
    Tall = 0; Tiso = 0
    for a in vecs:
        da = (a[0]*a[3]-a[1]*a[2]) % q
        for b in vecs:
            if pol(a, b): continue
            db = (b[0]*b[3]-b[1]*b[2]) % q
            # c orthogonal to a and b: linear conditions; count solutions and isotropic solutions
            M = [[a[3], -a[2], -a[1], a[0]], [b[3], -b[2], -b[1], b[0]]]
            r, ker = rref_kernel(M, 4, q)
            Tall += q**(4-r)
            if da == 0 and db == 0:
                for coeffs in itertools.product(range(q), repeat=len(ker)):
                    c = [0]*4
                    for cf, kv in zip(coeffs, ker):
                        c = [(x + cf*y) % q for x, y in zip(c, kv)]
                    if (c[0]*c[3]-c[1]*c[2]) % q == 0: Tiso += 1
    S2 = (q*q+q+1)**2 * (Tall - Tiso)
    return S1, S2, S3, Tall, Tiso

if __name__ == "__main__":
    for q in [int(s) for s in sys.argv[1:]]:
        oc = orbit_count(q)
        S1, S2, S3, Tall, Tiso = predicted(q)
        line = "q=%d orbit-reduced count=%d predicted=%d (S1=%d S2=%d S3=%d; Tall=%d Tiso=%d) agree=%s  count/q^13=%.4f" % (
            q, oc, S1+S2+S3, S1, S2, S3, Tall, Tiso, oc == S1+S2+S3, oc/q**13)
        print(line, flush=True)
        if q == 3:
            fb = full_bruteforce(q)
            print("q=3 full brute force over all A (no group theory): %d agree_with_orbit=%s" % (fb, fb == oc), flush=True)
