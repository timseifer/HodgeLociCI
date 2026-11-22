import Mathlib.LinearAlgebra.Matrix.Adjugate

/-!
# The algebra behind the special coefficient λ0 = (−1)^(c−1), for every c

Lean 4.36 + Mathlib (tag v4.36.0, built from source). No `sorry`, no `native_decide`, no new axioms.
Written by hand (main thread), 2026-11-21.

This file formalises the first sentence of Lemma 3.5 of night/paper3/paper3.tex and the elementary matrix
algebra used in Theorem 1, for a square matrix `M` of ANY size `c = Fintype.card n` over ANY commutative ring.

## Dictionary (paper → this file)

* `S` = the polynomial ring; `n` = the index set of the `c` own equations; `κ` = the index set of the remaining
  members of the sequences (the shared equations `p` and their partners `s`), collected in `w : κ → S`.
* `f h : n → S`, `M : Matrix n n S`; `g = M *ᵥ h`, `q = Mᵀ *ᵥ f`.
* `seq f h w` = the sequence (f, h, w); `seq f (M *ᵥ h) w` = Φ¹; `seq h (Mᵀ *ᵥ f) w` = Φ².
  (The paper orders them (f, p; h, s). The same reordering is applied to all three sequences. That it does not
  change the relative signs is NOT formalised here.)
* `Res Φ m` = the residue symbol Res_S[m / Φ], an arbitrary additive function of `m` with values in an arbitrary
  abelian group; `Reg Φ` = "the symbol is defined for Φ" (in the paper: Φ is a regular sequence of forms).

## Hypothesis = the analytic/algebraic input (NOT proved here)

* `law`: the transformation law (R) for residue symbols: if Φ and A·Φ are both regular, then
  Res[det A · m / A·Φ] = Res[m / Φ]. In the paper this is quoted from the literature.

## What is proved

* `F_two_ways`: fᵀ(Mh) = (Mᵀf)ᵀh, i.e. F = Σ f_i g_i = Σ q_j h_j.
* `cramer_h`, `cramer_f` (and the entrywise forms): det M · h = adj(M)·g and det M · f = adj(Mᵀ)·q; so
  det M · h_j ∈ (g) and det M · f_i ∈ (q).
* `det_T1`, `det_T2`: the transition matrices from (f, h, w) to Φ¹ and Φ² have determinants det M and
  (−1)^c · det M.
* `residue_Phi1`, `residue_Phi2`: Res[m·det M/Φ¹] = Res[m/(f,h,w)] and Res[m·det M/Φ²] = (−1)^c · Res[m/(f,h,w)].
* `special_coefficient`: Res[m·det M/Φ¹] + (−1)^(c+1) · Res[m·det M/Φ²] = 0. Since (−1)^(c+1) = (−1)^(c−1) = λ0,
  this is the reason why λ0 is the coefficient at which the two period functionals cancel on det M.

## What is NOT proved here

That residue symbols exist and satisfy `law`; that the sequences are regular; the period formula relating
residues to periods of the cycles; and every geometric statement of the paper.
-/

namespace SpecialCoefficient
open Matrix

variable {S : Type*} [CommRing S] {n : Type*} [Fintype n] [DecidableEq n]

omit [DecidableEq n] in
/-- F = fᵀ M h computed in two ways: Σ f_i g_i = Σ q_j h_j with g = M h, q = Mᵀ f. -/
theorem F_two_ways (M : Matrix n n S) (f h : n → S) :
    f ⬝ᵥ (M *ᵥ h) = (Mᵀ *ᵥ f) ⬝ᵥ h := by
  rw [mulVec_transpose, dotProduct_mulVec]

/-- Cramer's rule: adj(M)·(M h) = det M · h. -/
theorem cramer_h (M : Matrix n n S) (h : n → S) :
    M.adjugate *ᵥ (M *ᵥ h) = M.det • h := by
  rw [mulVec_mulVec, adjugate_mul, smul_mulVec, one_mulVec]

/-- Cramer's rule for the transpose: adj(Mᵀ)·(Mᵀ f) = det M · f. -/
theorem cramer_f (M : Matrix n n S) (f : n → S) :
    Mᵀ.adjugate *ᵥ (Mᵀ *ᵥ f) = M.det • f := by
  rw [cramer_h, det_transpose]

