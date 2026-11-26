#!/usr/bin/env python3
# Extras for claims D and E (own code).
import sys, itertools
sys.path.insert(0, "/home/claude/blind_check10")
from fractions import Fraction as Fr

# ---------------------------------------------------------------- (1) Chern number: T3.T3 on the sixfold Z = {det A + det B = 0} in P^7
# T3 = {rows 1,2 of A dependent, rows 1,2 of B dependent} is isomorphic to the complete intersection of 3 divisors of type
# (1,1,0) and 3 of type (1,0,1) in M = P^7 x P^1 x P^1.  c(N_{T3/Z}) = (1+h+a)^3 (1+h+b)^3 / ((1+3h)(1+a)^2(1+b)^2).
# truncated polynomials in h,a,b: dict (i,j,k) -> coeff, with h^8 = a^2 = b^2 = 0
def trunc_mul(p, q, hmax):
    r = {}
    for (i1, j1, k1), c1 in p.items():
        for (i2, j2, k2), c2 in q.items():
            i, j, k = i1+i2, j1+j2, k1+k2
            if i > hmax or j > 1 or k > 1: continue
            r[(i, j, k)] = r.get((i, j, k), 0) + c1*c2
    return {m: c for m, c in r.items() if c != 0}
def power(p, n, hmax):
    r = {(0,0,0): Fr(1)}
    for _ in range(n): r = trunc_mul(r, p, hmax)
    return r
def inverse(p, hmax):
    # p = 1 + n, n nilpotent: 1/(1+n) = sum (-n)^k
    n = {m: -c for m, c in p.items() if m != (0,0,0)}
    r = {(0,0,0): Fr(1)}; t = {(0,0,0): Fr(1)}
    for _ in range(hmax + 3):
        t = trunc_mul(t, n, hmax)
        for m, c in t.items(): r[m] = r.get(m, 0) + c
    return r
def self_int(N, extra_h, d=3):
    # T = c.i. in P^N x P^1 x P^1 of extra_h hyperplanes, 3 x (1,1,0), 3 x (1,0,1); X = degree d hypersurface of dim N-1;
    # dim T = N + 2 - extra_h - 6 must be (N-1)/2.  Returns int_T c_top(N_{T/X}) and deg T.
    H = {(1,0,0): Fr(1)}; one = {(0,0,0): Fr(1)}
    def lin(ch, ca, cb, c0=1):
        return {(0,0,0): Fr(c0), (1,0,0): Fr(ch), (0,1,0): Fr(ca), (0,0,1): Fr(cb)}
    ha = {(1,0,0): Fr(1), (0,1,0): Fr(1)}; hb = {(1,0,0): Fr(1), (0,0,1): Fr(1)}
    cls = trunc_mul(trunc_mul(power(ha, 3, N), power(hb, 3, N), N), power(H, extra_h, N), N)
    cN = trunc_mul(power(lin(1,1,0), 3, N), power(lin(1,0,1), 3, N), N)
    cN = trunc_mul(cN, power(lin(1,0,0), extra_h, N), N)
    cN = trunc_mul(cN, inverse(lin(d,0,0), N), N)
    cN = trunc_mul(cN, inverse(power(lin(0,1,0), 2, N), N), N)
    cN = trunc_mul(cN, inverse(power(lin(0,0,1), 2, N), N), N)
    dimT = N + 2 - extra_h - 6
    top = {m: c for m, c in cN.items() if sum(m) == dimT}
    val = trunc_mul(top, cls, N).get((N,1,1), 0)
    deg = trunc_mul(power(H, dimT, N), cls, N).get((N,1,1), 0)
    return val, deg, dimT
v, deg, dimT = self_int(7, 0)
print("(1) sixfold: dim T3 = %d, deg T3 = %s, T3.T3 = %s, delta6^2 = T3.T3 - 27 = %s" % (dimT, deg, v, v - 27))
print("    => by the cone formula (cone a, cone b) = 4 (a,b) - deg a deg b:  T5.T5 = %s, delta^2 = T5.T5 - 27 = %s = 4 * delta6^2" % (4*v - 81, 4*v - 81 - 27))

# ---------------------------------------------------------------- (2) test of the one-step cone formula on linear spaces
def planes(k, m, d=3):   # two k-planes meeting in P^m on a smooth 2k-fold of degree d
    return Fr(1 - (1-d)**(m+1), d)
