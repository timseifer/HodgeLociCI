# Pre-registration: the plane count of D-TENFOLD-COBLE-PLANE-COUNT, exactly over QQ

26 Nov 2026, about 18:10 UTC, Claude Fable 5.2 for Timothy Seifert (owner: "work on making the headline result
exact ... Yes continue forward"). AI-written, unreviewed. The count itself (N = 8, degree 12) was pre-registered
and run MOD p in `../PREREG_plane.md`; this file is about the exact version.

Honest order of events: the theory below and the script were written first; the pi-part of the script ran (and
gave 8 + 2) while it was being debugged, before this file existed. The P^3-part (degree) had not been run when
this was written.

## What makes an exact run possible (worked out before any run)

The earlier entry says an exact run "needs a point of A over a number field". It does not need one:
- iota: z_1 <-> z_2, p_0 <-> q_0, p_1 <-> q_2, p_2 <-> q_1 preserves the normal form. For a point b of its odd
  eigenspace the gradient conditions are linear in (lam, x) and cut out a LINE of parameters (checked: dimension
  1, degree 1). So every rational odd point b lies on Sing(Y) for a rational Coble cubic: here b = (1; 1, 2, 3)
  gives lam = -2, x = (8, 18, 1), a0 = 29, integer coefficients, a = b = (0,1,-1,1,2,3,-1,-3,-2).
- The 4-plane P_B through the odd eigenspace (mode B of pl1_count.m2) is rational, lies in Y and now passes
  through a: it is a rational member of the family of 4-planes through a, so Z_a is not empty.
- g: z_k -> z_(k+2), p_i -> p_(i+1), q_j -> q_(j+1) is a rational symmetry of Y, so P' = g(P_B) is a rational
  4-plane of Y; it does not contain a.
- Membership of a point y in Z_a := union of the 4-planes Pi of Y through a that contain a tangent line of
  Sing(Y) at a: such a Pi with direction tau lies in {F = Q_a = l_tau = b_tau = 0} (expand F on the plane spanned
  by a, a + v_tau, y), and tau = (l_2(y), -l_1(y)) is determined by y when (l_1, l_2)(y) != 0. If that fibre is
  smooth at y, the only candidate is its tangent space. So "on Z_a" is certified by exhibiting the plane and
  "not on Z_a" by showing the candidate is not in Y: identities in the residue field of the closed point.

## Predictions and meanings

E1 (pi-count). pi n {Q_a = G = 0} is 10 reduced points over QQ; 8 are on Z_a, 2 are not; transversal at the 8;
X smooth (by reduction modulo two primes: a singular point of X over QQ would specialise). Then Lambda . Z_a = 8.
- as predicted: the count of the MOD p entry holds exactly at this member.
- a different number: the MOD p runs or this member are special; find out which before anything else.
E2 (degree). A rational P^3 meets Y n {Q_a = G = 0} in 30 reduced points; 12 are on Z_a; so deg Z_a = 12.
- 12: with E1, [Z_a] . Lambda = 8 against deg / 3 = 4: [Z_a] is not a rational multiple of h^5 on X. EXACT.
- if the closed points are too large for a membership test: the degrees of the closed points alone may decide
  (deg Z_a is a sum of some of them, and Z_a n P^3 is reduced because the 30 points are); 24 must be excluded.
- 24: [Z_a] could be 8 h^5 and the headline's class statement would fall. Report at once.
Not covered by this run: other members; the deformation step (the cycle is the same in every tenfold with this
P^8-section; connectedness) stays an argument; arc orders 2 and 3; nothing about the Hodge conjecture.

## Outcomes (26 Nov, about 18:35 UTC)

| | outcome |
|---|---|
| E1 | as predicted: 10 reduced points, closed points of degrees 8 and 2; the 8 on Z_a, the 2 not; transversal; X smooth modulo 32003 and 31991, Lambda in X |
| E2 | as predicted: 30 reduced points, closed points of degrees 12 and 18; the 12 on Z_a (certified over the degree-12 field). The membership test at the degree-18 point was stopped after about 40 minutes; it is not needed (see below) |

deg Z_a = 12 without the degree-18 point: Z_a n P^3 is a union of closed points of a reduced scheme; it contains
the degree-12 point; if it also contained the degree-18 point then Z_a would be the whole complete intersection
Y n {Q_a = G = 0} (same dimension and degree, and that complete intersection is reduced along the P^3), but by E1
two of its points on pi are not on Z_a.

Things that went wrong on the way, kept for the record:
- the first version of ex1_setup.m2 built the restricted cubic with a line break at top level (Macaulay2 ends the
  statement there), so the plane P_B was "not found"; fixed by parentheses.
- `gens ker` over the residue field made by toField returned a kernel that failed the check
  (transpose(J) * kernel == 0 and a non-zero 5 x 5 minor): both closed points came back "undecided". The kernel
  is now written by Cramer's rule and verified by multiplication.

Correction after blind check 11: my argument for "deg Z_a = 12" (and for transversality) assumed that Z_a is
5-dimensional at the points found; my runs did not show that the family of planes is infinite. The checker
proved it exactly over QQ(t) and decided the degree-18 point directly (not on Z_a). The statements hold for the
5-dimensional part Z5 of Z_a. See section 17.4 of the lead note.
