# The lambda = 2 aligned pocket at the eightfold Movasati point: checkpoint A1 (published 27 Nov after the owner had seen it)

27 Nov 2026, 07:25 UTC. Claude Opus 5.5. AI-written, unreviewed. MOD p throughout, finite order, one direction
(net s: A = E01 + E10, B = E01 - E10; T_1 = y_0 + net). Time spent on this step: about 2 hours of the 3-hour cap.

## What was pre-registered (PREREG_arc.md, step 3c, written 05:33 UTC before any order-9 run)

Per order n >= 5 the jet space with fixed T_1 grows by 94 - r_n, r_n = rank of the conditions q_n left after the
linear corrections. A smooth component of codimension c through T_1 gives r_n = c - 26 in the steady state, and its
extra conditions must move along (k_2 at order 7, k_3 at order 8, k_4 at order 9).
- (H1) trace of CT_2 (codimension 36): needs T_1 tangent to CT_2; steady r_n = 10.
- (H2) a component of dimension dim V - 6 (the lambda = -1 situation): r_n = 0. Excluded by r_7 = 2.
- (H3) a smooth component of codimension 28 (dim V - 8), not a known family: r_n = 2, conditions moving along.
- (H4) no component with a reduced tangent cone through T_1: conditions keep falling on k_2.

## Results

1. Splitting test (the decisive one, per your plan): DECIDED AT FIRST ORDER. CT_2 is cubics c(8 variables) + u^3 + v^3
   up to coordinate changes; for this pair of planes the split-off block must be (x6, x7) or (x8, x9) (a pair on
   which the planes have different roots forces both planes to persist, i.e. lies in V). Modulo J its tangent
   directions do not couple the block to the rest. T_1 has 4 monomials coupling (x6, x7) and 2 coupling (x8, x9)
   to the rest (inspection of arcs/jet8_32029_s_lam2.txt). So T_1 is NOT tangent to CT_2 for either block, and
   the restricted problem does not contain the arc at all. (H1) is excluded. Label: ARG (the description of T CT_2
   modulo J) plus an exact inspection.
2. Order 9 (prime 31981; the run at 32029 died twice, apparently out of memory in the order-9 expansion):
   - the order-8 jet exists (direct check, as before); ob_9 has 19 non-zero components, q_9 has 12 of 19 non-zero;
   - q_9 changes with k_4 in ker J4 with rank 2, staying on V8 (first run; the rerun died before this step, so the
     linearity test "2v against v" was not completed);
   - moving k_3 in ker J3 at the V8 point breaks q_8 (2 components), i.e. at this point q_8 DOES depend on k_3 --
     although at the base jet of the order-8 run it did not. So the order-8 dependence on k_3 is point-dependent
     (bilinear in k_2 and k_3, not a fixed linear map).
   Reading: the conditions do move along (k_2 at 7, k_3 at 8, k_4 at 9), which is the (H3) pattern, but not in the
   clean "one fixed linear map" form a smooth component would give. AMBIGUOUS between (H3) and (H4). By your rule
   order 10 would be next; I did not run it: it needs a nonlinear solve on V9 and the order-9 expansion already
   exhausts memory with two jobs; it would exceed the cap.

## Verdict

By the pre-registered rule ("no splitting found -> a candidate, reported as a candidate only") this is a WEAK
CANDIDATE: a direction at the eightfold Movasati point along which [P1] + 2[P2] stays Hodge to order 8 (two
primes), not tangent to the known cone-type family CT_2, with jets losing about 2 dimensions per order (consistent
with a component of dimension dim V - 8, which is allowed by the bound dim <= dim V - 7 of D-GLOBAL-ARGUMENT).

Every caveat:
- finite order (8), MOD p (two primes), one first-order direction, integer powers of eps; nothing exact;
- order 9 at one prime only, with the key linearity test not completed; (H4) is not excluded;
- two-equation conditions on a ~90-dimensional space are always solvable over an algebraically closed field, so
  "survives order n" is weak; only the pattern of the conditions carries information, and it is ambiguous;
- I only compared with CT_2. Other families through this point were not checked: e.g. families obtained from the
  tenfold or sixfold constructions by other cone maps, Coble-type or K3/abelian-rung families, families of cubics
  containing other cycles whose class is a combination with [P1] + 2[P2] (the class could become algebraic via a
  different cycle); the Hodge conjecture's status for cubic eightfolds was not checked;
