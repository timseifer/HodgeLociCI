# Movasati's Conjecture 1 and higher-order expansions at Fermat points

- Exact certificates at both Movasati points (lambda = -1, 2, 5/3) show, conditionally, that the full germ of the Hodge locus has no component of dimension dim V + 1 there; this is AI-computed and conditional, and must not be presented as a refutation of a published conjecture.
- Structure of the germ: V doubled plus one component W_lambda on sixfolds; bounds on eightfolds; at the pair X1 the coefficient -1 is special, with an explicit obstruction formula and a rank invariant separating -1, 1 and the other coefficients.
- Identifications of components with explicit families are paper arguments by AI agents, each read once.

> **Status of everything on this page:** produced by AI agents, checked only by other AI agents, reviewed by no human. Sources of published results were read by machine (see `tests/SOURCES.md`). The notes cited as "unreviewed note 1, 2, 3" are AI-written and not public. Nothing here is, or bears on, a proof or disproof of the Hodge conjecture. This is a registry of what was found, ruled out or left open, not a list of established theorems.

Generated from `discoveries/registry.yaml` by `discoveries/check_registry.py --write-pages`. Do not edit this page by hand: edit the registry. Notation: [`NOTATION.md`](NOTATION.md). Status vocabulary: [`README.md`](README.md).

## Entries on this page (16)

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
