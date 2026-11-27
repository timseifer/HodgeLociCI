# Blind check 20: first-order correction of the order-8 jet at order 9 (MOD p, p = 31981, lambda = 2)

Status: AI-written, not reviewed by a human. All arithmetic MOD p (p = 31981), one prime, one jet.

## Inputs (shared definition)
- Jet T_1..T_8: `leads/movasati_arc/arcs/jet8_31981_s_lam2.txt` (all 8 lines; T_1 has 26 terms, T_2..T_8 squarefree cubics).
- Period functional: `blind_check14/own/own.py`, `Ctx(31981, z=12637)` (z^2 - z + 1 = 0 mod p, the value used by
  `c1.py`/`run_fs*.py`), table `ptable(Pspace(L1) + 2*Pspace(L2))`, method `periods`; `expseries` for E_n.
- c_n = periods(E_n), n E_n = sum_j j T_j E_{n-j}, T_9 = 0 for c_9.

## Own code (this folder)
- `phi.c`: C routine computing Phi_f(s) = Psi(x^s f) for all monomials s of a given degree D (Psi as in own.py:
  product of Pochhammer weights W times the P-table entry, zero when an exponent is 2 mod 3). D = 2 gives the 45
  periods; D = 5 gives Psi(q m f) for all quadrics q x cubic monomials m at once.
- `main.py`: driver. Derivative: since E = exp(sum eps^j T_j), dE_n = sum_{j=2..n} dT_j E_{n-j} (dT_1 = 0), so
  D c_n(dT) = sum_j A_{n-j} dT_j with A_k[q, m] = Psi(q * x^m * E_k) (45 x 220, all 220 cubic monomials).
  The full Jacobian J (rows: orders 2..9, 360; columns: dT_2..dT_8, T_9, 8 x 220 = 1760) is built EXACTLY from
  A_0..A_7, so no random sampling of directions was needed (exact image, no probabilistic rank bound).
- Independent control: the linearized recursion n dE_n = sum_j j (dT_j E_{n-j} + T_j dE_{n-j}) for one dense random
  direction (seed 20, dT_2..dT_9 random over all 220 cubic monomials), expanded to order 9 (dE_9: 9.57 M terms),
  periods taken with the C code.

## Outputs (run.log)
- Sizes of E_0..E_9: 1, 26, 375, 2983, 17188, 75320, 275727, 863765, 2418277, 6127127.
- Step 0: c_1 = ... = c_8 = 0 (all 45 components each), both with the C code and with own.py `periods`
  (they agree for n = 1..8). c_9 (T_9 = 0) has 43 nonzero components of 45 (vector saved in `c9.npy`).
- ranks of A_0..A_7: 19, 25, 43, 44, 45, 45, 45, 45 (A_0 = map T_9 -> c_9, rank 19).
- rank D c on orders 2..8: **165**; on orders 2..9: **195**.
- rank [J | (0,...,0,-c_9)] = **196** > 195: the system has NO solution.
- Same result with unknowns restricted to squarefree cubics: rank 195, augmented 196.
- Control: J v equals the linearized-recursion periods for the random direction on all orders 2..9 (True);
  order-1 derivative is 0.
- Control (a): rank [J | D c(v)] = 195 = rank J (solvable, as it must be).
- Time: whole run 131 s (2 cores); the 2.5 h budget was not an issue.

## Verdict: CONFIRMED (MOD p, p = 31981, this jet)
No (dT_2..dT_8, T_9) with dT_1 = 0 satisfies D c_n(dT) = 0 (n = 2..8) and D c_9(dT) + c_9 = 0.
Not established: anything over QQ or other primes, other jets on the same order-8 locus, or higher-order corrections
(e.g. second-order changes of the jet, or changing T_1).
