# SOURCES.md: the numbers the validation suite is checked against

Written by agent PC (an AI agent), 22 November 2026. No human has reviewed this file, the package, or the
session's own results listed in part E. Nothing here is, or bears on, a proof or disproof of the Hodge conjecture.

## Paths and names that are not in this repository

Part E and a few other places name working files of the research project: paths beginning with `night/` or
`discovery/`, `LEDGER.md`, `LEDGER_DISCOVERY.md`, `CHECKS_R2.md`, `END_OF_ROUND_REPORT.md`, `paper3.tex`, and Python
or Singular scripts. These files are NOT in this repository and are not public; they are named only to record where
a number came from. What this repository ships of them: the certificate files and their READMEs in
`tests/data/fermat/` (copies in `M2/HodgeLociCI/data/`), and the paraphrases of the statements of "paper 3" in part E
below and in the help nodes of the package. "The task" means the instructions that the agent who wrote this file
was given; they are not in the repository either.

## How the sources were read (please read this before trusting a number)

- Each paper in parts A to D was opened on the day of writing through a web-fetch tool: the tool downloads the page
  (arXiv PDF), converts it to text and returns the answers of a small language model to my questions about it.
  I did NOT see the raw text of the PDFs. A direct download of the arXiv sources was refused by the network proxy
  (HTTP 403), so there is no local copy and no text search was possible.
- Consequences: statement numbers, hypotheses and numbers below are "read in the source by machine". Tables were
  requested twice, in separate fetches, and the two readings agree where both were legible; entries the tool itself
  called garbled are marked. A human should confirm every entry against the paper before it is cited anywhere.
- Status labels used below:
  **[READ]** read in the source by machine (in the sense above);
  **[READ, SECONDARY]** read by machine, but in a paper by someone else describing the result;
  **[NOT VERIFIED]** not verified in the source (the source could not be opened, or the statement was not found);
  **[SESSION]** a result of this AI research session: AI-produced, checked only by other AI agents, unreviewed.
- Journal references are not given: the arXiv pages as fetched did not show them, and I do not fill them in
  from memory.
- Notation of the package and of part E: X a smooth hypersurface of degree d in P^(2k+1) (dimension n = 2k);
  two k-dimensional complete intersections Y1 = V(f,p), Y2 = V(h,p) meeting in dimension k - c (c = number of
  non-shared equations); V_Z = the locus of hypersurfaces containing both; tau = sum(deg f_i + deg h_i) - (c-1)d
  ("the level"); lambda_0 = (-1)^(c-1). For two k-planes meeting in P^m: c = k - m, tau = 2c - (c-1)d.
  Movasati writes n, m and (r, r-check); Kloosterman writes k, c and lambda.

---------------------------------------------------------------------------------------------------------------

## A. Movasati's tables at the Fermat point

### A1. H. Movasati, "Why should one compute periods of algebraic cycles?", arXiv:1602.06607  [READ]
URL: https://arxiv.org/abs/1602.06607 (PDF fetched: https://arxiv.org/pdf/1602.06607; version not shown in the text).

This is where the pairs "8 -> 7" and "20 -> 19" are tabulated.

- Section 6, Theorem 12: K_n^d(m) := codim(V_P n V_P-check), the locus of hypersurfaces containing two linear
  P^(n/2) meeting in P^m, is given by a closed formula (sums of binomials, eq. (23) with (22)).
- Section 6, eq. (21): H_n^d(m) := rank of the period matrix [p_(i+j)] of the SUM P + P-check at the Fermat point;
  by Theorem 5 (Section 4) the kernel of that matrix is the Zariski tangent space of the Hodge locus at the
  Fermat point, so H is the codimension of that tangent space. Theorem 13: for the pairs (n,d) of Theorem 1 the
  rank is the same for P + x P-check for every nonzero rational x. (As reported by the tool; one short quotation
  was returned only as a fragment: "be two linear algebraic cycles in the Fermat variety. We define".)
- Section 6, Table 1, "The numbers (H_n^3(m), K_n^3(m))" (cubics; column = n/2 - m; read twice, identical):

  | n \ (n/2 - m) | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
  |---|---|---|---|---|---|---|---|---|
  | 4  | (1,1)   | (1,2)   | (1,2)   | (1,2)   |         |         |         |         |
  | 6  | (4,4)   | (4,7)   | (6,8)   | (7,8)   | (8,8)   |         |         |         |
  | 8  | (10,10) | (10,16) | (16,19) | (19,20) | (20,20) | (20,20) |         |         |
  | 10 | (20,20) | (20,30) | (32,36) | (38,39) | (40,40) | (40,40) | (40,40) |         |
  | 12 | (35,35) | (35,50) | (55,60) | (65,66) | (69,69) | (70,70) | (70,70) | (70,70) |

  So: cubic sixfold, two 3-planes meeting in a point (m = 0): K = 8, H = 7. Cubic eightfold, two 4-planes meeting
  in a line (m = 1): K = 20, H = 19.
- Section 6, data in the text as tuples (n, d, m | H, K): (4,4,0 | 11,12), (4,4,-1 | 12,12), (4,5,0 | 24,24),
  (4,5,-1 | 24,24), (4,6,0 | 38,38), (4,6,-1 | 38,38), (6,4,1 | 36,37), (6,4,0 | 38,38), (6,4,-1 | 38,38).
  ((4,7,0): K = 54, H not computed.)
- Section 4, table "Codimension of the loci of complete intersection algebraic cycles", types (d_1,d_2,d_3) and
  codimensions: (1,1,1) 19, (1,1,2) 32, (1,1,3) 37, (1,2,2) 54, (1,2,3) 62, (1,3,3) 71, (2,2,2) 92, (2,2,3) 106,
  (2,3,3) 122, (3,3,3) 141. The tool reports that the table itself does not print (n,d) and that it stands in the
  discussion of sextic fourfolds; (n,d) = (4,6) is my inference (the entry 19 = binomial(8,6) - 9 for three linear
  forms). Section 6: for (n,d) = (4,4), the locus T_(1,1,2) has codimension 8.
