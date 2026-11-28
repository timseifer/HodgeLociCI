# Movasati's Conjecture 1 and higher-order expansions at Fermat points

- Exact certificates at both Movasati points (lambda = -1, 2, 5/3) show, conditionally, that the full germ of the Hodge locus has no component of dimension dim V + 1 there; this is AI-computed and conditional, and must not be presented as a refutation of a published conjecture.
- Structure of the germ: V doubled plus one component W_lambda on sixfolds; bounds on eightfolds; at the pair X1 the coefficient -1 is special, with an explicit obstruction formula and a rank invariant separating -1, 1 and the other coefficients.
- Identifications of components with explicit families are paper arguments by AI agents, each read once.

> **Status of everything on this page:** produced by AI agents, checked only by other AI agents, reviewed by no human. Sources of published results were read by machine (see `tests/SOURCES.md`). The notes cited as "unreviewed note 1, 2, 3" are AI-written and unreviewed (in papers/). Nothing here is, or bears on, a proof or disproof of the Hodge conjecture. This is a registry of what was found, ruled out or left open, not a list of established theorems.

Generated from `discoveries/registry.yaml` by `discoveries/check_registry.py --write-pages`. Do not edit this page by hand: edit the registry. Notation: [`NOTATION.md`](NOTATION.md). Status vocabulary: [`README.md`](README.md).

## Entries on this page (31)

