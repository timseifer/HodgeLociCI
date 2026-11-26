# Pre-registration: the class of the 4-plane cycle by one transversal intersection count

Written 26 Nov 2026 by Claude (Fable 5.2) BEFORE the computation. Kept as written; results go in
`leads/TENFOLD_COBLE_LEAD.md`, section 14. AI-generated, unreviewed. Nothing here is a statement about the Hodge
conjecture.

## Why

The owner expects no reply from a mathematician. The one step of the Coble explanation that is an argument and not
a computation is "the class of the 4-plane cycle is not a multiple of h^5" (section 10: local classes at 72 nodes;
a ladder of self-intersections). This test replaces it by something elementary: one intersection number of two
subvarieties that meet transversally in finitely many points.

## Setup

Y = a Coble cubic in P^8 (normal form of section 5), A = Sing(Y), a a point of A, Z_a = the union of the 4-planes
of Y through a (the cycle of section 10; dimension 5, degree 12: Chern class count, and sampled MOD p).
Take another 4-plane P' of Y, not through a, and a general plane pi in P'. Take the cubic tenfold
X = F_Y + sum_k w_k Phi_k with quadrics Phi_k in the ideal of pi (times linear forms in all 12 variables). Then
X n {w = 0} = Y, and X contains the 5-plane Lambda = {y in pi, w arbitrary}, with Lambda n P^8 = pi.

Textbook fact used: if two subvarieties of complementary dimension in a smooth projective variety meet
transversally in N points, their classes have intersection number N.
If [Z_a] were c h^5, then 12 = deg Z_a = 3c, so c = 4, and Lambda . Z_a = 4 (Lambda . h^5 = 1).
Lambda n Z_a = pi n Z_a, inside P' n Z_a.

## Prediction (theory, done before computing)

P' n P'' is the secant line of the theta curve of P' through its two points on the theta curve of P''. So
P' n Z_a is the ruled surface of those secant lines, for P'' through a. Its degree is 6 * 2 - 8 / 2 = 8 (class of the
family of pairs in the symmetric square of a genus-2 sextic: it meets "pairs containing a point" in 2 and the
diagonal in 8, by Riemann-Hurwitz on a curve of genus 7). So I predict N = 8.

## What is computed (MOD p; two primes, two seeds)

P1. Inside P' = P^4 the scheme {Q_a = G = 0} (Q_a the tangent cone of Y at a, G the quintic of
    `h5c_cycle_sampling.m2`; Z_a is a component of Y n {Q_a = G = 0}): its components, degrees, multiplicities.
P2. For each component, at a rational point where Y n {Q_a = G = 0} is smooth: does the point lie on a 4-plane of
    Y through a? (The test of `h5c_cycle_sampling.m2`.) This sorts the components into "in Z_a" and "residual".
P3. N = sum of the degrees of the components in Z_a, if each has multiplicity 1.
P4. X is smooth; at sampled points of pi n Z_a the tangent spaces of Z_a and of pi meet only in the point.

## Outcomes

- N different from 4 (predicted 8), multiplicities 1, X smooth: [Z_a] is not a multiple of h^5 on X. Z_a is the
  same subvariety in every tenfold with this P^8-section, and those form a connected family, so the same holds for
  all of them. Then the class statement of section 10 no longer rests on the node argument or on the ladder: it
  rests on a count (MOD p) and the textbook fact. Section 10 would also predict N - 4 = c (Lambda . v_0) with
  c = +-2, so N must be even.
- N = 4: this test decides nothing (possible if Lambda is orthogonal to the class), and my prediction 8 is wrong;
  find the error in the count before anything else.
- N odd: contradicts c = +-2 in section 10. Report as a contradiction.
- A component with multiplicity > 1, or the membership test not constant where it should be: the count is not
  valid as set up; fix the setup, do not report a number.

## Limits

MOD p. Lifting to characteristic 0 needs an argument (the points a, P', pi lift by Hensel; intersection numbers are
constant in flat families): ARG until written out or until the count is done over a number field. The degree 12
of Z_a is from the earlier count and sampling. An independent agent gets the statement only.
