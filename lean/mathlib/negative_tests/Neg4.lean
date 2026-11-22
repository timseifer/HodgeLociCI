import Mathlib.LinearAlgebra.BilinearMap
import Mathlib.Tactic.Ring
import Mathlib.Tactic.LinearCombination

/-!
# The second-order law for modules, bilinear maps and submodules (Mathlib version)

Lean 4.36 + Mathlib (tag v4.36.0, built from source). No `sorry`, no `native_decide`, no new axioms.
Written by hand (main thread), 2026-11-21.

The same statements as `lean/SecondOrderLaw.lean` (Lean core, weaker assumptions), now phrased with Mathlib's
`Module`, bilinear maps `V →ₗ[R] V →ₗ[R] R` and `Submodule`, for readers who prefer the standard vocabulary.
Symmetry of the forms is not needed. Each proof ends with an explicit certificate (`linear_combination`):
the difference of the two sides is displayed as a combination of the hypotheses.

Dictionary, hypotheses and limits: exactly as in the header of `lean/SecondOrderLaw.lean`.
In short: `V` = S_d, `φ1 x y` = φ_1(Q·x·y), `φ2 x y` = φ_2(Q·x·y) for a fixed Q in K, `T1`, `T2` = the tangent
spaces of the two individual Hodge loci, `D` = N·det M, `lam0` = λ0, `mu` = 1/λ.
Hypotheses `key1`, `key2` (key lemma), `pencil` (from the liaison identity) and `hC1`–`hC3` (from the period
formula) are the geometric inputs; they are NOT proved here, and nothing geometric is.
-/

namespace SecondOrderLawModule

variable {R V : Type*} [CommRing R] [AddCommGroup V] [Module R V]

/-- The excess direction at λ: G_λ = G_1 − (1/λ)·G_2 with G_1 = D + λ0·G_2. -/
def Glam (lam0 mu : R) (D G2 : V) : V := D + lam0 • G2 - mu • G2