/-- Entrywise: det M · h_j is an explicit combination of the g_i. -/
theorem det_mul_h_mem (M : Matrix n n S) (h : n → S) (j : n) :
    M.det * h j = ∑ i, M.adjugate j i * (M *ᵥ h) i := by
  have := congrFun (cramer_h M h) j
  simpa [mulVec, dotProduct] using this.symm

/-- Entrywise: det M · f_i is an explicit combination of the q_j. -/
theorem det_mul_f_mem (M : Matrix n n S) (f : n → S) (i : n) :
    M.det * f i = ∑ j, Mᵀ.adjugate i j * (Mᵀ *ᵥ f) j := by
  have := congrFun (cramer_f M f) i
  simpa [mulVec, dotProduct] using this.symm

/-! ### The two transition matrices -/

variable {κ : Type*} [Fintype κ] [DecidableEq κ]

/-- The sequence (u, v, w). -/
def seq (u v : n → S) (w : κ → S) : (n ⊕ n) ⊕ κ → S := Sum.elim (Sum.elim u v) w

/-- (f, h, w) ↦ (f, M h, w). -/
def T1 (M : Matrix n n S) : Matrix ((n ⊕ n) ⊕ κ) ((n ⊕ n) ⊕ κ) S :=
  fromBlocks (fromBlocks 1 0 0 M) 0 0 1

/-- (f, h, w) ↦ (h, Mᵀ f, w). -/
def T2 (M : Matrix n n S) : Matrix ((n ⊕ n) ⊕ κ) ((n ⊕ n) ⊕ κ) S :=
  fromBlocks (fromBlocks 0 1 Mᵀ 0) 0 0 1

theorem T1_mulVec (M : Matrix n n S) (f h : n → S) (w : κ → S) :
    (T1 M : Matrix ((n ⊕ n) ⊕ κ) ((n ⊕ n) ⊕ κ) S) *ᵥ seq f h w = seq f (M *ᵥ h) w := by
  simp [T1, seq, fromBlocks_mulVec]

theorem T2_mulVec (M : Matrix n n S) (f h : n → S) (w : κ → S) :
    (T2 M : Matrix ((n ⊕ n) ⊕ κ) ((n ⊕ n) ⊕ κ) S) *ᵥ seq f h w = seq h (Mᵀ *ᵥ f) w := by
  simp [T2, seq, fromBlocks_mulVec]

theorem det_T1 (M : Matrix n n S) :
    (T1 M : Matrix ((n ⊕ n) ⊕ κ) ((n ⊕ n) ⊕ κ) S).det = M.det := by
  simp [T1, det_fromBlocks_zero₂₁]

/-- The determinant of the block matrix [[0, 1], [C, 0]] is (−1)^c · det C. -/
theorem det_swap_block (C : Matrix n n S) :
    (fromBlocks (0 : Matrix n n S) 1 C 0).det = (-1) ^ Fintype.card n * C.det := by
  have key : fromBlocks (1 : Matrix n n S) 0 (-C) 1 * (fromBlocks 0 1 C 0 * fromBlocks (1 : Matrix n n S) 0 1 1)
      = fromBlocks 1 1 0 (-C) := by
    simp [fromBlocks_multiply]
  have hdet := congrArg det key
  rw [det_mul, det_mul, det_fromBlocks_zero₁₂, det_fromBlocks_zero₁₂, det_fromBlocks_zero₂₁, det_neg] at hdet
  simpa using hdet

theorem det_T2 (M : Matrix n n S) :
    (T2 M : Matrix ((n ⊕ n) ⊕ κ) ((n ⊕ n) ⊕ κ) S).det = (-1) ^ Fintype.card n * M.det := by
  simp [T2, det_fromBlocks_zero₂₁, det_swap_block, det_transpose]

/-! ### Consequences of the transformation law -/

variable {Λ : Type*} [AddCommGroup Λ]

