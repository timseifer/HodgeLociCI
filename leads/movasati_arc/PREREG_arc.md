# Pre-registration: an arc at Movasati's own point in a direction that is not a cone, past order 6

26 Nov 2026, 22:14 UTC (from `date -u`), Claude Fable 5.2 for Timothy Seifert. Owner: "move forward with
the next most exciting lead"; "is there anything that comes out of the work we just did and the big headline
results ... [the two-determinant headline] has something about going out to 6". AI-written, unreviewed.
Labels: EXACT / MOD p / PROVED (AI, unreviewed) / ARG / LIT / OPEN / NUMERICAL.

## Why this lead

The weakest number on the headline card "Two determinants on cubic tenfolds" is: at Movasati's own point the
evidence stops at order 6, at one prime and one direction (D-TENFOLD-MOVASATI-ORDER6, MOD p; the package's
default continuation is obstructed at order 7 and that was not analysed). Tonight's batch
(D-SIXFOLD-ARC-ORDER19) took T2's sixfold arc from order 7 to order 19, exactly, by one change of method: do
not let the engine choose the undetermined terms; carry unknown coefficients in a slice in which the arc is
unique and let the equations of several orders close up. The same method applies at Movasati's point.

## Read first (registry), and what is NOT repeated

D-TENFOLD-ORDER4-MODEL-CONE, C-TENFOLD-ORDER4-RANK2, D-TENFOLD-MOVASATI-ORDER6 (tenfold: 27 model quadrics, the
13-dimensional piece, order 6); D-EIGHTFOLD-BOUNDS-AT-MOVASATI-POINT (eightfold: nine quadrics, cone of
codimension 7; a tangent vector unobstructed through order 6 inside a 20-dimensional family);
D-X1-COMPONENT-IS-TD-CLOSURE, D-GLOBAL-ARGUMENT (paper chain: the closure of l Q + det A + det B passes through
the eightfold Movasati point); D-PAIR-TYPE-TABLE; O-OTHER-COMPONENTS-AT-X1 ("no arcs outside the cone-type
family there"); O-TENFOLD-CONE-LEAD; D-SIXFOLD-GERM-AT-MOVASATI-POINT (sixfold: W_lambda exists for lambda =
-1, 2, 5/3: cones over sixfold arcs do not single out -1); D-LAMBDA2-CONE-TYPE (T3's cone map).
Not repeated: order 4 on the tenfold; the order-6 run; cone-type directions z_0 C' (they exist for every lambda).

## Theory (ARG)

1. Tenfold Movasati point: normal directions to V_Z are nets N = z_0 A + z_1 B + z_2 C. A net with C = 0 does not
   involve the block (x10, x11): the tenfold arc is then the cone (Thom-Sebastiani with x10^3 + x11^3) over an
   arc at the EIGHTFOLD Movasati point with net A y_1 + B y_2, and by the cone map a class that stays Hodge
   along the eightfold arc stays Hodge along the tenfold one. So an eightfold arc in a direction with A and B
   both non-zero gives a tenfold arc at Movasati's point in the 13-dimensional piece that is not a double cone
   over a sixfold. On eightfolds the engine has 45 period functions and 120 monomials (tenfold: 221 and 220).
2. Eightfold model cone (T3): nine quadrics, the y_1 y_2-coefficients of the 2 x 2 minors of A y_1 + B y_2.
   Pieces by hand: A invertible, B = 0 (dimension 9) and the same with A, B exchanged; both of rank <= 1 with a
   common column or a common row (two pieces of dimension 8); and the piece of interest: common kernel and
   cokernel, two 2 x 2 blocks orthogonal for the polar form of det (dimension 2 + 2 + 7 = 11 = 18 - 7).
3. If a second component W of dimension dim V - 6 passes through the point with tangent cone the 11-dimensional
   piece (what the paper chain says for lambda = -1), then through a smooth direction of the piece there is an
   arc, and in a linear slice of dimension codim W + 1 = 27 in general position it is unique: 26 unknowns per
   order against 45 equations. The equations of order n do not determine T_n (the first-order map has rank 19);
   they close up after a few more orders, as on the sixfold.
4. Control. On the tenfold, lambda = 2 is obstructed at order 6 on a direction of the piece (modulo the
   corrections tested). If the same holds here, the slice system for lambda = 2 becomes inconsistent at order 5
   or 6 while lambda = -1 goes on.

## Step 1: a cheap probe (MOD p; minutes) -- predictions written before the run

Eightfold Fermat cubic, Movasati's pair P1 = {x_(2i) = z x_(2i+1)}, P2 = {x_(2i) = z^3 x_(2i+1), i < 3;
x_(2i) = z x_(2i+1), i = 3, 4}; T_1 = y_0 + sum N_ijk f_i h_j x_(7+2k), as in vz4 for the tenfold.
Q0. rank L = 19 and joint persistence codimension 20 for lambda = -1 and for 2 (26 dependent equations of 45).
    Otherwise: I have the wrong pair or the wrong reading of the registry; stop.
