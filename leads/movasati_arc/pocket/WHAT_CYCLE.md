# If the lambda = 2 pocket is a real component, what cycle could live on it?

Claude Opus 5.5, 28 Nov 2026. AI-written, unreviewed. Labels: EXACT (arithmetic), ARG (argument), LIT.

## Premises

- (OPEN) The pocket is a component W of the Hodge locus of c = [P1] + 2[P2] through the eightfold Movasati point
  (two P^4's meeting in a line in a cubic eightfold). Status: jets exist to order 9 (D-POCKET-ORDER9-PASSED); open.
- (LIT, as recorded in the SCOPE paragraph of O-ALIGNED-POCKET-LAMBDA2-ORDER9, added by the owner's session #12) the
  Hodge conjecture in the middle degree is expected to hold for every smooth cubic eightfold. If so, c is algebraic on
  W: c = sum n_i [Z_i] (rationally) for subvarieties Z_i of X_t, t in W.
- (MOD p, two primes; N-POCKET-NO-COMPANION-CLASS) along the pocket jet, the only Hodge class that survives past order
  5 is c; so the generic Hodge lattice of W is (assumed to be) Q h^4 + Q c.

## Consequences (ARG, EXACT arithmetic)

1. Each Z_i is itself a Hodge class on W, so [Z_i] = a c + b h^4 with a, b in Q (rank-2 lattice). If the lattice
   Z h^4 + Z c is saturated in H^8(X, Z), then a, b are integers. (Saturation is NOT checked.)
2. With c.c = 51, c.h^4 = 3, h^8 = 3 (EXACT, from P.P = 11, P1.P2 = -1):
       deg Z = 3 (a + b),     Z.Z = 51 a^2 + 6 a b + 3 b^2 = 48 a^2 + (deg Z)^2 / 3,
       disc(Z) = 3 Z.Z - deg^2 = 144 a^2.
   So a cycle that carries c (a != 0) has Z.Z = 48 a^2 + deg^2/3 and degree divisible by 3.
3. Degree 3 (a + b = 1). An irreducible 4-fold of degree 3 is (classical) a cubic hypersurface in a P^5 or a rational
   normal scroll / cone over one: S(0,1,1,1) (cone over P^1 x P^2), S(0,0,1,2), S(0,0,0,3). In X:
   - a cubic 4-fold in a P^5 lying in X is X n P^5, class h^4 (a = 0);
   - every generalised cubic scroll degenerates to a chain of three P^4's A, B, C with dim(A n B) = dim(B n C) = 3 and
     dim(A n C) = 2, so Z.Z = 3*11 + 2*(-5 - 5 + 3) = 19 and disc = 57 - 9 = 48 (EXACT; equal to disc(P1 - P2) for
     planes meeting in a plane, Movasati's lambda = -1 scrolls). Not 144 a^2.
   So no cubic 4-fold and (if the scroll computation holds) no generalised cubic scroll carries c. CAVEAT (blind
   check 23): the scroll value 19 uses a degeneration to three P^4's in P^6; nothing shown keeps that limit inside X,
   so for scrolls this is a plausibility argument, not a computation in X. If it holds, c is not the class of an
   irreducible deformation of the cycle P1 + 2 P2 itself (which would have degree 3 and Z.Z = 51).
4. Degree 6 (a = 1, b = 1): Z.Z would have to be 60. The smooth degree-6 4-folds tested (N-POCKET-LATTICE-FILTER-SMOOTH:
   P^2 x P^2 with 36, scrolls S(1,1,2,2), S(1,1,1,3) with 38) are far from it. Degree 9: Z.Z = 75 (a = 1) or 219 (a = 2);
   degree 6 with a = 2: Z.Z = 204.
5. Comparison: the known mechanisms at the same configuration have disc 56 (Kloosterman's lambda = 1 class, del Pezzo
   4-folds of degree 5) and 72 (Movasati's lambda = -1, P^2 x P^2-type); every smooth type tested gave 32..86. A cycle on
   W would need disc 144 a^2 >= 144: "more twisted" than every cycle tested.

## What this gives an expert

A sharp target: if W exists (and the premises hold), it carries an irreducible 4-fold Z of degree 3(a + b) >= 6 with
Z.Z = 48 a^2 + deg^2/3, for instance (deg, Z.Z) = (6, 60), (9, 75), (6, 204). Finding such a Z (or showing none can
lie on a cubic eightfold) would either explain the pocket or contradict it.

Not established: that W exists; saturation of Z h^4 + Z c; that the generic Hodge lattice of W has rank 2 (only one
jet was tested); the Hodge-conjecture premise (deduction not checked against one source).

Blind check 23 (separate agent; its report file was blocked, verdicts recorded here from its message): items 1
(c.c = 51, disc = 144 a^2, Z.Z = 48 a^2 + deg^2/3), 2 (degree-3 classification: cubics in a P^5, or the cones
S(0,1,1,1), S(0,0,1,2), S(0,0,0,3); no smooth degree-3 scroll of dimension 4), 3 (a cubic 4-fold in X is P^5 n X,
class h^4) and 6 (60, 75, 219, 204) CONFIRMED; item 4 arithmetic CONFIRMED, degeneration UNCLEAR; item 5 therefore
UNCLEAR for scrolls.
