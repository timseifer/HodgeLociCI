# Worked example 1: the excess calculator on Movasati's cubic cases, and a case with shared equations of higher degree

> Status. This example and the package were written by AI agents and have not been reviewed by a human. The
> theorems of "paper 3" quoted in the output come from an AI-written manuscript that no human has refereed.
> Nothing here is, or bears on, a proof or disproof of the Hodge conjecture. The session below is a real captured
> Macaulay2 1.22 session (input `docs/sessions/01_excess_calculator.m2`, output `docs/sessions/01_excess_calculator.out`, pasted unchanged).

## What is computed

Let X = {F = 0} be a smooth hypersurface of degree d in P^(2k+1), and let Y1 = V(f, p), Y2 = V(h, p) be two
complete-intersection cycles of dimension k on X: c "own" equations f, resp. h, and k + 1 - c shared equations p, so
that Y1 and Y2 meet in dimension k - c. Write V_Z for the locus of hypersurfaces containing deformations of both
cycles, and NL(delta_lambda) for the Hodge locus of the class delta_lambda = [Y1] + lambda [Y2]. Always
V_Z is contained in NL(delta_lambda); the *excess* of lambda is dim T NL(delta_lambda) - dim T V_Z, a first-order
(Zariski tangent space) quantity.

`excessFromDegrees(d, deg f, deg h, deg p)` returns, from the degrees alone: the level
tau = sum(deg f_i + deg h_i) - (c-1)d, the special coefficient lambda0 = (-1)^(c-1), whether "the range"
(k-1)d + tau < 2k+2 holds, e_tau, the codimensions of V_1, V_2, V_Z (Hilbert functions of complete intersections), the
excess at lambda0 and, where the degrees determine it, at the other coefficients. `excessFromData` does the same
from explicit forms (f, h, p, M, s) with F = f^T M h + sum p_l s_l; `verifyExcess` compares with a direct
computation in the Jacobian ring; `fermatTangentData` computes the same first-order numbers at the Fermat point over
a cyclotomic field.

## Session

{{SESSION}}

## Reading the output

| quantity | cubic sixfold, 3-planes meeting in a point | cubic eightfold, 4-planes meeting in a line | label |
|---|---|---|---|
| codim V_Z (`codimVZ`) | 8 | 20 | EXACT (integer arithmetic on the degrees) |
| excess, every lambda != 0 | 1 | 1 | PROVED in paper 3, Theorem 2(2) (AI-written, unreviewed); checked MOD p at one random sixfold (`verifyExcess`) |
| tangent codimension of the Hodge locus at the Fermat point (`hodgeCodimension`) | 7 | 19 | EXACT over Q(zeta_6) |

- The pairs (7, 8) and (19, 20) are the entries (H, K) of Table 1 of H. Movasati, "Why should one compute periods of
  algebraic cycles?" (arXiv:1602.06607) for n = 6, m = 0 and n = 8, m = 1, and the rows dim(S), codim(V^1) of Table 2
  of his "Hodge cycles for cubic hypersurfaces" (arXiv:1902.00831). Those papers were read by machine only; see
  `tests/SOURCES.md`, entries A1 and A2, and validation tests 01, 03, 15.
- These are FIRST-ORDER numbers. `codimNLAtLambda0 = 7` (resp. 19) is, by Theorem 2(4) of paper 3, the codimension of
  the Hodge locus itself at the coefficient lambda0 = +1 (the sum of the two classes). For the other coefficients
  the tangent space is equally large, but whether the locus is larger than V_Z is a second-order question: see
  worked example 3. The package does not decide Movasati's Conjecture 1 (arXiv:2211.11405); what the session's
  unreviewed work says about it is recorded in `tests/SOURCES.md`, entry E8.
- Shared equations of higher degree (step 5): two plane conics Y1 = V(f, p), Y2 = V(h, p) on the same quadric p = 0,
  lying on a sextic surface. Here tau = 2, e_tau = 2: codim V_Z = 10 and the Hodge locus of [Y1] + [Y2] has
  codimension 8; in the range the excess is 2 for every coefficient, and the direct computation agrees (MOD p).
- Step 6 shows a mixed type (a plane and a quadric surface on a quartic fourfold): lambda0 = -1 because c = 2.

Regenerate: `cd docs/sessions && M2 --silent --no-readline --print-width 118 < 01_excess_calculator.m2 > 01_excess_calculator.out`, then
`python3 docs/build_docs.py` (or `python3 docs/build_docs.py --run` for all sessions at once).