/-- The λ-independent second-order invariant A_0(N,N')(Q). -/
def A0 (φ1 φ2 : V →ₗ[R] V →ₗ[R] R) (lam0 : R) (D D' G2 G2' : V) : R :=
  φ1 (D + lam0 • G2) (D' + lam0 • G2') - φ2 (D + lam0 • G2) G2' - φ2 G2 (D' + lam0 • G2')

/-- The excess direction at λ is in the kernel of u_1 + λ u_2 whenever the abstract maps u_1, u_2 satisfy
u_2(G_1) = 0, u_1(G_2) = 0 and u_1(G_1) = u_2(G_2) (as in the paper: u_1(G_1) = ω_N = u_2(G_2)). -/
theorem Glam_mem_ker {W : Type*} [AddCommGroup W] [Module R W] (u1 u2 : V →ₗ[R] W)
    (lam0 : R) (D G2 : V) (h12 : u1 G2 = 0) (h21 : u2 (D + lam0 • G2) = 0)
    (hω : u1 (D + lam0 • G2) = u2 G2) (lam mu : R) (hlam : lam * mu = 1) :
    u1 (Glam lam0 mu D G2) + lam • u2 (Glam lam0 mu D G2) = 0 := by
  unfold Glam
  rw [map_sub, map_sub, map_smul u1 mu G2, map_smul u2 mu G2, h12, h21, hω, smul_zero, sub_zero, zero_sub,
    smul_neg, smul_smul, hlam, one_smul, add_neg_cancel]

theorem second_order_law (φ1 φ2 : V →ₗ[R] V →ₗ[R] R) (T1 T2 : Submodule R V)
    (key1 : ∀ x ∈ T1, ∀ y ∈ T1, φ1 x y = 0)
    (key2 : ∀ x ∈ T2, ∀ y ∈ T2, φ2 x y = 0)
    (lam0 : R) (h0 : lam0 * lam0 = 1)
    (D D' G2 G2' : V) (hG2 : G2 ∈ T1) (hG2' : G2' ∈ T1)
    (hG1 : D + lam0 • G2 ∈ T2) (hG1' : D' + lam0 • G2' ∈ T2)
    (pencil : φ1 D D' + lam0 * φ2 D D' = 0)
    (lam mu : R) (hlam : lam * mu = 1) :
    φ1 (Glam lam0 mu D G2) (Glam lam0 mu D' G2') + lam * φ2 (Glam lam0 mu D G2) (Glam lam0 mu D' G2')
      = (1 - lam0 * mu) * A0 φ1 φ2 lam0 D D' G2 G2' := by
  have k1 := key1 G2 hG2 G2' hG2'
  have k2 := key2 _ hG1 _ hG1'
  simp only [Glam, A0, map_add, map_sub, map_smul, LinearMap.add_apply, LinearMap.sub_apply,
    LinearMap.smul_apply, smul_eq_mul] at k2 ⊢
  linear_combination (mu * (lam0 ^ 3 - 2 * lam0 + mu)) * k1 
    + (lam - lam0 ^ 2 * mu) * k2
    + (mu * (φ1 D G2' + φ1 G2 D' + lam0 ^ 2 * φ2 G2 G2' + lam0 * φ2 D G2' + lam0 * φ2 G2 D' - φ2 G2 G2')) * h0
    + (-2 * lam0 * φ2 G2 G2' + mu * φ2 G2 G2' - φ2 D G2' - φ2 G2 D') * hlam

theorem formula_step (φ1 φ2 : V →ₗ[R] V →ₗ[R] R) (T1 T2 : Submodule R V)
    (key1 : ∀ x ∈ T1, ∀ y ∈ T1, φ1 x y = 0)
    (key2 : ∀ x ∈ T2, ∀ y ∈ T2, φ2 x y = 0)
    (lam0 : R) (h0 : lam0 * lam0 = 1)
    (D D' G2 G2' : V) (hG2 : G2 ∈ T1) (hG2' : G2' ∈ T1)
    (hG1 : D + lam0 • G2 ∈ T2) (hG1' : D' + lam0 • G2' ∈ T2)
    (pencil : φ1 D D' + lam0 * φ2 D D' = 0)
    (c kappa rho delta : R)
    (hC1 : c * (φ1 D G2' + lam0 * φ2 D G2') = lam0 * kappa * rho)
    (hC2 : c * (φ1 G2 D' + lam0 * φ2 G2 D') = lam0 * kappa * rho)
    (hC3 : c * φ2 D D' = -(lam0 * kappa * (rho + delta))) :
    c * A0 φ1 φ2 lam0 D D' G2 G2' = kappa * (rho - delta) := by
  have k1 := key1 G2 hG2 G2' hG2'
  have k2 := key2 _ hG1 _ hG1'
  simp only [A0, map_add, map_smul, LinearMap.add_apply, LinearMap.smul_apply, smul_eq_mul] at k2 ⊢
  linear_combination c * pencil + lam0 * hC1 + lam0 * hC2 + (lam0 * lam0 * c) * k1
    + (2 * kappa * rho - c * φ2 D G2' - c * φ2 G2 D'
        + 2 * c * (φ2 D G2' + φ2 G2 D' + lam0 * φ2 G2 G2') - kappa * (rho + delta)) * h0
    - (2 * c * lam0) * k2 + lam0 * hC3

theorem law_with_formula (φ1 φ2 : V →ₗ[R] V →ₗ[R] R) (T1 T2 : Submodule R V)
    (key1 : ∀ x ∈ T1, ∀ y ∈ T1, φ1 x y = 0)
    (key2 : ∀ x ∈ T2, ∀ y ∈ T2, φ2 x y = 0)
    (lam0 : R) (h0 : lam0 * lam0 = 1)
    (D D' G2 G2' : V) (hG2 : G2 ∈ T1) (hG2' : G2' ∈ T1)
    (hG1 : D + lam0 • G2 ∈ T2) (hG1' : D' + lam0 • G2' ∈ T2)
    (pencil : φ1 D D' + lam0 * φ2 D D' = 0)
    (c kappa rho delta : R)
    (hC1 : c * (φ1 D G2' + lam0 * φ2 D G2') = lam0 * kappa * rho)
    (hC2 : c * (φ1 G2 D' + lam0 * φ2 G2 D') = lam0 * kappa * rho)
    (hC3 : c * φ2 D D' = -(lam0 * kappa * (rho + delta)))
    (lam mu : R) (hlam : lam * mu = 1) :
    c * (φ1 (Glam lam0 mu D G2) (Glam lam0 mu D' G2')
        + lam * φ2 (Glam lam0 mu D G2) (Glam lam0 mu D' G2'))
      = (1 - lam0 * mu) * (kappa * (rho - delta)) := by
  rw [second_order_law φ1 φ2 T1 T2 key1 key2 lam0 h0 D D' G2 G2' hG2 hG2' hG1 hG1' pencil lam mu hlam,
    ← formula_step φ1 φ2 T1 T2 key1 key2 lam0 h0 D D' G2 G2' hG2 hG2' hG1 hG1' pencil c kappa rho delta
      hC1 hC2 hC3]
  ring

/-- Consequence used for non-reducedness: over a field, if the invariant A_0(N,N) is non-zero and
λ ≠ λ0 (λ ≠ 0), then the second-order term at λ does not vanish on the excess direction. -/
theorem second_order_ne_zero {k W : Type*} [Field k] [AddCommGroup W] [Module k W]
    (φ1 φ2 : W →ₗ[k] W →ₗ[k] k) (T1 T2 : Submodule k W)
    (key1 : ∀ x ∈ T1, ∀ y ∈ T1, φ1 x y = 0)
    (key2 : ∀ x ∈ T2, ∀ y ∈ T2, φ2 x y = 0)
    (lam0 : k) (h0 : lam0 * lam0 = 1)
    (D G2 : W) (hG2 : G2 ∈ T1) (hG1 : D + lam0 • G2 ∈ T2)
    (pencil : φ1 D D + lam0 * φ2 D D = 0)
    (hA : A0 φ1 φ2 lam0 D D G2 G2 ≠ 0)
    (lam : k) (hlam0 : lam ≠ 0) (hne : lam ≠ lam0) :
    φ1 (Glam lam0 lam⁻¹ D G2) (Glam lam0 lam⁻¹ D G2)
      + lam * φ2 (Glam lam0 lam⁻¹ D G2) (Glam lam0 lam⁻¹ D G2) ≠ 0 := by
  rw [second_order_law φ1 φ2 T1 T2 key1 key2 lam0 h0 D D G2 G2 hG2 hG2 hG1 hG1 pencil lam lam⁻¹
    (mul_inv_cancel₀ hlam0)]
  refine mul_ne_zero ?_ hA
  intro h
  apply hne
  have h1 : lam0 * lam⁻¹ = 1 := by linear_combination -h
  have h2 : lam0 = lam := by
    have := congrArg (fun t => t * lam) h1
    simpa [mul_assoc, inv_mul_cancel₀ hlam0] using this
  exact h2.symm

end SecondOrderLawModule

#print axioms SecondOrderLawModule.Glam_mem_ker
#print axioms SecondOrderLawModule.second_order_law
#print axioms SecondOrderLawModule.formula_step
#print axioms SecondOrderLawModule.law_with_formula
#print axioms SecondOrderLawModule.second_order_ne_zero
