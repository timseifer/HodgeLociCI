# Validation suite of HodgeLociCI (tests/)

Written by agent PC (an AI agent), 22 November 2026; not reviewed by a human. Nothing here is, or bears on, a proof
or disproof of the Hodge conjecture.

The suite checks the package against (i) numbers published by Movasati, Kloosterman, Villaflor Loyola and Maclean,
and (ii) the results of the AI research session that the package implements. **The published papers were read by
machine only** (through a web-fetch tool; see the first section of `SOURCES.md`), and the session's results are
AI-produced and unreviewed. A passing test therefore says: "the package reproduces the number as the machine read
it", nothing more.

## Running

    tests/run_all.sh            # fast suite: 15 tests, about 4.5 minutes on 2 cores
    tests/run_all.sh --slow     # also tests/slow/ (2 more tests, about 3 minutes more)
    tests/run_all.sh 03         # only the tests whose name contains "03" (exit status 2 if no test matches)
    tests/run_all.sh --slow slow   # only the two slow tests

Requirements: Macaulay2 (developed with 1.22) on the PATH (or `M2=/path/to/M2`); bash, awk, grep, diff, timeout.
Nothing has to be installed: every test loads the package from `../M2/HodgeLociCI.m2`.
The script prints a PASS/FAIL table and exits with status 0 if and only if every test passes. A test passes when
all its checks hold AND its `RESULT`/`INFO` lines are identical to `tests/expected/NAME.out` (all tests use fixed
random seeds, so the outputs are deterministic). Raw outputs go to `tests/out/` (not part of the repository).
A second, smaller copy of the suite (8 blocks, PC-V1 to PC-V8, each under 3 s) is in
`M2/HodgeLociCI/ValidationTests.m2` and runs with `check "HodgeLociCI"`.

## Layout

    SOURCES.md              every source: reference, statement, numbers, how it was read, what a test computes
    validation/common.m2    shared helpers (expect / report / finish; random linear pairs; the Fermat hypersurface
                            written as a CyclePair modulo p, independently of the Fermat module)
    validation/NN_*.m2      the tests; each starts with: source, statement, what is computed, label, expected value
    slow/NN_*.m2            tests that take more than about a minute
    expected/NN_*.out       expected RESULT / INFO lines
    data/fermat/            the session's certificate files, with their original READMEs and SHA256SUMS
    run_all.sh              the runner

Each test prints lines `RESULT <what> = <value>   ok` (or `MISMATCH: expected ...`), `INFO` lines for values that
have no published or recorded expected value, `DISAGREE` lines for recorded disagreements with a published number
(see below), and ends with `ALL n CHECKS PASSED`.

## The tests

Labels: EXACT = integer arithmetic, QQ or a cyclotomic field; MOD p = one instance modulo a prime (evidence, not a
proof). "Session" = result of the AI research session (unreviewed). Times: wall clock of the last run (the table at the
end of this file) on the development machine (2 cores shared with other jobs), in seconds.