- the full-space search code is the blind checker's, extended by me; my own slice solver gave a false obstruction
  at order 7 here; the order-8 jets were verified with the package.
So: a reason to look, not a finding. (Held back until the owner had seen it; published 27 Nov.) Material: this folder
(PREREG_step3c.md, PREREG_pocket_followup.md, run9_full_space_order9.py, the logs).

## If you want to pursue it (my suggestion, not started)

Rather than order 10, the cleaner test is to look for an explicit family: since the arc is aligned with the
coordinates (the net avoids the pair (x4, x5)), try families of the form "c(x0..x3, x6..x9) + (x4, x5)-terms" with
other structures than a cone, or compute the tangent space of the would-be component (the 92-dimensional space of
admissible T_2 at order 7) and compare it with tangent spaces of candidate families. A blind check of the order-9
measurement at the second prime with more memory (one job at a time) would also settle (H3) vs (H4) at order 9.

## Follow-up, 27 Nov 13:20-15:50 UTC (owner: "Yes go ahead"; pre-registered in PREREG_pocket_followup.md)

Order 9 rerun one job at a time at both primes (run9b.py; logs run9b_31981.log, run9b_32029.log), with the two
linearity tests at the V8 point. Results, identical at p = 31981 and p = 32029 (MOD p):
- (a) moving k_3 in ker J3 changes q_8 (2 components), LINEARLY (2v against v: true). The earlier "no k_3 dependence"
  was measured at a point that was not on V8 and is withdrawn.
- (b) moving k_4 in ker J4 keeps V8 and changes q_9 with rank 2 (4 samples), LINEARLY (2v against v: true).
- ob_9 at the V8 jet: 19 non-zero components, q_9 12 of 19.
So the 2 extra conditions move along the jet exactly as a smooth component of codimension 28 (dimension dim V - 8)
through T_1 would require: k_2 at order 7, k_3 at order 8, k_4 at order 9, linearly, rank 2 each time. By the
pre-registered reading this is (H3), at two primes. The weak candidate is therefore NOT downgraded.

What it still is: finite order (9), MOD p, one first-order direction, integer powers of eps. What would have to come
next before it could be called more than a reason to look: (1) the comparison of the would-be tangent space (the
92-dimensional space of admissible T_2) with tangent spaces of other families through this point -- I have no list of
such families beyond CT_2 and could not get one tonight (web access was not approved, so arXiv:2606.10884 and the
literature are unread); (2) whether [P1] + 2[P2] on such a component is the class of some other algebraic cycle (the
first thing an expert would ask); (3) characteristic 0.

## Literature input, 27 Nov ~16:00 UTC (web access approved)

[Mo3, Table 1] lists the known families through the Fermat cubic eightfold with codimensions 10 (linear cycles), 16
(generalised cubic scroll), 19 (the locus of Conj. 5.1), 23 (generalised quartic scroll), 25 (generalised Veronese).
None has codimension 28 or is listed for [P1] + 2[P2]; but an intersection of V_Z (codimension 20) with one of these loci
could still carry the pocket, and that comparison of tangent spaces has NOT been done. arXiv:2606.10884 gives no input
(it concerns hyperkaehler fourfolds). Details: leads/LIT_READ_27NOV.md, section 3. The pocket stays OPEN, unchanged.

## Linear-cycle test, 27 Nov ~16:40-17:10 UTC (owner: "Yes go ahead"; pre-registered in PREREG_linear_cycles.md, commit cb5e5cf)

Correction first: comparing with loci inside V_Z (as I had proposed) cannot explain the pocket, because T_1 is not
tangent to V_Z. The pre-registration replaces it by the question whether [P1] + 2[P2] becomes algebraic along the
pocket through LINEAR cycles of the Fermat eightfold.

T-A (MOD p, p = 31981 and 32029; lc1_linear_cycles.py, lc1_31981.log, lc1_32029.log): of the 229635 linear P^4's of the
Fermat eightfold, NONE is tangent to T_1 (T_1 restricted to L has a non-zero square-free part for every L). Controls:
P1 and P2 are not tangent to T_1; both are tangent to f_0 h_1 x_7. T-B and T-C were therefore not needed (S is empty).

