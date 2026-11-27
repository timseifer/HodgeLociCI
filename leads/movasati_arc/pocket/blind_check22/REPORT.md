# Blind check 22: jet9_31981.txt, Hodge locus of [P1] + 2[P2]

My scripts: check.py and ctrl_a.py. They import the Ctx/Pspace/periods definitions from blind_check14/own/own.py. The full output is in run.log.
p = 31981, z = 12637. P = P_{P1} + 2 P_{P2}. E_n is built recursively up to n = 9; E_10 is never formed. E_9 has 6,127,119 terms.

- T_1 is equal, as a polynomial, to line 1 of arcs/jet8_31981_s_lam2.txt: True.
- With lambda = 2, c_n[Q] = 0 for all 45 Q and every n = 1..9.
- Control (b), lambda = -1: the same jet already fails at n = 1 (4 of 45 nonzero). The count reaches 45/45 by n = 7.
- Control (a), perturbing a coefficient of T_5:
  - The first try changed x0x1x2 (12397 -> 12398) and c_5 did not change. That monomial lies in the kernel of the period map.
  - The second try changed x0x2x4 (21098 -> 21099), a monomial with a nonzero period image (80 of the 120 in T_5 have one). c_1..c_4 stay 0, c_5 has 4/45 nonzero and c_6 has 40/45.

Verdict: CONFIRMED.
