import Mathlib.LinearAlgebra.Matrix.Adjugate

/-!
# The matrix step of "the formula for every r" (paper 3, version 20, Proposition 9.4', step (ii))

Lean 4.36 + Mathlib (tag v4.36.0, built from source). No `sorry`, no `native_decide`, no new axioms.
Written by hand (main thread), 2026-11-22.

## What the paper says

For a virtual deformation whose only nonzero entry is one matrix entry `Mdot_ij = m`, one has
`Q = m f_i h_j`, `theta = m adj(M)_ji`, and the term `D` vanishes. Step (ii) of the proof shows

  sum_nu Res[ m f_i h_j B det M / Phi^1 with pair nu squared ] = Res[ m B adj(M)_ji / Phi^1 ],
  sum_nu Res[ m f_i h_j B det M / Phi^2 with pair nu squared ] = Res[ m B adj(M)_ji / Phi^2 ],

where `Phi^1 = (f, p; g, s)`, `g = M h`, and `Phi^2 = (h, p; q, s)`, `q = M^T f`. With the pointwise formula
(Lemma 2.1(3)) and the period formula (Lemma 2.1(1)) this gives the two identities (9.1) of the paper for such
a deformation. (This is the argument supplied by AI referee 24.)

## Dictionary (paper -> this file)

* `S` = the polynomial ring; `n` = the index set of the own equations; `κ` = the index set of the shared pairs
  `(p_l, s_l)`. The pairs of a sequence are indexed by `n ⊕ κ`.
* `rho x` = `Res[x / Phi]`; `rhoSq ν x` = `Res[x / Phi with the ν-th pair squared]`; both arbitrary additive maps
  with values in a commutative ring `R`.
* `PairSymbols u v rho rhoSq` = the three properties of these symbols that the proof uses, for a sequence whose
  own pairs are `(u_i, v_i)`:
  - `kill_u`, `kill_v`: a multiple of `u_i` or `v_i` has zero symbol modulo the sequence with ANOTHER pair
    squared (the member is in the ideal);
  - `trans`: `Res[x u_i v_i / Phi with pair i squared] = Res[x / Phi]` (one instance of the transformation law).

## Hypotheses = the inputs (NOT proved here)

`PairSymbols` for `Phi^1` (pairs `(f_i, g_i)`) and for `Phi^2` (pairs `(h_j, q_j)`); in `eqA2_matrix_entry` also
the pointwise formula `c * phi P = kappa * sum_nu rhoSq ν P` and the period formula `pi P = kappa * rho P`,
for each of the two cycles.

## What is proved

* `matrix_step_Phi1`, `matrix_step_Phi2`: the two displayed identities, for a matrix of any size over any
  commutative ring.
* `eqA2_matrix_entry`: the two identities (9.1) of the paper for a deformation with a single matrix entry:
  `c * phi_i (Q * B * det M) = pi_i (B * theta)` for `i = 1, 2`.

## What is NOT proved here

That residue symbols exist and have the three properties; the pointwise formula; the period formula; and
every geometric statement of the paper.
-/

namespace EveryR
open Matrix

variable {S : Type*} [CommRing S] {R : Type*} [CommRing R]
variable {n : Type*} [Fintype n] [DecidableEq n]
variable {κ : Type*} [Fintype κ]

/-- The properties of the symbols `Res[·/Phi]` and `Res[·/Phi with pair ν squared]` used in step (ii),
for a sequence whose own pairs are `(u i, v i)`, `i : n`. -/
structure PairSymbols (u v : n → S) (rho : S →+ R) (rhoSq : n ⊕ κ → S →+ R) : Prop where
  kill_u : ∀ (ν : n ⊕ κ) (i : n), ν ≠ Sum.inl i → ∀ x : S, rhoSq ν (x * u i) = 0
  kill_v : ∀ (ν : n ⊕ κ) (i : n), ν ≠ Sum.inl i → ∀ x : S, rhoSq ν (x * v i) = 0
  trans : ∀ (i : n) (x : S), rhoSq (Sum.inl i) (x * (u i * v i)) = rho x

