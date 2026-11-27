# Does every special locus come from a K-trivial singular locus? (plan item C12; first look)

27 Nov 2026, Claude Opus 5.5. AI-written, unreviewed.

The rule of headline card 2 (+1 with K3, -1 with abelian surfaces) is about c = 3 (planes meeting in codimension 3)
and about the singular surface S of a P^8-section in the rung construction. Its converse would say: every special
Hodge locus of a two-cycle class arises from a section singular along a K-trivial variety.

First test case, c = 2 (cubic fourfolds, two planes meeting in a point; lambda_0 = -1; the locus is the cubics
containing a cubic scroll, discriminant 12; D-CODIM-AT-LAMBDA0 (b)). Through the node identity
(D-NODES-DISCRIMINANT-IDENTITY, k = 2): a hyperplane section containing the scroll Sigma (smooth, rational, degree 3,
Sigma^2 = 7) has (3 * 7 - 9) / 2 = 6 nodes with one relation on linear forms. Computed (MOD 32003, two seeds,
cv1_scroll_nodes.m2): exactly 6 ordinary double points, 5 conditions on linear forms, defect 1.
So here the node mechanism works with a RATIONAL Sigma and no K-trivial surface anywhere: the extra class is the
scroll itself, and the discriminant 12 is not of K3 type (12 is divisible by 4). This is classical (cubic fourfolds in
C_12), and it shows that the K-trivial rule is specific to c = 3 / tau = 0, where the cycle through the nodes is not
available directly and the relation comes from the residue theorem on S. For c = 1, 2 the special loci come from
rational cycles (complete intersections of type (1,...,1,2), cubic scrolls / P^1 x P^2 cones), not from K-trivial
surfaces. Not a counterexample to anything: the converse was never claimed for c < 3.

Next cases for c = 3 itself (not run): the three-plane class kappa (O-THREE-CYCLES: a conic of special coefficients at
first order that dies at second order -- consistent with "no K-trivial surface, no locus"); classes of complete
intersections of other degrees on cubic eightfolds (two quadric 4-folds, etc.), where the node count of a
hyperplane section through one of them can be computed by the generalised identity and compared with the list of
K-trivial surfaces of arXiv:2606.10884 (not read).
