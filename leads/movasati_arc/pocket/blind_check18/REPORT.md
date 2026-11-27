# Blind check 18 (linear-cycle test of the pocket)

A separate agent wrote check.py without seeing lc1_linear_cycles.py. Its own report file was blocked, so this
summary was written by the main session from the agent's run.log (both files are in this folder, unedited) and its
final message.

Verdict: CONFIRMED at p = 31981 and p = 32029. 0 of 229635 linear P^4's persist to first order along T_1.
- Method A: substitution; I_L + J reduces to (y_1^2, ..., y_5^2) in 5 variables.
- Method B: the rank of (I_L + J)_3 over GF(p), which is 210 (codimension 10). It was run on P1, P2 and 150 random L.
- The two methods never disagreed.
- Controls: P1 and P2 do not persist. A product l1 l2 l3 persists on both, and on 32805 L in all, which matches a
  hand count. A random T in I_L0 picks up exactly L0.