Q1. Order 4 (fermatExtendArc): a generic net is obstructed at order 4; a net of the 11-dimensional piece
    (case d: generic in the piece; case s: A = E01 + E10, B = E01 - E10, which has a symmetry of order 3) is not;
    the nine model quadrics vanish on d and s and not on the generic net.
    - as predicted: the model of T3 is the right frame and s can serve as a symmetric direction.
    - d or s obstructed at order 4: the piece is not what I computed by hand; redo the theory before anything else.
Q2. Orders 5 to 7 with the package's default continuation, lambda = -1 and 2, cases d and s: NO prediction, and
    nothing is read from where a default continuation stops (the tenfold showed that a stop can be removable).
    Recorded only to size the main computation (time per order).

## Step 2: the main computation (hours; to be approved by the owner before it starts)

M1. Choose a monomial slice of dimension 27 through T_1 that is transversal (the block system of point 3 has the
    expected rank), MOD p first. Solve for the arc with unknown coefficients, lambda = -1: prediction: the system
    is consistent and determines the arc to every order reached (target: order 10 or more).
    - as predicted, MOD p at two primes: at the eightfold Movasati point, in a direction that is not a cone over
      a sixfold, [P1] - [P2] stays a Hodge class to order N. By the cone map the same for the tenfold in the
      13-dimensional piece, replacing "order 6, one prime, one direction" on the headline card.
    - inconsistent at some order for every transversal slice tried: the first evidence AGAINST a component in
      that direction at Movasati's point (so against that part of the headline); it would have to be confirmed
      on a second direction and a second prime, and compared with D-EIGHTFOLD-BOUNDS-AT-MOVASATI-POINT.
M2. The same slice system for lambda = 2: prediction: inconsistent at order 5 or 6.
    - consistent to the same order as -1: the direction does not single out -1 (like a cone direction);
      choose another direction before reading anything.
M3. Characteristic 0: the same in exact arithmetic over QQ(zeta_6), in the symmetric direction s if the
    invariant slice is small enough; then the cone to the tenfold, checked with the tenfold's own 221 equations
    to the order that fits.
What no outcome gives: a proof that a component exists (finite order), and nothing about classes that are not
algebraic: if the paper chain holds, this component carries the class of an algebraic cycle.

## Outcome of step 1 (22:18 UTC; logs/ma1_*.log; MOD 32029, seed 1)

Q0 as predicted: rank L = 19, joint 20, for lambda = -1 and 2. Q1 as predicted: the generic net is obstructed at
order 4; cases d, s (and the cone case E) pass order 4, and the nine model quadrics vanish exactly on those.
Q2 (no prediction): the default continuation stops at order 5 for d and s and at order 6 for E, for both
lambda; each call takes seconds. So the eightfold engine is fast enough that the MOD p part of step 2 is
minutes, not hours; only the exact part is expensive. I therefore run M1 and M2 MOD p now and keep the owner's
approval for the exact part.

## Step 2, the algorithm as it will be run (fixed before the run)

