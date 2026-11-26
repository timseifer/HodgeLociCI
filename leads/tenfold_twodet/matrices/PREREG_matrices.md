# Pre-registration: the matrices along T2's sixfold arc (O-RECOVER-MATRICES-AND-LIMIT-OF-T)

26 Nov 2026, about 20:20 UTC, Claude Fable 5.2 for Timothy Seifert (owner: "queue this work up", "Go ahead").
AI-written, unreviewed. Labels: EXACT / MOD p / PROVED (AI, unreviewed) / ARG / LIT / OPEN, and here also
NUMERICAL (double precision or multiprecision floating point: evidence of the weakest kind, never a proof).

## What is asked

Team T2's statement (S) (D-W-MINUS1-IS-TWO-DET-CLOSURE, a paper chain): near the sixfold divisor D the second
component W_(-1) of the Hodge locus of [P1] - [P2] is the closure of {det A + det B}, with the class
+-([T] - 3h^3). T2's computation along one arc (D-DEGENERATION-ALONG-ARC, MOD p): the kernel of the catalecticant
splits into two nets with the numbers of 2 x 2 minors; the matrices themselves were never found
(O-RECOVER-MATRICES-AND-LIMIT-OF-T, STUCK: "raise the precision ... or solve the anisotropic ansatz").
The eightfold statement D-X1-COMPONENT-IS-TD-CLOSURE and the tenfold statement D-TENFOLD-CONE-POINTS-TWO-DET
rest on (S) through the cone map.

## Read first

