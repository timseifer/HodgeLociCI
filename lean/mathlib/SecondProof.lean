import Mathlib.LinearAlgebra.Matrix.Adjugate
import Mathlib.Tactic.LinearCombination

/-!
# A second proof of the pointwise formula and of "kappa is constant" (paper 3, Remark 10.3, "A second proof")

Lean 4.36 + Mathlib (tag v4.36.0, built from source). No `sorry`, no `native_decide`, no new axioms.
Written by hand (main thread), 2026-11-22. The argument is due to AI referee 23.

## What the paper says

Differentiating `pi = kappa * rho` along a family of data with first-order change `G` of `F` gives, for every form
`P` of degree `t`,

    (k+1) phi(P G) - kappa * R(P G) = - kappa' * rho(P),          R := sum over nu of the squared-pair symbols.

For `P` in the ideal `I = (phi, psi)` the right side vanishes, because `rho` kills `I` in degree `t`. Since the
products `P G` with `P` in `I_t` and `G` in `I_d` span `S_{t+d}`, the left side vanishes identically: this is the
pointwise formula. Applying the displayed identity once more, now with `P` outside `I`, gives `kappa' * rho(P) = 0`.

## Dictionary (paper -> this file)

* `S` = the polynomial ring, `R` = the ring of values; `phi`, `rho`, `Rsum : S →+ R` = the second-order
  functional, the residue symbol, and the sum of the squared-pair symbols (each extended additively to `S`).
* `D` = the set of directions (pairs `(alpha, beta)`); `G δ` = the first-order change of `F`; `kdot δ` = the
  derivative of `kappa` in the direction `δ`; `c` = `k+1`.
* `I : Set S` = the forms of degree `t` in the ideal `(phi, psi)`.

## Hypotheses = the inputs (NOT proved here)

* `hD`: the derivative relation displayed above, for every direction and every `P`.
* `hI`: `rho` vanishes on `I`.
* In `kdot_mul_rho_eq_zero`: `hspan`, that the product `P * G δ` lies in the additive span of the products
  `P' * G δ'` with `P'` in `I` (in the paper: both are all of `S_{t+d}`).

## What is proved

* `pointwise_on_span`: `c * phi x = kappa * Rsum x` for every `x` in the additive span of the products `P * G δ`,
  `P ∈ I`.
* `kdot_mul_rho_eq_zero`, `kdot_eq_zero`: `kdot δ * rho P = 0`, hence `kdot δ = 0` if `rho P ≠ 0` and `R` has no
  zero divisors.

## What is NOT proved here

The derivative relation (it needs the cited fact (G), the flatness of classes (A) and the transformation law
(R)); that `rho` kills the ideal; the spanning statement; and every geometric statement of the paper.
-/

namespace SecondProof

variable {S R : Type*} [CommRing S] [CommRing R] {D : Type*}

/-- The pointwise formula on the span of the products `P * G δ` with `P ∈ I`. -/
theorem pointwise_on_span (phi rho Rsum : S →+ R) (c kappa : R) (G : D → S) (kdot : D → R) (I : Set S)
    (hD : ∀ δ P, c * phi (P * G δ) - kappa * Rsum (P * G δ) = -(kdot δ * rho P))
    (hI : ∀ P ∈ I, rho P = 0) (x : S)
    (hx : x ∈ AddSubgroup.closure {x | ∃ δ P, P ∈ I ∧ x = P * G δ}) :
    c * phi x = kappa * Rsum x := by
  induction hx using AddSubgroup.closure_induction with
  | mem x hx =>
    obtain ⟨δ, P, hP, rfl⟩ := hx
    have h1 := hD δ P
    rw [hI P hP, mul_zero, neg_zero] at h1
    linear_combination h1
  | zero => simp
  | add x y _ _ hx hy =>
    simp only [map_add]
    linear_combination hx + hy
  | neg x _ hx =>
    simp only [map_neg]
    linear_combination -hx

/-- Constancy of kappa: `kdot δ * rho P = 0` for every `P` such that `P * G δ` lies in the span. -/
theorem kdot_mul_rho_eq_zero (phi rho Rsum : S →+ R) (c kappa : R) (G : D → S) (kdot : D → R) (I : Set S)
    (hD : ∀ δ P, c * phi (P * G δ) - kappa * Rsum (P * G δ) = -(kdot δ * rho P))
    (hI : ∀ P ∈ I, rho P = 0) (δ : D) (P : S)
    (hspan : P * G δ ∈ AddSubgroup.closure {x | ∃ δ' P', P' ∈ I ∧ x = P' * G δ'}) :
    kdot δ * rho P = 0 := by
  have h1 := pointwise_on_span phi rho Rsum c kappa G kdot I hD hI _ hspan
  have h2 := hD δ P
  linear_combination h2 - h1

/-- If moreover `rho P ≠ 0` and the ring of values has no zero divisors, then `kdot δ = 0`. -/
theorem kdot_eq_zero [NoZeroDivisors R] (phi rho Rsum : S →+ R) (c kappa : R) (G : D → S) (kdot : D → R)
    (I : Set S)
    (hD : ∀ δ P, c * phi (P * G δ) - kappa * Rsum (P * G δ) = -(kdot δ * rho P))
    (hI : ∀ P ∈ I, rho P = 0) (δ : D) (P : S)
    (hspan : P * G δ ∈ AddSubgroup.closure {x | ∃ δ' P', P' ∈ I ∧ x = P' * G δ'})
    (hρ : rho P ≠ 0) : kdot δ = 0 :=
  (mul_eq_zero.mp (kdot_mul_rho_eq_zero phi rho Rsum c kappa G kdot I hD hI δ P hspan)).resolve_right hρ

#print axioms pointwise_on_span
#print axioms kdot_mul_rho_eq_zero
#print axioms kdot_eq_zero

end SecondProof