ok1 = all(planes(k+1, m+1) == -2*planes(k, m) + 1 for k in range(0, 8) for m in range(-1, k+1))
ok2 = all(planes(k+2, m+2) == 4*planes(k, m) - 1 for k in range(0, 8) for m in range(-1, k+1))
print("(2) linear spaces: one-step formula (cone a, cone b) = -2 (a,b) + deg a deg b holds for all k<=7, m=-1..k:", ok1,
      "; two-step formula 4 (a,b) - deg a deg b:", ok2)
print("    sample values (k,m,(a,b)):", [(k, m, str(planes(k, m))) for (k, m) in ((1,1),(1,0),(1,-1),(2,2),(2,1),(2,0),(3,3),(3,0),(5,5),(5,2))])

# ---------------------------------------------------------------- (3) h-vector of S/Ann([P1]-[P2]) at the Fermat cubic tenfold
from B_own import period_poly, padd, rank_Qz, ZERO, ONE, iszero
nv = 12
P1 = [(0,1,1),(2,3,1),(4,5,1),(6,7,1),(8,9,1),(10,11,1)]
P2 = [(1,2,3),(3,4,3),(0,5,3),(6,7,1),(8,9,3),(10,11,1)]
p1 = period_poly(nv, P1); p2 = period_poly(nv, P2)
def hvec(P):
    # HF(S/Ann, k) = rank of multiplication by P : R_k -> R_(k+6), R = S/(x_i^2) (Jacobian ring of the Fermat cubic)
    out = []
    for k in range(0, 4):
        rows = []
        for r in itertools.combinations(range(nv), k):
            rs = set(r)
            row = []
            for c in itertools.combinations(range(nv), k + 6):
                if rs <= set(c):
                    key = tuple(1 if (i in c and i not in rs) else 0 for i in range(nv))
                    row.append(P.get(key, ZERO))
                else:
                    row.append(ZERO)
            rows.append(row)
        out.append(rank_Qz(rows))
    return out + out[2::-1]
for name, P in (("P1-P2", padd(p1, p2, (Fr(-1), Fr(0)))), ("P1+P2", padd(p1, p2)), ("P1", p1)):
    print("(3) Fermat tenfold, class %s: Hilbert function of S/Ann in degrees 0..6 (degrees 4..6 by symmetry): %s" % (name, hvec(P)), flush=True)
print("    compare: S/I for delta = [T5] - 3h^5 has 1,10,35,52,35,10,1")

# ---------------------------------------------------------------- (4) h-vector of S/Ann([P1']-[P2']) at the Fermat cubic sixfold
# (3-planes meeting in a point; the arc's variables x0..x5,x8,x9 renamed 0..7)
nv = 8
R1 = [(0,1,1),(2,3,1),(4,5,1),(6,7,1)]
R2 = [(1,2,3),(3,4,3),(0,5,3),(6,7,3)]
r1 = period_poly(nv, R1); r2 = period_poly(nv, R2)
def hvec6(P):
    out = []
    for k in range(0, 3):
        rows = []
        for r in itertools.combinations(range(nv), k):
            rs = set(r); row = []
            for c in itertools.combinations(range(nv), k + 4):
                if rs <= set(c):
                    row.append(P.get(tuple(1 if (i in c and i not in rs) else 0 for i in range(nv)), ZERO))
                else: row.append(ZERO)
            rows.append(row)
        out.append(rank_Qz(rows))
    return out + out[1::-1]
print("(4) Fermat sixfold, class P1'-P2' (3-planes meeting in a point): Hilbert function of S/Ann: %s ; compare S/(I_2(A)+I_2(B)): 1,8,18,8,1" % hvec6(padd(r1, r2, (Fr(-1), Fr(0)))))
print("    class P1'+P2': %s" % hvec6(padd(r1, r2)))
# (5) the 'virtual' number for T5 in the big family (T5 is singular there, so this is NOT T5.T5; printed for information)
v5, deg5, dim5 = self_int(11, 2)
print("(5) big family: int over the resolution of T5 of c_5(f^*T_X - T): %s (deg %s, dim %s); T5.T5 from the cone formula is -21" % (v5, deg5, dim5))
