/-!
# The second-order law as an abstract theorem

Lean 4 core only: no Mathlib, no `native_decide`, no `sorry`. Written by hand (main thread), 2026-11-21.

Unlike the other files in this directory, this one does not check an identity between explicit polynomials.
It proves a statement with hypotheses, for an ARBITRARY commutative ring `R`, an arbitrary type `V` with an
addition and a scalar multiplication, arbitrary symmetric bilinear forms and arbitrary "subspaces" (predicates).
It is the algebraic deduction in the proofs of Theorem 3, Theorem 9.1(2),(3) and Theorem 9.4(1),(2) of
night/paper3/paper3.tex.

## Dictionary (paper → this file)

* `V` = S_d, the space of first-order deformations of the hypersurface; `R` = the complex numbers.
* For a fixed form Q in K: `φ1.f G G'` = φ_1(Q·G·G'), `φ2.f G G'` = φ_2(Q·G·G') (second-order period functionals
  of the two cycles). The second-order term of the Hodge locus of [Y_1] + λ[Y_2] is `φ1 + λ·φ2`.
* `T1`, `T2` = the tangent spaces T V_1, T V_2 of the two individual Hodge loci (only as predicates).
* `lam0` = λ0 = (−1)^(c−1), with `lam0 * lam0 = 1`; `lam`, `mu` with `lam * mu = 1` (mu = 1/λ).
* `D`, `D'` = N·det M, N'·det M (the excess directions at λ0); `G2`, `G2'` = G_2(N), G_2(N') ∈ T V_1, chosen so that
  `G1 := D + lam0•G2` and `G1' := D' + lam0•G2'` lie in T V_2. The excess direction at λ is
  `G1 − mu•G2 = D + lam0•G2 + (−mu)•G2`.

## Hypotheses = the geometric inputs (NOT proved here)

* `key1`, `key2` (the "key lemma"): φ_i(Q·G·G') = 0 for G, G' ∈ T V_i. In the paper this follows from: V_i is
  smooth with tangent space T V_i, and the period function of Q vanishes on V_i with zero differential.
* `pencil`: φ_1(Q·D·D') + λ0·φ_2(Q·D·D') = 0. In the paper this follows from the liaison identity (Theorem 1):
  all hypersurfaces F − N·det M lie in the Hodge locus of [Y_1] + λ0[Y_2].
* In `formula_step`: `hC1`, `hC2`, `hC3` are the three evaluations of Step C in the proof of Theorem 9.1(3)
  (obtained there from the differentiated period formula, the two displayed identities of Step A, and Lemma 3.5);
  `c` = k+1, `kappa` = the period constant κ, `rho` = ϱ(N·N'·tr(Ṁ adj M)), `delta` = 𝔇(N·N'·det M).

## What is proved

* `second_order_law`: (φ1 + λ·φ2)(G_λ(N), G_λ(N')) = (1 − λ0/λ)·A_0, where
  A_0 = φ1(G1,G1') − φ2(G1,G2') − φ2(G2,G1') does not involve λ. (Note 1 − λ0/λ = (λ − λ0)/λ.)
* `tangent_in_kernel`: for z ∈ T V_1 ∩ T V_2: (φ1 + λ·φ2)(z, G_λ(N')) = (φ1 + λ0·φ2)(z, D')
  (the displayed identity in the proof of Theorem 9.4(1)).
* `formula_step`: under the key lemma, `pencil` and the three evaluations of Step C: c·A_0 = kappa·(rho − delta)
  (Steps B and C of the proof of Theorem 9.1(3)).
* `law_with_formula`: both together: c·(φ1 + λ·φ2)(G_λ(N), G_λ(N')) = (1 − λ0/λ)·kappa·(rho − delta).

## What is NOT proved here

Everything geometric: that the hypotheses hold for Hodge loci (smoothness of V_i, the liaison identity, the
period formula and its derivative), that the Hessian of the Hodge locus is given by φ1 + λ·φ2, and every
consequence about (non-)reducedness. Those are ordinary mathematics in the paper, written by an AI and
refereed only by AI agents. `V` is not even assumed to satisfy the module axioms: only bilinearity of the
forms with respect to the given operations is used.
-/
namespace SecondOrderLaw
open Lean.Grind
set_option linter.unusedVariables false
set_option linter.unusedSimpArgs false

/-- A symmetric form on `V`, bilinear with respect to given operations `add`, `smul`. -/
structure SymBilin (R : Type) [CommRing R] (V : Type) (add : V → V → V) (smul : R → V → V) where
  f : V → V → R
  add_left : ∀ x y z, f (add x y) z = f x z + f y z
  smul_left : ∀ (a : R) x z, f (smul a x) z = a * f x z
  symm : ∀ x y, f x y = f y x

variable {R : Type} [CommRing R] {V : Type} {add : V → V → V} {smul : R → V → V}

theorem SymBilin.add_right (φ : SymBilin R V add smul) (x y z : V) :
    φ.f x (add y z) = φ.f x y + φ.f x z := by
  rw [φ.symm x (add y z), φ.add_left, φ.symm y x, φ.symm z x]

theorem SymBilin.smul_right (φ : SymBilin R V add smul) (a : R) (x z : V) :
    φ.f x (smul a z) = a * φ.f x z := by
  rw [φ.symm x (smul a z), φ.smul_left, φ.symm z x]

/-- The λ-independent second-order invariant A_0(N,N')(Q). -/
def A0 (φ1 φ2 : SymBilin R V add smul) (lam0 : R) (D D' G2 G2' : V) : R :=
  φ1.f (add D (smul lam0 G2)) (add D' (smul lam0 G2'))
    - φ2.f (add D (smul lam0 G2)) G2' - φ2.f G2 (add D' (smul lam0 G2'))

/-- The excess direction at λ: G_λ = G_1 − (1/λ)·G_2 with G_1 = D + λ0·G_2. -/
def Glam (add : V → V → V) (smul : R → V → V) (lam0 mu : R) (D G2 : V) : V :=
  add (add D (smul lam0 G2)) (smul (-mu) G2)

theorem eq_of_sub_eq_zero (x y : R) (h : x - y = 0) : x = y := by grind

theorem mul_swap (x y z : R) : x * (y * z) = y * (x * z) := by grind

/-- The formula step for ring elements: the difference of the two sides is written explicitly as a
combination of the hypotheses (`cert`, a polynomial identity), so nothing is left to proof search. -/
theorem formula_ring (a b c' e p q r s lam0 c kappa rho delta : R)
    (h0 : lam0 * lam0 = 1) (k1 : e = 0)
    (k2 : p + lam0 * q + (lam0 * r + lam0 * (lam0 * s)) = 0)
    (pencil : a + lam0 * p = 0)
    (hC1 : c * (b + lam0 * q) = lam0 * kappa * rho)
    (hC2 : c * (c' + lam0 * r) = lam0 * kappa * rho)
    (hC3 : c * p = -(lam0 * kappa * (rho + delta))) :
    c * (a + lam0 * b + (lam0 * c' + lam0 * (lam0 * e)) - (q + lam0 * s) - (r + lam0 * s))
      = kappa * (rho - delta) := by
  have cert :
      c * (a + lam0 * b + (lam0 * c' + lam0 * (lam0 * e)) - (q + lam0 * s) - (r + lam0 * s)) - kappa * (rho - delta)
      = c * (a + lam0 * p)
        + lam0 * (c * (b + lam0 * q) - lam0 * kappa * rho)
        + lam0 * (c * (c' + lam0 * r) - lam0 * kappa * rho)
        + lam0 * lam0 * c * e
        + (lam0 * lam0 - 1) * (2 * kappa * rho - c * q - c * r + 2 * c * (q + r + lam0 * s) - kappa * (rho + delta))
        - 2 * c * lam0 * (p + lam0 * q + (lam0 * r + lam0 * (lam0 * s)))
        + lam0 * (c * p + lam0 * kappa * (rho + delta)) := by grind
  have z : c * (a + lam0 * b + (lam0 * c' + lam0 * (lam0 * e)) - (q + lam0 * s) - (r + lam0 * s))
      - kappa * (rho - delta) = 0 := by
    rw [cert, pencil, hC1, hC2, hC3, k1, k2, h0]; grind
  exact eq_of_sub_eq_zero _ _ z

theorem second_order_law
    (φ1 φ2 : SymBilin R V add smul) (T1 T2 : V → Prop)
    (key1 : ∀ x y, T1 x → T1 y → φ1.f x y = 0)
    (key2 : ∀ x y, T2 x → T2 y → φ2.f x y = 0)
    (lam0 : R) (h0 : lam0 * lam0 = 1)
    (D D' G2 G2' : V) (hG2 : T1 G2) (hG2' : T1 G2')
    (hG1 : T2 (add D (smul lam0 G2))) (hG1' : T2 (add D' (smul lam0 G2')))
    (pencil : φ1.f D D' + lam0 * φ2.f D D' = 0)
    (lam mu : R) (hlam : lam * mu = 1) :
    φ1.f (Glam add smul lam0 mu D G2) (Glam add smul lam0 mu D' G2')
      + lam * φ2.f (Glam add smul lam0 mu D G2) (Glam add smul lam0 mu D' G2')
    = (1 + lam0 * mu) * A0 φ1 φ2 lam0 D D' G2 G2' := by
  have k1 := key1 G2 G2' hG2 hG2'
  have k2 := key2 _ _ hG1 hG1'
  unfold Glam A0
  simp only [SymBilin.add_left, SymBilin.add_right, SymBilin.smul_left, SymBilin.smul_right] at k2 ⊢
  grind

theorem tangent_in_kernel
    (φ1 φ2 : SymBilin R V add smul) (T1 T2 : V → Prop)
    (key1 : ∀ x y, T1 x → T1 y → φ1.f x y = 0)
    (key2 : ∀ x y, T2 x → T2 y → φ2.f x y = 0)
    (lam0 : R) (h0 : lam0 * lam0 = 1)
    (D' G2' z : V) (hz1 : T1 z) (hz2 : T2 z) (hG2' : T1 G2')
    (hG1' : T2 (add D' (smul lam0 G2')))
    (lam mu : R) (hlam : lam * mu = 1) :
    φ1.f z (Glam add smul lam0 mu D' G2') + lam * φ2.f z (Glam add smul lam0 mu D' G2')
    = φ1.f z D' + lam0 * φ2.f z D' := by
  have k1 := key1 z G2' hz1 hG2'
  have k2 := key2 z _ hz2 hG1'
  unfold Glam
  simp only [SymBilin.add_left, SymBilin.add_right, SymBilin.smul_left, SymBilin.smul_right] at k2 ⊢
  grind

theorem formula_step
    (φ1 φ2 : SymBilin R V add smul) (T1 T2 : V → Prop)
    (key1 : ∀ x y, T1 x → T1 y → φ1.f x y = 0)
    (key2 : ∀ x y, T2 x → T2 y → φ2.f x y = 0)
    (lam0 : R) (h0 : lam0 * lam0 = 1)
    (D D' G2 G2' : V) (hG2 : T1 G2) (hG2' : T1 G2')
    (hG1 : T2 (add D (smul lam0 G2))) (hG1' : T2 (add D' (smul lam0 G2')))
    (pencil : φ1.f D D' + lam0 * φ2.f D D' = 0)
    (c kappa rho delta : R)
    (hC1 : c * (φ1.f D G2' + lam0 * φ2.f D G2') = lam0 * kappa * rho)
    (hC2 : c * (φ1.f G2 D' + lam0 * φ2.f G2 D') = lam0 * kappa * rho)
    (hC3 : c * φ2.f D D' = -(lam0 * kappa * (rho + delta))) :
    c * A0 φ1 φ2 lam0 D D' G2 G2' = kappa * (rho - delta) := by
  have k1 := key1 G2 G2' hG2 hG2'
  have k2 := key2 _ _ hG1 hG1'
  unfold A0
  simp only [SymBilin.add_left, SymBilin.add_right, SymBilin.smul_left, SymBilin.smul_right] at k2 ⊢
  exact formula_ring _ _ _ _ _ _ _ _ lam0 c kappa rho delta h0 k1 k2 pencil hC1 hC2 hC3

theorem law_with_formula
    (φ1 φ2 : SymBilin R V add smul) (T1 T2 : V → Prop)
    (key1 : ∀ x y, T1 x → T1 y → φ1.f x y = 0)
    (key2 : ∀ x y, T2 x → T2 y → φ2.f x y = 0)
    (lam0 : R) (h0 : lam0 * lam0 = 1)
    (D D' G2 G2' : V) (hG2 : T1 G2) (hG2' : T1 G2')
    (hG1 : T2 (add D (smul lam0 G2))) (hG1' : T2 (add D' (smul lam0 G2')))
    (pencil : φ1.f D D' + lam0 * φ2.f D D' = 0)
    (c kappa rho delta : R)
    (hC1 : c * (φ1.f D G2' + lam0 * φ2.f D G2') = lam0 * kappa * rho)
    (hC2 : c * (φ1.f G2 D' + lam0 * φ2.f G2 D') = lam0 * kappa * rho)
    (hC3 : c * φ2.f D D' = -(lam0 * kappa * (rho + delta)))
    (lam mu : R) (hlam : lam * mu = 1) :
    c * (φ1.f (Glam add smul lam0 mu D G2) (Glam add smul lam0 mu D' G2')
      + lam * φ2.f (Glam add smul lam0 mu D G2) (Glam add smul lam0 mu D' G2'))
    = (1 - lam0 * mu) * (kappa * (rho - delta)) := by
  have hlaw := second_order_law φ1 φ2 T1 T2 key1 key2 lam0 h0 D D' G2 G2' hG2 hG2' hG1 hG1' pencil lam mu hlam
  have hform := formula_step φ1 φ2 T1 T2 key1 key2 lam0 h0 D D' G2 G2' hG2 hG2' hG1 hG1' pencil c kappa rho delta hC1 hC2 hC3
  rw [hlaw, ← hform]
  exact mul_swap _ _ _

/-! ## The hypotheses are satisfiable with `A0 ≠ 0`

A small model over the integers (`V = ℤ × ℤ`, `T1 = {x.2 = 0}`, `T2 = {x.1 = 0}`, `φ1 = x.2*y.2`, `φ2 = -(x.1*y.1)`,
`lam0 = 1`, `D = (-1, 1)`, `G2 = (1, 0)`) satisfies every hypothesis of `second_order_law` and has `A0 = 1`.
So the theorem is not vacuous. This says nothing about geometry. -/
section Model
def addZ (x y : Int × Int) : Int × Int := (x.1 + y.1, x.2 + y.2)
def smulZ (a : Int) (x : Int × Int) : Int × Int := (a * x.1, a * x.2)
def phi1 : SymBilin Int (Int × Int) addZ smulZ where
  f x y := x.2 * y.2
  add_left x y z := by simp only [addZ]; grind
  smul_left a x z := by simp only [smulZ]; grind
  symm x y := by grind
def phi2 : SymBilin Int (Int × Int) addZ smulZ where
  f x y := -(x.1 * y.1)
  add_left x y z := by simp only [addZ]; grind
  smul_left a x z := by simp only [smulZ]; grind
  symm x y := by grind

theorem model_hypotheses :
    (∀ x y : Int × Int, x.2 = 0 → y.2 = 0 → phi1.f x y = 0)
    ∧ (∀ x y : Int × Int, x.1 = 0 → y.1 = 0 → phi2.f x y = 0)
    ∧ ((1 : Int) * 1 = 1)
    ∧ ((1, 0) : Int × Int).2 = 0
    ∧ (addZ (-1, 1) (smulZ 1 (1, 0))).1 = 0
    ∧ phi1.f (-1, 1) (-1, 1) + 1 * phi2.f (-1, 1) (-1, 1) = 0 := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
  · intro x y hx hy; show x.2 * y.2 = 0; rw [hx]; exact Int.zero_mul _
  · intro x y hx hy; show -(x.1 * y.1) = 0; rw [hx, Int.zero_mul]; rfl
  · decide
  · decide
  · decide
  · decide

theorem model_A0 : A0 phi1 phi2 1 (-1, 1) (-1, 1) (1, 0) (1, 0) = 1 := by decide
end Model

end SecondOrderLaw

#print axioms SecondOrderLaw.second_order_law
#print axioms SecondOrderLaw.tangent_in_kernel
#print axioms SecondOrderLaw.formula_step
#print axioms SecondOrderLaw.law_with_formula
#print axioms SecondOrderLaw.model_hypotheses
#print axioms SecondOrderLaw.model_A0