| test | source (entry of SOURCES.md) | what is reproduced | label | checks | time |
|---|---|---|---|---|---|
| 01_movasati_K_table | Movasati arXiv:1602.06607 Table 1 (K) and tuples; arXiv:1902.00831 Tables 1, 2, 5; arXiv:2211.11405 Section 4 (A1-A3) | codim of the locus of hypersurfaces containing two linear cycles: cubics n = 4..12 (incl. 8 and 20), quartic/quintic/sextic/septic tuples; columns dim(T), L, CS, M and the Hodge numbers of Table 5 | EXACT | 24, and 1 recorded disagreement | 1 |
| 02_kloosterman_prop310 | Kloosterman arXiv:2312.12363 Prop. 3.10; Villaflor arXiv:2001.01019 Thm 1.1 number (B, C2) | the codimension formula on 135 triples (d,k,c) | EXACT | 4 | 1 |
| 03_movasati_H_fermat_exact | Movasati arXiv:1602.06607 Table 1 (H); arXiv:1902.00831 Tables 1, 2 (codim V^1); arXiv:2211.11405 Prop. 21 (A1-A3) | tangent codimension of the Hodge locus at the Fermat cubic, n = 4, 6, 8, all m, several coefficients: (7,8), (19,20), (6,8), (16,19), ...; Fermat quartic fourfold (11,12), (12,12) | EXACT over Q(zeta_6), Q(zeta_8) | 17 | 27 |
| 04_kloosterman_thm12_no_excess | Kloosterman Thm 1.2 (B) | no first-order excess outside S at a random cubic tenfold (3,5,3) and quartic sixfold (4,3,2); excess at the exceptional coefficient | MOD p | 9 | 45 |
| 05_kloosterman_thm13_excess | Kloosterman Thm 1.3, Ex. 3.17; Villaflor arXiv:1812.03964 Prop. 7 (B, C1) | excess >= 1 for 8 triples, 4 coefficients, at a random point and at the Fermat point | MOD p | 16 | 13 |
| 06_no_excess_tau_negative | Movasati-Villaflor arXiv:1705.00084 Thm 2; Villaflor arXiv:1812.03964 Thm 3; Kloosterman Thm 1.5 (A4, C1, B) | tau < 0 and excess 0: 11 linear triples (random point; 5 also at Fermat), 5 non-linear types; two strategies agree on the small cases | MOD p | 21 | 43 |
| 07_villaflor_single_cycle | Villaflor arXiv:1812.03964 Cor. 3; arXiv:2001.01019 Ex. 2.1, Thm 1.1; Movasati arXiv:1602.06607 Section 4 table, Section 6 (C1, C2, A1) | tangent codimension of the Hodge locus of one complete intersection: published numbers (sextic fourfold table, T_(1,1,2) = 8, linear cycles) and three independent computations on 7 types | EXACT / MOD p | 10 | 3 |
| 08_maclean_coplanar_lines | Maclean (thesis Thm 24, Prop. 9; Dan arXiv:1407.8491, secondary) (D) | coplanar lines on a quintic: codim 4, tangent codim 3, excess direction dies for a != b and survives for a = b | MOD p and EXACT over QQ | 11 | 2 |
| 09_session_theorem2_table | Session: paper 3 Thm 2, table tab:tau (E1, E4) | 12 degree types: tau, range, e_tau (EXACT); excess at lambda_0 and elsewhere, transversality iff range, Theorem 2 = direct computation (MOD p); dichotomy on a grid | EXACT / MOD p | 60 | 3 |
| 10_session_linear_list | Session: paper 3 Thm 9.7 and Table 1; CHECKS_R2 T3 (E3, E6) | first-order excess for the rows with k <= 3 and surfaces; cases off the list; excluded cases | MOD p | 23 | 3 |
| 11_session_linear_list_large | same, cubic eightfolds and quintic fourfolds (E3, E6) | rows (3,4,1), (3,4,2), (3,4,3), (5,2,1) and four triples off the list | MOD p | 8 | 31 |
| 12_session_second_order | Session: paper 3 Cor. 4, Thm 9.7(3), tab:tau, tab:types (E2-E4) | second-order verdicts: ALL DIE away from lambda_0 / ALL SURVIVE at lambda_0 for 8 linear rows and 7 types with tau = 0; the factor (lambda - lambda_0)/lambda; K = 0 rows | MOD p | 38 | 60 |
| 13_discovery_explicit_families | Session: ledger checks C12, C13, C15 (E7) | tangent codimensions 8 (two determinants), 7 (Pfaffian), 27 / 26 (Segre fourfold), 26 (l Q + two determinants), with Hilbert functions | MOD p | 14 | 5 |
| 14_fermat_certificates | Session: T3's exported certificates (E8) | 6 certificates (sixfold, eightfold; lambda = -1, 2, 5/3), 2 files at the pair X1, 2 order-9 arcs: every checkable claim; 2 corrupted files rejected | EXACT over Q(zeta_6) | 26 | 18 |
| 15_fermat_two_implementations | Movasati arXiv:1602.06607 Table 1; session: paper 3 Thm 2(5) (A1, E1) | (H,K) at the Fermat point by three routes that share no code (Fermat module exact; Jacobian-ring tool mod p; Hilbert functions mod p), 10 triples | EXACT / MOD p | 20 | 5 |
| slow/16_slow_large_cases | Movasati-Villaflor Thm 2 (sextic fourfolds, cubic tenfolds); Kloosterman Thm 1.2 for (3,5,2) (A4, B) | excess 0 for five more triples; (3,5,2): 0 at six coefficients, 4 at lambda = -1 | MOD p | 7 | 158 |
| slow/17_slow_second_order_quintic_fourfold | Session: paper 3 tab:types, (k,d) = (2,5) (E2, E4) | tau = 0 type on a quintic fourfold: excess 1, ALL DIE away from lambda_0 = -1 | MOD p | 3 | 34 |

