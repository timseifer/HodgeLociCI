# Blind check 15 — report (saved by the main session from the checker's hand-back; summary and table verbatim)

Full-space reduction of blind check 14 extended by one order (fs7.py; T_2..T_7 over all squarefree cubics); the
reduction matches the direct expansion at a random dense point for orders 2..7 in every case.

- C1, net s, lambda = 2: REFUTED (MOD p, at 32029 and 31981). At each prime an explicit jet T_1..T_7 with this T_1,
  checked directly from the definition: all 7 x 45 coefficients zero. The slice result does not carry over to the
  full space.
- C1, nets F1, F2, lambda = 2: CONFIRMED (MOD p + ARG, at 32029 and 31981). On the set where orders 2..6 hold, the
  order-7 cokernel part is affine in k_2 with a rank-2 linear part; its constant term is outside that image (2
  non-zero annihilator values). Structure facts tested at sample points, not proved.
- Control, lambda = -1, net g, p = 32029: a jet through order 7 found and checked directly.
- C2: "no such jet passes order 7" is overstated for net s; for F1, F2 only MOD p with ARG. The slice result
  itself was not checked. Nothing here in characteristic 0. A 19-monomial + 7-direction slice cannot rule jets out
  at this order, because the s solutions use k_2 directions over all of the 94-dimensional solution set of order 5.

| Case | p | Result | Label |
|---|---|---|---|
| s, lambda = 2 | 32029 | jet through order 7, direct check [0,0,0,0,0,0,0] | MOD p (explicit jet) |
| s, lambda = 2 | 31981 | same | MOD p (explicit jet) |
| F1, F2, lambda = 2 | 32029 | Lambda rank 2; q(base) not in im Lambda; no T_2..T_7 | MOD p + ARG |
| F1, F2, lambda = 2 | 31981 | same | MOD p + ARG |
| g, lambda = -1 (control) | 32029 | jet through order 7, direct check | MOD p (explicit jet) |

Nothing here is, or bears on, a proof or disproof of the Hodge conjecture. Nothing comes from the user's memory.
