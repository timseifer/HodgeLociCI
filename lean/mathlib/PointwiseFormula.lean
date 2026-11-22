import Mathlib.LinearAlgebra.Matrix.Adjugate
import Mathlib.Tactic.LinearCombination

/-!
# The algebra of the pointwise second-order formula (paper 3, Remark 10.3)

Lean 4.36 + Mathlib (tag v4.36.0, built from source). No `sorry`, no `native_decide`, no new axioms.
Written by hand (main thread), 2026-11-21/22.

Remark 10.3 of night/paper3/paper3.tex states, for a complete intersection Y = V(φ_0..φ_k) in X = {F = 0},
F = Σ φ_ν ψ_ν:

    (k+1) · φ_Y(P) = κ · Σ_ν Res[ P / (Φ with φ_ν and ψ_ν both squared) ]          (10.1)

and deduces that κ does not vary with X. This file checks the ALGEBRA of that remark for arbitrary data.

## Dictionary (paper → this file)

* `S` = the polynomial ring; `R` = the complex numbers; `ι` = the index set {0..k}.
* `u ν`, `v ν` = φ_ν, ψ_ν.  `a`, `b` = first-order deformations of φ, ψ.
* `G u v a b` = Σ (a_ν ψ_ν + φ_ν b_ν) (first-order change of F), `H a b` = Σ a_ν b_ν (second-order change).
* `pi`, `phi` : S →+ R = the period functionals π_Y (pole order k+1) and φ_Y (pole order k+2), extended by zero
  outside their degree.  `rho` = Res[· / (φ;ψ)].  `rhoSq ν` = Res[· / (Φ with the pair ν squared)].
  `rhoU ν`, `rhoV ν` = Res[· / (Φ with only φ_ν squared)], Res[· / (Φ with only ψ_ν squared)].
* `c` = k+1, `kappa` = κ(X,Y), `kdot` = the derivative of κ along the deformation (a,b).

## Hypotheses = the inputs that are NOT proved here

* `hT` (from facts (G) and (A) of the paper): the ε²-coefficient of the vanishing period function along
  F_ε = Σ (φ_ν + ε a_ν)(ψ_ν + ε b_ν), in the form  c · φ(Q·G²) = 2 · π(Q·H).
  (`taylor_cancel` derives this form from the raw coefficient −k·π(QH) + (k(k+1)/2)·φ(QG²) = 0.)
* `hpi` (Lemma 2.1(1)): π = κ · ρ.
* `SqSymbols` (definition of residue symbols and the transformation law (R)): the symbol with the pair ν squared
  kills multiples of the other members and of φ_ν², ψ_ν², and satisfies Res_ν[m·φ_ν ψ_ν] = Res[m].
* `HalfSymbols` (transformation law): Res_ν[m·ψ_ν] = Res[m / (… φ_ν² …)], Res_ν[m·φ_ν] = Res[m / (… ψ_ν² …)].
* `hD` in `kappa_dot_zero` (fact (G) and the rule for the derivative of a residue symbol): the derivative of
  π = κ·Res along the deformation.
* In `pointwise_on_closure`: that the element one cares about lies in the additive span of the products
  Q·G·G' (in the paper: [(φ,ψ)²] is everything in degree t+d). This spanning statement is NOT proved here.

## What is proved