Slice: T_1 fixed; T_n (n >= 2) in the span of a set U of 26 monomials chosen at random among the 120 subject to:
L restricted to U has rank 19 (so 7 free directions tau_1..tau_7 = ker L in span U, and 26 dependent equations).
At order n the system for T_n is L T_n = known; when it is not solvable, the obstruction o_n (26 numbers) can
only be changed, inside the slice, by the free part of T_(n-3): the dependent equations vanish to order 3 on
the smooth germ, so their order-n coefficient is affine in the free part of T_(n-3) with a fixed 26 x 7 matrix
D (the derivative of the order-4 forms at T_1; the same D for every n). D is measured once by finite
differences (change T_(n-3) by tau_i, re-extend two orders, read the obstruction) and checked for linearity on
a random combination. Then: o_n in Im D: correct T_(n-3), go on; o_n not in Im D: OBSTRUCTED at order n in this
slice. rank D = 7 is required (uniqueness of the arc in the slice); if rank D < 7 the slice is not transversal
and another U is drawn. Every corrected arc is re-verified from scratch with fermatVerifyArc at the end.
Reading: "passes to order N" = [P1] + lambda [P2] stays Hodge to order N along an arc with this T_1 (finite
order: evidence). "Obstructed at order n" = no arc with this T_1, integer powers of eps and terms in this
slice; since the slice is transversal this means no component with a reduced tangent cone through this
direction, for this lambda (MOD p, one direction).

## Outcome of step 2, MOD p part (23:08 UTC; logs/ma2_*.log, ma3_*.log)

A change to the algorithm, made after the first three slices and before any result was read: with 26 random
monomials as the slice the response matrix had rank 5 or 6, not 7 (the free directions did not see the model
cone). The slice is now 19 monomials with independent columns of L plus 7 NET directions, chosen among the 18
after measuring D on all of them. With that: D has rank 7 = 18 - 11 on the 18 net directions, D(y_0) = 0, D is
linear on a random combination, and D measured again at order 6 equals D measured at order 5 (as the theory
says). After that D is measured once and reused; a correction that fails would trigger a new measurement (it
never did).

M1 AS PREDICTED (MOD p). lambda = -1:
- p = 32029, seed 1 (direction d, slice 1): the obstructions of orders 5, 6, 7, 8 lie in Im D and are removed by
  the free parts of T_2, T_3, T_4, T_5; the arc of 8 terms passes fermatVerifyArc (45 forms).
