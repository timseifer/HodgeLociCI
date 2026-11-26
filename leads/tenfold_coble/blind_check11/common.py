# Common definitions for the blind check (written from the task statement only).
# Exact arithmetic.  Coordinates: index 0..8 = z0,z1,z2,p0,p1,p2,q0,q1,q2.
from fractions import Fraction as Fr
import itertools

LAM = Fr(-2)
XX = [Fr(8), Fr(18), Fr(1)]
NAMES = ['z0', 'z1', 'z2', 'p0', 'p1', 'p2', 'q0', 'q1', 'q2']
N = 9


def hval(v, lam=LAM):
    return v[0] ** 3 + v[1] ** 3 + v[2] ** 3 + 3 * lam * v[0] * v[1] * v[2]


A0 = -hval(XX) / (27 * (1 + LAM ** 3))


def build_F_monomials():
    """F as dict {sorted index triple (i<=j<=k): coefficient}."""
    mon = {}

    def add(idx, c):
        key = tuple(sorted(idx))
        mon[key] = mon.get(key, Fr(0)) + c

    def add_h(off, scale):
        for i in range(3):
            add((off + i, off + i, off + i), scale)
        add((off, off + 1, off + 2), scale * 3 * LAM)

    add_h(0, A0)   # a0*h(z)
    add_h(3, Fr(1))  # h(p)
    add_h(6, Fr(1))  # h(q)
    for i in range(3):
        for j in range(3):
            add(((i + j) % 3, 3 + i, 6 + j), XX[(i - j) % 3])
    return {k: c for k, c in mon.items() if c != 0}


FMON = build_F_monomials()


def build_T3():
    """T3[i][j][k] = d^3 F / dy_i dy_j dy_k (constant, fully symmetric)."""
    T = [[[Fr(0)] * N for _ in range(N)] for _ in range(N)]
    for (i, j, k), c in FMON.items():
        # d^3/d(i)d(j)d(k) of c*y_i*y_j*y_k = c * (product of factorials of multiplicities)
        from math import factorial
        from collections import Counter
        mult = 1
        for m in Counter((i, j, k)).values():
            mult *= factorial(m)
        for perm in set(itertools.permutations((i, j, k))):
            T[perm[0]][perm[1]][perm[2]] = c * mult
    return T


T3 = build_T3()
# sparse list of nonzero entries
T3S = [(i, j, k, T3[i][j][k]) for i in range(N) for j in range(N) for k in range(N) if T3[i][j][k] != 0]

A_PT = [Fr(c) for c in (0, 1, -1, 1, 2, 3, -1, -3, -2)]


def tri(u, v, w, zero):
    """sum T3[i][j][k] u_i v_j w_k  ( = 6*Phi(u,v,w), Phi the symmetric trilinear form of F)."""
    s = zero
    for i, j, k, c in T3S:
        s = s + (u[i] * v[j]) * w[k] * c
    return s


def Fval(y, zero):
    """F(y) by direct monomial evaluation (independent of T3)."""
    s = zero
    for (i, j, k), c in FMON.items():
        s = s + (y[i] * y[j]) * y[k] * c
    return s


def grad(y, zero):
    """gradient of F at y: (1/2) T3(y,y,.)"""
    g = [zero] * N
    for i, j, k, c in T3S:
        g[i] = g[i] + (y[j] * y[k]) * (c / 2)
    return g


def hess(y, zero):
    """Hessian of F at y: T3(.,.,y)."""
    H = [[zero] * N for _ in range(N)]
    for i, j, k, c in T3S:
        H[i][j] = H[i][j] + y[k] * c
    return H


def hess_vec(u, v, zero):
    """vector T3(u,v,.) = Hess F(u) v."""
    g = [zero] * N
    for i, j, k, c in T3S:
        g[k] = g[k] + (u[i] * v[j]) * c
    return g