- Section 6, Conjecture 7: H < K for m = n/2 - 2, n >= 6. Section 1, Conjecture 1 of THIS paper concerns
  m = n/2 - 2 and d > 2(n+1)/(n-2) (existence of a finite nonempty set of coprime (r, r-check) with a larger
  deformation space); it is not the conjecture usually called "Movasati's Conjecture 1" (see A3).
- Section 1: one verification, (n,d,m) = (8,3,2), is reported to take more than 14 days of computer time.

IMPORTANT reading notes (mine).
(i) H is a FIRST-ORDER number at the FERMAT point, defined with coefficients (1,1) and stated to be the same for all
nonzero rational coefficients. It is not "the codimension of the Hodge locus of the difference of the two
classes": that the locus itself has codimension K - 1 is the content of the conjecture in A3, and for
m = n/2 - 3 no particular coefficient is singled out in the sources. (The coefficient (1,-1) is singled out in
the sources for m = n/2 - 2, the "cubic ruled cycle" column (6,8), (16,19); see A2.)
(ii) Cross-check done by me, not in the source: every K entry above, and every K in the tuples, equals the value
of the formula of Kloosterman's Proposition 3.10 (entry B) at (k, c) = (n/2, n/2 - m).

What a test computes. K: codimension of V_Z from the degree data (Hilbert function), d = 3, 4, 5, 6. H: the
first-order tangent codimension of the Hodge locus of [P1] + lambda [P2] AT THE FERMAT POINT with Movasati-type
planes x_a = zeta x_b; expected H for every lambda != 0 tested. Label: EXACT if done over Q(zeta_2d), MOD p if a
root of unity in F_p is used.

### A2. H. Movasati, "Hodge cycles for cubic hypersurfaces", arXiv:1902.00831  [READ]
URL: https://arxiv.org/abs/1902.00831 (v2 of 5 April 2019 according to the abstract page; PDF https://arxiv.org/pdf/1902.00831).

