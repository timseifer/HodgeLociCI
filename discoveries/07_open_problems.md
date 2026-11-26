# Open problems

- Questions the project left open, each with the single most useful next computation or argument.
- Includes work that was queued and never started (three or more cycles; sextic fourfolds and cubic tenfolds) and the literature and human checks that were not done.
- Status OPEN, STUCK (attempted, blocked) or CONJECTURE (a statement the evidence supports, with gaps).

> **Status of everything on this page:** produced by AI agents, checked only by other AI agents, reviewed by no human. Sources of published results were read by machine (see `tests/SOURCES.md`). The notes cited as "unreviewed note 1, 2, 3" are AI-written and unreviewed (in papers/). Nothing here is, or bears on, a proof or disproof of the Hodge conjecture. This is a registry of what was found, ruled out or left open, not a list of established theorems.

Generated from `discoveries/registry.yaml` by `discoveries/check_registry.py --write-pages`. Do not edit this page by hand: edit the registry. Notation: [`NOTATION.md`](NOTATION.md). Status vocabulary: [`README.md`](README.md).

## Entries on this page (19)

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
| [O-TENFOLD-CONE-LEAD](#o-tenfold-cone-lead) | `OPEN` | Cubic tenfold with two 5-planes meeting in a P^2: is the component W through Z_0 strictly larger than the cone locus Cone_d? |

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

UPDATE 26 Nov 2026 (night): a first batch, D-SIXFOLD-ARC-ORDER19 (the arc exactly to order 19),
D-ARC-SPLITTING-NUMERICAL (floating point: the splitting in characteristic 0, a matrix for one of the two
summands, none for the other) and N-MATRIX-RECOVERY-FIRST-ATTEMPTS (what failed). Still open: the second
matrix, the series, the flat limit of T. Earlier text:
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

UPDATE 26 Nov 2026: for the tenfold K3 / abelian parallel the literature was searched (machine-read):
arXiv:2606.10884 lists the K3 surface of genus 8 and the abelian surfaces as the K-trivial surfaces with a Coble type
cubic in P^8; see known_before of D-TENFOLD-K3-ABELIAN-PAIRING. The items below are still open.
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

UPDATE 26 Nov 2026 (night): at the eightfold Movasati point there is now an arc outside the cone-type family for
lambda = -1 (order 8, MOD p), and lambda = 2 is obstructed at order 6 on such directions in transversal slices:
D-MOVASATI-POINT-ARC-ORDER8. Earlier text:
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

---

## O-TENFOLD-CONE-LEAD

**Cubic tenfold with two 5-planes meeting in a P^2: is the component W through Z_0 strictly larger than the cone locus Cone_d?**

kind: `open` | area: `movasati_conjecture` | status: **`OPEN`**

**Statement.**

At the Fermat cubic tenfold with Movasati's pair (in Z_0 and in every Cone_d), for lambda = -1, 2 (MOD 32029):
rank L = 38, joint persistence codim 39, excess 1; T Cone_T has codim 65, lies in ker L, T Cone_T + T V_Z = ker L,
T Cone_T n T V_Z = T Z_0 (codim 66). The 2nd- and 3rd-order forms of the 183 dependent equations vanish on ker L;
generic directions are obstructed at order 4 independently of choices (no smooth component of dimension
dim V_Z + 1, agreeing with Kloosterman arXiv:2312.12363 as machine-read). Normal directions to Cone_T are the
27-dim space of 3x3 matrices M|Pi of linear forms on the P^2 (ARG): rank 2 and 3 obstructed at order 4; rank 1
(two Segre cones of dimension 11) survive order 4, so dim W <= dim Cone_T + 11. For one generic rank-1 direction
at lambda = 2 the order-5 obstruction is removable (K.c_5 in Im DG4(v), rank 16) and, after correction, the
order-6 term is NOT in Im DG4(v): obstructed modulo first-order corrections.

**Conditions.**

MOD 32029 only; one direction; quadratic freedom at order 6 not examined; lambda = -1 order 6 not finished; the
special monomial rank-1 direction (x1 x6 x7) survives to order 6 at lambda = 2 (cap), not interpreted.

**Evidence.**

Team T6 step (d), session folder discovery/t6_unsolved/d/ (NOTES.md, t1, t6, t8, t9 outputs; lin.m2; not in this
repository).

**Independent check.**

Blind check BC-T6 (own Python code, closed-form Fermat periods; did not see steps (d)/(e)): rank L = 38, codim
V_Z = 39, excess 1, T Cone_T codim 65, T V_Z + T Cone_T = ker L, ker L / T Cone_T = 27-dim (y_i u_e v_f) AGREE,
with L.T V_Z = 0 and L.T Cone_T = 0 EXACT over Z[z] and ranks at three primes. The lambda-dichotomy is NOT
reproduced: in the family b = y0 (a.u)(c.v) both lambda = -1 and lambda = 2 (and rank-2 controls) extend to order 9
with nonlinear corrections (MOD p, three primes for the generic case); for generic rank-1 directions both lambda
behave identically through order 5 and in the order-6 tests run (order 6 undecided for both). Step (e) (lambda = -1
survives to order 8, lambda = 2 obstructed at order 6, MOD p, two primes, fe.py) and the blind check disagree; the
devil's advocate (DA-T6) found no known explanation and no fatal error, and noted that step (e) tested only a
subcone of directions.
RECONCILIATION RC-T6: conventions identical (sigma maps one plane pair to the other, lambda preserved); each code
confirms the other's arcs; BC's order-9 arcs lie in a degenerate y0 sub-locus (8-variable Thom-Sebastiani slice,
M = y0 x scalar matrix) where both lambda behave alike, and BC's generic order-6 search was inconclusive. Independent
order-6 test (own finite differences): lambda = 2 obstructed for every integral arc with a generic rank-1 tangent
(2 directions), lambda = -1 removable; the step (e) lambda = -1 order-8 arc is confirmed with BC's functional. So the
dichotomy stands, MOD p (32029; 31981 from step (e)), finite order, Fermat point only.
EXACT (EX-T6, Q(z), cross-checked with both functionals): lambda = 2: for 3 explicit generic rank-1 tangents
(both Segre types) the ARG hypotheses hold exactly (rank DG4(v) = 16 = codim Sigma1, ker DG4(v) = T_v Sigma1) and
an exact certificate (y.c6 = 480(1+z) etc.) shows order 6 is obstructed for every integral arc with that tangent
(given the ARG). lambda = -1: exact arcs in Q(z) with all period equations vanishing through order 8 (2 explicit
tangents, linear corrections only), not V_Z arcs.
EXPLANATION TESTS (EXP-T6): rank DG4 = 16 at generic Segre-cone points (16/16, MOD p), so a component W with
generic rank-1 tangents has codim EXACTLY 54 in moduli. Not explaining W: Kloosterman 2312.12363 Thm 5.3 (its
components are Cone_d; LIT); Segre P^2xP^3, P^1xP^4, P^1xQ^4, G(2,5) sections (integrality: the degree of a cycle
in Q<h^5, P1 - P2> is divisible by 3); 13 cone/join/scroll families (codims 32-60, none 54, MOD p). Partial: the
C_18 family F_T (X containing J(P^2, T), T an elliptic ruled sextic; codim 55, MOD p) is specific to lambda = -1
and is expected to explain a codim-1 sub-cone of the directions (ARG). Explained: the y0 sub-locus (join of a line
with the sixfold W_lambda; ARG + MOD p). Correction: "every component other than V_Z through the Fermat point has
codim >= 54" is too strong; it holds only for components containing Cone_T (the TD10 closure passes with codim
<= 52, ARG).
FOLLOW-UP (W1-W4, 24 Nov; MOD p unless stated): W3: lambda = -1 arcs extend to order 12 (a x l) and 11 (l x a) at
two primes, top-term linear corrections at every order; 12/12 FULLY generic directions (v0 uniform in T Cone_T)
extend to order 8 at lambda = -1 and are obstructed at order 6 at lambda = 2; G4 = 0 on all of Sigma1 EXACT at 40
random points (Schwartz-Zippel < 1e-53). W4 (second reader): setup, order-6 criterion and tangent-cone argument
SOUND; finite-order arcs are evidence, not proof. W2: the C_18 family F_T does not explain W (tangent cone at Fermat
165-dim, a codim-1 sub-cone; ARG). W1: no codim-54 family found; at random X in F_T the Hodge-tangent codim of
[J(P^2,T)] is 54 vs codim F_T 55 (a codim-54 branch, or a non-reduced locus since T is irregular; undecided).
CLOUD RUNS (24 Nov, 02:48Z-14:00Z; every line MOD p at 67108837 and/or 67108819; each batch re-checked by the
coordinator with check_results.py against stored reference logs: CHECK PASS, except one batch where the reported
FAIL is a checker artifact (it compares one line past the reference's last order; verified by hand); every batch
pre-registered in the session ledger with dead end = any lambda = -1 generic direction obstructed, and none hit):
lambda = -1, fully generic rank-1 directions: one direction (a x l) extends to order 12 at BOTH primes with identical
correction histories; 8 more to order 10 and 1 to order 9; a batch of 48 new directions (both Segre types, both
primes) 48/48 extend to order 9. No lambda = -1 generic direction has been obstructed at any order tested.
lambda = -1 sparse (EX-T6) arcs: 4/4 extend to order 15 (both types, both primes). lambda = 2 controls: 120/120
generic directions obstructed at order 6 (OBSTRUCTED_GENUINE, both primes). Other coefficients at order 7 (26
values incl. -2, -1/2, 3, 1/3, 5, 1/5, 3/2, 2/3): all obstructed at order 6; only lambda = -1 and lambda_0 = 1
extend. The pre-registered "surprise" (generic survival to order 13 at both primes) was not testable: order 13
needs about 244 GB.
SYMMETRY VERSUS GEOMETRY (24 Nov; both tests pre-registered in writing before results were read): lambda = -1 is
both the unique value fixed by the swap tau (lambda -> 1/lambda) and the unique C_18 value, so Fermat runs alone
cannot separate the two. (TS-T6, MOD p at 67108837 and 67108819, order 6 and 8) At two Thom-Sebastiani split points
X = V(Fermat4(x0..x5) + G(x6..x11)), G a cubic fourfold containing two disjoint planes (cone points in Z_0), with NO
automorphism exchanging the planes (EXACT, computer-assisted: the two discriminant cubics have different
j-invariants; a symmetrised control has equal ones): generic rank-1 directions at lambda = -1 extend to order 6
(16/16 = 4 seeds x 2 primes x 2 points) and to order 8 (8/8, first point); lambda = 2 is obstructed at order 6
(4/4 seeds, both Segre types, both points, both primes); lambda_0 = 1 extends; lambda = 1/2 is also obstructed
(lambda and 1/lambda still agree although no symmetry forces it). All validity gates passed. Verdict by the
pre-registration: GEOMETRIC (the survival at lambda = -1 does not depend on the Fermat swap symmetry at these
points). Blind check BC-TS (own period tables and order-6 driver; shared: cone geometry code, direction recipe,
I_Q^2 condition at degree 6): AGREE, tables identical on all monomials of degree <= 21, verdicts 32/32 + 4/4.
No EXACT certificate at the split points. (SO-T6, MOD 32003 and 31991, order 2) At points of the C_18 family F_T
the one extra Hodge-tangent direction of [J(P^2,T)] is unobstructed at second order (2 seeds x 2 primes; controls
pass; the non-vacuity of the all-zero matrices rests on a nontriviality check and on the cubic-sixfold controls,
ARG); verdict SURVIVES, consistent with a codim-54 component containing F_T as a divisor. Blind check BC-SO (own
code for T, V, X and a different evaluation route for psi; shared only the characterisation of psi, ARG): AGREE
at 2 seeds x 2 primes (dims 310/309, order-2 matrices 0), positive control and nontriviality pass.
(SO3-T6, MOD 32003 and 31991, order 3; pre-registered) With the order-2 correction g_2 solved for (it is not 0)
and its cross term included, the order-3 condition on the extra direction vanishes on all of T NL at 2 seeds x
2 primes (4/4): the two parts are each nonzero on 246 of 310 basis vectors and cancel exactly. Controls: a known
third-order obstruction on a Fermat cubic sixfold is detected (and the unobstructed cases are not flagged); the
third-order evaluator agrees with the package's Fermat periods; family directions (in T F_T) pass at both seeds.
The freedom matrix was spot-checked on 2 random directions, not computed in full. Verdict SURVIVES (orders 2 and
3). Check BC-SO3 (own derivation and code, own random points and positive control; PARTLY BLIND: it saw the
SO3-T6 result lines before its own numbers, disclosed): AGREE at 2 points x 2 primes (the deciding number
6 psi(G^2 g2) - 7 psi3(G^4) is 0 mod p with both parts nonzero; it also shows c3 vanishes on T F_T automatically,
ARG).
(SR-T6, MOD p, ARG, LIT) V is not a local complete intersection (depth 5); Buchweitz-Flenner semiregularity for
O_V applies: the map has a 1-dim kernel on the obstruction image, spanned by the extra direction; V is rigid in X
(Ext^1_X(O_V,O_V) = 0). NOT SEMIREGULAR: neutral (the theorem gives no conclusion); a codim-54 branch would need
a different cycle or sheaf with class a h^5 + b[V], b != 0.
(DP-T6, MOD p, 2 seeds x 2 primes) At cones over sextic del Pezzo residuals V' = J(Pi, S') the Hodge-tangent
codim of [V'] is 50: of the 5 extra directions, a rank-4 quadric cone survives order 2 and the rest die
(PARTIAL); controls pass; not blind-checked. CORRECTION (second search): these X lie in F_T (they also contain a
V-type cone), so this is the excess of NL([V]) over F_T jumping from 1 to 5 at special points of F_T, not a
separate family. Order 3 there is OPEN.
Wording: finite-order arcs are evidence, not a proof that a component exists; NOT a candidate.

**Not established.**

Whether W = Cone_d locally or W is larger in rank-1 directions; the cause of the step (e) / blind-check
disagreement (resolved: see independent_check). Still missing: orders >= 9 at lambda = -1 (exact engine needs
streaming); the ARG (tangent-cone conclusion) checked by a second reader; G4 = 0 on all of Sigma1 exactly; more
directions (genericity); a codim-54 family containing F_T as a divisor (the eightfold analogue is the Segre divisor
inside TD), which would EXPLAIN the lead;
lambda = 2 with a fully generic T Cone_T tangent under the full quadratic-freedom test; whether the y0 sub-locus
is explained (now: yes); a specific smooth member off the cone locus.

**Known before.**

Movasati arXiv:1902.00831 (component conjectured, cycles unknown); Kloosterman arXiv:2312.12363 Thm 5.3 (extra
component at split X built from cones), both machine-read.
rStation paper #5 (u/lelong_ridge, "Movasati's GADEPs Conjecture 1 fails for cubic sixfolds and eightfolds", v5
18 Oct 2026, https://rstation.ai/problems/hodge_conjecture/papers/5; agent-written, reviewed on rStation, not by
us; machine-read 24 Nov 2026): Theorem D / Thm 11.1 (n = 10): for each of the 125 ratios (lambda = -1 included)
V_Z (slice dimension 181 of 220) is an irreducible component of NL_red at the Fermat point, by a generic arc
obstructed at order 4; Prop. 11.2: U_lambda is not contained in V_Z (cone type, recovering Kloosterman); Sec. 11
bounds the explained families (split family, cones over cubic eightfolds) by slice dimension 155 and states that
whether U_lambda has a component of dimension > 155 is open. Rank-1 / Segre directions are not tested there.
This entry is consistent with Theorem D (generic directions obstructed at order 4 here too; rank L = 38, 183
dependent equations) and addresses #5's open question: W would have slice dimension 220 - 54 = 166 > 155, for
lambda = -1 only (finite-order MOD p evidence, not a proof). rStation paper #11 (u/lelong_ridge, "The Hodge
conjecture for Thom-Sebastiani cubic tenfolds", v1 17 Oct 2026,
https://rstation.ai/problems/hodge_conjecture/papers/11/v1; agent-written; machine-read 24 Nov 2026): Theorem 1
/ Cor. 1.1 reduce the Hodge conjecture for V(g(x) + h(y)) to the product of the two cubic fourfolds, and Cor.
2(a) proves it when T_g is not isomorphic to T_h. At the TS-T6 split points g = Fermat cubic fourfold (Hodge
classes of rank 21, so T_g has rank 2) and h = G with two disjoint planes (Hodge classes of rank 3 for general
G, T_h of rank 20), so Cor. 2(a) applies (ARG: rank of A_G not computed; it differs from 21 unless G is very
special): the Hodge conjecture holds at those points, consistent with their lying in the explained cone locus.
The split points are test points for the arc computation, not candidates.

