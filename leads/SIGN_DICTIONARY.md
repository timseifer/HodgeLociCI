# Sign dictionary: lambda, (r, r-check), lambda_0, "+-1", "P1 -/+ P2"

27 Nov 2026, Claude Opus 5.5 for Timothy Seifert (plan item A2). AI-written, unreviewed. Intended as the
"Conventions" section of the rStation draft (the draft itself is not in this repository; copy from here).

## 1. The one convention used in this repository

- X = {F = 0} smooth of degree d in P^(2k+1), dimension n = 2k. Two k-planes Pi_1, Pi_2 meeting in P^m,
  m = k - c; **c = k - m** is the number of non-shared linear equations.
- The class is **delta_lambda = [Pi_1] + lambda [Pi_2]** (fundamental classes; the package normalises the period
  polynomial of each plane so that an automorphism carrying one plane to the other carries class to class, so
  there is no hidden sign: `fermatPeriodPolynomial(S, L1) + lambda * fermatPeriodPolynomial(S, L2)`).
- **lambda_0 = (-1)^(c-1)** is the special coefficient of the general first-order rule (paper 3, Thm 2;
  D-FIRST-ORDER-RULE; tau = 2c - (c-1)d >= 0 needed). lambda_0 = +1 for odd c, -1 for even c.
- "P1 - P2" in a title means lambda = -1, "P1 + P2" means lambda = +1. Nothing else.

## 2. Translation to the literature (statements as machine-read earlier; see tests/SOURCES.md)

| source | their notation | ours |
| --- | --- | --- |
| Kloosterman, arXiv:2312.12363 | NL([Pi_1] + lambda [Pi_2]); k, c as here | identical |
| Movasati, arXiv:1602.06607, 1902.00831, 2211.11405 | Z = r P + r-check P-check; P^(n/2) meeting in P^m | lambda = r-check / r; c = n/2 - m |
| Movasati-Villaflor Loyola, Villaflor Loyola | as Movasati | as above |
| paper 3 (AI, unreviewed) | delta_lambda, lambda_0 = (-1)^(c-1) | identical |

Consequences, per case (cubics d = 3 unless stated):

| geometry | c | tau | lambda_0 | Movasati's statement (machine-read) | our special value(s) |
| --- | --- | --- | --- | --- | --- |
| meeting in a hyperplane of each, m = n/2 - 1 | 1 | 2 | +1 | Conj. 4 / Thm 5 (2211.11405): (r, r-check) = (1, 1) special | +1 = lambda_0 |
| m = n/2 - 2 | 2 | 1 | -1 | Conj. 6 / 7: (1, -1) special (cubic scroll) | -1 = lambda_0 |
| m = n/2 - 3 (sixfold: a point; eightfold: a line; tenfold: P^2) | 3 | 0 | +1 | Prop. 21 / Thm 8: smooth N-th order loci for all (r, r-check) in a range; the conjecture these entries are "at odds with" | lambda_0 = +1 (first-order excess at every X); **-1 is NOT lambda_0** but is where the second component (two determinants) is found |
| quartics, (d, c) = (4, 2) | 2 | 0 | -1 | Kloosterman: special coefficient -1 | -1 = lambda_0 |
| (d, c) = (3, 3) | 3 | 0 | +1 | Kloosterman: special coefficient +1 | +1 = lambda_0 |

So the two "special" signs in this project have different origins and must not be merged:
- **lambda_0** (first order, every X with tau >= 0): +1 for c = 3, -1 for c = 2.
- **-1 for c = 3** (sixfolds with planes in a point, eightfolds with planes in a line, tenfolds with planes in a
  P^2): the coefficient of Movasati's class [P1] - [P2] at his point; the two-determinant component W_(-1),
  the cone-type families, and the separation at order 6 (D-MOVASATI-POINT-EXACT-SEPARATION) are about this one.
  The K3 / abelian explanation (headline card 2) is the explanation offered for why +1 and -1 are the values
  that occur.

## 3. Numerical check at one instance each (MOD 32003, random instances; `leads/sign_check.m2`)

Prediction written before the run: excess at lambda = lambda_0 only, among {1, -1, 2}, for (d,k,c) = (3,3,3) and (4,3,2).
Results (MOD 32003, one random instance each, `leads/sign_check.m2`, `leads/sign_check2.m2`):
- (4,3,2), lambda_0 = -1: first-order excess at lambda = 1, -1, 2 is 0, 1, 0. As predicted: the special sign is -1.
- (3,3,3), lambda_0 = +1: first-order excess 1, 1, 1 -- my prediction was WRONG at first order: (3,3,3) is in the
  list of cases with excess for every lambda (Kloosterman, Thm 1.3 as machine-read; D-LINEAR-LIST-FIRST-ORDER). The
  sign is decided at second order: `secondOrderObstruction` gives ALL SURVIVE at lambda = 1 and ALL DIE at -1 and 2.
So at a GENERAL cubic sixfold with two 3-planes in a point the special sign is +1 (= lambda_0), and -1 behaves like
any other coefficient; -1 is special only at special points (Movasati's point, D on sixfolds, X1 on eightfolds),
where the two-determinant / cone-type families pass. This is the distinction of section 2, now checked once each.

## 4. Entries that used the conventions loosely (flagged, not changed: the registry text is the record)

- D-TENFOLD-... titles and the two-determinant headline write "Movasati's class [P1] - [P2]"; correct (lambda = -1,
  c = 3), but the reader must not read -1 as lambda_0: D-TENFOLD-LAMBDA0 (registry line ~273) already says so.
- tests/SOURCES.md, "Column CS = K - e_tau with c = 2 (the value at lambda_0 = -1 ...)": consistent.
- No entry found that writes lambda for r / r-check (inverted ratio); search: grep "r-check" in the registry and
  SOURCES.md. Inverting would not matter for lambda = +-1 anyway, but would for lambda = 2 vs 1/2 (both are
  treated as "other" coefficients in every entry, so no conclusion depends on it).

## 5. Citation check (done 27 Nov ~16:00 UTC, after the owner approved web access)

The citations of [Mo3] (Prop. 5.6 in §5.10, attributed to Villaflor; Conj. 5.1 for n = 6, 8; §5.2, §5.7, §5.9) and of
[Kl1] (Thms 1.2, 1.3, Prop. 6.4, Cor. 6.2, Cor. 6.5) were checked against the HTML versions: all CONSISTENT, nothing to
correct (machine-read through a fetch tool; table in leads/LIT_READ_27NOV.md, section 1). The statements of section 2
above were not re-read line by line.
