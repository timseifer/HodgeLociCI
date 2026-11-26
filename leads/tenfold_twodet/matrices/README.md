# The matrices along T2's sixfold arc (O-RECOVER-MATRICES-AND-LIMIT-OF-T): first batch, 26 Nov 2026

AI-written (Claude Fable 5.2 for Timothy Seifert), unreviewed. Read `PREREG_matrices.md` first: it has the
predictions as written before each step, three changes of method, one withdrawn statement, and the outcomes.
Summary in `leads/TENFOLD_TWODET_LEAD.md`, section 8. Registry: D-SIXFOLD-ARC-ORDER19,
D-ARC-SPLITTING-NUMERICAL, N-MATRIX-RECOVERY-FIRST-ATTEMPTS.

| file | what | label |
| --- | --- | --- |
| `mx3_extend_arc.m2` | the arc with unknown coefficients from T_8 on; solves the period equations | EXACT |
| `arc_true_order19.txt` | T_1..T_19 of the arc (T_1..T_7 from the certificate `six_lam-1_arc.txt`) | EXACT |
| `mx3b_verify_arc.m2` | the 8 x 19 expansion along that arc is zero; T_8, T_9 differ from the certificate's | EXACT |
| `mx0_export_periods.m2` | Taylor coefficients of the periods of the 330 quartic monomials | EXACT |
| `periods_deg4_order19.txt` | its output for the extended arc, orders 0..19 | EXACT |
| `periods_deg4.txt` | the same for the certificate arc, orders 0..9 (good modulo eps^8 only) | EXACT |
| `mx4_pipeline.py` | catalecticant, the 3-dimensional space of cubics, the two summands, their vector fields, a matrix | NUMERICAL |
| `logs/mx4_eps*.log`, `results/mx4_eps*.json` | runs at eps = 1/16, 1/40, 1/64, 1/100, 1/800; the summands and the matrix A (60 digits) | NUMERICAL |
| `mx1_solve.py`, `mx_common.py`, `mx2_split.py` | the first route (random-start Levenberg-Marquardt; splitting from order 9): did not work | NUMERICAL |

Reproduce (repository root; Macaulay2 1.22, Python 3 with mpmath, sympy, python-flint):

    M2 --script leads/tenfold_twodet/matrices/mx3b_verify_arc.m2                      (2.5 minutes)
    python3 leads/tenfold_twodet/matrices/mx4_pipeline.py 1/100 leads/tenfold_twodet/matrices/periods_deg4_order19.txt leads/tenfold_twodet/matrices/arc_true_order19.txt 19 /tmp/out.json 90
                                                                                        (about 6 minutes; 1/800 with 170 digits: about 10)

To regenerate the data: `mx3_extend_arc.m2 13 FILE`, then `19 FILE` (2 minutes), and
`mx0_export_periods.m2 OUT FILE 19` (6 minutes).

Independent check: `leads/tenfold_twodet/blind_check12/` (brief, report, the checker's own scripts and outputs).
It confirmed the numbers and corrected three statements; the corrections are worked into the notes.

NUMERICAL means multiprecision floating point at fixed values of eps on one arc: evidence, never a proof.