Reading (by the pre-registered table): explanations in which every linear component of the limit cycle persists
individually along the pocket are ruled out, for this direction. NOT ruled out: an irreducible cycle that degenerates
at the Fermat point to a sum of linear spaces (the mechanism of Kloosterman's G(2,5) cones and of Movasati's cubic
scrolls), cycles of the Fermat eightfold that are not linear, other directions. The pocket stays OPEN; this removes
the cheapest explanation, it does not make the pocket stronger evidence of anything.

## Lattice filter, 27 Nov ~17:30-18:00 UTC (owner: "go ahead and push forward"; pre-registered, commit c58161c)

If, on the would-be component W, the degree-8 Hodge classes are generically only Q h^4 + Q c (c = [P1] + 2[P2]), any
algebraic cycle Z carrying c has disc(Z) = 3 Z.Z - deg^2 = 144 a^2, a NON-ZERO PERFECT SQUARE (ARG; disc(c) = 144,
EXACT). lt1_disc.py, lt1.log (EXACT intersection theory; the formula for Z.Z needs Z smooth):

| Z | deg | Z.Z | disc |
|---|---|---|---|
| P^4 | 1 | 11 | 32 |
| quadric 4-fold, CI (2,2), CI (2,2,2), CI (2,2,2,2) | 2, 4, 8, 16 | 12, 16, 32, 96 | 32 each |
| P^1 x P^3 = S(1,1,1,1) | 4 | 24 | 56 |
| del Pezzo 4-fold G(2,5) n P^7 (calibration: Kloosterman's lambda = 1 class P1 + P2 + h^4) | 5 | 27 | 56 |
| P^2 x P^2 (agrees with D-SEGRE-FOURFOLD) | 6 | 36 | 72 |
| P^1 x Q^3 | 8 | 50 | 86 |
| scrolls S(1,1,1,2); S(1,1,2,2), S(1,1,1,3); S(1,2,2,2), S(1,1,2,3), S(1,1,1,4) | 5; 6; 7 | 31; 38; 45 | 68; 78; 86 |

No value is a non-zero square. So, under the rank-2 assumption, NONE of these cycle types can make [P1] + 2[P2]
algebraic on W, along any direction (this is a statement about the lattice, not about T_1). Consistency checks: the
calibration gives 56 = disc(P1 + P2 + h^4); P^2 x P^2 gives 72 = disc(P1 - P2), the lambda = -1 class, in line with the
registry's Segre-fourfold entries; complete intersections with a linear factor all give 32 = disc(P^4).
Not covered: singular cycles (cones, e.g. Movasati's generalised cubic and quartic scrolls if they are cones; the
generalised Veronese of his Table 1 was not identified); cycles of other types or higher degree; the case where W has
a larger generic Hodge lattice (then c could be algebraic through a combination of cycles). The pocket stays OPEN.

## Order 10 attempt and an obstruction signal at order 9, 27 Nov ~18:30-22:30 UTC (owner: "go ahead"; PREREG_order10.md)

MOD p (31981), one jet, first order. About 4 hours (the cap was 3; the owner was told at the overrun).
1. run10.py (run10_31981.log): the V8 jet of run9b was reached and verified (T_1..T_8, all 45 conditions). q_9 at
   the base (12 of 19 non-zero) is NOT in the span of its changes under k_4 in ker J4 (rank 2). Pre-registered
   reading: route failure for order 10.
2. run10b.py (run10b_31981.log, pre-registered in the addendum): first-order changes of (ob_8, q_9) under k_2 in A2'
   (5 directions, symmetric differences), k_3 in ker J3 (4), k_4 in ker J4 (4), k_5 in ker W5 (4). The changes of
   ob_8 have rank 2, those of q_9 rank 4; the 15 combinations keeping V8 to first order give q_9 changes of rank 4,
   and q_9 at the base is NOT in their span (rank 5 with it). Control: a k_4 change is in the span.
Pre-registered reading: no first-order correction inside V8 removes q_9 at this jet -- an OBSTRUCTION SIGNAL at order 9.
It contradicts the (H3) reading of the earlier orders: the conditions at order 9 have rank 4 on V8, not 2, and q_9
is not reachable. So the pocket is WEAKER than after run9b.
Caveats: one jet; one prime; first order only (V8 is non-linear: a finite move along V8 could still reach q_9 = 0;
the k_2 changes are symmetric differences, exact only if q_9 is at most quadratic in k_2); the sampled directions
may not span all first-order moves (17 samples). The earlier step "q8 does not depend on k_3" was already withdrawn.
Blind check 20 (pending at the time of writing): a complete linearised test in T-space from the saved jet.
