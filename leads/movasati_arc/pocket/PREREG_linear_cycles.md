# Pre-registration: is the lambda = 2 pocket explained by linear cycles of the Fermat eightfold?

Written 27 Nov 2026, ~16:40 UTC, before any computation of this step (owner: "Yes go ahead" to the tangent-space
comparison). Claude Opus 5.5. AI-written, unreviewed.

## Correction to what I proposed

I proposed comparing with "V_Z n CS" and "V_Z n QS". That cannot be the right test: the pocket direction T_1 is NOT
tangent to V_Z (its y_0 part is the excess direction), so the would-be component is not inside V_Z, and no locus
inside V_Z can explain it. What could explain it: along the component, [P1] + 2[P2] = a [Z_t] + b h^4 for an
algebraic cycle Z_t. At the Fermat point Z_t specialises to an algebraic cycle Z_0 with that class. The cheapest
complete family of candidates for Z_0 is combinations of LINEAR P^4's of the Fermat eightfold (945 matchings x 3^5
roots = 229635 of them).

## The tests

T-A (first order, exhaustive). For every linear P^4 L of the Fermat eightfold, decide whether T_1 is tangent to V_L,
i.e. whether T_1 restricted to L lies in (x_i^2) restricted to L (equivalently: the 10 square-free coefficients of
T_1|_L vanish). T_1 from arcs/jet8_31981_s_lam2.txt and arcs/jet8_32029_s_lam2.txt (MOD p).
T-B (span). Let S = the set of L passing T-A. Decide whether [P1] + 2[P2] lies in the Q-span of h^4 and the classes
of S, using intersection numbers L.L' = f_3(dim L n L') (f_3: -1 -> 0, 0 -> 1, 1 -> -1, 2 -> 3, 3 -> -5, 4 -> 11),
h^4.L = 1, h^8 = 3 (EXACT). The test is "rank of the Gram matrix does not grow"; valid because the form is definite
on primitive real (4,4) classes (Hodge-Riemann), so the span is non-degenerate.
T-C (only if T-B finds a span). Along the order-8 jet, check that the L in a spanning set persist to order 8
(the deformation of L is unique order by order in this chart, so this is a direct check), and compute the tangent
codimension of the intersection of their V_L; compare with 28.
Controls: P1 and P2 must FAIL T-A for T_1 (else the pocket would sit in V_Z); both must PASS T-A for a pure net
direction (net directions are tangent to V_Z).

## What each outcome would mean

- T-B finds a span, T-C passes to order 8, codimension 28: the pocket is (to the orders computed) explained by an
  intersection of loci of cubics containing linear cycles; the class is then algebraic along it. The open entry
  would be closed as explained (by the computed orders, MOD p).
- T-B finds a span but T-C fails: linear cycles persist to first order only; not an explanation; record.
- S non-empty, no span: linear cycles that persist individually do not explain the pocket. Ruled out: ONLY
  explanations in which every linear component of Z_0 persists individually. NOT ruled out: an irreducible Z_t
  degenerating to a sum of linear spaces (the mechanism of Kloosterman's G(2,5) cones and of Movasati's cubic
  scrolls), non-linear cycles of the Fermat (e.g. Aoki-Shioda type), and other directions.
- S empty: the same statement, more strongly.
None of the outcomes says anything about the Hodge conjecture.

# Step 2 (pre-registered 27 Nov ~17:30 UTC, before computing; owner: "go ahead and push forward"): lattice filter

Argument (ARG). Suppose that on the would-be component W the Hodge classes in degree 8 are generically exactly
Q h^4 + Q c, c = [P1] + 2[P2]. Any algebraic 4-cycle Z on a general member of W then has [Z] = a c + b h^4, so
disc(Z) := 3 Z.Z - deg(Z)^2 = a^2 disc(c) = 144 a^2 (EXACT: c.c = 11 + 4*11 + 4*(-1) = 51, deg c = 3, 3*51 - 9 = 144).
Since 144 = 12^2, a cycle that makes c algebraic on W must have disc(Z) a NON-ZERO PERFECT SQUARE.
Test L: compute disc(Z) for the smooth 4-folds of low degree that occur in cubic eightfolds, by
Z.Z = int_Z c_4(N_{Z/X}), c(N) = (1 + H)^10 / ((1 + 3H) c(T_Z)) (Schubert2), and for the known classes:
P^4 (Z.Z = 11), Q^4, P^1 x P^3, (2,2) complete intersection, del Pezzo 4-fold of degree 5 (= G(2,5) n P^7, Kloosterman's
lambda = 1 cycle), P^2 x P^2, (2,2,2) complete intersection, P^1 x Q^3; and the classes P1 - P2 (planes in a line: 72,
Movasati's lambda = -1), P1 - P2 (planes in a plane: 48, cubic scrolls). Calibration: the del Pezzo of degree 5 must
give disc 56 (its class is P1 + P2 + h^4, D-TENFOLD... Kloosterman Prop. 6.4); a different value means the method is wrong.
Outcomes:
- Some family has a non-zero square disc: a candidate explanation; next would be a tangency test against that family.
- None does: none of those families can carry c on W, for ANY direction, under the stated rank-2 assumption. Not ruled
  out: other cycles (singular ones, higher degree), and the case where W has a larger generic Hodge lattice.
