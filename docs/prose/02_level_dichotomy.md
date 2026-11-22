# Worked example 2: the level dichotomy, on both sides

> Status. This example and the package were written by AI agents and have not been reviewed by a human. The
> theorems of "paper 3" quoted in the output come from an AI-written manuscript that no human has refereed.
> Nothing here is, or bears on, a proof or disproof of the Hodge conjecture. The session below is a real captured
> Macaulay2 1.22 session (input `docs/sessions/02_level_dichotomy.m2`, output `docs/sessions/02_level_dichotomy.out`, pasted unchanged).

## What is computed

In the setting of worked example 1 the *level* is tau = sum(deg f_i + deg h_i) - (c-1)d = d - deg det M.
(It is not the Hodge level of X, which the separate helper `hodgeLevel` returns.) The dichotomy stated in paper 3,
Theorem 2 (AI-written, unreviewed), is:

- tau < 0: no excess; the Hodge locus of [Y1] + lambda [Y2] equals V_Z for every lambda != 0. For two linear cycles
  this is the condition m < n/2 - d/(d-2) of Villaflor Loyola (arXiv:1812.03964, Theorem 3) and the inequality of
  Kloosterman's Theorem 1.5 (arXiv:2312.12363).
- tau >= 0: at lambda0 = (-1)^(c-1) the Hodge locus is smooth of codimension codim V_Z - e_tau, strictly larger than
  V_Z (when e_tau > 0). At the other coefficients the excess is e_tau in "the range" (k-1)d + tau < 2k+2, and
  dim (0 :_A det M)_tau outside it, which depends on the hypersurface and not only on the degrees.

## Session

{{SESSION}}

## Reading the output

- The table (step 5) runs through the four ways two 3-planes can meet on a cubic sixfold: in a plane (c = 1,
  tau = 2), a line (c = 2, tau = 1), a point (c = 3, tau = 0), or not at all (c = 4, tau = -1). Labels: EXACT
  (integers); `NotDetermined` is returned instead of a guess where the degrees do not determine the answer.
- tau < 0 side: at a random cubic sixfold through two disjoint 3-planes the excess is 0 for all four coefficients
  tried (MOD p, one instance; direct linear algebra in the Jacobian ring, Theorem 2 not used).
- tau >= 0 side: with the planes meeting in a point the excess is 1 for all four coefficients (MOD p).
- Outside the range (steps 13 to 22): for two 5-planes meeting in a plane on a cubic tenfold, the excess away from
  lambda0 is 0 at a random point (MOD p; by Hilbert functions and the rank of multiplication by det M, PROVED only in
  paper 3) and 1 at the Fermat point (EXACT over Q(zeta_6): codimensions 39 and 38, Movasati's pair (38, 39)).
  This is the phenomenon of Kloosterman's Theorem 1.2; validation test 04 checks the random-point statement by a
  direct first-order computation.
- `linearSubspaceCase` quotes the classification of paper 3, Theorem 9.7, which is a statement about a GENERAL
  hypersurface containing the two planes.

Regenerate: `cd docs/sessions && M2 --silent --no-readline --print-width 118 < 02_level_dichotomy.m2 > 02_level_dichotomy.out`, then
`python3 docs/build_docs.py` (or `python3 docs/build_docs.py --run` for all sessions at once).
