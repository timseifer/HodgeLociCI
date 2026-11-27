# Pre-registration: the non-linear order-9 test (owner: "run what you believe would give the best explanation")

Written 27 Nov 2026, late, before the run. Claude Opus 5.5. AI-written, unreviewed. MOD p (31981).

Facts fixed before the run (blind check 20 tooling, cnt.py):
- First-order extra conditions per order (beyond the 19 fixed by T_n) at the pocket jet: 0,0,0,7,7,9,9,11 (orders 2..9);
  at the lambda = -1 control arc (arc9_32029_seed1_lam-1_d.txt, same point): 0,0,0,7,7,7,7,7 and order 9 solvable
  (control_lam-1_increments.log). So the jump at order 9 is specific to the pocket.
- X_0 is a singular point of NL(c); its 8-jet space contains jets that lie on no branch. A branch's jets extend; a
  random jet need not. So the question is: do the order-9 conditions vanish SOMEWHERE on V8?
Structure used: q_7 is affine in k_2; q_8 is linear in k_3 (rank 2); q_9 is linear in k_4 (rank 2); modulo the k_4
directions the order-9 conditions have a differential of rank 2 along V8, so their image is (locally) a surface.
Method: a generic 2-plane of k_2 directions in A2' (keeps q_7 exactly); at each point solve q_8 = 0 exactly with two
k_3 directions in ker J3 (linear); evaluate q_9 and project it modulo the k_4 image (Pi, 17 components; first test
along a line that the k_4 image does not move, else eliminate k_4 per point). Interpolate the 17 polynomials in
(s, t) (degree from a line probe, with an off-grid check), then compute a Groebner basis (Macaulay2) of their ideal.
Outcomes:
- Common zero with coordinates in F_p: build that jet, solve k_4, k_6, and verify T_1..T_9 directly. The pocket then
  survives order 9 for real (MOD p, one prime) -- the strongest support it can get from this kind of test.
- Common zeros only over an extension of F_p: same conclusion over the algebraic closure, not verified directly.
- Ideal = (1): the surface does not pass through 0, so (up to the caveats) no 9-jet with this T_1 exists: an order-9
  obstruction for this direction. The pocket would be closed as obstructed (MOD p).
Caveats fixed in advance: one prime; a generic plane covers the image surface only up to lower-dimensional pieces
and other components; the line probe could miss a rational (non-polynomial) dependence, which the off-grid check
should catch.