# ---------- generic exact linear algebra over a field ----------
def rref(M, zero, one, iszero=lambda a: a == 0):
    """Row reduce (list of lists of field elements). Returns (R, pivots)."""
    M = [row[:] for row in M]
    nr = len(M)
    nc = len(M[0]) if nr else 0
    piv = []
    r = 0
    for c in range(nc):
        p = None
        for i in range(r, nr):
            if not iszero(M[i][c]):
                p = i
                break
        if p is None:
            continue
        M[r], M[p] = M[p], M[r]
        inv = one / M[r][c]
        M[r] = [e * inv for e in M[r]]
        for i in range(nr):
            if i != r and not iszero(M[i][c]):
                f = M[i][c]
                M[i] = [a - f * b for a, b in zip(M[i], M[r])]
        piv.append(c)
        r += 1
        if r == nr:
            break
    return M, piv


def rank(M, zero, one, iszero=lambda a: a == 0):
    return len(rref(M, zero, one, iszero)[1])


def nullspace(M, zero, one, iszero=lambda a: a == 0):
    """Basis of {v : M v = 0} as list of vectors."""
    R, piv = rref(M, zero, one, iszero)
    nc = len(M[0])
    free = [c for c in range(nc) if c not in piv]
    basis = []
    for f in free:
        v = [zero] * nc
        v[f] = one
        for r, pc in enumerate(piv):
            v[pc] = zero - R[r][f]
        basis.append(v)
    return basis


def matvec(M, v, zero):
    out = []
    for row in M:
        s = zero
        for a, b in zip(row, v):
            s = s + a * b
        out.append(s)
    return out


def dot(u, v, zero):
    s = zero
    for a, b in zip(u, v):
        s = s + a * b
    return s


# ---------- data from the statement ----------
PI_ROWS = [(Fr(11, 3), Fr(-10, 3), Fr(1, 3)), (Fr(-31, 3), Fr(20, 3), Fr(-5, 3)), (Fr(10, 3), Fr(-5, 3), Fr(2, 3)),
           (Fr(7), Fr(5), Fr(-4)), (Fr(-5, 9), Fr(-119, 9), Fr(44, 9)), (Fr(-49, 9), Fr(247, 18), Fr(-44, 9)),
           (Fr(59, 9), Fr(-257, 18), Fr(46, 9)), (Fr(85, 9), Fr(79, 9), Fr(-28, 9)), (Fr(13), Fr(-15), Fr(8))]
L_ROWS = [(3, -2, -1, 0), (-3, -2, -1, 3), (-1, 3, 1, -3), (0, 1, -3, -2), (3, -1, 0, 1), (3, 0, 0, 1), (3, -1, 0, -1),
          (1, 2, -2, 1), (-2, 2, -1, 2)]
L_ROWS = [tuple(Fr(c) for c in r) for r in L_ROWS]


def cols(rows):
    return [[rows[i][j] for i in range(len(rows))] for j in range(len(rows[0]))]


PI_COLS = cols(PI_ROWS)   # three vectors in Q^9
L_COLS = cols(L_ROWS)     # four vectors in Q^9

# iota: z1<->z2, p0<->q0, p1<->q2, p2<->q1  (as permutation of coordinate indices)
IOTA = {0: 0, 1: 2, 2: 1, 3: 6, 6: 3, 4: 8, 8: 4, 5: 7, 7: 5}


def unit(i):
    v = [Fr(0)] * N
    v[i] = Fr(1)
    return v


def vsub(u, v):
    return [a - b for a, b in zip(u, v)]


def vadd(u, v):
    return [a + b for a, b in zip(u, v)]


ODD = [vsub(unit(1), unit(2)), vsub(unit(3), unit(6)), vsub(unit(4), unit(8)), vsub(unit(5), unit(7))]
EVEN = [unit(0), vadd(unit(1), unit(2)), vadd(unit(3), unit(6)), vadd(unit(4), unit(8)), vadd(unit(5), unit(7))]


def kernel_T():
    """H_a, and a basis (a, v1, v2) of T = ker H_a with v1, v2 chosen canonically (rref nullspace, completed)."""
    Ha = hess(A_PT, Fr(0))
    ns = nullspace(Ha, Fr(0), Fr(1))
    return Ha, ns
