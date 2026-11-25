# K3 / Pfaffian test: pre-registration (written 25 Nov 2026, late evening, before any run)

## What the registry already has (read first; not repeated here)
- D-TENFOLD-LAMBDA0-CHECK: for two 5-planes meeting in a P^2 on a cubic tenfold the special coefficient of the general
  rule is lambda_0 = +1; codim V_Z = 39, codim NL(lambda_0) = 38; first-order excess 1 at a random point of V_Z (MOD p).
- D-LAMBDA1-PFAFFIAN-AND-SCROLL, D-PFAFFIAN-LAMBDA1 (sixfolds, eightfolds): for lambda = +1 the locus is "a linear
  section is a Pfaffian cubic", with quintic del Pezzo k-folds of class h^k + [P1] + [P2] (Kloosterman, arXiv:2312.12363,
  Prop. 6.4, Cor. 6.5) and, on sixfolds, quartic scrolls of class 2h^3 - [P1] - [P2].
- D-CONE-DICTIONARY: (1,1) <-> discriminant 14, (1,-1) <-> discriminant 18 on cubic fourfolds.
So the family "X n P^8 is a Pfaffian cubic sevenfold" that I proposed this afternoon is, on tenfolds, the registry's
lambda_0 = +1 locus (codim 38 = 39 - 1; my count 19 + 80 = 99, 164 - 99 - 27 = 38 agrees). Its codimension and its
first-order excess are NOT re-tested. I had not connected the two when I proposed the test.

## What this run is for
A positive control of today's mechanism (D-TENFOLD-COBLE-CYCLE-CLASS) on a case whose answer is known independently:
the node picture and the ladder must reproduce the lattice numbers of h^5 + [P1] + [P2]. New for the registry would
be: the K3 description of the lambda = +1 locus on tenfolds, and the parallel K3 (degree 14, lambda = +1) /
abelian surface (degree 18, lambda = -1).

Setting. M a 6x6 skew matrix of random linear forms in 9 variables, F = Pf(M), Y = {F = 0} in P^8.
LIT (recalled, not re-read): the Pfaffian cubic in P^14 is singular exactly along Gr(2,6) (forms of rank 2), with
transversal singularity the Pluecker quadric of rank 6; so Sing(Y) = S = Gr(2,6) n P^8, a K3 surface of genus 8,
degree 14, ideal the fifteen 4x4 Pfaffians.

## Predictions and what each outcome would mean
Q1. Sing(Y) = S: dimension 2, degree 14, Hilbert polynomial 7n^2 + 2; sat(Jacobian ideal) = (4x4 Pfaffians);
    Hessian of rank 6 everywhere on S.     Fail: the Pfaffian section is not of the Coble type; stop.
Q2. S n {Psi_1 = Psi_2 = 0} = 56 reduced points with Hilbert function 9, 28, 47, 55, 56 (one relation on quartics);
    Jacobian scheme of a random completion on P^10: degree 56, nothing off the P^8.
    One level down: 28 points, 27 on cubics. Two levels down: Y n P^6 has 14 nodes, 13 on quadrics. Y n P^5 smooth.
    (These Hilbert functions follow from S being arithmetically Gorenstein with K = 0, so they test the setup, not
    a conjecture. A different number would mean S is not what LIT says.)
Q3. Algebra. B = k[y]/(I_S, Phi_1, Phi_2, Phi_3) has Hilbert function (1, 9, 27, 38, 27, 9, 1) (Gorenstein, socle
    degree 6); the pairing on cubics has rank 38 with kernel (I_S + Phi)_3 (forced by Gorenstein duality: recorded,
    not a test). Open question to be read off: A = k[y]/(Jacobian ideal, Phi): is dim A_6 = 1 (as for the Coble
    cubic) or larger?  If larger, "the class supported on the section" is not determined by (w) + J alone and the
    first-order argument must use I_S, which needs the class to be Hodge on the family (true here: it is algebraic).
Q4. Two explicit 5-folds in Y:  Z' = {rank of M restricted to a fixed 5-space <= 2} (the five 4x4 Pfaffians of a
    5x5 principal block; quintic del Pezzo 5-fold) and Z = {kernel of M meets a fixed 3-space} (3x3 minors of a
    6x3 block of columns). Predictions: dim 5, degrees 5 and 7 (7 = 12 - 5 from c_1(kernel bundle) = -2h), both
    contain S, Z + Z' is the complete intersection of Y with two quadrics (degree 12).
    Degrees 5 and 7 are not divisible by 3, so neither class is a rational multiple of h^5 (h^5 is primitive in
    H^10(X, Z) since h^5.h^5 = 3). This part needs no ladder.
Q5. Local classes (the point of the control). At a point p of S: Z and Z' are smooth, their tangent 5-spaces contain
    T_pS and are isotropic for Hess F(p); they lie in DIFFERENT rulings (intersection of the two tangent spaces of
    projective dimension 2 or 4); two Z's (different 3-spaces) are in the SAME ruling (dimension 3), likewise two Z'.
    Outcome "Z and Z' in the same ruling": contradicts Z + Z' = complete intersection (local class 0); the local
    class reasoning of 10.3 would be wrong.
Q6. Intersection numbers on the smooth cubic fourfold Y n P^5 (proper intersections, counted as lengths):
    D.D_2 = 13 (LIT: quintic del Pezzo surfaces on a Pfaffian cubic fourfold, lattice (3,5;5,13), disc 14),
    sigma.sigma_2 = 21, sigma.D = 7, where sigma = Z n P^5, D = Z' n P^5 (from sigma = 4h^2 - D).
Q7. Ladder against the lattice (arithmetic; node counts 14, 28, 56; local classes +1 for Z, -1 for Z'):
        Z'.Z' = 13 - 14 + 28 - 56 = -29,   Z.Z = 21 - 42 = -21,   Z.Z' = 7 + 14 - 28 + 56 = 49.
    Independent values from the classes [Z'] = h^5 + P1 + P2, [Z] = 3h^5 - P1 - P2 with h^5.h^5 = 3, h^5.P = 1,
    P.P = -21 (top Chern class of the normal bundle of a 5-plane), P1.P2 = 3 (excess formula, c_2 of
    (1+h)^3/(1+3h) on the common plane):
        (h^5+P1+P2)^2 = 3 - 42 + 4 + 6 = -29,  (3h^5-P1-P2)^2 = 27 - 42 + 6 - 12 = -21,  product = 49.
    These were computed by hand before the run and agree. So Q6 is the experimental input: if Q6 returns
    13, 21, 7 the ladder reproduces a second known lattice (the first was [V]^2 = -36); if Q6 returns other
    numbers, either the ladder or the identification of the classes is wrong, and section 10 loses its test.