**Reproduce.**

not reproducible from this repository: session scripts (use fermatExtendArc with care: obstruction orders above
the first nonzero Taylor order can depend on the choice of lower terms).

**Do not repeat.**

Generic Fermat arcs at this point (obstructed at order 4); rank-2/3 normal directions to Cone_d (order 4); reading
a fermatExtendArc obstruction at order > 4 here as final without testing removability (order 5 was removable).

**Next step.**

```text
UPDATE 26 Nov 2026 (night): at Movasati's point, directions with C = 0 and A, B non-zero: lambda = -1 to order 8
(MOD p, via the eightfold; the tenfold's own 221 equations hold), lambda = 2 obstructed at order 6:
D-MOVASATI-POINT-ARC-ORDER8. Earlier updates follow.     UPDATE 26 Nov 2026 (evening): the order-4 sentence of this entry is corrected by C-TENFOLD-ORDER4-RANK2 (special
nets of rank 2 and 3 pass order 4; D-TENFOLD-ORDER4-MODEL-CONE), and the closure of the two-determinant family
(codimension 52, an algebraic class) passes through this point CONDITIONALLY on the sixfold identification
(D-TENFOLD-CONE-POINTS-TWO-DET). The lead W in the Segre directions is not touched. Earlier updates:
UPDATE 26 Nov 2026 (later): the class of the 4-plane cycle is not a multiple of h^5 by a transversal intersection
count with a 5-plane (8 points, where a multiple of h^5 gives 4; MOD p, blind-checked): D-TENFOLD-COBLE-PLANE-COUNT.
This does not use the node argument or the ladder. Left: characteristic 0 by an exact run, and a human reading.
UPDATE 26 Nov 2026: at the Fermat tenfold the explicit arcs of the Coble family carry the three-plane class, not
delta (C-TENFOLD-FERMAT-POINT-CLASS). For that class the family passes an explicit-arc test to orders 10-12
(D-TENFOLD-COBLE-FERMAT-ARCS). For delta nothing new: an explicit arc of the family with the marking delta is the
open step.
UPDATE 25 Nov 2026 (evening): the class argument was replaced (D-TENFOLD-COBLE-CYCLE-CLASS: the 4-plane cycle has
self-intersection -144, so it is 4 h^5 +- 2 ([V] - 2 h^5); two paper arguments with MOD p inputs) and the explicit
arc passes orders 2 and 3 exactly (D-TENFOLD-COBLE-ARC-ORDERS, MOD p). If those arguments hold, W exists, is the
Coble family, and the class is algebraic on it. This entry stays OPEN until a mathematician has read the two
arguments; what remains is review, not computation.
RESUMED 25 Nov 2026 with a candidate explanation: D-TENFOLD-COBLE-FAMILY (cubic tenfolds with a P^8-section that
is a Coble cubic; codim 54; first order MOD p and EXACT at two points; the class statement is ARG) and
D-TENFOLD-PRODUCT-POINTS. This entry stays OPEN until the class argument is replaced by a computation and a
mathematician has looked at it; next steps are listed there. Earlier text follows.
PAUSED (25 Nov 2026, owner's stopping rule: three pre-registered searches and the direct methods found no
explaining construction; N-TENFOLD-CODIM54-SEARCH, -2, N-TENFOLD-DIRECT-METHODS; a later singular-section test,
N-TENFOLD-SINGULAR-SECTIONS, also explains nothing). The lead stands as an open
question with the evidence above. If resumed: the undecided cases (~8 GB), order >= 4 / AG ideals, the Segre
P^2 x P^2 cone family (codim 55, Hodge-tangent 50), expert input. Earlier plan for reference: (1) DONE; (2) DONE;
(3) an exact certificate at a split point (memory/core-hour estimate first); (4) a specific smooth
member off the cone locus with an exact proof that the class is Hodge there. More random lambda = -1 directions
at the Fermat point add little.
```

**Session references (files not public).**

LEDGER_DISCOVERY.md "[T6d]" 11:56Z-14:47Z (23 Nov); "[W1]"-"[W4]", "[COORD]" cloud entries, "[TS-T6]", "[SO-T6]"
(24 Nov). Cloud logs: branch cloud-job-1, jobs/queue/results/ (not on main).
