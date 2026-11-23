# Second order: excess directions die away from lambda_0

- Second-order law: the obstruction on the excess directions is ((lambda - lambda_0)/lambda) times a quantity independent of lambda; where it is nonzero the Hodge locus is V_Z with a non-reduced structure.
- Exceptions are listed: rows with no dependent equation (K = 0), one row where only some directions die, and special points (Fermat) where the second-order term vanishes.
- All of it rests on formulas of AI-written, unreviewed notes; instances are computed modulo primes or exactly.

> **Status of everything on this page:** produced by AI agents, checked only by other AI agents, reviewed by no human. Sources of published results were read by machine (see `tests/SOURCES.md`). The notes cited as "unreviewed note 1, 2, 3" are AI-written and not public. Nothing here is, or bears on, a proof or disproof of the Hodge conjecture. This is a registry of what was found, ruled out or left open, not a list of established theorems.

Generated from `discoveries/registry.yaml` by `discoveries/check_registry.py --write-pages`. Do not edit this page by hand: edit the registry. Notation: [`NOTATION.md`](NOTATION.md). Status vocabulary: [`README.md`](README.md).

## Entries on this page (11)

| id | status | title |
|---|---|---|
| [D-SECOND-ORDER-LAW](#d-second-order-law) | `PROVED_AI_UNREVIEWED` | Second-order law with one excess direction: the term is ((lambda - lambda_0)/lambda) * A |
| [D-SECOND-ORDER-SEVERAL-DIRECTIONS](#d-second-order-several-directions) | `PROVED_AI_UNREVIEWED` | Several excess directions in the range: a system of quadrics, the same law, non-reduced locus |
| [D-SECOND-ORDER-OUTSIDE-RANGE](#d-second-order-outside-range) | `PROVED_AI_UNREVIEWED` | Outside the range: the law survives on E' = ker(det M : A_tau -> A_d); formula for every r |
| [D-FORMULA-FOR-A](#d-formula-for-a) | `PROVED_AI_UNREVIEWED` | Formula for the second-order coefficient A as a derivative of a residue symbol; A != 0 for general data |
| [D-POINTWISE-FORMULA](#d-pointwise-formula) | `PROVED_AI_UNREVIEWED` | Pointwise second-order period formula: a sum of residue symbols with one pair squared |
| [D-LINEAR-LIST-SECOND-ORDER](#d-linear-list-second-order) | `PROVED_AI_UNREVIEWED` | Two linear subspaces, lambda != lambda_0: non-reduced structure on V_Z exactly for the list L |
| [D-SECOND-ORDER-EXCEPTIONS](#d-second-order-exceptions) | `MOD_P` | Exceptions to 'all excess directions die': rows with K = 0 and one row where only some die |
| [D-COPLANAR-LINES-FERMAT](#d-coplanar-lines-fermat) | `EXACT` | Two coplanar lines on Fermat surfaces: the second-order term vanishes on the quintic, not on the sextic |
| [D-CUBIC-SIXFOLD-DETC](#d-cubic-sixfold-detc) | `PROVED_AI_UNREVIEWED` | Cubic sixfolds, two 3-planes meeting in a point: Hessian = nu * det C * ((lambda-1)/lambda) * A^2 |
| [D-CUBIC-EIGHTFOLD-INVARIANT](#d-cubic-eightfold-invariant) | `PROVED_AI_UNREVIEWED` | Cubic eightfolds (4-planes meeting in a line) and sixfolds (3-planes meeting in a line): the invariant D |
| [D-SURFACES-DISJOINT-CURVES](#d-surfaces-disjoint-curves) | `PROVED_AI_UNREVIEWED` | Disjoint complete-intersection curves on surfaces (tau = 0, c = 2): law (r+1)/r, special coefficient -1 |

## Related entries on other pages

| id | kind | status | page | title |
|---|---|---|---|---|
| [O-THIRD-ORDER-PERIOD-FORMULA](07_open_problems.md#o-third-order-period-formula) | open | `OPEN` | 07 | A third-order pointwise period formula (the next case of the residue formula with squared pairs) |
| [C-SECOND-ORDER-CHECKER-OUTSIDE-RANGE](08_corrections_and_lessons.md#c-second-order-checker-outside-range) | correction | `MOD_P` | 08 | secondOrderObstruction said ALL SURVIVE outside the range where the locus is not smooth at order 2; now NOT DETERMINED |
| [O-COMMON-ZEROS-AND-SECOND-ORDER-GAPS](07_open_problems.md#o-common-zeros-and-second-order-gaps) | open | `OPEN` | 07 | Second order: quadrics with common zeros, condition (S) failing, and cubic eightfolds in the package tests |
| [C-NIGHT-PROP-94PRIME-GAP](08_corrections_and_lessons.md#c-night-prop-94prime-gap) | correction | `PROVED_AI_UNREVIEWED` | 08 | Night run: the first proof of 'the formula for every r' had a gap; repaired with Cramer's rule and the pointwise formula |
| [C-NIGHT-VACUOUS-CHECKS](08_corrections_and_lessons.md#c-night-vacuous-checks) | correction | `PROVED_AI_UNREVIEWED` | 08 | Night run: three numerical checks of the pointwise formula tested less than claimed |
| [N-SPECIAL-REGIONS-TARGET-FAMILIES](06_ruled_out_and_dead_ends.md#n-special-regions-target-families) | negative | `RULED_OUT` | 06 | Excess for lambda outside {0, lambda_0} in quartic sixfolds, cubic tenfolds, sextic fourfolds: none at general points; all die on the jump divisor J; leads only on deeper strata |

---

## D-SECOND-ORDER-LAW

**Second-order law with one excess direction: the term is ((lambda - lambda_0)/lambda) * A**

kind: `result` | area: `second_order` | status: **`PROVED_AI_UNREVIEWED`**

**Statement.**

```text
Setting: discoveries/NOTATION.md. Assume e_tau = 1 and the range (for instance tau = 0 and (k-1)d < 2k+2). Then
(Theorem 3 and Corollary 4 of the unreviewed note 3), at every smooth X of the setting:
(a) for every lambda != 0 there is exactly one excess direction, and NL(delta_lambda) lies in a smooth germ of
    dimension dim V_Z + 1 in which V_Z = {y = 0};
(b) the space K of forms Q of degree kd - 2k - 2 whose period function has zero differential at X is the same for
    all lambda != 0, and for Q in K the second-order term along the excess direction is
        (1/2) Hess(Phi_Q)(G_lambda) = ((lambda - lambda_0)/lambda) * A(Q),
    with A a linear form on K independent of lambda;
(c) where A != 0, NL(delta_lambda) = {y^2 = 0}: it is V_Z with a double structure, for every lambda not in
    {0, lambda_0}; at lambda_0 the locus is smooth of dimension dim V_Z + 1.
A != 0 for general data of every degree type with tau = 0 in the range that admits a smooth X and has K != 0
(Corollary 8.2 of the note; see D-FORMULA-FOR-A).
```

**Conditions.**

Hypotheses (a)-(d) of Theorem 3: V_1, V_2 smooth and transversal at X, one excess direction along V_Z, and an arc
in NL(delta_lambda_0) leaving V_Z (the pencil F - t N det M of D-LIAISON-IDENTITY). Griffiths' description of the
Hodge locus by period functions and its second-order coefficient. A != 0 is a condition on X.

**Evidence.**

Written proof in note 3; AI referees 13, 14, 22. MOD p at random instances: the law holds exactly modulo the prime
with A != 0 in every type of the note's table "tab:types" for which the second-order computation was run (all
rows except those with k = 4). Night-run blind agent: 123 second-order instances, 62 types, two primes, no
failure. Night check T4 (pole-order reduction at Fermat hypersurfaces, independent of the note's formula):
vanishing at lambda_0 in 67 of 67 runs, law in 61 of 61 runs with excess. Lean: the abstract deduction of the
law from its hypotheses (lean/core/SecondOrderLaw.lean). Package test 12.

**Independent check.**

No C-number. Discovery round, team T3 (04:06Z, 04:37Z): the window cases (3,3,3), (3,4,3) with the full space K at
two primes each agree with the law; that run reused the night-run implementer's library.

**Not established.**

Not human-reviewed. Says nothing where A = 0 (special points such as the Fermat point with planes of the same
pairing, or cubics with det C = 0): there the locus can have further components (see D-CUBIC-SIXFOLD-DETC). The
Lean file certifies a deduction from hypotheses, not the hypotheses.

**Known before.**

For two coplanar lines on surfaces (c = 1) the alternative "reduced only for equal coefficients" is published
(Maclean, thesis Theorem 24 and Proposition 9; Dan arXiv:1407.8491, Theorem 1.3). Kloosterman arXiv:2312.12363,
Theorem 1.3 leaves open, for d = c = 3 and k in {2,3,4}, whether the conjecture holds or the locus is non-reduced.
The law with the factor (lambda - lambda_0)/lambda for c >= 2: not found in the sources we read (machine-read, see
tests/SOURCES.md); not checked further.

**Reproduce.**

Run from the repository root (Macaulay2 1.22).

```
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
Y = randomCyclePair(3, {1,1,1}, {1,1,1}, {1}, Seed => 7);
print((secondOrderObstruction(Y, 2))#"verdict", (secondOrderObstruction(Y, 1))#"verdict");
```

Expected: (ALL DIE, ALL SURVIVE). The factor (lambda - lambda_0)/lambda on 7 degree types with tau = 0:
tests/run_all.sh 12_session (file tests/validation/12_session_second_order.m2; 38 checks, about 60 s).

**Session references (files not public).**

night/paper3/paper3.tex (Theorem 3, Corollary 4, table tab:types); LEDGER.md "BLIND AGENT FINAL", "SECOND ROUND OF
CHECKS"; tests/SOURCES.md E2.

---

## D-SECOND-ORDER-SEVERAL-DIRECTIONS

**Several excess directions in the range: a system of quadrics, the same law, non-reduced locus**

kind: `result` | area: `second_order` | status: **`PROVED_AI_UNREVIEWED`**

**Statement.**

```text
Assume tau >= 0 and the range; E = A_tau, e_tau = dim E, K as in D-SECOND-ORDER-LAW. Then (Theorem 9.1 of the
unreviewed note 3):
(1) for every lambda != 0, NL(delta_lambda) lies in a smooth germ of dimension dim V_Z + e_tau in which
    V_Z = {y_1 = ... = y_e = 0}, and it is cut out there by functions phi_Q, Q in K, lying in the square of the
    ideal of V_Z;
(2) there is a symmetric bilinear map Q_0 : E x E -> K^*, independent of lambda, with
        (1/2) Hess phi_Q (G_lambda(N), G_lambda(N')) = c_0 ((lambda - lambda_0)/lambda) Q_0(N,N')(Q),  c_0 = k(k+1)/2;
(3) Q_0(N,N')(Q(v)) = (kappa/(k+1)) [ rho(N N' tr(Mdot adj M)) - D_v(N N' det M) ] for every virtual deformation v
    of weight -r of the data, r = d - (kd - 2k - 2): the formal derivative along v of the residue symbol
    Res[N N' det M / (f,p;h,s)];
(4) if the quadrics N -> Q_0(N,N)(Q), Q in K, have no common zero in P(E), then for every lambda not in
    {0, lambda_0} the reduced locus is V_Z and the locus is non-reduced at every point of V_Z near X.
Example (Corollary 9.3): on a smooth cubic sixfold with two 3-planes meeting in a line L (c = 2, tau = 1,
lambda_0 = -1, e_tau = 2, K spanned by the two shared equations) the two quadrics have no common zero iff the
binary quadric det M restricted to L has two distinct zeros and is not in the span of the restrictions of s_1, s_2.
At every such X the locus is non-reduced for lambda not in {0, -1} and smooth for lambda = -1.
```

**Conditions.**

As for D-SECOND-ORDER-LAW, plus the period formula with a constant kappa independent of X (D-POINTWISE-FORMULA)
for part (3). Part (4) needs dim K >= e_tau.

**Evidence.**

Note 3, Theorem 9.1 (read by AI referees 17, 18, 22), Corollary 9.3 (exact criterion by referee 17). MOD p: law and
formula at 41 instances of 17 degree types with tau in {1,2}, e_tau in {1,2,3,6} (report FG2). Exact: the two
binary quadrics have nonzero resultant in 6 of 6 random rational instances. Night check T5: the formula against
the Fermat pole-order reduction with no free constant: 61 runs, 25,344 comparisons (8,532 nonzero), all equal.
Lean: polynomial algebra of Corollary 9.3 (lean/core/SixfoldCriterionCert.lean). Package test 12.

**Independent check.**

No C-number. Discovery round, team T3: (3,3,2) with the full K at primes 31991 and 32749 (dim E' = 2, law holds,
no common zero).

**Not established.**

When the quadrics have common zeros (always if dim K < e_tau, and at special points such as the Fermat cubic with
planes of the same pairing) the structure of the locus is not determined. Night check T5 is at Fermat points only
and cannot see a variation of kappa with X.

**Known before.**

For cubics with c = 2 the coefficient (1,-1) is singled out in Movasati arXiv:2211.11405, Conjectures 6, 7 (stated
at the Fermat point; conjectures) and arXiv:1902.00831, Theorem 1 (computer-assisted, finite order, at Fermat).
A statement of this type at every smooth X: not found in the sources we read (machine-read, see tests/SOURCES.md);
not checked further.

**Reproduce.**

Run from the repository root (Macaulay2 1.22).

```
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
Z = randomCyclePair(3, {1,1}, {1,1}, {1,1}, Seed => 7);
a = secondOrderObstruction(Z, 2, Strategy => "Both");
print(a#"excess", a#"verdict", a#"strategiesAgree", (secondOrderObstruction(Z, -1))#"verdict");
```

Expected: (2, ALL DIE, true, ALL SURVIVE). More rows: tests/validation/12_session_second_order.m2.

**Session references (files not public).** night/paper3/paper3.tex (Theorem 9.1, Corollary 9.3); LEDGER.md "REFEREE 17", "FG2"; night/CHECKS_R2.md T4, T5.

---

## D-SECOND-ORDER-OUTSIDE-RANGE

**Outside the range: the law survives on E' = ker(det M : A_tau -> A_d); formula for every r**

kind: `result` | area: `second_order` | status: **`PROVED_AI_UNREVIEWED`**

**Statement.**

```text
Assume tau >= 0, no range hypothesis, lambda not in {0, lambda_0}. Put E' = (0 :_A det M)_tau (the excess
directions, by D-FIRST-ORDER-RULE(5)) and call (S) the condition that det M : A_tau -> A_d is surjective. Then
(Theorem 9.4 and Proposition 9.4' of the unreviewed note 3):
(0) dim K_lambda - dim K = dim coker(det M : A_tau -> A_d); so K_lambda = K iff (S) holds;
(1) the law of D-SECOND-ORDER-SEVERAL-DIRECTIONS(2) holds on E' x E' against the forms of K;
(2) the formula of D-SECOND-ORDER-SEVERAL-DIRECTIONS(3) holds for N, N' with classes in E', for every sign of
    r = d - (kd - 2k - 2) ("the formula for every r", Proposition 9.4');
(3) if Q_0 != 0 at X, the locus is not smooth at X; if this happens at one smooth X of a degree type where dim E'
    is minimal, the locus is singular at every smooth X of that type;
(4) under (S): if the quadrics on P(E') have no common zero, the reduced locus is V_Z and the locus is
    non-reduced along V_Z.
Corollary 9.5: for smooth cubics containing two 4-planes meeting in a plane (lambda_0 = -1), two 3-planes meeting
in a plane (lambda_0 = 1), or two 4-planes meeting in a 3-plane (lambda_0 = 1), the locus is non-reduced at X for
every lambda not in {0, lambda_0} and smooth at lambda_0; for general such X its reduction is V_Z.
```

**Data.**

For r < 0: E' = 0 at random data in all 19 degree types tried (k = 2..5, c = 1, 2; primes 32003, 30011), so the
formula has content only at special X there. Example of such a point: the Fermat septic fourfold with two planes
meeting in a line, pairings (01)(23)(45) and (01)(24)(35), type (d,k,c) = (7,2,1), r = -1, tau = 2, dim E' = 2.

**Conditions.** As for D-SECOND-ORDER-SEVERAL-DIRECTIONS without the range; the constancy of kappa in X (D-POINTWISE-FORMULA(4)).

**Evidence.**

Note 3: Theorem 9.4 (AI referee 19), Proposition 9.4' (first proof had a gap found by referee 24, see
C-NIGHT-PROP-94PRIME-GAP; repaired proof read by referee 25). Exact over Q on restricted data: quadrics span all
binary quadrics on E' in 6, 5 and 3 random instances of the three cases of Corollary 9.5 (reproduced by referees
19, 20 with own code). MOD p: 63 of 63 and 61 of 61 runs (report FG3); night check T11a: Fermat (7,2,1), r = -1,
p = 30059: law holds, formula matches the pole-order reduction (1440 comparisons, 288 nonzero); T11b: the two
residue identities in 260 instances (22 types with r < 0), two primes; six heavier types later, 12 instances.
Lean: lean/mathlib/EveryR.lean (one algebraic step, from hypotheses).

**Independent check.**

No C-number. Discovery round, team T3: (3,4,2) with all 38 forms of K at primes 31991 and 32749 (dim E' = 2, (S)
holds, law, no common zero).

**Not established.**

The second-order terms against K_lambda minus K when (S) fails, and the structure when the quadrics on P(E') have
common zeros, are not determined. The additions of version 21 of the note were not re-read by a referee.

**Known before.**

Kloosterman arXiv:2401.10775 (linear subspaces meeting in codimension one; machine-read in the night run, not in
tests/SOURCES.md) leaves a related question open in its Remark 4.9, as read by a scout agent. The statements
above: not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further.

**Reproduce.**

Run from the repository root (Macaulay2 1.22). Quartic fourfold, two planes meeting in a line (outside the range;
e_tau = 3, dim E' = 2):

```
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
Y = randomCyclePair(4, {1}, {1}, {1,1}, Seed => 5);
print((tangentExcess(Y, 1))#"excess", (tangentExcess(Y, 2))#"excess", (secondOrderObstruction(Y, 2))#"verdict");
```

Expected: (3, 2, ALL DIE). The package test "PA-S7" in M2/HodgeLociCI/SecondOrderTests.m2 compares the formula for
every r with the pointwise formula at the Fermat septic fourfold (exact over Q); it runs with check "HodgeLociCI".

**Session references (files not public).**

night/paper3/paper3.tex (Theorem 9.4, Proposition 9.4', Corollary 9.5); LEDGER.md "REFEREE 19", "five-hour block,
part 1", "part 2"; night/CHECKS_R2.md T9-T11.

---

## D-FORMULA-FOR-A

**Formula for the second-order coefficient A as a derivative of a residue symbol; A != 0 for general data**

kind: `result` | area: `second_order` | status: **`PROVED_AI_UNREVIEWED`**

**Statement.**

```text
Assume tau = 0 and the range, r = 2k + 2 - (k-1)d > 0. Every Q in K is Q(v) = f^T Mdot h + sum fdot_i (Mh)_i
+ sum hdot_j (M^T f)_j + sum pdot_l s_l + sum sdot_l p_l for a "virtual deformation of weight -r"
v = (fdot, hdot, pdot, sdot, Mdot): forms of the degrees of f, h, p, s, M lowered by r. Then (Theorem 8.1 of the
unreviewed note 3), with the excess direction normalised to G_lambda_0 = det M:
    A(Q(v)) = constant * D_v,   D_v = rho(tr(Mdot adj M)) - sum over the forms phi in (f, h, p, s) of
              Res_S[ det M * phidot / (f,p;h,s with phi replaced by phi^2) ],
the formal derivative along v of the residue symbol Res_S[det M/(f,p;h,s)]; the constant is nonzero and does not
depend on X. Corollary 8.2: A != 0 for general data of every degree type with tau = 0 in the range for which a
smooth X exists and K != 0. So the double structure of D-SECOND-ORDER-LAW(c) is the general behaviour.
For cubic sixfolds with two 3-planes meeting in a point it specialises, up to normalisation, to the factor det C
of D-CUBIC-SIXFOLD-DETC.
```

**Conditions.**

The period formula for complete intersections with a constant independent of X (D-POINTWISE-FORMULA(4)); the key
lemma of the second-order principle.

**Evidence.**

Note 3, Theorem 8.1 (AI referee 15; re-derived by referees 16, 22), Corollary 8.2. The formula agrees modulo
primes with the computed second-order term at 25 random instances of twelve degree types (report FG: exact
agreement in 11 types before the proof was written).

**Independent check.** none with a C-number

**Not established.**

Not human-reviewed. A does vanish at special points (split hypersurfaces, Fermat with planes of the same pairing).
Nothing is claimed for tau > 0 with e_tau >= 2 beyond D-SECOND-ORDER-SEVERAL-DIRECTIONS.

**Known before.** not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further

**Reproduce.**

Run from the repository root (Macaulay2 1.22). The package evaluates this formula (Strategy "Formula") and an
independent-in-code pointwise route (Strategy "Pointwise"); both rest on the same lemma of the note:

```
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
Y = randomCyclePair(4, {1,1}, {1,1}, {1}, Seed => 11);
s = secondOrderObstruction(Y, 2, Strategy => "Both"); print(s#"excess", s#"verdict", s#"strategiesAgree");
```

Expected: (1, ALL DIE, true). Seven types with tau = 0: tests/validation/12_session_second_order.m2.

**Session references (files not public).**

night/paper3/paper3.tex (Theorem 8.1, Corollary 8.2); LEDGER.md "15:06Z THEOREM FA", "15:38Z REFEREE 15";
night/formula_g/REPORT_FG.md.

---

## D-POINTWISE-FORMULA

**Pointwise second-order period formula: a sum of residue symbols with one pair squared**

kind: `result` | area: `second_order` | status: **`PROVED_AI_UNREVIEWED`**

**Statement.**

```text
Let Y = V(phi_0, ..., phi_k) be a complete intersection of dimension k in X = {F = 0}, F = sum_nu phi_nu psi_nu,
and t = (k+1)(d-2). The first-order period functional pi_Y of [Y] acts on forms of degree t and
pi_Y(P) = kappa(X,Y) Res_S[P/(phi_0, psi_0, ..., phi_k, psi_k)] (period formula). The second-order functional phi_Y
(pole order one higher) acts on forms of degree t + d. Then (Lemma 2.1(3) of the unreviewed note 3)
    (k+1) phi_Y(P) = kappa(X,Y) * sum_(nu = 0..k) Res_S[ P / (phi_0, psi_0, ..., phi_nu^2, psi_nu^2, ..., phi_k, psi_k) ],
the nu-th symbol having both members of the nu-th pair squared. Lemma 2.1(4): kappa does not depend on X within
one degree type. Consequence: the second-order statements of note 3 no longer use the cup-product formula of
Carlson and Griffiths.
```

**Data.**

Example of the degrees: quartic sixfold (k = 3, d = 4): t = 8 and t + d = 12 (the functionals Phi8 and Phi12 of the
fake-linear-cycle entries). Residue symbols are normalised by Res_S[det Jac(g)/(g)] = product of the degrees of g.

**Conditions.**

Griffiths' pole-order description of periods (second-order coefficient), the residue formula for the class of a
complete intersection, the transformation law for residue symbols. All cited, none opened by an agent.

**Evidence.**

Found by the night-run blind agent; proof written by the coordinating thread; read by AI referees 23 (who gave a
second, shorter proof), 24, 25. Lean: the algebra of the formula from stated hypotheses
(lean/mathlib/PointwiseFormula.lean, lean/mathlib/SecondProof.lean). Discovery round, check C19: the formula was
tested, not taken on trust, by three routes independent of it: Griffiths-Dwork on the Jacobian ideal (8 tests),
dual numbers on first-order residues (8 tests; covers all of degree 12 for a quartic sixfold), derivative of the
first-order form along Sigma_4 (21 pairs, two weights, two primes). All agree, MOD p.

**Independent check.**

C19 (routes R1-R3, MOD p, primes 30089 and 32003, quartic sixfolds with four linear P^3). Not covered: the lemma
itself was not re-proved; other degree types; characteristic 0.

**Not established.**

The value and sign of kappa; that kappa is the same for different degree types. The night-run record says: "no
numerical test compares the pointwise formula off the Jacobian ideal with an independently computed period"
(the 780-form Fermat check was vacuous, see C-NIGHT-VACUOUS-CHECKS). Check C19 (route R2) later did such a test
for one degree type, MOD p. Both statements are recorded; they refer to different dates.

**Known before.**

not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further. Second-order
invariants of Noether-Lefschetz loci go back to Maclean (thesis, Theorem 23).

**Reproduce.**

Run from the repository root (Macaulay2 1.22). The package function secondOrderFunctional implements the
right-hand side; Strategy "Both" compares it with the formula of D-FORMULA-FOR-A (same lemma behind both, so this
checks the algebra only):

```
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
Z = randomCyclePair(3, {1,1}, {1,1}, {1,1}, Seed => 7);
print((secondOrderObstruction(Z, 2, Strategy => "Both"))#"strategiesAgree");
```

Expected: true.

**Session references (files not public).**

night/paper3/paper3.tex (Lemma 2.1(3),(4), Remark 10.3); LEDGER.md "SECOND ROUND, continued", "five-hour block";
LEDGER_DISCOVERY.md "[CHECK C19]".

---

## D-LINEAR-LIST-SECOND-ORDER

**Two linear subspaces, lambda != lambda_0: non-reduced structure on V_Z exactly for the list L**

kind: `result` | area: `second_order` | status: **`PROVED_AI_UNREVIEWED`**

**Statement.**

In the setting of D-LINEAR-LIST-FIRST-ORDER, for lambda not in {0, lambda_0} and X general among the smooth
hypersurfaces containing the two planes (Theorem 9.7(3) of the unreviewed note 3): if (d,k,c) is not in the list L,
NL([Pi_1] + lambda [Pi_2]) = V_Z as schemes (smooth). If (d,k,c) is in L, the locus is V_Z with a non-reduced
structure: its reduction is V_Z and its Zariski tangent space has dimension dim V_Z + e. For (d,k,c) in L the
locus is non-reduced at every smooth X containing two such planes. So the excess directions "die at second
order" for lambda != lambda_0, and survive at lambda_0.

**Data.**

Source of the second-order statement for each row: (3,3,3), (3,4,3), (4,2,2): one excess direction, A != 0 for
general data (D-FORMULA-FOR-A; for cubics also D-CUBIC-SIXFOLD-DETC, D-CUBIC-EIGHTFOLD-INVARIANT). (3,3,2): the
criterion of Corollary 9.3. (3,3,1), (3,4,1), (3,4,2): Corollary 9.5 (outside the range). (4,2,1), (5,2,1): a
remark of the note with exact computations on restricted data. (d,1,1): Corollary 9.2 (surfaces).
At Fermat points the quadrics do have a common zero in the configurations tried for (3,3,1), (4,2,1), (3,4,1)
and in one of the two tried for (3,3,2): these are special points, not covered by the statement.

**Conditions.**

D-SECOND-ORDER-LAW, D-SECOND-ORDER-SEVERAL-DIRECTIONS, D-SECOND-ORDER-OUTSIDE-RANGE; for some rows exact
computations at instances carry the non-vanishing.

**Evidence.**

Note 3, Theorem 9.7 (AI referee 21: second-order half reproduced with independent exact code for the five rows
outside the range and for (3,3,2); five by-hand instances, their polynomial algebra kernel-checked in
lean/core/LinearListCert.lean). Night-run blind agent: all ten rows at second order, MOD p. Night check T6: for
all rows, two seeds, dim E' = e and the quadrics have no common zero. Night check T4: cubic eightfold cases
(3,4,1), (3,4,2), (3,4,3) at Fermat points. Discovery round, team T3: the four "window" cases (3,3,2), (3,3,3),
(3,4,3), (3,4,2) at random points with the full K, two primes each: nothing differs. Package test 12 (rows with
k <= 3 and (5,2,1), (5,1,1), (6,1,1)).

**Independent check.** No C-number. Night-run blind agent and team T3 (which reused that agent's library).

**Not established.**

General X only for 'reduction = V_Z'. The package validation suite does not run the second order for cubic
eightfolds (rows (3,4,c)); see O-COMMON-ZEROS-AND-SECOND-ORDER-GAPS.

**Known before.**

Coplanar lines: Maclean, Dan (published). For d = c = 3, k = 3, 4 Kloosterman arXiv:2312.12363, Theorem 1.3 states
the alternative "conjecture holds or non-reduced" without deciding it. The non-reduced structure for the other
rows of L: not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further.

**Reproduce.**

Run from the repository root (Macaulay2 1.22). tests/run_all.sh 12_session (file
tests/validation/12_session_second_order.m2): verdicts "ALL DIE" at lambda = 2, -2, 5/3, -lambda_0 and "ALL
SURVIVE" at lambda_0 for (3,3,1), (3,3,2), (3,3,3), (4,2,1), (4,2,2), (5,2,1), (5,1,1), (6,1,1).

**Session references (files not public).**

night/paper3/paper3.tex (Theorem 9.7(3), Table 1, Corollaries 9.3, 9.5); LEDGER.md "REFEREE 21", "Lean file
LinearListCert"; LEDGER_DISCOVERY.md "[T3] 04:06Z", "[T3] 04:29Z", "[T3] 04:37Z".

---

## D-SECOND-ORDER-EXCEPTIONS

**Exceptions to 'all excess directions die': rows with K = 0 and one row where only some die**

kind: `result` | area: `second_order` | status: **`MOD_P`**

**Statement.**

```text
At random instances modulo 32003 the package's second-order checker gives, for lambda in {2, -2, 5/3, -lambda_0}:
(a) K = 0 (no dependent equation, nothing is obstructed, verdict ALL SURVIVE for every lambda): the degree types
    (d; deg f; deg h; deg p) = (5; 1; 1; 2), (5; 1; 1; 3), (3; 1,1; 1,1; 1), (3; 1; 1; 1,1). In the range K = 0
    means that the locus is smooth of dimension dim V_Z + e_tau for every lambda;
(b) verdict SOME DIE (the quadrics are not all zero but have a common zero on the excess space): the type
    (6; 1; 1; 3), with e_tau = 3;
(c) verdict ALL DIE: (6; 1; 1; 2), (4; 1,1,1; 1,2,3; -), (4; 1,1,2; 1,2,2; -), (4; 1,1; 1,2; 1).
In all rows with K != 0 the quadratic map vanishes at lambda_0 only among the tested coefficients.
Also K = 0 for skew lines on quartic surfaces and disjoint planes on cubic fourfolds ((k,d) = (1,4), (2,3)):
there the Hodge locus is a smooth hypersurface for every lambda.
```

**Conditions.** One random instance per type, modulo 32003, fixed seeds.

**Evidence.**

Package test 12, part (c) (INFO lines of the expected output). Note 3, table tab:tau: the quadratic map vanishes
at lambda_0 only among lambda in {1,-1,2,3,1/2,-2,5/3} (K = 0 in four rows).

**Independent check.** none

**Not established.**

SOME DIE at one instance does not decide the reduced locus for that type: when the quadrics have common zeros the
structure is not determined (O-COMMON-ZEROS-AND-SECOND-ORDER-GAPS).

**Known before.** n/a (a record of what the checker returns)

**Reproduce.**

Run from the repository root (Macaulay2 1.22).

```
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
W = randomCyclePair(3, {1,1}, {1,1}, {1}, Seed => 5);
s = secondOrderObstruction(W, 2); print(s#"dimK", s#"verdict");
```

Expected: (0, ALL SURVIVE). All rows: tests/validation/12_session_second_order.m2, part (c).

**Session references (files not public).** night/paper3/paper3.tex (table tab:tau); tests/SOURCES.md E4; tests/expected/12_session_second_order.out.

---

## D-COPLANAR-LINES-FERMAT

**Two coplanar lines on Fermat surfaces: the second-order term vanishes on the quintic, not on the sextic**

kind: `result` | area: `second_order` | status: **`EXACT`**

**Statement.**

Exact computation over cyclotomic fields with the package's second-order checker (both strategies agree), for
[L_1] + 2 [L_2]:
Fermat quintic x_0^5 + ... + x_3^5, plane x_0 + x_1 = 0, lines x_2 + x_3 = 0 and x_2 = u x_3 (u a primitive 10th
root of unity): excess 1, verdict ALL SURVIVE (the second-order term is zero).
Fermat sextic, plane x_0 = w x_1, lines x_2 = w x_3 and x_2 = w^3 x_3 (w a primitive 12th root of unity): excess 1,
verdict ALL DIE at lambda = 2 and ALL SURVIVE at lambda_0 = 1.
This agrees with Corollary 9.2 of the unreviewed note 3: for two coplanar lines on a quintic, A vanishes exactly
when M_00(o) = 0 (o the point where the three linear forms vanish); the d lines of a Fermat surface in a plane
x_0 = zeta x_1 are concurrent, so M_00(o) = 0 there; for d >= 6 the note states A != 0 at every smooth X.

**Conditions.**

The second-order formulas of note 3 (the checker evaluates them; it has no route independent of Lemma 2.1 of the
note).

**Evidence.**

Package test PA-S6 (exact over Q(zeta_10), Q(zeta_12)); night check T4 (pole-order reduction at Fermat, MOD p,
independent of the note's formula): Q_0 = 0 on the Fermat quintic, != 0 on the Fermat sextic; AI referee 18 (MOD
p).

**Independent check.** No C-number. Night check T4 is the independent route (MOD p).

**Not established.**

At the Fermat quintic the vanishing second-order term does not decide the locus (higher order not computed in the
sources).

**Known before.**

Maclean (thesis, Theorem 24, Proposition 9): for quintics, non-reduced components come from two coplanar lines
with unequal coefficients; Dan arXiv:1407.8491, Theorem 1.3 (d >= 5). The behaviour at the Fermat quintic
specifically: not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further.

**Reproduce.**

Run from the repository root (Macaulay2 1.22).

```
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
K5 = toField(QQ[u]/(u^4 - u^3 + u^2 - u + 1)); S5 = K5[x_0..x_3];
p0 = x_0 + x_1; s0 = (x_0^5 + x_1^5) // p0; f0 = x_2 + x_3; h0 = x_2 - u*x_3; M00 = (x_2^5 + x_3^5) // (f0*h0);
D5 = cyclePair({f0}, {h0}, {p0}, matrix{{M00}}, {s0});
r5 = secondOrderObstruction(D5, 2, Strategy => "Both"); print(r5#"verdict", r5#"excess", r5#"strategiesAgree");
K6 = toField(QQ[w]/(w^4 - w^2 + 1)); S6 = K6[x_0..x_3];
p0 = x_0 - w*x_1; s0 = (x_0^6 + x_1^6) // p0; f0 = x_2 - w*x_3; h0 = x_2 - w^3*x_3; M00 = (x_2^6 + x_3^6) // (f0*h0);
D6 = cyclePair({f0}, {h0}, {p0}, matrix{{M00}}, {s0});
r6 = secondOrderObstruction(D6, 2, Strategy => "Both"); print(r6#"verdict", r6#"excess", r6#"strategiesAgree");
```

Expected: (ALL SURVIVE, 1, true) and (ALL DIE, 1, true). The same code is the test "PA-S6" in
M2/HodgeLociCI/SecondOrderTests.m2.

**Session references (files not public).** night/paper3/paper3.tex (Corollary 9.2, Remark (iv) of section 9); night/CHECKS_R2.md T4.

---

## D-CUBIC-SIXFOLD-DETC

**Cubic sixfolds, two 3-planes meeting in a point: Hessian = nu * det C * ((lambda-1)/lambda) * A^2**

kind: `result` | area: `second_order` | status: **`PROVED_AI_UNREVIEWED`**

**Statement.**

```text
Let X be a smooth cubic sixfold containing 3-planes P_1, P_2 with P_1 n P_2 = {q}, and lambda != 0 rational. Let C
be the 3 x 3 matrix of the quadratic part of X n T_q X at q (rows and columns: the directions of P_1 and of P_2
in T_q X; T_q X is the hyperplane spanned by the two planes). Then (Theorem A of the unreviewed note 1):
(1) V_Z is smooth of codimension 8 and the Zariski tangent space of NL(lambda) has codimension 7;
(2) NL(lambda) is a hypersurface {f = 0} in a smooth germ M_lambda of codimension 7 with df(X) = 0 and
    Hess_f(G) = nu * det C * ((lambda - 1)/lambda) * A(G)^2, nu != 0, A a linear form with kernel T V_Z;
(3) for lambda != 1: if det C != 0, NL(lambda) = {y^2 = 0} is V_Z with a double structure; if det C = 0,
    NL(lambda) = {y^2 u' = 0} is V_Z doubled together with a second component W_lambda = {u' = 0} of codimension 8,
    not containing V_Z and meeting it along D = {det C = 0};
(4) for lambda = 1, f = 0 identically: NL(1) is smooth and reduced of codimension 7.
So every component of NL(lambda) through X has the dimension of V_Z when lambda != 1.
```

**Data.**

```text
Exact values. Fermat cubic sixfold with the rational pair of 3-planes from the pairings (01)(23)(45)(67) and
(07)(12)(34)(56): second-order obstruction -(8/3) lambda (lambda - 1) (two independent implementations; in the
Lean file's normalisation ob3(lambda) = -8 lambda (lambda - 1)); C = [[-6,0,0],[6,-6,0],[0,6,-6]], det C = -216.
Three explicit non-Fermat cubics (Lean, ClosedFormulaCert): det C = -1, 2, 0, with obstruction
-det C * lambda (lambda - 1) and identically zero in the third.
At Movasati's pair on the Fermat cubic (same pairing of the coordinates) C = 0: the point q has only two nonzero
coordinates and X n T_q X is a cone over the Fermat cubic fourfold.
At all 10 incidence types of pairs of 3-planes meeting in a point on the Fermat sixfold: first obstruction in
generic directions at order exactly 2 + corank C (MOD p, two primes).
```

**Conditions.**

Griffiths' period calculus; residues on the planes; lambda_0 = 1 from the intersection numbers P^2 = -5, P_1.P_2 =
1 or from Kloosterman's Corollary 6.5 (machine-read).

**Evidence.**

Note 1 (AI-written): proof by residues on the planes, derived independently by two agents; AI referee
reports of the night run on the note and its parts, no fatal finding. Exact checks at the Fermat rational pair (two
implementations) and at an explicit non-Fermat cubic over Q. Independent re-implementation at a non-Fermat cubic
modulo 2147483587: obstruction at lambda = 1, -1, 2, 3, 1/2, 5 equal to lambda (lambda - 1) in its normalisation.
Lean (kernel-checked integer and polynomial computations; the geometric bridge is not formalised):
lean/core/ObstructionCert.lean, lean/core/ClosedFormulaCert.lean, lean/core/TangentCert.lean.

**Independent check.**

No C-number. Discovery round: check C3 confirmed exactly the consequence 'no component of dimension dim V + 1' at
the Movasati point for lambda = -1, 2, 5/3 by a route that does not use this theorem (D-MOVASATI-CERTIFICATES).

**Not established.**

Not human-reviewed; not a refutation of a published conjecture (see D-CONJ1-DIMENSION-NOTE1 for the wording).
W_lambda "may be reducible or non-reduced" in the note; the discovery round gives its structure at some points
(D-SIXFOLD-GERM-AT-MOVASATI-POINT, D-W-MINUS1-IS-TWO-DET-CLOSURE). The description in terms of det C: novelty not
determined in the note.

**Known before.**

Parts (1) and (4) are published or follow from published results: tangent spaces at Fermat (Villaflor Loyola,
Proposition 21 of Movasati arXiv:2211.11405) and at every X (Kloosterman arXiv:2312.12363, Theorem 1.3);
lambda = 1 (Kloosterman, Corollary 6.5). Parts (2), (3): not found in the sources we read (machine-read, see
tests/SOURCES.md); not checked further. The second-order form vanishes at the Fermat point for Movasati's pairs
according to Duque Franco-Villaflor Loyola arXiv:2312.17222, Proposition 5.1 (machine-read in the night run; not
in tests/SOURCES.md), which agrees with C = 0 there.

**Reproduce.**

Run from the repository root (Macaulay2 1.22). At a random two-plane cubic sixfold (det C != 0 with high
probability):

```
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
Y = randomCyclePair(3, {1,1,1}, {1,1,1}, {1}, Seed => 7);
print((verifyExcess Y)#"agrees", (secondOrderObstruction(Y, 2))#"verdict", (secondOrderObstruction(Y, 1))#"verdict");
```

Expected: (true, ALL DIE, ALL SURVIVE). Kernel-checked finite computations: lean/run_all.sh core (files
lean/core/ObstructionCert.lean, lean/core/ClosedFormulaCert.lean; see lean/README.md for what they do not prove).

**Session references (files not public).**

deliverables/hodge_loci_session/papers/paper1.tex (Theorem A); LEDGER.md "MAIN FINDING of the night", "AUDIT
RESULT AND CLOSED FORMULA", "REFEREE RESULT"; night/PROOF_A.md.

---

## D-CUBIC-EIGHTFOLD-INVARIANT

**Cubic eightfolds (4-planes meeting in a line) and sixfolds (3-planes meeting in a line): the invariant D**

kind: `result` | area: `second_order` | status: **`PROVED_AI_UNREVIEWED`**

**Statement.**

(Theorem C of the unreviewed note 1.) Let X be a smooth cubic 2k-fold with two k-planes meeting in a P^m,
(k,m) = (4,1) or (3,1), lambda_0 = (-1)^(k-1-m). Every dependent equation Phi_L of the Hodge locus of
[P_1] + lambda [P_2] has Hessian k * kappa * ((lambda - lambda_0)/lambda) * D_L(u), u the coordinate on the excess
space, D_L independent of lambda.
Eightfolds (lambda_0 = 1): the form is of rank one, 4 kappa ((lambda - 1)/lambda) u^2 D(L). D = 0 iff det C(y)
vanishes identically on the line AND all 2 x 2 minors of C(y) lie in the span of the two quadrics s restricted to
the line; here C(y) is a 3 x 3 matrix of linear forms on the line. Where D != 0, NL(lambda) is V_Z with a double
structure for lambda != 1, and dim NL(lambda) = dim V_Z at every point of V_Z.
Sixfolds with a common line (lambda_0 = -1): in the normal form s = (y_0^2, y_1^2), det C = A y_0^2 + B y_0 y_1
+ D y_1^2, the two forms have no common zero iff det C is not in the span of s and its discriminant is nonzero;
then the reduced locus is V_Z for lambda != -1.

**Data.**

```text
Lean (ObstructionCert8): Fermat cubic eightfold, 4-planes from the pairings (01)(23)(45)(67)(89) and
(05)(12)(34)(69)(78), meeting in a line: the obstruction functional evaluates to 4 lambda (lambda - 1) for every
rational lambda. At this pair codim T NL(P_i) = 10, codim V_Z = 20, excess 1, cokernel of dimension 26.
The invariant D on the 18-dimensional space of pencils C(y) = A y_1 + B y_2 (after normalising s to y_1^2, y_2^2):
D = 0 iff the nine y_1 y_2-coefficients of the 2 x 2 minors of C(y) vanish and det C(y) = 0. This is a cone of
dimension 11 and degree 54 (exact over Q, Singular); its only component of codimension 7 consists of the pencils
with a common kernel vector and a common cokernel vector whose 2 x 2 part has determinant without y_1 y_2-term
(MOD p, check C17). At Movasati's eightfold pair C = 0.
```

**Conditions.**

As for D-CUBIC-SIXFOLD-DETC; equality of the two period constants (kappa_1 = kappa_2) from the Carlson-Griffiths
multiplicativity in note 1, later from D-POINTWISE-FORMULA.

**Evidence.**

Note 1, Theorem C (second AI referee: no fatal finding; own code with full period functionals). Exact checks: four
explicit eightfolds, three sixfolds with a common line, five rational Fermat pairs. Lean:
lean/core/ObstructionCert8.lean (235 theorems).

**Independent check.**

No C-number for the theorem. The algebra model (dimension 11, degree 54) was confirmed exactly by the coordinator
(checks/c3_coord) and its unique codimension-7 component MOD p in check C17 (N5).

**Not established.**

Not human-reviewed. At points with D = 0 (for instance Movasati's eightfold pair) the theorem gives only dim
NL(lambda) = dim V_Z by a dimension argument; the second component there is the subject of the discovery-round
entries.

**Known before.**

Kloosterman arXiv:2312.12363, Theorem 1.3 (alternative left open for k = 4); Corollary 6.5 for lambda = 1. The
invariant D and the double structure: not found in the sources we read (machine-read, see tests/SOURCES.md); not
checked further.

**Reproduce.**

Run from the repository root (Macaulay2 1.22). First order at the Fermat pair of the Lean certificate (exact), and
the kernel-checked computation:

```
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
S = fermatRing(3, 8);
L1 = {{0,1,3},{2,3,3},{4,5,3},{6,7,3},{8,9,3}}; L2 = {{0,5,3},{1,2,3},{3,4,3},{6,9,3},{7,8,3}};
u = fermatTangentData(S, {L1, L2}, {1, 2}); print(u#"hodgeCodimension", u#"jointPersistenceCodimension", u#"excess");
```

Expected: (19, 20, 1). Then lean/run_all.sh core (file lean/core/ObstructionCert8.lean).

**Session references (files not public).**

deliverables/hodge_loci_session/papers/paper1.tex (Theorem C, Remark "rem:C"); LEDGER.md "GENERAL CUBIC FORMULA
(agent D, second task)", "Entries after 07:27Z"; LEDGER_DISCOVERY.md "[T3] 04:25Z", "[CHECK C17]" (N5).

---

## D-SURFACES-DISJOINT-CURVES

**Disjoint complete-intersection curves on surfaces (tau = 0, c = 2): law (r+1)/r, special coefficient -1**

kind: `result` | area: `second_order` | status: **`PROVED_AI_UNREVIEWED`**

**Statement.**

(Unreviewed note 2.) Let Z_1, Z_2 in P^3 be disjoint complete-intersection curves of types (a_1,a_2), (e_1,e_2) on
a smooth surface X = {f^T M h = 0} of degree d = a_1 + a_2 + e_1 + e_2 (k = 1, c = 2, tau = 0, lambda_0 = -1).
For every rational r != 0 the Noether-Lefschetz locus NL(r) of [Z_1] + r [Z_2] has exactly one excess tangent
direction over V_Z; its second-order term is ((r+1)/r) * A with A independent of r; NL(-1) is smooth, a branch of
the closure of the family of surfaces containing a complete intersection of type (a_1 + e_1, a_2 + e_1). Where
A != 0, NL(r) is V_Z with a double structure for every r not in {0, -1}.
Octic case, a line L and a disjoint (3,3) curve C: A is a 2 x 2 matrix D of residues, linear in M. At every
smooth octic containing such a pair and every r not in {0, -1}, the only component of the locus of [L] + r [C]
through that point of codimension smaller than 35 is V_Z (codimension 32); other components, present exactly
where D = 0 (for example at the Fermat octic), have codimension 35. For r = -1 the locus is smooth of
codimension 31.

**Data.**

Octic numbers at a random instance (MOD p): codim T NL(L) = 5, codim T NL(C) = 27, codim T V_Z = 32,
codim T NL(L + r C) = 31 for every r tested, cokernel 4. Second-order obstruction nonzero for r = 1, 2, 3, 1/2,
-2, 5/3 and zero for r = -1. At the Fermat octic with a line and a disjoint 3 x 3 grid of lines the second-order
form is zero for every r. The direction at r = -1 is det M: F + t det M is a 3 x 3 determinantal octic.
Intersection numbers on an octic: L^2 = -6, C^2 = -18, L.C = 0.

**Conditions.**

The second-order principle; a hypothesis on one of the curves for the residue formula for A (proved in the note
for lines, smooth conics, smooth plane curves in a range of degrees, smooth (2,2) curves).

**Evidence.**

Note 2 (AI referees 6, 6b, 7, 7b, 8, 9: no fatal error, corrections applied). A != 0: exact over Q in four degree
types ((1,2)+(1,2), (1,1)+(1,3), (1,1)+(2,3), (1,2)+(2,2)) and for (1,1)+(3,3) according to the ledger; the
abstract of the note says 'exact computations in six types (conditional on an identification without written
proof)'. Both counts are recorded. MOD p in the remaining types of the note's table. Lean:
lean/core/SexticCert.lean (one explicit sextic with two disjoint conics: Ob(r) = A_0 (1 + 1/r)),
lean/core/OcticDetCert.lean (ring identities). Package test 12: types (6; 1,2; 1,2), (7; 1,2; 2,2), (8; 1,1; 3,3).

**Independent check.** none with a C-number

**Not established.**

Not human-reviewed. All statements are local at points of V_Z: nothing is claimed about components of the
Noether-Lefschetz locus that do not meet V_Z, nor about Harris's conjecture. This must not be presented as a
refutation of a published statement: the statements of Movasati on octic surfaces are conjectural in his papers
as read by machine, and his rigorous propositions (smoothness of finite-order truncations on slices) are not
contradicted.

**Known before.**

The setting with the strict inequality tau < 0: Kloosterman arXiv:2312.12363, Theorem 1.5; this is the boundary
case. The octic proposal: Movasati arXiv:1908.04117 and arXiv:2606.26944 (machine-read in the night run; not in
tests/SOURCES.md). A statement deciding it: not found in the sources we read (machine-read, see tests/SOURCES.md);
not checked further (finite search).

**Reproduce.**

Run from the repository root (Macaulay2 1.22). tests/run_all.sh 12_session (file
tests/validation/12_session_second_order.m2), part (b): for the types (6, {1,2}, {1,2}), (7, {1,2}, {2,2}), (8,
{1,1}, {3,3}) the excess is 1, the verdict is ALL DIE at lambda = 2, -2, 5/3, 1 and ALL SURVIVE at lambda_0 = -1,
and the values obey the factor (lambda + 1)/lambda.

**Session references (files not public).**

deliverables/hodge_loci_session/papers/paper2.tex; LEDGER.md "OCTIC SURFACES", "REFEREE 6", "REFEREE 7", "REFEREE
6b", "REFEREE 8", "REFEREE 9".
