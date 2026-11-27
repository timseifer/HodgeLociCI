# Blind check 14 — report (exact arcs at the eightfold Movasati point)

(Saved by the main session from the checker's hand-back; the summary and verdict table are verbatim, the detailed
sections are in the checker's scripts and outputs in own/ and pkg/.)

## Summary (checker's words)

- C1: CONFIRMED, partly EXACT. Package, EXACT over QQ(z): all 45 equations of [P1] - [P2] vanish along the s file
  to order 8 (order 9 timed out) and along the g file to order 6 (order 7 timed out at 530 s). For [P1] + [P2] both
  fail at order 1. Own code, MOD p at 32029 and 31981: s to order 9, g to order 7, both primes. So the exact checks
  fall short of the claim: order 9 for s and order 7 for g are confirmed only MOD p.
- C2 first part: CONFIRMED EXACT ([P1] + 2[P2], orders 1..5 zero). Second part: CONFIRMED MOD p at both primes,
  not exact: with this T_1, no T_2..T_6 among the squarefree cubics passes order 6 (own full-space test: ob_2..ob_4
  vanish, ob_5 affine with linear part of rank 7 from k_2 only, solution space of dimension 397, on it ob_6 varies
  in a 7-dimensional W and ob_6(u_0) is not in W; a functional killing W is a non-zero constant, 11183 resp. 1268).
- C3: CONFIRMED MOD p. lambda = 2, net s and net F1, F2 (both primes): explicit T_2..T_6 built and checked directly,
  all 6 x 45 coefficients zero. Net g obstructed at both primes. Control: g at lambda = -1 passes order 6 (32029).
- C4: "separation holds in characteristic 0" is exact only for the slice; the full-space part is MOD p.
  "General position versus aligned" rests on one non-aligned net g plus the author's random nets. Net g is G F H but
  y_0 was not transformed with it, so the data fit equally a dependence on how the net sits relative to y_0, or on
  its rank-one members (OPEN). Everything finite order, one direction per net, integer powers of eps.

Nothing here is, or bears on, a proof or disproof of the Hodge conjecture. Nothing comes from the user's memory store.
The checker did not read ma4_exact.m2, ma5_verify_exact.m2 or the logs; it read PREREG_arc.md after "Step M3" only
once all its results were in.