- p = 31981, seed 2 (another direction d, slice 1): the same to order 7.
M2 AS PREDICTED (MOD p). lambda = 2: order 5 is repaired by the free part of T_2, then the order-6 obstruction
is NOT in Im D: at p = 32029 seed 1 in slice 1 and in slice 2, and at p = 31981 seed 2 in slice 1.
Cone to the tenfold (MOD 32029): the 8 terms, read on the Fermat tenfold with x_10, x_11 untouched, pass
fermatVerifyArc with the tenfold's own 221 equations at Movasati's pair of 5-planes (rank L = 38 against 39;
T_1 in ker L and not tangent to the locus where P1 persists); the control class [P1] + [P2] fails at order 1.
Cost: one prime and direction to order 8 takes 18 minutes; each further order costs about 3.5 times the last.
Not done: characteristic 0 (step M3, needs the owner's approval: hours); the symmetric direction s; order 9
unless a line is added below.

Added 23:40 UTC: order 9 (logs/ma2_32029_seed1_lam-1_d_order9.log; continued from the state file of the
order-8 run). MOD 32029, seed 1, lambda = -1: the order-9 obstruction lies in Im D and is removed by the free
part of T_6; the arc of 9 terms passes fermatVerifyArc (45 forms). As the method requires, T_6, T_7, T_8 of the
9-term arc differ from those of the 8-term arc (arcs/arc9_... against arcs/arc8_...): the free part of T_6 is
fixed only by order 9. The tenfold check was run on the 8-term arc only. Order 9 took 21 minutes of cpu plus 8
for the final verification.

## Blind check 13 (26 Nov 2026, 23:00 to 23:45 UTC; a separate agent; code of its own in python-flint)

Report, scripts, outputs: `leads/movasati_arc/blind_check13/`. It read none of my scripts or logs.
Confirmed (MOD p, own implementation of the period formula, and the package as a black box): the arcs for
lambda = -1 to order 8 (p = 32029) and 7 (p = 31981), and, outside the brief, the 9-term arc to order 9; the shape
of the nets; the tenfold's 221 equations to order 8 and 7; the obstruction for lambda = 2 at order 6 in my slice.
Strengthened: for lambda = 2 the checker showed that NO choice of T_2..T_6 in the full space of cubics passes
orders 2..6 with the given T_1, at both primes (exact linear algebra plus polynomial identities tested at random
points), so the slice is not needed for that verdict; and as a control that for lambda = -1 every admissible T_2
continues through order 6.
Corrections and caveats, all accepted:
1. "A direction that is not a cone" must read "not a cone over a sixfold": the tenfold arc IS a cone over the
   eightfold arc, and the tenfold check adds no evidence beyond the eightfold one (it is automatic).
2. My sentence "the order-n obstruction is affine in the free part of T_(n-3) with one fixed matrix" is right for
   the linear part and incomplete: the obstruction also depends on the free parts of T_(n-4), ..., T_2 (a second
   response map of rank 11, and a quadratic term at n = 6). In the slice those are already pinned, so the
   algorithm is unaffected; the general statement holds here because the first two response maps vanish.
3. The reading of the lambda = 2 obstruction needs "tangent cone reduced as a scheme at T_1"; for a component of
   dimension dim V - 6 that is automatic from the rank 7. With the full-space result: no component of dimension at
   least dim V - 6 has this T_1 in its tangent cone, and no component of any dimension has a tangent cone reduced
   and smooth at T_1 (finite order, one direction per prime, MOD p).
4. T_1 is special inside the 94-dimensional candidate cone: it has no component along the 64 directions tangent
   to V that are neither nets nor cubics in x_0..x_5. For lambda = -1 the arcs are evidence at such directions
   only. And no direction was run at two primes: the two primes carry two different directions.
5. The free parts of the last three terms of each arc file are placeholders (fixed only by later orders).
A practical note from the checker: its python-flint expansion is about five times faster than the package's at
order 8 (`blind_check13/lib13.py`); worth using for the next orders.

## Step M3: characteristic 0 (owner: "yes go ahead"; pre-registered 27 Nov 2026, 00:01 UTC, after the exact run
## had reached order 4 and before any exact result beyond it was read)

Script `ma4_exact.m2`: the algorithm of ma2 with p = 0 (EXACT over QQ(zeta_6)), every choice deterministic (y_0 a
fixed integer combination of a kernel basis; slice by a greedy pass over the monomials in their natural order;
free directions the first 7 net directions with independent images), linear algebra by the package's own row
reduction. Direction s: A = E01 + E10, B = E01 - E10 (in the 11-dimensional piece; rank 2 each, common kernel and
cokernel, polar form 0). With p > 0 the same script is the control. Control already run (MOD 32029, lambda = -1):
passes to order 7, D of rank 7 (logs/ma4_32029_lam-1_s.log).
Predictions. E1: exact, lambda = -1: orders 5, 6, 7 (and beyond, as far as time allows) are repaired; the arc
passes fermatVerifyArc exactly. E2: exact, lambda = 2: obstructed at order 6 (order 5 repaired).
- E1 and E2 as predicted: the separation of -1 from 2 at Movasati's point holds in characteristic 0 on this
  direction, to the order reached; the headline number becomes EXACT (one direction, finite order).
- E1 obstructed exactly at some order where MOD p passed: then the MOD p results were a coincidence of the
  primes or the direction s is special; report as a correction.
- E2 not obstructed exactly: the MOD p obstruction for 2 does not lift; report as a correction.
Also a second net f = ([[1,2],[0,1]], [[1,0],[1,1]]) blocks, polar form 0, if time allows.

### Note of 27 Nov, 00:52 UTC, before any exact result for lambda = 2 was read: the direction s does not separate

MOD 32029 controls, not predicted: for lambda = 2 the order-6 obstruction is REMOVABLE on the symmetric net s
(with the deterministic y_0 and with a random y_0: logs/ma4_32029_lam2_s.log, ma2_32029_seed1_lam2_s.log) and on
the net f (ma4_32029_lam2_f.log). Both have their common kernel and cokernel along coordinate vectors (the third
row and column vanish). On a net with the same blocks moved by fixed integer matrices G3, H3 (case g, kernel and
cokernel not along coordinates) lambda = 2 is obstructed at order 6 again (ma4_32029_lam2_g.log), as for the
random nets d. So the separation of -1 from 2 at order 6 holds for nets in general position, not for nets
aligned with the coordinates; this matches the checker's caveat that the tested directions are special.
Consequence for M3: the exact separation test is run on case g (E1, E2 for g); the exact run on s for lambda = -1
is kept as an exact arc, but it cannot decide anything about 2. The lambda = 2 exact run on s was stopped.
An aligned net passing order 6 for lambda = 2 is plausible because the arc then sees a product structure (no
f_2, h_2 in the net); not analysed (OPEN).

### Outcome of M3 (27 Nov, 02:10 UTC; logs/ma4_exact_*.log, ma5_exact_g_lam-1_order7.log; arcs/exact_*.txt)

EXACT over QQ(zeta_6), deterministic choices:
- net g (general position), lambda = -1: orders 5, 6, 7 repaired by the free parts of T_2, T_3, T_4; the 7-term arc
  re-verified from scratch by ma5 (fermatVerifyArc, 45 forms: pass; [P1] + [P2] fails at order 1). The run was
  stopped by hand during order 8 (each exact order costs about 3 times the last; order 7 took 20 minutes).
- net g, lambda = 2: order 5 repaired, order 6 OBSTRUCTED (not in Im D) in the slice.
- net s (aligned), lambda = -1: orders 5 to 9 repaired; the 9-term arc passes fermatVerifyArc exactly.
E1 and E2 AS PREDICTED for net g (the separating direction; see the note above for why s does not separate).
So on one direction in general position at Movasati's point the separation of -1 from 2 at order 6 holds in
characteristic 0, with lambda = -1 continuing exactly to order 7. Finite order; one direction; the slice reading
for lambda = 2 (the full-space statement is MOD p, blind check 13; the exact full-space test is in blind check 14).

### Blind check 14 (27 Nov, 02:12 to 02:40 UTC): `blind_check14/REPORT.md`. Confirmed (exact to orders 8 / 6 with the
package, MOD p to 9 / 7 with own code); lambda = 2 on g obstructed in the full space MOD p; aligned nets pass order 6
for lambda = 2 (explicit jets). Corrections accepted: "separation in characteristic 0" holds in the slice only; the
aligned/general reading rests on one net and may instead be about the net's position relative to y_0.