Total: 17 tests, 311 checks, 1 recorded disagreement (test 01). Result of the last run: see the end of this file.

## Disagreements between published numbers and the package

**One disagreement was found. Neither side was adjusted; it is printed as a `DISAGREE` line by test 01 in every run
and counted in the runner's "disagree" column.**

- Where: Table 5 of Movasati, arXiv:1902.00831 (= Table 1 of arXiv:2211.11405), last column, Hodge numbers of the
  cubic hypersurface of dimension 12. Published, as read by machine (twice in each paper):
  `0, 0, 0, 0, 14, 1001, 3432, 1001, 14, 0, 0, 0, 0`.
- Package: `primitiveHodgeNumbers(12, 3)` has middle entry 3432, so the Hodge number h^(6,6), which includes the class
  of a linear section, is 3433.
- Context: in the rows n = 4, 6, 8, 10 the same table prints the middle number with the +1 (21, 71, 253, 925), and
  the package reproduces those. My own arithmetic, not taken from a source: the middle Betti number of a smooth
  cubic 12-fold is ((-2)^14 - 1)/3 + 2 = 5463, which is the sum of the package's row; the published row sums to 5462.
- Assessment (mine, unreviewed): a slip in a side column of the table, or of the machine reading. No codimension in
  any table depends on it.

No other disagreement in 311 checks. Three checks failed on their first run; in each case the mistake was in the
test input written by agent PC, not in the package or in a source, and the input (not the expected value) was
corrected: a degree type listed under "tau < 0" that has tau = 0; a grid that ignored the hypothesis
kd - 2k - 2 >= 1 of Theorem 9.7; and a row of tab:types read with the wrong degree d.

One point of wording (not a disagreement of numbers): the pairs "8 -> 7" and "20 -> 19", as the instructions for
this suite called them (those instructions are not in this repository), are, in the sources, the codimension K of
the locus of cubics containing the two linear spaces and the codimension H of the ZARISKI TANGENT SPACE of the Hodge
locus AT THE FERMAT POINT, for every nonzero coefficient; they are not specifically attached to the difference of
the two classes, and that the Hodge locus itself has codimension 7, resp. 19, is the content of Movasati's
Conjecture 1, not a published theorem.

## Not covered, and why

