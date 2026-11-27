# Pre-registration: order 10 at the new 9-jet (written 27 Nov ~22:50 UTC, before run12b finished)

Background: run11 (PREREG_order9_nonlinear.md) found a common zero of the 17 order-9 polynomials on the plane,
(s, t) = (-8145, 7245) mod 31981; run12 cleared q_9 there with k_4 (then died of memory in the order-10 step before
saving). run12b rebuilds that 9-jet, clears the J3 part with k_6, verifies T_1..T_9 directly, and saves it.
Test (main_N.py, the generalisation of blind check 20's complete linear test; reproduces 165 / 195 / 196 and the
0,0,0,7,7,9,9,11 counts on the old jet): on the saved 9-jet, the first-order extra conditions per order 2..10, and
whether a first-order correction fixes order 10.
What each outcome would mean:
- Extra conditions at order 9 equal to 9 (= 7 + 2) at the new jet (against 11 at the old one): the old jet was off
  the branch (a jet of the singular point that lies on no branch), and on the branch the pocket again loses 2
  conditions per order -- the (H3) pattern restored. If 11: the rank-4 behaviour is not an artefact of the old jet.
- Order 10 solvable to first order: the 10-jet exists to first order (a full order-10 extension would still need the
  non-linear check only if this fails). Not solvable: run the non-linear test at order 10 (as run11), not a verdict.
None of this is a statement about the Hodge conjecture.
