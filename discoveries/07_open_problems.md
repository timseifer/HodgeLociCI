# Open problems

- Questions the project left open, each with the single most useful next computation or argument.
- Includes work that was queued and never started (three or more cycles; sextic fourfolds and cubic tenfolds) and the literature and human checks that were not done.
- Status OPEN, STUCK (attempted, blocked) or CONJECTURE (a statement the evidence supports, with gaps).

> **Status of everything on this page:** produced by AI agents, checked only by other AI agents, reviewed by no human. Sources of published results were read by machine (see `tests/SOURCES.md`). The notes cited as "unreviewed note 1, 2, 3" are AI-written and not public. Nothing here is, or bears on, a proof or disproof of the Hodge conjecture. This is a registry of what was found, ruled out or left open, not a list of established theorems.

Generated from `discoveries/registry.yaml` by `discoveries/check_registry.py --write-pages`. Do not edit this page by hand: edit the registry. Notation: [`NOTATION.md`](NOTATION.md). Status vocabulary: [`README.md`](README.md).

## Entries on this page (18)

| id | status | title |
|---|---|---|
| [O-RECOVER-MATRICES-AND-LIMIT-OF-T](#o-recover-matrices-and-limit-of-t) | `STUCK` | Recover the matrices A(eps), B(eps) along the arc into D, the flat limit of T, and D as a family |
| [O-EXACT-VERSIONS-OF-MOD-P-RANKS](#o-exact-versions-of-mod-p-ranks) | `OPEN` | Exact (characteristic 0) versions of the ranks that are known only modulo primes |
| [O-PENCIL-REGIME](#o-pencil-regime) | `STUCK` | Pencil-type points of Sigma_4: does the balanced system (nu ~ tau^2) have a solution at a general point? |
| [O-THIRD-ORDER-PERIOD-FORMULA](#o-third-order-period-formula) | `OPEN` | A third-order pointwise period formula (the next case of the residue formula with squared pairs) |
| [O-OTHER-COEFFICIENTS](#o-other-coefficients) | `OPEN` | Coefficients other than 1 and -1: no explicit cycle or family is known for the second component |
| [O-SEXTIC-FOURFOLDS-CUBIC-TENFOLDS](#o-sextic-fourfolds-cubic-tenfolds) | `OPEN` | Fake linear cycles on sextic fourfolds and cubic tenfolds: not started beyond first-order ranks |
| [O-LITERATURE-CHECK-DET-PFAFF](#o-literature-check-det-pfaff) | `OPEN` | Literature check for the determinantal and Pfaffian descriptions before any novelty claim |
| [O-THREE-CYCLES](#o-three-cycles) | `OPEN` | Special coefficients for three or more cycles (first order: a conic beyond the pairwise lines; it dies at second order) |
| [O-FERMAT-LOOPHOLES](#o-fermat-loopholes) | `CONJECTURE` | Three loopholes at the Fermat quartic sixfold, and the statement with gaps for fake linear cycles |
| [O-E1-GENERAL-POINT-AND-E2](#o-e1-general-point-and-e2) | `STUCK` | Is the cone locus E1 a component of the reduced locus at its general point? What does E2 contain? |
| [O-OTHER-COMPONENTS-AT-X1](#o-other-components-at-x1) | `OPEN` | Eightfolds: exact dimension of the second component for lambda != +-1, and the pair types not computed |
| [O-EXPONENT-OF-LAMBDA-PLUS-1](#o-exponent-of-lambda-plus-1) | `OPEN` | Why is the exponent of (lambda + 1) in the order-5 obstruction at X1 equal to 2? |
| [O-SIGN-AND-PLANE-LEMMA-GAPS](#o-sign-and-plane-lemma-gaps) | `OPEN` | Sign and monodromy of the class of T; the cases (block,block), (skew,*) of the plane lemma; its eightfold version |
| [O-CITED-INPUTS-AND-HUMAN-REVIEW](#o-cited-inputs-and-human-review) | `OPEN` | No human review; the cited analytic inputs were never opened |
| [O-KLOOSTERMAN-THEOREM-14-READING](#o-kloosterman-theorem-14-reading) | `OPEN` | Unresolved reading: Kloosterman's Theorem 1.4 (introduction) against smoothness at lambda = -1 for cubics with c = 2 |
| [O-HODGE-NUMBER-3432](#o-hodge-number-3432) | `OPEN` | Recorded disagreement with a published table: middle Hodge number of the cubic 12-fold, 3432 or 3433 |
| [O-COMMON-ZEROS-AND-SECOND-ORDER-GAPS](#o-common-zeros-and-second-order-gaps) | `OPEN` | Second order: quadrics with common zeros, condition (S) failing, and cubic eightfolds in the package tests |
| [O-PACKAGE-FEATURES-NEEDED](#o-package-features-needed) | `OPEN` | What the package lacks for the entries marked 'not reproducible from this repository' |

---

## O-RECOVER-MATRICES-AND-LIMIT-OF-T

**Recover the matrices A(eps), B(eps) along the arc into D, the flat limit of T, and D as a family**

kind: `open` | area: `explicit_cycles` | status: **`STUCK`**

**Statement.**

Along the arc of D-DEGENERATION-ALONG-ARC only the two cubics G_A, G_B and the two nets of quadrics are known, not
the matrices A(eps), B(eps) with G_A = det A(eps), G_B = det B(eps). Not known either: the flat limit of the
degree-9 threefold T at a cubic of D, its class there (so the paper chain behind D-W-MINUS1-IS-TWO-DET-CLOSURE is
not replaced by a computation), and a description of D as a family: the cubic of D is the eps^0 term of two
determinantal arcs through l^3 that agree up to sign to order 5; the general solution of that condition was not
found. Conjecture of T2: the flat limit of T is supported on a union P_i u Q_j u (X n A) u (X n B) inside the
hyperplane H (one plane as a component, the other only through its residual quadric), with a non-reduced
structure leaving H. The eight reduced unions of this kind have all their cubics inside the limit tangent space
U_0 but the wrong Hilbert function (7, 26, 67 or 7, 25, 64 instead of 8, 30, 76).

**Conditions.** n/a

**Evidence.** Team T2, 18:38Z ([STUCK] items (i)-(iii)); the reading of the leading normal form as a tridiagonal determinant.

**Independent check.** none

**Not established.**

Everything in the statement is open; the conjecture on the support of the limit is not tested beyond the
tangent-space inclusion.

**Known before.** n/a

**Reproduce.** not reproducible from this repository: an open question; the entries it refers to say what can be re-verified.

**Next step.**

Raise the precision: extend the arc well beyond eps^25 so that the nets are known to about eps^20 after the pole
of order 6; then recover one matrix from the product structure of a net over the series field (its rank-4
quadrics, or the two families of P^4's in the determinantal cubic). Alternatively solve the anisotropic ansatz
(weights l: 0, w: 1, y': 3/2; tridiagonal leading matrix) order by order.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T2] 18:38Z", "[COORD] 18:39Z"; END_OF_ROUND_REPORT.md (follow-up 1).

---

## O-EXACT-VERSIONS-OF-MOD-P-RANKS

**Exact (characteristic 0) versions of the ranks that are known only modulo primes**

kind: `open` | area: `methods` | status: **`OPEN`**

**Statement.**

Known only modulo primes at random instances: the tangent codimensions 26 and 27 and the Hilbert functions for the
eightfold family l*Q + det A + det B and the Segre fourfold; the limit computations (proportional classes) on V_6
and Segre cubics; the rank invariant 18 / 12 / 28 on generic arcs; the structure of the germ at both Movasati
points; the table "pair type x lambda" except the row X1; the splitting of the 18 quadrics; all ranks along
Sigma_4 (38, 32, 26, 19) and the inputs of D-CORANK6-STRATA; the ten families. Partly exact already: the
two-determinant numbers at one integer point (the run over Q stopped at its 500 s limit after dimension 112,
codim (I_T+J)_3 = 13, codim (I_T+J)_4 = 1), the flag threefold, the certificates.

**Conditions.** n/a

**Evidence.** END_OF_ROUND_REPORT.md (follow-up 2); the 'not established' lines of checks C12, C13, C15, C17, C19, C20.

**Independent check.** none

**Not established.** n/a

**Known before.** n/a

**Reproduce.** not reproducible from this repository: an open question; the entries it refers to say what can be re-verified.

**Next step.**

For each tangent-codimension claim: one instance with small integer coefficients over Q (hodgeLocusTangentCodim
with CoefficientRing QQ); the rank over Q is at least the rank modulo p, so a matching upper bound (a family of
the right dimension) finishes it, as T2 did for 8. For the arcs: rational reconstruction from two primes plus
exact verification with fermatVerifyArc.

**Session references (files not public).** END_OF_ROUND_REPORT.md; LEDGER_DISCOVERY.md "[T2] 06:08Z" (exact parts).

---

## O-PENCIL-REGIME

**Pencil-type points of Sigma_4: does the balanced system (nu ~ tau^2) have a solution at a general point?**

kind: `open` | area: `fake_linear_cycles` | status: **`STUCK`**

**Statement.**

At a general pencil-type point of Sigma_4 the only undecided regime for an extra branch of the Hodge locus of
3[P1] + [P2] - 3[P4] is nu ~ tau^2: weighted critical points, with nu != 0, of
W_lead = (1/2) Q_(tau tau)(nu, nu) - c(nu)/6 (6 unknowns tau of weight 1, 12 unknowns nu of weight 2, 18 equations
in a 17-dimensional weighted projective space; excess -1). At split points this is: does a graded homomorphism
C[t1,t2,n1,n2]/J_w -> C[v0,v1,v2]/(three cubics) exist that does not kill n, for the explicit polynomial w of
D-PENCIL-REDUCTION-TO-W? Solutions exist on a codimension-4 family of nets (some l^4 in the ideal); none is
expected at a general net, but this is not shown. Also open: the corank-2 surface inside Sing(D) at a general
(non-split) pencil-type point, described by formula at split points only.
A solution would only be the leading term of a possible component of codimension 43 through the pencil-type
stratum, still to be tested at higher order. Status: live question, not a candidate.

**Conditions.** D-PENCIL-TYPE-CLOSED-PART, D-PENCIL-REDUCTION-TO-W.

**Evidence.**

Team T1, rounds 5 and 6; nothing exact finished (N-LOW-DEGREE-CERTIFICATES-PENCIL); the numerical search is
worthless (N-NUMERICAL-RANDOM-START-SEARCH); symmetric degenerations cannot help
(N-SYMMETRIC-DEGENERATION-PENCIL).

**Independent check.** C21 confirmed the reduction to w, not anything about solutions.

**Not established.** Whether solutions exist at a general point.

**Known before.** n/a

**Reproduce.** not reproducible from this repository: an open question; the entries it refers to say what can be re-verified.

**Next step.**

Run an F4-type engine (msolve or Magma; neither was installed in the session) on the split-point system, first on
the two-variable analogue (10 unknowns, 10 equations), at one non-symmetric point modulo a prime below 2^31;
emptiness at one pencil-type point implies emptiness at the general one. Alternative: prove that the incidence
variety {graded homomorphisms C[t,n]/J_w -> R_h} has no component of dimension >= 21 over the 21-dimensional
family of nets.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T1] 19:27Z" (items C, D), "[COORD] 19:33Z"; END_OF_ROUND_REPORT.md (follow-up 3).

---

## O-THIRD-ORDER-PERIOD-FORMULA

**A third-order pointwise period formula (the next case of the residue formula with squared pairs)**

kind: `open` | area: `second_order` | status: **`OPEN`**

**Statement.**

Lemma 2.1 of the unreviewed note 3 gives the first- and second-order period functionals of a complete intersection
as residue symbols (D-POINTWISE-FORMULA). A third-order (and fourth-order) analogue is not known to the session.
It is what blocks: the exact version of "the cone locus E1 is a component of the reduced locus" (non-degeneracy of
the quartic form Psi_S at a general Noether-Lefschetz surface, which needs third-order periods at non-split
surfaces); extra equations for the balanced regime at pencil-type points; and second-order data along strata
without the p-adic or dual-number detour.

**Conditions.** n/a

**Evidence.** Team T1, 16:26Z (item C: why the E1 statement is stuck), 19:27Z (item C.4).

**Independent check.** none

**Not established.** n/a

**Known before.** n/a

**Reproduce.** not reproducible from this repository: an open question; the entries it refers to say what can be re-verified.

**Next step.**

Derive the eps^3 coefficient of the vanishing period functions along F_eps = sum (phi + eps a)(psi + eps b) as in
the proof of Lemma 2.1(3), and test it against the dual-number route (M-DUAL-NUMBER-AND-PADIC-SECOND-ORDER) one
order higher, at a quartic sixfold with four linear P^3.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T1] 16:26Z" (C), "[T1] 19:27Z" (C); END_OF_ROUND_REPORT.md (follow-up 3).

---

## O-OTHER-COEFFICIENTS

**Coefficients other than 1 and -1: no explicit cycle or family is known for the second component**

kind: `open` | area: `explicit_cycles` | status: **`OPEN`**

**Statement.**

For lambda not in {0, 1, -1} (tested: 2, 1/2, -2, 3, 5/3) on cubic sixfolds with two 3-planes meeting in a point,
the second component W_lambda exists where det C = 0 and the class on it is algebraic by the Hodge conjecture for
cubic sixfolds (Steenbrink, LNM 1246; stated for every smooth cubic sixfold as Albano-Collino alg-geom/9308001,
Prop. 2.2; machine-read, Steenbrink not opened), but no explicit cycle and no explicit description of W_lambda is known. Known constraints:
the cycle spans P^7 and lies on no quadric beyond the partials (rank 28); W_lambda is not in the closure of the
sums of two determinants; the cone bridge relates W_lambda to cubic fourfolds in Hassett's divisor C_d,
d = 8r^2 - 2rs + 8s^2 (36 for lambda = 2 and 1/2, 44 for -2). On eightfolds the corresponding component through X1
that contains the cone-type family has dimension dim V - 16; other components are bounded only.
Also untested: at a general point of D, whether T W_lambda = T D + <beta* - lambda alpha*> (seen at one symmetric
Fermat point, D-TANGENT-OF-W-TURNS).

**Conditions.** n/a

**Evidence.** END_OF_ROUND_REPORT.md (Target 2, last item; follow-up 4); N-SUMS-OF-SAME-SHAPE-OTHER-LAMBDA, N-PROJECTED-SCROLLS.

**Independent check.** none

**Not established.** n/a

**Known before.** n/a

**Reproduce.** not reproducible from this repository: an open question; the entries it refers to say what can be re-verified.

**Next step.**

Use the only handle, the rank invariant: compute along a generic arc in W_2 the full Hilbert function of the
annihilator of the class in degrees 3 and 4 (cubics and quartics killing it), to get the numerics a cycle must
have; and try surfaces on a general cubic fourfold of C_36 (as constructed in the literature on special cubic
fourfolds) as hyperplane-section data for a threefold in P^7.

**Session references (files not public).** END_OF_ROUND_REPORT.md; LEDGER_DISCOVERY.md "[T2] 15:43Z" (item (d)), "[T3] 16:42Z".

---

## O-SEXTIC-FOURFOLDS-CUBIC-TENFOLDS

**Fake linear cycles on sextic fourfolds and cubic tenfolds: not started beyond first-order ranks**

kind: `open` | area: `fake_linear_cycles` | status: **`OPEN`**

**Statement.**

Fake linear cycles exist for d = 3, 4, 6 (published, as machine-read). Only quartic sixfolds were studied. For
sextic fourfolds and cubic tenfolds the session has only the first-order ranks of
D-FAKE-TYPE-FIRST-RANKS-OTHER-DEGREES (57 = codim Sigma_6; 30 = codim Sigma_3; discriminant with a residual of
degree 12 for sextics, none for cubic tenfolds). Not examined either: fake cycles with two or more fake factors;
other Pythagorean triples.

**Conditions.** n/a

**Evidence.** END_OF_ROUND_REPORT.md (Target 1, last line); T1 05:25Z (c).

**Independent check.** none

**Not established.** n/a

**Known before.** n/a

**Reproduce.** not reproducible from this repository: an open question; the entries it refers to say what can be re-verified.

**Next step.**

Repeat the quartic-sixfold programme at general points of the strata of Sigma_6 and Sigma_3 (not at the Fermat
point): rank, net of quadrics, cubic, conditions (A), (B) as in D-CORANK6-STRATA.

**Session references (files not public).** END_OF_ROUND_REPORT.md; LEDGER_DISCOVERY.md "[T1] 04:19Z", "[T1] 05:25Z".

---

## O-LITERATURE-CHECK-DET-PFAFF

**Literature check for the determinantal and Pfaffian descriptions before any novelty claim**

kind: `open` | area: `explicit_cycles` | status: **`OPEN`**

**Statement.**

Not checked against the literature: that the closure of {det A + det B} (secant variety of the determinantal
cubics) is a component of a Hodge locus of cubic sixfolds, with the degree-9 scroll T; the description
"reducible cubic + Pfaffian" for equal coefficients; the eightfold family l*Q + det A + det B and the Segre
fourfold; the invariant det C; the rule lambda_0 = (-1)^(c-1); the liaison identity. The existing searches were
finite and machine-read (tests/SOURCES.md says how). No entry of this registry claims novelty.

**Conditions.** n/a

**Evidence.**

END_OF_ROUND_REPORT.md (follow-up 5); note 3, section 'Open points', item 2; check C13 ('Not checked against the
literature').

**Independent check.** none

**Not established.** n/a

**Known before.** n/a

**Reproduce.** not reproducible from this repository: an open question; the entries it refers to say what can be re-verified.

**Next step.**

A person (or an agent with full-text access) reads Kloosterman arXiv:2312.12363 Section 6, Movasati's book
(Conjecture 19.1 and the sections cited in tests/SOURCES.md A5, never opened) and the literature on secant
varieties of determinantal cubics and on special cubic fourfolds (C_14, C_18), and records what is already there.

**Session references (files not public).** END_OF_ROUND_REPORT.md; tests/SOURCES.md (first section, A5); night/paper3/paper3.tex (section "Open points").

---

## O-THREE-CYCLES

**Special coefficients for three or more cycles (first order: a conic beyond the pairwise lines; it dies at second order)**

kind: `open` | area: `first_order` | status: **`OPEN`**

**Statement.**

Question (queued by the user of the session, not started; budget line "three-cycle target: 0 of 12"): for three
complete-intersection cycles Y_1, Y_2, Y_3 (start with three linear spaces on cubic sixfolds and quartic fourfolds,
pairwise meeting as in the ten cases of the list L), consider the Hodge locus of [Y_1] + a[Y_2] + b[Y_3]. Describe
the set of (a, b) where the locus is larger than the obvious one (all three cycles survive). Is it exactly the union
of the lines predicted by the pairwise rule lambda_0 = (-1)^(c-1) (plus coordinate lines), or does a three-way
special coefficient appear that no pair explains? Where extra room appears, is it explained by a residual or
linked cycle?
Already known from the discovery round (three planes pairwise meeting in a point on a cubic sixfold, at a
"triangle" point): the Hodge locus of Pa + Pb + Pc, Pa + Pb - Pc and Pa + 2Pb + 3Pc has tangent codimension 8; of
one plane 4; of two planes 7; the joint kernel has codimension 12; and h^3 + Pa + Pb + Pc is the class of a flag
threefold.

**Conditions.** n/a

**Evidence.** LEDGER_DISCOVERY.md 'QUEUED NEXT TARGET'; D-TRIANGLE-OF-PLANES for the triangle numbers (MOD p, check C4).

**Independent check.** none

**Not established.** Everything: nothing was computed for this target as such.

**Known before.** n/a

**Reproduce.**

Run from the repository root (Macaulay2 1.22). The package already handles three linear spaces at the Fermat point
(first order). Example with the three P^3 of D-FAKE-CLASS-EXPLICIT on the Fermat quartic sixfold:

```
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
S = fermatRing(4, 6); P = m -> {{0,1,2*m-1},{2,3,1},{4,5,1},{6,7,1}};
v = fermatTangentData(S, {P 1, P 2, P 4}, {3, 1, -3}); print(v#"hodgeCodimension", v#"jointPersistenceCodimension");
```

Expected: (19, 38). Nothing for the queued question itself.

**Next step.**

Started 22 Nov 2026 (framework: Kloosterman arXiv:2312.12363, Definition 3.12, "excess tangent dimension at
(a_1 : ... : a_r)", as read by machine; he proves nothing beyond the definitions for r >= 3). First-order scans MOD p,
one instance each: on cubic sixfolds (ten configurations of three 3-planes) and quartic fourfolds (seven) no jump off
the pairwise lines. CANDIDATE, NOT YET INDEPENDENTLY CHECKED: three 3-planes in one P^4 on an explicit quartic
sixfold, where the jump set appears to be the six pairwise lines plus a conic depending on X (exact over QQ at one
instance, by the team that found it). Next: the blind check of that claim; then second order and a geometric
explanation of the conic, if it is confirmed.

**Session references (files not public).**

LEDGER_DISCOVERY.md "QUEUED NEXT TARGET", "[COORD] 05:07Z"; discovery/t4_three_cycles/ (an empty folder at the
time of writing).

---

## O-FERMAT-LOOPHOLES

**Three loopholes at the Fermat quartic sixfold, and the statement with gaps for fake linear cycles**

kind: `open` | area: `fake_linear_cycles` | status: **`CONJECTURE`**

**Statement.**

```text
The statement the evidence supports, NOT a theorem: "near a smooth quartic sixfold X of Sigma_4 close to the Fermat
one, the reduced Hodge locus of delta = 3[P1] + [P2] - 3[P4] is the union of Sigma_4 and the cone loci E1(j),
E2(j,j') (the latter two pass only through special points of Sigma_4)".
Not covered by the direction-by-direction analysis at the Fermat point:
(1) velocities y + k with k in K_Sigma, the 285-dimensional radical inside T Sigma_4 (only the 64 directions of
    J_4 are covered, by invariance under the projective group);
(2) arcs tangent to Sigma_4 (velocity inside T Sigma_4, normal part starting at order s^2) and singular branches
    (zero-velocity arcs): a component whose whole tangent cone lies in T Sigma_4 is invisible to any test on
    directions;
(3) strata of the third-order cone with g, D_1, D_1' nonzero: exact decomposition not done (timed out), only
samples. Further gaps: the pencil-type balanced regime (O-PENCIL-REGIME); the Fermat-type stratum (corank 19) at
its general point: same invariants (19, 7, 14) as Fermat, cubic not analysed, unknown whether the ten families
persist there;
E1 as a component only numerically; the content of E2; completeness of the list of degenerate strata of Sigma_4;
all machine statements are modulo one to three primes.
```

**Conditions.** n/a

**Evidence.**

Team T1, 15:25Z (what the method does not cover), 16:26Z (item D), 19:27Z (item D); END_OF_ROUND_REPORT.md ('Why
it is not a theorem').

**Independent check.** C14 restated loopholes (1), (2) and added that the certificate q cannot close them.

**Not established.** The statement itself.

**Known before.** n/a

**Reproduce.** not reproducible from this repository: an open question; the entries it refers to say what can be re-verified.

**Next step.**

Change of method, as T1 proposed: any extra component B through Fermat meets Sigma_4 in dimension >= 25 inside the
degeneracy locus of the normal Hessian; so treat the general point of each degeneracy stratum (done: conic
divisor, triple strata; open: pencil type, Fermat-type stratum) instead of more directions at Fermat. For the
Fermat-type stratum: compute the critical locus of the reduced cubic (26 quadrics) at one general point with an F4
engine.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T1] 15:25Z", "[T1] 15:32Z", "[T1] 16:26Z" (D), "[T1] 19:27Z" (D); END_OF_ROUND_REPORT.md.

---

## O-E1-GENERAL-POINT-AND-E2

**Is the cone locus E1 a component of the reduced locus at its general point? What does E2 contain?**

kind: `open` | area: `fake_linear_cycles` | status: **`STUCK`**

**Statement.**

```text
E1 (cones with vertex a line over quartic surfaces carrying the divisor class) lies in the Hodge locus and has 24
extra tangent directions along it (D-EXPLAINED-LOCI-E0-E1-E2). Whether they integrate at a general point of E1 is
open. It is equivalent to: the quartic form Psi_S on a 12-dimensional space, attached to the surface S and its
class, has no nonzero critical point for the general surface of the Noether-Lefschetz locus. At split surfaces
(Fermat, f(x0,x1) + g(x2,x3)) Psi_S is degenerate for a structural reason. Numerical evidence only (for an auxiliary
class, three values of the perturbation size) that it is non-degenerate nearby.
E2 (cones over quartic fourfolds carrying a * pt * pt): algebraic through the Hodge conjecture for quartic fourfolds
(recalled from memory in the session, not re-read); its content is not determined; at a random point of the
four-planes locus of quartic fourfolds the tangent rank is 10 < 14.
```

**Conditions.** n/a

**Evidence.** Team T1, 05:55Z (item C), 15:30Z (numeric), 16:26Z (item C: why it is stuck).

**Independent check.** none

**Not established.** n/a

**Known before.** n/a

**Reproduce.** not reproducible from this repository: an open question; the entries it refers to say what can be re-verified.

**Next step.**

Either the third-order period formula (O-THIRD-ORDER-PERIOD-FORMULA), or the p-adic / dual-number trick applied to
second-order periods along a path in the Noether-Lefschetz locus, to get Psi_S at one non-split surface modulo p;
then a Groebner computation for 12 cubics in 12 variables at that point.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T1] 05:55Z", "[T1] 15:30Z", "[T1] 16:26Z" (C).

---

## O-OTHER-COMPONENTS-AT-X1

**Eightfolds: exact dimension of the second component for lambda != +-1, and the pair types not computed**

kind: `open` | area: `movasati_conjecture` | status: **`OPEN`**

**Statement.**

For lambda not in {0, 1, -1} at the pair X1 only bounds are known for components of the Hodge locus other than V and
other than the cone-type family (dimension dim V - 16): dim <= dim V - 7, and <= dim V - 10 if not tangent to V
(order 5, one prime). At the eightfold Movasati point: <= dim V - 7 by D-GLOBAL-ARGUMENT, and a second component of
dimension at least 19 in the slice exists. The pair types [6F 2T 2T] and [4F 2T 2T 2F] were not computed beyond the
first obstruction order; at [4T 4F 2T], [4T 2T 2F 2F] only lambda = 2 and -1 at order 4. No exact (characteristic 0)
version of the rank contrast at the Movasati point; no arcs outside the cone-type family there.

**Conditions.** n/a

**Evidence.** Team T3, 16:33Z, 16:42Z (open / stuck list); D-PAIR-TYPE-TABLE.

**Independent check.** none

**Not established.** n/a

**Known before.** n/a

**Reproduce.** not reproducible from this repository: an open question; the entries it refers to say what can be re-verified.

**Next step.**

At X1 for lambda = 2: the quartic tangent cone inside W' (the four linear forms m_a are known at one prime;
compute the next order on {m_a = 0}); and run the order-3 analysis of X1 at the two types [6F 2T 2T], [4F 2T 2T
2F].

**Session references (files not public).** LEDGER_DISCOVERY.md "[T3] 05:12Z", "[T3] 16:33Z", "[T3] 16:42Z", "[COORD] 16:39Z".

---

## O-EXPONENT-OF-LAMBDA-PLUS-1

**Why is the exponent of (lambda + 1) in the order-5 obstruction at X1 equal to 2?**

kind: `open` | area: `movasati_conjecture` | status: **`OPEN`**

**Statement.**

The obstruction (8/9)(1 + z)(lambda - 1)(lambda + 1)^2/lambda^3 at X1 has a double zero at lambda = -1. The chain
that explains why -1 is special (D-X1-COMPONENT-IS-TD-CLOSURE; the sixfold fact "18 quadrics annihilate the class")
does not explain the exponent. Also unexplained: the simple zero at lambda_0 = 1 is expected from the pairwise
rule, but no second-order dependence on lambda of this kind was seen anywhere else.

**Conditions.** n/a

**Evidence.** Team T3, 06:05Z ('what is not explained'), 06:13Z.

**Independent check.** none

**Not established.** n/a

**Known before.** n/a

**Reproduce.** not reproducible from this repository: an open question; the entries it refers to say what can be re-verified.

**Next step.**

Compute the order-5 obstruction as a polynomial in lambda for a second, independent tangent direction kappa'
outside the sixfold sub-family (exact, with certlib-type code or fermatNextOrderSystem with a parameter ring), and
compare the lambda-factor with the factor t(t - 1) of the order-3 form.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T3] 06:05Z", "[T3] 06:13Z".

---

## O-SIGN-AND-PLANE-LEMMA-GAPS

**Sign and monodromy of the class of T; the cases (block,block), (skew,*) of the plane lemma; its eightfold version**

kind: `open` | area: `explicit_cycles` | status: **`OPEN`**

**Statement.**

```text
(1) On W_(-1): P1 - P2 (transported) = +-([T] - 3h^3). Which sign (which of the two types of T goes with P1 - P2)
and
    the behaviour along loops are not determined. Same for the eightfold: +-([T4] - 3 eta^4).
(2) Plane lemma (D-GENERAL-CUBIC-OF-D-IS-LIMIT): no proof that |g.P| = 6 never occurs for planes of type
    (block,block), (skew,block), (skew,skew) inside both determinantal cubics; samples only (all give 0). T2's
    classification of such planes lacks the skew type.
(3) The eightfold analogue (|tau.P| <= 3 for a 4-plane on an honest member of l*Q + det A + det B) is stated by
analogy
    in check C17 and not proved.
(4) The repair of the lemma's proof by the checker of C16 uses a classification of nets of singular 3 x 3 matrices
    cited from memory, and was read by no one else.
```

**Conditions.** n/a

**Evidence.** Checks C16 ('not done / not covered'), C17 ('not done'); T2's note, section 5.

**Independent check.** none

**Not established.** n/a

**Known before.** n/a

**Reproduce.** not reproducible from this repository: an open question; the entries it refers to say what can be re-verified.

**Next step.**

For (2): a hand proof for (block,block) planes (T2's 'three conditions in a P^3' argument was not examined by the
checker), or an exhaustive symbolic computation for the generic member of each stratum. For (4): one independent
read of the repair, with the classification checked in a source.

**Session references (files not public).**

LEDGER_DISCOVERY.md "[CHECK C16]" (NOT DONE), "[CHECK C17]" (EFFECT OF T2, NOT DONE);
discovery/t2_w_cycle/NOTE_W_minus1.md (section 5).

---

## O-CITED-INPUTS-AND-HUMAN-REVIEW

**No human review; the cited analytic inputs were never opened**

kind: `open` | area: `methods` | status: **`OPEN`**

**Statement.**

Nothing in this registry has been read by a human mathematician as far as the session files record. The three
notes are AI-written; their referees were AI agents. Cited and not opened by any agent: Griffiths' description of
the Hodge locus by period functions with its exact second-order coefficient and the scheme structure for a
non-primitive class; the residue formula for classes of complete intersections that may be singular or
non-reduced; the self-intersection formula (Fulton); the Carlson-Griffiths cup-product formula (no longer needed
for the second-order statements since version 20 of note 3); strong Lefschetz for monomial complete intersections
(Stanley, Watanabe); Northcott's and Wiebe's papers; Hassett's irreducibility of C_18; the Hodge conjecture for
cubic sixfolds and eightfolds and quartic fourfolds (attributions not verified); Cattani-Deligne-Kaplan. All
published papers in tests/SOURCES.md were read through a web-fetch tool, not as raw text. Versions 15 to 21 of
note 3 were not re-read end to end (a last cold read was stopped unfinished when the notes were frozen).

**Conditions.** n/a

**Evidence.**

night/paper3/paper3.tex (section 'Open points, and what a specialist should check first'); LEDGER.md 'FREEZE of
the existing results'; tests/SOURCES.md (first section).

**Independent check.** none

**Not established.** n/a

**Known before.** n/a

**Reproduce.** not reproducible from this repository: an open question; the entries it refers to say what can be re-verified.

**Next step.**

```text
The order proposed in note 3 for a specialist: (i) the cited analytic input and Lemma 2.1, in particular its parts
(3), (4); (ii) the lemma that V_Z is the image of the data map; (iii) the key lemma of the second-order principle;
(iv) the Northcott-Wiebe lemma and linkage additivity; (v) the formula for A; (vi) the range-free parts of the
first-order rule, tested against the literature first.
```

**Session references (files not public).**

night/paper3/paper3.tex (section "Open points"); LEDGER.md "FINAL STATE", "FREEZE of the existing results";
tests/SOURCES.md.

---

## O-KLOOSTERMAN-THEOREM-14-READING

**Unresolved reading: Kloosterman's Theorem 1.4 (introduction) against smoothness at lambda = -1 for cubics with c = 2**

kind: `open` | area: `first_order` | status: **`OPEN`**

**Statement.**

As digested by two scout agents, the introduction of Kloosterman arXiv:2312.12363 states (Theorem 1.4) for
(c,d) in {(2,3), (3,3), (2,4)}, every nonzero rational lambda and split X, that the reduced locus properly contains
the two-plane locus, and for d = 3, k >= 5 that the locus is reducible at X. Read literally for (c,d) = (2,3) and
lambda = -1 this contradicts the smoothness asserted in D-CODIM-AT-LAMBDA0(b). But the corresponding statement in
the body (Theorem 5.3) and its proof treat only (d,c) = (3,3) and (4,2), as digested; tests/SOURCES.md records the
same: "Theorem 1.4 (= 5.3 in the body, which treats (d,c) = (3,3) and (4,2) only)". So no statement proved there,
as digested, contradicts the session's claim. Both readings are recorded; a person has to confirm.

**Conditions.** n/a

**Evidence.** Night-run scout 6; note 3, paragraph after Theorem 2; tests/SOURCES.md entry B.

**Independent check.** none

**Not established.** Which reading is right.

**Known before.** n/a

**Reproduce.** not reproducible from this repository: an open question; the entries it refers to say what can be re-verified.

**Next step.**

A person reads Theorem 1.4 and Theorem 5.3 with its proof in the published version. If Theorem 1.4 does cover
(c,d) = (2,3): test Theorem 2(4) numerically at a split cubic tenfold with two 5-planes meeting in codimension 2
(first-order excess at lambda = -1 and the second-order verdict).

**Session references (files not public).** LEDGER.md "FINAL STATE" (SCOUT 6); night/paper3/paper3.tex (after Theorem 2); tests/SOURCES.md B.

---

## O-HODGE-NUMBER-3432

**Recorded disagreement with a published table: middle Hodge number of the cubic 12-fold, 3432 or 3433**

kind: `open` | area: `first_order` | status: **`OPEN`**

**Statement.**

In the table of Hodge numbers of cubic hypersurfaces in Movasati arXiv:1902.00831 (Table 5) and arXiv:2211.11405
(Table 1), the middle entry of the row for dimension 12 reads 3432 as read by machine (twice in each paper). The
rows for dimensions 4 to 10 include the class of the linear section (21, 71, 253, 925), and by the same rule the
package gives 3432 + 1 = 3433 (primitive middle number 3432). The middle Betti number ((-2)^14 - 1)/3 + 2 = 5463 is
the sum of the package's row; the published row sums to 5462. Neither side was adjusted. This concerns a side
column only, no codimension.

**Conditions.** n/a

**Evidence.** tests/README.md (section on disagreements); package test 01 prints a DISAGREE line in every run.

**Independent check.** none

**Not established.** Whether it is a slip in the table or in the machine reading.

**Known before.** n/a

**Reproduce.**

Run from the repository root (Macaulay2 1.22).

```
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
print primitiveHodgeNumbers(12, 3);
```

Expected: {0, 0, 0, 0, 14, 1001, 3432, 1001, 14, 0, 0, 0, 0} (primitive numbers; add 1 in the middle for the class
of the linear section). The DISAGREE line: tests/run_all.sh 01_movasati (file
tests/validation/01_movasati_K_table.m2).

**Next step.** A person looks at the printed table.

**Session references (files not public).** tests/README.md; tests/SOURCES.md A2.

---

## O-COMMON-ZEROS-AND-SECOND-ORDER-GAPS

**Second order: quadrics with common zeros, condition (S) failing, and cubic eightfolds in the package tests**

kind: `open` | area: `second_order` | status: **`OPEN`**

**Statement.**

Not determined by the second-order results: (1) the structure of the Hodge locus when the quadrics on the excess
space have common zeros (always if dim K < e_tau; at special points such as Fermat cubics with planes of the same
pairing; at one random instance of the type (6; 1; 1; 3), verdict SOME DIE); (2) the second-order terms against
K_lambda minus K when (S) fails; (3) the second-order law for k = 5, for r < 0 at general points (E' = 0 there in
the types tried), and for seven degree types with (k,d) = (2,5) (not run by the blind agent); for c = 5 on cubic
eightfolds the special coefficient is supported at first order and by Hilbert functions only.
Package: the validation suite does not run the second order for cubic eightfolds (rows (3,4,c) of the list L): the
computation in 10 variables was not attempted within the time budget. It was run in the session with other code
(blind agent; team T3 at two primes; night check T4 at Fermat points).

**Conditions.** n/a

**Evidence.**

night/paper3/paper3.tex (section 'Open points', items 5, 6); tests/README.md ('Not covered'); LEDGER.md 'BLIND
AGENT FINAL' (not run by it).

**Independent check.** none

**Not established.** n/a

**Known before.** n/a

**Reproduce.** not reproducible from this repository: an open question; the entries it refers to say what can be re-verified.

**Next step.**

For the package: time secondOrderObstruction on linear pairs (3,4,3), (3,4,2), (3,4,1) modulo 32003 with a column
subset of the linear system, and add a slow test. For (1): treat the type (6; 1; 1; 3) at a random instance to
third order on the common zero locus.

**Session references (files not public).** night/paper3/paper3.tex; tests/README.md; tests/SOURCES.md (last table).

---

## O-PACKAGE-FEATURES-NEEDED

**What the package lacks for the entries marked 'not reproducible from this repository'**

kind: `open` | area: `methods` | status: **`OPEN`**

**Statement.**

Collected from the reproduce fields of this registry. Not in the package: (1) the residual R and the family
F - N det M at lambda_0; (2) periods of monomials of higher pole order along an arc and Smith forms over a power
series ring (catalecticants along arcs: rank invariant, splitting test); (3) leading forms of all dependent
equations on a subspace of the tangent space at a Fermat point (the session's engine works on whole subspaces, the
package on one arc at a time); (4) residue functionals at random hyperplane arrangements (points of Sigma_4) and
the Hessian along curves; (5) an evaluation of the closed-form period Phi(q G^m) for arbitrary polynomials at a
Fermat point (universal certificates); (6) intersection numbers; (7) cone-type instances.
One practical point found while confirming the pointers: a validation test must be started with an absolute path
(M2 --script "$PWD/tests/validation/NAME.m2") or through tests/run_all.sh; with a relative path the test cannot
find tests/validation/common.m2.

**Conditions.** n/a

**Evidence.**

This registry (22 November 2026); the commands that were run are listed in the final report of the agent that
built it.

**Independent check.** none

**Not established.** n/a

**Known before.** n/a

**Reproduce.**

Run from the repository root (Macaulay2 1.22). The path remark: tests/run_all.sh 02_kloosterman works; so does
M2 --script "$PWD/tests/validation/02_kloosterman_prop310.m2" (expected last line: ALL 4 CHECKS PASSED).

**Next step.** Port the two most reused tools first: periods of quadratic monomials along an arc (2) and the closed-form Phi (5).

**Session references (files not public).** README.md (section Limitations); tests/README.md (section 'Not covered, and why').