- Setting: Fermat cubic X_0 of even dimension n in {4,...,12}, Z_0 = r P + r-check P-check, 1 <= |r|, |r-check| <= 10,
  P n P-check = P^m; a family S of deformations x_0^3 + ... - sum t_alpha x^alpha (squarefree cubic monomials) chosen
  so that the triple (X_0, P, P-check) is rigid in it. (The tool reports that the text does not say "dim S =
  codim V_Z"; the dim(S) row below nevertheless coincides with the K column of A1.)
- Theorem 1 (the only numbered theorem; computer-assisted): for m = n/2 - 2 the N-th order Hodge locus V^N is
  smooth at 0 in the cases marked in Table 1 and, for r != -r-check, not smooth in the crossed cases; for
  m = n/2 - 3 it is smooth for the N of Table 2, for all r, r-check in the range; the codimensions of the Zariski
  tangent spaces at 0 are the third rows of the tables.
- Table 1 (m = n/2 - 2), n = 4, 6, 8, 10, 12: dim(S) = 2, 8, 19, 36, 60; codim(V^1) = 1, 6, 16, 32, 55.
  Rows N = 2, 3, 4 (smooth yes/no): N = 2 yes in all five; N = 3: yes, yes, no, no, no; N = 4: yes, no, no, no, no
  (the tool flags the N = 4 row and the last row, for Z_0 = P - P-check, as partly garbled: NOT recorded here).
- Table 2 (m = n/2 - 3), n = 4, 6, 8, 10, 12: dim(S) = 2, 8, 20, 39, 66; codim(V^1) = 1, 7, 19, 38, 65;
  orders N up to which V^N is smooth: infinity, 14, 6, 4, 3.
- Conjecture 1 (Section 1), two parts, for the full family of cubics: (1) for m = n/2 - 2, V_([P] - [P-check]) is
  smooth and larger than the deformation space of the triple; (2) for m = n/2 - 3 and all r, r-check, the same,
  and (short quotation) "The difference of dimensions in this case is 1." Stated to hold trivially for n = 4.
- Section 6, Table 5 (the text calls it Table 6 in places), codimensions of loci of cubics, columns L (linear
  cycle), CS (cubic scroll), M (the components of Theorem 1(2)), QS (quartic scroll), V (Veronese):
  n = 6: 4, 6, 7, 8, 10; n = 8: 10, 16, 19, 23, 25; n = 10: 20, 32, 38, 45, 47; n = 12: 35, 55, 65, 75, 77
  (n = 4: all 1). Column dim(T): 20, 56, 120, 220, 364 for n = 4..12. Hodge numbers (h^(n,0), ..., h^(0,n)):
  n = 4: 0,1,21,1,0; n = 6: 0,0,8,71,8,0,0; n = 8: 0,0,0,45,253,45,0,0,0; n = 10: 0,0,0,1,220,925,220,1,0,0,0;
  n = 12: 0,0,0,0,14,1001,3432,1001,14,0,0,0,0. (The column "range of codimensions" was read differently in A1 and
  A3 for n = 12 and is not recorded.)
  **DISAGREEMENT with the package (recorded, not adjusted):** for n = 12 the package gives the middle Hodge number
  3433 (primitive 3432, plus 1), the table prints 3432 although its rows n = 4..10 include the +1. The entry was
  re-read with a question about exactly this digit, in A2 and in A3: 3432 both times. See tests/README.md.
- Tables 3 and 4 list the monomials of S (8 for n = 6 in both; 19 resp. 20 for n = 8): not recorded here.

What a test computes. dim(S) row = codim V_Z (as in A1). codim(V^1) rows = first-order tangent codimension at the
Fermat point: 6, 16 (c = 2) and 7, 19 (c = 3) for n = 6, 8. Column L: codim of the locus of cubics containing a
k-plane, binomial(k+3,3) - (k+1)^2 = 4, 10, 20, 35. Column CS = K - e_tau with c = 2 (the value at lambda_0 = -1
in part E): 6, 16, 32, 55. The finite-order smoothness statements (N = 14, 6, ...) are NOT covered (see README).

### A3. H. Movasati, "On a Hodge locus", arXiv:2211.11405  [READ]
URL: https://arxiv.org/abs/2211.11405 (v4 of 25 February 2025 according to the abstract page; PDF https://arxiv.org/pdf/2211.11405).

- Conjecture 1 (Section 1), "Movasati's Conjecture 1": d = 3, n = 6 or n = 8, m = n/2 - 3 (two 3-planes meeting
  in a point; two 4-planes meeting in a line), Z = r P + r-check P-check with r a positive integer and r-check a
  nonzero integer (no coprimality condition), T the space of smooth cubics near the Fermat point. Conclusion
  (short quotation): "the Hodge locus V_[Z] is of dimension dim(V_Z)+1"; a further clause asserts the Hodge
  conjecture for the classes over V_[Z]. Trivial for n = 4; Section 2 and Section 9 say it is false for n >= 10,
  attributing this to Kloosterman (entry B).
- Section 4: codim V_Z by the formula of A1 (citing the author's book, Prop. 17.9); for d = 3, k = n/2 and
  m = n/2 - 3 the closed form (1/6)k^3 + (3/2)k^2 - (14/3)k + 4. The numbers 8 and 20 are NOT printed; they are the
  values of this polynomial at k = 3, 4 (evaluation by the tool and by me). The tool notes that an intermediate
  expansion printed in the same section is inconsistent with this final formula.
- Section 5, Table 1 (same as Table 5 of A2), column M = "the codimension of our Hodge loci in Conjecture 1":
  7 (n = 6), 19 (n = 8), 38, 65.
- Theorem 3 (Section 2): for m < n/2 - d/(d-2), T_0 V_[Z] = T_0 V_Z and V_[Z] = V_Z (computer proof in the book for
  a list of cases, full proof attributed to Villaflor Loyola, entry C1).
- Theorem 8 (Section 3; computer proof): for 1 <= r, |r-check| <= 10 the N-th order Hodge locus is smooth for
  N <= M, (n, M) = (6,14), (8,6), (10,4), (12,3).
- Conjecture 6 / 7 (Section 2): for (d,m) = (3, n/2 - 2), V_[Z] is not smooth if (r, r-check) != (1,-1), and is
  smooth, parametrizing hypersurfaces containing a generalized cubic scroll, if (r, r-check) = (1,-1).
  Conjecture 4: for m = n/2 - 1 and (r, r-check) != (1,1), V_[Z] is not smooth; Theorem 5: for (1,1) it is the locus
  of hypersurfaces containing a complete intersection of type (1,...,1,2).
- Appendix A, Proposition 21 (by R. Villaflor): at the cubic Fermat variety, for two explicit linear cycles with
  m = n/2 - 3, dim T_0 V_[Z] = dim T_0 V_Z + 1.

What a test computes. (a) codim V_Z = 8, 20 from degree data; (b) first-order excess exactly 1 for every tested
lambda != 0 at the Fermat cubic sixfold and eightfold with m = n/2 - 3 (Proposition 21; the tangent-space part of
the conjecture); (c) first-order equality T V_[Z] = T V_Z when tau < 0 (Theorem 3); (d) NOT a test of the
conjecture itself: what the session found about it is in E8, labelled as the session's own.

### A4. H. Movasati, R. Villaflor Loyola, "Periods of linear algebraic cycles", arXiv:1705.00084  [READ]
URL: https://arxiv.org/abs/1705.00084 (PDF https://arxiv.org/pdf/1705.00084).

- Theorem 1: explicit periods of linear cycles of the Fermat variety (values are roots of unity times
  1/(d^(n/2+1) (n/2)!), or zero).
- Theorem 2: for (n,d,m) in the list (2,d,-1) with 5 <= d <= 14; (4,4,-1), (4,5,-1), (4,6,-1), (4,5,0), (4,6,0);
  (6,3,-1), (6,4,-1), (6,4,0); (8,3,-1), (8,3,0); (10,3,-1), (10,3,0), (10,3,1): the locus of hypersurfaces
  containing two linear cycles meeting in P^m is a reduced component of the Hodge locus of the sum (variational
  Hodge conjecture on a Zariski open subset). All these triples have tau < 0 in the package's notation.
- Proposition 1, eq. (24) (Section 5-6): codimension of that locus = 2 C_(1^(n/2+1), (d-1)^(n/2+1))
  - C_(1^(n-m+1), (d-1)^(m+1)), with C_a defined in (23) by an inclusion-exclusion of binomials.
- Theorem 4 / Conjecture 1 of that paper (Section 7): for a complete intersection Z of type (d_1,...,d_(n/2+1)) the
  conjectured rank of the period matrix is C_(d_1,...,d_(n/2+1), d-d_1,...,d-d_(n/2+1)); for all d_i = 1 this is
  binomial(n/2+d, d) - (n/2+1)^2 (Proposition 2). (One bound in Theorem 4 was garbled in extraction.)
- No table of numbers in this paper (the tables are in A1).

What a test computes. For every triple of Theorem 2: tau < 0 and first-order excess 0 (at a random point and, where
feasible, at Fermat), and codim V_Z from the Hilbert function. Codimension of the locus of hypersurfaces
containing one complete intersection: dim (S/(f,g))_d, compared with binomial(k+d,d) - (k+1)^2 for linear cycles.

### A5. H. Movasati, "A course in Hodge theory: with emphasis on multiple integrals" (book)  [NOT VERIFIED]
Cited by A1, A3 and B (Conjecture 19.1, Theorem 18.1, 18.3, 19.1, Proposition 17.9, Sections 19.2, 19.8 as numbered
in B and A3). Not opened. Nothing is taken from it.

---------------------------------------------------------------------------------------------------------------

## B. R. Kloosterman, "On a conjecture on Hodge loci of linear combinations of linear subvarieties", arXiv:2312.12363  [READ]
URL: https://arxiv.org/abs/2312.12363 (v2 of 16 July 2025 on the abstract page; the PDF fetched, https://arxiv.org/pdf/2312.12363,
is dated 23 September 2025).

Notation there: cubic or quartic X in P^(2k+1), two k-planes Pi_1, Pi_2 meeting in dimension k - c ("codimension c"),
NL(.) the Hodge locus, NL([Pi_1],[Pi_2]) the locus where both classes stay Hodge.

- Conjecture 1.1 (Movasati's conjecture as restated there, attributed to the book, Conj. 19.1(2)): k >= 2, X a
  smooth cubic with two k-planes meeting in dimension k - 3, integers a, b with ab != 0; then
  codim NL(a[Pi_1] + b[Pi_2]) = codim NL([Pi_1],[Pi_2]) - 1.
- Theorem 1.2: let d = 3, c in {2,3}, k >= 5, or d = 4, c = 2, k >= 3. THERE EXISTS a smooth X of degree d containing
  two k-planes meeting in codimension c, and a finite set S, such that for all rational lambda not in S the tangent
  spaces of NL([Pi_1] + lambda [Pi_2]) and NL([Pi_1],[Pi_2]) at X have the same codimension and the two loci
  coincide near X. If c = d = 3 then S = {0, 1}; if d = 4, c = 2 then S = {0, -1}.
- Theorem 1.3: let d = 3, c in {2,3}, k in {2,3,4}, or d = 4, c = 2, k in {1,2}. For EVERY smooth X containing two
  such planes and every nonzero rational lambda, the tangent space of NL([Pi_1] + lambda [Pi_2]) is strictly larger
  than that of NL([Pi_1],[Pi_2]). Moreover for d = c = 3, k in {2,3,4}: for each lambda, either Movasati's
  conjecture holds for that lambda or NL([Pi_1] + lambda [Pi_2]) is non-reduced.
- Theorem 1.4 (= 5.3 in the body, which treats (d,c) = (3,3) and (4,2) only): at X of "split type" and for every
  nonzero rational lambda, NL([Pi_1],[Pi_2])_red is contained in NL([Pi_1] + lambda [Pi_2])_red near X, and for
  d = 3, k >= 5 or d = 4, k >= 3 the latter is reducible at X.
- Theorem 1.5 (= 3.16): Y_1, Y_2 complete intersections of multidegrees (d_0..d_k) and (e_0..e_(c-1), d_c..d_k) with
  Y_1 n Y_2 = Z a complete intersection of multidegree (d_0..d_k, e_0..e_(c-1)). If
  sum_(i<c) (e_i + d_i) < (c-1) d, then for all but finitely many nonzero rational lambda the tangent spaces of
  NL([Y_1] + lambda [Y_2]) and NL([Y_1],[Y_2]) have the same codimension, and
  NL([Y_1] + lambda [Y_2]) = NL([Y_1]) n NL([Y_2]). For linear Y_i the inequality reads (c-1)(d-2) > 2.
  (The inequality is exactly tau < 0.)
- Theorem 1.6 (= 3.14): a kernel criterion on a multiplication map for the same conclusion at first order;
  Corollary 3.15 a variant for every lambda.
- Proposition 3.10: the tangent space of NL([Pi_1],[Pi_2]) has codimension
  2 binomial(k+d,k) - binomial(k-c+d,k-c) - (k+1)^2 - 2c(k+1) + c^2 (a second display of the same formula in the
  proof is garbled according to the tool). Lemma 3.7: codim T NL(gamma) = codim of (I(gamma))_d in S_d.
- Example 3.17: for d = 3, k in {2,3,4} and for d = 4, k in {1,2} the inclusion of tangent spaces is strict for
  all lambda, at every X; the size of the excess is not stated (at least 1).
- Corollary 6.2: d = 4, c = 2, k >= 1: NL([Pi_1],[Pi_2]) is a subscheme of positive codimension of
  NL([Pi_1] - [Pi_2]). Corollary 6.5: d = 3, c = 3, k >= 2: the same for NL([Pi_1] + [Pi_2]).
  (Neither states "codimension exactly one" or smoothness.)
- No corollary specific to cubic eightfolds was found: k = 3, 4 are covered by Theorem 1.3 and Example 3.17 only.
- The paper states that only tangent spaces are analysed; short quotation: the author "did not succeed in higher
  order approximations".

What a test computes. Prop. 3.10: codim V_Z for a grid of (d,k,c), from the Hilbert function, against the formula.
Thm 1.2: at ONE random point modulo p (existence statement), first-order excess 0 for several lambda outside S and
excess > 0 at the special coefficient (1 for (d,c) = (3,3), -1 for (4,2)); cases (3,5,3), (3,5,2), (4,3,2).
Thm 1.3 / Ex. 3.17: excess >= 1 at random points and at Fermat for (3,k,c), k in {2,3,4}, c in {2,3} and (4,k,2),
k in {1,2}, several lambda. Thm 1.5: tau < 0 implies excess 0 for non-linear complete intersections (a few degree
types). Cor 6.2 / 6.5: excess > 0 at lambda_0 for larger k (first order only; "positive codimension" itself is a
statement about the loci, not tested). The "non-reduced or conjecture" alternative of Thm 1.3 is not testable
at first order; the session's second-order results (E3) bear on it and are labelled as the session's own.

---------------------------------------------------------------------------------------------------------------

## C. R. Villaflor Loyola: first-order statements

### C1. "Periods of complete intersection algebraic cycles", arXiv:1812.03964  [READ]
URL: https://arxiv.org/abs/1812.03964 (PDF https://arxiv.org/pdf/1812.03964). Results are numbered Theorem 1 to 4 there.

- Theorem 2 (period formula): X = {F = 0} smooth of degree d and even dimension n, Z = {f_1 = ... = f_(n/2+1) = 0} a
  complete intersection inside X, F = sum f_i g_i, H = (f_1, g_1, ..., f_(n/2+1), g_(n/2+1)). For P of degree
  (d-2)(n/2+1): the integral over Z of res(P Omega / F^(n/2+1)) equals (2 pi i)^(n/2) / (n/2)! * c * (d-1)^(n+2), where
  c is defined by P det Jac(H) = c det Hess(F) modulo the Jacobian ideal J^F. Theorem 1 is the corresponding
  formula for the class [Z] (primitive part = a residue with numerator det Jac(H)).
- Corollary 3 (Section 8): for a cycle delta "of complete intersection type" (an integer combination of complete
  intersections in X) with P_delta = sum n_i det Jac(H_i): T_t V_[delta] = (J^F : P_delta)_d.
- Corollary 4 (Section 8): two linear cycles of the Fermat variety meeting in dimension m have intersection number
  (1 - (1-d)^(m+1)) / d.
- Theorem 3 (Fermat) and Theorem 4 (general point): if m < n/2 - d/(d-2) then for all nonzero integers a, b,
  V_[a P + b P-check] = V_[P] n V_[P-check], smooth and reduced (Theorem 3, at Fermat); variational Hodge conjecture
  at a general point of the locus (Theorem 4). Section 9, Proposition 7 and Remark 7: if m >= n/2 - d/(d-2), the
  Zariski tangent space of V_[delta] at Fermat is strictly larger than that of the intersection.
  Open cases listed in Section 11: (d,m) = (3, n/2-3), (3, n/2-2), (4, n/2-2), and m = n/2 - 1 with a != b.
  (m < n/2 - d/(d-2) is tau < 0 for linear cycles: c > d/(d-2) iff 2c - (c-1)d < 0.)

What a test computes. Corollary 3 is the engine of the package's first-order tools: test that the tangent
codimension computed as dim (S/(J^F : P_delta))_d agrees with the Hilbert-function prediction on instances where
both are available. Corollary 4: self-consistency only (not computed by the package unless an intersection
number helper is exported). Theorem 3: excess 0 at Fermat for tau < 0; Proposition 7: excess > 0 at Fermat for
tau >= 0.

### C2. "Small codimension components of the Hodge locus containing the Fermat variety", arXiv:2001.01019  [READ]
URL: https://arxiv.org/abs/2001.01019 (PDF https://arxiv.org/pdf/2001.01019).

- Proposition 2.1 / 2.2 (Section 2): for a Hodge cycle lambda on X = {F = 0}, the Zariski tangent space of V_lambda is
  the degree-d part of the ideal J^(F,lambda) = (J^F : P_lambda), and S/J^(F,lambda) is Artinian Gorenstein of socle degree
  (d-2)(n/2+1).
- Example 2.1 (attributed there to Dan): for d >= 2 + 4/n the locus of hypersurfaces containing a complete
  intersection of type (d_1,...,d_(n/2+1)) is a component of the Hodge locus; V_[Z] is smooth and reduced with tangent
  space <f_1, g_1, ..., f_(n/2+1), g_(n/2+1)>_d.
- Theorem 1.1: for d not in {1,2,3,4,6} (zeta_d + 1/zeta_d irrational): a component of the Hodge locus through the
  Fermat variety has codimension binomial(n/2+d, d) - (n/2+1)^2 if and only if it is the locus of hypersurfaces
  containing a linear P^(n/2); and the Zariski tangent space of V_lambda at Fermat has that codimension if and only
  if lambda_prim is a rational multiple of the class of a linear P^(n/2). (One binomial in the statement was garbled
  in extraction and was read from Proposition 3.3 / eq. (15) by the tool.)
- Theorem 1.3: for the other components through Fermat, codim >=
  binomial(n/2+d, d) + binomial(n/2+d-1, d-1) - (3n^2/8 + 9n/4 + 2) (for d >= max(4, 2 + 6/n) also for Zariski tangent
  spaces), with the equality case attached to complete intersections of type (1,...,1,2).
- The statement about combinations of two linear cycles with m < n/2 - d/(d-2) is NOT in this paper (it is C1,
  Theorem 3).

What a test computes. Example 2.1: tangent codimension of the Hodge locus of one complete intersection =
dim (S/(f,g))_d, for a few types, by the package's first-order tools, against the Hilbert function of the
complete intersection (f,g). Theorem 1.1, numbers only: binomial(k+d,d) - (k+1)^2 for a linear cycle, e.g. 4, 10
(cubics, k = 3, 4), 6 (quartic fourfold), 2 (quintic surface). The "if and only if" statements are not testable.

---------------------------------------------------------------------------------------------------------------

## D. Maclean's quintic example

### D1. C. Maclean, "A second-order invariant of the Noether-Lefschetz locus and two applications", Asian J. Math. 9 (2005)  [NOT VERIFIED in the journal article]
The journal article could not be opened (the publisher page returned a bot-protection page; no arXiv version found).
What follows is from two other documents.

### D1a. C. Maclean, thesis "Quelques resultats en theorie des deformations en geometrie algebrique" (Paris 6, 2003)  [READ; the author's thesis, not the article]
URL: https://www-fourier.univ-grenoble-alpes.fr/~catriona/these.pdf (the tool read the first 100000 of 148361 characters).

- Theorem 24 (Chapter 4; Theorem 4 of the introduction): if a component NL(gamma) of the Noether-Lefschetz locus of
  quintic surfaces in P^3 is non-reduced, then for every X in it there is a plane H with H n X containing two
  distinct lines L_1, L_2, and distinct nonzero integers alpha, beta, with
  gamma = alpha [L_1] + beta [L_2] - ((alpha + beta)/5) H.
- Proposition 9 (converse): if a quintic X has a plane section made of two distinct lines and a cubic, and
  alpha != beta are nonzero integers, then NL(alpha L_1 + beta L_2 - ((alpha+beta)/5) H) is non-reduced: its reduction is
  NL(L_1) n NL(L_2), of codimension 4, while the Zariski tangent space has codimension smaller than 4.
- The second-order invariant (a quadratic form on tangent directions, Theorem 23 there) is used for Theorem 24.

### D1b. A. Dan, "Non-reduced components of the Noether-Lefschetz locus", arXiv:1407.8491  [READ, SECONDARY]
URL: https://arxiv.org/abs/1407.8491 (PDF fetched from www.arxiv.org/pdf/1407.8491).

- Introduction: describes Maclean's result as: for d = 5 there is a non-reduced component whose reduction
  parametrizes surfaces containing two coplanar lines, of codimension 2d - 6 = 4.
- Theorem 1.3 (= 6.17): for d >= 5 and X containing two distinct coplanar lines l_1, l_2, the locus NL(gamma) for
  gamma = [2 l_1 + l_2] is non-reduced, NL(gamma)_red = (NL([l_1]) n NL([l_2]))_red, of codimension 2d - 6.
- The paper the task named, A. Dan, arXiv:1404.7519 ("Noether-Lefschetz locus and a special case of the variational
  Hodge conjecture: using elementary techniques"), was opened too [READ]: it does not mention Maclean. Its
  Theorem 1.2 (d >= 5, gamma = sum a_i [C_i] with d > sum a_i deg C_i + 4) contains the criterion: NL(gamma) is
  non-reduced if and only if some pair C_i, C_j with i != j has C_i.C_j != 0.

What a test computes (package notation: k = 1, d = 5, c = 1; Y1 = V(f_0, p), Y2 = V(h_0, p) with p the equation of
the common plane; tau = 2, lambda_0 = +1). (a) codim V_Z = 2d - 6 = 4 for d = 5 (and 6, 8 for
d = 6, 7); (b) first-order excess 1 for every lambda != 0 (tangent codimension 3 < 4); (c) the second-order
checker reports that the excess direction dies for lambda not in {0, 1} (alpha != beta, non-reduced structure on
V_Z) and survives at lambda = 1 (alpha = beta). Label: MOD p or EXACT at a random point; the published statement is
for every such quintic, the test is one instance.

---------------------------------------------------------------------------------------------------------------

## E. The session's own results  [SESSION: AI-produced, checked only by AI agents, unreviewed by any human]

"PROVED" below always means "proved in an AI-written, unreviewed paper"; "COMPUTED" means computed modulo primes at
random instances unless marked exact.

### E1. Paper 3 (night/paper3/paper3.tex), Theorem 2 (first order; the coefficient lambda_0)
Setting: Y1 = V(f,p), Y2 = V(h,p) complete intersections of dimension k in X = {F = 0}, F = f^T M h + sum p_l s_l,
tau = sum_(i<c)(d_i + e_i) - (c-1)d = d - deg det M, lambda_0 = (-1)^(c-1), A = S/(f,h,p,s), e_tau = dim A_tau;
"the range" is (k-1)d + tau < 2k + 2.
(1) V_1, V_2 are smooth at X of codimensions dim (S/(f,p,g,s))_d and dim (S/(h,p,q,s))_d (g = M h, q = M^T f); V_Z is
    smooth with T V_Z = T V_1 n T V_2; V_1, V_2 are transversal iff the range holds.
(2) For every lambda != 0 the excess dim T NL(delta_lambda)/T V_Z is at most e_tau; in the range it equals e_tau.
(3) If tau < 0 then NL(delta_lambda) = V_Z for every lambda != 0.
(4) If tau >= 0 then NL(delta_lambda_0) is smooth of codimension codim V_Z - e_tau, tangent space T V_Z + det M * S_tau.
(5) If tau >= 0 and lambda not in {0, lambda_0}: excess = dim (0 :_A det M)_tau = e_tau - rank(det M : A_tau -> A_d).
Status: PROVED (AI paper, read by AI referees). Consequence recorded there for two k-planes on a cubic meeting in
codimension 2: codim NL([Pi_1] - [Pi_2]) = 2 binomial(k+1,3) - binomial(k-1,3) - (k-1) = 1, 6, 16, 32, 55 for
k = 2..6 (compare column CS of A2).
Test: the excess calculator on degree data (tau, lambda_0, e_tau, range, codimensions) and the first-order tools at
random points (excess at lambda_0 and elsewhere), for the rows of E4.

### E2. Paper 3, Corollary 4 (one excess direction)
If e_tau = 1 and the range holds: one excess direction for every lambda != 0; the second-order law
(1/2) Hess = ((lambda - lambda_0)/lambda) A(Q); NL(delta_lambda) = V_Z with a double structure for lambda not in
{0, lambda_0} wherever A != 0. Applies to tau = 0 with (k-1)d < 2k+2 and e.g. to two coplanar lines (d >= 5).
Status: PROVED (AI paper). Test: second-order checker on a tau = 0 type (two 3-planes meeting in a point on a cubic
sixfold; two planes meeting in a point on a quartic fourfold) and on coplanar lines: obstruction vanishes at
lambda_0 only, and is proportional to (lambda - lambda_0)/lambda for several lambda.

### E3. Paper 3, Theorem "thm:lin" (two linear subspaces: the complete list at a general point) and its Table
d >= 3, k >= 1, 1 <= c <= k+1, kd - 2k - 2 >= 1; tau = 2c - (c-1)d.
(1) tau < 0 (c >= 4; or c = 3, d >= 4; or c = 2, d >= 5): NL([Pi_1] + lambda [Pi_2]) = V_Z for all lambda != 0, every smooth X.
(2) tau >= 0: NL at lambda_0 is smooth and strictly larger than V_Z, at every smooth X.
(3) tau >= 0, lambda not in {0, lambda_0}, X general: NL = V_Z as schemes unless (d,k,c) is in the list
    L = {(3,3,1), (3,3,2), (3,3,3), (3,4,1), (3,4,2), (3,4,3), (4,2,1), (4,2,2), (5,2,1)} u {(d,1,1): d >= 5}, where
    it is V_Z with a non-reduced structure and e extra tangent directions:

    | (d,k,c) | tau | lambda_0 | e |
    |---|---|---|---|
    | (3,3,1) | 2 | 1 | 2 |
    | (3,3,2) | 1 | -1 | 2 |
    | (3,3,3) | 0 | 1 | 1 |
    | (3,4,1) | 2 | 1 | 2 |
    | (3,4,2) | 1 | -1 | 2 |
    | (3,4,3) | 0 | 1 | 1 |
    | (4,2,1) | 2 | 1 | 2 |
    | (4,2,2) | 0 | -1 | 1 |
    | (5,2,1) | 2 | 1 | 1 |
    | (d,1,1), d >= 5 | 2 | 1 | 1 |

Status: PROVED (AI paper) with the second-order parts resting on computations at instances for some rows.
From night/CHECKS_R2.md, test T3 (COMPUTED, Singular, random points): for lambda in {2, 3, -2, -lambda_0} all rows
give the table's e; at lambda_0 the excess is 3, 2, 1, 6, 3, 1, 3, 1, 3, 1 in the order of the table ((d,1,1): 1 for
d = 5, 6, 7); outside the list, excess 0 for (3,3,4), (3,4,4), (3,4,5), (4,2,3), (5,2,2), (5,2,3), (5,1,2), (6,1,2);
the excluded cases (4,1,2), (3,2,1), (3,2,2) show excess 1 for every lambda.
Test: first-order excess at a random point for each row, at lambda_0 and at two other lambda; excess 0 off the list.
Second-order checker on the rows that are fast enough: excess directions die for lambda != lambda_0.

### E4. Paper 3, Section "Computations", tables tab:tau and tab:types (COMPUTED mod p)
tab:tau, rows "(k,d,c); deg f; deg h; deg p | tau | range | e_tau | excess found":
(1,6,1);(1);(1);(2) | 2 | yes | 2 | 2.   (1,6,1);(1);(1);(3) | 2 | yes | 3 | 3.   (1,5,1);(1);(1);(2) | 2 | yes | 2 | 2.
(1,5,1);(1);(1);(3) | 2 | yes | 2 | 2.   (1,5,1);(1);(1);(1) | 2 | yes | 1 | 1.   (2,3,2);(1,1);(1,1);(1) | 1 | yes | 1 | 1.
(2,3,1);(1);(1);(1,1) | 2 | yes | 1 | 1.   (2,4,3);(1,1,1);(1,2,3);- | 1 | yes | 2 | 2.   (2,4,3);(1,1,2);(1,2,2);- | 1 | yes | 3 | 3.
(2,4,2);(1,1);(1,2);(1) | 1 | yes | 2 | 2.   (2,4,1);(1);(1);(1,1) | 2 | no | 3 | 3 at lambda = 1, 2 at the six others.
(2,4,3);(1,1,1);(1,1,2);- | -1 | - | 0 | 0.
Quadratic map on the excess directions vanishes at lambda_0 only among lambda in {1,-1,2,3,1/2,-2,5/3} (K = 0 in four rows).
tab:types (tau = 0, K != 0; excess 1, lambda_0 = (-1)^(c-1), A != 0): (k,d) = (1,6),(1,7),(1,8): (1,2)+(1,2); (1,2)+(2,2);
(1,1)+(3,3). (2,4), c = 2: (1,1)+(1,1) with p of degree 1, 2, 3. (2,4), c = 3: (1,1,1)+(1,1,3); (1,1,1)+(1,2,2);
(1,1,2)+(1,1,2). (2,5), c = 2: (1,1)+(1,2), p of degree 1, 2. (2,5), c = 3: six types. (3,3): (1,1,1)+(1,1,1) with p
linear; (1,1,1,1)+(1,1,1,2). (4,3): first order only.
Test: excess calculator reproduces tau, range, e_tau for every row of tab:tau from the degrees alone (EXACT,
combinatorial); first-order excess at a random point for the small rows (MOD p); second-order checker on a few.

### E5. LEDGER.md, entry "[REFEREED, night/referee3_report.md]" ("codimension formulas")
The entry reads: "codimension formulas (4 quintic surface; 12, 11 quartic fourfold; 8 cubic sixfold; 22 for (5,2,1))".
It does not say which configurations are meant. My reading, by evaluating codim V_Z: 4 = two coplanar lines on a
quintic surface, (d,k,c) = (5,1,1) (agrees with D1); 8 = (3,3,3); 22 = (5,2,1); for "12, 11" two readings fit:
codim V_Z = 12 for (4,2,2) with 11 the codimension at lambda_0 (the pair (11,12) of A1), or codim V_Z = 12 for
(4,2,2) and codim V_Z = 11 for (4,2,1). Both readings give numbers the calculator must return.
Test: codim V_Z = 4, 12, 11, 8, 22 for (5,1,1), (4,2,2), (4,2,1), (3,3,3), (5,2,1), and 12 - e_tau = 11 for (4,2,2)
(EXACT, Hilbert functions).

### E6. night/CHECKS_R2.md (second round of checks; COMPUTED mod p, plus one exact Lefschetz check)
T2: for A = Q[y_1..y_k]/(y_i^(d-1)), L = sum y_i, the map L^(d-2): A_2 -> A_d has maximal rank for 72 pairs (d,k); kernel
dimensions (d,k): (3,2):1, (3,3):2, (3,4):2, (4,1):1, (4,2):2, (5,2):1, (d,1):1 for d >= 4 (the c = 1 rows of E3).
T3: as quoted in E3. Test: covered by the E3 tests.

### E7. Discovery round: discovery/END_OF_ROUND_REPORT.md; LEDGER_DISCOVERY.md entries [CHECK C12], [CHECK C13], [CHECK C15]
All COMPUTED mod p (Singular, primes 32003, 30011, 1000003) at random instances, by the coordinator with own code.
- C13 (cubic sixfolds F = det A + det B, A, B 3x3 matrices of linear forms in 8 variables, smooth): the threefold
  T = {rows 1,2 of A proportional} n {rows 1,2 of B proportional} has dimension 3, degree 9, lies on X; cubics in
  the ideal of all 2x2 minors of A and B: codimension 8, containing J_3; codim (I_T + J)_3 = 13, codim (I_T + J)_4 = 1,
  codim ((I_T + J) : m)_3 = 8: the Hodge locus of [T] has TANGENT CODIMENSION 8.
- C12 (cubic eightfolds through a Segre fourfold: random cubic in I = (x_9, 2x2 minors of the generic 3x3 matrix in
  x_0..x_8)): A = S/(I + J) has Hilbert function 1, 9, 26, 27, 9, 1, 0; pairing A_3 x A_2 -> A_5 of rank 26:
  tangent codimension 27 for "contains a Segre fourfold", 26 for the Hodge locus of its class.
- C15 (a) sixfolds F = l Q + Pf(M), M a 6x6 skew matrix of linear forms: family tangent space of codimension 7; the
  quintic threefold T5 = {l = 0} n {4x4 Pfaffians of a 5x5 principal block}: dimension 3, degree 5, Hodge locus of
  [T5] of TANGENT CODIMENSION 7. (b), (c) eightfolds F = l Q + det A + det B in P^9: family tangent codimension 26;
  T' = {l = 0} n {rows 1,2 of A proportional} n {rows 1,2 of B proportional}: dimension 4, degree 9, S/(I(T') + J) has
  Hilbert function 1, 9, 29, 26, 9, 1, 0, Hodge locus of [T'] of TANGENT CODIMENSION 26.
So the four numbers named in the task are 8 (C13), 26 (C12 and C15(c)), 27 (C12, "contains the Segre fourfold"),
7 (C15(a)).
Test: the package's first-order tangent codimension of the Hodge locus of the class of an explicit subvariety Z of
X, i.e. (in the form used in C12) the rank of the multiplication pairing
(S/(I(Z)+J))_d x (S/(I(Z)+J))_(sigma-d) -> (S/(I(Z)+J))_sigma, sigma = (k+1)(d-2), valid when that last space is a line;
on freshly generated random instances of the same families. Label MOD p. Expected: 8, 13 and 1 (C13); 27, 26 and the Hilbert function (C12); 7 (C15a);
26 and the Hilbert function (C15c, if fast enough: otherwise tests/slow/).

### E8. T3's exported Fermat certificates (discovery/t3_window/export_c3/, export_x1/)  [EXACT over Q(zeta_6), blind-confirmed by an AI check]
- export_c3: cert_n6_lam-1.txt, cert_n6_lam2.txt, cert_n6_lam5o3.txt (Fermat cubic sixfold, NV = 8, order N = 5) and
  cert_n8_lam-1.txt, cert_n8_lam2.txt, cert_n8_lam5o3.txt (eightfold, NV = 10, N = 4). Claim of each file: the listed
  arc F_0 - (eps T_1 + eps^2 T_2 + ...) is tangent to the Hodge locus of [P1] + lambda [P2] but not to V_Z, all period
  functions vanish to order N - 1 along it, and the coefficient vector c_N is not in the image of the first-order
  map L (a left-kernel vector K with K.L = 0 and K.c_N != 0 is listed). rank L = 7 against 8 for the pair (NV = 8),
  19 against 20 (NV = 10). Conclusion drawn in the session, CONDITIONAL on Griffiths' description of the Hodge
  locus, the period formula for linear cycles and smoothness of V_Z: no component of dimension dim V_Z + 1 of the
  Hodge locus passes through the Fermat point for lambda = -1, 2, 5/3. This CONTRADICTS the dimension claim of
  Movasati's Conjecture 1 (A3) for these coefficients as the session reads it; it is an unreviewed AI result and
  must not be presented as a refutation.
- export_x1 (Fermat cubic eightfold, a second pair "X1" of 4-planes): x1_lam2_obstruction.txt (no arc with the given
  T_1 to order 5; a functional Lambda with Lambda.L = 0 and Lambda.c_5 = 1 + z), x1_lam-1_arc.txt (an arc along which
  all 45 period functions vanish to order 7), six_lam2_arc.txt, six_lam-1_arc.txt. (The export also contained a file
  lform_lam-1.txt with mod p data; it is not shipped in this repository and no test uses it.)
Test: the package's certificate verifier on each exported file: recompute c_n = 0 for n < N, the listed c_N, K.L = 0,
K.c_N as listed and nonzero, L.T_1 = 0, L_P1.T_1 != 0; ranks 7/8 and 19/20. Label EXACT (Q(zeta_6)).
Also a negative control: a corrupted certificate must be rejected.

---------------------------------------------------------------------------------------------------------------

## Which test covers which entry

| entry | status of the reading | tests (tests/validation, tests/slow) | not covered (reasons in tests/README.md) |
|---|---|---|---|
| A1 Movasati arXiv:1602.06607 | READ | 01 (K), 03 and 15 (H at Fermat, n = 4, 6, 8; quartic fourfold), 07 (sextic table, T_(1,1,2)); docs example 2 (one entry for n = 10) | H for n = 10, 12 as full rows; conjectures |
| A2 Movasati arXiv:1902.00831 | READ (two rows of Table 1 not legible) | 01 (dim(S), column L), 03 (codim(V^1), several coefficients), 04 and slow/16 (column CS via the excess at lambda_0, session value) | Theorem 1 (N-th order smoothness), Tables 3, 4, Conjecture 1 |
| A3 Movasati arXiv:2211.11405 | READ | 01 (formula of Section 4), 03 (Proposition 21, column M as first-order number), 06 (Theorem 3, first order) | Conjecture 1 itself, Theorem 8 |
| A4 Movasati, Villaflor Loyola arXiv:1705.00084 | READ | 06, slow/16 (Theorem 2 list: tau < 0, excess 0), 01/02 (codimension formula), 07 (complete intersections) | Theorem 1 (period values), d >= 8 surfaces |
| A5 Movasati's book | NOT VERIFIED (not opened) | none | everything |
| B Kloosterman arXiv:2312.12363 | READ | 02 (Prop. 3.10), 04 and slow/16 (Thm 1.2), 05 (Thm 1.3, Ex. 3.17), 06 (Thm 1.5) | Thm 1.4/5.3, 1.6/3.14, Cor. 6.2, 6.5 as statements on loci |
| C1 Villaflor Loyola arXiv:1812.03964 | READ | 07 (Cor. 3), 06 (Thm 3 at Fermat), 05 (Prop. 7) | Thm 1, 2 constants, Cor. 4, Thm 4 |
| C2 Villaflor Loyola arXiv:2001.01019 | READ | 07 (Example 2.1), 02 and 07 (the number of Thm 1.1) | the "iff" and lower-bound statements |
| D Maclean (article) | NOT VERIFIED in the article; thesis READ; Dan arXiv:1407.8491 READ, SECONDARY | 08 (mod p and exact over QQ) | Theorem 24 (classification) |
| E1, E4 paper 3 Theorem 2, tab:tau | SESSION | 09, 15 | Theorem 1 (residual), W_t |
| E2 paper 3 Corollary 4, tab:types | SESSION | 12, slow/17 | types not listed in the test |
| E3, E6 paper 3 Theorem 9.7, CHECKS_R2 | SESSION | 10, 11 (first order), 12 (second order, k <= 3 and (5,2,1)) | second order for cubic eightfolds |
| E5 ledger "codimension formulas" | SESSION | 01, 02, 08 (4), 10/11 (8, 11, 12, 22 as codim T V_Z at instances) | the reading of "12, 11" is ambiguous (both readings hold) |
| E7 ledger checks C12, C13, C15 | SESSION | 13 | limit statements of C13, C15(d) |
| E8 T3's Fermat certificates | SESSION (EXACT files) | 14 | claim 4 of x1_lam2; sixfold reading; mod-p rank statements |