/-- Res[m·det M / Φ¹] = Res[m / (f,h,w)]. -/
theorem residue_Phi1
    (Res : ((n ⊕ n) ⊕ κ → S) → S →+ Λ) (Reg : ((n ⊕ n) ⊕ κ → S) → Prop)
    (law : ∀ (A : Matrix ((n ⊕ n) ⊕ κ) ((n ⊕ n) ⊕ κ) S) (Φ : (n ⊕ n) ⊕ κ → S) (m : S),
      Reg Φ → Reg (A *ᵥ Φ) → Res (A *ᵥ Φ) (A.det * m) = Res Φ m)
    (M : Matrix n n S) (f h : n → S) (w : κ → S)
    (h0 : Reg (seq f h w)) (h1 : Reg (seq f (M *ᵥ h) w)) (m : S) :
    Res (seq f (M *ᵥ h) w) (M.det * m) = Res (seq f h w) m := by
  have := law (T1 M) (seq f h w) m h0 (by rw [T1_mulVec]; exact h1)
  rwa [T1_mulVec, det_T1] at this

/-- Res[m·det M / Φ²] = (−1)^c · Res[m / (f,h,w)]. -/
theorem residue_Phi2
    (Res : ((n ⊕ n) ⊕ κ → S) → S →+ Λ) (Reg : ((n ⊕ n) ⊕ κ → S) → Prop)
    (law : ∀ (A : Matrix ((n ⊕ n) ⊕ κ) ((n ⊕ n) ⊕ κ) S) (Φ : (n ⊕ n) ⊕ κ → S) (m : S),
      Reg Φ → Reg (A *ᵥ Φ) → Res (A *ᵥ Φ) (A.det * m) = Res Φ m)
    (M : Matrix n n S) (f h : n → S) (w : κ → S)
    (h0 : Reg (seq f h w)) (h2 : Reg (seq h (Mᵀ *ᵥ f) w)) (m : S) :
    Res (seq h (Mᵀ *ᵥ f) w) (M.det * m) = (-1 : ℤ) ^ Fintype.card n • Res (seq f h w) m := by
  have key := law (T2 M) (seq f h w) m h0 (by rw [T2_mulVec]; exact h2)
  rw [T2_mulVec, det_T2] at key
  rcases Nat.even_or_odd (Fintype.card n) with he | ho
  · rw [he.neg_one_pow] at key ⊢
    simpa using key
  · rw [ho.neg_one_pow] at key ⊢
    rw [← key]
    simp

/-- The special coefficient: with λ0 = (−1)^(c+1) = (−1)^(c−1),
Res[m·det M / Φ¹] + λ0 · Res[m·det M / Φ²] = 0. -/
theorem special_coefficient
    (Res : ((n ⊕ n) ⊕ κ → S) → S →+ Λ) (Reg : ((n ⊕ n) ⊕ κ → S) → Prop)
    (law : ∀ (A : Matrix ((n ⊕ n) ⊕ κ) ((n ⊕ n) ⊕ κ) S) (Φ : (n ⊕ n) ⊕ κ → S) (m : S),
      Reg Φ → Reg (A *ᵥ Φ) → Res (A *ᵥ Φ) (A.det * m) = Res Φ m)
    (M : Matrix n n S) (f h : n → S) (w : κ → S)
    (h0 : Reg (seq f h w)) (h1 : Reg (seq f (M *ᵥ h) w)) (h2 : Reg (seq h (Mᵀ *ᵥ f) w)) (m : S) :
    Res (seq f (M *ᵥ h) w) (M.det * m)
      + (-1 : ℤ) ^ (Fintype.card n + 1) • Res (seq h (Mᵀ *ᵥ f) w) (M.det * m) = 0 := by
  rw [residue_Phi1 Res Reg law M f h w h0 h1 m, residue_Phi2 Res Reg law M f h w h0 h2 m]
  rcases Nat.even_or_odd (Fintype.card n) with he | ho
  · rw [he.neg_one_pow, he.add_one.neg_one_pow]; simp
  · rw [ho.neg_one_pow, ho.add_one.neg_one_pow]; simp

end SpecialCoefficient

#print axioms SpecialCoefficient.F_two_ways
#print axioms SpecialCoefficient.det_mul_h_mem
#print axioms SpecialCoefficient.det_mul_f_mem
#print axioms SpecialCoefficient.det_T1
#print axioms SpecialCoefficient.det_T2
#print axioms SpecialCoefficient.residue_Phi1
#print axioms SpecialCoefficient.residue_Phi2
#print axioms SpecialCoefficient.special_coefficient
