#!/usr/bin/env python3 -I
# Claim A: point count of V4 over F_q for larger q (same definitions as A_count.py, imported), with A reduced to
# GL3 x GL3 normal forms and, for A = 0, B reduced to normal forms as well.
import sys, itertools
sys.path.insert(0, "/home/claude/blind_check10")
from A_count import linmap, rref_kernel, vec2mat, num_rank, gl_order, count_BC_given_A

def normal(r):
    return tuple(tuple(1 if (i == j and i < r) else 0 for j in range(3)) for i in range(3))

def orbit_count(q):
    tot = 0
    # A = 0: pairs (B,C) with mix(B,C)=0; B up to equivalence, C in the kernel of a linear map
    s = 0
    for r in range(4):
        rk, _ = rref_kernel(linmap(normal(r), q), 9, q)
        s += num_rank(3, 3, r, q) * q**(9 - rk)
    tot += s
    for r in range(1, 4):
        tot += num_rank(3, 3, r, q) * count_BC_given_A(normal(r), q)
    return tot

def predicted(q):
    S1 = 3*gl_order(3, q)
    S3 = 2*(1 + (q**3-1)*(q**9-1)//(q-1)) - (1 + (q**3-1)**3//(q-1)**2)
    # pairwise orthogonal triples of 2x2 matrices for the polar form of det; coordinates (a11,a12,a21,a22)
    def pol(a, b): return (a[0]*b[3] + b[0]*a[3] - a[1]*b[2] - b[1]*a[2]) % q
    vecs = list(itertools.product(range(q), repeat=4))
    Tall = 0
    for a in vecs:
        za = not any(a)
        for b in vecs:
            if pol(a, b): continue
            # rank of the two functionals pol(a,.), pol(b,.) = rank of {a,b} (the form is nondegenerate)
            if za and not any(b): r = 0
            elif za or not any(b): r = 1
            else:
                # proportional?
                r = 1 if all((a[i]*b[j] - a[j]*b[i]) % q == 0 for i in range(4) for j in range(i+1, 4)) else 2
            Tall += q**(4 - r)
    # all-isotropic pairwise orthogonal triples = triples spanning a space of rank <= 1 matrices (2x2)
    Tiso = 2*(1 + (q**2-1)*(q**6-1)//(q-1)) - (1 + (q**2-1)**2*(q**3-1)//(q-1)**2)
    S2 = (q*q+q+1)**2 * (Tall - Tiso)
    return S1, S2, S3, Tall, Tiso

for q in [int(s) for s in sys.argv[1:]]:
    oc = orbit_count(q)
    S1, S2, S3, Tall, Tiso = predicted(q)
    print("q=%d orbit-reduced count=%d predicted=%d (S1=%d S2=%d S3=%d; Tall=%d Tiso=%d) agree=%s count/q^13=%.4f" % (
        q, oc, S1+S2+S3, S1, S2, S3, Tall, Tiso, oc == S1+S2+S3, oc/q**13), flush=True)
