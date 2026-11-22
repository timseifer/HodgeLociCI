EXPORT FOR A BLIND CHECK (team T3, round 3): exact data at the pair X1 on the Fermat cubic eightfold.
Normalisation of the periods, of L and of the files: exactly as in ../export_c3/README.txt (items (1)-(5)); NV = 10, k = 4,
forms Q = the 45 squarefree quadratic monomials, z = zeta_6, coefficients written a+b*z.
Planes (x_a = z^e x_b on the listed pairs):  P1: (01)(23)(45)(67)(89), all e = 1;   P2: x1 = -x2, x3 = -x4, x0 = -x5, x6 = z x7, x8 = -x9.
delta = [P1] + lambda [P2].

THE CLAIM, IN TWO SENTENCES
For lambda = 2 there is NO arc F0 - (eps T_1 + eps^2 T_2 + ...) with the T_1 of x1_lam2_obstruction.txt along which all period
functions vanish to order 5, although one exists to order 4; for lambda = -1 and the T_1 built by the same recipe
(x1_lam-1_arc.txt) the listed seven terms make all period functions vanish to order 7.
Both T_1 are tangent to the Hodge locus (L.T_1 = 0), are not tangent to V (L_P1.T_1 != 0), and lie in the kernel of the
order-3 leading forms; they are  tau_* + kappa  with tau_* the unique such vector, in the family below, with excess coordinate 1
and no x6, and  kappa = (z-1)(x0x3x6 + x0x4x6) + x1x3x6 + x1x4x6.

FILES
 x1_lam2_obstruction.txt   T_1..T_4; claim 1: the coefficients of eps^1..eps^4 vanish; claim 2: the coefficients c_5[Q] of eps^5
                           (with T_5 = 0; 15 nonzero); claim 3: a functional Lambda on the 45 coefficients with Lambda.L = 0 and
                           Lambda.c_5 = 1 + z; claim 4: Lambda.c_5 is the same for EVERY choice of T_2, T_3, T_4 that keeps the
                           coefficients of eps^1..eps^4 zero (T_1 fixed), so order 5 cannot be reached.
 x1_lam-1_arc.txt          T_1..T_7; claim: the coefficients of eps^1..eps^7 vanish for all 45 forms Q.

HOW CLAIM 4 WAS ESTABLISHED (CORRECTED 22 Nov, after check C11)
The terms T_2, T_3, T_4 of the file were found inside the 56-dimensional family FF spanned by the squarefree cubics in
x0, x1, x2, x3, x4, x6, x8, x9, and inside FF the invariance of Lambda.c_5 was verified exactly (the order-3 leading forms are
h^2 * u with u linear of rank 7 on the 37-dimensional T n FF; order 4 fixes the u-part of T_2; the order-5 vector is then
determined modulo the image of u, and Lambda kills that image).
WITHDRAWN: the first version of this file claimed that the restriction to FF is harmless "by equivariance / averaging over the
diagonal symmetries acting on x5 and on x7".  That argument is WRONG: those symmetries fix F0 and T_1 but do NOT fix the planes
(x4 = z x5 becomes x4 = z w^-1 x5), ker L is not stable under them, and averaged solutions are not solutions.
Claim 4 itself stands, by a different computation: the blind checker (check C11, folder checks/c11/) verified exactly, on ALL
220 cubic monomials and without FF, that Lambda.c_5 = 1 + z for every admissible (T_2, T_3, T_4).  Use that as the reference.
How to test it: on all cubics, change T_2 and T_3 by elements of ker L (re-solving orders 3 and 4 as needed) and recompute
Lambda.c_5; it must stay 1 + z.  A wrong claim would show Lambda.c_5 moving, or c_5 in the image of L for some choice.
(The honest symmetries of the configuration are: simultaneous scaling of (x6,x7) by a cube root of unity, of (x8,x9) by a cube
root of unity, and the rotation x0->x2->x4->x0, x1->x3->x5->x1.  They do not cut the problem down to FF.)

FURTHER EXACT VALUES (not exported; ../cert_x1.py lam 5):  with the same deterministic recipe,
   Lambda.c_5 = (8/9)(1 + z) * (lambda - 1)(lambda + 1)^2 / lambda^3      at lambda = 2, 3, 5, 7, 1/2, 5/3, -2, -3, -1/2,
and at lambda = -1 the arc continues exactly through order 9 (order 10 did not finish in the time limit).
Self-check with different code: ../verify_literal_x1.py reproduces both files by the literal recipe (same author).
Not claimed: that the arc for lambda = -1 continues to all orders; anything about algebraic cycles.
