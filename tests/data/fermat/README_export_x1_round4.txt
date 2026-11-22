EXPORT FOR ONE BLIND CHECK, ROUND 4 (team T3): the class along the exact arc x1_lam-1_arc.txt is annihilated by a linear form.

SETTING.  As in README.txt: Fermat cubic eightfold, pair X1, lambda = -1, delta = [P1] - [P2]; the arc
F_eps = F0 - (eps T_1 + ... + eps^7 T_7) of x1_lam-1_arc.txt (all period functions vanish to order 7 along it: check C11).
DEFINITION (one pole order higher than the period functions; rules (1)-(3) of ../export_c3/README.txt with k = 4):
   pi_eps(N) := int_delta Res( N Omega / F_eps^5 ) = sum_{m >= 0} binomial(4 + m, m) * I(N * T(eps)^m, 5 + m),   N a monomial of degree 5,
   T(eps) = eps T_1 + ... + eps^7 T_7,  as a power series in eps, truncated mod eps^8.   (Closed form: pi_eps(N) = Psi(N exp(T(eps))).)
   At eps = 0: pi_0(N) = coefficient of the complementary monomial in P_delta if N is squarefree, and 0 otherwise.
THE CLAIM, IN TWO SENTENCES.
 (a) The 10 x 715 matrix  C14[x_i][H] = pi_eps(x_i * H)  (H over the monomials of degree 4) has, over the power series ring,
     invariant factors: 8 units, one of valuation 2, and one that vanishes mod eps^8; equivalently there is a linear form
     l(eps) = l_0 + eps l_1 + ... with pi_eps(l(eps) * H) = 0 mod eps^8 for every H, unique up to a unit series, and with the
     normalisation "coefficient of x7 equal to 1" it is the one listed in lform_lam-1.txt:
        l_0 = (z - 1) x6 + x7,   l_1 = l_2 = l_3 = l_4 = 0,   l_5 and l_6 as listed,   l_7 = 0.
 (b) The 55 x 220 matrix  C23[q][G] = pi_eps(q * G)  (q quadric monomials, G cubic monomials) has invariant factors: 19 units,
     7 of valuation 2, and 29 that vanish mod eps^8  (rank 26 over the field of Laurent series, to this order).
MEANING.  Where delta is a Hodge class, pi_eps is its class P in the Jacobian ring (degree 5); (a) says that one linear form
kills P along the arc ("the class is carried by a hyperplane section"), (b) that the Hodge locus has tangent codimension 26
at the general point of the arc.  Both are properties of a general member of the family l*Q + det A + det B.
PRECISION.  The statements are about the truncated arc.  For the true germ W' they are valid mod eps^6 (the truncated arc
agrees with an arc of W' only mod eps^6), so l_5 is meaningful and l_6 is at the limit.
HOW TO CHECK.  Recompute pi_eps(N) for the monomials needed (for (a) it is enough to take H squarefree: 210 columns), then
verify pi_eps(l(eps) H) = 0 mod eps^8, and that no other independent linear form does this mod eps^3 (the second linear form
vanishing on span(P1, P2), which kills the class at eps = 0, fails at eps^2).
WHAT A WRONG CLAIM LOOKS LIKE.  A tenth invariant factor of valuation <= 7 in (a) (no linear form), or more than 26 factors
of valuation <= 5 in (b).  Controls on our side: an arc that satisfies the period equations only to order 4 loses both linear
forms at eps^3, eps^4; for lambda = 2 the order-4 arcs give rank >= 30 in (b).
Computed mod p = 268435399 and 268435291 (t3_window/annlib.py, ann_run.py genfile, lform.py); the coefficients of l(eps) were
reconstructed in Q(z) from the two conjugate reductions at the first prime and agree at the second.  NOT exact.

SECOND CHECKABLE CLAIM (the one the dimension statement for lambda = 2 rests on): files six_lam2_arc.txt, six_lam-1_arc.txt.
These are exact arcs (9 terms each, coefficients in Q(z)) that involve only x0, x1, x2, x3, x4, x8, x9.  They can be read in two ways:
 * as arcs of cubic EIGHTFOLDS at X1 (all 45 period functions vanish to order 9: stated in the files, exact);
 * as arcs of cubic SIXFOLDS: Fermat cubic in y = (x0, ..., x5, x8, x9), planes Pi1: x0 = z x1, x2 = z x3, x4 = z x5, x8 = z x9 and
   Pi2: x1 = -x2, x3 = -x4, x0 = -x5, x8 = -x9 (two 3-planes meeting in a point, corank of C equal to 1), class
   gamma = [Pi1] + lambda [Pi2], lambda = 2 resp. -1; the 8 period functions Phi_{y_i} (k = 3) vanish to order 9 along them.
SIXFOLD DEFINITION:  pi_eps(N) := int_gamma Res( N Omega / c_eps^4 ) = sum_m binomial(3 + m, m) I(N T(eps)^m, 4 + m),  N a monomial of
degree 4 in y  (rules (1)-(3) of ../export_c3/README.txt with NV = 8, k = 3; period polynomial of a 3-plane = product over its
four pairs of 3*zeta*(y_a + zeta*y_b)).
CLAIM (c).  The symmetric 36 x 36 matrix  C22[q][q'] = pi_eps(q q')  (q, q' quadric monomials in y) has invariant factors
     lambda = -1:  12 units, 6 of valuation 2, and 18 that vanish mod eps^10                       (rank 18);
     lambda =  2:  12 units, 6 of valuation 2, 4 of valuation 4, 2 of valuation 5, 3 of valuation 7  (rank at least 27),
and the 8 x 120 matrix pi_eps(y_i * G) has 7 units and one factor of valuation 2 in both cases (no linear form survives).
(The 8 partial derivatives of the cubic are always in the kernel of C22, so 28 is the largest possible rank; on generic,
non-sparse arcs for lambda = 2 the rank 28 is reached, with 4 factors of valuation 7.  Mod p, two primes.)
WHY IT MATTERS.  For X = x6^3 + x7^3 + c(y) and delta = cone(gamma):  Hodge tangent codimension of delta at X = rank of the
8 x 120 matrix + rank of C22  (Jacobian ring of a sum = tensor product; period polynomial of a cone = product).  So 8 + 18 = 26
for lambda = -1 and 8 + 28 = 36 for lambda = 2, against codim V = 20 on eightfolds.
A WRONG CLAIM would show, for lambda = -1, a 19th factor of valuation <= 7; or, for lambda = 2, no factor beyond the first 18.
