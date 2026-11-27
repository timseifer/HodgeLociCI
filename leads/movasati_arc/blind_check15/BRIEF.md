# Blind check 15: does the lambda = 2 "aligned pocket" die at order 7?

Independent checker. Setting and tools: exactly as in blind check 14 (report: /home/claude/hodgelocici/leads/
movasati_arc/blind_check14/REPORT.md; its full-space code is copied here in bc14_own/: fs.py, run_fs.py,
run_fs2.py, own.py). Do not read leads/movasati_arc/ma4_exact.m2 or logs/ma4_*order8.log before your own result.
Work only in /home/claude/blind_check15; write nothing in the repository. Two cores; runs under ~9 minutes each,
about 30 minutes in total. Never call anything a proof or disproof of the Hodge conjecture; never use the word
"counterexample"; label EXACT / MOD p / ARG / OPEN. Return the report as your final answer (summary <= 200 words).

Claim C1 (MOD p). Blind check 14 built, for lambda = 2 on the aligned nets s and F1, F2 (T_1 = y_0(lambda = 2) +
x_7 N(A) + x_9 N(B), y_0 the x_0..x_5 part of leads/movasati_arc/arcs/exact_g_lam2_order5.txt), jets passing
order 6. My claim: no such jet passes order 7: with these T_1, no choice of T_2, ..., T_7 among the squarefree
cubics satisfies orders 2..7 (I found this only in a slice of 19 monomials + 7 net directions, at p = 32029 and
31981). Test in the full space at one prime at least (extend the bc14 reduction by one order), for net s, and for
F1, F2 if it fits. As a control, the same test for lambda = -1 on net g or s should find a jet through order 7.
C2. Anything overstated.
