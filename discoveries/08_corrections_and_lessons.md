# Corrections, and methods worth reusing

- Every error caught by a check: what was wrong and what replaced it. For a correction, 'status' is the status of the statement that replaced the wrong one.
- Then the methods that worked: universal certificates, catalecticants along arcs, dual-number and p-adic second-order data, the endomorphism-algebra splitting test, exact certificate files, blind checks.
- Lessons: keep parameters symbolic, check that symmetries fix the class, never infer a dimension from a tangent codimension alone.

> **Status of everything on this page:** produced by AI agents, checked only by other AI agents, reviewed by no human. Sources of published results were read by machine (see `tests/SOURCES.md`). The notes cited as "unreviewed note 1, 2, 3" are AI-written and not public. Nothing here is, or bears on, a proof or disproof of the Hodge conjecture. This is a registry of what was found, ruled out or left open, not a list of established theorems.

Generated from `discoveries/registry.yaml` by `discoveries/check_registry.py --write-pages`. Do not edit this page by hand: edit the registry. Notation: [`NOTATION.md`](NOTATION.md). Status vocabulary: [`README.md`](README.md).

## Entries on this page (23)

| id | status | title |
|---|---|---|
| [C-AVERAGING-ARGUMENT](#c-averaging-argument) | `EXACT` | T3's symmetry-averaging reduction at X1 was wrong; the result was re-established by a direct exact computation |
| [C-EIGHTFOLD-CHAIN-STEP4](#c-eightfold-chain-step4) | `PAPER_ARGUMENT_AI` | T3's chain for the eightfold had a gap at step 4; closed modulo primes with the explicit family l*Q + det A + det B |
| [C-PLANE-LEMMA-GAP](#c-plane-lemma-gap) | `PAPER_ARGUMENT_AI` | T2's plane lemma: proof gap and incomplete case list; statement confirmed, wording narrowed to 'the general cubic' |
| [C-CLOSURE-OF-WORDING](#c-closure-of-wording) | `PAPER_ARGUMENT_AI` | 'W is the family of sums of two determinants' corrected to 'the closure of' |
| [C-RANDOM-SAMPLING-MISSED-VALUES](#c-random-sampling-missed-values) | `MOD_P` | T1's random sampling missed special parameter values; those strata were redone exactly |
| [C-RANK-28-MISREADING](#c-rank-28-misreading) | `MOD_P` | '8 quadrics annihilate the class' for lambda = 2 was a misreading: they are the partial derivatives; 28 is the maximal rank |
| [C-CUBIC-LIFT-DEPENDENCE](#c-cubic-lift-dependence) | `PAPER_ARGUMENT_AI` | 'The cubic c is non-degenerate' at triple points depends on a choice of lift; condition (A) replaced it |
| [C-VOID-OUTPUTS-AND-CHECKER-BUGS](#c-void-outputs-and-checker-bugs) | `COMPUTED_ONLY` | Outputs declared void, and bugs found in the teams' and checkers' own code before the reported numbers |
| [C-WORDING-8-7-AND-20-19](#c-wording-8-7-and-20-19) | `EXACT` | '8 -> 7' and '20 -> 19' are K and H at the Fermat point for every nonzero coefficient, not codimensions of a Hodge locus |
| [C-NIGHT-WS-STATEMENT](#c-night-ws-statement) | `PROVED_AI_UNREVIEWED` | Night run: a statement on the family W_s at lambda_0 was false; replaced by the Northcott residual R |
| [C-NIGHT-PROP-94PRIME-GAP](#c-night-prop-94prime-gap) | `PROVED_AI_UNREVIEWED` | Night run: the first proof of 'the formula for every r' had a gap; repaired with Cramer's rule and the pointwise formula |
| [C-NIGHT-VACUOUS-CHECKS](#c-night-vacuous-checks) | `PROVED_AI_UNREVIEWED` | Night run: three numerical checks of the pointwise formula tested less than claimed |
| [C-NIGHT-SMALLER-CORRECTIONS](#c-night-smaller-corrections) | `COMPUTED_ONLY` | Smaller corrections of the night run and of the package phase |
| [M-UNIVERSAL-CERTIFICATES](#m-universal-certificates) | `EXACT` | Universal certificates: a form q that kills a velocity for every arc, at a Fermat point |
| [M-CATALECTICANT-ALONG-ARCS](#m-catalecticant-along-arcs) | `EXACT` | Catalecticant / invariant-factor method along arcs: finite-order invariants of a Hodge class on a component |
| [M-DUAL-NUMBER-AND-PADIC-SECOND-ORDER](#m-dual-number-and-padic-second-order) | `MOD_P` | Second-order period data from first-order residues: dual numbers and p-adic points |
| [M-ENDOMORPHISM-SPLITTING-TEST](#m-endomorphism-splitting-test) | `MOD_P` | Endomorphism-algebra test: does a space of quadrics split into two determinantal nets? |
| [M-F4-SMALL-PRIMES](#m-f4-small-primes) | `COMPUTED_ONLY` | Use primes below 32768 for Groebner-heavy steps in Macaulay2; large primes are much slower |
| [M-EXACT-CERTIFICATE-FILES](#m-exact-certificate-files) | `EXACT` | Small exact certificate files (arc + dual functional) that a third party can re-verify without rerunning the search |
| [M-TANGENT-CODIM-FROM-IDEAL](#m-tangent-codim-from-ideal) | `PAPER_ARGUMENT_AI` | Tangent codimension of the Hodge locus of any half-dimensional subvariety from its ideal alone |
| [M-STRATA-INSTEAD-OF-DIRECTIONS](#m-strata-instead-of-directions) | `PAPER_ARGUMENT_AI` | To exclude extra components, study general points of the degeneracy strata, not more directions at the special point |
| [M-BLIND-CHECKS-WITH-CONTROLS](#m-blind-checks-with-controls) | `COMPUTED_ONLY` | One blind check per claim, with negative controls and 'what a wrong claim would have looked like' |
| [M-LEAN-CERTIFICATES](#m-lean-certificates) | `EXACT` | Lean certificates: kernel-checked finite computations and deductions from stated hypotheses |

---

## C-AVERAGING-ARGUMENT

**T3's symmetry-averaging reduction at X1 was wrong; the result was re-established by a direct exact computation**

kind: `correction` | area: `movasati_conjecture` | status: **`EXACT`**

**Statement.**

What was wrong: T3's entry of 06:12Z and the README of the export claimed that the order-5 obstruction at X1 for
lambda != -1, computed inside the 56-dimensional family of cubics fixed by the symmetries on x5 and x7, holds for
arcs with the same T_1 in the full space of cubics "by equivariance". The symmetries do not fix the planes, ker L is
not stable, and averaged solutions are not solutions (N-SYMMETRY-AVERAGING).
What replaced it: for lambda = 2 the statement "Lambda.c_5 = 1 + z for every admissible (T_2, ..., T_5)" was
established by check C11 over all 220 cubic monomials, by a direct exact computation (the bilinear terms vanish on
the relevant kernels; the linear part of Lambda.c_5 has 0 nonzero coefficients of 194 and its quadratic part 0 of
18915). For the other values of lambda the obstruction over all cubics rests on modulo-p computations on the 120
squarefree cubics (a slice transversal to the orbit, no symmetry reduction); it is exact only inside the
56-dimensional family.

**Conditions.** n/a

**Evidence.**

Check C11 (b); T3's withdrawal at 16:03Z; coordinator's entry of 14:58Z. Not affected: the exact arcs and values
inside the family; all modulo-p statements of T3; the global argument and the chain (they do not use the step).

**Independent check.** C11

**Not established.** The obstruction over all cubics, exactly, for lambda other than 2.

**Known before.** n/a

**Reproduce.**

Certificate for lambda = 2: M2/HodgeLociCI/data/x1_lam2_obstruction.txt (claims 1-3 are re-verified by
fermatVerifyCertificate; claim 4, the independence of the choices, is not: tests/README.md).

**Session references (files not public).**

LEDGER_DISCOVERY.md "[T3] 06:12Z", "[CHECK C11] 14:55Z", "[COORD] 14:58Z", "[T3] 16:03Z"; END_OF_ROUND_REPORT.md
(Corrections, item 1).

---

## C-EIGHTFOLD-CHAIN-STEP4

**T3's chain for the eightfold had a gap at step 4; closed modulo primes with the explicit family l*Q + det A + det B**

kind: `correction` | area: `movasati_conjecture` | status: **`PAPER_ARGUMENT_AI`**

**Statement.**

What was wrong: step 4 of T3's six-step chain (06:05Z) said "the closure of the Hodge locus of the Segre class has a
component of codimension 26" because the tangent codimension is 26. That does not follow: a tangent codimension
bounds the dimension from above only. On sixfolds one can use "a Hodge locus is cut by h^(4,2) = 8 equations"; on
eightfolds the bound is h^(5,3) = 45, so the locus could a priori be the Segre locus (codimension 27) with a thicker
tangent space. Every later "dim V - 6" depended on this.
What replaced it: the family TD = {l*Q + det A + det B} supplies the lower bound. It is irreducible, carries the
explicit fourfold T4, its tangent space has codimension 26 and equals the Hodge tangent space of [T4]; at a general
Segre cubic the limit of [T4] - 3 eta^4 is +-([Sigma] - 2 eta^4). So the Segre Hodge locus contains a branch of TD
of codimension 26 and is smooth there (D-X1-COMPONENT-IS-TD-CLOSURE, step 4).

**Conditions.** n/a

**Evidence.** Check C17 (computations N1-N3 at primes 32003, 30011, own Macaulay2 code) with a short paper argument by the reader.

**Independent check.** C17 found the gap and wrote the repair; the repair was read by no one else. C15 agrees with N1, N2.

**Not established.** Anything exact; see D-X1-COMPONENT-IS-TD-CLOSURE.

**Known before.** n/a

**Reproduce.**

Numbers N1, N2: tests/validation/13_discovery_explicit_families.m2 (26 for the family and its fourfold; 27 and 26
for the Segre fourfold).

**Session references (files not public).**

LEDGER_DISCOVERY.md "[T3] 06:05Z", "[CHECK C17] 16:08Z" (step 4), "[COORD] 16:10Z"; END_OF_ROUND_REPORT.md
(Corrections, item 2).

---

## C-PLANE-LEMMA-GAP

**T2's plane lemma: proof gap and incomplete case list; statement confirmed, wording narrowed to 'the general cubic'**

kind: `correction` | area: `explicit_cycles` | status: **`PAPER_ARGUMENT_AI`**

**Statement.**

```text
What was wrong: (1) the written proof of |g.P| <= 3 argued that a common component of the two curves for all pencils
lies in the singular locus; a common component that moves with the pencils was not treated; (2) the list of
types of planes inside both determinantal cubics (row, column, block) misses a "skew" type; (3) the consequence
was worded "the cubics of D are not sums of two determinants".
What replaced it: (1) the checker closed the gap by hand (dimension count plus a classification of nets of
singular 3 x 3 matrices cited from memory); (2) skew examples all give g.P = 0, so the bound holds in the samples;
(3) the consequence reads "the GENERAL cubic of D is a limit of sums and not a smooth honest sum; special cubics
of D may be honest sums", and it follows from the lemma and a dimension count alone.
```

**Conditions.** n/a

**Evidence.** Check C16; coordinator's addendum to T2's note.

**Independent check.** C16 (statement confirmed by two methods at two primes and exactly on the Fermat sixfold).

**Not established.** See O-SIGN-AND-PLANE-LEMMA-GAPS.

**Known before.** n/a

**Reproduce.** not reproducible from this repository: see D-GENERAL-CUBIC-OF-D-IS-LIMIT.

**Session references (files not public).**

LEDGER_DISCOVERY.md "[CHECK C16] 16:18Z", "[COORD] 16:19Z"; discovery/t2_w_cycle/NOTE_W_minus1.md (addendum);
END_OF_ROUND_REPORT.md (Corrections, item 3).

---

## C-CLOSURE-OF-WORDING

**'W is the family of sums of two determinants' corrected to 'the closure of'**

kind: `correction` | area: `explicit_cycles` | status: **`PAPER_ARGUMENT_AI`**

**Statement.**

What was wrong: T2's entry of 05:45Z said that the second component W_(-1) "is the variety of sums of two
determinants". By D-GENERAL-CUBIC-OF-D-IS-LIMIT the general cubic of the divisor D = W_(-1) n V_Z is only a limit of
such sums, and the threefold T degenerates there.
What replaced it: W_(-1) is (an open piece of) the CLOSURE of the family {det A + det B}. The class of T at the
general point of W_(-1) is known only up to sign and only through the flag threefold and the chain read in C8.

**Conditions.** n/a

**Evidence.** T2 15:42Z; coordinator 15:48Z.

**Independent check.** C16 for the underlying lemma.

**Not established.** n/a

**Known before.** n/a

**Reproduce.** not reproducible from this repository: a wording correction; see D-W-MINUS1-IS-TWO-DET-CLOSURE.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T2] 05:45Z", "[T2] 15:42Z", "[COORD] 15:48Z"; END_OF_ROUND_REPORT.md (Corrections, item 4).

---

## C-RANDOM-SAMPLING-MISSED-VALUES

**T1's random sampling missed special parameter values; those strata were redone exactly**

kind: `correction` | area: `fake_linear_cycles` | status: **`MOD_P`**

**Statement.**

```text
What was wrong: T1 reported (05:19Z) that the candidate family nu_t "dies at order s^4" on the basis of three random
values of t at three primes, and that 58 of 64 support patterns were obstructed on the basis of random
coefficients. Check C10 found that at t^4 = -4 the candidate passes order 4: it was a live candidate.
What replaced it: (1) a certificate valid for all t != 0 at order 5 (D-CANDIDATE-NU-T-KILLED, exact, check C14);
(2) an exact primary decomposition of the fourth-order cone on the stratum y = w D_0, giving ten families, each
killed by universal certificates (D-TEN-FAMILIES-KILLED, modulo three primes, not independently checked).
```

**Conditions.** n/a

**Evidence.** Check C10; T1 06:11Z, 15:08Z, 15:14Z, 15:25Z.

**Independent check.** C10 (found it), C14 (confirmed the replacement for nu_t).

**Not established.** Strata still covered by random samples only (O-FERMAT-LOOPHOLES, item 3).

**Known before.** n/a

**Reproduce.** not reproducible from this repository: see D-CANDIDATE-NU-T-KILLED.

**Session references (files not public).**

LEDGER_DISCOVERY.md "[T1] 05:19Z", "[CHECK C10] 06:07Z", "[T1] 06:11Z", "[T1] 15:14Z"; END_OF_ROUND_REPORT.md
(Corrections, item 5).

---

## C-RANK-28-MISREADING

**'8 quadrics annihilate the class' for lambda = 2 was a misreading: they are the partial derivatives; 28 is the maximal rank**

kind: `correction` | area: `movasati_conjecture` | status: **`MOD_P`**

**Statement.**

What was wrong: T3's entry of 16:30Z said that for lambda = 2, 1/2, -2, 3, 5/3 "exactly 8 quadrics annihilate the
class, and they generate only 64 cubics", and that the rank 28 was an "upper bound from the eightfold cone-type
family". What replaced it (T3, 16:33Z): the catalecticant Cat(2,2) is a 36 x 36 matrix on all quadrics and the 8
partial derivatives of the cubic are always in its kernel. So 28 = dim R_2 is the maximal possible rank and for
these lambda NO quadric outside the Jacobian ideal annihilates the class. For lambda = -1 the kernel in R_2 has
dimension 10 (18 quadrics including the 8 partials); for lambda = 1, 16. Likewise on eightfolds the 29 quadrics
include the 10 partials. The ranks and the contrast 18 against 28 are unaffected.

**Conditions.** n/a

**Evidence.** T3 16:33Z (own correction).

**Independent check.** C18 notes that 8 of the 9 vanishing factors on the lambda = 2 arc are the partial derivatives.

**Not established.** n/a

**Known before.** n/a

**Reproduce.** not reproducible from this repository: see D-RANK-INVARIANT.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T3] 16:30Z", "[T3] 16:33Z".

---

## C-CUBIC-LIFT-DEPENDENCE

**'The cubic c is non-degenerate' at triple points depends on a choice of lift; condition (A) replaced it**

kind: `correction` | area: `fake_linear_cycles` | status: **`PAPER_ARGUMENT_AI`**

**Statement.**

What was wrong: in the arc argument for the corank-6 strata T1 used, in the case b < a, that the cubic c on the
6-dimensional kernel has only the trivial critical point. But c is defined only up to c -> c + 3 sum L_i(nu) q_i(nu)
(change of the lift of the kernel); the checker built a lift whose cubic is singular.
What replaced it: condition (A) (no critical point of the reduced cubic c + 3 sum tau_i q_i with nu != 0) is
lift-invariant and already covers that case. T1 dropped the appeal to non-degeneracy of c. At pencil-type points
the issue does not arise: the system of quadrics has dimension r = 0, so c and Q_(tau tau) are canonical there.

**Conditions.** n/a

**Evidence.** Check C19 (remark on (ii)); T1 18:10Z.

**Independent check.** C19

**Not established.** n/a

**Known before.** n/a

**Reproduce.** not reproducible from this repository: see D-CORANK6-STRATA.

**Session references (files not public).** LEDGER_DISCOVERY.md "[CHECK C19]" (REMARK on (ii)), "[T1] 18:10Z", "[T1] 19:27Z" (item D).

---

## C-VOID-OUTPUTS-AND-CHECKER-BUGS

**Outputs declared void, and bugs found in the teams' and checkers' own code before the reported numbers**

kind: `correction` | area: `methods` | status: **`COMPUTED_ONLY`**

**Statement.**

```text
Recorded so that nobody quotes the void numbers:
(1) T1, split_universal.py: the printed line "critical points with n != 0: dim 4" came from a reserved-name bug in
    the generated Singular code and means nothing; the valid statement is the nilpotency test of D-PENCIL-W-ALGEBRA.
(2) T1, step26_quartic.py: used a wrong space (a degree slip); its output is void and was not used.
(3) T2, w_tangent.py: a bug in the random combination of basis vectors once produced a spurious order-2
    obstruction at lambda = -1; fixed before the reported run.
(4) Check C19: the first runs of condition (A) used wrong multiplicities for the coefficients of c; found by a
    self-test, discarded and rerun. Check C21: an int64 overflow in a cross-check; fixed, main value unaffected.
(5) T1's ratios "lambda = 25854, 28317" for the comparison with Res_h[w] refer to T1's normalisation of Res_h; in
    the checker's normalisation the ratio is -1. They are not comparable.
(6) Check C1: with the opposite weight convention the projection limit of V_6 is different and the claim fails;
    the confirmed convention is x7 -> t x7, t -> 0.
```

**Conditions.** n/a

**Evidence.** The entries named in session_refs.

**Independent check.** n/a

**Not established.** n/a

**Known before.** n/a

**Reproduce.**

not reproducible from this repository: this entry is a record of errors and void outputs; there is nothing to
recompute.

**Session references (files not public).**

LEDGER_DISCOVERY.md "[T1] 19:27Z" (A), "[T1] 05:23Z", "[T2] 04:33Z", "[CHECK C19]" (last paragraphs), "[CHECK
C21]", "[CHECK C1]".

---

## C-WORDING-8-7-AND-20-19

**'8 -> 7' and '20 -> 19' are K and H at the Fermat point for every nonzero coefficient, not codimensions of a Hodge locus**

kind: `correction` | area: `first_order` | status: **`EXACT`**

**Statement.**

What was wrong: the task given to the package builders described the pairs "8 -> 7" and "20 -> 19" as published
numbers attached to the difference of the two classes, in the sense of codimensions of the Hodge locus.
What the sources say (machine-read): 8 and 20 are the codimension K of the locus of cubics containing the two
linear spaces; 7 and 19 are the codimension H of the ZARISKI TANGENT SPACE of the Hodge locus AT THE FERMAT POINT,
the same for every nonzero coefficient. That the Hodge locus itself has codimension 7, resp. 19, is the content of
Movasati's Conjecture 1, not a published theorem. The package README and tests were worded accordingly.

**Conditions.** n/a

**Evidence.** tests/README.md; tests/SOURCES.md A1 (reading notes).

**Independent check.** n/a

**Not established.** n/a

**Known before.** n/a

**Reproduce.** tests/validation/03_movasati_H_fermat_exact.m2 (the pairs (7,8), (19,20) as (H,K) for several coefficients).

**Session references (files not public).** tests/README.md (paragraph 'One point where the wording of the task and the sources differ'); tests/SOURCES.md A1.

---

## C-NIGHT-WS-STATEMENT

**Night run: a statement on the family W_s at lambda_0 was false; replaced by the Northcott residual R**

kind: `correction` | area: `first_order` | status: **`PROVED_AI_UNREVIEWED`**

**Statement.**

What was wrong: a draft of the general theorem described the witness cycle at lambda_0 as the fibrewise closure of
{f_j h_n = s a_j} minus {h_n = 0}. Counterexample (AI referee 11): skew lines on a quartic surface with M_00, M_10
sharing a linear factor modulo h_1: the quotient has Hilbert polynomial 4m and its saturation 3m + 1; the fibre is
a cubic plus a fixed line.
What replaced it: W_s defined as the fibre of a flat family; and, from the same referee, the residual
R = V(p, M^T f, det M), which lies in {F - s det M = 0} for all s and satisfies
[Y_1] + (-1)^(c-1) [Y_2] = m'' h^k - [R] (D-LIAISON-IDENTITY). Also corrected then: the type list for c = 5 (the
type (1,1,1,1,1)+(1,1,1,1,3) admits no smooth X: the hypothesis "all degrees < d" cannot be dropped).

**Conditions.** n/a

**Evidence.** Night-run referee 11 (report and scripts); main thread re-derivation.

**Independent check.** AI referees 11, 12 of the night run (no C-number).

**Not established.** n/a

**Known before.** n/a

**Reproduce.** not reproducible from this repository: see D-LIAISON-IDENTITY.

**Session references (files not public).** LEDGER.md "13:38Z REFEREE 11 on PROOF_G section 5A"; night/paper3/paper3.tex (Computations, items (iv), (v)).

---

## C-NIGHT-PROP-94PRIME-GAP

**Night run: the first proof of 'the formula for every r' had a gap; repaired with Cramer's rule and the pointwise formula**

kind: `correction` | area: `second_order` | status: **`PROVED_AI_UNREVIEWED`**

**Statement.**

What was wrong: the first proof of Proposition 9.4' of note 3 decomposed a virtual deformation into weight-0
deformations; it failed for entries of Mdot of negative formal degree (found by AI referee 24).
What replaced it: that referee's argument (Cramer's rule plus Lemma 2.1(3)), re-derived by the coordinating thread
and read by referee 25 (no mathematical error; step (ii) and its mirror confirmed numerically; a wrong matrix
index fails). An earlier draft by local residues is kept in the session files and is not used.

**Conditions.** n/a

**Evidence.**

LEDGER.md, five-hour block; Lean: lean/mathlib/EveryR.lean certifies step (ii) from hypotheses; negative tests
rejected.

**Independent check.** AI referees 24, 25 of the night run (no C-number).

**Not established.** The additions of version 21 were not re-read.

**Known before.** n/a

**Reproduce.**

The package test PA-S7 in M2/HodgeLociCI/SecondOrderTests.m2 compares the formula with the pointwise formula at an
instance with r = -1 (exact over Q).

**Session references (files not public).** LEDGER.md "five-hour block, part 1", "part 2"; night/referee24_report.md, night/referee25_report.md.

---

## C-NIGHT-VACUOUS-CHECKS

**Night run: three numerical checks of the pointwise formula tested less than claimed**

kind: `correction` | area: `second_order` | status: **`PROVED_AI_UNREVIEWED`**

**Statement.**

What was wrong: (1) the 780-comparison Fermat check of the pointwise second-order formula (night check T7) is
vacuous off the Jacobian ideal: it cannot fail there (AI referee 23); (2) the random-point consistency tests test
only the equal weighting of the own-pair terms: the "equal weights" test is blind to the shared pairs, whose
terms cancel one by one for every c; the "pencil vanishing" test is termwise formal for c = 1, and additivity is
termwise formal (referees 24, 25); (3) the sentence "(CG) is the one unopened citation" was inaccurate: Fulton,
Griffiths and others were not opened either.
What replaced it: an explicit list of what each check tests (Remark 10.3 of note 3); the statement that, at that
date, no numerical test compared the pointwise formula off the Jacobian ideal with an independently computed
period. Later, check C19 of the discovery round did such a comparison by dual numbers for one degree type
(D-POINTWISE-FORMULA).

**Conditions.** n/a

**Evidence.** LEDGER.md, five-hour block ('CORRECTIONS OWED TO THE USER'); night/CHECKS_R2.md.

**Independent check.** AI referees 23, 24, 25 (night run).

**Not established.** n/a

**Known before.** n/a

**Reproduce.** not reproducible from this repository: a record about checks.

**Session references (files not public).** LEDGER.md "five-hour block, part 1", "part 2" (CORRECTIONS OWED TO THE USER); night/paper3/paper3.tex (Remark 10.3).

---

## C-NIGHT-SMALLER-CORRECTIONS

**Smaller corrections of the night run and of the package phase**

kind: `correction` | area: `methods` | status: **`COMPUTED_ONLY`**

**Statement.**

```text
(1) Note 2 addendum: the sentence "M = 0 modulo (f,h) iff the arrangement is balanced" was wrong (odd d; antipodal
    roots); corrected. A sharp test followed: on the Fermat sextic with an unbalanced arrangement and antipodal
    pairs of quadratic factors both the numeric A and the formula vanish; for generic pairs both are nonzero.
(2) Note 3, Corollary 9.2: the constant in the display was wrong outside adapted coordinates (a factor J^-1);
    corrected by referee 18.
(3) Note 1: table rows with excess >= 2 relabelled as evidence; Kloosterman's Theorem 5.3 no longer cited for k = 3.
(4) A Lean draft of the second-order law omitted the pencil hypothesis (the note was right, the draft was wrong).
(5) Referee 21's by-hand list had a sign slip for (3,4,2): E' is n_1 = n_2 + n_3 (found while generating the Lean
file).
(6) An interim message contained wrong counts ("61 configurations", "20,772 comparisons"); the recorded counts are
    39 distinct configurations in 67 runs and 25,344 comparisons.
(7) T2's scroll formula had a sign typo: s = 3d + 4 e_1^2 + 8 e_1.k + 3 k^2 - 3 chi; T.T = 15 is unchanged.
(8) T3 04:46Z: the dC test used 8 random T at two of the (prime, lambda) pairs and 12 at the third.
(9) Check C4: the multiplication map is R_3 -> R_7 with dim R_7 = 8 ("both of dimension 56" was a slip in the
brief).
(10) Package tests: three checks failed on their first run because of mistakes in the test inputs (a degree type
    listed under tau < 0 that has tau = 0; a grid ignoring kd - 2k - 2 >= 1; a table row read with the wrong d); the
    inputs, not the expected values, were corrected.
```

**Conditions.** n/a

**Evidence.** The entries named in session_refs.

**Independent check.** n/a

**Not established.** n/a

**Known before.** n/a

**Reproduce.**

not reproducible from this repository: this entry is a record of errors and void outputs; there is nothing to
recompute.

**Session references (files not public).**

LEDGER.md "REFEREE 6b", "REFEREE 18", "REFEREE RESULT", "LATE ADDITION", "Lean file LinearListCert", "SECOND ROUND
OF CHECKS"; LEDGER_DISCOVERY.md "[T2] 15:42Z" (last item), "[T3] 04:51Z", "[CHECK C4]"; tests/README.md.

---

## M-UNIVERSAL-CERTIFICATES

**Universal certificates: a form q that kills a velocity for every arc, at a Fermat point**

kind: `result` | area: `methods` | status: **`EXACT`**

**Statement.**

```text
Method. At a Fermat hypersurface where the Hodge locus is the critical locus of W(G) = Phi(exp(-G)) and Phi is in
closed form: to show that a direction y is the velocity of no arc in the Hodge locus, find a form q such that
Phi(q y^a P) = 0 for all forms P of degree d r with a + 2r <= N (and a < N), and Phi(q y^N) != 0. Then for EVERY
formal arc s y + s^2 G_2 + s^3 G_3 + ... with arbitrary G_j,
    [s^N] Phi(q exp(-G(s))) = (-1)^N Phi(q y^N)/N!  != 0,
and the lower coefficients vanish. Since Phi(q exp(-G)) is a combination of the equations, the direction is dead.
The certificate is a single polynomial identity, checkable by hand through pair-degree bookkeeping, and it is
valid for all free choices and all values of a parameter kept symbolic.
```

**Data.**

Example: q = x0 x6 (x2 - z x3)^2, N = 5, for the family nu_t (D-CANDIDATE-NU-T-KILLED). Spaces of order-4
certificates at general points of the ten families: 11 or 21 independent forms (D-TEN-FAMILIES-KILLED).

**Conditions.** Closed-form periods (Fermat point); the certificate speaks about velocities exactly proportional to y.

**Evidence.** Team T1, 15:08Z, 15:14Z.

**Independent check.** C14 (exact, symbolic in t; also by brute force on 30 dense random arcs).

**Not established.**

Limits of the method (C14): it says nothing about zero-velocity arcs with leading term y, nor about velocities y +
k; one test form cannot exclude y from the tangent cone.

**Known before.** n/a (a method)

**Reproduce.**

not reproducible from this repository: needs the closed form Phi on arbitrary polynomials (see
O-PACKAGE-FEATURES-NEEDED, item 5).

**Session references (files not public).** LEDGER_DISCOVERY.md "[T1] 15:08Z", "[T1] 15:14Z", "[CHECK C14]".

---

## M-CATALECTICANT-ALONG-ARCS

**Catalecticant / invariant-factor method along arcs: finite-order invariants of a Hodge class on a component**

kind: `result` | area: `methods` | status: **`EXACT`**

**Statement.**

Method. For an arc F_eps = F_0 - sum eps^j T_j along which all period functions vanish to order N, compute
pi_eps(m) = period of m Omega / F_eps^(k+1) for all monomials m of degree NV/2 (one pole order higher than the
equations), as series modulo eps^(N+1). Form the catalecticants Cat(a,b)[m_1][m_2] = pi_eps(m_1 m_2) and their
invariant factors over the power series ring. The ranks at the general point of the arc are invariants of the
component (which forms of each degree annihilate the class in the Jacobian ring): a Hilbert function, the "quadric
part", whether a linear form annihilates the class. This separates candidate geometric descriptions without
knowing a cycle: 18 / 12 + linear form / 28 on sixfolds (D-RANK-INVARIANT).
Built-in self-test: pi_eps(H * dF_eps/dx_i) = 0 modulo eps^(N+1) (Griffiths' reduction).
Cautions: (1) ranks along special arcs are lower semicontinuous: a factor reported zero is zero only to the stated
order; (2) a truncated arc agrees with a true arc of the component only modulo eps^(N-1) at smooth base points and
modulo eps^(N-3) at a point of multiplicity 3; (3) some numbers are forced: for any class on a cubic eightfold with
tangent codimension 26 the quadric part has dimension 55 - 26 = 29, so only finer data (the linear form) test
anything; the partial derivatives always lie in the kernel.

**Conditions.** A Fermat base point (closed-form periods) in the session's implementation.

**Evidence.** Team T3 (annlib.py), round 4; reused by T2 in round 5 for the splitting.

**Independent check.**

C18 (exact, own engine, three ways, with controls: dropping terms of the arc or changing one coefficient produces
further factors). C20 reused its own version of the tool.

**Not established.** n/a

**Known before.** n/a (a method)

**Reproduce.**

not reproducible from this repository: not implemented in the package (O-PACKAGE-FEATURES-NEEDED, item 2). Exact
arcs to start from: M2/HodgeLociCI/data/x1_lam-1_arc.txt, M2/HodgeLociCI/data/six_lam-1_arc.txt,
M2/HodgeLociCI/data/six_lam2_arc.txt.

**Session references (files not public).**

LEDGER_DISCOVERY.md "[T3] 16:30Z" (TOOL), "[T3] 16:40Z" (precision note), "[T3] 16:27Z" (caution on 29), "[CHECK
C18]".

---

## M-DUAL-NUMBER-AND-PADIC-SECOND-ORDER

**Second-order period data from first-order residues: dual numbers and p-adic points**

kind: `result` | area: `methods` | status: **`MOD_P`**

**Statement.**

```text
Method. The second-order period functional of a complete intersection (D-POINTWISE-FORMULA) can be obtained, or
checked, from first-order residues only:
(a) dual numbers: for a velocity g_1 of the regular sequence g, the e-derivative of Res[P'/(g + e g_1)] computed
over
    F_p[e]/(e^2) equals minus the second-order functional on P' * G_v. Over F_p[e]/(e^3) the same gives the
    second-order variation of the first-order Hessian along a family (route E of check C21, with a Schur
    reduction to the kernel);
(b) p-adic points: compute the first-order Hessian modulo p^3 at points l_m + p gamma_m and read the first- and
    second-order variation from the p-adic digits (T1's strata_padic.py);
(c) Griffiths-Dwork consistency: Phi_(t+d)(sum A_i dF/dx_i) = Phi_t(sum dA_i/dx_i) fixes sign and normalisation on
the
    Jacobian ideal.
Residues are computed by normal forms: Res[A/(g)] = (product of the degrees) * (coefficient of A modulo (g) along
det Jac(g)); for a sequence with one pair squared, det Jac picks up the factor 4 phi psi.
```

**Conditions.** Regular sequences; a prime not dividing the relevant degrees.

**Evidence.** Team T1 (round 5, p-adic); checks C19 (routes R1-R3) and C21 (routes E, W).

**Independent check.**

C19 and C21: the routes agree with each other and with the squared-pair formula in every test (two primes, new
random points).

**Not established.** Third order (O-THIRD-ORDER-PERIOD-FORMULA).

**Known before.** n/a (a method)

**Reproduce.**

Run from the repository root (Macaulay2 1.22). The residue normalisation with the package (Res[det Jac G / G] =
product of the degrees):

```
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
R = ZZ/32003[a,b,c]; G = {a^2 + b*c, b^3 - a*c^2, c^2 + a*b};
print(grothendieckResidue(det jacobian matrix{G}, G), product(G, g -> first degree g));
```

Expected: the same number twice (12). The dual-number routes themselves are not in the package.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T1] 16:14Z" (item C), "[CHECK C19]" (R1-R4), "[CHECK C21]" (route E, route W).

---

## M-ENDOMORPHISM-SPLITTING-TEST

**Endomorphism-algebra test: does a space of quadrics split into two determinantal nets?**

kind: `result` | area: `methods` | status: **`MOD_P`**

**Statement.**

Method. Given a space Q of quadrics (here the 18 quadrics annihilating a class, over a field or a power series
ring), compute its linear syzygies and the algebra of endomorphisms E of Q with (E (x) 1)(syzygies) inside the
syzygies. If Q is the sum of the 2 x 2 minors of two 3 x 3 matrices of linear forms, the algebra has dimension 2
(the two projectors); if Q does not split, dimension 1. Over a power series ring: the second generator N satisfies
a quadratic equation; the splitting exists over the Laurent series field iff its discriminant is a nonzero square
there (even valuation, square leading coefficient), and the valuation of the discriminant gives the pole order of
the projectors (12 and 6 in D-DEGENERATION-ALONG-ARC). Then each summand is tested by its numbers: rank 9,
multiplication rank 56 into cubics, 16 linear syzygies.
Calibration over F_p: 18 random quadrics: 24 syzygies, algebra of dimension 1; the nine minors of one random
matrix: rank 56, 16 syzygies, dimension 1; the minors of two random matrices: rank 112, 32 syzygies, dimension 2.
Precision warning: with the arc known modulo eps^19 the discriminant looked zero; the splitting appeared modulo
eps^20.

**Conditions.** Enough precision: the chain loses 2 + 2 + 3 orders, then 12 for the discriminant.

**Evidence.** Team T2, round 5.

**Independent check.** C20 (own linear algebra over F_p[[eps]], both primes, with the three calibration controls).

**Not established.** That nets with the numbers 9 / 56 / 16 are generated by minors of matrices of linear forms (not shown).

**Known before.** n/a (a method)

**Reproduce.**

not reproducible from this repository: not in the package. The calibration is a few lines of Macaulay2 (syzygies
of random quadrics and of minors).

**Session references (files not public).** LEDGER_DISCOVERY.md "[T2] 18:11Z", "[CHECK C20]" (1), (controls).

---

## M-F4-SMALL-PRIMES

**Use primes below 32768 for Groebner-heavy steps in Macaulay2; large primes are much slower**

kind: `result` | area: `methods` | status: **`COMPUTED_ONLY`**

**Statement.**

Practical observation recorded for the package: Macaulay2 1.22 uses its fast Groebner engine (F4-type linear
algebra) only for primes below 32768; with larger primes the same computations are much slower. The package's
random instances default to ZZ/32003. The session's Python engines for arcs at Fermat points used primes near 2^28
(268435399, 268435291) and checkers used primes near 2^31; these are linear-algebra codes, not Groebner codes.
For exact statements the package works over Q or cyclotomic fields: sparse arcs reach order 9 in seconds, dense
ones are practical only modulo a prime.

**Conditions.** Macaulay2 1.22 on the session's machine (2 cores, 7 GB).

**Evidence.** AGENTS.md ('Things that trip agents up'); README.md (Limitations); timings in tests/README.md.

**Independent check.** none

**Not established.** No timing table comparing engines was recorded in the sources read: 'much slower' is not quantified there.

**Known before.** n/a (a method)

**Reproduce.**

Run from the repository root (Macaulay2 1.22). tests/run_all.sh 13_discovery (all instances at ZZ/32003; about 5 s
for four families in up to 10 variables).

**Session references (files not public).** AGENTS.md; README.md; package/PHASE_P_LOG.md (not read in detail: timings not determined from the sources).

---

## M-EXACT-CERTIFICATE-FILES

**Small exact certificate files (arc + dual functional) that a third party can re-verify without rerunning the search**

kind: `result` | area: `methods` | status: **`EXACT`**

**Statement.**

```text
Method. To make a finite-order statement at a Fermat point checkable: export (1) the planes, lambda and the arc
terms T_1, ..., T_(N-1) with exact coefficients a + b z; (2) the claim "all period coefficients of orders < N
vanish";
(3) the order-N coefficient vector c_N; (4) a left-kernel vector K of the first-order map with K.L = 0 and K.c_N
!= 0;
(5) the ranks that make the logic work. The search (which may be modulo p, with rational reconstruction from two
conjugate reductions) is not needed for verification. One arc suffices to exclude a component of the expected
dimension when the Zariski tangent space has exactly that dimension.
What a certificate does not certify: the arguments drawn from the numbers, and any claim of independence of
choices (claim 4 of the X1 file needed a separate computation, check C11).
```

**Conditions.** The period rules (1)-(5) of the export README (tests/data/fermat/README_export_c3.txt).

**Evidence.** Team T3; the package functions fermatReadCertificate, fermatWriteCertificate, fermatVerifyCertificate.

**Independent check.** C3, C11, C18 reproduced the files with independent code; the package rejects two corrupted files (test 14).

**Not established.** n/a

**Known before.** n/a (a method)

**Reproduce.**

Run from the repository root (Macaulay2 1.22). tests/run_all.sh 14_fermat (file
tests/validation/14_fermat_certificates.m2; 26 checks including two negative controls). Worked session:
docs/04_fermat_certificate.md.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T3] 04:44Z", "[CHECK C3]"; tests/data/fermat/README_export_c3.txt.

---

## M-TANGENT-CODIM-FROM-IDEAL

**Tangent codimension of the Hodge locus of any half-dimensional subvariety from its ideal alone**

kind: `result` | area: `methods` | status: **`PAPER_ARGUMENT_AI`**

**Statement.**

Method. Let Z be a subvariety of dimension k in a smooth X = {F = 0} of degree d in P^(2k+1), I its ideal, J the
Jacobian ideal of F, R = S/J and t = (k+1)(d-2) (R has socle degree 2t). The period polynomial P of [Z]_prim lies in
R_t and is orthogonal to (I + J)_t. If (I + J)_t has codimension 1 in S_t, P is determined up to a scalar, and the
Zariski tangent space of the Hodge locus of [Z], {G in S_d : G P in J}, equals {G : G S_e inside (I + J)_t}
= ((I + J) : m^e)_d with e = t - d = kd - 2k - 2. Its codimension is the rank of the multiplication pairing
(S/(I+J))_d x (S/(I+J))_e -> (S/(I+J))_t, the last space being a line.
No parametrisation, no cohomology computation and no period integral is needed.
Validation values: one 3-plane in a cubic sixfold 4; two planes spanning a hyperplane 7; V_6 8; quintic del Pezzo
threefold 7; a k-plane in general: binomial(k+d,d) - (k+1)^2.
Corollary used often: if a linear form L vanishes on Z then L P = 0 in R; on cubic sixfolds (e = 1) the tangent
codimension is then at most 8 - dim I_1.

**Conditions.**

The primitive class of Z is nonzero and the annihilator is one-dimensional in the relevant degree (reported by the
package as 'hypothesis', not proved). Fails at special points (N-CODIM-IJ4-AT-FERMAT).

**Evidence.**

Night run (tools/periods.py: 'Ann(K) trick'); teams T2, T3 and checks C1, C12, C13, C15, C17 all used it with
independent code. Package: hodgeLocusTangentCodim; test 07 compares with published numbers for complete
intersections.

**Independent check.** C1, C12, C13, C15, C17 (independent implementations in Singular and Macaulay2 agree).

**Not established.**

It gives a tangent space, hence an upper bound for the dimension of the Hodge locus; equality needs a family of
that dimension or a bound on the number of equations (see C-EIGHTFOLD-CHAIN-STEP4).

**Known before.**

The description T V = (J : P)_d is published (Villaflor Loyola arXiv:1812.03964, Corollary 3; arXiv:2001.01019,
Propositions 2.1, 2.2). The use of the ideal of Z without computing P: standard Macaulay duality; no source was
read for it.

**Reproduce.**

Run from the repository root (Macaulay2 1.22). See the snippets of D-TWO-DET-FAMILY-NUMBERS, D-FLAG-THREEFOLD-V6,
D-SEGRE-FOURFOLD, and tests/run_all.sh 07_villaflor (file tests/validation/07_villaflor_single_cycle.m2).

**Session references (files not public).** LEDGER.md "Tools" (tools/periods.py); LEDGER_DISCOVERY.md "[T2] 04:05Z", "[T2] 04:20Z"; docs/API.md.

---

## M-STRATA-INSTEAD-OF-DIRECTIONS

**To exclude extra components, study general points of the degeneracy strata, not more directions at the special point**

kind: `result` | area: `methods` | status: **`PAPER_ARGUMENT_AI`**

**Statement.**

Lesson of the fake-linear-cycle work. A classification of tangent directions at a very special point (Fermat)
cannot see components whose tangent cone lies inside the tangent space of the known component, and it is polluted
by explained loci that pass through the special point. Better: any extra component B through the special point
meets the known component Sigma in a set of positive dimension (it contains the orbit: dimension >= 25 for
Sigma_4), inside the degeneracy locus of the normal Hessian of Sigma. So (1) list the degeneracy strata of the
normal Hessian along Sigma; (2) at a GENERAL point of each stratum compute the reduced potential on the kernel:
net of quadrics from the first-order variation of the Hessian, cubic, and at deeper strata the second-order
variation; (3) exclude arcs by weighted leading-term analysis (three regimes by the relative orders of the normal
and stratum coordinates). Emptiness at one point of an irreducible stratum implies emptiness at its general point
when the leading problem is canonical.

**Conditions.** The splitting lemma for the potential (complex-analytic); constant rank along the stratum near the point.

**Evidence.**

Team T1, 15:25Z (item 2 of 'not covered'), rounds 5 and 6: closed the conic divisor and the corank-6 strata this
way.

**Independent check.** C19 (the corank-6 case).

**Not established.** Completeness of the list of strata.

**Known before.** n/a (a method)

**Reproduce.** not reproducible from this repository: a method note.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T1] 15:25Z", "[T1] 15:32Z" (b), "[T1] 16:14Z", "[T1] 19:20Z" (semicontinuity).

---

## M-BLIND-CHECKS-WITH-CONTROLS

**One blind check per claim, with negative controls and 'what a wrong claim would have looked like'**

kind: `result` | area: `methods` | status: **`COMPUTED_ONLY`**

**Statement.**

Working rule of the discovery round, recorded because it caught five errors (C-AVERAGING-ARGUMENT,
C-EIGHTFOLD-CHAIN-STEP4, C-PLANE-LEMMA-GAP, C-RANDOM-SAMPLING-MISSED-VALUES, C-CUBIC-LIFT-DEPENDENCE): each new
claim gets exactly one independent check by an agent that reads only the exported data or the statement, writes
its own code, does not run the author's scripts, and reports: the verdict per item; what was NOT covered; negative
controls showing that the test can fail (a changed coefficient, a wrong sign, a random input); and what a wrong
claim would have looked like. Exports carry a README with the normalisations so that a blind recomputation is
possible. Checkers also report their own bugs.
Things that the checks could not do: read the cited literature in the original; verify the unreviewed notes the
claims are conditional on; anything in characteristic 0 where the claim is modulo p.

**Conditions.** n/a

**Evidence.** Checks C1 to C21 of the discovery ledger.

**Independent check.** n/a

**Not established.** A blind AI check is not a human review.

**Known before.** n/a (a method)

**Reproduce.**

not reproducible from this repository: a working rule. Its package counterpart: negative controls in
tests/validation/14_fermat_certificates.m2 and the Lean negative tests (lean/README.md).

**Session references (files not public).** LEDGER_DISCOVERY.md "Rules (from the user)", "Standing rules of the project", entries "[CHECK C1]" to "[CHECK C21]".

---

## M-LEAN-CERTIFICATES

**Lean certificates: kernel-checked finite computations and deductions from stated hypotheses**

kind: `result` | area: `methods` | status: **`EXACT`**

**Statement.**

The repository ships Lean 4 files that the Lean kernel accepts (13 core files without Mathlib, 5 files with
Mathlib, 12 negative tests that are rejected). They certify: explicit integer and polynomial computations at
Fermat cubics and at three non-Fermat cubic sixfolds (first-order directions, the second-order quantity
ob3(lambda) = -8 lambda (lambda - 1), the eightfold analogue 4 lambda (lambda - 1), the closed formula -det C *
lambda (lambda - 1)); one explicit sextic surface with two disjoint conics; matrix identities (Cramer, Pfaffian,
determinants of transition matrices giving (-1)^c det M); the polynomial algebra of five by-hand instances of the
linear list; integer lattice facts; and abstract deductions (the second-order law, the pointwise formula, the
formula for every r) from hypotheses stated as hypotheses.
They certify NO statement about a Hodge locus: the geometry (periods, residues, Jacobian rings) is described in
comments and is not formalised.

**Conditions.** Lean 4.36.0; for the Mathlib files a built Mathlib v4.36.0.

**Evidence.**

Night run (16 files re-run by the main thread, then the late additions); lean/README.md gives the re-run status of
the copies in this repository.

**Independent check.** The Lean kernel. No human read the statements against the notes.

**Not established.** That the certified identities are the ones the notes need (statement-versus-note match is by AI only).

**Known before.** n/a (a method)

**Reproduce.**

Run from the repository root (Macaulay2 1.22). With Lean 4.36.0 on the PATH: lean/run_all.sh core (13 files in
lean/core plus one negative test; about 5 minutes on 2 cores). The Mathlib files need lean/run_all.sh mathlib with
a built checkout (not re-run for this registry).

**Session references (files not public).** lean/README.md; LEDGER.md "18:44Z Regression", "LATE ADDITION", "five-hour block".