* `rhoSq_mul_GG`, `sum_rhoSq_GG`: Σ_ν Res_ν[Q·G·G'] = Res[Q·(H(a,b') + H(a',b))].
* `pointwise_sq`: (10.1) on the elements Q·G².
* `pointwise_bilinear`, `pointwise_bilinear'`: (10.1) on the elements Q·G·G' (polarisation).
* `pointwise_on_closure`: (10.1), times 2, on the additive span of those elements.
* `sum_rhoSq_PG`: Σ_ν Res_ν[P·G] = Σ_ν (Res[P a_ν / (… φ_ν² …)] + Res[P b_ν / (… ψ_ν² …)]).
* `kappa_dot_zero`, `kappa_dot_eq_zero`: from (10.1) at P·G and the derivative relation: κ' · Res[P] = 0, hence
  κ' = 0 when Res[P] ≠ 0.
* `Model`: a small polynomial model (k = 0: φ = x, ψ = y, Res = constant term, squared symbol = coefficient of
  xy) in which the hypotheses `SqSymbols` hold with a non-zero residue. So they are not contradictory.

## What is NOT proved here

Every hypothesis listed above; that residue symbols exist; the spanning statement; and every statement about
periods, cycles or Hodge loci. Remark 10.3 itself is AI-written and has not been refereed.
-/

namespace PointwiseFormula
open Finset

variable {S R : Type*} [CommRing S] [CommRing R] {ι : Type*} [Fintype ι] [DecidableEq ι]

/-- First-order change of F = Σ φ_ν ψ_ν under (φ, ψ) ↦ (φ + εa, ψ + εb). -/
def G (u v a b : ι → S) : S := ∑ ν, (a ν * v ν + u ν * b ν)

/-- Second-order change of F. -/
def H (a b : ι → S) : S := ∑ ν, a ν * b ν

/-- The part of `G` not involving the pair ν. -/
def rest (u v a b : ι → S) (ν : ι) : S := ∑ μ ∈ univ.erase ν, (a μ * v μ + u μ * b μ)

omit [DecidableEq ι] in
theorem G_add (u v a b a' b' : ι → S) :
    G u v (a + a') (b + b') = G u v a b + G u v a' b' := by
  unfold G
  rw [← Finset.sum_add_distrib]
  refine Finset.sum_congr rfl fun ν _ => ?_
  simp only [Pi.add_apply]; ring

omit [DecidableEq ι] in
theorem H_add (a b a' b' : ι → S) :
    H (a + a') (b + b') = H a b + (H a b' + H a' b) + H a' b' := by
  unfold H
  simp only [← Finset.sum_add_distrib]
  refine Finset.sum_congr rfl fun ν _ => ?_
  simp only [Pi.add_apply]; ring

theorem G_split (u v a b : ι → S) (ν : ι) :
    G u v a b = (a ν * v ν + u ν * b ν) + rest u v a b ν := by
  unfold G rest
  exact (Finset.add_sum_erase univ (fun μ => a μ * v μ + u μ * b μ) (mem_univ ν)).symm

/-- What is used of the residue symbols in which one pair is squared. -/
structure SqSymbols (u v : ι → S) (rho : S →+ R) (rhoSq : ι → S →+ R) : Prop where
  kill_u : ∀ ν μ, μ ≠ ν → ∀ m, rhoSq ν (m * u μ) = 0
  kill_v : ∀ ν μ, μ ≠ ν → ∀ m, rhoSq ν (m * v μ) = 0
  kill_uu : ∀ ν m, rhoSq ν (m * (u ν * u ν)) = 0
  kill_vv : ∀ ν m, rhoSq ν (m * (v ν * v ν)) = 0
  trans : ∀ ν m, rhoSq ν (m * (u ν * v ν)) = rho m

/-- Transformation law between the symbol with a pair squared and those with one member squared. -/
structure HalfSymbols (u v : ι → S) (rhoSq rhoU rhoV : ι → S →+ R) : Prop where
  tU : ∀ ν m, rhoSq ν (m * v ν) = rhoU ν m
  tV : ∀ ν m, rhoSq ν (m * u ν) = rhoV ν m

section Main
variable {u v : ι → S} {rho : S →+ R} {rhoSq : ι → S →+ R}

theorem rhoSq_rest (h : SqSymbols u v rho rhoSq) (a b : ι → S) (ν : ι) (m : S) :
    rhoSq ν (m * rest u v a b ν) = 0 := by
  unfold rest
  rw [Finset.mul_sum, map_sum]
  refine Finset.sum_eq_zero fun μ hμ => ?_
  have hne : μ ≠ ν := Finset.ne_of_mem_erase hμ
  have e : m * (a μ * v μ + u μ * b μ) = (m * a μ) * v μ + (m * b μ) * u μ := by ring
  rw [e, map_add, h.kill_v ν μ hne, h.kill_u ν μ hne, add_zero]

/-- Res_ν[Q·G·G'] = Res[Q·(a_ν b'_ν + a'_ν b_ν)]. -/
theorem rhoSq_mul_GG (h : SqSymbols u v rho rhoSq) (Q : S) (a b a' b' : ι → S) (ν : ι) :
    rhoSq ν (Q * (G u v a b * G u v a' b')) = rho (Q * (a ν * b' ν + a' ν * b ν)) := by
  have e : Q * (G u v a b * G u v a' b')
      = (Q * (a ν * a' ν)) * (v ν * v ν) + (Q * (a ν * b' ν + a' ν * b ν)) * (u ν * v ν)
        + (Q * (b ν * b' ν)) * (u ν * u ν)
        + (Q * (a ν * v ν + u ν * b ν)) * rest u v a' b' ν
        + (Q * G u v a' b') * rest u v a b ν := by
    conv_lhs => rw [G_split u v a b ν]
    conv_rhs => rw [G_split u v a' b' ν]
    conv_lhs => rw [G_split u v a' b' ν]
    ring
  rw [e]
  simp only [map_add]
  rw [h.kill_vv, h.trans, h.kill_uu, rhoSq_rest h, rhoSq_rest h]
  simp

/-- Σ_ν Res_ν[Q·G·G'] = Res[Q·(H(a,b') + H(a',b))]. -/
theorem sum_rhoSq_GG (h : SqSymbols u v rho rhoSq) (Q : S) (a b a' b' : ι → S) :
    ∑ ν, rhoSq ν (Q * (G u v a b * G u v a' b')) = rho (Q * (H a b' + H a' b)) := by
  simp only [rhoSq_mul_GG h]
  rw [← map_sum]
  congr 1
  unfold H
  rw [← Finset.sum_add_distrib, Finset.mul_sum]

/-- (10.1) on the elements Q·G². -/
theorem pointwise_sq (h : SqSymbols u v rho rhoSq) (pi phi : S →+ R) (kappa c : R)
    (hpi : ∀ m, pi m = kappa * rho m) (Q : S) (a b : ι → S)
    (hT : c * phi (Q * (G u v a b * G u v a b)) = 2 * pi (Q * H a b)) :
    c * phi (Q * (G u v a b * G u v a b))
      = kappa * ∑ ν, rhoSq ν (Q * (G u v a b * G u v a b)) := by
  rw [hT, sum_rhoSq_GG h, hpi, mul_add, map_add]
  ring

/-- (10.1) on the elements Q·G·G', up to the factor 2 of polarisation. -/
theorem pointwise_bilinear (h : SqSymbols u v rho rhoSq) (pi phi : S →+ R) (kappa c : R)
    (hpi : ∀ m, pi m = kappa * rho m) (Q : S) (a b a' b' : ι → S)
    (hT : c * phi (Q * (G u v a b * G u v a b)) = 2 * pi (Q * H a b))
    (hT' : c * phi (Q * (G u v a' b' * G u v a' b')) = 2 * pi (Q * H a' b'))
    (hTs : c * phi (Q * (G u v (a + a') (b + b') * G u v (a + a') (b + b')))
        = 2 * pi (Q * H (a + a') (b + b'))) :
    2 * (c * phi (Q * (G u v a b * G u v a' b')))
      = 2 * (kappa * ∑ ν, rhoSq ν (Q * (G u v a b * G u v a' b'))) := by
  rw [sum_rhoSq_GG h]
  rw [G_add, H_add] at hTs
  have e1 : Q * ((G u v a b + G u v a' b') * (G u v a b + G u v a' b'))
      = Q * (G u v a b * G u v a b)
        + (Q * (G u v a b * G u v a' b') + Q * (G u v a b * G u v a' b'))
        + Q * (G u v a' b' * G u v a' b') := by ring
  have e2 : Q * (H a b + (H a b' + H a' b) + H a' b')
      = Q * H a b + Q * (H a b' + H a' b) + Q * H a' b' := by ring
  rw [e1, e2] at hTs
  simp only [map_add, hpi] at hTs
  rw [hpi] at hT hT'
  linear_combination hTs - hT - hT'

/-- (10.1) on the elements Q·G·G' when 2 can be cancelled. -/
theorem pointwise_bilinear' [NoZeroDivisors R] (h2 : (2 : R) ≠ 0)
    (h : SqSymbols u v rho rhoSq) (pi phi : S →+ R) (kappa c : R)
    (hpi : ∀ m, pi m = kappa * rho m) (Q : S) (a b a' b' : ι → S)
    (hT : c * phi (Q * (G u v a b * G u v a b)) = 2 * pi (Q * H a b))
    (hT' : c * phi (Q * (G u v a' b' * G u v a' b')) = 2 * pi (Q * H a' b'))
    (hTs : c * phi (Q * (G u v (a + a') (b + b') * G u v (a + a') (b + b')))
        = 2 * pi (Q * H (a + a') (b + b'))) :
    c * phi (Q * (G u v a b * G u v a' b'))
      = kappa * ∑ ν, rhoSq ν (Q * (G u v a b * G u v a' b')) :=
  mul_left_cancel₀ h2 (pointwise_bilinear h pi phi kappa c hpi Q a b a' b' hT hT' hTs)

/-- (10.1), times 2, on the additive span of the elements Q·G·G' with admissible (Q,a,b), (Q,a',b').
`Adm` stands for "of the right degrees"; it only has to be closed under adding deformations. -/
theorem pointwise_on_closure (h : SqSymbols u v rho rhoSq) (pi phi : S →+ R) (kappa c : R)
    (hpi : ∀ m, pi m = kappa * rho m)
    (Adm : S → (ι → S) → (ι → S) → Prop)
    (hAdd : ∀ Q a b a' b', Adm Q a b → Adm Q a' b' → Adm Q (a + a') (b + b'))
    (hT : ∀ Q a b, Adm Q a b → c * phi (Q * (G u v a b * G u v a b)) = 2 * pi (Q * H a b))
    (x : S)
    (hx : x ∈ AddSubgroup.closure
      {x | ∃ Q a b a' b', Adm Q a b ∧ Adm Q a' b' ∧ x = Q * (G u v a b * G u v a' b')}) :
    2 * (c * phi x) = 2 * (kappa * ∑ ν, rhoSq ν x) := by
  induction hx using AddSubgroup.closure_induction with
  | mem x hx =>
    obtain ⟨Q, a, b, a', b', h1, h2, rfl⟩ := hx
    exact pointwise_bilinear h pi phi kappa c hpi Q a b a' b' (hT _ _ _ h1) (hT _ _ _ h2)
      (hT _ _ _ (hAdd _ _ _ _ _ h1 h2))
  | zero => simp
  | add x y _ _ hx hy =>
    simp only [map_add, Finset.sum_add_distrib]
    linear_combination hx + hy
  | neg x _ hx =>
    simp only [map_neg, Finset.sum_neg_distrib]
    linear_combination -hx

/-- Σ_ν Res_ν[P·G] = Σ_ν (Res[P a_ν/(… φ_ν² …)] + Res[P b_ν/(… ψ_ν² …)]). -/
theorem sum_rhoSq_PG (h : SqSymbols u v rho rhoSq) (rhoU rhoV : ι → S →+ R)
    (hh : HalfSymbols u v rhoSq rhoU rhoV) (P : S) (a b : ι → S) :
    ∑ ν, rhoSq ν (P * G u v a b) = ∑ ν, (rhoU ν (P * a ν) + rhoV ν (P * b ν)) := by
  refine Finset.sum_congr rfl fun ν _ => ?_
  have e : P * G u v a b = (P * a ν) * v ν + (P * b ν) * u ν + P * rest u v a b ν := by
    conv_lhs => rw [G_split u v a b ν]
    ring
  rw [e, map_add, map_add, hh.tU, hh.tV, rhoSq_rest h, add_zero]

/-- Constancy of κ: the pointwise formula at P·G and the derivative of π = κ·Res give κ'·Res[P] = 0. -/
theorem kappa_dot_zero (h : SqSymbols u v rho rhoSq) (rhoU rhoV : ι → S →+ R)
    (hh : HalfSymbols u v rhoSq rhoU rhoV) (phi : S →+ R) (kappa kdot c : R) (P : S) (a b : ι → S)
    (hPW : c * phi (P * G u v a b) = kappa * ∑ ν, rhoSq ν (P * G u v a b))
    (hD : -(c * phi (P * G u v a b))
        = kdot * rho P - kappa * ∑ ν, (rhoU ν (P * a ν) + rhoV ν (P * b ν))) :
    kdot * rho P = 0 := by
  rw [sum_rhoSq_PG h rhoU rhoV hh] at hPW
  linear_combination -hD - hPW

theorem kappa_dot_eq_zero [NoZeroDivisors R] (h : SqSymbols u v rho rhoSq) (rhoU rhoV : ι → S →+ R)
    (hh : HalfSymbols u v rhoSq rhoU rhoV) (phi : S →+ R) (kappa kdot c : R) (P : S) (a b : ι → S)
    (hPW : c * phi (P * G u v a b) = kappa * ∑ ν, rhoSq ν (P * G u v a b))
    (hD : -(c * phi (P * G u v a b))
        = kdot * rho P - kappa * ∑ ν, (rhoU ν (P * a ν) + rhoV ν (P * b ν)))
    (hρ : rho P ≠ 0) : kdot = 0 :=
  (mul_eq_zero.mp (kappa_dot_zero h rhoU rhoV hh phi kappa kdot c P a b hPW hD)).resolve_right hρ

end Main

/-- From the raw ε²-coefficient (doubled, to avoid a division): −2k·π + k(k+1)·φ = 0 and k ≠ 0
give (k+1)·φ = 2·π. -/
theorem taylor_cancel [NoZeroDivisors R] (k : ℕ) (hk : (k : R) ≠ 0) (piv phiv : R)
    (hraw : -(2 * (k : R)) * piv + (k : R) * ((k : R) + 1) * phiv = 0) :
    ((k : R) + 1) * phiv = 2 * piv := by
  have h0 : (k : R) * (((k : R) + 1) * phiv - 2 * piv) = 0 := by linear_combination hraw
  rcases mul_eq_zero.mp h0 with h1 | h1
  · exact absurd h1 hk
  · linear_combination h1

/-! ## A model: the hypotheses on the squared symbols are satisfiable with a non-zero residue

`S = ℤ[x][y]`, one pair (k = 0): `φ = x`, `ψ = y`, `Res[· /(x,y)]` = constant term,
`Res[· /(x²,y²)]` = coefficient of `xy`. This says nothing about geometry. -/
section Model
open Polynomial

/-- Res[· /(x, y)]: the constant term. -/
noncomputable def rho0 : ℤ[X][X] →+ ℤ where
  toFun p := (p.coeff 0).coeff 0
  map_zero' := by simp
  map_add' p q := by simp

/-- Res[· /(x², y²)]: the coefficient of xy. -/
noncomputable def rhoSq0 : Unit → ℤ[X][X] →+ ℤ := fun _ =>
  { toFun := fun p => (p.coeff 1).coeff 1
    map_zero' := by simp
    map_add' := fun p q => by simp }

theorem model_sqSymbols :
    SqSymbols (fun _ : Unit => (C X : ℤ[X][X])) (fun _ : Unit => (X : ℤ[X][X])) rho0 rhoSq0 where
  kill_u ν μ hne := absurd (Subsingleton.elim μ ν) hne
  kill_v ν μ hne := absurd (Subsingleton.elim μ ν) hne
  kill_uu ν m := by
    show ((m * (C X * C X)).coeff 1).coeff 1 = 0
    rw [← C_mul, coeff_mul_C, ← pow_two, coeff_mul_X_pow']; simp
  kill_vv ν m := by
    show ((m * (X * X)).coeff 1).coeff 1 = 0
    rw [← pow_two, coeff_mul_X_pow']; simp
  trans ν m := by
    show ((m * (C X * X)).coeff 1).coeff 1 = (m.coeff 0).coeff 0
    rw [← mul_assoc, coeff_mul_X, coeff_mul_C, coeff_mul_X]

theorem model_rho_ne_zero : rho0 1 ≠ 0 := by
  show ((1 : ℤ[X][X]).coeff 0).coeff 0 ≠ 0
  simp

end Model

end PointwiseFormula

#print axioms PointwiseFormula.sum_rhoSq_GG
#print axioms PointwiseFormula.pointwise_sq
#print axioms PointwiseFormula.pointwise_bilinear
#print axioms PointwiseFormula.pointwise_bilinear'
#print axioms PointwiseFormula.pointwise_on_closure
#print axioms PointwiseFormula.sum_rhoSq_PG
#print axioms PointwiseFormula.kappa_dot_zero
#print axioms PointwiseFormula.kappa_dot_eq_zero
#print axioms PointwiseFormula.taylor_cancel
#print axioms PointwiseFormula.model_sqSymbols
#print axioms PointwiseFormula.model_rho_ne_zero
