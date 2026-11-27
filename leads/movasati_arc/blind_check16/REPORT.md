# Blind check 16 — report (saved by the main session from the checker's hand-back; summary and table verbatim)

- C1: CONFIRMED (MOD p). Full-space test on net g (blind check 14 reduction). At p = 32029, lambda = 3 and 1/2 are
  obstructed at order 6; the same at p = 31981 and with a second random y_0 at 32029. lambda = 1 passes: explicit
  T_1..T_6 checked directly, all 6 x 45 coefficients zero, at both primes and both y_0. Also at 32029: -2, 4, 5/3,
  -1/2, -1/3 obstructed; control -1 passes.
- C2: CONFIRMED (EXACT + ARG). f(m) = c_m((1+h)^(m+1)/(1+3h)) = (1 - (-2)^(m+1))/3 derived independently (excess
  intersection); m = 4: 11, m = 1: -1. Determinant 32 r^2 - 8 r s + 32 s^2 correct; 28 only at +-(1,1), 36 only at
  +-(1,-1); bound 14 (r^2 + s^2) settles the rest; the eight other values in 9.8 correct.
- C3: SOUND, with conditions (ARG): per local branch of Sigma through X; Sigma pure-dimensional at X; both
  codimensions in the same ambient space; sign and monodromy harmless; "independent" follows from equal norm -48
  (and the span must be negative definite by Hodge-Riemann: a usable consistency test). Which alternative: OPEN.
- C4: one T_1 per lambda, integer powers of eps, MOD p; the link to K-trivial surfaces is a correlation at 2 of 10
  sampled values; "+1 passes with no correction at all" is wrong if read literally (with T_2 = ... = 0 the counts
  are [0, 36, 43, 45, ...]; what is true is that the order-5 and order-6 constraints vanish identically, Lin5 = 0,
  W = 0, so the forced parts of T_n suffice).

| lambda | p | y_0 | Order 5 | Order 6 | Label |
|---|---|---|---|---|---|
| 3 | 32029 | auth | Lin5 rank 7 (all from k_2); dim A = 397 | obstructed (annihilator value 855 at 10 points) | MOD p |
| 3 | 32029 | rnd7 | same | obstructed (13893) | MOD p |
| 3 | 31981 | auth | same | obstructed (10135) | MOD p |
| 1/2 | 32029 | auth | same | obstructed (10423) | MOD p |
| 1/2 | 32029 | rnd7 | same | obstructed (20795) | MOD p |
| 1/2 | 31981 | auth | same | obstructed (31347) | MOD p |
| 1 | 32029, 31981 | auth, rnd7 | Lin5 rank 0, dim A = 404 | explicit jet, direct check zero | MOD p |
| -2, 4, 5/3, -1/2, -1/3 | 32029 | auth | Lin5 rank 7 | obstructed | MOD p |
| -1 (control) | 32029 | auth | Lin5 rank 7 | explicit jet, direct check zero | MOD p |

None of this is, or bears on, a proof or disproof of the Hodge conjecture. Nothing came from the user's memory store.
