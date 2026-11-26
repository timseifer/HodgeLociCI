# Explicit cycles on cubic sixfolds and eightfolds

- Coefficient -1: the second component is (an open piece of) the closure of the cubics det A + det B, which carry an explicit threefold of degree 9 (8 conditions); coefficient 1: l*Q + Pfaffian with a quintic threefold (7 conditions); eightfolds: l*Q + det A + det B with a fourfold of degree 9 (26 conditions), and the Segre fourfold (27 / 26).
- The general cubic containing both planes is a limit of sums of two determinants, not a sum; along one path into it both determinants blow up towards a triple hyperplane.
- For other coefficients nothing was found; the matrices along the path and the limit of the threefold were not recovered. Numbers are modulo primes unless marked exact; identifications are paper chains.

> **Status of everything on this page:** produced by AI agents, checked only by other AI agents, reviewed by no human. Sources of published results were read by machine (see `tests/SOURCES.md`). The notes cited as "unreviewed note 1, 2, 3" are AI-written and not public. Nothing here is, or bears on, a proof or disproof of the Hodge conjecture. This is a registry of what was found, ruled out or left open, not a list of established theorems.

Generated from `discoveries/registry.yaml` by `discoveries/check_registry.py --write-pages`. Do not edit this page by hand: edit the registry. Notation: [`NOTATION.md`](NOTATION.md). Status vocabulary: [`README.md`](README.md).

## Entries on this page (19)

