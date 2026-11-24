# First order: the rule for tau, lambda_0 and the excess

- From the degrees alone: the level tau, the special coefficient lambda_0 = (-1)^(c-1), the number e_tau, the codimensions, and the complete list of pairs of linear subspaces with excess directions.
- Published first-order numbers (Movasati, Kloosterman, Villaflor Loyola, Maclean) are reproduced; the general rule is a theorem of an AI-written, unreviewed note.
- First-order statements say nothing about the dimension of a Hodge locus away from lambda_0: see page 02.

> **Status of everything on this page:** produced by AI agents, checked only by other AI agents, reviewed by no human. Sources of published results were read by machine (see `tests/SOURCES.md`). The notes cited as "unreviewed note 1, 2, 3" are AI-written and not public. Nothing here is, or bears on, a proof or disproof of the Hodge conjecture. This is a registry of what was found, ruled out or left open, not a list of established theorems.

Generated from `discoveries/registry.yaml` by `discoveries/check_registry.py --write-pages`. Do not edit this page by hand: edit the registry. Notation: [`NOTATION.md`](NOTATION.md). Status vocabulary: [`README.md`](README.md).

## Entries on this page (10)

| id | status | title |
|---|---|---|
| [D-FIRST-ORDER-RULE](#d-first-order-rule) | `PROVED_AI_UNREVIEWED` | First-order rule: level tau, special coefficient lambda_0 = (-1)^(c-1), excess e_tau |
| [D-LEVEL-DICHOTOMY](#d-level-dichotomy) | `PROVED_AI_UNREVIEWED` | Level dichotomy: tau < 0 gives no excess for any nonzero coefficient, at every smooth X |
| [D-LIAISON-IDENTITY](#d-liaison-identity) | `PROVED_AI_UNREVIEWED` | Liaison identity: [Y_1] + (-1)^(c-1) [Y_2] = m'' eta^k - [R] with R the Northcott residual |
| [D-CODIM-VZ](#d-codim-vz) | `EXACT` | Codimension of V_Z for two linear subspaces: package values equal the published formulas |
| [D-CODIM-AT-LAMBDA0](#d-codim-at-lambda0) | `PROVED_AI_UNREVIEWED` | Codimension and explicit description of the Hodge locus at the special coefficient lambda_0 |
| [D-TENFOLD-LAMBDA0-CHECK](#d-tenfold-lambda0-check) | `MOD_P` | Cubic tenfold, two 5-planes meeting in a P^2: lambda_0 = +1; excess only at lambda_0 at general points, at every coefficient at the Fermat point |
| [D-LINEAR-LIST-FIRST-ORDER](#d-linear-list-first-order) | `PROVED_AI_UNREVIEWED` | Two linear subspaces: the complete list of cases with excess away from lambda_0 at a general point |
| [D-MOVASATI-TABLES-REPRODUCED](#d-movasati-tables-reproduced) | `EXACT` | Movasati's (H, K) tables at the Fermat cubic reproduced exactly for dimensions 4, 6, 8 |
| [D-PUBLISHED-STATEMENTS-AT-INSTANCES](#d-published-statements-at-instances) | `MOD_P` | Published first-order statements of Kloosterman, Villaflor Loyola and Maclean reproduced at instances |
| [D-THREE-PLANES-CONIC](#d-three-planes-conic) | `MOD_P` | Three 3-planes in one P^4 on a quartic sixfold: the first-order jump set includes a conic that no pair explains |

## Related entries on other pages

| id | kind | status | page | title |
|---|---|---|---|---|
| [O-THREE-CYCLES](07_open_problems.md#o-three-cycles) | open | `OPEN` | 07 | Special coefficients for three or more cycles (first order: a conic beyond the pairwise lines; it dies at second order) |
| [O-KLOOSTERMAN-THEOREM-14-READING](07_open_problems.md#o-kloosterman-theorem-14-reading) | open | `OPEN` | 07 | Unresolved reading: Kloosterman's Theorem 1.4 (introduction) against smoothness at lambda = -1 for cubics with c = 2 |
| [O-HODGE-NUMBER-3432](07_open_problems.md#o-hodge-number-3432) | open | `OPEN` | 07 | Recorded disagreement with a published table: middle Hodge number of the cubic 12-fold, 3432 or 3433 |
| [C-WORDING-8-7-AND-20-19](08_corrections_and_lessons.md#c-wording-8-7-and-20-19) | correction | `EXACT` | 08 | '8 -> 7' and '20 -> 19' are K and H at the Fermat point for every nonzero coefficient, not codimensions of a Hodge locus |
| [C-NIGHT-WS-STATEMENT](08_corrections_and_lessons.md#c-night-ws-statement) | correction | `PROVED_AI_UNREVIEWED` | 08 | Night run: a statement on the family W_s at lambda_0 was false; replaced by the Northcott residual R |

---

## D-FIRST-ORDER-RULE

**First-order rule: level tau, special coefficient lambda_0 = (-1)^(c-1), excess e_tau**

kind: `result` | area: `first_order` | status: **`PROVED_AI_UNREVIEWED`**

**Statement.**

```text
Setting and symbols: discoveries/NOTATION.md. X = {F = 0} is smooth of degree d in P^(2k+1). Y_1 = V(f,p) and
Y_2 = V(h,p) are complete intersections of dimension k in X with c own equations each (f, h) and k+1-c shared
equations (p), and F = f^T M h + sum_l p_l s_l. Put tau = sum_(i<c)(deg f_i + deg h_i) - (c-1)d = d - deg det M,
lambda_0 = (-1)^(c-1), A = S/(f,h,p,s), e_tau = dim A_tau (0 if tau < 0). The range is (k-1)d + tau < 2k+2.
Statement (Theorem 2 of the unreviewed note 3):
(1) V_1 = NL([Y_1]) and V_2 = NL([Y_2]) are smooth at X, of codimension dim (S/(f,p,Mh,s))_d and
    dim (S/(h,p,M^T f,s))_d. V_Z is smooth with T V_Z = T V_1 n T V_2. V_1 and V_2 are transversal iff the range holds.
(2) For every lambda != 0 the excess of lambda is at most e_tau. In the range it equals e_tau.
(3) If tau < 0, then NL(delta_lambda) = V_Z for every lambda != 0.
(4) If tau >= 0, then NL(delta_lambda_0) is smooth of codimension codim V_Z - e_tau, with tangent space
    T V_Z + det M * S_tau.
(5) If tau >= 0 and lambda is not in {0, lambda_0}, the excess is dim (0 :_A det M)_tau
    = e_tau - rank(det M : A_tau -> A_d). It does not depend on lambda.
```

**Data.**

Examples (all reproduced by the package from the degrees):

| configuration | (d; deg f; deg h; deg p) | tau | lambda_0 | e_tau | codim V_Z | codim NL at lambda_0 | range |
|---|---|---|---|---|---|---|---|
| cubic sixfold, two 3-planes meeting in a point | (3; 1,1,1; 1,1,1; 1) | 0 | 1 | 1 | 8 | 7 | yes |
| cubic eightfold, two 4-planes meeting in a line | (3; 1,1,1; 1,1,1; 1,1) | 0 | 1 | 1 | 20 | 19 | yes |
| cubic eightfold, two 4-planes meeting in a point | (3; 1,1,1,1; 1,1,1,1; 1) | -1 | -1 | 0 | 20 | 20 | - |
| quartic fourfold, two planes meeting in a point | (4; 1,1; 1,1; 1) | 0 | -1 | 1 | 12 | 11 | yes |
| quartic fourfold, two planes meeting in a line | (4; 1; 1; 1,1) | 2 | 1 | 3 | 11 | 8 | no |
| quintic surface, two coplanar lines | (5; 1; 1; 1) | 2 | 1 | 1 | 4 | 3 | yes |

Outside the range (quartic fourfold, planes meeting in a line): excess 3 at lambda = 1 and 2 at six other values
of lambda (MOD p, one instance), as (5) predicts: 3 - 1 = 2.
The twelve degree types of the note's table "tab:tau" are listed in tests/SOURCES.md, entry E4.

**Conditions.**

The classical description of the tangent space of a Hodge locus in the Jacobian ring (Griffiths, Carlson-Griffiths,
Macaulay duality) and the period formula for complete intersections (Lemma 2.1 of note 3). All degrees of f, h, p
are at least 1 and less than d. X smooth. The cited analytic inputs were not opened by any agent.

**Evidence.**

Written proof in note 3 (version 21). AI referees 13, 14 and 22 read it and reported no fatal error; parts (2)-(5)
need no range hypothesis (referee 13) and part (5) is due to referee 14.
Computed MOD p at random instances: the twelve degree types of the note's table agree. Night-run blind agent
(own Macaulay2 code, reads only the note): first order 84/84 (42 types, 2 primes), sign rule 84/84.
Night check T1: the residue identity behind kappa_1 = kappa_2 in 190 degree types at p = 32003 (60 again at
p = 2147483629). Agent GC: lambda_0 = (-1)^(c-1) in 18 equality types, including non-linear complete
intersections in fourfolds. Package: tests 09 (60 checks) and 15.

**Independent check.**

No C-number (this is a night-run result). The night-run blind agent confirmed the first-order numbers and the
sign rule at instances, MOD p. Not covered: 5 degree types that check T1 did not run (the ledger labels them
'(3,4)'); the cited inputs; any human reading.

**Not established.**

Not a published or human-reviewed theorem. The rule is a first-order statement: for lambda not in {0, lambda_0}
it does not give the dimension of the Hodge locus (see the second-order entries). Outside the range the excess
for lambda != lambda_0 depends on the data, not only on the degrees.

**Known before.**

Published, as machine-read in tests/SOURCES.md: tau < 0 implies equal tangent spaces for all but finitely many
lambda (Kloosterman arXiv:2312.12363, Theorem 1.5, same inequality); for linear cycles and every nonzero
coefficient at the Fermat point (Villaflor Loyola arXiv:1812.03964, Theorem 3; Movasati-Villaflor Loyola
arXiv:1705.00084, Theorem 2). Excess at least 1 for linear cases with tau >= 0 (Kloosterman Theorem 1.3,
Example 3.17; Villaflor Loyola Proposition 7; excess exactly 1 at Fermat for m = n/2 - 3: Proposition 21 of
Movasati arXiv:2211.11405). The special coefficients 1 for (d,c) = (3,3) and -1 for (4,2): Kloosterman
Theorem 1.2, Corollaries 6.2, 6.5. The rule lambda_0 = (-1)^(c-1) in terms of c for general complete
intersections, and parts (4), (5) in this generality: not found in the sources we read (machine-read, see
tests/SOURCES.md); not checked further.
rStation paper #5 (u/lelong_ridge, v5 18 Oct 2026, https://rstation.ai/problems/hodge_conjecture/papers/5) has
no general rule for lambda_0 or the excess: its Sec. 6 records rk L(delta) = codim V_Z - 1 at the tested
instances (n = 6, 8, 10; credited there to Villaflor and Kloosterman) and treats lambda = 1 via Kloosterman
Prop. 6.4 / Cor. 6.5. Not covered there: the rule lambda_0 = (-1)^(c-1), the level tau and the excess e_tau.

**Reproduce.**

Run from the repository root (Macaulay2 1.22). Degrees only (integer arithmetic):

```
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
r = excessFromDegrees(3, {1,1,1}, {1,1,1}, {1});
print(r#"tau", r#"lambda0", r#"eTau", r#"codimVZ", r#"codimNLAtLambda0", r#"excessElsewhere", r#"inRange");
t = excessFromDegrees(4, {1}, {1}, {1,1});
print(t#"tau", t#"lambda0", t#"eTau", t#"inRange", t#"excessAtLambda0", t#"excessElsewhere");
```

Expected: (0, 1, 1, 8, 7, 1, true) and (2, 1, 3, false, 3, NotDetermined).
Comparison with a direct Jacobian-ring computation at random instances: tests/run_all.sh 09_session
(file tests/validation/09_session_theorem2_table.m2; 60 checks).

**Session references (files not public).**

night/paper3/paper3.tex (Theorem 2, table tab:tau); LEDGER.md entries "REFEREE 13", "REFEREE 14", "REFEREE 22",
"BLIND AGENT FINAL", "SECOND ROUND OF CHECKS"; night/CHECKS_R2.md (T1, T3); tests/SOURCES.md E1, E4.

---

## D-LEVEL-DICHOTOMY

**Level dichotomy: tau < 0 gives no excess for any nonzero coefficient, at every smooth X**

kind: `result` | area: `first_order` | status: **`PROVED_AI_UNREVIEWED`**

**Statement.**

In the setting of D-FIRST-ORDER-RULE: if tau < 0, then NL([Y_1] + lambda [Y_2]) = V_Z for every lambda != 0, at
every smooth X containing the two cycles (Theorem 2(3) of the unreviewed note 3). For two k-planes meeting in
dimension k - c on a hypersurface of degree d: tau = 2c - (c-1)d, so tau < 0 means c >= 4, or c = 3 and d >= 4,
or c = 2 and d >= 5 (Theorem 9.7(1) of the same note).

**Conditions.** As for D-FIRST-ORDER-RULE.

**Evidence.**

Ten-line argument in note 3 (I_1 n I_2 = 0), read by AI referees. MOD p at instances: package test 06
(11 linear triples at a random point, 5 of them also at the Fermat point, 5 non-linear degree types; 21 checks);
slow test 16 (five more triples: sextic fourfolds, cubic tenfolds). Night check T3: excess 0 for (3,3,4), (3,4,4),
(3,4,5), (4,2,3), (5,2,2), (5,2,3), (5,1,2), (6,1,2).

**Independent check.** None with a C-number. Night-run blind agent: 13 triples outside the list, MOD p.

**Not established.**

Not a human-reviewed theorem. The published statements cover: all but finitely many lambda (Kloosterman), or
linear cycles at the Fermat point and at a general point (Villaflor Loyola). "Every lambda != 0 at every smooth X"
for general complete intersections is the session's claim only.

**Known before.**

Published for all but finitely many lambda: Kloosterman arXiv:2312.12363, Theorem 1.5 (= 3.16). Published for
linear cycles: Villaflor Loyola arXiv:1812.03964, Theorems 3 and 4; Movasati-Villaflor Loyola arXiv:1705.00084,
Theorem 2 (a list of triples, all with tau < 0). The statement for every lambda != 0 at every smooth X: not found
in the sources we read (machine-read, see tests/SOURCES.md); not checked further.

**Reproduce.**

Run from the repository root (Macaulay2 1.22).

```
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
t = excessFromDegrees(3, {1,1,1,1}, {1,1,1,1}, {1});
print(t#"tau", t#"codimVZ", t#"excessAtLambda0", t#"excessElsewhere"); print(t#"levelDichotomy");
```

Expected: (-1, 20, 0, 0) and the line "tau < 0: no excess; ...". At instances: tests/run_all.sh 06_no_excess
(file tests/validation/06_no_excess_tau_negative.m2; 21 checks).

**Session references (files not public).** night/paper3/paper3.tex (Theorem 2(3), Theorem 9.7(1)); night/CHECKS_R2.md T3; tests/SOURCES.md A4, B, C1.

---

## D-LIAISON-IDENTITY

**Liaison identity: [Y_1] + (-1)^(c-1) [Y_2] = m'' eta^k - [R] with R the Northcott residual**

kind: `result` | area: `first_order` | status: **`PROVED_AI_UNREVIEWED`**

**Statement.**

In the setting of D-FIRST-ORDER-RULE (any tau), let R = V(p, M^T f, det M). Then (Theorem 1 of the unreviewed
note 3): tau <= d; R lies in X and is Cohen-Macaulay of pure dimension k (empty iff tau = d); R is linked to Y_1
by the complete intersection V(p, M^T f) inside X; and [Y_1] + (-1)^(c-1) [Y_2] = m'' eta^k - [R] in H^(2k)(X, Z)
for an explicit integer m''. If tau >= 0, every hypersurface {F - N det M = 0}, N of degree tau, contains R. So
for small N it lies in NL(delta_lambda_0). This is the source of the special coefficient lambda_0 = (-1)^(c-1).

**Conditions.**

The colon formulas of Northcott and Wiebe for the residual ideal (cited through a secondary source; proved again
by AI referee 12) and additivity of cycle classes under linkage. Degrees of f, h, p between 1 and d-1.

**Evidence.**

Written proof in note 3, read by AI referees 11, 12, 13, 22. MOD p: dim R = k, deg R as predicted and the colon
formulas in eight degree types (c = 1..4, tau = -1, 0, 1). Lean (kernel-checked polynomial identities only):
Cramer-type identities for a 4 x 4 matrix M (lean/core/GenFamilyCert.lean), 2 x 2 (lean/core/OcticDetCert.lean)
and any size with Mathlib (lean/mathlib/SpecialCoefficient.lean).

**Independent check.** None with a C-number. AI referees of the night run only.

**Not established.**

Not human-reviewed. The Lean files certify matrix identities, not the geometric statement. An earlier description
of the family at lambda_0 (W_s as a fibrewise closure) was false and was replaced by R: see C-NIGHT-WS-STATEMENT.

**Known before.**

For two linear subspaces in the cases (d,c) = (4,2), (3,3) the pencils F +- t det M are in Kloosterman
arXiv:2312.12363, Section 6 (machine-read in the session; tests/SOURCES.md lists Corollaries 6.2, 6.5). The
identity for general complete intersections with the residual R: not found in the sources we read (machine-read,
see tests/SOURCES.md); not checked further.

**Reproduce.**

not reproducible from this repository: the residual cycle R and the family F - N det M are not implemented in the
package (README.md, section "Limitations"). Needed: a function that builds R from (f, h, p, M, s) and computes its
degree and class.

**Session references (files not public).**

night/paper3/paper3.tex (Theorem 1, Lemma "NW"); LEDGER.md "13:38Z REFEREE 11", "14:00Z REFEREE 12";
night/gen_ci/PROOF_G.md (section 5B).

---

## D-CODIM-VZ

**Codimension of V_Z for two linear subspaces: package values equal the published formulas**

kind: `result` | area: `first_order` | status: **`EXACT`**

**Statement.**

```text
For two k-planes meeting in dimension m = k - c on a hypersurface of degree d, the codimension of V_Z computed by
the package from Hilbert functions equals
    2 binomial(k+d,k) - binomial(k-c+d,k-c) - (k+1)^2 - 2c(k+1) + c^2
on 135 triples (d,k,c), and equals every K entry of Movasati's table for cubics (n = 4..12) and of his tuples
for degrees 4 to 7. This is an agreement of integers, exact. It is not a new result.
```

**Data.**

Values used in this registry: 8 (cubic sixfold, 3-planes meeting in a point), 20 (cubic eightfold, 4-planes
meeting in a line), 12 (quartic fourfold, planes meeting in a point), 11 (quartic fourfold, planes meeting in a
line), 4 (quintic surface, coplanar lines), 22 (quintic fourfold, planes meeting in a line).
Movasati's closed form for d = 3, m = n/2 - 3: (1/6)k^3 + (3/2)k^2 - (14/3)k + 4 (8 and 20 for k = 3, 4).
Note on a ledger line: the night-run ledger lists "codimension formulas (4 quintic surface; 12, 11 quartic
fourfold; 8 cubic sixfold; 22 for (5,2,1))" without saying which configurations are meant. Two readings fit
"12, 11" and both are true numbers: (a) codim V_Z = 12 for (d,k,c) = (4,2,2) and 11 = codimension of the locus at
lambda_0; (b) codim V_Z = 12 for (4,2,2) and 11 for (4,2,1). The sources do not decide between them.

**Conditions.** none (integer arithmetic on Hilbert functions of complete intersections)

**Evidence.**

Package tests 01 (24 checks) and 02 (4 checks, 135 triples). Agent PC cross-checked every K entry against the
formula.

**Independent check.** none (the published formula is the comparison)

**Not established.** Nothing beyond the equality of integers. That V_Z is smooth of this codimension is part of D-FIRST-ORDER-RULE(1).

**Known before.**

published: Kloosterman arXiv:2312.12363, Proposition 3.10; Movasati arXiv:1602.06607, Theorem 12 and Table 1
(column K); Movasati arXiv:2211.11405, Section 4; Movasati-Villaflor Loyola arXiv:1705.00084, Proposition 1.

**Reproduce.**

Run from the repository root (Macaulay2 1.22).

```
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
cod = (d, a, b, p) -> (r := excessFromDegrees(d, a, b, p); (r#"codimVZ", r#"codimNLAtLambda0"));
print(cod(5,{1},{1},{1}), cod(4,{1,1},{1,1},{1}), cod(4,{1},{1},{1,1}), cod(3,{1,1,1},{1,1,1},{1}), cod(5,{1},{1},{1,1}));
```

Expected: ((4, 3), (12, 11), (11, 8), (8, 7), (22, 19)). Full comparison: tests/run_all.sh 01_movasati and
tests/run_all.sh 02_kloosterman (files tests/validation/01_movasati_K_table.m2,
tests/validation/02_kloosterman_prop310.m2).

**Session references (files not public).** LEDGER.md entry "[REFEREED, night/referee3_report.md]" ("codimension formulas"); tests/SOURCES.md A1, A3, B, E5.

---

## D-CODIM-AT-LAMBDA0

**Codimension and explicit description of the Hodge locus at the special coefficient lambda_0**

kind: `result` | area: `first_order` | status: **`PROVED_AI_UNREVIEWED`**

**Statement.**

```text
For tau >= 0 the locus NL([Y_1] + lambda_0 [Y_2]) is smooth of codimension codim V_Z - e_tau at every smooth X
(D-FIRST-ORDER-RULE(4)). For two k-planes on a cubic:
(a) meeting in codimension one (c = 1, tau = 2, lambda_0 = 1): the locus of [Pi_1] + [Pi_2] is the locus of cubics
    containing a complete intersection of type (1,...,1,2);
(b) meeting in codimension two (c = 2, tau = 1, lambda_0 = -1, every k >= 2): the locus of [Pi_1] - [Pi_2] is
    smooth and equal, near every smooth X containing the planes, to the locus of cubics containing a scheme
    V(p'', 2 x 2 minors of a 2 x 3 matrix of linear forms): a cubic scroll for k = 2, P^1 x P^2 in P^5 for k = 3,
    a cone over P^1 x P^2 for k >= 4. Its codimension is 2 binomial(k+1,3) - binomial(k-1,3) - (k-1)
    = 1, 6, 16, 32, 55 for k = 2..6;
(c) meeting in codimension three (c = 3, tau = 0, lambda_0 = 1; k = 3, 4): codimension 7 and 19.
```

**Conditions.**

As for D-FIRST-ORDER-RULE. Statement (b) is called there a consequence of Theorem 2(4); the comparison with the
literature was made by machine only.

**Evidence.**

Note 3, Theorem 2(4) and the paragraph "Two consequences for cubics" (read by AI referees 16, 22). The numbers
1, 6, 16, 32, 55 are returned by the package from the degrees. MOD p at instances: excess at lambda_0 in tests 04,
05, 10, 11 and slow/16 (for (3,5,2): 0 at six coefficients, 4 at lambda = -1).

**Independent check.** None with a C-number.

**Not established.**

The numbers 1, 6, 16, 32, 55 coincide with column CS ("cubic scroll") of Movasati's table and 7, 19 with column M;
in the sources 7 and 19 are codimensions of the Zariski tangent space at the Fermat point for every nonzero
coefficient, and the dimension of the locus is the subject of conjectures. That (b) proves a published conjecture
is NOT claimed: the comparison has not been made by a person.

**Known before.**

```text
(a) published: Movasati arXiv:2211.11405, Theorem 5. (b) the object and the codimensions are those of Movasati's
conjecture on generalized cubic scrolls (arXiv:1902.00831, Table 5 column CS; arXiv:2211.11405, Conjectures 6, 7),
stated at the Fermat point; that the locus is smooth of this codimension at every smooth X: not found in the
sources we read (machine-read, see tests/SOURCES.md); not checked further.
(c) positive codimension of V_Z in the locus: Kloosterman arXiv:2312.12363, Corollary 6.5 (for (d,c) = (4,2):
Corollary 6.2).
```

**Reproduce.**

Run from the repository root (Macaulay2 1.22).

```
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
print apply(toList(2..6), k -> (excessFromDegrees(3, {1,1}, {1,1}, toList((k-1):1)))#"codimNLAtLambda0");
```

Expected: {1, 6, 16, 32, 55}. First-order excess at lambda_0 at instances: tests/run_all.sh 04_kloosterman
(file tests/validation/04_kloosterman_thm12_no_excess.m2; about 45 s).

**Session references (files not public).** night/paper3/paper3.tex (Theorem 2(4), "Two consequences of Theorem 2(4) for cubics"); tests/SOURCES.md A2, E1.

---

## D-TENFOLD-LAMBDA0-CHECK

**Cubic tenfold, two 5-planes meeting in a P^2: lambda_0 = +1; excess only at lambda_0 at general points, at every coefficient at the Fermat point**

kind: `result` | area: `first_order` | status: **`MOD_P`**

**Statement.**

For (d,k,c) = (3,5,3) (two 5-planes meeting in a P^2 on a cubic tenfold; c = k - m = 3) the first-order rule
(D-FIRST-ORDER-RULE; paper 3 Thm 1, Thm 9.7) gives lambda_0 = (-1)^(c-1) = +1, tau = 0, e_tau = 1, codim V_Z = 39,
codim NL at lambda_0 = 38, and (3,5,3) is not in the sporadic list, so for lambda not in {0, 1} the excess at a
general point of V_Z is 0. Computed (MOD 32029): at a random point of V_Z the first-order excess is 1 at lambda = 1
and 0 at lambda = -1, 2, 1/2; at the Fermat point (Movasati's pair) it is 1 at lambda = 1, -1, 2, 1/2.
Consequence for O-TENFOLD-CONE-LEAD: lambda = -1 is NOT the special coefficient lambda_0 of the general rule; the
first-order excess at lambda = -1 (and 2, 1/2) is a property of special points (Fermat; also random Z_0 and Cone_18
points, session MOD p), not of a general point of V_Z.

**Conditions.**

One random point of V_Z (seed 1031; a second seed was running when this entry was written), the Fermat point,
MOD 32029; the random point was NOT checked for smoothness (a general cubic containing both planes is expected to
be smooth; not verified here). lambda_0 and the general-point excess from the degrees are PROVED_AI_UNREVIEWED
(paper 3).

**Evidence.**

examples/checks/tenfold_lambda0.m2 (package tangentExcess, fermatPairModP from tests/validation/common.m2);
excessFromDegrees(3,{1,1,1},{1,1,1},{1,1,1}) and linearSubspaceCase(3,5,3) = generic, excess elsewhere 0.
Checked at the request of the repository owner (Tim Seifert), who read Thm 9.7 as giving lambda_0 = +1 here:
confirmed.

**Independent check.**

The Fermat values agree with the independent blind check BC-T6 of O-TENFOLD-CONE-LEAD (rank L = 38, excess 1 at
lambda = -1, 2). No independent check of the random-point values.

**Not established.** Second-order behaviour; anything about the lambda = -1 survival at higher order (see O-TENFOLD-CONE-LEAD).

**Known before.**

The rule lambda_0 = (-1)^(c-1): paper 3 (AI-written, unreviewed); c = 1 and (d,c) = (3,2) cases in Dan, Movasati,
Kloosterman (machine-read).

**Reproduce.** examples/checks/tenfold_lambda0.m2

**Session references (files not public).** LEDGER_DISCOVERY.md "[COORD] 15:04Z PRE (lambda_0 check" and its RESULT line (24 Nov).

---

## D-LINEAR-LIST-FIRST-ORDER

**Two linear subspaces: the complete list of cases with excess away from lambda_0 at a general point**

kind: `result` | area: `first_order` | status: **`PROVED_AI_UNREVIEWED`**

**Statement.**

```text
Let Pi_1, Pi_2 be k-planes meeting in dimension k - c on a hypersurface of degree d >= 3 in P^(2k+1), with
kd - 2k - 2 >= 1 (this excludes cubic surfaces, cubic fourfolds and quartic surfaces). Then tau = 2c - (c-1)d and
(Theorem 9.7 of the unreviewed note 3, first-order half):
(1) tau < 0: no excess for any lambda != 0, at every smooth X.
(2) tau >= 0: at lambda_0 = (-1)^(c-1) the locus is smooth and strictly larger than V_Z, at every smooth X.
(3) tau >= 0, lambda not in {0, lambda_0}, X general: the excess is 0 unless (d,k,c) is in the list
    L = {(3,3,1), (3,3,2), (3,3,3), (3,4,1), (3,4,2), (3,4,3), (4,2,1), (4,2,2), (5,2,1)} u {(d,1,1) : d >= 5},
    where it is the number e of the table below.
```

**Data.**

| (d,k,c) | the two planes | tau | lambda_0 | e (excess for lambda != lambda_0) | excess at lambda_0 (MOD p, night check T3) |
|---|---|---|---|---|---|
| (3,3,1) | 3-planes in P^7 meeting in a plane | 2 | 1 | 2 | 3 |
| (3,3,2) | 3-planes meeting in a line | 1 | -1 | 2 | 2 |
| (3,3,3) | 3-planes meeting in a point | 0 | 1 | 1 | 1 |
| (3,4,1) | 4-planes in P^9 meeting in a 3-plane | 2 | 1 | 2 | 6 |
| (3,4,2) | 4-planes meeting in a plane | 1 | -1 | 2 | 3 |
| (3,4,3) | 4-planes meeting in a line | 0 | 1 | 1 | 1 |
| (4,2,1) | planes in P^5 meeting in a line | 2 | 1 | 2 | 3 |
| (4,2,2) | planes meeting in a point | 0 | -1 | 1 | 1 |
| (5,2,1) | planes in P^5 meeting in a line | 2 | 1 | 1 | 3 |
| (d,1,1), d >= 5 | two coplanar lines | 2 | 1 | 1 | 1 (d = 5, 6, 7) |

Off the list (excess 0 found): (3,3,4), (3,4,4), (3,4,5), (4,2,3), (5,2,2), (5,2,3), (5,1,2), (6,1,2).
Excluded cases (kd - 2k - 2 < 1): (4,1,2), (3,2,1), (3,2,2) show excess 1 for every lambda.
For cubics with c = 2 and k >= 5: multiplication by det M is injective for general data, so no excess for
lambda not in {0, -1} (Proposition 9.6 of the note).

**Conditions.**

D-FIRST-ORDER-RULE(5), and generic injectivity of multiplication by det M. For c = 1 this uses the strong Lefschetz
property of monomial complete intersections (Stanley, Watanabe; cited from memory, not opened; checked directly
for 3 <= d <= 10, 1 <= k <= 9, 72 of 72 pairs).

**Evidence.**

Note 3, Theorem 9.7 with its table, read by AI referee 21, who reproduced the first-order half by exact enumeration
for all 40 triples with tau >= 0, kd - 2k - 2 >= 1, d <= 7, k <= 6. Night check T3 (Singular, Jacobian-ring
quotients, random points): 12 of 12 rows agree for lambda in {2, 3, -2, -lambda_0}; 8 triples off the list have
excess 0; 3 excluded cases show excess 1. Package tests 10 (23 checks), 11 (8 checks).

**Independent check.** None with a C-number. Night-run blind agent: all ten rows, 13 triples off the list, MOD p.

**Not established.**

"General X" only for part (3): at special points (for instance Fermat points) the excess can be larger. Not run
in night check T3: (3,5,c) (one timeout), (4,3,c), (6,2,c) (these were run later by the blind agent).

**Known before.**

Published special cases, as machine-read: Kloosterman arXiv:2312.12363, Theorem 1.2 (existence of a point with no
excess outside {0, lambda_0} for d = 3, c in {2,3}, k >= 5 and d = 4, c = 2, k >= 3) and Theorem 1.3 (excess for
small k); Villaflor Loyola arXiv:1812.03964 (open cases listed in his Section 11). The complete list L with the
numbers e: not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further.
rStation paper #5 (u/lelong_ridge, v5 18 Oct 2026, https://rstation.ai/problems/hodge_conjecture/papers/5): not
covered (no list of cases; it works only with two k-planes meeting in P^(k-3) on cubics).

**Reproduce.**

Run from the repository root (Macaulay2 1.22).

```
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
for dkc in {(3,3,1),(3,3,2),(3,3,3),(3,4,1),(3,4,2),(3,4,3),(4,2,1),(4,2,2),(5,2,1),(5,1,1),(3,5,2),(3,3,4)} do (
    r := linearSubspaceCase dkc; print(dkc, r#"tau", r#"lambda0", r#"case", r#"genericExcessElsewhere"));
```

Expected: the table above ("sporadic" with e for the rows of L; "generic", 0 for (3,5,2); "tau < 0", 0 for (3,3,4)).
At random instances: tests/run_all.sh 10_session (file tests/validation/10_session_linear_list.m2) and
tests/run_all.sh 11_session (file tests/validation/11_session_linear_list_large.m2; about 35 s).

**Session references (files not public).**

night/paper3/paper3.tex (Theorem 9.7, Table 1, Proposition 9.6); LEDGER.md "REFEREE 21"; night/CHECKS_R2.md T2,
T3; tests/SOURCES.md E3, E6.

---

## D-MOVASATI-TABLES-REPRODUCED

**Movasati's (H, K) tables at the Fermat cubic reproduced exactly for dimensions 4, 6, 8**

kind: `result` | area: `first_order` | status: **`EXACT`**

**Statement.**

At the Fermat cubic of dimension n = 4, 6, 8, for two linear subspaces of the standard type meeting in P^m
(all m), the package computes over Q(zeta_6): K = codimension of the locus where both subspaces persist, and
H = codimension of the Zariski tangent space of the Hodge locus of r[P] + r'[P'] at the Fermat point. The values
equal Movasati's published table for coefficients (1,1), and H is the same for (r,r') = (1,-1), (1,2), (3,-5),
(7,10) when c = 2, 3. For the Fermat quartic fourfold: (H,K) = (11,12) for m = 0 and (12,12) for m = -1.
This is a reproduction of published numbers, not a new result.

**Data.**

Published table (H_n^3(m), K_n^3(m)), cubics, column = n/2 - m (as machine-read; rows 10 and 12 not reproduced in
the test suite except one entry, (38,39), in docs/02_level_dichotomy.md):

| n | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
|---|---|---|---|---|---|---|---|---|
| 4 | (1,1) | (1,2) | (1,2) | (1,2) | | | | |
| 6 | (4,4) | (4,7) | (6,8) | (7,8) | (8,8) | | | |
| 8 | (10,10) | (10,16) | (16,19) | (19,20) | (20,20) | (20,20) | | |
| 10 | (20,20) | (20,30) | (32,36) | (38,39) | (40,40) | (40,40) | (40,40) | |
| 12 | (35,35) | (35,50) | (55,60) | (65,66) | (69,69) | (70,70) | (70,70) | (70,70) |

The pairs "7 against 8" and "19 against 20" are K and H at the Fermat point for every nonzero coefficient. They
are not specifically attached to the difference of the two classes, and they are tangent-space numbers.

**Conditions.** The period polynomial of a linear subspace of the Fermat variety (det Jac, Villaflor Loyola's normalisation).

**Evidence.**

Package tests 03 (17 checks, exact), 15 (three routes sharing no code: Fermat module exact, Jacobian-ring tool MOD
p, Hilbert functions MOD p; 10 triples).

**Independent check.** none (comparison with a published table, read by machine)

**Not established.**

Nothing about the dimension of the Hodge locus. The published tables were read through a web-fetch tool, not by a
person.

**Known before.**

published: Movasati arXiv:1602.06607, Table 1 and Theorem 13; arXiv:1902.00831, Tables 1, 2; arXiv:2211.11405,
Proposition 21 (by Villaflor Loyola).

**Reproduce.**

Run from the repository root (Macaulay2 1.22). The two pairs of Movasati's Conjecture 1, four coefficient pairs
each for n = 6:

```
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
S = fermatRing(3, 6);
L1 = {{0,1,1},{2,3,1},{4,5,1},{6,7,1}}; L2 = {{0,1,3},{2,3,3},{4,5,3},{6,7,1}};
print apply({{1,1},{1,-1},{1,2},{3,-5}}, c -> (u := fermatTangentData(S, {L1, L2}, c); (u#"hodgeCodimension", u#"jointPersistenceCodimension")));
```

Expected: {(7, 8), (7, 8), (7, 8), (7, 8)}. A list {a,b,e} means x_a = z^e x_b with z = zeta_6. Full tables:
tests/run_all.sh 03_movasati (file tests/validation/03_movasati_H_fermat_exact.m2; about 30 s).

**Session references (files not public).** tests/SOURCES.md A1, A2, A3; tests/README.md (section on the wording 8 -> 7, 20 -> 19).

---

## D-PUBLISHED-STATEMENTS-AT-INSTANCES

**Published first-order statements of Kloosterman, Villaflor Loyola and Maclean reproduced at instances**

kind: `result` | area: `first_order` | status: **`MOD_P`**

**Statement.**

At random instances modulo a prime (and for Maclean's example also exactly over Q) the package reproduces:
Kloosterman's Theorem 1.2 at one random point each for (d,k,c) = (3,5,3), (3,5,2), (4,3,2) (no excess outside the
exceptional set S, excess at the exceptional coefficient); his Theorem 1.3 and Example 3.17 (excess at least 1 for
(3,k,c), k in {2,3,4}, c in {2,3} and (4,k,2), k in {1,2}); Villaflor Loyola's Corollary 3 (tangent space
(J : P_delta)_d) and the codimension binomial(k+d,d) - (k+1)^2 of the locus of hypersurfaces containing a k-plane
(4, 10 for cubics with k = 3, 4; 6 for quartic fourfolds; 2 for quintic surfaces); Maclean's quintic example
(two coplanar lines: codim V_Z = 4, tangent codimension 3, the excess direction dies for unequal coefficients
and survives for equal ones).

**Conditions.** One random instance per case; existence statements are tested at one point.

**Evidence.** Package tests 04 (9 checks), 05 (16), 06 (21), 07 (10), 08 (11, MOD p and exact over Q), slow/16 (7).

**Independent check.** none (comparison with published statements as read by machine)

**Not established.**

A passing test says "the package reproduces the number as the machine read it". Maclean's journal article could
not be opened: that comparison rests on her thesis and on Dan arXiv:1407.8491 (secondary).

**Known before.**

published: Kloosterman arXiv:2312.12363; Villaflor Loyola arXiv:1812.03964, arXiv:2001.01019; Maclean (thesis
2003; Asian J. Math. 9 (2005), not opened); Dan arXiv:1407.8491.

**Reproduce.**

Run from the repository root (Macaulay2 1.22). tests/run_all.sh 05_kloosterman (file
tests/validation/05_kloosterman_thm13_excess.m2) and tests/run_all.sh 08_maclean (file
tests/validation/08_maclean_coplanar_lines.m2). One instance by hand:

```
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
Y = randomCyclePair(5, {1}, {1}, {1}, Seed => 3);
print((excessFromData Y)#"codimVZ", (tangentExcess(Y, 2))#"excess", (secondOrderObstruction(Y, 2))#"verdict", (secondOrderObstruction(Y, 1))#"verdict");
```

Expected: (4, 1, ALL DIE, ALL SURVIVE).

**Session references (files not public).** tests/SOURCES.md parts B, C, D; tests/README.md.

---

## D-THREE-PLANES-CONIC

**Three 3-planes in one P^4 on a quartic sixfold: the first-order jump set includes a conic that no pair explains**

kind: `result` | area: `first_order` | status: **`MOD_P`**

**Statement.**

X = {F = 0} in P^7 a smooth quartic sixfold with F = x0 x1 x2 x3 + x5 A5 + x6 A6 + x7 A7 (explicit integer cubics A_j),
containing the 3-planes Pi_i = {x_(i-1) = x5 = x6 = x7 = 0}, i = 1, 2, 3 (and Pi_4 = {x3 = x5 = x6 = x7 = 0}; the period
polynomials satisfy P1 + P2 + P3 + P4 = 0). For delta = a0[Pi_1] + a[Pi_2] + b[Pi_3], the codimension of the Zariski tangent
space of NL(delta) in S_4 is 38 for general (a0 : a : b), 32 on the six lines a0 a b (a0 - a)(a0 - b)(a - b) = 0 away from
special points, 19 at (1:0:0), (0:1:0), (0:0:1), (1:1:1), and 37 on the conic 3601565 a0 a - 1797971 a0 b - 1803594 a b = 0
(through those four points). The conic depends on X. At points of the conic the excess explained by pairs is 0.
So, at first order, the special set for three cycles is NOT always a union of pairwise lines.

**Data.**

Instance: discovery file t4_three_cycles/INSTANCE_F.m2 (not in this repository; to be added with the next package version).
Exact values over QQ: 38 at (1 : 2 : 5/3); 32 at (1 : 1 : 3) (delta = 2P3 - P4); 19 at (1:0:0) and (1:1:1) (delta = -P4).
Conic point (5623 : -5623 : 3601565): 37 modulo 32003 and 31991; over QQ only 37 <= codim <= 38 is proved.
Integral class on the conic: 5623[Pi_1] - 5623[Pi_2] + 3601565[Pi_3]. At that point codim 37 is EXACT over QQ (team T4:
an explicit integral quartic G tangent to NL(delta) and not in K, plus an injective compression of rank 37).
Explanation at first order (MOD p, three quartics; one paper step, AI): the four planes meet in a point; on a 2-dimensional
block each plane's residue form has rank 1, B_i = c_i l_i^2 with four points l_i on a P^1, and the conic is
a0 a + mu a0 b - (1 + mu) a b = 0 with mu = 1/(t - 1), t the cross-ratio of the four points. mu depends only on the
restrictions of the cubics to the four triple lines through the common point. No closed formula in F was found.
SECOND ORDER: the extra direction is OBSTRUCTED. At five conic points on two quartics (MOD p, T4), and confirmed by blind
check C23 at the point above (MOD p, primes 32003 and 31991, own second-order method validated on single planes, on
1+1+1 and 2P3-P4, on kappa in K and on four-plane directions): no kappa in K solves order 2 for the direction G. So near
such a point NL(delta) has no component larger than the three-plane locus; the conic adds only non-reduced structure.

**Conditions.**

Standard first-order description of the tangent space of a Hodge locus (Carlson-Griffiths, Macaulay duality) and the period
polynomial of a linear space. The conic statement is modulo two primes; one instance of X.

**Evidence.**

Team T4 (own Macaulay2 code, cross-validated against the package's periodPolynomial): exact over QQ at the named points,
the factored determinant on two lines gives (six walls)^6 times the conic; two more quartics give other conics.

**Independent check.**

C22 (blind, own Macaulay2 and Singular code; read only F from T4's folder): every item confirmed; exact over QQ at four of
the five named points; at the conic point and for the conic modulo 32003 and 31991 only (8 points on the conic give 37,
14 off it give 38, 12 on the lines give 32; on three general lines the determinant gcd is (six-line product)^6 times the
conic). Not covered: an exact value at a conic point; the drop locus over QQ; the full three-variable minor ideal.

**Not established.**

The second-order obstruction over QQ (only mod two primes); the obstruction at every conic point; a cycle-theoretic
explanation of the conic (none is known); that every conic point is a jump over QQ; any statement for general X.

**Known before.**

Kloosterman arXiv:2312.12363, Definition 3.12, defines the excess tangent dimension at (a_1 : ... : a_r) for several classes;
no result for three classes was found there (as read by machine). The configuration is the four-plane locus Sigma_4 of the
fake-linear-cycle entries (Pi_4 is the fourth plane); team T1 had seen the conic modulo p earlier, unchecked. Otherwise
not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further.

**Reproduce.**

not reproducible from this repository: the instance F and the scripts are in the project's working files; the package has no
function for three or more cycles yet (see O-PACKAGE-FEATURES-NEEDED).

**Session references (files not public).** LEDGER_DISCOVERY.md "[T4] 00:09Z", "[CHECK C22] 01:33Z"; discovery/t4_three_cycles/INSTANCE_F.m2, three3.m2; checks/c22/.