| id | status | title |
|---|---|---|
| [D-MOVASATI-CERTIFICATES](#d-movasati-certificates) | `EXACT` | Exact certificates at both Movasati points: no component of dimension dim V + 1 for lambda = -1, 2, 5/3 |
| [D-CONJ1-DIMENSION-NOTE1](#d-conj1-dimension-note1) | `PROVED_AI_UNREVIEWED` | Dimension statement of Conjecture 1 as argued in the unreviewed note 1: holds iff the coefficients are equal |
| [D-MOVASATI-SLICE-COMPATIBLE](#d-movasati-slice-compatible) | `MOD_P` | No conflict with Movasati's computer theorem: on his transversal slice no obstruction was found |
| [D-SIXFOLD-GERM-AT-MOVASATI-POINT](#d-sixfold-germ-at-movasati-point) | `MOD_P` | Sixfold Movasati point: the germ is V doubled plus one irreducible reduced component W_lambda |
| [D-EIGHTFOLD-BOUNDS-AT-MOVASATI-POINT](#d-eightfold-bounds-at-movasati-point) | `MOD_P` | Eightfold Movasati point: a second component exists but has dimension at most dim V - 6 |
| [D-EIGHTFOLD-INCIDENCE-TYPES](#d-eightfold-incidence-types) | `MOD_P` | The nine incidence types of pairs of 4-planes meeting in a line on the Fermat cubic eightfold |
| [D-X1-ORDER5-FORMULA](#d-x1-order5-formula) | `EXACT` | At the pair X1 the order-5 obstruction is (8/9)(1+z)(lambda-1)(lambda+1)^2/lambda^3: -1 is special |
| [D-PAIR-TYPE-TABLE](#d-pair-type-table) | `MOD_P` | Table 'pair type x lambda': dimension of the second component on Fermat eightfold line pairs |
| [D-GLOBAL-ARGUMENT](#d-global-argument) | `PAPER_ARGUMENT_AI` | Global argument: bounds and components at X1 transfer to the eightfold Movasati point |
| [D-X1-COMPONENT-IS-TD-CLOSURE](#d-x1-component-is-td-closure) | `PAPER_ARGUMENT_AI` | For lambda = -1 the second component at X1 is the germ of the closure of the family l*Q + det A + det B |
| [D-RANK-INVARIANT](#d-rank-invariant) | `MOD_P` | Rank invariant on the sixfold underneath: 18 for lambda = -1, 12 plus a linear form for 1, 28 for the others |
| [D-RANK-CONTRAST-EXACT-ARCS](#d-rank-contrast-exact-arcs) | `EXACT` | Rank contrast on two exported exact arcs: 18 for lambda = -1, at least 27 for lambda = 2, modulo eps^10 |
| [D-LAMBDA2-CONE-TYPE](#d-lambda2-cone-type) | `PAPER_ARGUMENT_AI` | For lambda = 2 the component through X1 containing the cone-type family is that family (dim V - 16) |
| [D-TANGENT-OF-W-TURNS](#d-tangent-of-w-turns) | `EXACT` | At a Fermat point of the divisor D the tangent hyperplane of W_lambda turns linearly with lambda |
| [D-FERMAT-RATIONAL-PAIRS-ORDER2](#d-fermat-rational-pairs-order2) | `EXACT` | Rational Fermat pairs: the order-2 form vanishes exactly at lambda_0 = (-1)^(c-1), no other special value |
| [D-FERMAT-LINEAR-CYCLES-SPAN](#d-fermat-linear-cycles-span) | `EXACT` | Fermat varieties: for which (dimension, degree) the linear cycles span all Hodge classes (night-run counts) |
| [D-TENFOLD-PRODUCT-POINTS](#d-tenfold-product-points) | `PAPER_ARGUMENT_AI` | Tenfold lead: exact structure at product points C(w,z) + c_1(p) + c_2(q); the cubic model is a determinant; two period identities on the rank-one locus |
| [D-TENFOLD-FERMAT-THREE-PLANE-FAMILY](#d-tenfold-fermat-three-plane-family) | `PROVED_AI_UNREVIEWED` | A 3-parameter family of cubic tenfolds through the Fermat tenfold (Fermat plus a Heisenberg trilinear term): it lies in the Coble family, and the three-plane class stays Hodge on it (AI proof, unreviewed) |
| [D-TENFOLD-COBLE-FERMAT-ARCS](#d-tenfold-coble-fermat-arcs) | `MOD_P` | Explicit arcs of the Coble family through the Fermat tenfold, with no symmetry and no free terms: the three-plane class satisfies all period equations to orders 10-12 (MOD p); every change to the Coble relation fails at the predicted order |
| [D-TENFOLD-CONE-POINTS-TWO-DET](#d-tenfold-cone-points-two-det) | `PAPER_ARGUMENT_AI` | Tenfold two-determinant family and V_Z: at cone points over the sixfold divisor D its class is +-([P1] - [P2]), conditional on the sixfold identification (cone map applied twice); exact cone arc to order 9; no smooth honest member carries a two-plane class |
| [D-TENFOLD-ORDER4-MODEL-CONE](#d-tenfold-order4-model-cone) | `MOD_P` | Tenfold Movasati point: special nets of rank 2 (a 13-dimensional piece) and of rank 3 pass order 4; a model cone of 27 quadrics; the order-5 obstruction on the 13-dimensional piece is removable for lambda = -1 and 2 |
| [D-TENFOLD-MOVASATI-ORDER6](#d-tenfold-movasati-order6) | `MOD_P` | Tenfold Movasati point, a direction of the 13-dimensional piece: order 6 passes for lambda = -1 (by a change of T_3) and is obstructed for lambda = 2 modulo the first-order corrections tested |
| [D-SIXFOLD-ARC-ORDER19](#d-sixfold-arc-order19) | `EXACT` | The sixfold arc of T2 into the divisor D, exactly to order 19: T_8..T_19 are determined uniquely; the certificate's T_8, T_9 are not on the continuing arc |
| [D-MOVASATI-POINT-ARC-ORDER8](#d-movasati-point-arc-order8) | `MOD_P` | Movasati's own point, a direction that is not a cone over a sixfold: [P1] - [P2] stays Hodge to order 9 along an arc (eightfold; the tenfold by the cone map); with the same first-order term lambda = 2 is obstructed at order 6 |
| [D-MOVASATI-POINT-EXACT-SEPARATION](#d-movasati-point-exact-separation) | `EXACT` | Movasati's own point in characteristic 0: on one direction in general position lambda = -1 passes order 7 and lambda = 2 is obstructed at order 6 in the slice, exactly; on coordinate-aligned directions lambda = 2 is not obstructed at order 6 (MOD p) |
| [D-ALIGNED-POCKET-LAMBDA2](#d-aligned-pocket-lambda2) | `MOD_P` | Movasati's point, lambda = 2 on coordinate-aligned directions: net s passes order 7 in the full space (two primes), net f is obstructed at order 7 |
| [D-ALIGNED-POCKET-ORDER8](#d-aligned-pocket-order8) | `MOD_P` | Movasati's point, lambda = 2 on the symmetric aligned direction: jets through order 8 exist (two primes), at the price of 2 conditions per order from order 7 on; for lambda = -1 the corresponding condition vanishes |
| [D-MOVASATI-POINT-COEFFICIENT-SCAN](#d-movasati-point-coefficient-scan) | `MOD_P` | Movasati's point, a direction in general position: among ten coefficients only -1 and +1 pass order 6; they are exactly the two whose lattice half-discriminant (28, 36 on eightfolds) is that of a K3 or an abelian surface |
| [D-POCKET-ORDER9-OBSTRUCTION-SIGNAL](#d-pocket-order9-obstruction-signal) | `MOD_P` | The lambda = 2 pocket at order 9: at the tested order-8 jet no first-order move inside V8 removes the order-9 conditions (MOD p, two primes, one jet); this does NOT by itself signal an obstruction (corrected reading) |
| [D-POCKET-ORDER9-PASSED](#d-pocket-order9-passed) | `MOD_P` | The lambda = 2 pocket passes order 9: a 9-jet with the pocket's tangent exists (MOD p, one prime), found by a non-linear search; order 10 again needs one |
| [D-POCKET-ORDER10-PARTIAL](#d-pocket-order10-partial) | `MOD_P` | Order 10 of the lambda = 2 pocket: structure at the 9-jet, and no order-10 zero in a 4-dimensional family (MOD p) -- inconclusive, the family is too small |

## Related entries on other pages

| id | kind | status | page | title |
|---|---|---|---|---|
| [N-JOIN-HYPOTHESIS](06_ruled_out_and_dead_ends.md#n-join-hypothesis) | negative | `RULED_OUT` | 06 | The lambda = -1 component at X1 is not a join locus built from the special coefficient of the sixfold sub-pair |
| [N-BRIDGE-PLANES](06_ruled_out_and_dead_ends.md#n-bridge-planes) | negative | `RULED_OUT` | 06 | 'Bridge planes' do not explain lambda = -1 at X1: the two c = 2 loci meet only inside V |
| [N-OTHER-SPECIAL-COEFFICIENTS-AT-X1](06_ruled_out_and_dead_ends.md#n-other-special-coefficients-at-x1) | negative | `RULED_OUT` | 06 | No special coefficient other than 1 and -1 at X1: the order-5 obstruction has no further zero |
| [N-EIGHTFOLD-DIM-MINUS-6-ALL-LAMBDA](06_ruled_out_and_dead_ends.md#n-eightfold-dim-minus-6-all-lambda) | negative | `RULED_OUT` | 06 | 'The eightfold second component has dimension exactly dim V - 6 for every lambda not in {0,1}' is false for lambda != -1 |
| [N-T3-ARC-BEYOND-ORDER-7](06_ruled_out_and_dead_ends.md#n-t3-arc-beyond-order-7) | negative | `RULED_OUT` | 06 | The exported arc six_lam-1_arc.txt is a truncation of a true arc only modulo eps^8 |
| [O-OTHER-COMPONENTS-AT-X1](07_open_problems.md#o-other-components-at-x1) | open | `OPEN` | 07 | Eightfolds: exact dimension of the second component for lambda != +-1, and the pair types not computed |
| [O-EXPONENT-OF-LAMBDA-PLUS-1](07_open_problems.md#o-exponent-of-lambda-plus-1) | open | `OPEN` | 07 | Why is the exponent of (lambda + 1) in the order-5 obstruction at X1 equal to 2? |
| [C-AVERAGING-ARGUMENT](08_corrections_and_lessons.md#c-averaging-argument) | correction | `EXACT` | 08 | T3's symmetry-averaging reduction at X1 was wrong; the result was re-established by a direct exact computation |
| [C-EIGHTFOLD-CHAIN-STEP4](08_corrections_and_lessons.md#c-eightfold-chain-step4) | correction | `PAPER_ARGUMENT_AI` | 08 | T3's chain for the eightfold had a gap at step 4; closed modulo primes with the explicit family l*Q + det A + det B |
| [C-RANK-28-MISREADING](08_corrections_and_lessons.md#c-rank-28-misreading) | correction | `MOD_P` | 08 | '8 quadrics annihilate the class' for lambda = 2 was a misreading: they are the partial derivatives; 28 is the maximal rank |
| [N-T5-CYCLE-SEARCH-CUBIC-SIXFOLDS](06_ruled_out_and_dead_ends.md#n-t5-cycle-search-cubic-sixfolds) | negative | `RULED_OUT` | 06 | Search for algebraic cycles of the lambda = 2, -2 two-plane classes and the triangle classes on cubic sixfolds: none found (closed) |
| [N-TENFOLD-CODIM54-SEARCH](06_ruled_out_and_dead_ends.md#n-tenfold-codim54-search) | negative | `RULED_OUT` | 06 | Tenfold lead: search for a codim-54 family containing the C_18 family F_T (six named construction types, none explains it) |
| [N-TENFOLD-CODIM54-SEARCH-2](06_ruled_out_and_dead_ends.md#n-tenfold-codim54-search-2) | negative | `RULED_OUT` | 06 | Tenfold lead: second search for a codim-54 family containing F_T (Thom-Sebastiani cycles, more degenerations, scrolls, unions, del Pezzo-guided): none explains it |
| [N-TENFOLD-DIRECT-METHODS](06_ruled_out_and_dead_ends.md#n-tenfold-direct-methods) | negative | `RULED_OUT` | 06 | Tenfold lead: direct methods (periods to equations along the arc; search by invariants) find no explaining cycle |
| [N-TENFOLD-SINGULAR-SECTIONS](06_ruled_out_and_dead_ends.md#n-tenfold-singular-sections) | negative | `RULED_OUT` | 06 | Tenfold lead: loci where a P^8-section is singular along a plane do not explain the extra direction |
| [N-TENFOLD-THIRD-DETERMINANT](06_ruled_out_and_dead_ends.md#n-tenfold-third-determinant) | negative | `RULED_OUT` | 06 | Tenfold lead: the extra direction is not 'add the third determinant e_0(z) of the tensor' |
| [C-TENFOLD-FERMAT-POINT-CLASS](08_corrections_and_lessons.md#c-tenfold-fermat-point-class) | correction | `EXACT` | 08 | Tenfold lead: at the Fermat tenfold the explicit arc of the Coble family carries the three-plane class, not Movasati's class; the planned check and one earlier remark are withdrawn |
| [C-TENFOLD-ORDER4-RANK2](08_corrections_and_lessons.md#c-tenfold-order4-rank2) | correction | `MOD_P` | 08 | Tenfold lead: 'rank 2 and 3 obstructed at order 4, so dim W <= dim Cone_T + 11' holds for generic nets only; special nets of rank 2 and 3 pass order 4 |
| [O-ALIGNED-POCKET-LAMBDA2-ORDER9](07_open_problems.md#o-aligned-pocket-lambda2-order9) | open | `OPEN` | 07 | Open: lambda = 2 on the symmetric aligned direction at the eightfold Movasati point reaches order 9 with 2 linear conditions per order -- a direction worth examining, not a finding |
| [N-POCKET-NOT-LINEAR-CYCLES](06_ruled_out_and_dead_ends.md#n-pocket-not-linear-cycles) | negative | `RULED_OUT` | 06 | The lambda = 2 pocket at the eightfold Movasati point is not explained by linear cycles persisting individually: none of the 229635 linear P^4's of the Fermat eightfold is tangent to its direction |
| [N-POCKET-LATTICE-FILTER-SMOOTH](06_ruled_out_and_dead_ends.md#n-pocket-lattice-filter-smooth) | negative | `RULED_OUT` | 06 | Lattice filter for the lambda = 2 pocket: no smooth 4-fold of the tested types (linear, complete intersections, Segre, del Pezzo of degree 5, scrolls) has the square discriminant needed to carry [P1] + 2[P2] |
| [N-POCKET-NO-COMPANION-CLASS](06_ruled_out_and_dead_ends.md#n-pocket-no-companion-class) | negative | `RULED_OUT` | 06 | No companion Hodge class along the lambda = 2 pocket jet: from order 6 on, only [P1] + 2[P2] stays Hodge (MOD p, two primes) |
| [O-TENFOLD-CONE-LEAD](07_open_problems.md#o-tenfold-cone-lead) | open | `OPEN` | 07 | Cubic tenfold with two 5-planes meeting in a P^2: is the component W through Z_0 strictly larger than the cone locus Cone_d? |

---

## D-MOVASATI-CERTIFICATES

**Exact certificates at both Movasati points: no component of dimension dim V + 1 for lambda = -1, 2, 5/3**

kind: `result` | area: `movasati_conjecture` | status: **`EXACT`**

**Statement.**

Setting: the Fermat cubic of dimension n = 6 and n = 8 with Movasati's pair of planes P1, P2 (same pairing of the
coordinates; "Movasati point", see discoveries/NOTATION.md), delta = [P1] + lambda [P2], z = zeta_6.
For each lambda in {-1, 2, 5/3} and each n there is an explicit arc F_eps = F_0 - (eps T_1 + eps^2 T_2 + ...), with
T_1 in the kernel of the first-order map L and not tangent to V, along which all period functions vanish to order
N - 1 and the vector c_N of eps^N-coefficients is NOT in the image of L (N = 5 for n = 6, N = 4 for n = 8). A
left-kernel vector K with K.L = 0 and K.c_N != 0 is listed in each certificate. rank L = 7 against rank 8 for
the pair (n = 6), 19 against 20 (n = 8), exact.
Consequence drawn in the session, under the conditions below: the Hodge locus of [P1] + lambda [P2] has no
component of dimension dim V + 1 through the Fermat point, for these lambda. (If it had one, it would be the smooth
germ with tangent space ker L; the arc stays within O(eps^N) of that germ, so K.c_N would be 0.)
This is a conditional, AI-computed statement about the full germ of the Hodge locus. It has not been reviewed by a
human and must not be presented as a refutation of a published conjecture.

**Data.**

```text
Planes. n = 6: P1 = {x0 = z x1, x2 = z x3, x4 = z x5, x6 = z x7}, P2 = {x0 = -x1, x2 = -x3, x4 = -x5, x6 = z x7}.
n = 8: P1 = {x0 = z x1, x2 = z x3, x4 = z x5, x6 = z x7, x8 = z x9},
       P2 = {x0 = z x1, x2 = z x3, x4 = -x5, x6 = -x7, x8 = -x9}: the planes agree on the pairs (01), (23) and differ
       on (45), (67), (89); they meet in a line.
Smallest certificates (lambda = -1):
n = 6: T_1 = x0x1x7 + x2x3x7 + x4x5x7 + x0x2x4 (the last monomial is the excess part);
       T_2 = -(1/3)(x0x2x6 + x0x4x6 + x2x4x6) + ((z-1)/3)(x0x3x6 + x0x5x6 + x2x5x6); T_3 = T_4 = 0;
       K = (z-1)[x6] + [x7] spans the left kernel of L; K.c_5 = -18 + 9z.
n = 8: T_1 = x1x4x5 + x3x6x7 + x4x6x8; T_2 = -(1/3)(x0x6x8 + x2x4x8) + ((z-1)/3)(x0x6x9 + x2x4x9);
       T_3 = ((1-z)/9) x0x2x9; the only nonzero eps^4-coefficient is at Q = x8x9, value -108 - 108z, and the row of
       L at x8x9 is zero.
Control: at lambda = 1 the same construction gives an eps^N-vector in the image of L, for both n.
Also run by team T3 and not exported: lambda = 3, -2, 1/2 (same outcome).
Certificate files: M2/HodgeLociCI/data/cert_n6_lam-1.txt, cert_n6_lam2.txt, cert_n6_lam5o3.txt, cert_n8_lam-1.txt,
cert_n8_lam2.txt, cert_n8_lam5o3.txt (format described in tests/data/fermat/README_export_c3.txt).
```

**Conditions.**

```text
(i) Griffiths' description of the Hodge locus by period functions, with the Griffiths-Dwork (pole-order) reduction
at the Fermat cubic and the period polynomial of a linear subspace ("the engine"). (ii) V smooth with tangent
space ker L_P1 n ker L_P2, so that ker L has dimension dim V + 1. Neither was verified by the checker.
```

**Evidence.**

Team T3 (cert.py), exact over Q(zeta_6). Self-check by the same author with different code (literal
Griffiths-Dwork reduction, Python Fractions). Earlier, night run: nonzero obstruction in generic tangent
directions at order 5 (n = 6) and order 4 (n = 8), MOD p; and the paper statement D-CUBIC-SIXFOLD-DETC,
D-CUBIC-EIGHTFOLD-INVARIANT. Package: fermatVerifyCertificate re-verifies all six files (test 14).

**Independent check.**

C3 (blind; read only the exported files): all six files reproduced entry by entry with independent code by
literal pole-order reduction, exact; ranks 7/8 and 19/20; the period rules tested with own designs and negative
controls; the "one arc suffices" logic found sound. Not covered: condition (ii) (smoothness of V and its tangent
space); other lambda; the second component; anything about algebraic cycles.

**Not established.**

Nothing for lambda outside the six values run. Nothing about a proof or disproof of any published conjecture
without a human check of the conditions and of the reading of the conjecture (machine-read). Nothing about the
Hodge conjecture: all classes concerned are algebraic.

**Known before.**

Movasati arXiv:2211.11405, Conjecture 1 (the Hodge locus has dimension dim V_Z + 1 for these two configurations,
all coefficients; as machine-read) and Theorem 8 (computer proof that the N-th order Hodge locus is smooth for
N <= 14 (n = 6), 6 (n = 8), on a parameter space in which V is a point). Section 2 and 9 of that paper say the
conjecture is false for n >= 10, attributed to Kloosterman. A decision for n = 6, 8 and unequal coefficients: not
found in the sources we read (machine-read, see tests/SOURCES.md); not checked further.
rStation paper #5 (u/lelong_ridge, "Movasati's GADEPs Conjecture 1 fails for cubic sixfolds and eightfolds", v5
18 Oct 2026, https://rstation.ai/problems/hodge_conjecture/papers/5; agent-written, reviewed on rStation, not by
us; machine-read 24 Nov 2026) PRECEDES this entry: its Theorem A proves (mod p jet certificates transferred to
characteristic 0, Lemma 5.2) that Conjecture 1 fails for n = 6, 8 for all lambda outside a finite set, including
all 125 of Movasati's ratios, at the Fermat point and at a general point; credit for the sixfold and eightfold
disproof belongs there. This entry adds EXACT certificates over Q(zeta_6) for lambda = -1, 2, 5/3.

**Reproduce.**

Run from the repository root (Macaulay2 1.22).

```
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
for f in {"cert_n6_lam-1.txt", "cert_n6_lam2.txt", "cert_n6_lam5o3.txt", "cert_n8_lam-1.txt", "cert_n8_lam2.txt", "cert_n8_lam5o3.txt"} do (
    v := fermatVerifyCertificate("M2/HodgeLociCI/data/" | f); print(f, v#"pass", v#"vanishingOrder", v#"obstructionOrder"));
```

Expected: pass = true for all; (vanishing order, obstruction order) = (4, 5) for n = 6 and (3, 4) for n = 8. The key
"label" of each result says that the arithmetic is exact over QQ(zeta_6). With negative controls: tests/run_all.sh
14_fermat (file tests/validation/14_fermat_certificates.m2; 26 checks).

**Session references (files not public).** LEDGER_DISCOVERY.md "[T3] 04:44Z", "[CHECK C3] 04:59Z"; discovery/t3_window/export_c3/; tests/SOURCES.md E8.

---

## D-CONJ1-DIMENSION-NOTE1

**Dimension statement of Conjecture 1 as argued in the unreviewed note 1: holds iff the coefficients are equal**

kind: `result` | area: `movasati_conjecture` | status: **`PROVED_AI_UNREVIEWED`**

**Statement.**

The unreviewed note 1 argues (corollary of its Theorems A, C, E): for smooth cubic sixfolds with two 3-planes
meeting in a point and smooth cubic eightfolds with two 4-planes meeting in a line, the equality
dim NL([P1] + lambda [P2]) = dim V_Z + 1 holds if and only if lambda = 1, at every point of V_Z (V_Z the branch of
the pair), including the Fermat points with Movasati's pairs. For lambda != 1 every component through such a point
has dimension at most dim V_Z. For lambda = 1 the locus is smooth and reduced of dimension dim V_Z + 1.
The conjecture is taken there in the form: Z = r P + r' P', r a positive integer, r' a nonzero integer, "the Hodge
locus V_[Z] is of dimension dim(V_Z) + 1", as read by machine from arXiv:2211.11405. Only this dimension clause
is addressed. This is a conditional, AI-computed statement about the full germ of the Hodge locus. It has not been
reviewed by a human and must not be presented as a refutation of a published conjecture.

**Conditions.**

Theorems A, C, E of note 1 (D-CUBIC-SIXFOLD-DETC, D-CUBIC-EIGHTFOLD-INVARIANT, D-LAMBDA1-PFAFFIAN-AND-SCROLL),
hence Griffiths' calculus and the cited inputs; the machine reading of the conjecture.

**Evidence.**

Note 1 (AI referee reports of the night run, no fatal finding); Lean certificates of finite computations at Fermat
rational pairs and at three non-Fermat cubics; exact certificates of D-MOVASATI-CERTIFICATES for three
coefficients at the Movasati points (blind check C3).

**Independent check.**

C3 for the certificates at the two Movasati points only (three values of lambda). The general statement has AI
referees, no blind recomputation.

**Not established.**

No human has read the note. Whether the note's reading of the conjecture matches the source has to be confirmed by
a person. Algebraicity of the transported classes is shown in the note only for lambda = 1 (it is known for cubic
sixfolds and eightfolds by cited results the session did not open).

**Known before.**

Published: the equal-coefficient half follows from Kloosterman arXiv:2312.12363, Corollary 6.5 with the tangent
computation; for unequal coefficients Theorem 1.3 there states "the conjecture holds or the locus is
non-reduced". Movasati arXiv:2211.11405 states the conjecture for n = 6, 8 (v4 of 25 February 2025, as
machine-read). A decision for unequal coefficients: not found in the sources we read (machine-read, see
tests/SOURCES.md); not checked further.
rStation paper #5 (u/lelong_ridge, "Movasati's GADEPs Conjecture 1 fails for cubic sixfolds and eightfolds", v5
18 Oct 2026, https://rstation.ai/problems/hodge_conjecture/papers/5; agent-written, reviewed on rStation, not by
us; machine-read 24 Nov 2026) precedes this entry (Theorem A: Conjecture 1 fails for n = 6, 8 outside a finite
set of lambda; Corollary B: NL non-reduced along V_Z).

**Reproduce.**

See D-MOVASATI-CERTIFICATES (certificate files) and D-CUBIC-SIXFOLD-DETC (second-order check at a random point).
The general statement is not reproducible from this repository: it is a paper argument; needed: a human reading of
note 1.

**Session references (files not public).**

deliverables/hodge_loci_session/papers/paper1.tex (Corollary "Movasati's Conjecture 1", Corollary "cor:mov");
LEDGER.md "REFEREE RESULT", "Entries after 07:27Z".

---

## D-MOVASATI-SLICE-COMPATIBLE

**No conflict with Movasati's computer theorem: on his transversal slice no obstruction was found**

kind: `result` | area: `movasati_conjecture` | status: **`MOD_P`**

**Statement.**

Movasati's computer-assisted theorem concerns truncations of the Hodge locus on a linear slice spanned by
monomials and transversal to V at the Fermat cubic. The session's computations agree with it as far as they go:
at his pair the order-2 obstruction vanishes on the whole tangent space for every lambda (exact), and along the
pure excess direction inside a monomial slice no obstruction appears through order 8 for seven values of lambda
(order 11 for lambda = 2, -1; modulo one prime). The obstruction of D-MOVASATI-CERTIFICATES appears only in
directions that also move along V: at order 5 for n = 6, with leading coefficient
kappa * lambda (lambda - 1) * det dC(w) on 30 random w in T V (two primes). Smoothness of a slice of a locus does
not give the dimension of the locus, because the locus is not locally a product.

**Conditions.** The Fermat engine (pole-order reduction); the reading of the published slice by machine.

**Evidence.** Night run, agent B (night/fermat_order/, primes 268435399, 268435291); note 1, Remark on the slice computation.

**Independent check.** none with a C-number

**Not established.**

Order 14 was not reached. That the slice curve consists of cubics with a cone-type hyperplane section, with
classes given by cones over surfaces in special cubic fourfolds, is a conjecture of the session. The comparison
with the published paper rests on machine summaries.

**Known before.**

published: Movasati arXiv:2211.11405, Theorem 8; arXiv:1902.00831, Theorem 1 and Table 2 (orders 14, 6, 4, 3 for n
= 6, 8, 10, 12).

**Reproduce.**

not reproducible from this repository: the slice runs used the session's Python engine. Needed: fermatExtendArc
along the pure excess direction to order 8 or more (feasible only modulo a prime for dense arcs).

**Session references (files not public).**

LEDGER.md "[RESOLVED] Conflict with Movasati's computer theorem";
deliverables/hodge_loci_session/papers/paper1.tex (Remark "rem:slice"); night/fermat_order/REPORT.md.

---

## D-SIXFOLD-GERM-AT-MOVASATI-POINT

**Sixfold Movasati point: the germ is V doubled plus one irreducible reduced component W_lambda**

kind: `result` | area: `movasati_conjecture` | status: **`MOD_P`**

**Statement.**

At the sixfold Movasati point, for lambda = -1, 2, 5/3: the order-5 leading form of the one dependent equation of
the Hodge locus is h^2 * psi(w), with h the excess coordinate and w in T V, and no h^3, h^4 terms. The cubic psi is
irreducible; its singular scheme has codimension 4 and degree 6; it has exactly 9 essential variables: the numbers
of a generic 3 x 3 determinant. psi(T) = constant * det dC(T) for the explicit linear map dC below.
Consequence, given the factorisation f = y^2 u' of D-CUBIC-SIXFOLD-DETC: the germ of NL(lambda) there has exactly
two components, V (doubled) and W_lambda, both of dimension dim V; W_lambda is an irreducible reduced hypersurface
of the smooth germ M_lambda, of multiplicity 3, with tangent cone {det dC(T) = 0} x (excess line), the same cone for
all three lambda.

**Data.**

```text
Coordinates: P1 = {x0 = z x1, x2 = z x3, x4 = z x5, x6 = z x7}, P2 = {x0 = -x1, x2 = -x3, x4 = -x5, x6 = z x7},
p = P1 n P2 = (0,...,0,z,1), tangent hyperplane x6 = z x7. A first-order deformation is F_0 - eps T,
T = sum t_abc x_a x_b x_c over the 56 squarefree cubic monomials. With B_ab := z t_(a,b,6) + t_(a,b,7):
    dC_ii(T) = - B_(2i,2i+1) / (z - 1),
    dC_ij(T) = ( z B_(2i,2j) + B_(2i,2j+1) - z B_(2i+1,2j) - B_(2i+1,2j+1) ) / (1 + z)^2   (i != j; i, j = 0, 1, 2).
dC : T V -> Mat_3 is surjective (rank 9). Example of a direction not in the cone: T = x0x1x7 + x2x3x7 + x4x5x7 has
dC = -I/(z - 1). For lambda = -1 the excess direction is the monomial x0x2x4.
```

**Conditions.**

f = y^2 u' with u'|V = unit * det C (Theorem A of note 1). Random 5-, 6- and 11-dimensional subspaces of T V;
primes 268435399 and 268435291.

**Evidence.**

Team T3 (mov6.py, dc_check.py): lambda = -1 and 5/3 at the first prime, lambda = 2 at the second; psi = const *
det dC on 8 to 12 random T per run.

**Independent check.**

None for the match. The coordinator confirmed exactly the algebra model only (singular locus of the 3 x 3
determinant: codimension 4, degree 6).

**Not established.** Exact (characteristic 0) version; other lambda; the statement away from random subspaces of T V.

**Known before.**

not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further
rStation paper #5 (u/lelong_ridge, "Movasati's GADEPs Conjecture 1 fails for cubic sixfolds and eightfolds", v5
18 Oct 2026, https://rstation.ai/problems/hodge_conjecture/papers/5; agent-written, reviewed on rStation, not by
us; machine-read 24 Nov 2026) precedes this entry: Theorem C (n = 6: near the Fermat point NL_red = V_Z u
U_lambda, every component of U_lambda of dimension exactly dim V_Z) and Corollary B (non-reduced along V_Z);
multiplicity 2 and the leading form c_lambda l^2 det A are reported there as finite-field observations (Sec.
8.6). This entry adds: the order-5 leading form h^2 psi(w), psi = const det dC(T), the tangent cone, and the
multiplicity statements (MOD p).

**Reproduce.**

not reproducible from this repository: needs the leading form of the dependent equation on T V at order 5 (the
session's Python engine fog.py). The package's fermatNextOrderSystem gives one arc at a time.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T3] 04:06Z", "[T3] 04:29Z", "[T3] 04:46Z"; discovery/t3_window/mov6.py, dc_check.py.

---

## D-EIGHTFOLD-BOUNDS-AT-MOVASATI-POINT

**Eightfold Movasati point: a second component exists but has dimension at most dim V - 6**

kind: `result` | area: `movasati_conjecture` | status: **`MOD_P`**

**Statement.**

At the eightfold Movasati point, for lambda = -1, 2, 5/3: the order-4 leading forms of the 26 dependent equations
are h^2 * q_L(w), with nine independent quadrics q_L on T V; their common zero cone has codimension 7 and degree 54
in T V. The nine quadrics span the same space as the nine y_1 y_2-coefficients of the 2 x 2 minors of
dC(T)(y) = A y_1 + B y_2, for an explicit surjective map T V -> Mat_3 x Mat_3 (rank 18). The 17 order-5 cubics of
the remaining equations do not change dimension or degree of the cone.
Consequence, given f_L = y^2 v_L (Theorem C(3a) of note 1): every component of NL(lambda) through this point other
than V has dimension at most dim V - 6. Evidence that a second component exists: inside the 20-dimensional family
F = (x0^3 + ... + x3^3) + G_2(x4..x9) a tangent vector of NL not in T V is unobstructed through order 6 (and
Kloosterman's Theorem 5.3, as machine-read, gives a larger reduced locus at split-type points).
For which lambda the bound dim V - 6 is reached: see D-PAIR-TYPE-TABLE and D-X1-COMPONENT-IS-TD-CLOSURE.

**Data.**

dim T V = 100 in the slice of squarefree cubics. Section of the cone by a random 10-dimensional subspace and two
hyperplanes: 54 reduced points. The map dC on eightfolds: the sixfold formulas of D-SIXFOLD-GERM-AT-MOVASATI-POINT
on the pairs (4,5), (6,7), (8,9) with B_ab(y) = y_1 (z t_(a,b,0) + t_(a,b,1)) + y_2 (z t_(a,b,2) + t_(a,b,3)).

**Conditions.**

Theorem C(3a) of note 1. Five runs: lambda = -1, 2 at prime 268435399; lambda = -1, 5/3, 2 at 268435291; random
10- or 11-dimensional subspaces.

**Evidence.**

Team T3 (mov8.py, mov8b.py, mov8_split.py, dc_check.py). Exact over Q: the model ideal has dimension 11 of 18 and
degree 54 (Singular).

**Independent check.** Model only: coordinator (exact) and C17 (N5, MOD p). The match with the Hodge locus was not independently checked.

**Not established.**

The exact dimension of the second component at this point. T3's first conjecture 'exactly dim V - 6 for every
lambda not in {0,1}' was withdrawn (N-EIGHTFOLD-DIM-MINUS-6-ALL-LAMBDA).

**Known before.**

Kloosterman arXiv:2312.12363, Theorem 1.4 / 5.3: at split-type X the reduced locus properly contains the two-plane
locus (as machine-read; cited in the session for existence only). The bound: not found in the sources we read
(machine-read, see tests/SOURCES.md); not checked further.
rStation paper #5 (u/lelong_ridge, "Movasati's GADEPs Conjecture 1 fails for cubic sixfolds and eightfolds", v5
18 Oct 2026, https://rstation.ai/problems/hodge_conjecture/papers/5; agent-written, reviewed on rStation, not by
us; machine-read 24 Nov 2026) precedes this entry: Theorem A (n = 8: dim NL = dim V_Z at the Fermat point
outside a finite set of lambda) and Theorem C / Prop. 8.3 (U_lambda contains a cone family W' of dimension dim
V_Z - 16, not in V_Z and not of split type). The bound dim V - 6 and the lambda = -1 analysis are not in #5 (#5
does not treat lambda = -1 specially at n = 8).

**Reproduce.**

not reproducible from this repository: needs leading forms of 26 equations on a subspace of T V (session engine).
First-order numbers 19 against 20 at this pair: see D-MOVASATI-TABLES-REPRODUCED.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T3] 04:06Z", "[T3] 04:14Z", "[T3] 04:25Z", "[T3] 04:46Z", "[COORD] 04:39Z".

---

## D-EIGHTFOLD-INCIDENCE-TYPES

**The nine incidence types of pairs of 4-planes meeting in a line on the Fermat cubic eightfold**

kind: `result` | area: `fermat_expansion` | status: **`MOD_P`**

**Statement.**

```text
P1 is the plane of the pairing (01)(23)(45)(67)(89) with x_(2e) = z x_(2e+1). P2 runs over one representative of
each incidence type. A type lists the cycles of the union of the two pairings; T means that the planes share a
point supported on the cycle, F that they do not; a pair meeting in a line has exactly two T. In all nine types:
codim V = 20, rank of the first-order map 19 (excess 1), cokernel of dimension 26. The first obstruction in
generic tangent directions (lambda = 2) is at
    order 2: [8T 2T], [6T 4T], [4T 4T 2F]            (like a general point of V);
    order 3: [6T 2T 2F], [4T 4F 2T], [4T 2T 2F 2F];
    order 4: [6F 2T 2T], [4F 2T 2T 2F], [2T 2T 2F 2F 2F] (the last one is Movasati's pair).
At the three order-3 types the leading forms are h^2 * (linear form on T): of rank 7 at [6T 2T 2F] and rank 4 at
the other two, with the same rank on T V.
Sixfold analogue (night run, two primes): at all 10 incidence types of pairs of 3-planes meeting in a point the
first obstruction is at order exactly 2 + corank C.
```

**Data.**

Representative of [6T 2T 2F] (called X1 in this registry): P2 = {x1 = -x2, x3 = -x4, x0 = -x5, x6 = z x7, x8 = -x9}.
Model: at [6T 2T 2F] the pencil C(y) = y_1 * (rank-2 matrix), a smooth point of the codimension-7 cone of
D-CUBIC-EIGHTFOLD-INVARIANT; at the two rank-4 types C(y) = y_1 * (rank-1 matrix), a singular point of it.

**Conditions.** Prime 268435399, lambda = 2, generic tangent directions.

**Evidence.** Team T3 (scan8.py). Night run, agent B (DETC.md) for the sixfold types.

**Independent check.** C9 confirmed exactly the numbers at X1: ranks 10/10/20 and 19, left kernel 26, rank 7 of the order-3 linear forms.

**Not established.** The types [6F 2T 2T] and [4F 2T 2T 2F] were not computed beyond the first obstruction order.

**Known before.** not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further

**Reproduce.**

Run from the repository root (Macaulay2 1.22). First-order numbers at X1 and at Movasati's pair (exact):

```
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
S = fermatRing(3, 8);
P1 = {{0,1,1},{2,3,1},{4,5,1},{6,7,1},{8,9,1}}; Mov = {{0,1,1},{2,3,1},{4,5,3},{6,7,3},{8,9,3}};
X1 = {{1,2,3},{3,4,3},{0,5,3},{6,7,1},{8,9,3}};
print apply({Mov, X1}, P2 -> (u := fermatTangentData(S, {P1, P2}, {1, 2}); (u#"hodgeCodimension", u#"jointPersistenceCodimension")));
```

Expected: {(19, 20), (19, 20)}. The obstruction orders themselves need arcs in generic directions (session engine).

**Session references (files not public).** LEDGER_DISCOVERY.md "[T3] 04:51Z"; LEDGER.md "[CHECKED mod 2 primes, agent B, night/fermat_order/DETC.md]".

---

## D-X1-ORDER5-FORMULA

**At the pair X1 the order-5 obstruction is (8/9)(1+z)(lambda-1)(lambda+1)^2/lambda^3: -1 is special**

kind: `result` | area: `movasati_conjecture` | status: **`EXACT`**

**Statement.**

```text
X1 is the following pair of 4-planes meeting in a line on the Fermat cubic eightfold (z = zeta_6):
    P1 = {x0 = z x1, x2 = z x3, x4 = z x5, x6 = z x7, x8 = z x9},
    P2 = {x1 = -x2, x3 = -x4, x0 = -x5, x6 = z x7, x8 = -x9}     (incidence type [6T 2T 2F]).
Exact facts over Q(zeta_6):
(a) the order-3 obstruction on ker L (dimension 101 on squarefree cubics) is h^2 * u_t with u_t = t (t - 1) u for
    one fixed 26 x 101 matrix u of rank 7, on T and on T V; it vanishes at t = 1;
(b) fix T_1 = tau_* + kappa, where tau_* is the element of ker L supported on x0x1x8, x0x2x8, x0x3x8, x0x4x8,
x1x3x8,
    x2x4x8 with coefficient 1 at x2x4x8, and kappa = (z-1)(x0x3x6 + x0x4x6) + x1x3x6 + x1x4x6. For lambda != -1
    order 4 is solvable and order 5 is obstructed: with the functional Lambda of the certificate file
        Lambda.c_5 = (8/9)(1 + z) * (lambda - 1)(lambda + 1)^2 / lambda^3;
(c) for lambda = 2 the value Lambda.c_5 = 1 + z does not depend on any admissible choice of T_2, ..., T_5, over all
    220 cubic monomials: no arc with this T_1 has all period functions vanishing to order 5;
(d) for lambda = -1 an explicit seven-term arc with this T_1 has all 45 period functions vanishing to order 7.
At every value tested the obstruction equals this formula, which has a double zero at lambda = -1, a simple zero
at lambda_0 = 1 and no other zero. The pairwise rule gives +1 as the only special coefficient here (c = 3).
```

**Data.**

Values of lambda at which formula (b) was confirmed exactly: 2, 3, 5, 7, 1/2, 5/3, -2, -3, -1/2 (team T3) and
3, 4, -3/2, 4/3, 5/3, 1/2 - (2/3)z, z (check C11). Modulo primes, with dense random T_1 in ker u and own
normalisation, check C9 found the order-5 residual proportional to lambda (lambda - 1)(lambda + 1)^2 at 24 values
(integers -8..10 except 0, 1; 5/3, 1/2, -1/2, 1/3, -5/2; two non-real values). T3's modulo-p fit with a different
normalisation: c_i (lambda - 1)(lambda + 1)^2 / lambda^3 at 40 and 15 values. The normalisations differ by a
power of lambda; all three agree on the zeros.
Functional of the lambda = 2 file: Lambda = ((z-1)/2)[x0x1] + ((z-1)/2)[x0x2] - (1/2)[x0x3] - (1/2)[x0x4]
+ (z/2)[x0x5] + [x1x2] (dual basis of the quadratic forms Q); Lambda.L = 0.
Files: M2/HodgeLociCI/data/x1_lam2_obstruction.txt, M2/HodgeLociCI/data/x1_lam-1_arc.txt.
X1 is a cone-type point: its section by x6 = z x7 is the cone, with vertex (0,...,0; z,1; 0,0), over the Fermat
sixfold in x0..x5, x8, x9, and P1, P2 are the cones over the 3-planes Pi1 = {x0 = z x1, x2 = z x3, x4 = z x5,
x8 = z x9}, Pi2 = {x1 = -x2, x3 = -x4, x5 = -x0, x8 = -x9}, which meet in the point (z, 1, -1, z^2, -z^2, -z; 0, 0)
and have rank C = 2.

**Conditions.**

The Fermat engine (Griffiths-Dwork reduction, period polynomial of a linear subspace). Statements (b)-(d) are for
the one fixed T_1.

**Evidence.** Team T3 (cert_x1.py, exact; lam_scan.py, lam_fit.py MOD p). The package re-verifies both files exactly (test 14).

**Independent check.**

C9 (blind, own engine): (a) exact; the contrast lambda = -1 against 2, 5/3, -2 MOD p at two primes with dense
random T_1; the 24-value scan. C11 (blind, exact): (b) at seven further values, (c) by a direct computation over
all 220 cubic monomials, (d) to order 7. Not covered: arcs with any other T_1 exactly; orders above 7 at
lambda = -1 (T3's order 9 is not exported); T3's values at lambda = 5, 7, 1/2, -2, -3, -1/2.

**Not established.**

That an honest arc of the Hodge locus exists at lambda = -1 (finite order only). Why the exponent of (lambda + 1)
is 2 (O-EXPONENT-OF-LAMBDA-PLUS-1). The passage from the 56-dimensional symmetric family to all cubics by
"equivariance" claimed first by T3 is wrong (C-AVERAGING-ARGUMENT); only (c) is established over all cubics, and
only for lambda = 2.

**Known before.** not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further

**Reproduce.**

Run from the repository root (Macaulay2 1.22).

```
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
for f in {"x1_lam2_obstruction.txt", "x1_lam-1_arc.txt"} do (
    v := fermatVerifyCertificate("M2/HodgeLociCI/data/" | f); print(f, v#"pass", v#"vanishingOrder", v#"obstructionOrder"));
```

Expected: (x1_lam2_obstruction.txt, true, 4, 5) and (x1_lam-1_arc.txt, true, 7, ) (no obstruction order). The
formula in lambda and claim (c) are not re-verified by the package (tests/README.md, "Not covered").

**Session references (files not public).**

LEDGER_DISCOVERY.md "[T3] 05:05Z", "[CHECK C9] 05:46Z", "[T3] 06:01Z", "[T3] 06:12Z", "[CHECK C11] 14:55Z", "[T3]
16:03Z"; discovery/t3_window/export_x1/.

---

## D-PAIR-TYPE-TABLE

**Table 'pair type x lambda': dimension of the second component on Fermat eightfold line pairs**

kind: `result` | area: `movasati_conjecture` | status: **`MOD_P`**

**Statement.**

Dimension of the second component of the Hodge locus of [P1] + lambda [P2] at pairs of 4-planes meeting in a line
on the Fermat cubic eightfold, by incidence type (D-EIGHTFOLD-INCIDENCE-TYPES). d = dim V; "none" = the locus is V
with a double structure. All entries are modulo primes and to the order stated; bounds for the second component
use the factorisation f_L = y^2 v_L of note 1.

**Data.**

| type (order of first obstruction) | lambda = 1 | lambda = -1 | other lambda tested |
|---|---|---|---|
| [8T 2T], [6T 4T], [4T 4T 2F] (2) | smooth, d + 1 | none | none (2, 1/2, 5/3, four sixth roots of unity) |
| [6T 2T 2F] = X1 (3) | smooth, d + 1 | d - 6 conjecturally: arcs to order 7 inside the smooth germ W' | <= d - 7; outside T V <= d - 10 (order 5; lambda = 2, 5/3, 3, 1/2, -2, -1/2, -3, roots of unity) |
| [4T 4F 2T], [4T 2T 2F 2F] (3) | smooth, d + 1 | <= d - 6 (cone of codimension 3 and degree 5 in the 97-dimensional ker u, order 4) | <= d - 7; outside T V <= d - 8 (order 4; lambda = 2 only) |
| [6F 2T 2T], [4F 2T 2T 2F] (4) | smooth, d + 1 | not computed beyond the first obstruction order | not computed |
| Movasati [2T 2T 2F 2F 2F] (4) | smooth, d + 1 | <= d - 6 by the order-4 cone; = d - 6 if W' is the locus at X1 (D-GLOBAL-ARGUMENT) | <= d - 6 by the order-4 cone; <= d - 7 by D-GLOBAL-ARGUMENT from X1 (lambda = 2, 5/3) |

d - 6 is an upper bound everywhere for a structural reason: a component other than V meets V in a hypersurface of
itself, inside {D = 0}, which has codimension 7 in V.
At X1 for lambda = 2: the order-5 residual along arcs in W' is h^4 * m_a(tau), a = 1..4, with four independent
linear forms m_a (one prime, one subspace).

**Conditions.** Primes 268435399, 268435291; random subspaces; f_L = y^2 v_L (Theorem C(3a) of note 1).

**Evidence.** Team T3 (scan8b.py to scan8f.py, order2types.py, lam_scan.py).

**Independent check.** C9 and C11 for the row X1 (see D-X1-ORDER5-FORMULA). The other rows: none.

**Not established.**

Every 'dimension' entry is a bound or a finite-order statement. Other components through X1 for lambda != +-1 are
not excluded beyond the bounds (O-OTHER-COMPONENTS-AT-X1).

**Known before.** not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further

**Reproduce.**

Row X1: see D-X1-ORDER5-FORMULA. The other rows are not reproducible from this repository: they need the session's
arc engine in generic directions.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T3] 06:01Z" (table), "[T3] 05:12Z".

---

## D-GLOBAL-ARGUMENT

**Global argument: bounds and components at X1 transfer to the eightfold Movasati point**

kind: `result` | area: `movasati_conjecture` | status: **`PAPER_ARGUMENT_AI`**

**Statement.**

Let I be the incidence variety of triples (X, P1, P2), X a smooth cubic eightfold, P1, P2 two 4-planes in X meeting
in a line; I is irreducible. Let X0 be the Movasati pair and X1 the pair of D-X1-ORDER5-FORMULA.
Statement A. Fix lambda not in {0, 1}. If at X1 every component of the Hodge locus of [P1] + lambda [P2] other
than V has dimension <= dim V - 7, then the same holds at X0.
Statement B. If at X1 the Hodge locus contains the smooth germ W' of dimension dim V - 6 cut out by the order-3
linear forms, then at X0 it has a component of dimension exactly dim V - 6.
The proof uses: every component other than V lies in {v_L = 0} and meets V inside Z_D = {D = 0}; Z_D has exactly
one component Z of codimension 7 in V near X0 and X1; Z is irreducible globally and contains X0 and X1; the locus
of Hodge classes is a countable union of closed algebraic sets (Cattani-Deligne-Kaplan).

**Conditions.**

F1: Theorem C(3a) of note 1 (assumed; it carries all the weight). The formula for D (note 1). Rational lambda only.
Hypothesis of A at X1: exact for lambda = 2 only (check C11); MOD p for the other lambda. Hypothesis of B (W'
inside the Hodge locus for lambda = -1) is not given by arcs to finite order; it is supplied by
D-X1-COMPONENT-IS-TD-CLOSURE.

**Evidence.** Team T3, 06:03Z (written out for one checker).

**Independent check.**

C17 (one adversarial read, own computations MOD p): stands with small fixes, as a conditional statement. It does
not use the wrong symmetry-averaging step. 'One component of codimension 7' was confirmed there MOD p (N5); X1 in
Z verified by hand from an explicit C(y).

**Not established.** Anything unconditional. 'The other components of Z_D have codimension 9' was not checked (not needed).

**Known before.** n/a (an argument internal to the session's framework)

**Reproduce.**

not reproducible from this repository: a paper argument. Needed: a human reading of the ledger entry and of
Theorem C of note 1.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T3] 06:03Z", "[CHECK C17] 16:08Z".

---

## D-X1-COMPONENT-IS-TD-CLOSURE

**For lambda = -1 the second component at X1 is the germ of the closure of the family l*Q + det A + det B**

kind: `result` | area: `movasati_conjecture` | status: **`PAPER_ARGUMENT_AI`**

**Statement.**

Let TD be the family of cubic eightfolds F = l*Q + det A + det B (l a linear form, Q a quadric, A, B 3 x 3 matrices
of linear forms in 10 variables), SS its closure, d = dim V. Claim: for lambda = -1, at the pair X1, the zero set
{v_L = 0} equals the smooth germ W' of dimension d - 6, and W' is the germ at X1 of SS. A general member of SS
carries the explicit fourfold T4 of degree 9 with T4.T4 = 51 (D-EIGHTFOLD-FAMILY-TD), and the transported class is
+-([T4] - 3 eta^4), sign and monodromy not determined. With D-GLOBAL-ARGUMENT(B) the same component passes through
the eightfold Movasati point with dimension d - 6. For the other lambda tested no such component exists
(D-PAIR-TYPE-TABLE).

**Data.**

```text
The chain, in the form that stands after check C17:
1. sigma = [Sigma] - 2 eta^4 (Sigma a Segre fourfold P^2 x P^2) is primitive of square 24, and so is [P1] - [P2] for
   4-planes meeting in a line (exact, Chern classes).
2. On cubic sixfolds: near a point of the two-plane locus with rank C = 2 the second component for lambda = -1 is
   the closure of the Hodge locus of the flag threefold, class 2h^3 +- (Pi1 - Pi2) (D-W-MINUS1-IS-TWO-DET-CLOSURE).
3. For cone-type eightfolds x_0*Q + c the cone is a correspondence; the cone over a flag threefold is a flat limit
   of Segre fourfolds. (This gives Hodge classes only on the cone-type family, of codimension d - 16 over the
   sixfold locus.)
4. (Gap in the first version, repaired in C17.) TD is irreducible, tau = [T4] - 3 eta^4 is Hodge on it, the Hodge
   locus of [T4] at a general member is smooth of codimension 26 and equals TD; at a general Segre cubic the limit
   of tau is +-(Sigma - 2 eta^4). So the Hodge locus of the Segre class is smooth of codimension 26 there and
   SS = closure of TD.
5. X1 is cone-type over a sixfold pair of rank C = 2 (coordinates in D-X1-ORDER5-FORMULA), so X1 lies in SS with
   class +-([P1] - [P2]).
6. The germ of SS at X1 has pure dimension d - 6, lies in the Hodge locus and not in V, hence in W'; so it is W'.
Supporting computations that do not use the chain: arcs in W' to order 7; the factor (lambda + 1)^2; the
invariants of the class along W' equal those of a general member of TD (D-RANK-INVARIANT); the quadric part of
ker u at X1 has dimension exactly 29 and contains l_0 * S_1 for l_0 = x6 - z x7 only (exact; the number 29 is
forced for any class with tangent codimension 26, only the linear form is informative).
```

**Conditions.**

Theorems A and C(3a) of the unreviewed note 1; the chain behind D-W-MINUS1-IS-TWO-DET-CLOSURE (with Hassett's
irreducibility of the divisor C_18, cited); ranks modulo primes at random points (two primes at most); the cone
pairing formula.

**Evidence.**

Team T3 (06:05Z chain; 16:27Z, 16:30Z computations). Check C17 computations N1-N4 (Macaulay2, primes 32003 and
30011). Coordinator's check C15 (Singular) agrees with N1, N2.

**Independent check.**

C17: one adversarial read. Step 4 had a gap as written (tangent codimension 26 bounds the dimension from above
only); closed there MOD p with the family TD. The repair was read by no one else. C12, C15: the numbers 27 / 26
for the Segre fourfold and 26 for TD.

**Not established.**

UPDATE 26 Nov 2026: X1 is the cone over T2's sixfold pair and the exported arc six_lam-1_arc.txt is a cone-type arc
(variables x0..x5, x8, x9), so an explicit degeneration onto X1 is the cone over a degeneration of (A, B) onto T2's
sixfold point: the missing step is O-RECOVER-MATRICES-AND-LIMIT-OF-T (see D-TENFOLD-CONE-POINTS-TWO-DET). Earlier text:
Anything exact. That the divisor of Segre-type members of SS comes near X1. An explicit degeneration of (l, Q, A,
B) onto X1. The eightfold version of the plane lemma (D-GENERAL-CUBIC-OF-D-IS-LIMIT). A direct comparison of
classes at X1 is impossible if that lemma holds one dimension up.

**Known before.** not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further

**Reproduce.**

The numerical inputs for TD and the Segre fourfold: see D-EIGHTFOLD-FAMILY-TD and D-SEGRE-FOURFOLD
(tests/validation/13_discovery_explicit_families.m2). The identification itself is not reproducible from this
repository: a paper chain; needed: an explicit degeneration onto X1 or a human reading.

**Session references (files not public).**

LEDGER_DISCOVERY.md "[T3] 05:41Z", "[T3] 06:05Z", "[CHECK C17] 16:08Z", "[COORD] 16:10Z", "[T3] 16:27Z";
discovery/checks/c17/.

---

## D-RANK-INVARIANT

**Rank invariant on the sixfold underneath: 18 for lambda = -1, 12 plus a linear form for 1, 28 for the others**

kind: `result` | area: `movasati_conjecture` | status: **`MOD_P`**

**Statement.**

```text
For a Hodge class on a cubic sixfold with period polynomial P, let Cat(2,2) be the 36 x 36 catalecticant
(m_1, m_2) -> period of m_1 m_2 on quadrics, and Cat(1,3) the 8 x 120 one. Their ranks at the general point of a
component of a Hodge locus are invariants of the component. The 8 partial derivatives of the cubic always lie in
the kernel of Cat(2,2), so its maximal rank is 28 = dim R_2. Computed along generic arcs inside the second
component W_lambda at the sixfold pair of type [6T 2F] (coordinates below; corank C = 1):
    lambda = -1: Cat(1,3) has no kernel; Cat(2,2) has rank 18: 18 quadrics annihilate the class (10 beyond the
                 partials), Hilbert function 1, 8, 18, 8, 1, and they generate the tangent space (112 = 120 - 8).
                 These are the invariants of a sum of two 3 x 3 determinants.
    lambda = 1 (control): a linear form annihilates the class; Cat(2,2) has rank 12; 24 quadrics generating
                 113 = 120 - 7 cubics; Hilbert function 1, 7, 12, 7, 1, as for l*Q + Pfaffian.
    lambda = 2, 1/2, -2, 3, 5/3: Cat(2,2) has rank 28, the maximum: no quadric outside the Jacobian ideal
                 annihilates the class.
On eightfolds along W' at X1 (lambda = -1): one linear form annihilates the class, Cat(2,3) has rank 26, 29
quadrics generate the tangent space, Hilbert function 1, 9, 26, 26, 9, 1: the invariants of a general member of
the family l*Q + det A + det B.
```

**Data.**

```text
Sixfold pair [6T 2F]: P1 = {x0 = z x1, x2 = z x3, x4 = z x5, x6 = z x7}, P2 = {x1 = -x2, x3 = -x4, x0 = -x5, x6 =
-x7}. Invariant factors over F_p[[eps]] (units, then valuations):
lambda = -1 (orders 6 to 9, primes 268435399 seeds 1, 3, 5, 7 and 268435291 seed 2): Cat(1,3): 7 units, 1 at eps^2;
  Cat(2,2): 12 units, 6 at eps^2, 18 zero modulo eps^10.
lambda = 2 (both primes), 1/2, -2, 3, 5/3 (one prime each), orders 6 to 10: Cat(2,2): 12 units, 6 at eps^2, 4 at
  eps^4, 2 at eps^5, 4 at eps^7, 8 zero modulo eps^11.
At the sixfold Movasati point (C = 0): lambda = -1: Cat(2,2) 12 units, 6 at eps^3, nothing more below eps^8
(rank 18); lambda = 2: 12 units, 6 at eps^3, 3 at eps^5, ... (rank at least 21).
Eightfold, X1, lambda = -1, generic arcs of order 6: Cat(1,4): 8 units, 1 at eps^2, 1 zero; Cat(2,3): 19 units, 7 at
eps^2, 29 zero.
Precision: these are factors of truncated arcs. They are valid for a true arc of the component modulo eps^(N-1)
where the component is smooth at the base point, and modulo eps^(N-3) at the Movasati point.
```

**Conditions.** Arcs built by the session's Fermat engine modulo primes; 'zero' means zero to the stated order.

**Evidence.**

Team T3 (annlib.py, ann_run.py), round 4. A first reading ('8 quadrics annihilate the class' for the other lambda)
was corrected by T3: those 8 are the partial derivatives (C-RANK-28-MISREADING).

**Independent check.**

C18 (exact, but on the two exported sparse arcs only): see D-RANK-CONTRAST-EXACT-ARCS. The generic-arc values, in
particular 28, were not independently checked.

**Not established.** Exact ranks at the general point of the components. A rank reported as k along an arc is a finite-order statement.

**Known before.**

not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further
rStation paper #5 (u/lelong_ridge, "Movasati's GADEPs Conjecture 1 fails for cubic sixfolds and eightfolds", v5
18 Oct 2026, https://rstation.ai/problems/hodge_conjecture/papers/5; agent-written, reviewed on rStation, not by
us; machine-read 24 Nov 2026), Sec. 8.4: at lambda = -1 (n = 6) the monomial directions x1x3x5 and x0x2x4 give
arcs unobstructed to order 5 while generic arcs are obstructed at order 5, and no monomial direction works at
lambda = 2. Reproduced here (EXACT, package fermatExtendArc, Movasati pair as in NOTATION.md): both are in ker L
only at lambda = -1 (not at 2 or 1), are not in T V_Z, and extend to order 7. Whether they are tangent to W_(-1)
was not checked.

**Reproduce.**

not reproducible from this repository: the catalecticants along arcs are not implemented in the package. The
exported arcs are in M2/HodgeLociCI/data/six_lam-1_arc.txt and M2/HodgeLociCI/data/six_lam2_arc.txt; needed: a
function computing periods of quadratic monomials along an arc (pole order one higher) and Smith forms over a
power series ring.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T3] 16:30Z", "[T3] 16:33Z", "[T3] 16:40Z", "[T3] 16:42Z".

---

## D-RANK-CONTRAST-EXACT-ARCS

**Rank contrast on two exported exact arcs: 18 for lambda = -1, at least 27 for lambda = 2, modulo eps^10**

kind: `result` | area: `movasati_conjecture` | status: **`EXACT`**

**Statement.**

```text
For the two polynomial arcs of the files six_lam-1_arc.txt and six_lam2_arc.txt (arcs at X1 without x6, x7, read as
arcs of the cubic sixfold in x0..x5, x8, x9), exactly over Q(zeta_6):
(a) the 8 period functions of the sixfold vanish modulo eps^10 along both arcs;
(b) invariant factors of Cat(2,2) modulo eps^10: lambda = -1: 12 units, 6 of valuation 2, 18 vanishing;
    lambda = 2: 12 units, 6 of valuation 2, 4 of valuation 4, 2 of valuation 5, 3 of valuation 7, 9 vanishing (8 of
    them are the partial derivatives). So rank 18 to this order for lambda = -1 and rank at least 27 for lambda = 2
    on these arcs;
(c) on the exported eightfold arc x1_lam-1_arc.txt, modulo eps^8: one linear form annihilates the class
    (l(eps) = (z-1) x6 + x7 + eps^5 l_5(x0..x5) + eps^6 l_6(x8,x9) + ...), the 55 x 220 catalecticant has 19 units, 7
    of valuation 2, 29 vanishing: rank 26, Hilbert function 1, 9, 26, 26, 9, 1 to this order.
All statements are about the truncated arcs in the files.
```

**Conditions.**

The Fermat engine. The files are truncations: the lambda = -1 sixfold file agrees with a true arc of the Hodge
locus only modulo eps^8, and its terms T_1..T_8 cannot be continued to order 10 (check C20).

**Evidence.**

Team T3 (exact arcs; factors MOD p). Check C18: exact, three ways (exact ranks over Q of truncated matrices; own
elimination over Q(z)[[eps]]; two primes).

**Independent check.**

C18. Not covered: whether the files are truncations of true arcs and to which order; generic arcs; the value 28;
the family l*Q + det A + det B itself.

**Not established.**

Rank 18 beyond eps^10 on this arc, or at the general point. For a true arc agreeing with a file modulo eps^r only
the factors of valuation < r carry over (lambda = 2: rank >= 27 if r >= 8, >= 24 if r = 6).

**Known before.** not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further

**Reproduce.**

Run from the repository root (Macaulay2 1.22). The package verifies that the files are arcs to order 9 (as
eightfold arcs: 45 period functions):

```
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
for f in {"six_lam-1_arc.txt", "six_lam2_arc.txt"} do (
    v := fermatVerifyCertificate("M2/HodgeLociCI/data/" | f); print(f, v#"pass", v#"vanishingOrder"));
```

Expected: pass = true, vanishing order 9 for both. The invariant factors are not computed by the package.

**Session references (files not public).**

LEDGER_DISCOVERY.md "[T3] 16:42Z", "[CHECK C18] 16:53Z", "[CHECK C20] 18:57Z";
discovery/t3_window/export_x1/README_round4.txt.

---

## D-LAMBDA2-CONE-TYPE

**For lambda = 2 the component through X1 containing the cone-type family is that family (dim V - 16)**

kind: `result` | area: `movasati_conjecture` | status: **`PAPER_ARGUMENT_AI`**

**Statement.**

```text
Thom-Sebastiani formula for the Jacobian ring: let X = {x6^3 + x7^3 + c(y) = 0}, Z = {c = 0} a smooth cubic
sixfold, gamma a Hodge class on Z, delta = cone(gamma). Then R(X) = R(Z) (x) C[x6,x7]/(x6^2, x7^2), the period
polynomial of delta is that of gamma times (x6 + z x7), and
    Hodge tangent codimension of delta at X = (tangent codimension of gamma) + rank Cat(2,2)(gamma).
With D-RANK-INVARIANT: 8 + 18 = 26 = codim V + 6 for lambda = -1; 8 + 28 = 36 = codim V + 16 for
lambda = 2, 1/2, -2, 3, 5/3; 7 + 12 = 19 = codim V - 1 for lambda = 1.
The cone-type family CT_lambda (cubic eightfolds with a hyperplane section that is a cone over a sixfold of the
sixfold second component W_lambda) has codimension 36 by a parameter count, lies in the Hodge locus and passes
through X1. Hence for lambda = 2 (same for 1/2, -2, 3, 5/3): at a general point of CT_lambda of the form
x6^3 + x7^3 + c the Hodge locus is smooth and equal to CT_lambda. The component through X1 that contains the
cone-type family has dimension exactly dim V - 16.
```

**Conditions.**

The sixfold rank 28 (MOD p, to order 10, two primes: D-RANK-INVARIANT). The parameter count 219 - (9 + 8 + 111 +
55) = 36.

**Evidence.**

Team T3, 16:33Z (short paper argument). MOD p check: along arcs of such cubics the invariant factors of the
eightfold Cat(2,3) are the union of those of the sixfold Cat(1,3) and Cat(2,2); all period coefficients of orders
1..5 vanish along explicit cone-type arcs for lambda = 2 and -1.

**Independent check.** none (C18 confirmed the additivity of factor lists on the exported arcs only)

**Not established.**

Further components through X1 for these lambda are not excluded: only the bounds dim <= dim V - 7, and <= dim V -
10 if not tangent to V (order 5, one prime).

**Known before.**

not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further
rStation paper #5 (u/lelong_ridge, "Movasati's GADEPs Conjecture 1 fails for cubic sixfolds and eightfolds", v5
18 Oct 2026, https://rstation.ai/problems/hodge_conjecture/papers/5; agent-written, reviewed on rStation, not by
us; machine-read 24 Nov 2026) precedes this entry and agrees with it: Prop. 8.3, the cone family W' of dimension
dim V_Z - 16 at n = 8 (for lambda outside its exceptional set).

**Reproduce.** not reproducible from this repository: needs the catalecticant rank along arcs (see D-RANK-INVARIANT).

**Session references (files not public).** LEDGER_DISCOVERY.md "[T3] 16:33Z", "[T3] 16:40Z".

---

## D-TANGENT-OF-W-TURNS

**At a Fermat point of the divisor D the tangent hyperplane of W_lambda turns linearly with lambda**

kind: `result` | area: `fermat_expansion` | status: **`EXACT`**

**Statement.**

```text
Fermat cubic sixfold with P1 = {x0 = -x1, x2 = -x3, x4 = -x5, x6 = -x7}, P2 = {x0 = z x1, x2 = z x4, x3 = z x6,
x5 = -x7}, z a primitive sixth root of unity (corank of C equal to 1, a point of D). Exactly over Q(zeta_6), on
all of T V (dimension 48 in the slice of squarefree cubics), for seven values of the coefficient t:
order 2 vanishes on the kernel of the first-order map; the order-3 obstruction along w + s (beta - t alpha) is
s^2 * psi_t(w) with no s^0, s^1, s^3 part, independent of the second-order term; and psi_t = t (t - 1) psi for one
fixed linear form psi. Here alpha is a first-order deformation that keeps P2 and loses P1, beta one that keeps P1
and loses P2. Hence at this point T D = ker psi does not depend on lambda and
    T W_lambda = T D + <beta - lambda alpha>.
```

**Conditions.**

The Fermat engine. One point (a symmetric Fermat point of D). The vanishing of the s^3 term depends on the choice
of alpha, beta modulo T V.

**Evidence.**

Team T2 (w_tangent.py, MOD p, two primes; lambda = -1, 2, 1/2, -2, 3). Validation: no obstruction through order 5
at lambda = 1; order-2 obstruction at a rational corank-0 pair for lambda = -1, 2.

**Independent check.** C5 (blind, own code, exact): confirmed at the values tested, not as an identity in t.

**Not established.** The same statement at a general point of D (expected form: the s^3 coefficient is affine in lambda; not tested).

**Known before.** not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further

**Reproduce.**

not reproducible from this repository: the order-3 leading form on all of T V needs the session's arc engine; the
package builds one arc at a time (fermatNextOrderSystem).

**Session references (files not public).** LEDGER_DISCOVERY.md "[T2] 04:33Z", "[CHECK C5] 05:06Z".

---

## D-FERMAT-RATIONAL-PAIRS-ORDER2

**Rational Fermat pairs: the order-2 form vanishes exactly at lambda_0 = (-1)^(c-1), no other special value**

kind: `result` | area: `fermat_expansion` | status: **`EXACT`**

**Statement.**

```text
At Fermat cubics with rational pairs of k-planes (planes x_a = -x_b from two different pairings), with lambda
symbolic: the order-2 obstruction form vanishes identically exactly at lambda = 1 for (n,m) = (6,0), (6,2), (8,1),
(8,3) and exactly at lambda = -1 for (6,1), (8,2). The gcd of all entries is lambda (lambda -+ 1) and the quotient
is constant, so there is no other special lambda, real or complex. For (n,m) = (8,0) there is no excess.
Example: Fermat cubic sixfold, pairings (01)(23)(45)(67) and (07)(12)(34)(56) (planes meeting in a point): the
obstruction is -(8/3) lambda (lambda - 1). Fermat cubic eightfold, pairings (01)(23)(45)(67)(89) and
(05)(12)(34)(69)(78) (planes meeting in a line): 4 lambda (lambda - 1) in the normalisation of the Lean file.
Degenerate cycle types (for n = 6: (6,2), (4,2,2), ...) have forms with common zeros for every lambda: special
points, like Movasati's.
```

**Conditions.** The Fermat engine (period power series).

**Evidence.**

Night run: two independent implementations (main thread and agent B, exact); Lean: lean/core/ObstructionCert.lean
(ob3 lambda = -8 lambda (lambda - 1) for every rational lambda), lean/core/ObstructionCert8.lean.

**Independent check.** No C-number. Two implementations in the night run; AI referee's own exact check at Fermat.

**Not established.** The Lean files certify the finite computations, not the Griffiths-Dwork bridge to periods.

**Known before.**

Duque Franco-Villaflor Loyola arXiv:2312.17222, Section 5 (machine-read in the night run; not in
tests/SOURCES.md): at the Fermat point the quadratic fundamental form does not vanish for c = 1 and unequal
coefficients, and vanishes for Movasati's pairs. The symbolic-lambda table: not found in the sources we read
(machine-read, see tests/SOURCES.md); not checked further.

**Reproduce.**

Run from the repository root (Macaulay2 1.22). lean/run_all.sh core (needs Lean 4.36.0; files
lean/core/ObstructionCert.lean and lean/core/ObstructionCert8.lean; about 6 minutes for all 13 core files).
First-order numbers at the eightfold pair: see the snippet in D-CUBIC-EIGHTFOLD-INVARIANT.

**Session references (files not public).**

LEDGER.md "Night, entries after 05:45Z", "Night, entries after 06:10Z" (agent B, TABLE.md), "Night, entries after
06:28Z".

---

## D-FERMAT-LINEAR-CYCLES-SPAN

**Fermat varieties: for which (dimension, degree) the linear cycles span all Hodge classes (night-run counts)**

kind: `result` | area: `fermat_expansion` | status: **`EXACT`**

**Statement.**

Recorded in the night-run ledger as checked, with exact arithmetic: on the Fermat variety of dimension n and
degree d the classes of linear subspaces span all Hodge classes for (n,d) = (4,3), (4,4), (4,5), (4,7), (4,11),
(4,13), (6,3), (6,4), (6,5), and not for d = 6, 8, 9, 10, 12, ... (the ledger does not list the dimensions for the
second statement: not determined from the sources). For Fermat fourfolds: Hodge characters outside Shioda's
inductive structure first appear at d = 25, and outside Aoki's standard cycles at d = 32, 33. The ledger lists as
an open target "Fermat fourfolds of degree 32/33: new cycles needed for the listed characters"; nothing more was
done on it.

**Conditions.**

The combinatorial description of Hodge classes of Fermat varieties by characters and the period formula for linear
cycles; neither was re-derived in the sources read for this registry.

**Evidence.**

Night run, first phase: scripts in the session folder fermat/ (results_table.md, shioda_check.out), labelled
CHECKED and '(exact)' in the ledger. The numbers themselves were not re-read for this registry.

**Independent check.** none

**Not established.**

Anything about which of the remaining Hodge classes are algebraic. This entry is outside the three targets of the
discovery round and was never revisited.

**Known before.**

Classical results of Shioda and Aoki are named in the ledger; no source was read for them and they are not in
tests/SOURCES.md. Relation of these counts to the literature: not determined from the sources.

**Reproduce.**

not reproducible from this repository: the counting scripts are session files. Needed: the character count of
Hodge classes of a Fermat variety and the rank of the period matrix of all linear subspaces (the package computes
periods of linear spaces with fermatPeriodPolynomial but has no function for the full Hodge-class count).

**Session references (files not public).** LEDGER.md "Facts" (first two items), "Open targets (ranked)" (item 3); session folder fermat/.

---

## D-TENFOLD-PRODUCT-POINTS

**Tenfold lead: exact structure at product points C(w,z) + c_1(p) + c_2(q); the cubic model is a determinant; two period identities on the rank-one locus**

kind: `result` | area: `movasati_conjecture` | status: **`PAPER_ARGUMENT_AI`**

**Statement.**

```text
(a) Framework (PROVED, AI, unreviewed; short): a cubic tenfold has h^{7,3} = 1, so for an integral class delta the
Hodge locus is the critical locus of W_delta(F) = int_delta Res(Omega/F^4) (Euler relation), with Hessian
delta(HK) on R_3. Near a general point of F_T (one extra kernel direction t) the reduced function is t^N h(t,s) or 0:
either a smooth codim-54 component with tangent T F_T + G_e, or F_T with multiplicity N-1 and G_e obstructed at
order N-1 (N >= 5 by the registry's orders 2 and 3, MOD p).
(b) Product points X_0 = C(w,z) + c_1(p) + c_2(q), C a cubic fourfold containing Pi = {w = 0}, c_1, c_2 isomorphic
plane cubics, class [J(Pi, T_phi)] (EXACT, by hand, from the tensor decomposition of the Jacobian ring): Hessian rank
38, kernel 182, normal kernel to the cone locus = the 27 directions z_k p_i q_j. Periods multiply:
W(F_0 + H) = (beta x gamma)(exp(-H)); on the elliptic side << S (x) T >> = div(S) pi(T) - pi(S) div(T).
(c) Cubic term on tensors (EXACT, by hand, for c_1 = c_2 = h_lam; ratio 1/3 checked MOD p): Delta(M) =
f_beta(nu(M(z))) with nu(B) = -2 det(B'), B'_{(i+j),(i-j)} = b_ij. Its critical cones are the two Segre cones of
rank-one B' (dimension 11): tensors alpha X_1 + beta X_2 + gamma X_3 in Hesse form with (alpha:beta:gamma) free; F_T
is the curve h_lam(alpha,beta,gamma) = 0. Hessian corank at Hesse tensors 11 = 10 + 1 (MOD 32003, 31991; 3 runs),
the registry's 16 = 27 - 11.
(d) Period identities for rank-one B' = u (x) x, x not on the curve (MOD p): K1 << exp(-B) >> = 0 through degree 18
(32003) and 15 (31991); K3 << p0p1p2 exp(-B) >> = -exp(-c) through degree 12 (both primes), with
c = h_lam(x) h_lam(u) / (27 (1 + lam^3)) (cubic term EXACT, symbolic over QQ(lam)). Controls: generic B nonzero;
rank two nonzero, its degree-6 term depending only on the adjugate.
(e) First order at a general point of F_T in nine variables: S/(I_V + J) = k[z,p,q]/(I_V8, dF_8/dp, dF_8/dq, Phi);
Hilbert function (1, 9, 33, 57, 42, 12, 1), pairing rank 54 (MOD 32003, 31991): the registry's 54 by a 20-second
computation. With a mu_3-graded completion the extra direction is invariant and has a z-cubic component.
```

**Conditions.**

```text
(a), (b), (c) are hand derivations by an AI, read once; numbers MOD p as stated. K1 and K3 have no proof. The class at
the product points is [Pi] x [graph], which at the Fermat fourfold is not Movasati's class [P1] - [P2] (different
annihilator in degree 2); the Fermat-point computations of O-TENFOLD-CONE-LEAD are not re-derived here.
```

**Evidence.**

leads/TENFOLD_COBLE_LEAD.md sections 1-4; scripts leads/tenfold_coble/c1_general_point.m2, c1b_graded_completion.m2,
d1_cubic_model.m2, k1_rank_one_vanishing.m2, k2_rank_two.m2, k3_exponential.m2, s1_closed_form_c.m2.

**Independent check.**

The same blind check (BC-COBLE): K1 PASS for m <= 5 and K3 PASS for m <= 4 at 12 rank-one instances (own Python
implementation, two primes), with the alternatives c -> -c, 2c and c without its denominator rejected;
nu = -2 det(B') confirmed at 24 instances and by hand. NOT blind-checked: (a), (b), the corank 11 in (c), and (e)
(which reproduces the 54 of O-TENFOLD-CONE-LEAD by another route and so is itself a cross-check of that entry).

**Not established.**

Proofs of K1 and K3; a geometric reason for them (the expected one is D-TENFOLD-COBLE-FAMILY); the reduced potential
beyond the cubic term; that product points are general enough for conclusions about W.

**Known before.**

Thom-Sebastiani / Shioda-Katsura structure of sums: rStation #11 (u/lelong_ridge) and classical; Griffiths residues;
3x3x3 tensors and elliptic curves (Hesse normal form, classical); the superpotential description of Hodge loci for
Calabi-Yau fourfolds is standard in the physics literature (not checked against a source). The numbers 38, 27, 16,
54: O-TENFOLD-CONE-LEAD (at the Fermat point and at random points of F_T).

**Reproduce.**

```text
From leads/tenfold_coble/:
    M2 --script c1_general_point.m2 32003 1
    M2 --script d1_cubic_model.m2 32003 1
    M2 --script k1_rank_one_vanishing.m2 32003 2 6
    M2 --script k3_exponential.m2 32003 7 4
    M2 --script s1_closed_form_c.m2
```

**Session references (files not public).** Session of 25 Nov 2026 (Claude Fable 5.2, chat); leads/TENFOLD_COBLE_LEAD.md.

---

## D-TENFOLD-FERMAT-THREE-PLANE-FAMILY

**A 3-parameter family of cubic tenfolds through the Fermat tenfold (Fermat plus a Heisenberg trilinear term): it lies in the Coble family, and the three-plane class stays Hodge on it (AI proof, unreviewed)**

kind: `result` | area: `fermat_expansion` | status: **`PROVED_AI_UNREVIEWED`**

**Statement.**

Coordinates of the Fermat cubic tenfold X_0: r_k = x_(2k), y_k = x_(2k+1), p_i = x_(6+2i), q_i = x_(7+2i) (indices
mod 3). The three 5-planes P_zeta = {r_k + y_k = 0, p_i = zeta q_i}, zeta^3 = -1, pairwise meet in the same P^2.
delta = [P_zeta] - [P_zeta'] (Movasati's class), kappa = h^5 - [P_z1] - [P_z2] - [P_z3] (the three-plane class).
M_x = sum_{i,j} x_(i-j) y_(i+j) p_i q_j;  X_x: F_0 + M_x = 0.

```text
(1) (EXACT, by hand; checked EXACT at x = (3,15,18)) The section of X_x by each of the 27 P^8 {r_k = -theta_k y_k},
theta_k^3 = 1 + h_0(x)/27, is the Coble normal form of D-TENFOLD-COBLE-FAMILY with lam = 0, a = -h_0(x)/27; at
x = (3,15,18), theta = 7 its singular locus is a surface of degree 18 with Hilbert polynomial 9 n^2. So X_x is in
the Coble family.
(2) (PROVED, AI, unreviewed) For every x with X_x smooth and every path from 0, the flat transport of kappa is a
Hodge class on X_x, not a multiple of h^5. Proof: a group Gamma' of order 162 acts on every X_x and fixes kappa;
the Gamma'-invariant part of H^10 has Hodge numbers (0, 1, 10, 1, 0) (EXACT), its (6,4) line is spanned by
Res((P - Q) Omega / F^5), P = p_0 p_1 p_2, Q = q_0 q_1 q_2; (P - Q) dM_x/dx_d lies in the Jacobian ideal for
generic x (EXACT: 30 explicit elements of the ideal, rank computations at 5456 integer points and a degree
bound), so that line is flat; kappa is orthogonal to it at x = 0, hence everywhere, and by invariance to all of F^6.
(3) (EXACT, finite order) The period equations of kappa along F_0 + tau M_x vanish identically in x for all orders
n <= 15. This is implied by (2). Every one of these sums is forced by a reflection symmetry or by (2): the run was
planned as a test of D-TENFOLD-COBLE-CYCLE-CLASS and turned out to have no teeth as such (control K4).
(4) (MOD p, two primes, finite order) The combinations of the 924 eigenclasses of type (5,5) of X_0 that stay of
type (5,5) along F_0 + tau M_x identically in x form a space of dimension 220, stable from order 4 to order 12; it
contains the 8-dimensional span of the 27 classes kappa_theta.
```

**Conditions.**

The proof in (2) is by an AI and unreviewed; its two computational inputs are exact; the blind checker judged it
sound and noted that it applies to every invariant rational Hodge class (a 10-dimensional space), not only to
kappa. It uses the symmetry of this family only: it says nothing about tenfolds outside the family and does not use the Coble cubic or
D-TENFOLD-COBLE-CYCLE-CLASS. (4) is finite order, MOD p, and the 220 classes other than the kappa_theta were not
identified. The class kappa(x) is algebraic if D-TENFOLD-COBLE-CYCLE-CLASS holds (ARG); this entry does not show it.
Not a statement about the Hodge conjecture.

**Evidence.**

leads/tenfold_coble/fermat_point/ (b_membership.m2, t_invariants.py, t_ks_grid.py, fp_main.py, fp_diag.py, logs/);
leads/TENFOLD_COBLE_LEAD.md sections 13.1-13.3.

**Independent check.**

Blind check 5 (26 Nov 2026; a separate agent given the statements only, not the code or the numbers; its own two
period engines, numpy MOD p and python-flint EXACT over QQ, and its unedited report:
leads/tenfold_coble/blind_check5/). Its answers agree with every item:
first order: kappa yes, identically in x; delta no for general x (EXACT, x symbolic; it adds: tangent for delta
exactly when x_1 + x_2 = 0). Membership at x = (3,15,18): yes, a = -342, surface of degree 18, 9 n^2 (EXACT).
The group: order 162, invariants 0, 1, 10, 1, 0, degree 3 spanned by P - Q (EXACT, two methods). The identity
(P - Q) dM/dx_d in the Jacobian ideal: EXACT over QQ(x) by its own determinant-grid proof (36 x 36 block, 37^3
points), at 7 rational points and over QQ(s) on a line; (P + Q) dM/dx_d not; P - Q not in the ideal for any x.
The proof on the symmetric family: judged sound, with eight points that each need a sentence (all taken into
section 13.3); it notes the argument gives the same for every invariant rational Hodge class (a 10-dimensional
space). Symmetric family: zero identically in x to order 18 (EXACT). The arc with no symmetry, with its own random
data: all period equations of kappa vanish to order 10 (2 data sets), 9 (2), 8 (4), each at two primes
(2147483629, 2147483587), and EXACTLY over QQ to order 7 (1 data set) and 6 (1). Variants, without being told the
orders: no term 3 a lam Y: fails at 4; h_0 in place of h_lam: 5; no factor 1 + lam^3: 7; theta = 1: 4; delta in
place of kappa: 1. Found by it and then replicated here: among all 924 eigenclasses the combinations that survive
along the arc to order n have dimension 704, 484, 264, 44, 1 for n = 1..5, and the last is the line of kappa.
Its caveats: a coordinate-change arc passes for ANY class, so that gate validates the reduction and the signs, not
the period polynomial of a plane (it pinned that separately, exactly); on the plane x_1 + x_2 = 0 each single plane
class persists, so tests there are uninformative; orders n = 1 mod 3 of the symmetric test are empty sums. Not
checked by it: the closed period formula and Griffiths' description (taken from the literature); orders above 10;
algebraicity of the transported class. Disclosure by it: it saw file names under leads/ in a directory listing and
opened none.

**Not established.**

A human reading of the proof. The identity (P - Q) dM/dx_d in the Jacobian ideal has no conceptual proof here, only
the exact certificate; a Groebner basis over QQ(x) did not finish in 25 minutes. What the 220-dimensional space is.
Algebraicity of kappa(x).

**Known before.**

Hodge classes forced by symmetry and constant sub-variations are standard tools; Thom-Sebastiani cubic tenfolds are
the subject of rStation paper #11 (u/lelong_ridge, machine-read 24 Nov 2026; its theorems concern the 6 + 6 split,
not this family). Not searched further.

**Reproduce.**

```text
From leads/tenfold_coble/fermat_point/ (Python 3 with numpy and python-flint; Macaulay2 1.22):
    M2 --script b_membership.m2            (1 min)
    python3 t_invariants.py                (seconds)
    python3 t_ks_grid.py                   (15 s)
    python3 fp_main.py exact 15            (1.5 min);   python3 fp_diag.py 12;   python3 fp_main.py classes55 12 67108837
```

**Session references (files not public).** Session of 25-26 Nov 2026 (Claude Fable 5.2, chat), fifth part.

---

## D-TENFOLD-COBLE-FERMAT-ARCS

**Explicit arcs of the Coble family through the Fermat tenfold, with no symmetry and no free terms: the three-plane class satisfies all period equations to orders 10-12 (MOD p); every change to the Coble relation fails at the predicted order**

kind: `result` | area: `fermat_expansion` | status: **`MOD_P`**

**Statement.**

Coordinates of the Fermat cubic tenfold X_0: r_k = x_(2k), y_k = x_(2k+1), p_i = x_(6+2i), q_i = x_(7+2i) (indices
mod 3). The three 5-planes P_zeta = {r_k + y_k = 0, p_i = zeta q_i}, zeta^3 = -1, pairwise meet in the same P^2.
delta = [P_zeta] - [P_zeta'] (Movasati's class), kappa = h^5 - [P_z1] - [P_z2] - [P_z3] (the three-plane class).
M_x = sum_{i,j} x_(i-j) y_(i+j) p_i q_j;  X_x: F_0 + M_x = 0.

```text
With P = p_0 p_1 p_2, Q = q_0 q_1 q_2, Y = y_0 y_1 y_2, lam = lam_1 tau, x = tau xi,
a = -h_lam(x) / (27 (1 + lam^3)), theta^3 = 1 - a, theta(0) = 1, and quadrics phi_0, phi_1, phi_2:
    F_tau = F_0 + 3 lam (P + Q) + 3 a lam Y + M_x + sum_k (r_k + theta y_k) tau phi_k.
The section of F_tau by the P^8 {r_k = -theta y_k} is the Coble normal form a h_lam(y) + h_lam(p) + h_lam(q) + M_x of
D-TENFOLD-COBLE-FAMILY (EXACT, by hand), so the arc lies in the Coble family; for random xi, lam_1 and random sparse
phi_k it has no symmetry, and all its terms are prescribed. Pre-registered (leads/tenfold_coble/fermat_point/
PREREG_fermat.md, sections 3 and 4) with the orders at which the controls should fail.
Results (MOD 67108837 and 67108819; engine tooling/fermat_series with its table of plane coefficients replaced by
kappa): all 221 period equations of kappa vanish
  - lam_1 = 0 (H): orders 1..12 (seed 1), 1..11 (seeds 2, 3), both primes; a denser arc (33 terms) 1..8;
  - lam_1 random (H'): orders 1..11 (seed 1), 1..10 (seeds 2, 3), both primes; a denser arc (47 terms) 1..6.
Controls, identical at every seed and prime: theta = 1, or the sign of h_0(xi) flipped: fail at order 4; the term
3 a lam Y left out: order 4; h_0(x) in place of h_lam(x): order 5; the factor (1 + lam^3) left out: order 7 (all as
predicted); the quadrics multiplied into r_k + 2 y_k: order 1; class P1 - P2 or P1 - P3: order 1; one eigen-sign of
kappa flipped: order 2.
Validity gate: on arcs F_0(g_tau x) (explicit coordinate changes, outside the engine's squarefree slice) all
equations vanish to order 5 and fail at order 3 with flipped signs; on the arc H the engine agrees with a
separate dictionary implementation on all 221 equations, orders 1..5.
Which classes survive (found by the blind checker, replicated): among all 924 eigenclasses of type (5,5) of X_0, the
combinations whose period equations vanish along the arc H' to order n form a space of dimension 704, 484, 264, 44,
1 for n = 1..5 (MOD p; seeds 1, 2); the last is the line of kappa. So up to a factor kappa is the only class of the
Fermat tenfold that survives along such an arc.
```

**Conditions.**

MOD p, two primes, the listed arcs; finite order (evidence, not proof). The validity gate with coordinate changes
passes for any class, so it validates the series and the signs, not the table of the class; that table is fixed by
the first-order test and, independently, by the blind checker. The arcs end at the cone point lam = 0,
x = 0 of the family, with sections of one normal form and sparse quadrics phi_k; they do not test the whole
family. About the three-plane class kappa only: nothing here tests Movasati's class (C-TENFOLD-FERMAT-POINT-CLASS).
The period formula and the engine are the previous agent's (closed-form Fermat periods; O-TENFOLD-CONE-LEAD).

**Evidence.**

leads/tenfold_coble/fermat_point/ (fp_engine.py, run_arcs.sh, run_arcsl.sh, logs/arcs_*.log, logs/arcsl_*.log,
logs/gate_*.log, logs/ref_*.log); leads/TENFOLD_COBLE_LEAD.md section 13.4.

**Independent check.**

Blind check 5 (26 Nov 2026; a separate agent given the statements only, not the code or the numbers; its own two
period engines, numpy MOD p and python-flint EXACT over QQ, and its unedited report:
leads/tenfold_coble/blind_check5/). Its answers agree with every item:
first order: kappa yes, identically in x; delta no for general x (EXACT, x symbolic; it adds: tangent for delta
exactly when x_1 + x_2 = 0). Membership at x = (3,15,18): yes, a = -342, surface of degree 18, 9 n^2 (EXACT).
The group: order 162, invariants 0, 1, 10, 1, 0, degree 3 spanned by P - Q (EXACT, two methods). The identity
(P - Q) dM/dx_d in the Jacobian ideal: EXACT over QQ(x) by its own determinant-grid proof (36 x 36 block, 37^3
points), at 7 rational points and over QQ(s) on a line; (P + Q) dM/dx_d not; P - Q not in the ideal for any x.
The proof on the symmetric family: judged sound, with eight points that each need a sentence (all taken into
section 13.3); it notes the argument gives the same for every invariant rational Hodge class (a 10-dimensional
space). Symmetric family: zero identically in x to order 18 (EXACT). The arc with no symmetry, with its own random
data: all period equations of kappa vanish to order 10 (2 data sets), 9 (2), 8 (4), each at two primes
(2147483629, 2147483587), and EXACTLY over QQ to order 7 (1 data set) and 6 (1). Variants, without being told the
orders: no term 3 a lam Y: fails at 4; h_0 in place of h_lam: 5; no factor 1 + lam^3: 7; theta = 1: 4; delta in
place of kappa: 1. Found by it and then replicated here: among all 924 eigenclasses the combinations that survive
along the arc to order n have dimension 704, 484, 264, 44, 1 for n = 1..5, and the last is the line of kappa.
Its caveats: a coordinate-change arc passes for ANY class, so that gate validates the reduction and the signs, not
the period polynomial of a plane (it pinned that separately, exactly); on the plane x_1 + x_2 = 0 each single plane
class persists, so tests there are uninformative; orders n = 1 mod 3 of the symmetric test are empty sums. Not
checked by it: the closed period formula and Griffiths' description (taken from the literature); orders above 10;
algebraicity of the transported class. Disclosure by it: it saw file names under leads/ in a directory listing and
opened none.

**Not established.**

That the Coble family lies in the Hodge locus of kappa (finite order only; the argument is D-TENFOLD-COBLE-CYCLE-CLASS,
unreviewed). Orders above 12 (memory). Dense quadrics phi_k above order 8. Arcs ending at other points of the cone
locus. Anything about delta.

**Known before.**

O-TENFOLD-CONE-LEAD (previous agent): finite-order arcs at the same tenfold for Movasati's class, to order 12, with
correction terms solved for at each order. Here the arcs are members of a named family and nothing is solved for.

**Reproduce.**

```text
From leads/tenfold_coble/fermat_point/ (Python 3 with numpy; a C++ compiler for tooling/fermat_series; about 6 GB
of memory for order 12):
    python3 fp_engine.py gate 67108837 5;   python3 fp_engine.py ref 67108837 1 5
    ./run_arcs.sh;   ./run_arcsl.sh         (a few minutes each)
```

**Next step.** An explicit arc of the Coble family ending at the Fermat cone with Movasati's marking (C-TENFOLD-FERMAT-POINT-CLASS).

**Session references (files not public).** Session of 25-26 Nov 2026 (Claude Fable 5.2, chat), fifth part.

---

## D-TENFOLD-CONE-POINTS-TWO-DET

**Tenfold two-determinant family and V_Z: at cone points over the sixfold divisor D its class is +-([P1] - [P2]), conditional on the sixfold identification (cone map applied twice); exact cone arc to order 9; no smooth honest member carries a two-plane class**

kind: `result` | area: `movasati_conjecture` | status: **`PAPER_ARGUMENT_AI`**

**Statement.**

```text
Question (D-TENFOLD-TWO-DET-HODGE-LOCUS, item (4)): does the closure of the family T2S of cubic tenfolds
l_1 Q_1 + l_2 Q_2 + det A + det B (codimension 52, class delta_2 = [T5] - 3h^5) meet V_Z (two 5-planes meeting in a
P^2) at a point where the class is +-([P1] - [P2])?
Notation: a tenfold of V_Z is F = f^T M h + sum p_l s_l; Mbar = M|Pi a net of 3 x 3 matrices on Pi = P1 n P2,
sbar_l = s_l|Pi. A cone point over a cubic sixfold c(y0..y7) is X_c = c + l_1 Q_1 + l_2 Q_2 (the section
l_1 = l_2 = 0 is the cone over c with vertex a line).
(1) (ARG; one step is T3's, D-LAMBDA2-CONE-TYPE.) Cone map: for c and X_c smooth, blowing up the vertex line gives
a P^2-bundle over the sixfold mapping to X_c; pull-back and push-forward give a morphism of Hodge structures
H^6 -> H^10 sending [V] to [cone over V] and h^3 to h^5. So if c moves in the Hodge locus of gamma, X_c moves in
that of cone(gamma) (one direction only). T3's one-step pairing formula (cone a, cone b) = -2 (a, b) + deg a deg b
gives 4 (a, b) - deg a deg b for two steps: norms -12 -> 24 -> -48 and T.T = 15 -> 51 -> -21, the number counted
independently in D-TENFOLD-TWO-DET-CLASS. A general X_c is not an iterated one-step cone; the two-step formula
holds at members that are (e.g. Fermat) and extends by flatness of the cone map.
(2) (MOD p, two instances.) Honest cone members (A, B in y0..y7 only) are smooth points of T2S with the numbers of
a general member: S/(l, Q, I_2(A), I_2(B)) has Hilbert function 1,10,35,52,35,10,1 and contains the Jacobian
ideal; the tangent codimension of the Hodge locus of [T5] is 52; the two rank <= 1 loci meet the P^9 in the
vertex line with multiplicity 36. These members form a family of codimension 72 (parameter count).
(3) (ARG.) At every smooth cubic literally of the form l_1 Q_1 + l_2 Q_2 + det A + det B the ideal
I = (l, Q, I_2(A), I_2(B)) is Gorenstein with that Hilbert function (smoothness forces the rank <= 1 loci to meet
the P^9 in a curve on which Q_1, Q_2 have no common zero), I lies in the annihilator of delta_2 and delta_2 is
not zero, so I is the annihilator (a proper quotient of an Artinian Gorenstein algebra kills the socle) and the
Hodge locus of delta_2 has tangent codimension 52 there. For two 5-planes the Hodge locus of [P1] - [P2] has
tangent codimension at most 40 (also: two linear forms annihilate delta_2, three annihilate a two-plane class).
Hence delta_2 is never +-([P1] - [P2]) at a smooth honest member: a meeting point of the kind asked for is a
limit, and this statement says nothing at limits. On sixfolds the same argument (no linear form annihilates the class of
an honest sum; the hyperplane spanned by the planes annihilates [P1] - [P2]) shows that no smooth honest sum
carries +-([P1] - [P2]), which sharpens "special cubics of D may be honest sums" in
D-GENERAL-CUBIC-OF-D-IS-LIMIT.
(4) (ARG, on the first-order rule of paper 3.) A second branch through a point of V_Z needs det Mbar in
(sbar_1, sbar_2, sbar_3), one condition (a divisor D_10 of V_Z). Cone points over any sixfold of V_Z^(6) satisfy
it: Mbar = z_0 C and sbar_3 is a multiple of z_0^2.
(5) (CONDITIONAL.) Assume (S) = D-W-MINUS1-IS-TWO-DET-CLOSURE: near a general point of the sixfold divisor D the
second component W_(-1) is an open piece of the closure of {det A + det B}, with class +-([P1'] - [P2']). Then
for every c in D (D is closed: also the points with C = 0) X_c lies in V_Z and in the closure of T2S, and the
class of T2S there is +-([P1] - [P2]). So the closure of T2S is a second component of the Hodge locus of
[P1] - [P2] at these points, a locus of codimension 73, as det A + det B is along D on sixfolds and
l Q + det A + det B at X1 on eightfolds. Examples on the Fermat tenfold: the pair
P1 = {x0 = z x1, x2 = z x3, x4 = z x5, x6 = z x7, x8 = z x9, x10 = z x11},
P2 = {x1 = -x2, x3 = -x4, x0 = -x5, x6 = z x7, x8 = -x9, x10 = z x11} (type [6T 2T 2F 2T], the double cone of
T2's pair), and Movasati's pair (the double cone of the sixfold Movasati pair, where C = 0).
(6) (EXACT, package Fermat engine.) At the first of these pairs: the first-order map of P1 - P2 has rank 38, the
joint persistence codimension is 39 (excess 1; the same rank for P1 + P2). T3's exported arc
six_lam-1_arc.txt (an eightfold arc in the variables x0..x5, x8, x9), read as an arc of cubic tenfolds, has all
221 period functions of P1 - P2 vanishing at orders 1..9; its T_1 is in ker L and not tangent to the locus where
P1 persists; for P1 + P2 the arc fails at order 1. So the Hodge locus of [P1] - [P2] at this point of V_Z
contains an arc leaving V_Z to order 9.
```

**Conditions.**

```text
(5) is conditional on (S), a paper chain of team T2 (supported MOD p along one arc by D-DEGENERATION-ALONG-ARC and
D-RANK-INVARIANT; the matrices along the arc were never recovered, O-RECOVER-MATRICES-AND-LIMIT-OF-T). (1), (3),
(4) are arguments by an AI, unreviewed; (3) uses the Gorenstein property of I at every smooth member and that I
annihilates delta_2 (D-TENFOLD-TWO-DET-HODGE-LOCUS; proof corrected by the blind check); (4) uses paper 3
(AI-written, unreviewed). (2) MOD p at (32003, seed 1) and
(31991, seed 2). (6) EXACT over Q(zeta_6), finite order: evidence for an arc, not a proof of a component, and not
independent of the eightfold statement (along such an arc the tenfold period functions are the eightfold ones
times constants).
```

**Evidence.**

leads/tenfold_twodet/PREREG_vz.md (theory T1-T5 and predictions P1-P3, written before the runs; all three as
predicted), vz1_fermat_cone_arc.m2, vz2_honest_cone_member.m2, logs/vz/. Write-up: leads/TENFOLD_TWODET_LEAD.md,
section 7.

**Independent check.**

Blind check 10 (26 Nov 2026; a separate agent given the claims only; own Macaulay2, Singular and Python code,
including its own exact implementation of the Fermat period formula; it read nothing under leads/ or
discoveries/). (6) CONFIRMED exactly by both the package and its own code: 221 forms, orders 1..9, for P1 - P2;
failure at order 1 for P1 + P2, P1, P2; ranks 38, 39, 20, 20; T_1 as stated; the sign convention checked against
intersection numbers. Its judgement: (6) is a formal consequence of the eightfold statement (it verified the
identity value by value), so the tenfold arc tests the implementation, not the mathematics; only the ranks are
new at the tenfold level. (2) CONFIRMED at two seeds (ZZ/32003), with the socle (dimension 1, degree 6), the
perfect pairing in degree 3, and smoothness by three Groebner routes (Macaulay2 F4, Singular). (3) SOUND IN
SUBSTANCE, with a corrected proof of the step "Ann(delta_2) = I at every smooth member": the ideal is contained
in the annihilator by a limit argument (or directly: I(T) + J annihilates [T] for each of the 36 row / column
variants of T5, and these ideals sum to I), the class is not zero, and a proper quotient of an Artinian Gorenstein
algebra kills the socle; what carries the step is the Gorenstein property, not the Hilbert function. It notes a
shorter route (Ann_1 has dimension 2 for delta_2 and at least 3 for a two-plane class), that the P^2 hypothesis
is not used, and that the statement holds only for cubics literally of this form, not for limits (so it cannot
separate the closure of the family from a component of the Hodge locus of [P1] - [P2]). (1) SOUND: the one-step
pairing formula proved for all classes, (cone a, cone b) = (1 - d)(a, b) + deg a deg b, two steps giving
4 (a, b) - deg a deg b; its caveat, taken into the write-up: a general c + l_1 Q_1 + l_2 Q_2 is not an iterated
one-step cone, and the two-step formula extends from the members that are by flatness. (4), (5) were not in its
brief as claims; (5) is conditional by construction. Report: leads/tenfold_twodet/blind_check10/REPORT.txt.

**Not established.**

```text
(S) itself, hence the answer "yes". That the nets of quadrics along T2's sixfold arc are nets of minors (numbers
only). Whether T2S meets V_Z at points that are not cone points, or at cone points over the eightfold locus.
The dimension of the component of the Hodge locus that contains the cone-type family, without (S): between 52
(first order) and 72. Characteristic 0 for (2). Nothing about the Hodge conjecture: delta_2 is the class of an
algebraic cycle.
```

**Known before.**

The cone map, the Thom-Sebastiani formula for the Jacobian ring, the cone-type families and the cone pairing:
team T3 (D-LAMBDA2-CONE-TYPE, D-CONE-DICTIONARY) and rStation papers #5 and #11 (u/lelong_ridge; cone families,
Thom-Sebastiani points). The arc: T3's export. The sixfold statement and the plane lemma: team T2. New here: the
second application of the cone map, the connection with the tenfold two-determinant family, item (3), the exact
tenfold run. Literature not searched.

**Reproduce.**

```text
From the repository root (Macaulay2 1.22):
    M2 --script leads/tenfold_twodet/vz1_fermat_cone_arc.m2 first        (about 25 s; exact)
    M2 --script leads/tenfold_twodet/vz2_honest_cone_member.m2 32003 1   (about 75 s; MOD p)
Expected lines: leads/tenfold_twodet/logs/vz/vz1_exact.log, vz2_32003_seed1.log.
```

**Next step.**

Replace (S) by a computation: recover A(eps), B(eps) along T2's sixfold arc (O-RECOVER-MATRICES-AND-LIMIT-OF-T);
the same matrices give explicit degenerations onto the eightfold point X1 and onto the tenfold cone points.
Held for the owner's decision (several hours).

**Session references (files not public).** Session of 26 Nov 2026 (Claude Fable 5.2, chat), tenth part (owner: 'Yes begin' on whether the tenfold two-determinant family meets V_Z with the class [P1] - [P2]).

---

## D-TENFOLD-ORDER4-MODEL-CONE

**Tenfold Movasati point: special nets of rank 2 (a 13-dimensional piece) and of rank 3 pass order 4; a model cone of 27 quadrics; the order-5 obstruction on the 13-dimensional piece is removable for lambda = -1 and 2**

kind: `result` | area: `movasati_conjecture` | status: **`MOD_P`**

**Statement.**

```text
Setting: the Fermat cubic tenfold with Movasati's pair (P1: x_(2i) = z x_(2i+1) for all i; P2: x_(2i) = -x_(2i+1)
for i < 3, x_(2i) = z x_(2i+1) for i >= 3), the class [P1] + lambda [P2]. First-order deformations inside V_Z map
onto the 27-dimensional space of nets N = z_0 A + z_1 B + z_2 C of 3 x 3 matrices (the net of a deformation
sum N_ijk f_i h_j z_k is N; f_i = x_(2i) - z x_(2i+1), h_i = x_(2i) + x_(2i+1), z_k = x_7, x_9, x_11).
Model (a conjecture by analogy with T3's eightfold result D-EIGHTFOLD-BOUNDS-AT-MOVASATI-POINT): the order-4
forms of the dependent equations are y^2 times the 27 coefficients of z_i z_j (i < j) in the 2 x 2 minors of N.
(1) (By hand; decomposition computed by the blind check over ZZ/32003, same Hilbert series over QQ.) The zero set
V_4 of the 27 quadrics has exactly six components and the quadrics generate a radical ideal: three linear pieces of dimension 9 (one
matrix invertible, the other two zero); the two Segre cones of dimension 11 (all of rank <= 1 with a common column
or a common row direction); and a piece of dimension 13: the three matrices have a common kernel vector and a
common cokernel vector, and their 2 x 2 blocks are pairwise orthogonal for the polar form of det (degree 540;
the Segre cones have degree 45). Jacobian ranks at random points: 14, 16, 18 on the pieces of dimension 13, 11, 9.
(2) (MOD p; order 4 is the first non-zero order here, so the outcome does not depend on lower terms.) With
T_1 = y_0 + (deformation with net N), y_0 a cubic in x_0..x_5 in ker L and not tangent to V_Z:
  generic N of rank 3, and generic N with a common cokernel vector (rank 2): obstructed at order 4;
  N in either Segre cone: order 4 passes;
  N in the 13-dimensional piece (rank 2), two samples: order 4 passes;
  N = z_0 C' with C' invertible (rank 3), and with C' of rank 2 (the cone-type direction): order 4 passes.
The same for lambda = -1 at (32029, seed 1) and (31981, seed 2), and for lambda = 2 at (32029, seed 1).
(3) (MOD p: lambda = -1 at (32029, seed 1) and (31981, seed 2), lambda = 2 at (32029, seed 1); a direction of the
13-dimensional piece.) With the package's own T_2, T_3, T_4 the arc is
obstructed at order 5. The map k -> (change of the order-5 obstruction vector when T_2 is replaced by T_2 + k),
k over the 27 net directions, has rank 14 (the Jacobian rank of the model on that piece), three random elements
of ker L add nothing to its image, and the obstruction vector lies in the image: the obstruction is removable,
for lambda = -1 and for lambda = 2. With the corrected T_2 the package's default continuation is obstructed at
order 6 in both cases; removability at order 6 was not tested. The cone-type direction passes order 5 without
correction (lambda = -1).
(4) (Consequence, IF the model is the full set of order-4 forms.) Every component of the Hodge locus at this
point other than V_Z has dimension at most dim V_Z - 14 + 1, i.e. codimension at least 52. 52 is the codimension
of the two-determinant family (D-TENFOLD-CONE-POINTS-TWO-DET), as the same count gives 8 on sixfolds and 26 on
eightfolds.
```

**Conditions.**

```text
(2), (3): the package's Fermat engine over ZZ/p (p = 1 mod 6), finite order. The model is supported by (2) at
eight types of direction and by the rank 14 in (3); it is not proved, and (4) depends on it. (1): the hand
classification is checked only through membership and Jacobian ranks at random points (see independent_check).
```

**Evidence.**

leads/tenfold_twodet/PREREG_vz.md (T6, P4-P6; P6 added before the order-5 runs), vz3_order4_model_cone.m2,
vz4_order4_movasati.m2, vz5_order5_removability.m2, logs/vz/. Write-up: leads/TENFOLD_TWODET_LEAD.md, section 7.4.

**Independent check.**

Blind check 10 (as above). (1) CONFIRMED and sharpened: the hand argument is correct and complete; the 27 quadrics
generate a radical ideal with exactly six components, of dimensions 13, 11, 11, 9, 9, 9 and degrees 540, 45, 45,
1, 1, 1 (decomposition by saturation over ZZ/32003, the 13-dimensional ideal prime; the same Hilbert series over
QQ and modulo 3, 5, 7, 101, 32003; point counts over F_3, F_5, F_7 equal to the count predicted by the
classification); the rank <= 1 part is exactly the two Segre cones; Jacobian ranks 14, 16, 18 as stated;
characteristic 3 need not be excluded. (2)-(4), the runs at the Movasati point, were NOT given to the checker:
they are checked only by repetition at a second prime and seed.

**Not established.**

That the order-4 forms are exactly the model quadrics. Existence of a component of codimension 52 at this point:
order 5 only; order 6 open; lambda = 2 is not separated from -1 at order 5 (on eightfolds the separation is at
order 5, D-X1-ORDER5-FORMULA; T6 saw it at order 6 for a rank-1 direction). Exact arithmetic. Other points of
V_Z.

**Known before.**

The eightfold model: team T3. The tenfold first-order structure, the 27-dimensional space of nets and the Segre
directions: team T6 (O-TENFOLD-CONE-LEAD), which recorded "rank 2 and 3 obstructed at order 4". The
13-dimensional piece and the tests on it were not found in the registry. Literature not searched.

**Reproduce.**

```text
From the repository root (Macaulay2 1.22):
    M2 --script leads/tenfold_twodet/vz3_order4_model_cone.m2 32003 1                 (2 s)
    M2 --script leads/tenfold_twodet/vz4_order4_movasati.m2 32029 1 -1 4              (about 2.5 min)
    M2 --script leads/tenfold_twodet/vz5_order5_removability.m2 32029 1 -1 d          (about 25 min)
Expected lines: leads/tenfold_twodet/logs/vz/.
```

**Next step.**

UPDATE 26 Nov 2026 (later): order 6 was run, D-TENFOLD-MOVASATI-ORDER6: it passes for lambda = -1 and is obstructed
for lambda = 2 modulo the first-order corrections tested. Earlier text:
Order 6 on a direction of the 13-dimensional piece, for lambda = -1 and 2: the order-6 vector modulo the image of
rank 14 and modulo the first-order changes of T_2 along the 13 tangent directions of the piece (about 15 runs of
4 minutes per lambda and prime). A proof or a full computation that the order-4 forms are the model quadrics
(27 x 27 coefficient extraction on a basis of nets).

**Session references (files not public).** Session of 26 Nov 2026 (Claude Fable 5.2, chat), tenth part (owner: 'Yes begin' on whether the tenfold two-determinant family meets V_Z with the class [P1] - [P2]).

---

## D-TENFOLD-MOVASATI-ORDER6

**Tenfold Movasati point, a direction of the 13-dimensional piece: order 6 passes for lambda = -1 (by a change of T_3) and is obstructed for lambda = 2 modulo the first-order corrections tested**

kind: `result` | area: `movasati_conjecture` | status: **`MOD_P`**

**Statement.**

```text
Setting and notation: D-TENFOLD-ORDER4-MODEL-CONE (Fermat cubic tenfold, Movasati's pair, T_1 = y_0 + a
deformation whose net lies in the 13-dimensional piece of the model cone; D = the order-5 map on first-order
changes of T_2, of rank 14). T_2 is first corrected so that order 5 holds. On the smooth germ Sigma the order-6
condition is Psi_6 + DPsi_5[tau_2] + (1/2) D^2 Psi_4[tau_2, tau_2] + DPsi_4[tau_3] = 0: tau_3 moves the order-6
vector by Im D, and tau_2 may still be changed by elements of ker D.
(1) (MOD 32029, seed 1.) lambda = -1: the order-6 obstruction vector of the package's default continuation is not
zero, and it lies in Im D. So it is removed by a change of T_3; checked directly: with T_2 and T_3 corrected the
arc passes fermatVerifyArc to order 6 (all 221 forms). The package's default continuation of that arc is
obstructed at order 7; whether that is removable was not tested.
(2) (MOD 32029, seed 1, the same T_1.) lambda = 2: the order-6 vector does not lie in Im D. Its changes under
T_2 -> T_2 + k were computed for k over the 13 net directions tangent to the piece, for y_0, and for 6 random
elements of ker L made D-free: every one of these changes lies in Im D (the rank stays 14), so the order-6
vector is not in Im D plus their span. Modulo the first-order corrections tested, the direction is obstructed at
order 6 for lambda = 2.
(3) So the directions of the 13-dimensional piece separate lambda = -1 from lambda = 2 at order 6 (at order 4
and 5 they do not). T6 found the same order for a rank-1 direction at lambda = 2 (O-TENFOLD-CONE-LEAD); on
eightfolds the separation is at order 5 (D-X1-ORDER5-FORMULA).
Both outcomes were predicted before the runs (PREREG_vz.md, section 6, P7a and P7b).
```

**Conditions.**

One prime, one seed, one direction; the package's Fermat engine. (2) is "modulo first-order corrections": the
changes of T_2 that were tested are 20 directions of ker D, not all of it (ker D has dimension 168; that the
random ones add nothing supports, and does not prove, that none does), and arcs with a different leading term or
with fractional powers of eps are not covered. (1) is a finite-order statement.

**Evidence.**

leads/tenfold_twodet/vz6_order6.m2, logs/vz/vz6_32029_seed1_lam-1.log (stopped by hand after (1): the further
directions are not needed when the vector is already in Im D), logs/vz/vz6_32029_seed1_lam2.log,
vz6b_verify_order6.m2 and logs/vz/vz6b_32029_seed1_lam-1.log (the corrected arc verified to order 6);
leads/tenfold_twodet/PREREG_vz.md, section 6; leads/TENFOLD_TWODET_LEAD.md, section 7.8.

**Independent check.**

None (one prime, one seed, one direction, by the same family of scripts as D-TENFOLD-ORDER4-MODEL-CONE). The
predictions were written before the runs (PREREG_vz.md, section 6).

**Not established.**

A second prime and a second direction. Orders 7 and higher for lambda = -1. That a component of codimension 52
exists at this point (finite order). For lambda = 2: obstruction for every arc (see conditions).

**Known before.**

The method (removability modulo first-order corrections) and the order-6 obstruction at lambda = 2 on a rank-1
direction: team T6, O-TENFOLD-CONE-LEAD. The 13-dimensional piece: D-TENFOLD-ORDER4-MODEL-CONE.

**Reproduce.**

```text
From the repository root (Macaulay2 1.22; primes must be 1 mod 6):
    M2 --script leads/tenfold_twodet/vz6_order6.m2 32029 1 -1 6     (about 20 minutes to the first RESULT line)
    M2 --script leads/tenfold_twodet/vz6_order6.m2 32029 1 2 6      (about 1.5 hours)
```

**Next step.**

UPDATE 26 Nov 2026 (night): done further by another route, D-MOVASATI-POINT-ARC-ORDER8 (directions with C = 0,
through the eightfold and the cone map: order 8 for lambda = -1 at one prime, 7 at a second; lambda = 2
obstructed at order 6 at both). A direction with C non-zero is still at order 6. Earlier text:
A second prime and seed for both lambda. Order 7 for lambda = -1: the default continuation is obstructed there;
the test is the same scheme one order up (changes of T_4 by Im D, of T_3 and T_2 inside the kernels).

**Session references (files not public).** Session of 26 Nov 2026 (Claude Fable 5.2, chat), eleventh part (owner: 'queue this work up').

---

## D-SIXFOLD-ARC-ORDER19

**The sixfold arc of T2 into the divisor D, exactly to order 19: T_8..T_19 are determined uniquely; the certificate's T_8, T_9 are not on the continuing arc**

kind: `result` | area: `fermat_expansion` | status: **`EXACT`**

**Statement.**

```text
Setting: Fermat cubic sixfold, the pair of D-RANK-CONTRAST-EXACT-ARCS (P1 = {{0,1,1},{2,3,1},{4,5,1},{6,7,1}},
P2 = {{1,2,3},{3,4,3},{0,5,3},{6,7,3}} in the package's notation), class [P1] - [P2], the arc of
D-DEGENERATION-ALONG-ARC read in the sixfold variables y0..y7 (x0..x5, x8, x9 of the exported eightfold file
six_lam-1_arc.txt). F_eps = sum y_i^3 - sum eps^n T_n. EXACT over QQ(zeta_6).
(1) Every term of the arc lies in the span of nine monomials: y0y1y6, y0y2y6, y0y3y6, y0y4y6, y1y3y6, y2y4y6 (the
terms T_n with n = 1 mod 3), y0y6y7 (n = 2 mod 3), y0y1y3, y0y2y4 (n = 0 mod 3). None contains y5: every cubic
of the arc is y5^3 + Phi_eps(the other seven variables).
(2) Keep T_1..T_7 of the certificate, put unknown coefficients on these monomials from T_8 on, and normalise the
coefficient of y2y4y6 in the arc to eps (it is 1 in T_1 and 0 afterwards). Then the Hodge-locus equations of
order <= 19 (the 8 x 19 matrix of fermatExpansion) determine T_8..T_19 uniquely. The equations of order n alone
do not determine T_n (the first-order map is singular on this slice; with equations to order 12 one coefficient
of T_12 is still free): the system closes up at the orders n = 1 mod 3.
(3) The determined T_8 and T_9 differ from those of the certificate file. The certificate is still correct as a
certificate (its expansion to order 9 is zero); a finite-order certificate fixes its last terms only modulo
later equations. For anything that needs the arc beyond eps^7, use the file of this entry.
(4) The Taylor coefficients (orders 0..19) of the periods of all 330 quartic monomials along this arc were
exported exactly: the class functional on R_4 modulo eps^20.
```

**Conditions.**

The package's Fermat engine (fermatExpansion with a ring that has parameters, then linear algebra on the
coefficients). Uniqueness is inside the nine-monomial slice with the stated normalisation and with T_1..T_7
fixed; it says nothing about arcs with other monomials or other leading terms. Finite order: an arc to order 19
is evidence for, not a proof of, a convergent arc.

**Evidence.**

leads/tenfold_twodet/matrices/mx3_extend_arc.m2 (stages 13 and 19), arc_true_order19.txt, mx3b_verify_arc.m2
(RESULT lines: 19 terms; the first seven equal to the certificate's; T_8, T_9 not equal; the 8 x 19 expansion is
zero; the certificate's own expansion to order 9 is zero), mx0_export_periods.m2, periods_deg4_order19.txt;
leads/tenfold_twodet/matrices/PREREG_matrices.md (step 0); leads/TENFOLD_TWODET_LEAD.md, section 8.1.

**Independent check.**

Blind check 12 (a separate agent; exact Python code of its own with python-flint: the period functional derived
from scratch, the Griffiths-Dwork reduction on the Fermat cubic written by hand; it did not read my scripts):
all 8 x 19 Taylor coefficients are zero; negative controls (adding a small term to T_3, T_12, T_19 gives a first
non-zero coefficient at exactly that order); T_1..T_7 equal to the certificate's, the certificate has T_8 = 0 and
other coefficients in T_9; nine monomials, none with y5. Its code also reproduces periods_deg4_order19.txt
completely (330 quartics, orders 0..19: 6600 entries, no mismatch, up to the one overall constant -81 z). The
package call was repeated separately. Not checked by it: the uniqueness statement (2), which is my run only.
Shared with the package: the period formula for linear spaces and the pole-order description of the Hodge locus.
leads/tenfold_twodet/blind_check12/REPORT.md (C1).

**Not established.**

Convergence of the arc; orders beyond 19; uniqueness outside the slice. That the arc lies in the divisor D or in
the closure of the two-determinant family is the subject of D-DEGENERATION-ALONG-ARC and
D-ARC-SPLITTING-NUMERICAL, not of this entry.

**Known before.**

The arc to order 25 modulo p and its certificate to order 9: team T2 (D-DEGENERATION-ALONG-ARC,
D-RANK-CONTRAST-EXACT-ARCS). That fermatExtendArc cannot continue this arc order by order: the probe recorded in
leads/TENFOLD_TWODET_LEAD.md, section 7.9. That the certificate file agrees with a true arc only modulo eps^8 and
cannot be continued to order 10 was already recorded in the conditions of D-RANK-CONTRAST-EXACT-ARCS (check C20
of the frozen run); item (3) repeats it and I had not credited it. New here: exact terms to order 19 in
characteristic 0 and the uniqueness statement.

**Reproduce.**

```text
From the repository root (Macaulay2 1.22):
    M2 --script leads/tenfold_twodet/matrices/mx3b_verify_arc.m2                      (2.5 minutes)
To regenerate (FILE must not exist at the first call):
    M2 --script leads/tenfold_twodet/matrices/mx3_extend_arc.m2 13 FILE              (20 seconds)
    M2 --script leads/tenfold_twodet/matrices/mx3_extend_arc.m2 19 FILE              (2 minutes)
    M2 --script leads/tenfold_twodet/matrices/mx0_export_periods.m2 OUT FILE 19      (6 minutes)
```

**Next step.**

Order about 30 if the second matrix is attacked by lowering the noise (see D-ARC-SPLITTING-NUMERICAL); the
engine's cost grows steeply (order 13: 1 minute, order 19: 6 minutes for the 330 periods).

**Session references (files not public).** Session of 26 Nov 2026 (Claude Fable 5.2, chat), twelfth part (owner: 'queue this work up'; 'Go ahead').

---

## D-MOVASATI-POINT-ARC-ORDER8

**Movasati's own point, a direction that is not a cone over a sixfold: [P1] - [P2] stays Hodge to order 9 along an arc (eightfold; the tenfold by the cone map); with the same first-order term lambda = 2 is obstructed at order 6**

kind: `result` | area: `movasati_conjecture` | status: **`MOD_P`**

**Statement.**

```text
Setting: Fermat cubic eightfold, Movasati's pair of 4-planes (P1: x_(2i) = z x_(2i+1) for all i; P2: the roots
z^3 on the first three pairs), meeting in the line with coordinates x_7, x_9; first order: rank L = 19, joint
persistence 20 (D-EIGHTFOLD-BOUNDS-AT-MOVASATI-POINT). T_1 = y_0 + sum N_ijk f_i h_j x_(7+2k): y_0 the excess
direction, the net N = A y_1 + B y_2 with A, B both non-zero of rank 2, common kernel and cokernel, 2 x 2
blocks orthogonal for the polar form of det (a generic point of the 11-dimensional piece of T3's order-4
model cone). Such a direction is not a cone over a sixfold direction.
Method: T_n (n >= 2) in a slice = 19 monomials on which L is injective + 7 net directions on which the 26 x 7
response matrix D is injective. With the earlier terms fixed, the order-n obstruction is affine in the free part
of T_(n-3) with the fixed matrix D (measured: rank 7 = 18 - 11 on the 18 net directions, D(y_0) = 0, linear, the
same at orders 5 and 6). In the slice the arc is unique: an order is either repaired by the free part of T_(n-3)
or obstructed.
(1) (MOD 32029, seed 1.) lambda = -1: orders 5 to 9 are repaired, by the free parts of T_2, ..., T_6; the arc
of 8 terms and the arc of 9 terms each pass fermatVerifyArc with the 45 period functions. T_6, T_7, T_8 of the
9-term arc differ from those of the 8-term arc, as the method requires (they are fixed only by later orders).
(2) (MOD 31981, seed 2: another direction.) lambda = -1: the same to order 7.
(3) (MOD 32029 seed 1 in two slices; MOD 31981 seed 2.) lambda = 2 (its own y_0, the same nets): order 5 is
repaired, the order-6 obstruction is not in Im D. Obstructed at order 6 in these slices. Stronger, by the blind
check (both primes; exact linear algebra plus polynomial identities tested at random points): with this T_1 no
choice of T_2, ..., T_6 in the full space of cubics satisfies orders 2 to 6.
(4) (MOD 32029.) The 8-term arc of (1), read on the Fermat cubic TENFOLD with x_10, x_11 untouched, passes
fermatVerifyArc to order 8 with the tenfold's own 221 period functions at Movasati's pair of 5-planes (rank
L = 38 against 39; T_1 in ker L, not tangent to the locus where P1 persists); for [P1] + [P2] it fails at
order 1. On the tenfold this is a direction of the 13-dimensional piece of D-TENFOLD-ORDER4-MODEL-CONE with
C = 0 and A, B non-zero: a cone over the eightfold arc (so this item is automatic and adds no evidence), not a
double cone over a sixfold direction.
(5) Reading. For lambda = -1: the highest order to which [P1] - [P2] is known to stay Hodge off V at Movasati's
own point, in a direction that is not a cone over a sixfold, goes from 6 (the tenfold run
D-TENFOLD-MOVASATI-ORDER6: one prime, a direction with C non-zero) to 9 at one prime and 7 at a second prime
and direction (directions with C = 0). For lambda = 2: no
component of dimension at least dim V - 6 has such a T_1 in its tangent cone, and no component of any dimension
has a tangent cone reduced and smooth there (ARG on (3)); smaller components with a non-reduced tangent cone at
T_1 and arcs with fractional powers are not excluded.
The package's default continuation stops at order 5 for both lambda; that stop is removable and says nothing.
```

**Conditions.**

```text
Two primes carrying two different directions (no direction was run at two primes); the package's Fermat engine
and, for the checks, an independent implementation. T_1 is special inside the 94-dimensional candidate tangent
cone: it has no component along the 64 directions tangent to V that are neither nets nor cubics in x_0..x_5, so
for lambda = -1 the evidence is at such directions only. The reading (5) for lambda = 2 is an argument on (3).
(4) is not independent of (1): along a cone arc the tenfold period functions are the eightfold ones times
constants (Thom-Sebastiani). The free parts of the last three terms of each arc file are placeholders, fixed
only by later orders. Everything is a finite-order statement: evidence, not a proof that a component exists;
it is equally consistent with an obstruction at a later order.
```

**Evidence.**

leads/movasati_arc/ma1_probe.m2, ma2_slice_arc.m2, ma3_cone_to_tenfold.m2; logs/ma1_32029_seed1_lam-1_order8.log,
ma1_32029_seed1_lam2_order8.log, ma2_32029_seed1_lam-1_d.log, ma2_31981_seed2_lam-1_d.log,
ma2_32029_seed1_lam2_d.log, ma2_32029_seed1_lam2_d_slice2.log, ma2_31981_seed2_lam2_d.log,
ma2_32029_seed1_lam-1_d_order9.log, ma3_tenfold_32029_seed1_lam-1_order7.log,
ma3_tenfold_32029_seed1_lam-1_order8.log; arcs/arc8_*.txt and arcs/arc9_32029_seed1_lam-1_d.txt (the terms);
PREREG_arc.md (predictions Q0, Q1, M1, M2 written before the runs; one change of the slice recorded);
leads/TENFOLD_TWODET_LEAD.md, section 9.

**Independent check.**

Blind check 13 (a separate agent; its own implementation of the period formula in Python with python-flint,
adapted from the code of blind check 12, and the package only as a black box; it read none of my scripts or
logs): (1), (2) confirmed with own code to order 8 and 7, and the 9-term arc to order 9; the nets of T_1
confirmed (rank 2, common kernel and cokernel, no y_1 y_2-term, A and B not proportional); (4) confirmed with
own code on 221 forms, with the remark that it is automatic; (3) confirmed in my slice and strengthened to the
full space of cubics (see (3)); control: for lambda = -1 every admissible T_2 continues through order 6.
Corrections it made, worked into this entry: "not a cone" must read "not a cone over a sixfold"; my statement
that the obstruction is affine in the free part of T_(n-3) was incomplete; the reading for lambda = 2 needs
"reduced as a scheme"; T_1 is special in the candidate cone; no direction at two primes. Shared with the
package: the closed period formula and the assumption that the 45 periods cut out the Hodge locus. Nothing exact.
leads/movasati_arc/blind_check13/REPORT.md.

**Not established.**

UPDATE 27 Nov 2026: in characteristic 0 on a direction in general position, D-MOVASATI-POINT-EXACT-SEPARATION.
There it was also found that on directions aligned with the coordinates lambda = 2 is NOT obstructed at order 6,
so item (3) here holds for directions in general position (the random nets used), not for all. Earlier text:
That a second component exists at Movasati's point (finite order). Anything exact: characteristic 0 is the
next step. Orders beyond those stated. A direction with C non-zero beyond order 6. That the arc lies in the
closure of the two-determinant family (the paper chain D-X1-COMPONENT-IS-TD-CLOSURE + D-GLOBAL-ARGUMENT predicts
such arcs; the arc does not test the identification). For lambda = 2: components of smaller dimension, arcs
with fractional powers of eps. Nothing here concerns a class that is not algebraic: on the paper chain this
component carries the class of an algebraic cycle.

**Known before.**

T3: the order-4 model on eightfolds and the cone map (D-EIGHTFOLD-BOUNDS-AT-MOVASATI-POINT, D-LAMBDA2-CONE-TYPE);
a tangent vector unobstructed through order 6 inside a 20-dimensional family at this point (same entry). T6:
removability of obstructions modulo first-order corrections (O-TENFOLD-CONE-LEAD). The tenfold run to order 6
(D-TENFOLD-MOVASATI-ORDER6). The paper chain that predicts the component (D-X1-COMPONENT-IS-TD-CLOSURE,
D-GLOBAL-ARGUMENT). O-OTHER-COMPONENTS-AT-X1 recorded "no arcs outside the cone-type family" at the eightfold
Movasati point. New here: the reduction of tenfold directions with C = 0 to the eightfold; the transversal
slice in which the arc is unique; orders 7 and 8; the second prime and direction; lambda = 2 obstructed at
this point on such directions.

**Reproduce.**

```text
From the repository root (Macaulay2 1.22; primes must be 1 mod 6):
    M2 --script leads/movasati_arc/ma2_slice_arc.m2 32029 1 -1 8 d 1 /tmp/a.txt       (18 minutes; order 9: 50)
    M2 --script leads/movasati_arc/ma2_slice_arc.m2 32029 1 2 7 d 1 /tmp/b.txt        (5 minutes; stops at order 6)
    M2 --script leads/movasati_arc/ma3_cone_to_tenfold.m2 32029 -1 leads/movasati_arc/arcs/arc8_32029_seed1_lam-1_d.txt 8   (5 minutes)
```

**Next step.**

```text
(0) A generic direction of the candidate cone (T_1 with a general component tangent to V), and one direction at
two primes. (a) Characteristic 0: the same algorithm over QQ(zeta_6), in the symmetric direction A = E01 + E10,
B = E01 - E10 (it passes order 4; a symmetry of order 3 cuts the monomials from 120 to 44). (b) Higher orders
MOD p: each order costs about 3.5 times the last (order 9: 30 minutes); the state files in
leads/movasati_arc/arcs/ can be continued, and the checker's python-flint expansion
(leads/movasati_arc/blind_check13/lib13.py) is about five times faster than the package's. (c) A direction with C non-zero on the tenfold by the same
slice method (27 net directions, rank D = 14). (d) Along the arc: the Hilbert function of the annihilator of
the class (1, 9, 26, 26, 9, 1 would be the two-determinant numbers of D-RANK-CONTRAST-EXACT-ARCS (c)).
```

**Session references (files not public).** Session of 26 Nov 2026 (Claude Fable 5.2, chat), thirteenth part (owner: 'move forward with the next most exciting lead').

---

## D-MOVASATI-POINT-EXACT-SEPARATION

**Movasati's own point in characteristic 0: on one direction in general position lambda = -1 passes order 7 and lambda = 2 is obstructed at order 6 in the slice, exactly; on coordinate-aligned directions lambda = 2 is not obstructed at order 6 (MOD p)**

kind: `result` | area: `movasati_conjecture` | status: **`EXACT`**

**Statement.**

```text
Setting and method: D-MOVASATI-POINT-ARC-ORDER8 (eightfold Movasati point; T_1 = y_0 + net; arc in a transversal
slice of 19 monomials and 7 net directions), now with every choice deterministic (leads/movasati_arc/ma4_exact.m2).
(1) (EXACT over QQ(zeta_6).) Net g in general position: A = G F1 H, B = G F2 H with G = [[1,1,0],[0,1,1],[1,0,2]],
H = [[2,0,1],[1,1,0],[0,1,1]], F1, F2 with top-left blocks [[1,2],[0,1]], [[1,0],[1,1]] (rank 2, polar form 0).
lambda = -1: orders 5, 6, 7 are repaired by the free parts of T_2, T_3, T_4; the 7-term arc passes fermatVerifyArc
exactly (45 forms); for [P1] + [P2] it fails at order 1. lambda = 2 (its own y_0): order 5 repaired, order 6
obstructed in the slice.
(2) (EXACT.) Symmetric net s (A = E01 + E10, B = E01 - E10): lambda = -1 passes to order 9; exact 9-term arc.
(3) (MOD 32029; not predicted.) On nets with common kernel and cokernel along coordinate vectors (s, with the fixed
y_0 and with a random one; and the unmoved net F1, F2) lambda = 2 is NOT obstructed at order 6 in the slice; the
same blocks moved into general position (g), and the random nets of D-MOVASATI-POINT-ARC-ORDER8, are obstructed.
(4) Reading. On this direction the separation of -1 from 2 at order 6 holds in characteristic 0 in the slice (to
order 7 for -1); the full-space version for 2 is MOD p (blind check 14). On the aligned directions lambda = 2 also
goes on to order 6 at least. Whether the dividing line is 'kernel along coordinates' or the position of the net
relative to y_0 (which was not moved with the net) is OPEN. Finite order: evidence, not a proof that a component
exists.
```

**Conditions.**

```text
(1), (2) are exact finite-order statements for one direction each and the stated slice; the lambda = 2 verdict in
(1) is a slice statement (its reading as "no component of dimension dim V - 6 through this direction" is the ARG of
D-MOVASATI-POINT-ARC-ORDER8). (3) is MOD p at one prime, in the slice. Why aligned directions behave differently is
not analysed.
```

**Evidence.**

leads/movasati_arc/ma4_exact.m2, ma5_verify_exact.m2; logs/ma4_exact_lam-1_g.log (stopped by hand during order 8),
ma4_exact_lam2_g.log, ma4_exact_lam-1_s.log, ma5_exact_g_lam-1_order7.log, ma4_32029_lam-1_s.log,
ma4_32029_lam2_s.log, ma4_32029_lam2_f.log, ma4_32029_lam2_g.log, ma2_32029_seed1_lam2_s.log; arcs/exact_*.txt;
PREREG_arc.md (step M3 and the note on s, written before the exact lambda = 2 results); leads/TENFOLD_TWODET_LEAD.md,
section 9.6.

**Independent check.**

Blind check 14 (a separate agent; the package as a black box over QQ(z), and its own python-flint code MOD p; it read
neither ma4_exact.m2 nor the logs): EXACT with the package: the s arc to order 8 and the g arc to order 6 (higher
orders timed out), [P1] + [P2] failing at order 1; the lambda = 2 jet to order 5. MOD p at two primes with own code:
the s arc to order 9, the g arc to order 7; for lambda = 2 on g no T_2..T_6 in the full space of squarefree cubics
passes order 6; on s and on the unmoved net F1, F2, explicit jets through order 6 for lambda = 2, checked directly.
Its corrections, worked in: the full-space obstruction is MOD p, not exact; the aligned/general-position reading
rests on one net g, and a dependence on the position relative to y_0 fits the data equally. Orders 7 (g) and 9 (s)
exactly rest on my own verification run (ma5, logs/ma5_exact_g_lam-1_order7.log; ma4 log for s) only.
leads/movasati_arc/blind_check14/REPORT.md.

**Not established.**

UPDATE 27 Nov 2026 (11:48 UTC): lambda = -1 on net g now EXACT to order 8 (arcs/exact_g_lam-1_order8.txt,
re-verified from scratch). Earlier text:
Orders beyond 7 (g) and 9 (s) exactly; other directions exactly; the full-space version of the lambda = 2
obstruction in characteristic 0 (see independent_check); a component; the meaning of the aligned sub-locus where
lambda = 2 passes order 6, and how far it goes.

**Known before.**

D-MOVASATI-POINT-ARC-ORDER8 (MOD p, random directions) and its blind check 13 (which noted that the tested directions
are special); D-TENFOLD-MOVASATI-ORDER6; D-SIXFOLD-GERM-AT-MOVASATI-POINT (cone-type components for every lambda).
New: characteristic 0; deterministic directions; the aligned directions where lambda = 2 is not obstructed.

**Reproduce.**

```text
From the repository root (Macaulay2 1.22):
    M2 --script leads/movasati_arc/ma5_verify_exact.m2 -1 leads/movasati_arc/arcs/exact_g_lam-1_order7.txt   (10 minutes)
    M2 --script leads/movasati_arc/ma4_exact.m2 0 0 2 6 g 0 /tmp/b.txt      (25 minutes; ends OBSTRUCTED at order 6)
    M2 --script leads/movasati_arc/ma4_exact.m2 32029 0 2 6 s 0             (3 minutes; passes order 6)
```

**Next step.**

Understand the aligned directions: run lambda = 2 on s and f past order 6 (MOD p), and look for a product or cone
structure that explains them (they may be the trace at this point of a family that exists for every lambda). For
the headline: lambda = -1 on g to order 8 or 9 exactly (2 to 6 hours).

**Session references (files not public).** Session of 26-27 Nov 2026 (Claude Fable 5.2 and Claude Opus 5.5, chat), fourteenth part (owner: 'yes go ahead').

---

## D-ALIGNED-POCKET-LAMBDA2

**Movasati's point, lambda = 2 on coordinate-aligned directions: net s passes order 7 in the full space (two primes), net f is obstructed at order 7**

kind: `result` | area: `movasati_conjecture` | status: **`MOD_P`**

**Statement.**

```text
Setting: D-MOVASATI-POINT-EXACT-SEPARATION (eightfold Movasati point; T_1 = y_0 + net; y_0 the excess direction for
lambda = 2). Nets with common kernel and cokernel along coordinate vectors: s (A = E01 + E10, B = E01 - E10) and f
(blocks [[1,2],[0,1]], [[1,0],[1,1]]).
(1) (MOD 32029 and 31981; blind check 15, explicit jets checked directly.) Net s, lambda = 2: there are T_2, ..., T_7
in the full space of squarefree cubics with orders 1..7 satisfied.
(2) (MOD 32029 and 31981; MOD p + ARG, blind check 15.) Net f, lambda = 2: no T_2, ..., T_7 satisfies orders 2..7.
(3) In my transversal slice both s and f were reported obstructed at order 7 at both primes; for s that is false
(see N-SLICE-FALSE-OBSTRUCTION-ORDER7).
(4) Reading: on the symmetric aligned direction lambda = 2 survives to order 7 so far (lambda = -1: to order 9
exactly). OPEN whether it goes on, and whether it is the trace of a family that exists for every lambda.
```

**Conditions.** Two primes; one T_1 per net; integer powers of eps; finite order. (2) rests on structure facts tested at sample points.

**Evidence.** leads/movasati_arc/blind_check15/ (fs7.py, run7*.py, r7*.out, REPORT.md); logs/ma4_*_lam2_*_order8.log; PREREG_arc.md, step 3 and its correction.

**Independent check.** The jets of (1) and the verdict of (2) are the checker's own (blind check 15), contradicting my slice result for s; my own runs agree with (2).

**Not established.** Order 8 and beyond; characteristic 0; other aligned nets; the meaning of the pocket; any component.

**Known before.** D-MOVASATI-POINT-EXACT-SEPARATION (aligned nets pass order 6 for lambda = 2); cone-type families for every lambda (D-SIXFOLD-GERM-AT-MOVASATI-POINT).

**Reproduce.**

```text
From the repository root (Python 3 with python-flint, numpy):
    python3 leads/movasati_arc/blind_check15/run7b.py      (see the REPORT for arguments; about 8 minutes per case)
```

**Next step.** Order 8 in the full space for net s (extend fs7.py by one order), then the pre-registered splitting test (PREREG_arc.md, step 3).

**Session references (files not public).** Session of 27 Nov 2026 (Claude Opus 5.5, chat), fifteenth part (owner: 'Go ahead').

---

## D-ALIGNED-POCKET-ORDER8

**Movasati's point, lambda = 2 on the symmetric aligned direction: jets through order 8 exist (two primes), at the price of 2 conditions per order from order 7 on; for lambda = -1 the corresponding condition vanishes**

kind: `result` | area: `movasati_conjecture` | status: **`MOD_P`**

**Statement.**

```text
Setting: D-ALIGNED-POCKET-LAMBDA2 (net s, lambda = 2, T_1 = y_0 + net). In the full space of squarefree cubics:
(1) (MOD 32029 and 31981.) There are T_2, ..., T_8 with orders 1..8 satisfied: explicit jets, found with the
blind-check-15 reduction extended by one order and verified with the package's fermatVerifyArc; for [P1] - [P2]
the same jets fail at order 1.
(2) (MOD p, structure tested at sample points.) On the set V7 of jets through order 7, the part q8 of ob_8 that
k_5 cannot remove (19 components) spans 2 dimensions, is quadratic in k_2 and independent of k_3 in ker J3 and
k_4 in ker J4. At order 7 the same quantity q7 had rank 2 and was affine (blind check 15). For lambda = -1
(control, net g) q7 vanishes identically.
(3) Reading (ARG): lambda = 2 on this direction loses about 2 dimensions of jets per order from order 7 on; lambda
= -1 loses none. Survival to a given order is weak evidence by itself (two equations on a large space are
generally solvable over an algebraically closed field); the rank of q per order is the informative number.
```

**Conditions.** Two primes, one direction, integer powers of eps, finite order. q8 was probed on one 2-plane per prime; at 31981 a first plane had no F_p point (a field effect). The structure statements of (2) are tested at sample points.

**Evidence.** leads/movasati_arc/run8_full_space_order8.py; logs/run8_32029_s_lam2_seed3.log, run8_31981_s_lam2_seed5.log (and run8_32029_s_lam2_signbug.log, run8_31981_s_lam2.log: a fixed sign error and a plane without F_p point); ma6_verify_jet.m2, logs/ma6_*_s_lam2.log; arcs/jet8_*_s_lam2.txt; PREREG_arc.md, step 3b.

**Independent check.** The 8-term jets were verified with the package (Macaulay2), an implementation independent of the Python code that found them. The search itself uses the reduction written by blind check 15. No separate agent re-ran the order-8 search.

**Not established.** Orders 9 and beyond; whether the rank of q stays 2; any component; characteristic 0.

**Known before.** D-ALIGNED-POCKET-LAMBDA2, N-SLICE-FALSE-OBSTRUCTION-ORDER7, blind checks 13-15.

**Reproduce.**

```text
From /home/claude/blind_check15-style setup (the checkers' libraries in leads/movasati_arc/blind_check14/own and blind_check15):
    M2 --script leads/movasati_arc/ma6_verify_jet.m2 32029 2 leads/movasati_arc/arcs/jet8_32029_s_lam2.txt     (5 minutes)
```

**Next step.** The rank of q at orders 9 and 10 (extend the reduction by one order each; about an hour per order MOD p).

**Session references (files not public).** Session of 27 Nov 2026 (Claude Opus 5.5, chat), sixteenth part (owner: 'Go ahead').

---

## D-MOVASATI-POINT-COEFFICIENT-SCAN

**Movasati's point, a direction in general position: among ten coefficients only -1 and +1 pass order 6; they are exactly the two whose lattice half-discriminant (28, 36 on eightfolds) is that of a K3 or an abelian surface**

kind: `result` | area: `movasati_conjecture` | status: **`MOD_P`**

**Statement.**

```text
(1) (MOD 32029, slice; order-6 verdicts for this net confirmed in the full space at lambda = 2 by blind check 14.)
Eightfold Movasati point, net g of D-MOVASATI-POINT-EXACT-SEPARATION: lambda = 2, 3, -2, 1/2, 5/3, -1/2, 4, -1/3 are
obstructed at order 6 (order 5 repaired); lambda = -1 passes (to order 7 exactly); lambda = 1 = lambda_0 passes to
order 6, its order-5 and order-6 constraints vanishing identically. Confirmed in the full space by blind check 16.
(2) (ARG + elementary arithmetic.) With f(m) = (1 - (-2)^(m+1))/3, the lattice <h^4, r P1 + s P2> on the eightfold has
determinant 2 (16 r^2 - 4 r s + 16 s^2); half of it is 28 for (1, 1), 36 for (1, -1), and at least 70 for every other
coprime pair with s != 0. The node mechanism of headline card 2 (D-NODES-DISCRIMINANT-IDENTITY) gives 28 for K3 and
36 for abelian surfaces on eightfolds. So the coefficients that survive order 6 are exactly those for which the rule
offers a K-trivial surface (a match at 2 of 10 sampled values, not a mechanism).
```

**Conditions.** One prime, one direction, the slice solver (reliable at order 6 here; see N-SLICE-FALSE-OBSTRUCTION-ORDER7 for order 7 on). (2) explains the zero set, not the order 6.

**Evidence.** leads/movasati_arc/logs/ma4_32029_lam*_g_scan.log; PREREG_arc.md (A4 pre-registration and outcome); leads/TENFOLD_TWODET_LEAD.md, section 9.8.

**Independent check.**

Blind check 16 (separate agent; its own driver on the python-flint full-space reduction of blind check 14; it read the
logs and notes only after its own results): every coefficient obstructed or passing as in (1), in the FULL space of
cubics at p = 32029, and for lambda = 3, 1/2, 1 also at 31981 and with a second choice of y_0; explicit jets checked
directly for 1 and -1. f(m) derived independently by the excess intersection formula; the determinant and the
values 28, 36, >= 70 confirmed. Its corrections (worked in): the match with K-trivial surfaces is a correlation at 2
of 10 values; "+1 passes without correction" was wrong as worded. leads/movasati_arc/blind_check16/REPORT.md.

**Not established.** Why order 6; other directions and primes; characteristic 0 (except -1 and 2, D-MOVASATI-POINT-EXACT-SEPARATION); a derivation of the obstruction from the lattice data.

**Known before.** D-NODES-DISCRIMINANT-IDENTITY, D-TENFOLD-K3-ABELIAN-PAIRING (the rule); D-MOVASATI-POINT-EXACT-SEPARATION (-1, 2); D-FIRST-ORDER-RULE (lambda_0).

**Reproduce.**

```text
From the repository root:
    M2 --script leads/movasati_arc/ma4_exact.m2 32029 0 3 6 g 0      (6 minutes; OBSTRUCTED at order 6; any coefficient in place of 3)
```

**Next step.** Derive the order-6 obstruction coefficient as a function of lambda (with lambda a parameter of the ring) and compare its zero set with the lattice condition.

**Session references (files not public).** Session of 27 Nov 2026 (Claude Opus 5.5, chat), plan items A4, A5.

---

## D-POCKET-ORDER9-OBSTRUCTION-SIGNAL

**The lambda = 2 pocket at order 9: at the tested order-8 jet no first-order move inside V8 removes the order-9 conditions (MOD p, two primes, one jet); this does NOT by itself signal an obstruction (corrected reading)**

kind: `result` | area: `movasati_conjecture` | status: **`MOD_P`**

**Statement.**

```text
Pre-registered in leads/movasati_arc/pocket/PREREG_order10.md (and its addendum, written before the follow-up run).
MOD p (31981), the V8 jet of run9b (T_1..T_8 verified directly):
(1) q_9 (12 of 19 non-zero) is not in the span of its changes under k_4 in ker J4 (rank 2), so the order-10 route
failed at order 9.
(2) Over first-order moves keeping V8 (k_2 in A2', k_3 in ker J3, k_4 in ker J4, k_5 in ker W5; 17 sampled
directions, symmetric differences for k_2, k_3, k_5), the q_9 changes have rank 4 and q_9 is not in their span.
CORRECTED READING (27 Nov, late): the pre-registered reading "obstruction signal" was wrong. The order-9 conditions
are a map G on V8 with a curved image; G(x0) outside the image of dG at one point does not show that G has no zero
on V8. What stands: the differential of the order-9 conditions along V8 has rank 4 (in the 19 q-coordinates), not
the 2 of the "smooth component of codimension 28" reading, at this jet. The pocket is undecided at order 9.
Same ranks at p = 32029 (165 / 195 / 196), file blind_check20/p32029/run32029.log.
```

**Conditions.** One jet; two primes; first order only (the blind check removes the sampling caveat: all first-order moves).

**Evidence.** leads/movasati_arc/pocket/run10.py, run10_31981.log, run10b.py, run10b_31981.log, REPORT.md (last section).

**Independent check.**

Blind check 20 (separate agent, own C/Python code, about 2 minutes): the COMPLETE linearised test in T-space from
arcs/jet8_31981_s_lam2.txt, with the exact derivative over all 220 cubic monomials (no sampling). c_1..c_8 = 0;
c_9 (T_9 = 0) has 43 of 45 non-zero; rank of the derivative on orders 2..8 is 165, on 2..9 is 195, and 196 with
(0, ..., 0, -c_9): no first-order correction (dT_2..dT_8, T_9) fixes order 9. Controls passed. CONFIRMED.
leads/movasati_arc/pocket/blind_check20/.

**Not established.** That order 9 is obstructed (a finite move along the non-linear V8 could reach q_9 = 0); the second prime; other jets; other first-order directions T_1. Nothing about the Hodge conjecture.

**Known before.** O-ALIGNED-POCKET-LAMBDA2-ORDER9 (run9b: q_9 changes with k_4 with rank 2, linearly); N-SLICE-FALSE-OBSTRUCTION-ORDER7 (a slice gave false obstructions; this test uses the full space).

**Reproduce.**

```text
From a folder holding the checkers' libraries (blind_check14/own, blind_check15), one job at a time:
    python3 run10b.py 31981 s 2 30 5      (about 110 minutes)
```

**Do not repeat.** Do not rerun run10.py's k_4-only route; order 10 needs the order-9 question settled first.

**Next step.** The blind check; then the same test at p = 32029, and a second-order (non-linear) search along V8 for q_9 = 0.

**Session references (files not public).** Session of 27 Nov 2026 (Claude Opus 5.5, chat); owner: 'go ahead' (order 10, cap about 3 h; overrun of about 1 h reported).

---

## D-POCKET-ORDER9-PASSED

**The lambda = 2 pocket passes order 9: a 9-jet with the pocket's tangent exists (MOD p, one prime), found by a non-linear search; order 10 again needs one**

kind: `result` | area: `movasati_conjecture` | status: **`MOD_P`**

**Statement.**

Pre-registered in leads/movasati_arc/pocket/PREREG_order9_nonlinear.md and PREREG_order10_newjet.md.
MOD p (31981). On V8 (8-jets of NL([P1] + 2[P2]) with the pocket's T_1), a generic 2-plane of k_2 moves with q_8 solved
exactly by k_3: modulo the k_4 image the order-9 conditions are 17 polynomials in (s, t), quadratic along a line
(off-grid check passed); they have exactly one common zero, in F_p (Groebner basis). There the remaining order-9
conditions are removed by k_4 and k_6, and T_1..T_9 satisfy all 45 period conditions at every order 1..9, checked
directly twice (run12b.py; main_N.py). The jet is saved as leads/movasati_arc/arcs/jet9_31981_s_lam2.txt.
Second prime (p = 32029, run11p.py, run11_32029.log, run11_groebner_32029.log): the same picture -- quadratic along a
line, values spanning 3 dimensions, off-grid check passed, exactly one common zero (s, t) = (-15886, 2154) in F_p.
(The 9-jet at p = 32029 was not built and verified.)
At the new 9-jet: extra first-order conditions 0,0,0,7,7,9,9,11,13 at orders 2..10, and order 10 is not solvable to
first order. Control: the lambda = -1 arc at the same point has 0,0,0,7,7,7,7,7 and passes order 9 to first order.
Reading: the failure recorded in D-POCKET-ORDER9-OBSTRUCTION-SIGNAL belonged to that jet, not to the direction. The
growing number of conditions per order (2, 2, 4, 6 at orders 7..10) does not fit a smooth component of codimension 28;
what it fits is not known.

**Conditions.**

9-jet built and verified at one prime (31981); the common zero found at both primes; one first-order direction; integer powers of eps; one plane of k_2 moves.
SCOPE (added 28 Nov 2026): this is on cubic EIGHTFOLDS. There the Hodge conjecture in the middle degree is expected
to hold for every smooth cubic: Otwinowska's bound CH_2(X)_Q = Q for cubic hypersurfaces of dimension >= 8 (C. R.
Acad. Sci. Paris 329 (1999) 51-56; quoted in C. Vial, arXiv:1203.2650, section 7.2.2), combined with a Bloch-
Srinivas-type decomposition of the diagonal, as stated in rStation paper #5. The ingredients are LIT; the deduction
for the middle degree is as stated in #5 and has not been checked against one source stating it as a theorem. If it
holds, [P1] + 2[P2] is algebraic wherever it is Hodge on a cubic eightfold, so the pocket can at most be an
unexplained special locus whose class is algebraic; it cannot be a Hodge class not known to be algebraic, which for
this configuration requires cubic tenfolds or higher.

**Evidence.** leads/movasati_arc/pocket/run11.py, run11_31981.log, run11_polys.m2, run11_groebner.log, run12b.py, run12b_31981.log, main_N.py, order10_31981.log, control_lam-1_increments.log; leads/movasati_arc/arcs/jet9_31981_s_lam2.txt.

**Independent check.**

Blind check 22 (separate agent, own code): T_1 equals the pocket's T_1, and c_n = 0 for all 45 Q, n = 1..9; with
lambda = -1 the same jet fails at order 1; perturbing T_5 breaks orders 5 and 6. CONFIRMED.
leads/movasati_arc/pocket/blind_check22/. (The non-linear search itself was not repeated independently.)

**Not established.** Order 10 and beyond; the second prime; characteristic 0; that a component exists; any explanation (geometry) of the pocket; anything about the Hodge conjecture.

**Known before.** O-ALIGNED-POCKET-LAMBDA2-ORDER9; D-POCKET-ORDER9-OBSTRUCTION-SIGNAL (the old jet, corrected reading); N-POCKET-NOT-LINEAR-CYCLES, N-POCKET-LATTICE-FILTER-SMOOTH, N-POCKET-NO-COMPANION-CLASS.

**Reproduce.**

```text
Direct check of the saved 9-jet (about 1.5 minutes; needs a C compiler for the checker's phi.c):
    python3 leads/movasati_arc/pocket/main_N.py 31981 12637 2 leads/movasati_arc/arcs/jet9_31981_s_lam2.txt 9
```

**Next step.** The same non-linear test at order 10 (a 2-plane, or larger if the order-10 image has dimension > 2); the second prime for order 9.

**Session references (files not public).** Session of 27-28 Nov 2026 (Claude Opus 5.5, chat); owner: 'run what you believe would give the best explanation'.

---

## D-POCKET-ORDER10-PARTIAL

**Order 10 of the lambda = 2 pocket: structure at the 9-jet, and no order-10 zero in a 4-dimensional family (MOD p) -- inconclusive, the family is too small**

kind: `result` | area: `movasati_conjecture` | status: **`MOD_P`**

**Statement.**

```text
MOD p (31981), at the verified 9-jet of D-POCKET-ORDER9-PASSED (rebuilt and verified again by fast/run13.py).
(1) q_10 (17 of 19 non-zero) changes LINEARLY with k_5 (rank 2); k_4 moves that keep q_9 do not change it modulo the
k_5 image; k_3 moves that keep q_8 stay on V9 and change it with rank 2, NOT linearly; q_10 is outside these first-order
spans.
(2) On a 6-dimensional family of k_2 moves (q_8 solved by k_3), the order-9 conditions modulo the k_4 image are
quadratic, and their ideal equals the ideal of its 8 linear members: the 9-jets in the family form an affine-LINEAR
4-dimensional space (codimension 2) -- the behaviour of jets of a smooth branch.
(3) On a plane of that space times two k_3 directions (4 variables), the order-10 conditions modulo the k_5 image are
quadratic (off-grid check passed): 8 linear ones (rank 2, consistent) and 7 quadratic ones, generating the unit
ideal: no order-10 zero in this family.
Reading: (2) supports a smooth branch through the 9-jet; (3) is inconclusive (pre-registered caveat: the family is
half of the available freedom).
```

**Conditions.** One prime; one 9-jet; families as stated (6-dim k_2 family for order 9; 4 variables for order 10); first-difference structure tests.

**Evidence.** leads/movasati_arc/pocket/fast/ (fastper.py, run13.py .. run17r.py, logs, run15_q9_31981.m2, run15_groebner.log, run17_q10_31981.m2, look17*.log); REPORT.md, sections 'Order 10'.

**Independent check.** Not repeated by a separate agent (the fast period code was checked against the Python one on test expansions, fast/test_fast.py; the 9-jet itself is blind-checked in D-POCKET-ORDER9-PASSED).

**Not established.** Whether order 10 is solvable (needs the full 8-variable family); the second prime for order 10; that a component exists; any explanation.

**Known before.** D-POCKET-ORDER9-PASSED; WHAT_CYCLE.md (what a cycle on a component would have to be).

**Reproduce.**

```text
Long (hours, one job at a time, from a folder holding the checkers' libraries): run13.py, then run15.py, then run17r.py; quick: the Groebner step
    M2 --script leads/movasati_arc/pocket/fast/look17.m2      (run from leads/movasati_arc/pocket/fast)
```

**Next step.** The full family: u0..u3 on the 9-jet piece and a0..a3 on all four k_3 directions (degree 2, 45 points); then the second prime.

**Session references (files not public).** Session of 28 Nov 2026 (Claude Opus 5.5, chat); owner: 'continue down the most interesting logical path through the night'.