D-DEGENERATION-ALONG-ARC, O-RECOVER-MATRICES-AND-LIMIT-OF-T, N-TWO-TRACE-DESCRIPTION-OF-D (isotropic scaling is
NOT D; do not repeat), D-RANK-CONTRAST-EXACT-ARCS (the exported arc, exact to order 9; Cat(2,2) has 12 units, 6
factors of valuation 2 and 18 zeros along it), D-TWO-DET-FAMILY-NUMBERS, M-ENDOMORPHISM-SPLITTING-TEST.
Code searched: the package Fermat engine (it cannot extend this arc order by order: the first-order map is
singular on the arc's nine monomials; probe of 26 Nov), leads/tenfold_coble/pairing/ (arc algebra, detrep_lib),
blind_check10/B_own.py (an exact implementation of the period formula).

## A route T2 did not try: solve for the matrices numerically at fixed small eps

The exported arc gives F_eps = Fermat - (eps T_1 + ... + eps^9 T_9) exactly; for eps around 0.1 the truncation
error is about 1e-7. If F_eps is a sum of two determinants over the complex numbers (T2's splitting says so over
the series field), a Gauss-Newton / Levenberg-Marquardt iteration on the 144 complex unknowns of (A, B) should
find one, with residual at the truncation level. From solutions at several eps one can read the scaling of the
entries, fix the gauge, and guess the exact leading matrices; an exact series solution can then be started from
them. Independently of that, the span of the 2 x 2 minors of the numerical (A, B) can be compared with the
kernel of the catalecticant of the transported class [P1] - [P2] (from the exact period series): this tests (S)
on this arc directly.

## Predictions and what each outcome means

M0 (control). On a synthetic target det A0 + det B0 (random complex matrices) the solver, started at random,
reaches residual 1e-12. If not: the solver is not adequate; fix it before reading anything else.
M1. For eps in {0.2, 0.15, 0.1, 0.07}: from random starts the iteration reaches a residual at the truncation
level (a few times eps^10 times the size of T_10, i.e. about 1e-4, 1e-6, 1e-7, 1e-9), far below the residual of
a control cubic that is NOT in the family (Fermat plus a random cubic of the same size as eps T_1: residual of
order the distance to a codimension-8 family, i.e. comparable to eps).
- as predicted: numerical evidence that the cubics of the arc are sums of two determinants (NUMERICAL).
- residual stalls at the control's level for every start: either the arc is not in the family (then (S) is in
  trouble on this arc, and T2's splitting needs another explanation), or the solutions are too ill-conditioned
  for double precision at these eps (repeat in multiprecision before concluding).
M2. The solutions scale as T2 found: after normalising the gauge, both matrices are close to a multiple of
l times the identity, of size about eps^-2, where l is the tangent hyperplane at P1 n P2.
- yes: the numerical solutions are the branch T2 saw.
- no (bounded matrices): a different, honest branch; then compare with the Fermat honest decomposition.
M3. The span of the eighteen 2 x 2 minors of (A, B) equals, up to the truncation level, the kernel of the
catalecticant Cat(2,2) of the transported class [P1] - [P2] at the same eps (largest principal angle small).
- yes: on this arc the two-determinant class is +-(the transported [P1] - [P2]) numerically: (S) supported by a
  direct computation, at the level NUMERICAL.
- no, with M1 yes: the arc is in the two-determinant family but with a different class; (S) fails on this arc.
M4 (aim, not a prediction). An exact description: leading matrices and exponents, then a series solution.

## Outcomes of the first route

Times, from the file times of the outputs (`date -u` at the time of writing this section: 20:25 UTC): the
pre-registration above was last saved at 20:11 UTC, mx1 ran 20:11 to 20:13, mx2 20:14 to 20:16, the first mx3
run 20:19. Deviation recorded: the header's "about 20:20 UTC" was a guess and is wrong by about ten minutes
(the text was written before 20:11); wall-clock times are to be taken from `date -u`, not estimated.

- M0 FAILED (NUMERICAL). `mx1_solve.py`: Levenberg-Marquardt from random starts does not reach a solution even
  on a synthetic target det A0 + det B0 (rms residual 1 to 2.6 from 4/4 and 12/12 starts, 400 and 1500
  iterations). From a start within a perturbation 0.1 or 0.3 of a true solution it converges (rms 1e-13 in 6 and
  14 iterations); from perturbation 1.0 it does not. So the solver is a polisher, not a finder.
- M1 NOT TESTABLE with this solver: on the arc cubics (eps = 0.2, 0.15, 0.1, 0.07) the residuals (0.1 to 0.7)
  are those of the failing control. Nothing can be read from them, in either direction.
- `mx2_split.py` on the order-9 period series of the exported certificate arc: Cat(2,2) has 12 large singular
  values, 6 of size eps^2 and 18 at the truncation level; the partial derivatives lie in the kernel; the
  multiplication map kernel (x) S_1 -> S_3 has rank 112 (so 32 linear syzygies); the commuting algebra has
  dimension 2. The two nets were NOT separated: the trace-free generator is nearly nilpotent (T2: its square has
  valuation 12, so its eigenvalues are +-c eps^6) and the series noise was about eps^8.
- A finding on the data, not on the mathematics: the exported certificate arc `six_lam-1_arc.txt` passes the
  period test to order 9, but its last two terms T_8, T_9 are not the terms of an arc that continues
  (`mx3_extend_arc.m2`, EXACT: with T_1..T_7 kept and one unknown per monomial from T_8 on, the equations up to
  order 13 determine T_8..T_13 uniquely, and the determined T_8, T_9 differ from the file's). This is the usual
  situation for a finite-order certificate and no error of T2's; it means the order-9 series was only good
  modulo eps^8 for the present purpose.

Ruled out by this, and only this: random-start Levenberg-Marquardt on (A, B) at the four eps above, and the
eigen-splitting from series of order 9. Not ruled out: anything about the family itself.

## Second route (pre-registered 26 Nov 2026, 20:25 UTC, before any of its splitting runs)

Step 0 (tooling, already run at 20:19 to 20:22 UTC, before this section was written: deviation recorded).
`mx3_extend_arc.m2`: EXACT over QQ(zeta_6). Keep T_1..T_7; unknown coefficients on the arc's nine monomials
from T_8 on (normalisation: the coefficient of y2y4y6 in the arc is eps exactly). Result: T_8..T_19 are
determined uniquely by the equations up to order 19 (`arc_true_order19.txt`). The equations of order n do not
determine T_n (first-order map singular on this slice); they close up at the orders n = 1 mod 3.

Step 1. `mx0_export_periods.m2` on that arc: exact Taylor coefficients, orders 0..19, of the periods of the 330
quartic monomials for [P1] - [P2].

Step 2. `mx4_pipeline.py` in multiprecision (mpmath, 60 digits; rounding is then not an issue, only the
truncation of the series is): at eps in {1/10, 1/16, 1/25}: the catalecticant, its kernel, the commuting
algebra, the two nets, the decomposition F_eps = G_A + G_B, then for each of G_A, G_B the Lie algebra of
linear vector fields killing it and the matrix by the method of `leads/tenfold_coble/pairing/detrep_lib.m2`
(eigenforms of a regular element of sl_3), done numerically; last a Newton polish of (A, B) on F_eps.

Predictions and what each outcome means.
M5. Cat(2,2): 12 values of size 1, 6 of size eps^2, 18 at the truncation level, which now falls like eps^20
(so by a factor about 2.5^20 = 1e8 from eps = 1/10 to 1/25). The commuting algebra is 2-dimensional; the
trace-free generator phi has phi^2 = delta * 1 with delta = c eps^12 (1 + O(eps)), c != 0, and two eigenspaces of
dimension 9, cleanly separated.
- as predicted: T2's mod p splitting (D-DEGENERATION-ALONG-ARC) is reproduced in characteristic 0, NUMERICAL.
- clusters other than 9 + 9, or delta not of order eps^12: the splitting seen mod p is not what happens over the
  complex numbers on this arc, or the extended arc is not T2's arc beyond order 7; stop and compare with T2's logs.
M6. F_eps = G_A + G_B with all partial derivatives of G_A in the first net and of G_B in the second, unique;
the coefficients of G_A grow like eps^-6 (T2: G_A, G_B = +-c l^3 eps^-6 + ...). The Lie algebra of each is
8-dimensional (8 singular values at the truncation level, the 9th far above).
- as predicted: each summand has the symmetry algebra of a determinant.
- dimension less than 8: the summand is not a determinant of a matrix with independent entries; (S) would then
  need the summands to be something else (in trouble on this arc). Dimension more than 8: a degenerate summand
  (a cone or a determinant with dependent entries); describe it before going on.
M7. The matrices: det A = G_A, det B = G_B to the truncation level, and after the polish
|det A + det B - F_eps| / |F_eps| is at the truncation level at each eps (falling like eps^20), while with the
series cut at order 13 instead of 19 it is larger by the corresponding factor (control: the residual follows
the truncation, so it is the series and not the fit that limits it).
- as predicted: NUMERICAL evidence that the cubics of this arc are sums of two determinants, with the kernel of
  the catalecticant of the transported [P1] - [P2] equal to the span of the 2 x 2 minors (that is M3, built in).
- residual with a floor that does not follow the truncation: the cubics are near, not in, the family along this
  arc; (S) is in trouble on this arc.
M8 (description, not a prediction). Exponents and leading forms of the entries after a gauge normalisation; the
limit of the pencils of rows that define T; whether the flat limit of T can be read off. An exact series
solution, and the class of the limit, would be a further step with its own pre-registration.

What no outcome of this route can give: a proof. Everything in step 2 is NUMERICAL at three values of eps on one
arc; (S) is a statement about a whole component. "Ruled out" will mean these runs only.

Implementation note, added 20:30 UTC before any run of step 2. The 3840 x 324 system of the commuting algebra
is too large for multiprecision in pure Python, so M5 and M6 are tested in a closely related, smaller form
(same objects, other route):
(a) the space of cubics G with all eight partial derivatives in the kernel of Cat(2,2) (a 144 x 120 linear
    system) is expected to be 2-dimensional, spanned by F_eps and one more cubic G' (taken orthogonal to F_eps,
    of the same norm). This replaces "the commuting algebra is 2-dimensional".
(b) a member G' - t F_eps of this pencil has linear vector fields killing it exactly when t is a generalized
    eigenvalue of the pair of 120 x 64 matrices (vector fields applied to G', to F_eps). Expected: exactly 16
    genuine eigenvalues (residual at the truncation level), in two clusters of 8 at t_1 != t_2, with
    |t_1 - t_2| of order eps^6; then G_A = (G' - t_1 F)/(t_2 - t_1), G_B = (t_2 F - G')/(t_2 - t_1), and
    |G_A| eps^6 tends to a non-zero constant. This replaces "phi^2 = c eps^12, two eigenspaces of dimension 9".
    Other outcomes: no genuine eigenvalue (no member of the pencil is a determinant: (S) in trouble on this arc);
    one cluster of 16 or clusters of other sizes (describe; compare with T2's log before reading anything).
(c) at the end, the eighteen 2 x 2 minors of the matrices found are tested directly for membership in the
    kernel of Cat(2,2) and for spanning it (this is M3).
A dry run of the code on the order-13 series is used for debugging only; its numbers are not evidence.

Revision of the implementation note, 20:36 UTC, after the dry run on the order-13 series (debugging
only) and before any run on the order-19 series. Item (a) above was WRONG as stated, for a reason I should have
seen in advance (it is in section 7.9 of the lead note): no monomial of the arc contains y5, so
F_eps = y5^3 + Phi_eps(the other seven variables) at every order, y5^2 lies in the kernel of Cat(2,2) exactly,
and the cubic y5^3 has all its partial derivatives in the kernel. In the dry run the 144 x 120 system showed one
exact null vector (singular value 1e-61) and two more at the truncation level, then 6e-6.
What this means for the test, if the splitting of T2 holds: G_A is not in the span of y5^3 and Phi_eps (a
determinant with independent entries has the irreducible 8-dimensional representation of sl_3 on the linear
forms, so no invariant line y5), hence the space of (a) contains y5^3, G_A, G_B and has dimension at least 3.
Revised (a'): the space is expected to be exactly 3-dimensional at the truncation level, with the next singular
value falling like a low power of eps (a genuine small number), not like eps^20.
- nullity 2: then y5^3 is a combination of F_eps and the other null vector; the argument just given says the
  summands cannot both be determinants: (S) in trouble on this arc.
- nullity 3: consistent with y5^3, G_A, G_B. Go on to (b').
- nullity 4 or more at the truncation level: extra cubics; the special members are then not found by a
  one-parameter problem. Stop and describe.
Revised (b'): with H the null vector orthogonal to y5^3 and F_eps, the special members are H - t F - u y5^3.
Modulo the eight monomials y5^2 y_i the term u y5^3 drops out, and t is a generalized eigenvalue of the reduced
pair (vector fields applied to H, to F; 112 x 64). Expected: eigenvalue "infinity" 8 times (the fields
y_i d/dy5, which kill F modulo y5^2 y_i: not of interest), and exactly 16 genuine finite eigenvalues in two
clusters of 8 at t_A != t_B; for each cluster one number u fits the eight remaining equations. Since
F = G_A + G_B forces the three cubics onto one line of the plane, u_A = u_B is a consistency check that is
not imposed. Then G_A = (H - t_A F - u y5^3)/(t_B - t_A), G_B = F - G_A, and |G_A| eps^6 should tend to a
non-zero constant. Other outcomes as in (b).

Note of 20:59 UTC, after steps 1 to 3 at eps = 1/16, 1/25 (stopped by the old stopping rule), 1/40, 1/64,
1/100 and before any attempt to build matrices. What was seen (NUMERICAL): nullity 3 as in (a'); 17, not 16,
genuine eigenvalues, in groups of 8 and 9, clean only for eps <= 1/40 (at 1/16 and 1/25 the 56 finite
eigenvalues crowd together and the groups cannot be separated: the special members are close to a cube, which
has 56 vector fields); u_A = u_B to 1e-17 .. 1e-24; |t_B - t_A| falls like eps^6.0; |G_A| eps^6 = |G_B| eps^6
= 1078.7, 1078.5, 1078.5. The first summand has 8 vector fields, the second has 9 (singular values at the noise
level; the next one falls like eps^8, resp. eps^10). So M6's third outcome occurred for one summand:
"dimension more than 8: a degenerate summand; describe it before going on". Deviation recorded: the values of
eps 1/40, 1/64, 1/100 were added to the pre-registered 1/10, 1/16, 1/25 because the signal-to-noise ratio
grows like eps^-14; the precision was raised to 90 digits for 1/64 and 1/100.

What a 9-dimensional algebra could be. For det B with B a 3 x 3 matrix whose nine entries span the 8 linear
forms, one linear relation tr(C B) = 0 holds. The algebra of (P, Q) acting by B -> P B + B Q and preserving the
relation and the determinant has dimension 8 if rank C = 3 (sl_3; the case of detrep_lib) and 9 if rank C = 2
(my count: B = [[a, b, c], [d, -a, e], [f, g, h]] with independent a..h; algebra (sl_2 + 2-dimensional torus)
with a 4-dimensional nilpotent ideal; ARG, unreviewed). A general element of that algebra has 8 distinct
eigenvalues on the linear forms, its eigenforms are the entries a..h, and in them
det B = -a^2 h - a e g - b d h + b e f + c d g + a c f: six monomials, with one invariant of the coefficients,
c(a^2 h) c(bef) c(cdg) / (c(aeg) c(bdh) c(acf)) = -1.
Test (step 5'): for the summand with 9 vector fields, take a random element of the algebra, pass to its
eigenforms, list the monomials of the summand.
- exactly the six monomials above (after naming the eigenforms) and the invariant -1 to the noise level: the
  summand is a determinant with a relation of rank 2. Then both summands are determinants and M7 goes on. Such
  sums form a proper subfamily of the two-determinant family (one more condition); for an arc inside the cubics
  y5^3 + Phi this special position is not a surprise, but it means the arc does not sample a general point of
  the family, and I will say so.
- another list of monomials: the summand is some other cubic with 9 vector fields; on this arc the splitting is
  then not into two determinants in the sense of (S). Describe the monomials; do not force a matrix.
- eigenvalues not distinct for every random element tried: the algebra is not of the kind counted above; same
  conclusion as the previous item until understood.
Step 6' (polish): the two summands are each known only to about 1e-22 relative, i.e. to about 1e-7 absolute
(they are of size eps^-6), so det A + det B - F_eps from step 5 alone is expected to be about 1e-7, not at the
truncation level. A damped Gauss-Newton iteration on the 144 entries of (A, B) against F_eps follows; M7 is
read after it. If it converges to the truncation level only by leaving the special type of B, that is reported.

Note of 21:06 UTC, after the first attempt at step 5 / 5' (eps = 1/64). Outcome: for the summand with 8
vector fields the method of detrep_lib works, but only to 1e-9 (det(matrix) - G_A relative 1.2e-9, weight
structure violated at 1.6e-9, "zero" eigenvalues at 1e-11 of the scale), far above the noise 1e-22 of G_A.
For the summand with 9 vector fields the eigenforms of a random element gave NO sparse list of monomials (nine
monomials of comparable size). I do NOT read this as the pre-registered second outcome of 5' yet, because the
computation was done in the coordinates y, in which the summand is c l^3 eps^-6 plus terms smaller by eps^6
and eps^12: the eigenvectors of a random element are then nearly parallel and the change to eigenforms
multiplies the noise by the cube of a huge condition number. A test that cannot tell a determinant from a
non-determinant is not a test. Change of method, fixed before rerunning: first bring each summand into
balanced coordinates (repeat y -> mu^(-1/6) y, mu the second-moment matrix of the cubic, determinant 1; for a
cubic with a closed SL_8-orbit this converges to a minimal vector, where the symmetry algebra is closed under
conjugate transpose and eigenvectors are well conditioned). Expectations, written now:
- G_A (8 fields; a determinant with relation of rank 3 is in the orbit of det restricted to sl_3, which is a
  minimal vector): the iteration converges (mu proportional to the identity), and step 5 then holds to about
  the inherent accuracy (noise 1e-22 divided by the relative size eps^6 .. eps^12 of the structure).
- G_B (9 fields): a determinant with relation of rank 2 is UNSTABLE for SL_8 (weights a: 1, h: -1.5,
  b, d: 0.8, c, e, f, g: -0.275 make all six monomials positive; ARG), so the iteration cannot converge; it
  is run a fixed number of steps only to remove the gross imbalance, and 5' is then read: six monomials and
  invariant -1 (determinant with relation of rank 2), or not.
The condition number of the eigenvector matrix is printed, so that a failure of 5' with a small condition
number counts as a real failure.

Note of 21:25 UTC, after the runs at eps = 1/64, 1/100 (90 digits) and 1/800 (170 digits) with the
construction of matrices. What was seen (NUMERICAL):
- The balancing step did not work as coded (the norm did not decrease along the direction used; no movement
  in 400 steps) and was dropped. Nothing is concluded from it.
- First summand G_A: 8 vector fields at every eps; the method of detrep_lib gives a matrix with
  |det(matrix) - G_A| / |G_A| = 1.2e-9 (1/64), 5.2e-11 (1/100), 8.1e-20 (1/800). G_A is also close to a
  determinant with a relation of rank 2 (six monomials, invariant -1), with mismatch 4.8e-11, 4.1e-12, 1.1e-16:
  that mismatch falls only like eps^5 and is a real deviation; the 9th vector field is broken at eps^8.
- Second summand G_B: at 1/64 and 1/100 it showed 9 vector fields at the noise level, and I wrote above that
  it has 9. At eps = 1/800 the 9th singular value (1.8e-38, that is 1.0 eps^13) is above the noise (5.5e-41):
  G_B has 8 vector fields, the 9th is broken at eps^13 and was simply below the noise at the larger eps.
  CORRECTION to the note of 20:59: "the second has 9" is withdrawn; the special position "relation of rank 2
  exactly" is NOT supported. Both summands have 8.
- For G_B no matrix was obtained: its 8 fields are known only to 0.3 per cent (noise over the 9th singular
  value), which is too coarse for the root pattern of sl_3 at tolerance 1e-8, and the eigenvector matrix of its
  9 near-fields has condition number 1e11 .. 1e18, so step 5' cannot be read for it (not a failure of the
  summand: a failure of the test, as the printed condition number shows).
- det A + det B - F_eps is NOT small at this stage, and cannot be: each summand is of size eps^-6 and known to
  relative 1e-19 .. 1e-40.
Next attempt, fixed now: (i) for G_B accept the root pattern at tolerance 1e-2 to get a rough matrix;
(ii) Gauss-Newton on det M = G separately for each summand (the equations are consistent to the noise);
(iii) Gauss-Newton on det A + det B = F_eps jointly (F_eps is known to the truncation level, 1e-45 at 1/800).
Outcomes: (ii) converges for both and (iii) reaches the truncation level: M7 at this eps. (ii) fails for B:
no matrix for B; then the statement stays "A found, B not", and M7 is not reached. (iii) stalls above the
truncation level: report the floor; it would then have to be compared with a second eps before reading it.

## Outcomes of the second route (21:36 UTC, 26 Nov 2026; logs in logs/, matrices in results/)

Runs kept: eps = 1/16 (60 digits; stops at step 3), 1/40 (60), 1/64 (90), 1/100 (90), 1/800 (170 digits).
The value 1/10 of the pre-registration was not run (1/16 already fails to separate the eigenvalues), and 1/25
was run only to the old stopping rule (same failure). Recorded as deviations.

Step 0 EXACT: T_8..T_19 determined uniquely; `mx3b_verify_arc.m2`: the 8 x 19 expansion is zero.
M5, in the form (a'), (b'): AS PREDICTED for eps <= 1/40 (NUMERICAL). 12 + 6 + 18 singular values, the 6 equal
to 13.9 eps^2 .. 77 eps^2, the 18 falling like eps^20 (2.6e-22, 2.2e-26, 2.9e-30, 2.5e-48 at 1/40, 1/64, 1/100,
1/800). Nullity 3 (y5^3, F_eps, one more); the next singular value is 0.027 eps^3. Two special members; u_A = u_B
to 1.2e-17, 1.6e-21, 4.4e-24, 2.8e-38; |t_B - t_A| / |t_A| = 0.0410 eps^6. In appearance not as predicted: a 17th
eigenvalue of the reduced pair passes the residual test at 1/40, 1/64, 1/100. At 1/800 its residual (3.0e-40)
stands above the first 16 (at most 2.8e-44) and falls like eps^13.7 from 1/100, not like the noise (eps^17.8): it
is the 9th near-field of G_B (below), not a genuine eigenvalue. So 16 = 8 + 8, as predicted, once the noise is
low enough to see it. At eps = 1/16 and 1/25 nothing can be separated.
M6: AS PREDICTED in substance, with one error of mine on the way. Both summands have 8 vector fields. The 9th
singular value is 8.7e-5 eps^8 for G_A; for G_B it is 1.0 eps^13, below the noise at 1/40, 1/64, 1/100 and visible
only at 1/800, so for an hour I recorded "G_B has 9" (withdrawn above). G_A, G_B = -+(2187/64) l^3 eps^-6
(1 + O(eps)), l = y0 + z^4 y1 + z^4 y2 + z^2 y3 + z^2 y4 + y5 (the coefficient: -34.171875 - 0.000001 i at
1/800; 2187/64 = 34.171875); |G_A - c l^3| / |G_A| = 0.753 eps.
M7: NOT REACHED. A matrix was found for G_A only: |det A - G_A| / |G_A| = 4.7e-5, 1.2e-9, 5.2e-11, 8.1e-20 at
1/40, 1/64, 1/100, 1/800 (the sl_3 method of detrep_lib, no polish). For G_B none: its 8 fields are known to
0.3 per cent only (noise 5.5e-41 against the 9th singular value 1.8e-38 at 1/800), and the eigenvector matrix
is too ill-conditioned (1e11 .. 1e18). The Gauss-Newton polish never ran successfully (the ball-arithmetic
solve fails on the badly scaled normal matrix). So "det A + det B = F_eps at the truncation level" was not
tested, and the control with the series cut at order 13 was not run.
M3: for A only. The nine 2 x 2 minors of A lie in the kernel of Cat(2,2) of the transported class: relative
distance 8.3e-7, 8.6e-11, 2.2e-12, 4.9e-21; they are independent.
M8: not done beyond the leading cube above; A is in the gauge the method produces, not in a normal form.

What these runs rule out: nothing about the family. What they do not establish: that G_B is a determinant; any
statement at the truncation level about det A + det B; anything off this one arc; the flat limit of T.

## Blind check 12 (26 Nov 2026, 21:35 to 21:58 UTC; a separate agent, its own Python and Macaulay2 code)

Report, scripts and outputs: `leads/tenfold_twodet/blind_check12/`. It did not read the pipeline, this file or the
logs. Confirmed: the arc to order 19 with an implementation of its own (and the whole period file, 6600 entries,
up to one constant); the numbers of M5, M6 and of the matrix A; the counts 8 / 9 / 12 for relations of rank
3 / 2 / 1 (exact over QQ). Corrections, all accepted:
1. A constant of mine was wrong by a slip of arithmetic: the 9th singular value of G_A is 8.7e-5 eps^8, not
   87 eps^8 (corrected above and in the notes).
2. "|det A - G_A| / |G_A| = 8.1e-20" does not by itself tell G_A from -G_B = G_A - F_eps, because |F_eps| / |G_A|
   is 1.0e-20: in absolute terms det A - G_A is 8 times |F_eps|. What the data support (the checker's linearised
   test): det A - G_A is, up to 1.4e-40 |G_A| (the noise), an infinitesimal linear change of coordinates applied to
   G_A (a matrix of norm 2.5e-11), while F_eps has a part of size 1.83 outside those directions. So: "det A is, to
   first order and within the noise, G_A in slightly changed coordinates". No non-linear fit was done.
3. "Each summand has 8 vector fields" holds for G_B at eps = 1/800 only (factor 459 above the noise; at the other
   three eps it shows 9). The checker showed that the value 1.8e-38 is not an artifact of the truncation (it does
   not move when the series is cut at order 18 or 17); the law eps^13 still rests on that one point.
4. For G_B the fields were not shown to form sl_3 (the checker's Killing-form test is inconclusive), so nothing
   supports "G_B is a determinant" beyond the count 8 at one eps.
5. Of the 18 small singular values of Cat(2,2), 6 fall like eps^20, 11 like eps^22, and one is exactly 0 (y5^2).