## Step 3: the aligned pocket for lambda = 2 (owner: "Go ahead"; pre-registered 27 Nov, 02:50 UTC, before the runs)

Question: on the aligned nets s and f, where lambda = 2 passes order 6, how far does it go, and is the arc the
trace of a family that exists for every lambda?
Runs (MOD 32029, ma4_exact.m2, deterministic): lambda = 2 on s and on f to order 8; then the same at a second
prime (31981) for whichever survives.
Outcomes and meaning:
- obstructed at order 7 or 8 on both: the pocket is a finite-order effect; the separation of -1 from 2 just sets in
  later on aligned directions. Record the order. Nothing new about classes.
- passes order 8 on both, at two primes: a lambda = 2 direction at Movasati's point that survives as far as -1 does.
  Next test (pre-registered here): whether the arc is the trace of a family known for every lambda. Candidate:
  a cone-type (Thom-Sebastiani) family; test by checking whether the arc can be chosen inside a sub-family that
  splits off a block of variables (re-run the slice restricted to monomials that do not couple that block). If
  yes: explained (algebraic by the cone construction). If no such splitting is found: a candidate locus for a
  Hodge class not known to be algebraic -- to be reported as a candidate only, with every caveat, never as more.

### Outcome of step 3 (03:06 UTC; logs/ma4_32029_lam2_{s,f}_order8.log, ma4_31981_lam2_{s,f}_order8.log)

First outcome: lambda = 2 on the aligned nets s and f passes order 6 and is OBSTRUCTED at order 7 in the slice, at
p = 32029 and p = 31981 (four runs). The pocket is a finite-order effect: on aligned directions the separation of
-1 (which passes order 9 exactly on s) from 2 sets in one order later. The pre-registered cone/splitting test is
therefore not needed. Full-space version at order 7: blind check 15.

### CORRECTION by blind check 15 (27 Nov; `blind_check15/REPORT.md`): the pocket does NOT close for net s

In the FULL space of cubics (not my slice), lambda = 2 on net s passes order 7 at both primes: the checker built
explicit jets T_1..T_7 and checked them directly. On net f (F1, F2) the order-7 obstruction holds in the full space
(MOD p + ARG). So my "outcome of step 3" above is withdrawn for s. Lesson (recorded as a dead end): from order 7 on
the slice method can report an obstruction that a full-space search removes, because the order-n condition then
depends on the free part of T_2 beyond the linear response D (the "level 4" map of blind check 13). The slice
verdicts at order 6 that were checked in the full space (net g, the random nets d) stand.
Status of the pocket: OPEN; net s, lambda = 2 survives to order 7 (MOD p, two primes). The pre-registered next test
(order 8 in the full space, then the splitting test) is the next step.
