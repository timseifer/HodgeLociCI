# Outcome of the frozen quartic prediction (FROZEN_PREDICTION.md, committed effa1af before these runs)

27 Nov 2026, 08:14 UTC. MOD 32003, random instances. AI-written, unreviewed.

- P1 (generalised node identity, d = 4): AS PREDICTED. A plane in a hyperplane section of a smooth quartic fourfold
  carries exactly 9 singular points of the section; a smooth quadric surface carries exactly 12 (two seeds each;
  qf1_node_counts.m2, qf1.log). These are the values (-1)^k (d Sigma^2 - m^2) / (d - 1) with Sigma^2 = 7, 10. (Both
  sides come from the same Chern classes, so this checks the identity and the node scheme, not a deep fact.)
- P3 (no special behaviour at +1 for (4, 2) at general points): FAILED AS WRITTEN for k = 2 at first order, HOLDS at
  second order: (4,2,2) has first-order excess 1 at lambda = 1, -1 and 2 (it is in the list with excess for every
  lambda), and the second-order verdict is ALL SURVIVE at -1 only, ALL DIE at 1 and 2 (qf2_excess.m2, qf2.log).
  (4,3,2): excess only at -1, which survives. So the special coefficient for (4, 2) is -1 at both k = 2, 3, as P2
  says; my formulation of P3 ignored the first-order list, the same slip as in the sign dictionary for (3,3,3).
- P2 (the geometry behind -1: 16 / 48 nodes with one relation in degree 3 / 5): NOT YET TESTED. Needs either the
  comparison with Kloosterman, Section 6 / Cor. 6.2 (arXiv:2312.12363; fetching it needs an approval that was not
  answered tonight) or a construction of the 16-node configuration at a point of the -1 locus. Open.
Blind comparison by a separate checker: pending (it should read FROZEN_PREDICTION.md, this file, and Kloosterman
Section 6 once web access is approved).

## After reading Kloosterman Section 6 (27 Nov, ~16:00 UTC; web access approved by the owner)

Details in leads/LIT_READ_27NOV.md, section 2. [Kl1, Prop. 6.1] (machine-read): the lambda = -1 cycle for (4, 2) is a
complete intersection of type (1^(k-1), 2, 2), degree 4 (for k = 2 a quartic del Pezzo surface in a hyperplane), with
class P1 - P2 + h^k. Its N-identity count is 16 (k = 2) / 48 (k = 3) (EXACT arithmetic). Instances (qf3_delpezzo_nodes.m2,
qf3.log, MOD 32003, three seeds): 16 reduced singular points of the hyperplane section, all on the surface, imposing
15 conditions on cubics (one relation in degree 3). So P2 HOLDS for k = 2 (node count and relation degree); the
"Kummer type" guess in P2 FAILS (the cycle is a del Pezzo surface). k = 3 not run. Blind check 17 (blind_check17/REPORT.md): CONFIRMED;
the 16 points are Q1 = Q2 = A = B = 0, a complete intersection of four quadrics, so the count and the relation are
automatic for this construction.
