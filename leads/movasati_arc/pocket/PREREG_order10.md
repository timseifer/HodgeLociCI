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
