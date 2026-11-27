# Blind check 14: exact (characteristic 0) arcs at the eightfold Movasati point

Independent checker. Do NOT read `leads/movasati_arc/ma4_exact.m2`, `ma5_verify_exact.m2`, `PREREG_arc.md`
(sections after "Step M3") or the logs `leads/movasati_arc/logs/ma4_*`, `ma5_*` before you have your own results.
You may read the data files below, the package `M2/HodgeLociCI` (as a black box), and the code of the previous
checker, copied here: `lib13.py`, `c3_lib.py` (python-flint, MOD p; its report: leads/movasati_arc/blind_check13/
REPORT.md, which explains the setting, the nets and its full-space method). Repository /home/claude/hodgelocici;
work only in /home/claude/blind_check14; write nothing in the repository. Two cores; keep runs under ~9 minutes
(`timeout`), about 35 minutes in total; if something does not fit, do less and say so. Never call anything a proof
or disproof of the Hodge conjecture; never use the word "counterexample"; label EXACT / MOD p / ARG / OPEN.
Return the full report as your final answer (summary of at most 250 words first).

Setting: as in blind check 13 (Fermat cubic eightfold, Movasati's pair, class [P1] + lambda [P2]). Exact means over
QQ(z), z^2 = z - 1, z = fermatRoot(fermatRing(3, 8)). Files in `leads/movasati_arc/arcs/` (line 1 comment, line 2
indices, line 3 a matrix, then T_1, T_2, ... one per line, polynomials in x_0..x_9 with coefficients in QQ(z)):
- `exact_s_lam-1_order9.txt`: lambda = -1, net s: A = E01 + E10, B = E01 - E10 (A with x_7, B with x_9 in the
  notation of blind check 13), 9 terms.
- `exact_g_lam-1_order7.txt`: lambda = -1, net g: A = G F1 H, B = G F2 H with G = [[1,1,0],[0,1,1],[1,0,2]],
  H = [[2,0,1],[1,1,0],[0,1,1]], F1, F2 the 3 x 3 matrices with top-left blocks [[1,2],[0,1]] and [[1,0],[1,1]]
  and zeros elsewhere. 7 terms.
- `exact_g_lam2_order5.txt`: lambda = 2, the same net g (its own y_0), 5 terms.

Claims:
C1 (EXACT). The 45 Hodge-locus equations of [P1] - [P2] vanish along `exact_s_lam-1_order9.txt` to order 9 and
 along `exact_g_lam-1_order7.txt` to order 7; for [P1] + [P2] both fail at order 1. Check exactly, with the package
 (fermatVerifyArc / fermatExpansion) and, if it fits, with exact code of your own (python-flint fmpq_mpoly over
 QQ(z), or a MOD p reduction of the files at two primes as a lower-cost substitute: say which).
C2 (EXACT). Along `exact_g_lam2_order5.txt` the equations of [P1] + 2 [P2] vanish to order 5, and with this T_1 no
 choice of T_2..T_6 passes order 6. Check the first exactly. For the second, at least: reduce T_1 modulo two primes
 (z -> fermatRoot of fermatRing(3, 8, p)) and repeat the full-space test of blind check 13; an exact version if it
 fits. Say plainly which you did.
C3 (MOD p). With a T_1 whose net has its kernel and cokernel along coordinate vectors (for example net s, or the
 net F1, F2 itself), lambda = 2 is NOT obstructed at order 6 (some T_2..T_6 exist), while for net g it is. Test
 at one prime with your full-space method; use the first-order term T_1 of the files where possible (for net s
 with lambda = 2 there is no file: build T_1 = y_0 + net as in blind check 13, with y_0 the excess direction for
 lambda = 2, and say how you chose y_0).
C4. Anything overstated, and what the data are equally consistent with.