| id | status | title |
|---|---|---|
| [D-INTERSECTION-NUMBERS](#d-intersection-numbers) | `EXACT` | Intersection numbers and lattices used throughout (cubic sixfolds and eightfolds) |
| [D-FLAG-THREEFOLD-V6](#d-flag-threefold-v6) | `EXACT` | Flag threefold V_6 on cubic sixfolds: 9 conditions, Hodge locus of its class of tangent codimension 8 |
| [D-TRIANGLE-OF-PLANES](#d-triangle-of-planes) | `MOD_P` | Three 3-planes pairwise meeting in a point on a cubic sixfold: tangent codimensions 4, 7, 8; joint 12 |
| [D-TWO-DET-FAMILY-NUMBERS](#d-two-det-family-numbers) | `MOD_P` | Cubic sixfolds det A + det B: codimension 8, an explicit threefold T of degree 9, tangent codimension 8 |
| [D-TWO-DET-HODGE-LOCUS](#d-two-det-hodge-locus) | `PAPER_ARGUMENT_AI` | The Hodge locus of [T] is smooth of codimension 8 and equals the closure of the sums of two determinants |
| [D-W-MINUS1-IS-TWO-DET-CLOSURE](#d-w-minus1-is-two-det-closure) | `PAPER_ARGUMENT_AI` | For lambda = -1 the second component W_(-1) on cubic sixfolds is an open piece of the closure of det A + det B |
| [D-GENERAL-CUBIC-OF-D-IS-LIMIT](#d-general-cubic-of-d-is-limit) | `PAPER_ARGUMENT_AI` | Plane lemma \|g.P\| <= 3; the general cubic of D is a limit of sums of two determinants, not a sum |
| [D-DEGENERATION-ALONG-ARC](#d-degeneration-along-arc) | `MOD_P` | Along one arc into D the 18 quadrics split into two determinantal nets; both cubics have a pole of order 6 |
| [D-PFAFFIAN-LAMBDA1](#d-pfaffian-lambda1) | `MOD_P` | Cubic sixfolds l*Q + Pfaffian: 7 conditions, an explicit quintic threefold whose Hodge locus is the family |
| [D-LAMBDA1-PFAFFIAN-AND-SCROLL](#d-lambda1-pfaffian-and-scroll) | `PROVED_AI_UNREVIEWED` | Equal coefficients: NL(1) is smooth of dimension dim V_Z + 1, with quintic del Pezzo k-folds and quartic scrolls |
| [D-EIGHTFOLD-FAMILY-TD](#d-eightfold-family-td) | `MOD_P` | Cubic eightfolds l*Q + det A + det B: 26 conditions, an explicit fourfold of degree 9 (self-intersection 51) |
| [D-SEGRE-FOURFOLD](#d-segre-fourfold) | `MOD_P` | Segre fourfold P^2 x P^2 in a cubic eightfold: 27 conditions to contain it, Hodge locus of codimension 26 |
| [D-CONE-DICTIONARY](#d-cone-dictionary) | `PAPER_ARGUMENT_AI` | Cone-type points: classes r P1 + s P2 are cones over classes of discriminant 8r^2 - 2rs + 8s^2 on cubic fourfolds |
| [D-CYCLE-CONSTRAINTS-OTHER-LAMBDA](#d-cycle-constraints-other-lambda) | `MOD_P` | Constraints on any cycle carrying the class for lambda = 2, 1/2, -2, 3, 5/3: spans P^7, lies on no extra quadric |
| [D-TENFOLD-COBLE-FAMILY](#d-tenfold-coble-family) | `MOD_P` | Tenfold lead: an explicit codim-54 family through F_T (P^8-section a Coble cubic); first-order Hodge locus of its class = the family; tangent to NL([V]) along F_T in the extra direction |
| [D-TENFOLD-COBLE-CYCLE-CLASS](#d-tenfold-coble-cycle-class) | `PAPER_ARGUMENT_AI` | Tenfold lead: the 4-plane cycle on the Coble family has self-intersection -144, so its class is 4 h^5 +- 2 ([V] - 2 h^5); hyperplane sections with 72 nodes and one relation |
| [D-TENFOLD-PFAFFIAN-K3](#d-tenfold-pfaffian-k3) | `MOD_P` | Cubic tenfolds, coefficient +1: the Pfaffian locus is 'P^8-section singular along a K3 surface of genus 8' (56 nodes, one relation); the node ladder reproduces the lattice of h^5 + P1 + P2 (a control for D-TENFOLD-COBLE-CYCLE-CLASS) |
| [D-TENFOLD-COBLE-EXACT-MEMBER](#d-tenfold-coble-exact-member) | `PROVED_AI_UNREVIEWED` | A named smooth cubic tenfold over QQ in the Coble family: its hyperplane section has exactly 72 nodes with exactly one relation (certificate over QQ); first-order Hodge locus of codimension 54 |
| [D-TENFOLD-COBLE-PLANE-COUNT](#d-tenfold-coble-plane-count) | `MOD_P` | Tenfold lead: the 4-plane cycle meets a 5-plane transversally in 8 points, where a multiple of h^5 would give 4; its class is not a multiple of h^5 by a count (MOD p), without the node argument or the ladder |

## Related entries on other pages

| id | kind | status | page | title |
|---|---|---|---|---|
| [N-SUMS-OF-SAME-SHAPE-OTHER-LAMBDA](06_ruled_out_and_dead_ends.md#n-sums-of-same-shape-other-lambda) | negative | `RULED_OUT` | 06 | lambda = 2, -2: no family 'G_A + G_B' of the two-determinant shape, no cycle in a hyperplane, no classical threefold |
| [N-PROJECTED-SCROLLS](06_ruled_out_and_dead_ends.md#n-projected-scrolls) | negative | `RULED_OUT` | 06 | Projected scrolls over P^1 x P^1 are not the cycle at a general point of W_2, W_(-2) |
| [N-NODAL-AND-DEGENERATE-DETERMINANTS](06_ruled_out_and_dead_ends.md#n-nodal-and-degenerate-determinants) | negative | `RULED_OUT` | 06 | The divisor D is not produced by a nodal flag threefold, a determinant singular along a P^4, or the tangent case |
| [N-TWO-TRACE-DESCRIPTION-OF-D](06_ruled_out_and_dead_ends.md#n-two-trace-description-of-d) | negative | `RULED_OUT` | 06 | D is not the family x_H*Q + det(S + E) - det(S - E) with tr E = 0 and tr(ES) = 0 on H |
| [N-CODIM-IJ4-AT-FERMAT](06_ruled_out_and_dead_ends.md#n-codim-ij4-at-fermat) | negative | `RULED_OUT` | 06 | 'codim (I_T + J)_4 = 1' fails at the Fermat cubic sixfold: the value there is 16 |
| [N-V6-DEGENERATIONS-AND-REDUCIBLE-CYCLES](06_ruled_out_and_dead_ends.md#n-v6-degenerations-and-reducible-cycles) | negative | `RULED_OUT` | 06 | Coordinate degenerations of V_6 do not reach the two-plane locus; visible reducible cycles at D do not leave V_Z |
| [O-RECOVER-MATRICES-AND-LIMIT-OF-T](07_open_problems.md#o-recover-matrices-and-limit-of-t) | open | `STUCK` | 07 | Recover the matrices A(eps), B(eps) along the arc into D, the flat limit of T, and D as a family |
| [O-OTHER-COEFFICIENTS](07_open_problems.md#o-other-coefficients) | open | `OPEN` | 07 | Coefficients other than 1 and -1: no explicit cycle or family is known for the second component |
| [O-LITERATURE-CHECK-DET-PFAFF](07_open_problems.md#o-literature-check-det-pfaff) | open | `OPEN` | 07 | Literature check for the determinantal and Pfaffian descriptions before any novelty claim |
| [O-SIGN-AND-PLANE-LEMMA-GAPS](07_open_problems.md#o-sign-and-plane-lemma-gaps) | open | `OPEN` | 07 | Sign and monodromy of the class of T; the cases (block,block), (skew,*) of the plane lemma; its eightfold version |
| [C-PLANE-LEMMA-GAP](08_corrections_and_lessons.md#c-plane-lemma-gap) | correction | `PAPER_ARGUMENT_AI` | 08 | T2's plane lemma: proof gap and incomplete case list; statement confirmed, wording narrowed to 'the general cubic' |
| [C-CLOSURE-OF-WORDING](08_corrections_and_lessons.md#c-closure-of-wording) | correction | `PAPER_ARGUMENT_AI` | 08 | 'W is the family of sums of two determinants' corrected to 'the closure of' |
| [N-DELSARTE-UNSOLVED-FAMILIES](06_ruled_out_and_dead_ends.md#n-delsarte-unsolved-families) | negative | `RULED_OUT` | 06 | Smooth Delsarte sextic fourfolds, quartic sixfolds and cubic tenfolds: every Hodge character closed by published criteria |
| [N-THOM-SEBASTIANI-SEXTIC-FOURFOLDS](06_ruled_out_and_dead_ends.md#n-thom-sebastiani-sextic-fourfolds) | negative | `RULED_OUT` | 06 | Sextic fourfolds f(x) + g(y): no explicit member with a Hodge class outside the known algebraic cases |

---

## D-INTERSECTION-NUMBERS

**Intersection numbers and lattices used throughout (cubic sixfolds and eightfolds)**

kind: `result` | area: `explicit_cycles` | status: **`EXACT`**

**Statement.**

The following integers were used and cross-checked in the session. h (sixfolds) and eta (eightfolds) denote the
hyperplane class; P, P' are linear subspaces of half dimension.
Cubic sixfold: h^3.h^3 = 3; h^3.P = 1; P.P = -5; P.P' = 1, -1, 3 if P n P' is a point, a line, a plane; 0 if
disjoint. So (P1 - P2)^2 = -12 for 3-planes meeting in a point, and the lattice <h^3, P1 - P2> has discriminant -36.
Cubic eightfold: P.P' = (1 - (-2)^(m+1))/3 for 4-planes meeting in dimension m: 11, -5, 3, -1, 1 for m = 4, 3, 2,
1, 0. So ([P1] - [P2])^2 = 11 + 11 + 2 = 24 for 4-planes meeting in a line; lattice <eta^4, [P1] - [P2]> = diag(3,
24). General formula for linear cycles on a degree-d hypersurface: P.P' = (1 - (1-d)^(m+1))/d.

**Data.**

Class a h^3 + b (s P1 + r P2) on a cubic sixfold (planes meeting in a point): degree 3a + b(r+s), self-intersection
3a^2 + 2ab(r+s) + b^2 (2rs - 5r^2 - 5s^2); discriminant of <h^3, s P1 + r P2> is -4(4r^2 - rs + 4s^2):
lambda = 1: -28; lambda = -1: -36; lambda = 2 or 1/2: -72; lambda = -2: -88.
Classes of discriminant -72: (degree, self-intersection) = (3,-21), (6,-12), (9,3), (12,24).
Explicit subvarieties: flag threefold V_6: degree 6, V_6.V_6 = 0, [V_6] = 2h^3 +- (P1 - P2) numerically, lattice
discriminant -36. Degree-9 threefold T on a sum of two determinants: T.T = 15 = (h^3 + [V_6])^2; ([T] - 3h^3)^2 =
-12. Quartic scroll S(1,1,2): degree 4, self-intersection -4 = numbers of 2h^3 - (P1 + P2). Quintic del Pezzo
threefold: (5, -1) = numbers of h^3 + P1 + P2. Cubic scroll S(1,1,1): self-intersection -5 = (h^3 + P1 - P2)^2 for
3-planes meeting in a line. h^3 + (k planes pairwise meeting in a point) has self-intersection (k-1)(k-3).
(h^k + P1 + P2)^2 = 13, -1, 27, -29, 83 for k = 2..6 (two k-planes meeting in codimension 3).
Eightfold: Segre fourfold Sigma = P^2 x P^2: degree 6, Sigma.Sigma = 36, ([Sigma] - 2 eta^4)^2 = 24. Degree-9
fourfold T4: T4.T4 = 51, ([T4] - 3 eta^4)^2 = 24. Cone map from a cubic sixfold Z to a cone-type eightfold:
(cone a, cone b) = -2 (a, b) + (deg a)(deg b).
Octic surface: line L, disjoint (3,3) curve C: L^2 = -6, C^2 = -18, L.C = 0.
Quartic sixfold: for delta = 3[P1] + [P2] - 3[P4] (D-FAKE-CLASS-EXPLICIT): delta.h^3 = 1, delta^2 = -506.

**Conditions.**

Chern class and excess-intersection computations by hand or with a computer algebra system; the scroll formula s =
3d + 4 e_1^2 + 8 e_1.k + 3 k^2 - 3 chi for a scroll in lines over a surface (sign of the e_1.k term corrected, see
C-NIGHT-SMALLER-CORRECTIONS).

**Evidence.**

Night run: tools/chern.py, Lean (lean/core/LatticeFacts.lean, integer arithmetic). Discovery round: T2 (hand and
exact), T3 (sympy Chern classes; exact count of T4.T4 on the Fermat eightfold as a union of 9 planes: 81 numbers
adding to 51; the same count for sixfolds gives 15), C16 (checks tau(t^2) = 36, P1.P2 = 1 with its own code), C17
(cone pairing by hand).

**Independent check.**

C16, C17 for the numbers they used (-12, 1, the cone pairing, 51 predicted then counted by T3). No single check of
the whole list.

**Not established.**

Smoothness of T is checked modulo p only; T.T = 15 uses it and the scroll formula, or alternatively the join
computation and the count on the Fermat sixfold.

**Known before.**

published: intersection numbers of linear cycles of Fermat varieties (Villaflor Loyola arXiv:1812.03964, Corollary
4). The other numbers are standard Chern-class computations; no source was read for them.

**Reproduce.**

Run from the repository root (Macaulay2 1.22). lean/run_all.sh core (file lean/core/LatticeFacts.lean: integer
arithmetic for the sixfold numbers). The package exports no intersection-number function (tests/README.md, "Not
covered").

**Session references (files not public).**

discovery/t2_w_cycle/NOTE_W_minus1.md (sections 0, 3(f)); LEDGER_DISCOVERY.md "[T2] 04:20Z", "[T2] 04:48Z", "[T3]
05:41Z", "[T3] 16:27Z"; LEDGER.md "Round 3".

---

## D-FLAG-THREEFOLD-V6

**Flag threefold V_6 on cubic sixfolds: 9 conditions, Hodge locus of its class of tangent codimension 8**

kind: `result` | area: `explicit_cycles` | status: **`EXACT`**

**Statement.**

V_6 = P(T_P2) = {rank-one traceless 3 x 3 matrices} in P^7, of degree 6. For a smooth cubic sixfold X containing a
V_6 (two random integer cubics, exact over Q): 56 cubics contain a fixed V_6; "contains some V_6" is 9 conditions
(codim (I(V)+J)_3 = 9); codim (I(V)+J)_4 = 1, so the period polynomial of [V_6] is determined; the Zariski tangent
space of the Hodge locus of [V_6] has codimension 8. Given that a Hodge locus on cubic sixfolds is cut by
h^(4,2) = 8 equations, the Hodge locus of [V_6] is smooth of codimension exactly 8 at such a cubic and the V_6
cubics are a divisor in it.
Limits (exact over Q): for the weight vector (0,1,0,0,0,1,1,0) on the coordinates the flat limit of V_6 is reduced:
three 3-planes pairwise meeting in one point (three different points) plus one cubic threefold section. So on a
smooth cubic through this limit [V_6] = h^3 + Pa + Pb + Pc (class of the flat limit). The numbers at such "triangle"
points are in D-TRIANGLE-OF-PLANES.

**Data.**

Hilbert function of V_6: 8, 27, 64, 125 = (n+1)^3. Triangle limit: Pa = {x7 = x6 = x1 = x0 = 0},
Pb = {x6 = x5 = x3 = x0 + x4 = 0}, Pc = {x5 = x4 = x2 = x1 = 0}, and the cubic threefold X n {x6 = x5 = x1 = 0}; the
limit ideal is the intersection of the three planes and (x6, x5, x1, x0^2 x4 + x0 x4^2 + x2 x3 x7).
Projection limit: V_6 projected from the point diag(1,2,-3) onto a hyperplane (flat limit under x7 -> t x7,
t -> 0): degree 6, Hilbert function 8, 27, 64; a general cubic through it is smooth, 11 conditions, and the Hodge
locus of the limit class has tangent codimension 7, not 8 (exact over Q for this centre; MOD p at three primes
by C1). So the closure of the codimension-8 locus is singular or non-reduced at these cubics. With the opposite
weight convention the limit is different and the statement fails.
Cone limit: the cone with vertex e4 over a smooth sextic del Pezzo surface S' in P^5 (Hilbert polynomial
3n^2 + 3n + 1; on 2 quadrics and 19 cubics; not linearly normal) plus one embedded point at the vertex. The cubics
x0*Q + c, c through S', are smooth; "contains such an S'" is one condition on cubic fourfolds (39-dimensional
family of S', rank 36); S'.S' = 18, so {c = 0} lies in Hassett's divisor C_18.
First-order count: V_6 moves in a 55-dimensional family in P^7. V_6 together with a cubic threefold section
(degree 9, class h^3 + [V_6]): 72-dimensional family, again 9 conditions.

**Conditions.**

'A Hodge locus on cubic sixfolds is cut locally by 8 equations' (standard). Smoothness of the test cubics is
certified modulo 32003.

**Evidence.**

Team T2 (v6_exact.m2, degen_scan*.m2, limit_planes*.m2, triangle_class3.m2, proj_exact.m2, split_exact.m2). Night
run: the numbers 9 and 8 modulo p (tools/periods.py); team T3 by another route (flag6.m2: Hilbert function 1, 8,
19, 9, 1 of S/(I+J)).

**Independent check.**

C1 (exact: 56 / 9 / 1 / 8 at two cubics; MOD p: the projection limit with tangent codimension 7). C4 (exact: the
triangle limit ideal). C7 (exact: the cone limit, including the embedded point found by the checker).

**Not established.**

Verified at two or three cubics per statement. The degeneration scans used coordinate weights only and are not
exhaustive.

**Known before.**

not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further (night-run ledger:
Movasati arXiv:1902.00831 says of planes meeting in a point that it is not known what kind of algebraic cycles
produce such Hodge cycles; machine-read).

**Reproduce.**

Run from the repository root (Macaulay2 1.22). Not in the validation suite as such; with the package's general
first-order tool:

```
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
setRandomSeed 5; S = ZZ/32003[x_0..x_7];
N = matrix{{x_0, x_1, x_2}, {x_3, x_4, x_5}, {x_6, x_7, -x_0 - x_4}}; I = minors(2, N);
F = sum(flatten entries gens I, m -> random(1, S) * m);
h = hodgeLocusTangentCodim(F, I); J = ideal jacobian matrix{{F}};
print(degree I, apply(3, i -> hilbertFunction(i + 1, I)), hilbertFunction(3, I + J), h#"codimIJ", h#"codim");
```

Expected: (6, {8, 27, 64}, 9, 1, 8) (MOD p, one random cubic through V_6).

**Session references (files not public).**

LEDGER_DISCOVERY.md "[T2] 04:05Z", "[T2] 04:20Z", "[T2] 04:48Z", "[T2] 04:56Z", "[T2] 04:57Z", "[T2] 05:07Z",
"[CHECK C1]", "[CHECK C4]", "[CHECK C7]", "[T3] 06:13Z".

---

## D-TRIANGLE-OF-PLANES

**Three 3-planes pairwise meeting in a point on a cubic sixfold: tangent codimensions 4, 7, 8; joint 12**

kind: `result` | area: `explicit_cycles` | status: **`MOD_P`**

**Statement.**

Let X be a general cubic sixfold through the "triangle" limit of the flag threefold (D-FLAG-THREEFOLD-V6): three
3-planes Pa, Pb, Pc pairwise meeting in one point, plus a cubic threefold section. Then X is smooth and "contains
this limit" is 15 conditions. With the period polynomials of the three planes normalised by the residue pairing:
the Hodge locus of one plane has tangent codimension 4; of Pa + Pb and of Pa - Pb, 7; of Pa + Pb + Pc, Pa + Pb -
Pc and Pa + 2Pb + 3Pc, 8 (the checker: 8 for every combination of all three tried, all sign patterns and random
coefficients); the joint kernel of the three classes has codimension 12. Multiplication by a period polynomial
maps R_3 to R_7, and dim R_7 = 8, so 8 is the maximal rank.
Consequence (paper, given "8 equations"): at such a cubic the Hodge locus of Pa + Pb + Pc is smooth of codimension 8
and equals the closure of the Hodge locus of the flag-threefold class near that cubic (same class
h^3 + Pa + Pb + Pc).

**Data.**

(h^3 + Pa + Pb + Pc)^2 = 3 + 6 - 15 + 6 = 0 = V_6.V_6. Normalisation used: <p_i, p_i> equal and <p_i, p_j> =
-<p_i, p_i>/8 for i != j. The opposite limit (weight (0,1,1,0,0,1,0,0): three quadric threefolds pairwise sharing
a plane) gives the class 3h^3 - Pa' - Pb' - Pc'.

**Conditions.**

One cubic at prime 32003 (T2), three primes and three random cubics (C4). The validation values 4 and 7 are known
numbers for one and two planes.

**Evidence.** Team T2 (triangle_class3.m2, seed 17; two earlier versions of the script timed out because of the monomial order).

**Independent check.** C4 (blind; two implementations): smooth, 15 conditions, ranks 4 / 7 / 8, joint kernel of codimension 12.

**Not established.**

Exact ranks. Second order for three planes. Other three-plane configurations (pairwise meeting in lines or
planes). This is the only three-cycle computation in the sources; the three-cycle question itself was not started
(O-THREE-CYCLES).

**Known before.** not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further

**Reproduce.**

not reproducible from this repository: the triangle cubic and the three period polynomials come from session
scripts. Needed: the limit ideal (given in D-FLAG-THREEFOLD-V6), a random cubic in it, and the period polynomial
of each plane. hodgeLocusTangentCodim gives the number for one plane; for a combination of classes at a non-Fermat
point the package has no route (fermatTangentData handles combinations of Fermat planes only).

**Session references (files not public).** LEDGER_DISCOVERY.md "[T2] 04:48Z", "[T2] 04:56Z", "[CHECK C4] 05:06Z".

---

## D-TWO-DET-FAMILY-NUMBERS

**Cubic sixfolds det A + det B: codimension 8, an explicit threefold T of degree 9, tangent codimension 8**

kind: `result` | area: `explicit_cycles` | status: **`MOD_P`**

**Statement.**

```text
Let F = det A + det B with A, B two 3 x 3 matrices of linear forms in x0..x7, X = {F = 0} smooth. At random such F:
(a) the cubics in the ideal of all 2 x 2 minors of A and of B (the tangent space of the family) form a space of
    dimension 112, codimension 8, containing the Jacobian ideal in degree 3; the parameter count 2 (72 - 16) = 112
    gives codimension at least 8;
(b) T = {rows 1, 2 of A proportional} n {rows 1, 2 of B proportional} lies in X, has dimension 3, degree 9, Hilbert
    function 8, 30, 76, 155 and Hilbert polynomial (3/2)n^3 + 3n^2 + (5/2)n + 1; it lies on 6 quadrics and 44 cubics;
(c) codim (I_T + J)_3 = 13, codim (I_T + J)_4 = 1, and the tangent space of the Hodge locus of [T],
    ((I_T + J) : m)_3, has codimension 8 and equals the space of (a);
(d) the threefolds built from (rows of A, columns of B) and (columns, columns) have degree 9, the same line in
    degree 4 and the same tangent space;
(e) T moves in a 4-parameter family on X (any pencil of rows of each matrix) and imposes 8 conditions.
The numbers of (a), (b) and codim (I_T + J)_3, codim (I_T + J)_4 were also obtained exactly over Q at one integer
point; then the tangent codimension 8 is exact there too (at most 8 over Q, at least its value modulo p).
```

**Data.**

T is a scroll in lines over P^1 x P^1: T = P(E), E the cokernel of O(-1,0)^3 + O(0,-1)^3 -> O^8, c_1(E) = (3,3),
c_2(E) = 9. Classes: [T_rows,rows] = [T_cols,cols] = 3h^3 + g, [T_rows,cols] = [T_cols,rows] = 3h^3 - g, g^2 = -12;
(rows,rows) + (rows,cols) = 6h^3. T.T = 15.
Link with the flag threefold: for N the generic traceless matrix and N' random,
F_t = (det(N + t N') - det N)/t is a sum of two determinants for t != 0, and F_0 = sum N'_ij cof_ij(N) is a cubic
through V = {rank N <= 1}; every cubic through V arises. At such F_0 (smooth): the flat limit T_0 of T has degree 9
and Hilbert function 8, 30, 76, does not contain V (T_0 n V is a curve), and
codim (I(V)+J)_4 = codim (I(T_0)+J)_4 = codim (I(V)+I(T_0)+J)_4 = 1: the primitive classes of T_0 and V_6 are
proportional. det(N') is not in I(V)_3 + J_3, is tangent to the Hodge locus of [V_6], and
I(V)_3 + J_3 + <det N'> is the whole tangent space (exact over Q at one point).
Special members: F = f(x0..x3) + g(x4..x7) (T = join of two twisted cubics); the Fermat cubic (two Fermat cubic
surfaces in complementary variables; there codim (I_T + J)_4 = 16, not 1, see N-CODIM-IJ4-AT-FERMAT).

**Conditions.**

Random instances: primes 32003, 30011 (T2, Macaulay2), 32003, 30011, 1000003 (check C13, Singular, entries in
[-1000, 1000]).

**Evidence.** Team T2 (twodet*.m2, tan_point_QQ.m2), rounds 4 and 4-resumed. Package test 13 on a fresh random instance.

**Independent check.**

C13 (coordinator, own Singular code, three primes): every number of (a)-(d) and of the link with V_6, with a
control (rows of A with rows of an unrelated matrix: F not in the ideal). Not covered: (e); the identification
with W_(-1); the literature.

**Not established.**

That the Hodge locus is the family (that is D-TWO-DET-HODGE-LOCUS, a paper argument). Smoothness of T beyond
modulo p.

**Known before.**

not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further. A literature check for
this determinantal description was not done (O-LITERATURE-CHECK-DET-PFAFF).

**Reproduce.**

Run from the repository root (Macaulay2 1.22).

```
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
setRandomSeed 11; S = ZZ/32003[x_0..x_7];
A = random(S^3, S^{3:-1}); B = random(S^3, S^{3:-1});
F = det A + det B; I = minors(2, A^{0,1}) + minors(2, B^{0,1});
h = hodgeLocusTangentCodim(F, I);
print(dim I - 1, degree I, apply(4, i -> hilbertFunction(i + 1, I)), h#"codim", h#"codimIJ", h#"hypothesis", hilbertFunction(3, minors(2, A) + minors(2, B)));
```

Expected: (3, 9, {8, 30, 76, 155}, 8, 1, true, 8). Also tests/run_all.sh 13_discovery (file
tests/validation/13_discovery_explicit_families.m2; 14 checks) and docs/05_tangent_codimension_two_determinants.md.

**Session references (files not public).**

LEDGER_DISCOVERY.md "[T2] 05:45Z", "[T2] 06:08Z", "[CHECK C13] 14:42Z"; discovery/t2_w_cycle/NOTE_W_minus1.md
(section 3); tests/SOURCES.md E7.

---

## D-TWO-DET-HODGE-LOCUS

**The Hodge locus of [T] is smooth of codimension 8 and equals the closure of the sums of two determinants**

kind: `result` | area: `explicit_cycles` | status: **`PAPER_ARGUMENT_AI`**

**Statement.**

Given D-TWO-DET-FAMILY-NUMBERS and the fact that a Hodge locus on cubic sixfolds is cut locally by at most
h^(4,2) = 8 equations: at a general cubic F = det A + det B the Hodge locus of the class of the degree-9 threefold T
is smooth of codimension 8 and coincides with the family of sums of two determinants. The closure N of that family
(the secant variety of the determinantal cubics, irreducible, of codimension 8) equals the closure of the Hodge
locus of the flag-threefold class [V_6] - 2h^3; the cubics containing a V_6 are its tangent variety, a divisor of N
(9 conditions against 8). On V_6 cubics [T] = h^3 + [V_6] or 5h^3 - [V_6] (degree 9 and square 15 leave only
these), i.e. [T] - 3h^3 = +-([V_6] - 2h^3); the two types of T realise both signs.

**Conditions.**

The numbers of D-TWO-DET-FAMILY-NUMBERS (MOD p; partly exact); the 8-equation fact; irreducibility of the secant
variety.

**Evidence.**

Team T2, NOTE_W_minus1.md sections 3(a)-(f): every sum of two determinants lies on an arc F_t with N' = A - B, and
for small t the arc is in N.

**Independent check.**

C13 confirmed the numerical inputs and states the deduction; it is not a separate proof-read. The chain of section
3 of T2's note has had no independent read.

**Not established.**

A direct computation of the class of T at a general point (it is pinned down through the flag threefold only).
Anything about the literature.

**Known before.** not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further

**Reproduce.**

Inputs: see D-TWO-DET-FAMILY-NUMBERS and D-FLAG-THREEFOLD-V6. The deduction is not reproducible from this
repository: a paper argument.

**Session references (files not public).**

discovery/t2_w_cycle/NOTE_W_minus1.md (S2, S3, section 3); LEDGER_DISCOVERY.md "[T2] 05:45Z", "[T2] 15:42Z",
"[CHECK C13]".

---

## D-W-MINUS1-IS-TWO-DET-CLOSURE

**For lambda = -1 the second component W_(-1) on cubic sixfolds is an open piece of the closure of det A + det B**

kind: `result` | area: `explicit_cycles` | status: **`PAPER_ARGUMENT_AI`**

**Statement.**

For cubic sixfolds with two 3-planes meeting in a point: at every point of the degenerate divisor D = {det C = 0}
of V_Z, the second component W_(-1) of the Hodge locus of [P1] - [P2] (D-CUBIC-SIXFOLD-DETC) is irreducible and
reduced, and it is an open piece of the unique irreducible component N of the Hodge locus of the class
[V_6] - 2h^3 of a flag threefold. With D-TWO-DET-HODGE-LOCUS: W_(-1) is (an open piece of) the closure of the family
of cubics det A + det B, and at its general point the transported class P1 - P2 equals +-([T] - 3h^3)
= +-([T_rows,rows] - [T_rows,cols])/2, carried by the explicit degree-9 threefolds. The sign and the behaviour
under monodromy are not determined. The cubics containing a V_6 form a divisor of W_(-1); deeper strata carry
h^3 plus three planes in a triangle, and cones over sextic del Pezzo surfaces.
The correct wording is "the closure of": see C-CLOSURE-OF-WORDING and D-GENERAL-CUBIC-OF-D-IS-LIMIT.

**Data.**

```text
The chain (T2's note, section 2, after the three fixes of check C8):
(i) squash a V_6 onto a hyperplane and take the cone limit: the limit is the cone over a projected sextic del Pezzo
    surface S' (plus a harmless embedded point); so every smooth split-type cubic x0*Q + c with {c = 0} containing
    such an S' is a limit of V_6 cubics, with class the cone over S';
(ii) S'.S' = 18, such cubic fourfolds are dense in Hassett's divisor C_18 (irreducible, cited);
(iii) for a cubic fourfold with two disjoint planes Pi1, Pi2 (lattice <h^2, Pi1 - Pi2>, discriminant 18), on the
    branch where Pi1 - Pi2 stays algebraic: [S'] = 2h^2 +- (Pi1 - Pi2); the cone is a correspondence with
    (cone a, cone b) = -2 (a, b) + (a.h^2)(b.h^2), injective; so [cone over S'] = 2h^3 +- transport(P1 - P2);
(iv) the split-type cubic is not on V_Z; by Theorem A of note 1 the Hodge locus of P1 - P2 near the two-plane
    cone-type cubic is 2 V_Z u W_(-1); so near the split-type cubic it is W_(-1), and the closure of the V_6 Hodge
    locus is a component of it there;
(v) u'|V_Z = unit * det C and C is a submersion onto 3 x 3 matrices, so W_(-1) is irreducible and reduced at every
    point of D; hence the identification at every point of D.
General lambda = r/s by the same cone bridge (unchecked): W_lambda is the component through cones over cubic
fourfolds in C_d, d = 8r^2 - 2rs + 8s^2 (14 for lambda = 1, 18 for -1, 36 for 2 and 1/2, 44 for -2).
```

**Conditions.**

Theorem A(1)-(3) of the unreviewed note 1, including at points with C = 0; Hassett's irreducibility of C_18
(cited; machine-read by the checker); ranks modulo primes; standard facts on flat limits and correspondences.

**Evidence.**

Team T2, rounds 3 and 4 (exact computation split_exact.m2 for step (i)). Supporting computations not using the
chain: D-RANK-INVARIANT (the class along W_(-1) has the invariants of a sum of two determinants, and only for
lambda = -1) and D-DEGENERATION-ALONG-ARC.

**Independent check.**

C8: one adversarial read against Theorem A of note 1, own computations MOD p: no fatal error, three fixes, sharper
conclusion. C7: the exact cone computation of step (i). Not covered: sections 3 and 6 of T2's note beyond what C13
and C16 checked; note 1 itself.

**Not established.**

An explicit description of the limit of T at a cubic of D; the matrices along a path into D
(O-RECOVER-MATRICES-AND-LIMIT-OF-T). Everything is conditional on note 1.

**Known before.** not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further

**Reproduce.**

Inputs: D-FLAG-THREEFOLD-V6 and D-TWO-DET-FAMILY-NUMBERS. The identification is not reproducible from this
repository: a paper chain; needed: the class of the limit of T at a cubic of D, computed directly.

**Session references (files not public).**

discovery/t2_w_cycle/NOTE_W_minus1.md (S1, section 2); LEDGER_DISCOVERY.md "[T2] 05:07Z", "[CHECK C8] 05:32Z",
"[T2] 15:42Z", "[COORD] 15:48Z".

---

## D-GENERAL-CUBIC-OF-D-IS-LIMIT

**Plane lemma |g.P| <= 3; the general cubic of D is a limit of sums of two determinants, not a sum**

kind: `result` | area: `explicit_cycles` | status: **`PAPER_ARGUMENT_AI`**

**Statement.**

Lemma. Let X = {det A + det B = 0} be smooth, g = [T] - 3h^3 (T for general row pencils), and P a 3-plane in X not
contained in {det A = 0}. Then |g.P| <= 3.
Consequence. On the divisor D the class is g = +-(P1 - P2), which needs g.P1 = -+6 and g.P2 = +-6. So at a smooth
honest sum with this class both planes lie in both determinantal cubics; the pairs (A, B) for which
{det A = 0} n {det B = 0} contains a 3-plane form sets of codimension at least 4 in the family, while D has
codimension 1. Hence the GENERAL cubic of D is a limit of sums of two determinants and not a smooth honest sum.
Special cubics of D may be honest sums. A direct comparison of the class of T with P1 - P2 at a point of D is
therefore impossible.

**Data.**

```text
Proof status. T's written proof: T n P is the intersection of two curves on the cubic surface {det A = 0} n P; a
common component for all pencils lies in the singular locus of X; so T.P >= 0, T'.P >= 0, and T + T' = 6h^3 gives
0 <= T.P <= 6. Gap (flagged by T2, found by C16): a common component that moves with the pencils is not treated.
Repair by the checker, by hand: a dimension count on the incidence variety reduces to the case where one matrix
has rank <= 1 on a plane of P; then a classification of nets of singular 3 x 3 matrices (compression spaces or the
skew-symmetric space; Atkinson, Eisenbud-Harris, cited from memory) gives a singular point of X or a
contradiction. The repair was read by no one else.
Exact data on the Fermat sixfold, splitting {0123 | 4567}, one class g: over all 8505 linear 3-planes g.P takes
the values -3: 72 planes, -2: 540, -1: 1080, 0: 5121, 1: 1080, 2: 540, 3: 72. |g.P| = 3 only for planes inside both
determinantal cubics: (row,row) 36 and (col,col) 36 give -3; (row,col) 36 and (col,row) 36 give +3; "block" planes
(585) give 0; planes not inside {det A = 0} (7776) have |g.P| <= 2. T2's own scan: all 216 x 216 classes of this
splitting, values in {-3..3}; no pair of Fermat planes has P1 - P2 = +-g for any of the 35 splittings.
Modulo p (32003, 30011), random examples: g.P = -2 or +2 for planes not in {det A = 0}; +-3 for (row,row),
(col,col), (row,col), (col,row); 0 for block and "skew" types. T2's list of plane types (row, column, block) is
incomplete: a fourth, "skew" type occurs on smooth cubics. With the block structure preserved between A and B the
cubic is singular along a curve.
```

**Conditions.**

The class statement g = +-(P1 - P2) at points of D, i.e. D-W-MINUS1-IS-TWO-DET-CLOSURE (not checked in C16); a
classification cited from memory in the repair.

**Evidence.** Team T2 (fermat_quad.py exact; block_planes.m2, nodal_det.m2 MOD p; hand arguments).

**Independent check.**

C16 (blind, 33 minutes): statement of the lemma confirmed by two methods at two primes and exactly on the Fermat
sixfold; proof gap closed by the checker; classification of plane types not confirmed (skew type missing);
consequence follows for the general smooth cubic of D from the lemma and a dimension count alone.

**Not established.**

No proof that |g.P| = 6 never occurs for (block,block), (skew,block), (skew,skew) planes: samples only. The
eightfold analogue of the lemma. Which degeneration of (A, B) produces D (see D-DEGENERATION-ALONG-ARC and
O-RECOVER-MATRICES-AND-LIMIT-OF-T).

**Known before.** not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further

**Reproduce.**

not reproducible from this repository: the plane-by-plane intersection counts used the session's scripts. Needed:
for a plane P in X, length(T n P) for random row pencils (a few lines of Macaulay2 once P and (A, B) are given).

**Session references (files not public).**

LEDGER_DISCOVERY.md "[T2] 15:42Z", "[CHECK C16] 16:18Z", "[COORD] 16:19Z"; discovery/t2_w_cycle/NOTE_W_minus1.md
(section 6 and addendum).

---

## D-DEGENERATION-ALONG-ARC

**Along one arc into D the 18 quadrics split into two determinantal nets; both cubics have a pole of order 6**

kind: `result` | area: `explicit_cycles` | status: **`MOD_P`**

**Statement.**

```text
Setting: the Fermat cubic sixfold in y0..y7 with P1 = {y0 = z y1, y2 = z y3, y4 = z y5, y6 = z y7} and
P2 = {y1 = -y2, y3 = -y4, y0 = -y5, y6 = -y7} (corank of C equal to 1), and an arc F_eps inside W_(-1): the
9-parameter family Fermat - sum t_m y^m over the 9 cubic monomials of the exported file six_lam-1_arc.txt,
normalised by t(y2 y4 y6) = eps and extended by Newton iteration. Modulo the two primes 268435399 and 268435291:
(0) the 8 period functions vanish modulo eps^25 along the extended arc;
(1) the catalecticant Cat(2,2) has 12 units, 6 factors of valuation 2 and a kernel Q(eps) of rank 18; the algebra of
    endomorphisms of Q(eps) respecting its 32 linear syzygies has dimension 2; its second generator satisfies a
    quadratic equation whose discriminant has valuation exactly 12 with a square leading coefficient. So over the
    Laurent series field Q(eps) = I_A + I_B, two nets of rank 9, each with multiplication rank 56 into the cubics and
    16 linear syzygies: the numbers of the 2 x 2 minors of a 3 x 3 matrix. The idempotents have a pole of order 6;
(2) F_eps = G_A + G_B with G_A in I_A * S_1, G_B in I_B * S_1; both have a pole of order exactly 6 at eps = 0, with
    leading terms c * l^3 and -c * l^3, where l = sum_i p_i^2 y_i is the tangent hyperplane of the Fermat cubic at
    p = P1 n P2 = (z, 1, -1, -1/z, 1/z, 1/z^2, 0, 0), which is also the hyperplane spanned by P1 and P2. The polar
    parts cancel exactly.
So along this path the two determinantal cubics do not converge: each tends projectively to the triple hyperplane
l^3, and the cubic of D is what remains at order eps^0.
```

**Data.**

```text
Further readings by T2 at one prime (not all covered by the check):
Pole expansion in coordinates (l, y1..y7), w = (y6, y7), y' = (y1..y5):
eps^6 G_A = a_0 l^3 + eps l^2 tau_1(w) + eps^2 l sigma_2(w) + eps^3 (a_3 l^3 + l^2 tau_3(y') + l sigma_3(y') +
delta_3(w)) + ... Leading normal form, with weights l: 0, w: 1, y': 3/2: eps^6 G_A / a_0 is, to lowest weight,
    (l + m_1(w))(l + m_2(w))(l + m_3(w)) - (l + m_3(w)) kappa_3(y') - (l + m_1(w)) kappa_1(y'),
with kappa_1, kappa_3 quadrics of rank 2 in y'. This is the determinant of a tridiagonal matrix
    [[l + m_1, b_1, 0], [c_1, l + m_2, b_2], [0, c_2, l + m_3]],  b_1 c_1 = kappa_3, b_2 c_2 = kappa_1,
with {l = b_1 = c_1 = 0} the P^4 spanned by P1 and the kernel line of C in P2, and {l = b_2 = c_2 = 0} the P^4
spanned by P2 and the kernel line in P1. The cubic and the two quadrics are computed; the matrix is a reading.
Limits of the nets at eps = 0: each 9-dimensional; they share 7 quadrics l * (linear form); sum of dimension 11; on
{l = 0} each is a pencil whose base locus is four P^4's through the plane spanned by p and the two kernel
directions; two of the four are common to both nets.
Limit tangent space: the limit U_0 of Q(eps) * S_1 has dimension 112, contains J_3 and meets T V_Z in codimension 9.
Multiplication Q(eps) x S_1 -> S_3: rank 112 (pivot valuations: 101 units, 10 of valuation 1, 1 of valuation 2).
Precision needed: with the arc known only modulo eps^19 the discriminant looks zero; modulo eps^20 its valuation 12
appears. T3's exported file agrees with the extended arc only modulo eps^8.
```

**Conditions.**

One arc, one point of D, two primes; one embedding of zeta_6 per prime. Nets known modulo eps^6 (check) or about
eps^11 (T2).

**Evidence.**

Team T2, round 5 (arclib.py, extend_arc.py, analyse1.py, analyse2.py, read_poles.py; T3's annihilator tool). File:
discovery/t2_w_cycle/round5/arc_extended_mod_p.txt (session only).

**Independent check.**

C20 (blind, own engine and linear algebra over F_p[[eps]]): (0), (1), (2) confirmed at both primes, with pipeline
controls (18 random quadrics and the minors of ONE random matrix give a 1-dimensional algebra; the minors of two
random matrices give 2). Not covered: the pole expansion beyond the leading term, the normal form, the limits of
the nets, U_0.

**Not established.**

Characteristic 0. More than this one arc. That the nets are generated by minors of matrices of linear forms (only
the numbers 9 / 56 / 16 agree). The matrices A(eps), B(eps) and the flat limit of T. So the paper chain of
D-W-MINUS1-IS-TWO-DET-CLOSURE is supported, not replaced.

**Known before.** not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further

**Reproduce.**

not reproducible from this repository: the extended arc and the splitting pipeline are session files. The starting
arc is in M2/HodgeLociCI/data/six_lam-1_arc.txt (valid modulo eps^8 only). Needed: catalecticant kernels along an
arc and the endomorphism-algebra test (M-ENDOMORPHISM-SPLITTING-TEST).

**Session references (files not public).**

LEDGER_DISCOVERY.md "[T2] 18:11Z", "[T2] 18:38Z", "[CHECK C20] 18:57Z"; discovery/t2_w_cycle/NOTE_W_minus1.md
(section 8).

---

## D-PFAFFIAN-LAMBDA1

**Cubic sixfolds l*Q + Pfaffian: 7 conditions, an explicit quintic threefold whose Hodge locus is the family**

kind: `result` | area: `explicit_cycles` | status: **`MOD_P`**

**Statement.**

Let F = l*Q + Pf(M), with l a linear form, Q a quadric and M a 6 x 6 skew-symmetric matrix of linear forms in
x0..x7 (equivalently: one hyperplane section of X is a Pfaffian cubic). At random such F (smooth): the tangent
space of the family, l*S_2 + Q*S_1 + (4 x 4 Pfaffians of M)_3, has codimension 7 and contains J_3; X contains the
quintic del Pezzo threefold T5 = {l = 0} n {4 x 4 Pfaffians of a 5 x 5 principal submatrix of M}, of dimension 3 and
degree 5; codim (I_T5 + J)_4 = 1; the Hodge locus of [T5] has tangent codimension 7 and its tangent space equals
that of the family. So (given the 8-equation fact) the Hodge locus of [T5] is smooth of codimension 7 there and is
the family. This is the shape of the locus for lambda = 1, parallel to "det + det" for lambda = -1.

**Data.**

Invariants of the class (D-RANK-INVARIANT, lambda = 1): one linear form annihilates it (T5 lies in a hyperplane);
24 quadrics (l*S_1, Q and the 15 Pfaffians); Hilbert function 1, 7, 12, 7, 1. X also contains the quartic scrolls
{l = 0} n {kernel of M meets a fixed 3-space} (by hand). Under the cone bridge lambda = 1 corresponds to Hassett's
divisor C_14 (Pfaffian cubic fourfolds), lambda = -1 to C_18.

**Conditions.**

Random instances at primes 32003 (T2) and 32003, 30011 (C15). The last sentence of the statement is a deduction
that uses the fact that a Hodge locus on cubic sixfolds is cut by 8 equations.

**Evidence.**

Team T2 (join_checks.m2). Package test 13. Night run: the numbers of the quintic del Pezzo threefold equal those
of h^3 + P1 + P2, and NL(1) is irreducible of codimension 7 (D-LAMBDA1-PFAFFIAN-AND-SCROLL).

**Independent check.**

C15(a) (coordinator, own Singular code, two primes). Not covered: the identification of this family with the
component NL(1) of the two-plane problem (not re-derived; not matched against the proof in note 1).

**Not established.** That this settles the point left open in note 1 at more than tangent level. Novelty.

**Known before.**

Related, as machine-read in the night run: Kloosterman arXiv:2312.12363, Proposition 6.4 and Corollary 6.5 use the
pencil F - t det(L) and cones over G(2,5) for lambda = 1 (tests/SOURCES.md records Corollary 6.5 only). The
description 'reducible cubic plus Pfaffian' with 7 conditions: not found in the sources we read (machine-read, see
tests/SOURCES.md); not checked further.

**Reproduce.**

Run from the repository root (Macaulay2 1.22).

```
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
setRandomSeed 1515; S = ZZ/32003[x_0..x_7];
Mk = random(S^6, S^{6:-1}); Mk = Mk - transpose Mk; l = random(1, S); Q = random(2, S);
F = l*Q + (gens pfaffians(6, Mk))_(0,0);
I5 = ideal(l) + pfaffians(4, submatrix(Mk, {0,1,2,3,4}, {0,1,2,3,4}));
t = hodgeLocusTangentCodim(F, I5);
print(dim I5 - 1, degree I5, t#"codim", t#"codimIJ", hilbertFunction(3, ideal(l, Q) + pfaffians(4, Mk)));
```

Expected: (3, 5, 7, 1, 7). Also in tests/validation/13_discovery_explicit_families.m2.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T2] 15:43Z", "[CHECK C15] 15:48Z"; tests/SOURCES.md E7.

---

## D-LAMBDA1-PFAFFIAN-AND-SCROLL

**Equal coefficients: NL(1) is smooth of dimension dim V_Z + 1, with quintic del Pezzo k-folds and quartic scrolls**

kind: `result` | area: `explicit_cycles` | status: **`PROVED_AI_UNREVIEWED`**

**Statement.**

(Theorems E and B of the unreviewed note 1; Theorem E is a re-derivation of a construction of Kloosterman.)
For cubic sixfolds with two 3-planes meeting in a point and cubic eightfolds with two 4-planes meeting in a line,
the Hodge locus NL(1) of [P1] + [P2] is smooth and reduced of dimension dim V_Z + 1 (codimension 7, resp. 19) at
every point of V_Z. The nearby members {F + t det(l_ij) = 0}, t != 0, contain codimension-3 Pfaffian k-folds of
degree 5 (quintic del Pezzo k-folds for general X; the five 4 x 4 Pfaffians of a 5 x 5 block), of class
h^k + [P1] + [P2].
Theorem B (sixfolds, general point of V_Z): NL(1) is the closure of the locus of cubics containing a quartic scroll
S(1,1,2), of class 2h^3 - [P1] - [P2]; [scroll] + [quintic del Pezzo] = 3h^3.

**Data.**

Pfaffian identity (kernel-checked in Lean over any commutative ring): Pf [[A, tau L], [-tau L^T, B]]
= tau (alpha^T L beta - tau^2 det L), A, B the skew matrices of the vectors alpha, beta.
Codimensions of loci of cubic sixfolds (night run, MOD p): containing one 3-plane 4; a cubic scroll S(1,1,1) 6; a
quartic scroll S(1,1,2) 7; a cone S(0,2,2) 8; S(0,1,3) 9; a cone over a Veronese surface 10; two quadric cones
sharing a plane 8. Published column of Movasati's table: L = 4, CS = 6, M = 7, QS = 8, V = 10; the session reads
his QS as the cone.

**Conditions.** A submersion argument from note 1; the Hodge-theoretic inputs cited there. Theorem B: 'general' point only.

**Evidence.**

Note 1 (agent P's proof, AI referee 4: no fatal error). Lean: lean/core/PfaffianCert.lean; the finite parts of the
scroll proof were kernel-checked in the night run (four Lean files, ScrollCert, DegenCert, HodgeRankCert,
ClassCert, which are not in this repository).

**Independent check.** none with a C-number

**Not established.**

Not human-reviewed. Theorem E is stated as not new. The identification with S(1,1,2) (Theorem B) 'appears new' in
the night ledger; novelty not checked.

**Known before.**

published: Kloosterman arXiv:2312.12363, Corollary 6.5 (V_Z has positive codimension in the Hodge locus of [Pi_1]
+ [Pi_2] for d = 3, c = 3). The identification with the quartic scroll locus: not found in the sources we read
(machine-read, see tests/SOURCES.md); not checked further.

**Reproduce.**

Run from the repository root (Macaulay2 1.22). Second-order side (the excess direction survives at lambda = 1):
see the snippet of D-CUBIC-SIXFOLD-DETC. Kernel-checked identity: lean/run_all.sh core (file
lean/core/PfaffianCert.lean). The explicit family F + t det(l_ij) is not implemented in the package.

**Session references (files not public).**

deliverables/hodge_loci_session/papers/paper1.tex (Theorems B, E); LEDGER.md "THE EQUAL-COEFFICIENT HALF (agent
P)", "Night, entries after 06:28Z"; night/pfaff/PFAFF.md; night/lambda1/PROOF.md.

---

## D-EIGHTFOLD-FAMILY-TD

**Cubic eightfolds l*Q + det A + det B: 26 conditions, an explicit fourfold of degree 9 (self-intersection 51)**

kind: `result` | area: `explicit_cycles` | status: **`MOD_P`**

**Statement.**

```text
Let F = l*Q + det A + det B in P^9, with l linear, Q a quadric, A, B two 3 x 3 matrices of linear forms in x0..x9
(equivalently: one hyperplane section is a sum of two determinants). At random such F (smooth):
(a) the tangent space of the family, l*S_2 + Q*S_1 + I_2(A)_3 + I_2(B)_3, has codimension 26 in the 220 cubics;
(b) the fourfold T4 = {l = 0} n {rows 1, 2 of A proportional} n {rows 1, 2 of B proportional} lies in X, has
    dimension 4 and degree 9; S/(I(T4) + J) has Hilbert function 1, 9, 29, 26, 9, 1, 0; the Hodge locus of [T4] has
    tangent codimension 26 and its tangent space equals that of the family;
(c) S/(l, Q, I_2(A), I_2(B)) has Hilbert function 1, 9, 26, 26, 9, 1, 0 (a Gorenstein quotient: this ideal is the
    annihilator of the class); the quadric part has dimension 29 and exactly one linear form m has m*S_1 inside it.
Exact count on the Fermat eightfold: T4.T4 = 51, so ([T4] - 3 eta^4)^2 = 24.
So (given that a Hodge locus contains every family along which the cycle deforms, and has tangent codimension 26)
the family is, near a general member, the Hodge locus of [T4], smooth of codimension 26 = codim V + 6.
```

**Data.**

The Fermat eightfold is a member for the splitting {x6, x7 | x0..x3 | x4, x5, x8, x9}: x6^3 + x7^3 = l*Q and each
Fermat cubic surface is det [[a_1, b_1, 0], [0, a_2, b_2], [b_3, 0, a_3]]; there T4 is a union of 9 Fermat
4-planes and the 81 intersection numbers add up to 51. T4(rows,rows) + T4(rows,cols) = 6 eta^4: the two types have
opposite primitive classes. Along the family, primitive classes that stay Hodge to first order: 1.

**Conditions.**

Random instances: 32003 (T2), 32003 and 30011 (C15, C17), 32003 seed 9 (T3). The last sentence of the statement is
a deduction (a Hodge locus contains every family along which the cycle deforms; equal tangent spaces).

**Evidence.**

Team T2 (join_checks.m2: the two codimensions), coordinator's check C15 (b), (c) (the fourfold and its Hodge
tangent space), check C17 (N1), team T3 (td_count.sing; t4sq.py exact count). Package test 13.

**Independent check.**

C15 (Singular) and C17 (Macaulay2) agree with each other and with T2. Not covered: any link between this family
and the pair X1 (that is D-X1-COMPONENT-IS-TD-CLOSURE); the class of T4 on Segre-type cubics beyond
proportionality (D-SEGRE-FOURFOLD).

**Not established.** Exact (characteristic 0) ranks. Novelty.

**Known before.** not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further

**Reproduce.**

Run from the repository root (Macaulay2 1.22).

```
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
kk = ZZ/32003; S = kk[x_0..x_9]; hf = (I, r) -> apply(r, i -> hilbertFunction(i, I));
setRandomSeed 1516; A = random(S^3, S^{3:-1}); B = random(S^3, S^{3:-1}); l = random(1, S); Q = random(2, S);
F = l*Q + det A + det B; IT = ideal(l) + minors(2, A^{0,1}) + minors(2, B^{0,1});
t = hodgeLocusTangentCodim(F, IT); J = ideal jacobian matrix{{F}};
print(dim IT - 1, degree IT, hf(IT + J, 7), t#"codim", hilbertFunction(3, ideal(l, Q) + minors(2, A) + minors(2, B)));
print(hf(ideal(l, Q) + minors(2, A) + minors(2, B), 7));
```

Expected: (4, 9, {1, 9, 29, 26, 9, 1, 0}, 26, 26) and {1, 9, 26, 26, 9, 1, 0}. Also in
tests/validation/13_discovery_explicit_families.m2.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T2] 15:43Z", "[CHECK C15]", "[CHECK C17]" (N1), "[T3] 16:27Z"; tests/SOURCES.md E7.

---

## D-SEGRE-FOURFOLD

**Segre fourfold P^2 x P^2 in a cubic eightfold: 27 conditions to contain it, Hodge locus of codimension 26**

kind: `result` | area: `explicit_cycles` | status: **`MOD_P`**

**Statement.**

Let Sigma = P^2 x P^2 = {x9 = 0, rank N <= 1} (N the generic 3 x 3 matrix in x0..x8), I its ideal, F a random
cubic in I with X = {F = 0} smooth, J the Jacobian ideal, A = S/(I + J). Then A has Hilbert function 1, 9, 26, 27,
9, 1, 0; the class of Sigma is isolated; "contains a Segre fourfold" has tangent codimension dim A_3 = 27; the
Zariski tangent space of the Hodge locus of [Sigma] has codimension rank(A_3 x A_2 -> A_5) = 26. So the Hodge
locus of the Segre class is one dimension larger than the Segre locus, and 26 = codim V + 6.
At a Segre-type cubic F_0 = x9*Q + sum N'_ij cof_ij(N): det(N') is not in I_3 + J_3 and is tangent to the Hodge
locus (27 -> 26): the limit of the tangent spaces of the family l*Q + det A + det B along
F_t = l*Q + (det(N + tN') - det N)/t. The flat limit of the fourfold T4 along F_t has degree 9, does not contain
Sigma, and its primitive class is proportional to that of Sigma: [lim T4] - 3 eta^4 = +-([Sigma] - 2 eta^4), sign
not determined (the squares agree: 24).

**Data.**

Sigma has degree 6 and Sigma.Sigma = c_4(N) = 36. Cone-type cubic x0*Q + c with {c = 0} a cubic sixfold through a
flag threefold (so X contains the cone over V_6, a degenerate P^2 x P^2): Hilbert function 1, 9, 27, 28, 10, 1,
tangent codimension of the Hodge locus 26.
The tower of linear sections of P^2 x P^2 in cubic 2k-folds, k = 2, 3, 4: sextic del Pezzo surface (class
2h^2 +- (Pi1 - Pi2), square 18: Hassett's divisor C_18), flag threefold (square 0), Segre fourfold (square 36). In
each case the two k-planes meet in codimension 3 and the coefficient is -1. Codimensions of the Hodge loci: 1, 8,
26; of the two-plane loci: 2, 8, 20.

**Conditions.** Random instances at primes 32003, 30011, 1000003.

**Evidence.** Team T3 (segre2.m2, segre3.m2, eight_limit.sing at two primes; Chern classes with sympy). Package test 13.

**Independent check.**

C12 (coordinator, Singular, three primes and seeds): Hilbert function and rank 26. C15(d), C17 (N2, N3, N4): the
direction det N', the limit of T4, the cone-type numbers.

**Not established.**

That the Segre Hodge locus and the germ W' at X1 coincide (D-X1-COMPONENT-IS-TD-CLOSURE). The sign of the class of
the limit of T4.

**Known before.** not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further

**Reproduce.**

Run from the repository root (Macaulay2 1.22).

```
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
kk = ZZ/32003; S = kk[x_0..x_9]; setRandomSeed 1212; N = genericMatrix(S, 3, 3); I = ideal(S_9) + minors(2, N);
F = S_9 * random(2, S) + sum(flatten entries gens minors(2, N), m -> random(1, S) * m);
t = hodgeLocusTangentCodim(F, I); J = ideal jacobian matrix{{F}};
print(apply(7, i -> hilbertFunction(i, I + J)), t#"codim", hilbertFunction(3, I + J));
```

Expected: ({1, 9, 26, 27, 9, 1, 0}, 26, 27). Also in tests/validation/13_discovery_explicit_families.m2.

**Session references (files not public).**

LEDGER_DISCOVERY.md "[T3] 05:41Z", "[T3] 06:05Z", "[T3] 06:13Z", "[CHECK C12] 14:42Z", "[CHECK C15]", "[CHECK
C17]", "[T3] 16:27Z"; tests/SOURCES.md E7.

---

## D-CONE-DICTIONARY

**Cone-type points: classes r P1 + s P2 are cones over classes of discriminant 8r^2 - 2rs + 8s^2 on cubic fourfolds**

kind: `result` | area: `explicit_cycles` | status: **`PAPER_ARGUMENT_AI`**

**Statement.**

If a hyperplane section X n H of a cubic sixfold is a cone (vertex p) over a cubic fourfold Z in P^5, then
H^4(Z)(-1) sits inside H^6(X) via cones: a surface S in Z gives the threefold Cone_p(S) in X; 3-planes through p are
cones over planes of Z, and two 3-planes meeting only at p correspond to two disjoint planes. On primitive parts
<Cone a, Cone b>_X = -2 <a, b>_Z, so a class of discriminant d on Z (Z in Hassett's divisor C_d) gives a class of
lattice discriminant -2d on X. The classes r P1 + s P2 are of this type with d = 8r^2 - 2rs + 8s^2:
(1,1): 14, (1,-1): 18, (1,2): 36, (1,-2): 44, (1,3): 74. So for every lambda there are cubic sixfolds outside the
two-plane locus where the class is algebraic (a cone), because the Hodge conjecture is known for cubic fourfolds.
Movasati's pair on the Fermat cubic is a cone-type point (C = 0).

**Data.**

Checks of the pairing: planes 8 <-> -16, cubic scroll 12 <-> -24, quartic scroll / quintic del Pezzo 14 <-> -28,
C_18 <-> -36, Veronese 20 <-> -40. First-order numbers of cones (MOD p, night run): cone over quartic scrolls: 8-9
conditions, Hodge-locus tangent codimension 7; cone over a quintic del Pezzo surface: 7, 7; cone over a Veronese
surface: 10, 7; cone over a cubic surface scroll: 6, 6; cone over a projected sextic del Pezzo surface: 15, 7.
The cone itself deforms in far fewer directions than its class.

**Conditions.** Standard facts on correspondences; the Hodge conjecture for cubic fourfolds (cited).

**Evidence.**

Night run (tools/cones.py, MOD p). Discovery round: T2 and C17 re-derived the pairing with the degree term: (cone
a, cone b) = -2 (a, b) + (deg a)(deg b).

**Independent check.** C8 and C17 used and re-derived the cone pairing by hand. No blind recomputation of the first-order table.

**Not established.**

Which surfaces on the general fourfold of C_36, C_44 give cycles for lambda = 2, -2 (not attempted). The cone
construction gives Hodge classes only on cone-type families, not in a neighbourhood.

**Known before.**

Kloosterman arXiv:2312.12363, Theorem 5.3 (split type: cones over cubic fourfolds; as machine-read). The
discriminant formula for r P1 + s P2: not found in the sources we read (machine-read, see tests/SOURCES.md); not
checked further.

**Reproduce.**

not reproducible from this repository: cone-type instances are not built by the package. Needed: a cubic x0*Q + c
with c through a given surface, then hodgeLocusTangentCodim(F, ideal of the cone).

**Session references (files not public).**

LEDGER.md "Round 3 (night session)" (fourfold-type dictionary); LEDGER_DISCOVERY.md "[T2] 05:07Z", "[CHECK C17]"
(step 1).

---

## D-CYCLE-CONSTRAINTS-OTHER-LAMBDA

**Constraints on any cycle carrying the class for lambda = 2, 1/2, -2, 3, 5/3: spans P^7, lies on no extra quadric**

kind: `result` | area: `explicit_cycles` | status: **`MOD_P`**

**Statement.**

For lambda = 2, 1/2, -2, 3, 5/3, at the general point of the sixfold second component W_lambda (as seen along
generic arcs at the pair of type [6T 2F], D-RANK-INVARIANT): no quadric outside the Jacobian ideal annihilates the
class. Since the ideal of any cycle Y carrying the class, plus the Jacobian ideal, lies in the annihilator: such a
Y lies in no hyperplane, and every quadric through Y is a combination of the partial derivatives of the cubic.
Separately (paper argument, T2 04:21Z, unchecked): near a general point of D, no cycle of class
a h^3 + b (P1 + lambda P2), b != 0, on W_lambda minus V_Z is supported in a hyperplane; in particular none is a cone
over a surface, a quartic scroll or a quintic del Pezzo threefold. Reason: if a linear form L vanishes on the
support T of a cycle then L * P_T = 0 in the Jacobian ring and the tangent codimension of NL([T]) is at most
8 - dim I(T)_1, while W_lambda is smooth of codimension 8 there.

**Conditions.** D-RANK-INVARIANT (MOD p, finite order along arcs). The paper argument rests on Theorem A of note 1.

**Evidence.** Team T3 (16:30Z, corrected 16:33Z); team T2 (04:20Z lemma, 04:21Z argument).

**Independent check.** none for the constraint itself (C18 checked the exported arcs only: rank at least 27 there)

**Not established.** Existence or shape of any cycle for these lambda (O-OTHER-COEFFICIENTS).

**Known before.** not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further

**Reproduce.** not reproducible from this repository: see D-RANK-INVARIANT.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T2] 04:20Z", "[T2] 04:21Z", "[T3] 16:30Z", "[T3] 16:33Z".

---

## D-TENFOLD-COBLE-FAMILY

**Tenfold lead: an explicit codim-54 family through F_T (P^8-section a Coble cubic); first-order Hodge locus of its class = the family; tangent to NL([V]) along F_T in the extra direction**

kind: `result` | area: `explicit_cycles` | status: **`MOD_P`**

**Statement.**

```text
Family (25 Nov 2026). In P^8 with coordinates z, p, q (three blocks of three, indices mod 3) let
h_lam(v) = v0^3 + v1^3 + v2^3 + 3 lam v0 v1 v2, M_x(z,p,q) = sum_{i,j} z_{i+j} x_{i-j} p_i q_j, and
    F#(z,p,q) = a h_lam(z) + b h_lam(p) + c h_lam(q) + M_x(z,p,q),    27 (1 + lam^3) a b c + h_lam(x) = 0.
W# = {cubic tenfolds X with a P^8-section projectively equivalent to some F# = 0}. a = 0 forces h_lam(x) = 0 and
gives X n P^8 = h_lam(p) + h_lam(q) + M_x, which contains V = J(Pi, T): that is F_T. Three moduli against two.
Computed, pre-registered (N1-N4; b = c = 1; MOD 32003 and 31991, 3 members and 3 points of F_T; EXACT over QQ at the
member x = (4,3,3), lam = 3 (a = -221/378) and at the point of F_T x = (4,3,3), lam = -59/54):
(N1) Sing(F# = 0) is a surface of degree 18 with Hilbert polynomial 9 n^2, on 9 quadrics. Controls: a -> 2a gives
a smooth cubic sevenfold; a -> 0 with x generic gives only a plane.
(N2) With three random quadrics Phi (the w-derivatives of a tenfold through the section), A = k[z,p,q]/(dF#, Phi)
has Hilbert function (1, 9, 33, 57, 39, 9, 1); the pairing A_3 x A_3 -> A_6 has rank 54.
(N3) The kernel of that pairing is the ideal part plus the four derivatives of F# along the family (a moving with x
and lam). So the tangent space of W# has codimension 54 and equals the first-order Hodge locus of the class
functional supported on the section. Controls (z-cubic coefficient doubled; pure tensor move; h_lam(z) alone) fail.
(N4) At points of F_T the same derivatives lie in the kernel of the pairing of [V] (Hilbert function
(1, 9, 33, 57, 42, 12, 1), rank 54); the combination tangent to the curve h_lam(x) = 0 has no z-cubic; the
transversal one is the extra direction: G_e = M_dx - (grad h_lam(x).dx / (27 (1 + lam^3))) h_lam(z), coefficient
exact (the doubled coefficient fails).
(P4, MOD 32003, one member) The member contains a 4-plane meeting Sing in a curve with Hilbert polynomial 6n - 1
(a genus-2 sextic); h^0 of its normal bundle in the cubic sevenfold is 2. At a point of F_T, Sing = a plane + a
surface of degree 18, and a 4-plane J(Pi, ruling) of V meets Sing in the plane and a twisted cubic.
(EXACT algebra, by hand) For a = b = c the relation becomes the Burkhardt quartic
y0^4 - y0 (y1^3+y2^3+y3^3+y4^3) + 3 y1 y2 y3 y4 = 0 under a = t y0, lam a = -t y1, x = -3t (y2,y3,y4); block
scalings reduce every member to a = b = c. The 3x3 determinant is the member lam -> infinity, x a coordinate point.
```

**Conditions.**

MOD p at the listed instances, EXACT over QQ at one member and one point of F_T; first order only. The identification
of the members with Coble cubics rests on N1, the Burkhardt identity and LIT; irreducibility and smoothness of the
degree-18 surface were not checked. AI-generated, not reviewed by a mathematician. Not a statement about the Hodge
conjecture: if the ARG under not_established holds, the class is algebraic on the family.

**Evidence.**

Scripts in leads/tenfold_coble/ (n1_candidate_family.m2, n1_candidate_family_exact.m2, p4b_theta_planes.m2,
p4c_ft_planes.m2); derivation and discussion in leads/TENFOLD_COBLE_LEAD.md, sections 5-6. The relation was derived
from D-TENFOLD-PRODUCT-POINTS (identity K3) before any of N1-N4 was run.

**Independent check.**

Blind check BC-COBLE (25 Nov 2026; a separate agent given only the definitions and the statements; own Macaulay2
and Python code; it did not see the scripts or the derivation). N1: PASS at 6 instances (2 primes x 3), and more:
the surface is smooth (2 instances), unmixed, with h^0(O) = 1, h^1(O) = 2, h^2(O) = 1 (5 instances); its saturated
ideal is the 9 partial derivatives plus 3 cubics. Controls PASS (at a = 0, x generic, the singular scheme is a
non-reduced structure on the plane). N2, N3: PASS at 8 instances (6 Macaulay2, 2 Python), with the finding that the
four family derivatives lie in the saturated ideal of the singular surface and that the kernel is (that ideal)_3 +
I_3, independent of Phi. N4: PASS at 8 instances. Burkhardt identity: PASS, exact (sympy); the substitution is unique
up to rescaling t. NOT blind-checked: the 4-plane runs (P4), the exact runs over QQ, and the class argument (ARG).
Checker's caveats: modular evidence at a handful of points; primality of the surface ideal only indirectly (isPrime
did not finish); Macaulay2 instances with the same seed at the two primes are correlated (the Python runs are not).

**Not established.**

UPDATE 25 Nov 2026 (evening): the class argument below was replaced by D-TENFOLD-COBLE-CYCLE-CLASS (still ARG, with
computed inputs), and orders 2 and 3 along the explicit arc were tested (D-TENFOLD-COBLE-ARC-ORDERS). Earlier text:
(ARG, not checked) That the continuation of [V] is Hodge on all of W#. Argument: a Coble cubic contains the 4-planes
spanned by the theta curves of the abelian surface A (genus-2 sextics; secant threefold of degree 8 inside a cubic);
Z_Theta = union of the 4-planes over a theta curve is a 5-fold of degree 12; cycle classes from the section have
functionals in the dual of A_6 (one-dimensional), so the cylinder map H^2(A) -> H^10(X) factors through the
polarization for general A; specializing to F_T, [Z_Theta] -> 2 [V]. Then W# is in NL([V]), has the dimension of its
tangent space, and is the codim-54 component W of O-TENFOLD-CONE-LEAD, with (1/2)[Z_Theta] the class. Weak steps:
the specialization of the family of 4-planes to F_T, and that V = Z_sigma there. Also not established: anything
beyond first order at a general member; that W# is the registry's W at the Fermat point (ARG: same closure,
determinant limit); exact arithmetic at more points.

**Known before.**

Coble (1917); Beauville, The Coble hypersurfaces, C. R. Acad. Sci. Paris 337 (2003), Proposition (unique cubic in P^8
singular along the abelian surface; read in the arXiv version math/0306097); Ren, Sam, Schrader, Sturmfels,
arXiv:1303.1132 (Coble cubics parametrized by the Burkhardt quartic; snippet read); Gruson, Sam, arXiv:1301.5276
(Theorem 3.6: the abelian surface as a Fano variety of the Coble cubic; degenerations; only the introduction
machine-read); Gruson, Sam, Weyman, arXiv:1203.2575. We found no source relating Coble cubics to Hodge loci of cubic
tenfolds (search not exhaustive). The lead, the numbers 54 / 55 and the excluded constructions: O-TENFOLD-CONE-LEAD,
N-TENFOLD-CODIM54-SEARCH, N-TENFOLD-CODIM54-SEARCH-2, N-TENFOLD-DIRECT-METHODS, N-TENFOLD-SINGULAR-SECTIONS (whose
next step, sections singular along a non-planar surface, is what this entry does). rStation papers #5 and #11
(u/lelong_ridge, Oct 2026) for the open question of a component of slice dimension > 155.

**Reproduce.**

```text
From leads/tenfold_coble/ (Macaulay2 1.22; 20 s each MOD p, minutes over QQ):
    M2 --script n1_candidate_family.m2 32003 1 coble
    M2 --script n1_candidate_family.m2 32003 1 ft
    M2 --script n1_candidate_family_exact.m2 1 coble
    M2 --script p4b_theta_planes.m2 32003 1
```

**Next step.**

```text
(1) and (2) below were done on 25 Nov 2026 (evening), in a different way for (1): see
D-TENFOLD-COBLE-CYCLE-CLASS and D-TENFOLD-COBLE-ARC-ORDERS. Open: (3), (4), (5). Earlier text:
(1) Replace the class ARG by a computation (intersection count of Z_f with T' in a cubic fourfold section at a point
of F_T: 18 expected; or the cylinder map by residues). (2) Orders 2 and 3 along the explicit arc at a point of F_T
with the so3_t6 machinery. (3) Exact arithmetic at a second member; irreducibility of the surface. (4) Read
Gruson-Sam sections 3-4 and match the boundary types. (5) A one-page note for a mathematician (owner decides).
```

**Session references (files not public).** Session of 25 Nov 2026 (Claude Fable 5.2, chat); leads/TENFOLD_COBLE_LEAD.md.

---

## D-TENFOLD-COBLE-CYCLE-CLASS

**Tenfold lead: the 4-plane cycle on the Coble family has self-intersection -144, so its class is 4 h^5 +- 2 ([V] - 2 h^5); hyperplane sections with 72 nodes and one relation**

kind: `result` | area: `explicit_cycles` | status: **`PAPER_ARGUMENT_AI`**

**Statement.**

```text
Setting: D-TENFOLD-COBLE-FAMILY. X a member (X n P^8 = Y, a Coble cubic singular along the abelian surface A),
Z_Theta = union of the 4-planes P^4_x of Y over a theta curve of A (all through one point a of A), a 5-fold.
Claim (ARG, AI, unreviewed; inputs MOD 32003 and 31991, pre-registered in leads/tenfold_coble/PREREG_step1.md):
Z_Theta.Z_Theta = -144 on X, whereas a multiple of h^5 of the same degree 12 has 48. Hence [Z_Theta] is not a
multiple of h^5; with v_0 = [V] - 2 h^5 (v_0^2 = -48) it is 4 h^5 + c v_0, c^2 = 4: [Z_Theta] = 2 [V] or
8 h^5 - 2 [V] (sign not determined). With D-TENFOLD-COBLE-FAMILY (the first-order Hodge locus of the class on the
section equals the tangent space of the family, codim 54) this gives (ARG): the family is a component of the Hodge
locus of [V], of codimension 54, smooth at its general point, with F_T in its closure, and [V] is algebraic with
rational coefficients on it. That is the component W asked for in O-TENFOLD-CONE-LEAD, explained by a cycle; it is
not a Hodge class not known to be algebraic.
Mechanism (MOD p; reason ARG). A general hyperplane H containing the P^8 is tangent to X at the 72 points
A n {Psi_1 = Psi_2 = 0}; X n H has exactly 72 ordinary double points (Jacobian scheme of degree 72, nothing off the
P^8). The 72 points fail by exactly one to impose independent conditions on quartics (Hilbert function
9, 34, 63, 71, 72), which is Cayley-Bacharach on a surface with K = 0; by Dimca's formula (LIT) H_10(X n H) has one
extra class. The same one level down (36 points, cubics) and two levels down (Y n P^6 has 18 nodes, quadrics). At a
point of F_T: 76 = 4 + 72 nodes, the 4 on the plane independent, the 72 fail by one.
Argument A (ARG + LIT). (1) A 5-cycle in X' = X n H with a non-zero local class at a node is not a rational multiple
of the linear section in H_10(X') (local homology of a node; Lefschetz). (2) Z_Theta has two smooth branches at each
node, in the same ruling, so local class +-2. Checked: two 4-planes of the family through common points of A (the
iota-invariant plane and its images under the index shift) meet in exactly a line, and their spans with the tangent
plane of A are 5-planes in the tangent cone meeting in a P^3. (3) H_10(X') -> H_10(X) is injective because X - X' is
a typical fibre of a polynomial with isolated singularities at infinity, hence a bouquet of 10-spheres
(Siersma-Tibar 1995, Parusinski 1995; LIT, snippets read).
Argument B (ARG; classical intersection theory). Blow-up formula for X smooth of dimension 2m, X' = X n H nodal,
Z, Z' of dimension m in X', X'' = X' n H':
    Z.Z' = (Z n H').(Z' n H') on X''  -  (-1)^(m-1) sum_p n_p(Z) n_p(Z').
Three levels (72, 36, 18 nodes) down to the smooth cubic fourfold Y n P^5 and the surface S = Z n P^5:
Z.Z = S.S - 54 n^2. Test: V at F_T, S = T (T.T = 18, the C_18 scroll), n = 1: 18 - 54 = -36 = [V]^2 of this
registry. Z_Theta: n = 2; S = image of a ruled surface over a genus-2 curve, degree 12, sections of genus 2,
delta double points, S.S = 38 + 2 delta; delta = degree of the projection of A from a point of A = 17 (computed);
S.S = 72, Z.Z = -144. No degree d makes the result d^2/3 when delta = 17.
Explicit cycle (MOD p). For a rational point a of A, Z_a lies in Y n Q_a n {G = 0} (Q_a tangent cone, G quintic).
254 (resp. 236) sampled rational points of Z_a n P^4 have Hilbert function 14, 29, 47, 59, 71, 83, 95 in degrees
2..8 = 12 d - 1 from degree 4: degree 12, arithmetic genus 2, as c_1 = -6 Theta predicts.
```

**Conditions.**

Arguments A and B are paper arguments by an AI; no mathematician has read them. Their computed inputs are MOD p
(two primes, few seeds): 72 / 36 / 18 nodes and the Hilbert functions, the ruling test, the projection degree 17,
the sampled degree 12. Lattice data [V]^2 = -36, h^5.[V] = 6 are this registry's; T.T = 18 is LIT (recalled).
The abelian-surface structure of Sing(Y) rests on D-TENFOLD-COBLE-FAMILY and LIT. Nothing here is EXACT over QQ.
Not a statement about the Hodge conjecture: the class is algebraic if the argument holds.

**Evidence.**

leads/TENFOLD_COBLE_LEAD.md, section 10. Scripts in leads/tenfold_coble/: h1_nodal_section.m2 (nodes, defect),
h2_same_ruling.m2, h3_ft_limit.m2 (at F_T every (5,5) class supported on the section is a multiple of [V]_prim:
Hilbert function (1,9,33,57,42,12,1,0)), h4_ladder_inputs.m2, h5c_cycle_sampling.m2. Pre-registration with the
predictions: PREREG_step1.md. Two decomposition attempts (h5, h5b) did not finish and gave nothing.
Added later the same day: a control on the coefficient +1, D-TENFOLD-PFAFFIAN-K3, where the same ladder
reproduces the known numbers -29, -21 and 49.

**Independent check.**

Blind check BC-COBLE-2 (25 Nov 2026; a separate agent given the definitions and the statements, not the scripts,
logs or notes; its own Macaulay2 and Python code and its unedited report: leads/tenfold_coble/blind_check2/). MOD
32003 and 31991. PASS: 72 reduced nodes and Jacobian degree 72 on P^10, all on the P^8 (4 full runs); Hilbert
function 1, 9, 34, 63, 71, 72 (5 runs), control 36; at F_T 76 = 4 + 72 points, 75 = 4 + 71 on quartics (4 runs);
the two 4-planes meet in a line with two points on A, rank 6, isotropic 5-planes meeting in a P^3, for sigma and
sigma^2 (7 runs); F_T Hilbert function (1,9,33,57,42,12,1,0) (4 runs in M2, 1 independent run in Python); 18 nodes
with 17 on quadrics, 36 points with 35 on cubics, Y n P^5 smooth, projection degree 17 against 18 (4 runs).
Mathematics re-derived by hand: the blow-up formula (signs right for m = 3, 4, 5; tested on a P^m in a smooth cubic
2m-fold with 2^m nodes, where it returns the top Chern class of the normal bundle, m = 2..5); the ladder for V,
whose assumption "local class 0 at the plane nodes" it then checked by computation (the scroll has class
3 sA + 3 sB in the transversal quadric); c_1 = -6 theta by GRR in two ways; the double point arithmetic; argument
A, for whose third step it supplied a shorter justification (all fibre closures are smooth along infinity, Thom's
isotopy lemma, the fibre is 9-connected) that does not need the quoted bouquet theorem.
Its objections (accepted): (1) one statement in the brief was false: the Hilbert function of k[z,p,q]/(dF, Phi) at
a general member is (1,9,33,57,39,9,1,0), not (..,42,12,..); a slip in the brief only (D-TENFOLD-COBLE-FAMILY has
39, 9; nothing here uses those two values). (2) Degree 12 and square -144 are shared by 2[V] and 8 h^5 - 2[V]:
consistency, not identification. (3) That S has exactly 17 transversal double points and no pinch or triple
points, that the scroll maps birationally onto Z, and the passage from the tested pair of planes to a general pair
are inputs with a paper argument only (written into the lead note after its report; unchecked).
Not covered by the blind check: the sampled degree 12 (run after the brief was written); the lattice value
[V]^2 = -36 (taken from this registry).

**Not established.**

A human check of: the blow-up formula (signs, local terms); absence of other singularities of the sections at the
two lower levels (only counted); that S has exactly 17 ordinary double points; the hypotheses of the bouquet theorem;
the Dimca formula as used (not needed for A or B). The sign of c. Exact arithmetic. That the family is the
registry's W at the Fermat point (ARG, as before).

**Known before.**

Benedetti, Manivel, Tanturri, The geometry of the Coble cubic and orbital degeneracy loci, arXiv:1904.10848 (abstract
read): the abelian surface is the Fano variety of P^4's of the Coble cubic and each P^4 cuts it in a theta divisor.
Dimca, Betti numbers of hypersurfaces and defects of linear systems, Duke Math. J. 60 (1990) (degree of the linear
system as quoted in Kloosterman, arXiv:1612.06726, Theorem 2.5). Siersma, Tibar, Singularities at infinity and their
vanishing cycles, Duke Math. J. 80 (1995); Parusinski (1995). Addington, Hassett, Tschinkel, Varilly-Alvarado
(C_18). Nodal hyperplane sections and defect as the source of special classes are classical in dimension 4 (cubic
fourfolds with a 6-nodal hyperplane section and cubic scrolls); we found no source for cubic tenfolds or for Coble
cubics in this role (search not exhaustive).

**Reproduce.**

```text
From leads/tenfold_coble/ (Macaulay2 1.22; seconds each unless noted):
    M2 --script h1_nodal_section.m2 32003 1 coble          (add a 5th argument "full" for the P^10 Jacobian, 3 min)
    M2 --script h1_nodal_section.m2 32003 1 ft
    M2 --script h2_same_ruling.m2 32003 2
    M2 --script h3_ft_limit.m2 32003 1
    M2 --script h4_ladder_inputs.m2 32003 1
    M2 --script h5c_cycle_sampling.m2 32003 1 260           (1.5 min)
```

**Next step.**

A one-page note for a mathematician with arguments A and B (the owner decides whether to send it). If wanted before
that: exact arithmetic for the node counts; the sign of c from the planes of V at a node of an F_T point.

**Session references (files not public).** Session of 25 Nov 2026 (Claude Fable 5.2, chat), second part; leads/TENFOLD_COBLE_LEAD.md section 10.

---

## D-TENFOLD-PFAFFIAN-K3

**Cubic tenfolds, coefficient +1: the Pfaffian locus is 'P^8-section singular along a K3 surface of genus 8' (56 nodes, one relation); the node ladder reproduces the lattice of h^5 + P1 + P2 (a control for D-TENFOLD-COBLE-CYCLE-CLASS)**

kind: `result` | area: `explicit_cycles` | status: **`MOD_P`**

**Statement.**

```text
Not a new family: on tenfolds "X n P^8 is a Pfaffian cubic sevenfold" is the locus of the coefficient lambda_0 = +1
of D-TENFOLD-LAMBDA0-CHECK (codim 38 = 39 - 1; here also 164 - 99 - 27 with 99 = 19 + 80), with the quintic del
Pezzo 5-folds of Kloosterman's construction (D-LAMBDA1-PFAFFIAN-AND-SCROLL, D-PFAFFIAN-LAMBDA1 for sixfolds and
eightfolds). The run was a pre-registered positive control of the mechanism of D-TENFOLD-COBLE-CYCLE-CLASS on a
case whose lattice is known. M = 6x6 skew matrix of random linear forms in 9 variables, Y = {Pf(M) = 0} in P^8.
Computed (MOD 32003 seed 1, 31991 seed 2; leads/tenfold_coble/PREREG_k3.md):
(Q1) Sing(Y) = S = {4x4 Pfaffians = 0}: degree 14, Hilbert polynomial 7n^2 + 2 (a K3 surface of genus 8, LIT);
the saturation of the Jacobian ideal is I_S; the Hessian has rank 6 on all of S.
(Q2) S n {Psi_1 = Psi_2 = 0} is 56 reduced points with Hilbert function 9, 28, 47, 55, 56: one relation on quartics;
a random completion on P^10 has Jacobian scheme of degree 56, all on the P^8 (56 nodes). One level down 28 points,
27 on cubics; Y n P^6 has 14 nodes, 13 on quadrics; Y n P^5 is smooth.
(Q3) k[y]/(Jac, Phi) has Hilbert function (1, 9, 33, 57, 27, 9, 1, 0) (degree 6 one-dimensional, as for the Coble
cubic, whose function is (1, 9, 33, 57, 39, 9, 1, 0)); k[y]/(I_S, Phi) has (1, 9, 27, 38, 27, 9, 1); the pairing on
cubics has rank 38 with kernel (I_S + Phi)_3; dim (I_S)_3 = 100.
(Q4) Z' = five 4x4 Pfaffians of a 5x5 principal block (quintic del Pezzo 5-fold): degree 5. Z = {kernel of M meets
a fixed 3-space}: degree 7, ideal 3 quadrics + 1 cubic. Both contain S; Z u Z' = Y n {Pf_0123 = Pf_0124 = 0}, a
complete intersection of degree 12. (The 3x3 minors of the 6x3 block define Z only as a set.)
(Q5) At a rational point of S all of Z, Z_2, Z', Z'_2 are smooth, their tangent 5-spaces contain T_pS and are
isotropic for the Hessian; Z and Z_2 lie in one ruling, Z' and Z'_2 in the other.
(Q6) On the smooth cubic fourfold Y n P^5 (lengths of proper intersections): D.D_2 = 13, sigma.sigma_2 = 21,
sigma.D = 7 (sigma = Z n P^5, D = Z' n P^5).
Consequences. (a) Degrees 5 and 7 are not divisible by 3 and h^5 is not divisible in H^10(X, Z), so neither class
is a rational multiple of h^5. (b) (ARG, arithmetic) The ladder of D-TENFOLD-COBLE-CYCLE-CLASS with node counts
14, 28, 56 and local classes +1 (Z), -1 (Z') gives Z'.Z' = 13 - 14 + 28 - 56 = -29, Z.Z = 21 - 42 = -21,
Z.Z' = 7 + 42 = 49; D-INTERSECTION-NUMBERS (P.P = -21, P1.P2 = 3 for 5-planes meeting in a plane) gives the same
three numbers for h^5 + P1 + P2 and 3h^5 - P1 - P2. This is the second known lattice the ladder reproduces (the
first: [V]^2 = -36), now with both rulings and a mixed product. (c) Parallel on tenfolds: coefficient +1: Pfaffian
cubic, K3 of degree 14, 56 nodes, codim 38; coefficient -1: Coble cubic, abelian surface of degree 18, 72 nodes,
codim 54. In both the singular surface has K = 0, which is what gives the one relation among the nodes; 14 and 18
are the discriminants of D-CONE-DICTIONARY for (1,1) and (1,-1).
```

**Conditions.**

MOD p, two instances. The family and its del Pezzo cycles are not new (see known_before). The ladder and the
local-class reading are paper arguments by an AI (as in D-TENFOLD-COBLE-CYCLE-CLASS), unreviewed. That Z has class
3h^5 - P1 - P2 and Z' has class h^5 + P1 + P2 is taken from the registry and Z + Z' = 4h^5; not re-derived here.
Nothing is EXACT over QQ. Not a statement about the Hodge conjecture: both classes are algebraic.

**Evidence.**

leads/tenfold_coble/pf1_section.m2, pf2_cycles.m2, PREREG_k3.md, logs in logs_k3/; leads/TENFOLD_COBLE_LEAD.md
section 11.

**Independent check.**

Blind check BC-PFAFF (25 Nov 2026; a separate agent given the definitions and the statements only; its own
Macaulay2 code and unedited report: leads/tenfold_coble/blind_check3/). MOD 32003 and 31991, 2 to 4 runs per item.
PASS on all of Q1-Q6: the K3 surface and the Jacobian saturation, Hessian rank exactly 6 on S (and S smooth); 56
reduced points with Hilbert function 9, 28, 47, 55, 56; 28 and 14 one and two levels down; Jacobian degree 56 on
P^10, all on the P^8; both Hilbert functions and the pairing of rank 38 with kernel (I_S + Phi)_3; the two 5-folds
(degrees 5 and 7, generators, the complete intersection, the non-reduced minors scheme; it also found the explicit
generators of I_Z); the rulings at 9 rational points of S; the lengths 13, 21, 7, 7, with all four 5-folds
arithmetically Cohen-Macaulay, so the lengths are intersection numbers. By hand: h^5 indivisible; P.P = -21 and
P1.P2 = 3 from Chern classes; the ladder formula re-derived again, with -29, -21, 49 on both sides.
Its caveats (accepted): (1) Z and Z_2 are singular along a curve of degree 6 that meets S in 9 points, so "smooth
at p" holds away from those; for random Psi the 56 nodes avoid them (computed), but for special Psi the formula
would need the local class of a singular Z. (2) The local classes were computed at rational points of S and extend
to the nodes by continuity (S smooth and connected); the self-intersections are computed as Z.Z_2 and Z'.Z'_2,
which uses that the two members of each family are homologous (connected families); not computed. (3) Equal
numbers show equal Gram matrices, they do not by themselves identify the classes. (4) A smooth tenfold with the
56-nodal hyperplane section was not constructed (Bertini). (5) Everything is MOD p.

**Not established.**

That K3 (genus 8) and abelian (3,3) are the only surfaces with K = 0 in P^8 that are the singular locus of a cubic
sevenfold with rank-6 Hessian (not examined). A human reading of the ladder. Exact arithmetic.

**Known before.**

Kloosterman, arXiv:2312.12363 (Prop. 6.4, Cor. 6.5; machine-read earlier, tests/SOURCES.md): cones over G(2,5) and
the coefficient +1. Beauville-Donagi (Pfaffian cubic fourfolds; D.D = 13, recalled). Mukai (K3 surfaces of genus 8
are linear sections of G(2,6); recalled). The Pfaffian cubic is singular along the rank-2 forms (classical;
recalled). This registry: D-TENFOLD-LAMBDA0-CHECK, D-LAMBDA1-PFAFFIAN-AND-SCROLL, D-PFAFFIAN-LAMBDA1,
D-INTERSECTION-NUMBERS, D-CONE-DICTIONARY. Whether the K3 / 56-node description of the +1 locus on tenfolds, or the
K3 / abelian parallel, is in the literature was not checked (O-LITERATURE-CHECK-DET-PFAFF applies).

**Reproduce.**

```text
From leads/tenfold_coble/ (Macaulay2 1.22):
    M2 --script pf1_section.m2 32003 1            (7 min; add a third argument "full" for the P^10 Jacobian, +3 min)
    M2 --script pf2_cycles.m2 32003 1             (5 s)
```

**Next step.**

For a mathematician: classify surfaces with K = 0 in P^8 that are singular loci of cubic sevenfolds with nodes
transversally; each would give a component of a Hodge locus of cubic tenfolds by the same mechanism. For the main
target the mechanism matters only where no cycle through the nodes is visible; both cases here have one.

**Session references (files not public).** Session of 25 Nov 2026 (Claude Fable 5.2, chat), third part.

---

## D-TENFOLD-COBLE-EXACT-MEMBER

**A named smooth cubic tenfold over QQ in the Coble family: its hyperplane section has exactly 72 nodes with exactly one relation (certificate over QQ); first-order Hodge locus of codimension 54**

kind: `result` | area: `explicit_cycles` | status: **`PROVED_AI_UNREVIEWED`**

**Statement.**

```text
The member. Variables z, p, q (three each; y for all nine) and w_0, w_1, w_2; h(a,b,c) = a^3 + b^3 + c^3 + 9abc;
M = sum_{i,j} x_{(i-j) mod 3} z_{(i+j) mod 3} p_i q_j with x = (4,3,3) (lam = 3, a = -221/378 in D-TENFOLD-COBLE-FAMILY):
    F8   = -221 h(z) + 378 h(p) + 378 h(q) + 378 M
    Phi0 = 2 z_0 p_0 + z_1 p_1 + 2 z_0 p_2 - p_2^2 - 2 p_0^2 - 2 z_1 z_2
    Phi1 = -p_1 p_2 - 2 q_0 q_2 - 2 q_0^2 + 2 z_1 p_1 - p_1 q_0 - 2 q_1^2
    Phi2 = 2 z_1 q_2 - 2 p_0 q_0 + p_2 q_1 + z_0 p_1 - p_1 q_2 + 2 p_2^2
    F    = F8 + w_0 Phi0 + w_1 Phi1 + w_2 Phi2 + w_0^3 + w_1^3 + w_2^3,      X = {F = 0} in P^11.
The quadrics come from a fixed rule (leads/tenfold_coble/exact_member/make_member.py, candidate 1, first w-part; no
candidate was rejected). X' = X n {w_2 = 0}; Sigma = {dF8 = 0, Phi0 = Phi1 = 0} in the P^8 = {w = 0}.
Certificate (pre-registered, exact_member/PREREG_exact.md):
(X1) X is smooth. MOD 32003, 31991, 30011: the Jacobian ideal has no projective zero (Hilbert function of the
quotient binomial(12,d), 0 in degree 13; also after a random change of coordinates). Over QQ by specialization.
(X2) Sigma is 72 distinct points. EXACT over QQ: dimension 0, degree 72, squarefree projection of degree 72.
(X3) Sing(X') = Sigma, all ordinary double points. MOD the three primes: the Jacobian scheme of F|_{w_2=0} in P^10
has dimension 0 and length 72, all on the P^8. Over QQ by specialization (length <= 72) together with (X2).
(X4) The 72 points impose exactly 71 conditions on quartics. EXACT over QQ: the saturated ideal of Sigma has
Hilbert function 1, 9, 34, 63, 71, 72, 72 (also from the colon ideal by the irrelevant ideal).
(X5) Phi2 has no zero on Sigma. EXACT over QQ.
Also EXACT over QQ at this member: the singular surface of X n P^8 has degree 18, Hilbert polynomial 9n^2, ideal
9 quadrics + 3 cubics; k[y]/(dF8, Phi0, Phi1, Phi2) has Hilbert function (1, 9, 33, 57, 39, 9, 1, 0) and the pairing
on cubics has rank 54 (codimension of the first-order Hodge locus of the class at X).
Consequence (ARG + LIT, not computed): X' is a nodal cubic 9-fold with 72 nodes and defect 1, so b_10(X') = 2
(Dimca's formula); the extra class is of type (5,5) and H_10(X') -> H_10(X) is injective (D-TENFOLD-COBLE-CYCLE-CLASS,
argument A, step 3). Hence this smooth cubic tenfold with rational coefficients carries a rational Hodge class that
is not a multiple of h^5. By D-TENFOLD-COBLE-CYCLE-CLASS the class is algebraic (ARG).
```

**Conditions.**

```text
(X2), (X4), (X5), the surface and the rank 54 are computed directly over QQ (Macaulay2). (X1) and (X3) are computed
modulo three primes and transferred to QQ by standard specialization arguments written out in PREREG_exact.md
(empty special fibre; upper semicontinuity of the length of a finite scheme over Z_(p)); those arguments are by an
AI and unreviewed. The modular Groebner bases for (X1) and (X3) use Macaulay2's F4 engine; (X3) was also run with
the default engine at one prime. The consequence about the Hodge class rests on cited theorems that were not
re-read and on an argument that no mathematician has read. Not a statement about the Hodge conjecture; the class
is algebraic if D-TENFOLD-COBLE-CYCLE-CLASS holds.
```

**Evidence.**

leads/tenfold_coble/exact_member/ (member.m2, make_member.py, cert_QQ.m2, cert_modp.m2, PREREG_exact.md, logs/);
leads/TENFOLD_COBLE_LEAD.md section 12.

**Independent check.**

Blind check BC-EXACT (25 Nov 2026; a separate agent given the equation and the statements only; its own Macaulay2
and Python code and unedited report: leads/tenfold_coble/blind_check4/, without its 2.6 MB file of two 72x72
rational matrices). All six computed items PASS with the same numbers. Over QQ: Sigma (dimension 0, degree 72;
squarefree by an independent route, the characteristic polynomial of a 72x72 rational multiplication matrix in
python-flint; it also found that the degree-72 form is irreducible over QQ, so the 72 nodes are one Galois orbit and
none is rational); the Hilbert functions 1, 9, 34, 63, 71, 72, 72 (saturation, colon ideal) and
1, 9, 34, 66, 73, 72, 72; Phi2 without zero on Sigma; the surface (degree 18, 9n^2, 9 quadrics + 3 cubics); the
Hilbert function (1, 9, 33, 57, 39, 9, 1, 0) and rank 54 (exact multiplication matrices; also rank 54 mod two
primes by the direct Gram matrix). Mod 32003, 31991, 30011: X smooth (F4; a second F4-type engine, Macaulay2's
LinearAlgebra algorithm, at one prime; a random change of coordinates) and the Jacobian scheme of X' of dimension
0 and degree 72 (F4; mathicgb's classic engine at one prime; a random change of coordinates). The default
Buchberger engine did not finish for it either (time-outs, not disagreements). It accepted both specialization
arguments, noting that one prime suffices and that (X5) is the same statement as smoothness of X at the nodes.
Its review of the consequence: sound, with two steps of the injectivity argument that were not written out and
are now (the product structure near infinity where f_2 != 0; isolated affine critical points, which it confirmed:
2048 - 72 = 1976 at one prime, no critical point on f = 0), and a cleaner reference that gives the vanishing of
H^9(X - X') directly: Dimca-Paunescu, On the connectivity of complex affine hypersurfaces II, arXiv:math/9906064
(the theorem as it states it; the paper's existence and abstract were confirmed by search, the theorem was not
read here). It asks for the exact statement number in Dimca's 1990 paper, which is still to be supplied.
Not checked by it and not claimed: smoothness or irreducibility of the singular surface at this member;
algebraicity of the class.

**Not established.**

A human reading of the specialization arguments and of the consequence. (X1) and (X3) by a direct computation over
QQ (the 11-variable one was stopped after 17 minutes). That this X is off F_T and off the cone loci is clear from
its singular surface (a smooth surface of degree 18, not a plane plus a scroll) but was not made a separate item.

**Known before.**

Dimca, Duke Math. J. 60 (1990); Siersma-Tibar, Duke Math. J. 80 (1995); Thomas, Nodes and the Hodge conjecture,
arXiv:math/0212216 (the Hodge conjecture restated through nodal hyperplane sections; snippet read): none re-read
in full. The method note of O-EXACT-VERSIONS-OF-MOD-P-RANKS (rank over QQ is at least the rank mod p) is the same
specialization idea.

**Reproduce.**

```text
From leads/tenfold_coble/exact_member/ (Macaulay2 1.22):
    M2 --script cert_QQ.m2                 (7 min)
    M2 --script cert_modp.m2 32003         (15 s; also 31991, 30011; a second argument gives a random change of coordinates)
```

**Next step.**

DONE 26 Nov 2026, differently: C-TENFOLD-FERMAT-POINT-CLASS (the arc carries the three-plane class, not Movasati's),
D-TENFOLD-FERMAT-THREE-PLANE-FAMILY, D-TENFOLD-COBLE-FERMAT-ARCS.

**Session references (files not public).** Session of 25 Nov 2026 (Claude Fable 5.2, chat), fourth part.

---

## D-TENFOLD-COBLE-PLANE-COUNT

**Tenfold lead: the 4-plane cycle meets a 5-plane transversally in 8 points, where a multiple of h^5 would give 4; its class is not a multiple of h^5 by a count (MOD p), without the node argument or the ladder**

kind: `result` | area: `explicit_cycles` | status: **`MOD_P`**

**Statement.**

```text
Setting: D-TENFOLD-COBLE-FAMILY. Y a Coble cubic in P^8 (normal form, random lam and x), A = Sing(Y), a a point of
A, Z_a the union of the 4-planes of Y through a (the cycle of D-TENFOLD-COBLE-CYCLE-CLASS; dimension 5, degree 12).
P' another 4-plane of Y, not through a; pi a plane in P'; X = F_Y + sum_k w_k Phi_k with Phi_k in
(ideal of pi)(linear forms), a cubic tenfold with X n {w = 0} = Y containing the 5-plane Lambda = {y in pi, w free}.
Then Lambda n Z_a = pi n Z_a. If [Z_a] = c h^5, then c = 12/3 = 4 and Lambda . Z_a = 4.
Pre-registered (leads/tenfold_coble/plane_test/PREREG_plane.md) with the prediction N = 8: P' n P'' is a secant line
of the theta curve A n P', so P' n Z_a is a ruled surface of secants of degree 6 * 2 - 8/2 = 8 (ARG).
Result (MOD 32003 and 31991, seeds 1 and 2, P' = the explicit 4-plane through the odd eigenspace of iota and P' = a
4-plane through a second random point of A: 8 runs, the same in all):
  - {Q_a = G = 0} in P' is a surface of degree 10; its section by a random P^3 of P' is a curve of degree 8
    (arithmetic genus 8) and two lines, all of multiplicity 1;
  - the curve of degree 8 lies in Z_a and the two lines do not (membership test at smooth points of Y n Q_a n G: the
    fibre of the pencil through the point is a 4-plane of Y through a, or it is not; over GF(p^2) where the lines
    are conjugate);
  - for an explicit plane pi in that P^3: pi n Z_a is 8 reduced points; at all 8 (ideal computation) Y n Q_a n G is
    smooth and the tangent space of Z_a meets pi only in the point; the 2 points of pi on the lines are not on Z_a;
  - X is smooth and contains Lambda.
So Lambda . Z_a = 8 and [Z_a] is not a multiple of h^5 on X. Z_a is the same subvariety in every tenfold with that
P^8-section; the smooth ones form a connected family; so the same holds on all of them (ARG, elementary).
Consistent with D-TENFOLD-COBLE-CYCLE-CLASS: [Z_a] = 4 h^5 + c v_0 with c = +-2 forces Lambda . Z_a - 4 to be even.
Also recorded (ARG, not tested): for a P^(10-s)-section of a cubic tenfold singular along a smooth S of dimension s,
the nodes of a general hyperplane through it have defect h^0(K_S + (2s - 4) h) (Cayley-Bacharach); for a surface
this is p_g(S), and then the secant variety of S is a 5-dimensional cycle inside the tenfold. So a search for new
classes with tooling/node_section would list loci that come with a visible cycle.
```

**Conditions.**

MOD p, 8 runs. The passage to characteristic 0 is an argument (Hensel lifting of a and P'; intersection numbers
are constant in flat families), not written out in detail and not replaced by an exact computation. The degree 12
of Z_a is from D-TENFOLD-COBLE-CYCLE-CLASS (Chern class count; sampled at two primes) and was recomputed by the
blind check in three ways; only "not 24" is needed. On X itself the statement is weak (Lambda is already not a
multiple of h^5); the content is for the members of the family without a 5-plane, by the deformation step. The conclusion uses the textbook fact that a transversal intersection of subvarieties of complementary
dimension in a smooth projective variety computes the intersection number of their classes. Not a statement
about the Hodge conjecture: this makes the class algebraic and non-trivial, so the lead is explained, not a
"Hodge class not known to be algebraic".

**Evidence.**

leads/tenfold_coble/plane_test/ (PREREG_plane.md, pl1_count.m2, run_all.sh, logs/); leads/TENFOLD_COBLE_LEAD.md
section 14.

**Independent check.**

Blind check BC-PLANE (26 Nov 2026; a separate agent given the statement and the definitions only, no code and no
repository; its own Macaulay2 and Python code and unedited report: leads/tenfold_coble/blind_check6/). MOD p at
4 primes (32003, 30011, 20011, 10007), 6 instances, 5 different cubics.
AGREES on every item: deg Z_a = 12 (three ways: 110 sampled 4-planes through a per instance cut by a P^5, a curve
of degree 12 and arithmetic genus 2; a direct count of the 4-planes through a meeting a random P^3; its own class
computation on A x A); N = 8 for all 24 planes pi tried, decided two ways (incidence scheme of dimension 0, degree
8, reduced; and, for every root including the conjugate ones over F_(p^k), the 4-plane through a and the point
constructed and verified to lie in Y); transversality at all 192 points; P' n P'' is a line through the two common
points of the two sextics in every pair tested; the identities for X; X smooth for 16 random X, and for one
explicit X over QQ (EXACT, lam = 2, x = (1,2,5), from two reductions).
It adds: the 4-planes through a form a geometrically irreducible double cover of the line of tangent directions
with 6 branch points (genus 2), so Z_a is irreducible; Z_a is double along the cone over A with vertex a, which pi
misses; a class in the span of h^5 and Lambda with these two pairings would have self-intersection 189/4, so
[Z_a] is not in that span either.
Its caveats (accepted): (1) everything is MOD p while classes and connectedness are used over C; (2) charts are
random, not a covering, so a point outside a chart would be missed with probability about 1/p; (3) only sampled
a and pi: what a proof needs is one fully certified triple (a, pi, X) in characteristic 0; (4) the degree needs a
proof, and the argument is insensitive to it (it would also "conclude" from a wrong degree other than 24); (5) on
X itself the statement is weak, because Lambda is already not a multiple of h^5; the content is for the tenfolds of
the family that contain no 5-plane, reached by the deformation step; (6) special parameters must be avoided.
Its pitfall: in a fully generic Grassmannian chart the count of 4-planes through a returns 14, with two spurious
points where the spanning vectors are dependent; saturating by the 5 x 5 minors gives 12.
Its finding on special parameters (EXACT over QQ, a scan of 1220 parameter points): Sing(Y) has degree 18 + 3k when
[x] lies on k flex tangents of the Hesse cubic h_lam = 0 (the rational ones: x_i + x_j = lam x_k).
Suggested route to characteristic 0: Hensel lifting of a (the Hessian has rank 6), then specialisation: the
characteristic-0 cycle specialises to m [Z_a mod p], so degree and intersection number become 12 m and 8 m and the
ratio 2/3 survives; or a computation over a number field containing a point of A.

**Not established.**

An exact (characteristic 0) run: it needs a point of A over a number field. One attempt at a rational member
(lam = 3, x = (4,3,5)) was dropped: that member is special (x_0 + x_2 = lam x_1; its singular locus has degree 21,
see the blind check's scan). A human reading. Whether the secant variety of A carries the same class.

**Known before.**

Intersection numbers of cycles with linear subspaces are the standard way to tell a class from a multiple of the
linear section class. Benedetti-Manivel-Tanturri (arXiv:1904.10848) for the 4-planes of the Coble cubic (abstract
read). Not searched further.

**Reproduce.**

```text
From leads/tenfold_coble/plane_test/ (Macaulay2 1.22):
    M2 --script pl1_count.m2 32003 1 B        (about 15 s; also 31991, seed 2, mode G)
    ./run_all.sh                              (all 8 runs)
```

**Next step.** An exact version over a number field at one rational Coble cubic, if a stronger label is wanted.

**Session references (files not public).** Session of 25-26 Nov 2026 (Claude Fable 5.2, chat), sixth part.
