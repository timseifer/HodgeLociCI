
## Step 3c: what the count must be if the arc is the trace of CT_2, and the splitting test (owner, 27 Nov:
## "write down what the count should be ... then run order 9 ... and the splitting test ... hard cap about 3 hours")
Written 27 Nov, 05:33 UTC, before any order-9 computation.

Bookkeeping. Unknowns per order: T_n (120 cubics modulo J). Of the 45 equations of order n, 19 fix the dependent
part of T_n, 7 are removed by k_(n-3) (the map J3), and r_n = rank of the rest (q_n) are new conditions on earlier
terms. So the jet space with fixed T_1 grows by 94 - r_n per order. For a SMOOTH component W of codimension c (in
cubics modulo J) whose tangent space contains T_1, arcs with tangent T_1 have T_n in T_0 W modulo lower terms, so
the steady increment is 120 - c, i.e. r_n = c - 26 in the steady state, and the extra conditions of W must fall on
EVERY T_m in turn: the 2 conditions that hit k_2 at order 7 must hit k_3 at order 8 and k_4 at order 9 (linearly).
Predictions by hypothesis (orders 7, 8 measured: r_7 = 2 affine in k_2; r_8 = 2 quadratic in k_2, and q_8 does NOT
change with k_3 in ker J3 or k_4 in ker J4 -- three random samples each):
(H1) trace of CT_2 (D-LAMBDA2-CONE-TYPE, codimension 36): steady r_n = 10. More basically T_1 must lie in T CT_2.
     CT_2 consists of cubics c(8 variables) + u^3 + v^3 up to coordinate changes; for the planes of this pair the
     split-off block must be one of the two pairs on which P1 and P2 have the same root, (x6, x7) or (x8, x9)
     (a pair with different roots, (x4, x5) etc., forces both sixfold classes to stay Hodge separately, i.e. both
     planes to persist: that family lies in V). Modulo J (= coordinate changes at Fermat) its tangent directions do
     not couple the block to the other variables. CHECKED NOW (first order, exact by inspection of the file
     arcs/jet8_32029_s_lam2.txt): T_1 has 4 monomials coupling (x6, x7) and 2 coupling (x8, x9) to the rest. So T_1
     is not tangent to CT_2 for either block, and the pre-registered splitting test (re-run the slice on monomials
     that do not couple the block) already fails at order 1: the restricted problem does not contain T_1.
(H2) a component of dimension dim V - 6 through T_1 (the -1 situation): r_n = 0 from order 6 on. Excluded by r_7 = 2.
(H3) a smooth component of codimension 28 (dimension dim V - 8) through T_1, not one of the known families: r_n = 2
     steady AND the 2 conditions move along: q_9 must depend LINEARLY on k_4 (and q_8 on k_3, which was NOT seen).
(H4) no component through T_1 with a smooth or reduced tangent cone: the extra conditions keep falling on k_2
     (q_9 again a function of k_2 only, of higher degree), the jets of T_2 shrink order by order, and an obstruction
     or a collapse of the k_2-family is expected later.
Order 9 test: on V8 (jets through order 8, from the order-8 run), measure (a) r_9 and (b) whether q_9 changes with
k_3 in ker J3 and with k_4 in ker J4 (rank of the changes). Reading:
- q_9 changes with k_4 with rank 2: (H3) pattern, but then the order-8 observation (no k_3 dependence) needs
  explaining; ambiguous -> order 10.
- q_9 independent of k_3, k_4 (changes only with k_2): (H4); the pocket is not a component through T_1 of the
  expected kinds; with (H1) already excluded at first order, no candidate.
- r_9 = 0: the conditions stop; ambiguous -> order 10.
