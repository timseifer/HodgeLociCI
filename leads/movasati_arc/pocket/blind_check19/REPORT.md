# Blind check 19: self-intersections of smooth 4-folds in a cubic eightfold X ⊂ P^9

## Method
Macaulay2 + Schubert2 (script `check.m2`, output `run.log`). Each Z is realized as the zero locus of a
section of a split bundle E on an ambient abstract variety A built with Schubert2:
- CIs: `abstractProjectiveSpace n`, E = sum O(d_i) for nonlinear degrees.
- Segre products P1xP3, P2xP2: `projectiveBundle'(OO^(r+1))` over a projective space, H = h1 + h2.
- P1xQ3: P1-bundle (trivial) over P4, E = O(2) pulled back from P4, H = h_P1 + h_P4.
- dP5 4-fold: `flagBundle({2,3})` = G(2,5), H = c1(quotient) (deg G(2,5) = 5 checked), E = O(1)^2.
- Scrolls: `projectiveBundle'(O(a1)+...+O(a4))` over P1, H = c1 of the tautological rank-1 quotient
  (degree = sum a_i checked: 5, 6, 6).
Then c(T_Z) = c(T_A)/c(E) (Schubert2 `tangentBundle`), c(N) = (1+H)^10 (1+3H)^-1 / c(T_Z),
Z.Z = ∫_A c_4(N)·c_top(E), deg = ∫_A H^4·c_top(E), disc = 3 Z.Z − deg^2.

## Output (run.log)
| # | Z | deg | Z.Z | disc | claimed Z.Z / disc | verdict |
|---|---|---|---|---|---|---|
| 1 | P^4 | 1 | 11 | 32 | 11 / 32 | CONFIRMED |
| 2 | quadric 4-fold | 2 | 12 | 32 | 12 / 32 | CONFIRMED |
| 3 | CI(1,1,1,2,2) | 4 | 16 | 32 | 16 / 32 | CONFIRMED |
| 4 | CI(1,1,2,2,2) | 8 | 32 | 32 | 32 / 32 | CONFIRMED |
| 5 | P1xP3 | 4 | 24 | 56 | 24 / 56 | CONFIRMED |
| 6 | P2xP2 | 6 | 36 | 72 | 36 / 72 | CONFIRMED |
| 7 | P1xQ3 | 8 | 50 | 86 | 50 / 86 | CONFIRMED |
| 8 | dP5 (G(2,5)∩H^2) | 5 | 27 | 56 | 27 / 56 | CONFIRMED |
| 9a | S(1,1,1,2) | 5 | 31 | 68 | 31 / 68 | CONFIRMED |
| 9b | S(1,1,2,2) | 6 | 38 | 78 | 38 / 78 | CONFIRMED |
| 9c | S(1,1,1,3) | 6 | 38 | 78 | 38 / 78 | CONFIRMED |

## Hand checks (lattice with P1.P1 = P2.P2 = 11, P1.P2 = -1, h^4.Pi = 1, h^8 = 3)
- c = P1 + 2P2: c.c = 11 + 4(-1) + 4·11 = 51, deg = 3, disc = 153 − 9 = 144. CONFIRMED.
- c = P1 + P2 + h^4: c.c = 11 + 11 + 3 + 2(−1) + 2(1) + 2(1) = 27, deg = 5 (disc 56, same numerics as dP5). CONFIRMED.

## Verdict
All 11 geometric items and both lattice hand checks CONFIRMED.