| item (SOURCES.md) | reason |
|---|---|
| Movasati's Conjecture 1 itself (A3); Kloosterman's Conjecture 1.1 | a statement about the dimension of the Hodge locus, not a first-order number. The package's tools give first- and second-order information at instances; the session's certificates (E8, test 14) are verified as files, their consequence is conditional and unreviewed |
| arXiv:1902.00831 Theorem 1, Tables 1, 2 rows N = 2, 3, 4 and "N = 14, 6, 4, 3" (smoothness of the N-th order Hodge locus); arXiv:2211.11405 Theorem 8 (A2, A3) | "N-th order Hodge locus is smooth" is a statement about a truncated scheme in Movasati's family S; the package has no function for it. Table 1's last two rows were also not legible to the reading tool |
| H column of Movasati's table for n = 10, 12 (A1) | n = 10: one entry (38, 39) is reproduced in docs example 2 (exact, 5 s) but the full rows are not in the suite; n = 12 was not tried (size) |
| Tables 3, 4 of arXiv:1902.00831 (monomial bases of S) (A2) | a choice of basis, not an invariant |
| Kloosterman Thm 1.4 / 5.3 (reducibility at split X, k >= 5); "non-reduced or conjecture holds" in Thm 1.3; Cor. 6.2, 6.5 as statements about loci (B) | statements about the reduced locus / components, not computable at first or second order at one point. The first-order shadow (excess > 0 at lambda_0) is in tests 04, 05 |
| Kloosterman Thm 1.6 / 3.14, Cor. 3.15 (kernel criterion) (B) | no function of the package computes that multiplication map; its conclusion is tested (tests 04, 06) |
| Villaflor arXiv:1812.03964 Thm 1, 2 (period formula with its constant), Cor. 4 (intersection numbers) (C1) | the package uses the formula up to a nonzero constant and exports no intersection-number function |
| Villaflor arXiv:2001.01019 Thm 1.1, 1.2, 1.3 as "if and only if" / lower-bound statements over all Hodge cycles (C2) | not computable by examples; only the number binomial(n/2+d,d) - (n/2+1)^2 is tested (tests 02, 07) |
| Movasati-Villaflor Thm 2 for (2,d,-1), 8 <= d <= 14 (A4) | same computation as d = 5, 6, 7 (test 06); omitted for time only |
| Maclean Theorem 24 (every non-reduced component for quintics is of this form) (D) | a classification; only the converse construction (Proposition 9) is tested, at instances |
| Session: paper 3 Theorem 1 (liaison, residual R), family W_t, Theorem 9.4(0) (E) | not implemented in the package (README.md, section "Limitations") |
| Session: second order for cubic eightfolds, rows (3,4,c) of Table 1 (E3) | not run: the second-order computation in 10 variables was not attempted within the time budget |
| Session: claim 4 of x1_lam2_obstruction.txt; the sixfold reading of six_*_arc.txt; the rank statements of README_export_x1_round4.txt; "V counted twice plus one component" on the sixfold (E8, and the session's working report, which is not in this repository) | not checkable from the files / computed modulo primes with other software; not implemented |
| Session: C13 limit statements (flat limit T_0, flag-threefold cubics), C15(d) (E7) | need the specific degenerate cubics of the session; only the generic-member numbers are tested (test 13) |
| tangentExcess, Strategy "Jacobian", for (d,k,c) = (3,5,3) | did not finish in 15 minutes; tests 04, 11, slow/16 use Strategy "Residue" there (the strategies agree on all smaller cases, tests 06, 15) |

## Result of the last run

Release run after the fixes of the blind install check: 22 November 2026 (UTC), Macaulay2 1.22, development machine
(2 cores shared with other jobs). Commands: `tests/run_all.sh`, then `tests/run_all.sh --slow slow`.

    test                                         status    checks  disagree  seconds
    -------------------------------------------- -------- ------- --------- --------
    01_movasati_K_table                          PASS          24         1      1.0
    02_kloosterman_prop310                       PASS           4         0      1.0
    03_movasati_H_fermat_exact                   PASS          17         0     26.7
    04_kloosterman_thm12_no_excess               PASS           9         0     44.5
    05_kloosterman_thm13_excess                  PASS          16         0     13.1
    06_no_excess_tau_negative                    PASS          21         0     43.1
    07_villaflor_single_cycle                    PASS          10         0      3.1
    08_maclean_coplanar_lines                    PASS          11         0      1.8
    09_session_theorem2_table                    PASS          60         0      3.3
    10_session_linear_list                       PASS          23         0      3.2
    11_session_linear_list_large                 PASS           8         0     31.0
    12_session_second_order                      PASS          38         0     59.9
    13_discovery_explicit_families               PASS          14         0      5.0
    14_fermat_certificates                       PASS          26         0     17.5
    15_fermat_two_implementations                PASS          20         0      4.6
    16_slow_large_cases                          PASS           7         0    158.1
    17_slow_second_order_quintic_fourfold        PASS           3         0     33.9

    17 of 17 tests passed; 311 checks; 1 recorded disagreement (test 01, see above).
    Fast suite (01-15): 259 s in total, slowest test 60 s. Slow tests (16, 17): 192 s.
