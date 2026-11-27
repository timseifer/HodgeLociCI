# Pre-registration: order 10 on the lambda = 2 pocket (owner, 27 Nov: "go ahead"; cap about 3 hours)

Written 27 Nov 2026, ~18:30 UTC, before any order-10 computation. Claude Opus 5.5. AI-written, unreviewed. MOD p.

Route (run10.py, built on run9_full_space_order9.py; one job at a time; p = 31981 first, then 32029):
1. Reach the same V8 jet as in run9b (same seeds).
2. Order 9: kill q_9 (2 conditions) with k_4 in ker J4 (the move is linear in k_4, measured in run9b), then kill the
   im J3 part of ob_9 with k_6; verify T_1..T_9 directly (all 45 period conditions, n = 1..9).
3. Order 10: compute ob_10 and q_10 = ell . ob_10 at that V9 jet; measure how q_10 changes with k_5 in the kernel of the
   order-8 response W5 (directions that keep V8), with a linearity test (2v against v), and whether q_10 at the base
   lies in the span of those changes.

What each outcome would mean (the pattern of the earlier orders, PREREG_step3c.md):
- (H3-consistent) q_9 killable; q_10 changes with k_5 with rank 2, linearly, and q_10 lies in the span: the two extra
  conditions move to k_5 at order 10 exactly as a smooth component of codimension 28 would require. This makes the
  pocket somewhat stronger (still finite order, MOD p, one direction); it is not a proof that a component exists.
- (obstruction signal) q_10 does NOT change with k_5 (rank 0), or changes with rank 1, or q_10 is not in the span:
  the conditions fall back on earlier terms. Then I check (one step only) whether the remaining freedom in k_2, k_3, k_4
  can absorb q_10; if not, that is a sign of an obstruction at order 10 along this route (not a proof: the route fixes
  choices). Either way it is recorded.
- (route failure) q_9 is not in the span of the k_4 changes at this point, or the direct verification fails: no
  conclusion about order 10; recorded as a failed route.
Blind check: an independent agent recomputes the order-9 verification and q_10's rank from the saved jet.
Nothing here is a statement about the Hodge conjecture.

## Outcome of step 2 and addendum (written ~19:35 UTC, before the follow-up run)

run10.py at p = 31981 (log run10_31981.log, 2502 s): the same V8 jet as run9b was reached and verified. q_9 at the base
(12 of 19 non-zero) is NOT in the span of its changes under k_4 in ker J4 (rank 2). Pre-registered reading: route
failure for order 10. It also bears on order 9: for a smooth component of codimension 28 the order-9 conditions must be
removable by the remaining freedom.

Follow-up (run10b.py, p = 31981): collect first-order changes of q_9 under ALL moves that keep V8 to first order:
k_4 in ker J4; k_5 in ker W5 (the order-8 response); k_3 in ker J3 combined so that the change of q_8 vanishes; k_2 in
A2' (the directions keeping q_7) combined so that the change of q_8 vanishes. Then ask whether q_9 at the base lies
in their span.
- In the span: order 9 is solvable to first order with more freedom; the route failure was a too-narrow route; the
  pocket is not weakened (and order 10 would need the larger route).
- Not in the span: no first-order correction inside V8 removes q_9 at this jet. That is an obstruction signal at
  order 9 for this jet (not a proof: V8 is non-linear and only one jet is tested). It would weaken the pocket and
  would contradict the (H3) reading; recorded as such.
