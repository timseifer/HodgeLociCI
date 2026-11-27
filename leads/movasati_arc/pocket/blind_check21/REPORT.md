# Blind check 21 — verdict: CONFIRMED
Own code: run.py (output run.log). Weights/Psi follow own.py conventions; P_L = prod 3c(x_a + c x_b), c = z^e.
Functionals P -> Psi_P(Q E_m) built as 45x252 matrices per m (only monomials with all r_j in {0,1}, sum r = 5 contribute).
- dim H = 252 (rank of ~2318 random linear cycles, all 945 matchings x e in {1,3,5}^5 sampled 1%), both primes.
- dim Lambda_n, n=1..8: 207,162,117,72,27,1,1,1 at p=31981 and p=32029.
- Control: c = P_P1 + 2 P_P2 is nonzero and killed by all 360 functionals, so Lambda_8 = span(c).
- Negative control: random P gives 360/360 nonzero values.