omit [DecidableEq n] in
/-- A sum of terms `c i' * (u i * v i')` has total symbol `rho (c i)`. -/
theorem sum_symbols {u v : n → S} {rho : S →+ R} {rhoSq : n ⊕ κ → S →+ R}
    (hs : PairSymbols u v rho rhoSq) (i : n) (c : n → S) :
    ∑ ν, rhoSq ν (∑ i', c i' * (u i * v i')) = rho (c i) := by
  rw [Finset.sum_eq_single (Sum.inl i)]
  · rw [map_sum, Finset.sum_eq_single i]
    · exact hs.trans i (c i)
    · intro i' _ hne
      have h1 : c i' * (u i * v i') = (c i' * u i) * v i' := by ring
      rw [h1]
      exact hs.kill_v (Sum.inl i) i' (fun h => hne (Sum.inl.inj h).symm) _
    · intro h; exact absurd (Finset.mem_univ i) h
  · intro ν _ hν
    rw [map_sum]
    apply Finset.sum_eq_zero
    intro i' _
    have h1 : c i' * (u i * v i') = (c i' * v i') * u i := by ring
    rw [h1]
    exact hs.kill_u ν i hν _
  · intro h; exact absurd (Finset.mem_univ _) h

/-- Step (ii) for `Phi^1 = (f, p; g, s)`, `g = M h`. -/
theorem matrix_step_Phi1 (M : Matrix n n S) (f h : n → S) {rho : S →+ R} {rhoSq : n ⊕ κ → S →+ R}
    (hs : PairSymbols f (M *ᵥ h) rho rhoSq) (i j : n) (m B : S) :
    ∑ ν, rhoSq ν (m * (f i * h j) * B * M.det) = rho (m * B * M.adjugate j i) := by
  have cram : M.det * h j = ∑ i', M.adjugate j i' * (M *ᵥ h) i' := by
    have := congrFun (show M.adjugate *ᵥ (M *ᵥ h) = M.det • h by
      rw [mulVec_mulVec, adjugate_mul, smul_mulVec, one_mulVec]) j
    simpa [mulVec, dotProduct] using this.symm
  have key : m * (f i * h j) * B * M.det
      = ∑ i', (m * B * M.adjugate j i') * (f i * (M *ᵥ h) i') := by
    calc m * (f i * h j) * B * M.det = (m * B * f i) * (M.det * h j) := by ring
      _ = (m * B * f i) * ∑ i', M.adjugate j i' * (M *ᵥ h) i' := by rw [cram]
      _ = ∑ i', (m * B * M.adjugate j i') * (f i * (M *ᵥ h) i') := by
          rw [Finset.mul_sum]; apply Finset.sum_congr rfl; intro i' _; ring
  simp only [key]
  exact sum_symbols hs i (fun i' => m * B * M.adjugate j i')

/-- Step (ii) for `Phi^2 = (h, p; q, s)`, `q = M^T f`. The same entry `adj(M)_ji` appears. -/
theorem matrix_step_Phi2 (M : Matrix n n S) (f h : n → S) {rho : S →+ R} {rhoSq : n ⊕ κ → S →+ R}
    (hs : PairSymbols h (Mᵀ *ᵥ f) rho rhoSq) (i j : n) (m B : S) :
    ∑ ν, rhoSq ν (m * (f i * h j) * B * M.det) = rho (m * B * M.adjugate j i) := by
  have cram : M.det * f i = ∑ j', M.adjugate j' i * (Mᵀ *ᵥ f) j' := by
    have := congrFun (show Mᵀ.adjugate *ᵥ (Mᵀ *ᵥ f) = M.det • f by
      rw [mulVec_mulVec, adjugate_mul, smul_mulVec, one_mulVec, det_transpose]) i
    have hadj : ∀ a b, Mᵀ.adjugate a b = M.adjugate b a := by
      intro a b
      have h1 : Mᵀ.adjugate = M.adjugateᵀ := (adjugate_transpose M).symm
      rw [h1, transpose_apply]
    simpa [mulVec, dotProduct, hadj] using this.symm
  have key : m * (f i * h j) * B * M.det
      = ∑ j', (m * B * M.adjugate j' i) * (h j * (Mᵀ *ᵥ f) j') := by
    calc m * (f i * h j) * B * M.det = (m * B * h j) * (M.det * f i) := by ring
      _ = (m * B * h j) * ∑ j', M.adjugate j' i * (Mᵀ *ᵥ f) j' := by rw [cram]
      _ = ∑ j', (m * B * M.adjugate j' i) * (h j * (Mᵀ *ᵥ f) j') := by
          rw [Finset.mul_sum]; apply Finset.sum_congr rfl; intro j' _; ring
  simp only [key]
  exact sum_symbols hs j (fun j' => m * B * M.adjugate j' i)

/-- The two identities (9.1) of the paper for a virtual deformation with one matrix entry `Mdot_ij = m`:
`Q = m f_i h_j`, `theta = m adj(M)_ji`, `D = 0`. Hypotheses: the symbol properties, the pointwise formula
(`hpw`) and the period formula (`hper`) for each of the two cycles (each with its own constant). -/
theorem eqA2_matrix_entry (M : Matrix n n S) (f h : n → S)
    {rho1 rho2 : S →+ R} {rhoSq1 rhoSq2 : n ⊕ κ → S →+ R}
    (hs1 : PairSymbols f (M *ᵥ h) rho1 rhoSq1) (hs2 : PairSymbols h (Mᵀ *ᵥ f) rho2 rhoSq2)
    (phi1 phi2 pi1 pi2 : S → R) (c kappa1 kappa2 : R)
    (hpw1 : ∀ P, c * phi1 P = kappa1 * ∑ ν, rhoSq1 ν P) (hper1 : ∀ P, pi1 P = kappa1 * rho1 P)
    (hpw2 : ∀ P, c * phi2 P = kappa2 * ∑ ν, rhoSq2 ν P) (hper2 : ∀ P, pi2 P = kappa2 * rho2 P)
    (i j : n) (m B : S) :
    c * phi1 (m * (f i * h j) * B * M.det) = pi1 (B * (m * M.adjugate j i)) ∧
    c * phi2 (m * (f i * h j) * B * M.det) = pi2 (B * (m * M.adjugate j i)) := by
  have e : B * (m * M.adjugate j i) = m * B * M.adjugate j i := by ring
  constructor
  · rw [hpw1, hper1, matrix_step_Phi1 M f h hs1 i j m B, e]
  · rw [hpw2, hper2, matrix_step_Phi2 M f h hs2 i j m B, e]

#print axioms sum_symbols
#print axioms matrix_step_Phi1
#print axioms matrix_step_Phi2
#print axioms eqA2_matrix_entry

end EveryR
